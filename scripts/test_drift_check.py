"""Tests for drift-check.py, run as the maintainer runs it: a subprocess.

    python -B -m unittest discover -s scripts
"""

import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

SCRIPT = Path(__file__).with_name("drift-check.py")
PLUGIN = SCRIPT.resolve().parent.parent / "plugins" / "matt-with-paseo"
STREAM_SKILL = PLUGIN / "skills" / "matt-with-paseo-streams"

SKILL_MD = """\
---
name: matt-with-paseo
---

## 0. Locate the state and suggest the next step

The user types `/mattpocock-skills:to-spec`.

## 4. Spawn

| The ticket describes | Flow |
|---|---|
| Behaviour that should exist | `/mattpocock-skills:tdd` |

## 5. Check each report

Read the `mattpocock-skills:code-review` result.
"""

TEMPLATE_MD = """\
## Done when
- Run `/mattpocock-skills:code-review` with your base commit as the fixed point.
"""


def write(path, text):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text, encoding="utf-8")


def make_plugin(root, skills):
    """skills: {name: user_only}. Writes a manifest listing each one."""
    manifest = {"name": "mattpocock-skills", "skills": []}
    for name, user_only in skills.items():
        flag = "disable-model-invocation: true\n" if user_only else ""
        write(root / "skills" / "engineering" / name / "SKILL.md",
              f"---\nname: {name}\ndescription: x\n{flag}---\n\n# {name}\n")
        manifest["skills"].append(f"./skills/engineering/{name}")
    write(root / ".claude-plugin" / "plugin.json", json.dumps(manifest))


def make_skill(root, skill_md=SKILL_MD, template_md=TEMPLATE_MD):
    write(root / "SKILL.md", skill_md)
    write(root / "COMMON-RULES-TEMPLATE.md", template_md)


class DriftCheck(unittest.TestCase):
    def setUp(self):
        tmp = tempfile.TemporaryDirectory()
        self.addCleanup(tmp.cleanup)
        self.tmp = Path(tmp.name)
        self.plugin = self.tmp / "plugin"
        self.skill = self.tmp / "skill"
        make_plugin(self.plugin, {"tdd": False, "code-review": False, "to-spec": True})

    def run_check(self, *targets, pass_plugin_root=True, env=None):
        args = [sys.executable, "-B", str(SCRIPT)]
        if pass_plugin_root:
            args += ["--plugin-root", str(self.plugin)]
        args += [str(t) for t in targets] or [str(self.skill)]
        return subprocess.run(args, capture_output=True, text=True, env=env)

    def fake_home(self, plugins):
        """A home directory whose Claude Code install record lists `plugins`."""
        home = self.tmp / "home"
        write(home / ".claude" / "plugins" / "installed_plugins.json",
              json.dumps({"version": 2, "plugins": plugins}))
        return dict(os.environ, HOME=str(home), USERPROFILE=str(home))

    def assert_one_mismatch(self, result, *fragments):
        self.assertEqual(result.returncode, 1, result.stderr)
        lines = result.stdout.splitlines()
        self.assertEqual(len(lines), 1, result.stdout)
        for fragment in fragments:
            self.assertIn(fragment, lines[0])

    def test_reports_a_reference_to_a_skill_that_does_not_exist(self):
        make_skill(self.skill, SKILL_MD + "\nThen `/mattpocock-skills:no-such-skill`.\n")

        result = self.run_check()

        self.assert_one_mismatch(
            result, "SKILL.md:19:", "mattpocock-skills:no-such-skill", "not in the installed plugin")

    def test_reports_a_user_only_skill_in_the_step_4_flow_table(self):
        planted = SKILL_MD.replace(
            "| Behaviour that should exist | `/mattpocock-skills:tdd` |",
            "| Behaviour that should exist | `/mattpocock-skills:tdd` |\n"
            "| A spec to write | `/mattpocock-skills:to-spec` |")
        make_skill(self.skill, planted)

        result = self.run_check()

        self.assert_one_mismatch(
            result, "SKILL.md:14:", "mattpocock-skills:to-spec", "disable-model-invocation")

    def test_reports_a_user_only_skill_anywhere_in_the_common_rules_template(self):
        make_skill(self.skill, template_md=TEMPLATE_MD + "- Then run `/mattpocock-skills:to-spec`.\n")

        result = self.run_check()

        self.assert_one_mismatch(result, "COMMON-RULES-TEMPLATE.md:3:", "disable-model-invocation")

    def test_accepts_a_user_only_skill_suggested_outside_the_agent_flow(self):
        make_skill(self.skill)  # step 0 suggests to-spec, which the user types

        result = self.run_check()

        self.assertEqual(result.stdout, "")
        self.assertEqual(result.returncode, 0)

    def test_ignores_the_placeholder_name_in_a_flow_rule(self):
        planted = SKILL_MD.replace(
            "## 5. Check each report",
            "Name each skill as `mattpocock-skills:<name>` and check its flag.\n\n## 5. Check each report")
        make_skill(self.skill, planted)

        result = self.run_check()

        self.assertEqual(result.stdout, "")
        self.assertEqual(result.returncode, 0)

    def test_reports_the_beta_loop_lens_named_bare(self):
        make_skill(self.skill, SKILL_MD + "\nDesign the loop as loop-me does.\n")

        result = self.run_check()

        self.assert_one_mismatch(result, "SKILL.md:19:", "loop-me", "without naming it")

    def test_reports_the_beta_loop_lens_named_as_a_matt_skill_once(self):
        make_skill(self.skill, SKILL_MD + "\nThen `/mattpocock-skills:loop-me`.\n")

        result = self.run_check()

        self.assert_one_mismatch(result, "SKILL.md:19:", "loop-me", "without naming it")

    def test_without_plugin_root_compares_against_the_user_scope_install(self):
        project_copy = self.tmp / "project-plugin"
        make_plugin(project_copy, {"tdd": False, "code-review": False, "to-spec": True, "extra": False})
        env = self.fake_home({
            "mattpocock-skills@claude-plugins-official": [
                {"scope": "project", "projectPath": "D:\\x", "installPath": str(project_copy)}],
            "mattpocock-skills@mattpocock": [
                {"scope": "user", "installPath": str(self.plugin)}],
        })
        make_skill(self.skill, SKILL_MD + "\nAnd `mattpocock-skills:extra`.\n")

        result = self.run_check(pass_plugin_root=False, env=env)

        self.assert_one_mismatch(result, "mattpocock-skills:extra", str(self.plugin))

    def test_fails_loudly_when_no_matt_plugin_is_installed(self):
        env = self.fake_home({"other@market": [{"scope": "user", "installPath": "x"}]})
        make_skill(self.skill)

        result = self.run_check(pass_plugin_root=False, env=env)

        self.assertEqual(result.returncode, 2)
        self.assertIn("mattpocock-skills", result.stderr)

    def test_without_targets_checks_the_standards_scope_and_both_readmes_of_this_repo(self):
        make_plugin(self.plugin, {})  # an empty plugin: every reference is stale

        result = subprocess.run(
            [sys.executable, "-B", str(SCRIPT), "--plugin-root", str(self.plugin)],
            capture_output=True, text=True)

        self.assertEqual(result.returncode, 1)
        paths = {re.match(r"(.*?):\d+: mattpocock-skills:", line).group(1)
                 for line in result.stdout.splitlines()}
        repo = SCRIPT.resolve().parent.parent
        self.assertIn(str(PLUGIN / "skills" / "matt-with-paseo" / "SKILL.md"), paths)
        self.assertIn(str(repo / "README.md"), paths)
        self.assertIn(str(PLUGIN / "README.md"), paths)
        self.assertIn(str(STREAM_SKILL / "SKILL.md"), paths)
        self.assertIn(str(repo / "CODING_STANDARDS.md"), paths)
        self.assertIn(str(PLUGIN / "evals" / "wave-pure-chain" / "graders" / "suggests-implement.md"), paths)

    def copy_stream_skill(self, *extra):
        """A copy of this repo's stream skill, and a plugin holding every Matt skill it names
        plus `extra`.

        Every one of those skills is user-only: the stream skill spawns only the wave skill,
        so no line of it is an agent flow and no flag may be reported."""
        copy = self.tmp / "matt-with-paseo-streams"
        shutil.copytree(STREAM_SKILL, copy)
        names = {name for path in copy.rglob("*.md")
                 for name in re.findall(r"mattpocock-skills:([a-z0-9][a-z0-9-]*)",
                                        path.read_text(encoding="utf-8"))}
        make_plugin(self.plugin, {name: True for name in names | set(extra)})
        return copy

    def plant_below_step_4(self, skill_md, line):
        """Insert `line` right below the '## 4.' heading; return its line number."""
        lines = skill_md.read_text(encoding="utf-8").splitlines()
        step_4 = next(n for n, text in enumerate(lines, 1) if text.startswith("## 4."))
        lines.insert(step_4, line)
        write(skill_md, "\n".join(lines) + "\n")
        return step_4 + 1

    def test_reports_exactly_the_bad_reference_planted_in_the_stream_skill(self):
        copy = self.copy_stream_skill()
        planted = self.plant_below_step_4(copy / "SKILL.md", "Then `/mattpocock-skills:no-such-skill`.")

        result = self.run_check(copy)

        self.assert_one_mismatch(
            result, f"SKILL.md:{planted}:", "mattpocock-skills:no-such-skill", "not in the installed plugin")

    def test_accepts_a_user_only_skill_in_step_4_of_the_stream_skill(self):
        copy = self.copy_stream_skill("to-spec")
        self.plant_below_step_4(copy / "SKILL.md", "The user types `/mattpocock-skills:to-spec`.")

        result = self.run_check(copy)

        self.assertEqual(result.stdout, "")
        self.assertEqual(result.returncode, 0)

    def test_fails_loudly_when_skill_md_has_no_step_4(self):
        make_skill(self.skill, SKILL_MD.replace("## 4. Spawn", "## Spawn"))

        result = self.run_check()

        self.assertEqual(result.returncode, 2)
        self.assertIn("## 4.", result.stderr)


PINNED_TABLE = SCRIPT.with_name("pinned-lines.json")
TROUBLESHOOTING = PLUGIN / "skills" / "matt-with-paseo" / "TROUBLESHOOTING.md"
STUCK_CALL = "a prompt only queues behind the stuck call"
STUCK_REASON = "bug 06: a cancel gets no acknowledgement"


class PinnedLines(unittest.TestCase):
    def setUp(self):
        tmp = tempfile.TemporaryDirectory()
        self.addCleanup(tmp.cleanup)
        self.tmp = Path(tmp.name)
        self.root = self.tmp / "repo"
        self.plugin = self.tmp / "plugin"
        self.table = self.tmp / "pinned.json"
        make_plugin(self.plugin, {"tdd": False})
        write(self.root / "skills" / "rules.md",
              f"Never cancel a hung agent: {STUCK_CALL}.\nAnother line.\n")
        self.pin({"file": "skills/rules.md", "phrase": STUCK_CALL, "reason": STUCK_REASON})

    def pin(self, *rows):
        write(self.table, json.dumps(list(rows)))

    def run_check(self, table=None):
        return subprocess.run(
            [sys.executable, "-B", str(SCRIPT), "--plugin-root", str(self.plugin),
             "--pinned", str(table or self.table), "--pinned-root", str(self.root),
             str(self.root / "skills")],
            capture_output=True, text=True)

    def test_accepts_a_table_whose_phrases_are_all_present(self):
        result = self.run_check()

        self.assertEqual(result.stdout, "")
        self.assertEqual(result.returncode, 0)

    def test_reports_a_removed_phrase_in_one_line_naming_the_file_and_the_reason(self):
        write(self.root / "skills" / "rules.md", "Never cancel a hung agent.\nAnother line.\n")

        result = self.run_check()

        self.assertEqual(result.returncode, 1, result.stderr)
        lines = result.stdout.splitlines()
        self.assertEqual(len(lines), 1, result.stdout)
        for fragment in ("rules.md", "pinned phrase missing", STUCK_CALL, STUCK_REASON):
            self.assertIn(fragment, lines[0])

    def test_reports_each_missing_phrase_on_its_own_line(self):
        self.pin({"file": "skills/rules.md", "phrase": STUCK_CALL, "reason": STUCK_REASON},
                 {"file": "skills/rules.md", "phrase": "an absent sentence", "reason": "reason two"},
                 {"file": "skills/rules.md", "phrase": "Another line", "reason": "reason three"},
                 {"file": "skills/rules.md", "phrase": "a second absent sentence", "reason": "reason four"})

        result = self.run_check()

        self.assertEqual(result.returncode, 1, result.stderr)
        lines = result.stdout.splitlines()
        self.assertEqual(len(lines), 2, result.stdout)
        self.assertIn("an absent sentence", lines[0])
        self.assertIn("reason two", lines[0])
        self.assertIn("a second absent sentence", lines[1])
        self.assertIn("reason four", lines[1])

    def test_a_phrase_split_over_two_lines_is_missing(self):
        write(self.root / "skills" / "rules.md", "Never cancel a hung agent: a prompt only\nqueues behind the stuck call.\n")

        result = self.run_check()

        self.assertEqual(result.returncode, 1, result.stderr)
        self.assertIn("pinned phrase missing", result.stdout)

    def test_reports_a_pinned_file_that_is_gone(self):
        (self.root / "skills" / "rules.md").rename(self.root / "skills" / "renamed.md")

        result = self.run_check()

        self.assertEqual(result.returncode, 1, result.stderr)
        lines = result.stdout.splitlines()
        self.assertEqual(len(lines), 1, result.stdout)
        for fragment in ("rules.md", "pinned file missing", STUCK_REASON):
            self.assertIn(fragment, lines[0])

    def test_fails_loudly_when_the_table_does_not_exist(self):
        result = self.run_check(table=self.tmp / "no-such-table.json")

        self.assertEqual(result.returncode, 2)
        self.assertEqual(result.stdout, "")
        self.assertIn("no-such-table.json", result.stderr)

    def test_fails_loudly_when_the_table_is_not_json(self):
        write(self.table, "file | phrase | reason")

        result = self.run_check()

        self.assertEqual(result.returncode, 2)
        self.assertIn("pinned.json", result.stderr)

    def test_fails_loudly_when_a_row_has_no_reason(self):
        self.pin({"file": "skills/rules.md", "phrase": STUCK_CALL})

        result = self.run_check()

        self.assertEqual(result.returncode, 2)
        self.assertIn("reason", result.stderr)

    def test_the_shipped_table_holds_in_this_repo(self):
        write(self.root / "skills" / "rules.md", "nothing to pin here\n")
        repo = SCRIPT.resolve().parent.parent

        result = subprocess.run(
            [sys.executable, "-B", str(SCRIPT), "--plugin-root", str(self.plugin),
             "--pinned", str(PINNED_TABLE), "--pinned-root", str(repo), str(self.root / "skills")],
            capture_output=True, text=True)

        self.assertEqual(result.stdout, "")
        self.assertEqual(result.returncode, 0)

    def test_the_shipped_table_pins_a_phrase_in_every_troubleshooting_entry(self):
        rows = json.loads(PINNED_TABLE.read_text(encoding="utf-8"))
        pinned = [row["phrase"] for row in rows if row["file"].endswith("TROUBLESHOOTING.md")]
        entries, current = [], None
        for line in TROUBLESHOOTING.read_text(encoding="utf-8").splitlines():
            if line.startswith("**"):
                current = [line]
                entries.append(current)
            elif line.startswith("## "):
                current = None
            elif current is not None:
                current.append(line)

        self.assertGreater(len(entries), 10)
        unpinned = [entry[0][:70] for entry in entries
                    if not any(phrase in "\n".join(entry) for phrase in pinned)]
        self.assertEqual(unpinned, [])


if __name__ == "__main__":
    unittest.main()

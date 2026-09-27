"""Tests for drift-check.py, run as the maintainer runs it: a subprocess.

    python -m unittest discover -s scripts
"""

import json
import os
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

SCRIPT = Path(__file__).with_name("drift-check.py")

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
    """skills: {name: human_only}. Writes a manifest listing each one."""
    manifest = {"name": "mattpocock-skills", "skills": []}
    for name, human_only in skills.items():
        flag = "disable-model-invocation: true\n" if human_only else ""
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

    def run_check(self, *targets, plugin_root=True, env=None):
        args = [sys.executable, str(SCRIPT)]
        if plugin_root:
            args += ["--plugin-root", str(self.plugin)]
        args += [str(t) for t in targets] or [str(self.skill)]
        return subprocess.run(args, capture_output=True, text=True, env=env)

    def fake_home(self, plugins):
        """A home directory whose Claude Code install record lists `plugins`."""
        home = self.tmp / "home"
        write(home / ".claude" / "plugins" / "installed_plugins.json",
              json.dumps({"version": 2, "plugins": plugins}))
        return dict(os.environ, HOME=str(home), USERPROFILE=str(home))

    def test_reports_a_reference_to_a_skill_that_does_not_exist(self):
        make_skill(self.skill, SKILL_MD + "\nThen `/mattpocock-skills:no-such-skill`.\n")

        result = self.run_check()

        self.assertNotEqual(result.returncode, 0)
        lines = result.stdout.splitlines()
        self.assertEqual(len(lines), 1, result.stdout)
        self.assertIn("SKILL.md:19:", lines[0])
        self.assertIn("mattpocock-skills:no-such-skill", lines[0])
        self.assertIn("not in the installed plugin", lines[0])

    def test_reports_a_human_only_skill_in_the_step_4_flow_table(self):
        planted = SKILL_MD.replace(
            "| Behaviour that should exist | `/mattpocock-skills:tdd` |",
            "| Behaviour that should exist | `/mattpocock-skills:tdd` |\n"
            "| A spec to write | `/mattpocock-skills:to-spec` |")
        make_skill(self.skill, planted)

        result = self.run_check()

        self.assertNotEqual(result.returncode, 0)
        lines = result.stdout.splitlines()
        self.assertEqual(len(lines), 1, result.stdout)
        self.assertIn("SKILL.md:14:", lines[0])
        self.assertIn("mattpocock-skills:to-spec", lines[0])
        self.assertIn("disable-model-invocation", lines[0])

    def test_reports_a_human_only_skill_anywhere_in_the_common_rules_template(self):
        make_skill(self.skill, template_md=TEMPLATE_MD + "- Then run `/mattpocock-skills:to-spec`.\n")

        result = self.run_check()

        self.assertNotEqual(result.returncode, 0)
        lines = result.stdout.splitlines()
        self.assertEqual(len(lines), 1, result.stdout)
        self.assertIn("COMMON-RULES-TEMPLATE.md:3:", lines[0])
        self.assertIn("disable-model-invocation", lines[0])

    def test_accepts_a_human_only_skill_suggested_outside_the_agent_flow(self):
        make_skill(self.skill)  # step 0 suggests to-spec, which the user types

        result = self.run_check()

        self.assertEqual(result.stdout, "")
        self.assertEqual(result.returncode, 0)

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

        result = self.run_check(plugin_root=False, env=env)

        self.assertNotEqual(result.returncode, 0)
        self.assertIn("mattpocock-skills:extra", result.stdout)
        self.assertIn(str(self.plugin), result.stdout)

    def test_fails_loudly_when_no_matt_plugin_is_installed(self):
        env = self.fake_home({"other@market": [{"scope": "user", "installPath": "x"}]})
        make_skill(self.skill)

        result = self.run_check(plugin_root=False, env=env)

        self.assertNotEqual(result.returncode, 0)
        self.assertNotEqual(result.returncode, 1)
        self.assertIn("mattpocock-skills", result.stderr)


if __name__ == "__main__":
    unittest.main()

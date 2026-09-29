"""Tests for check-version-gate.py, run as the maintainer runs it: a subprocess against a small git
repository built in a temp directory.

    python -B -m unittest discover -s scripts
"""

import json
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

SCRIPT = Path(__file__).with_name("check-version-gate.py")
PLUGIN_JSON = "plugins/matt-with-paseo/.claude-plugin/plugin.json"
WAVE_SKILL = "plugins/matt-with-paseo/skills/matt-with-paseo/SKILL.md"
LISTED = f"# seat-facing\n{WAVE_SKILL}\n"


def write(path, text):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text, encoding="utf-8")


def git(root, *args):
    result = subprocess.run(["git", "-C", str(root), *args], capture_output=True, text=True)
    assert result.returncode == 0, result.stderr
    return result.stdout


def manifest(version):
    return json.dumps({"name": "matt-with-paseo", "version": version}) + "\n"


class VersionGate(unittest.TestCase):
    def setUp(self):
        tmp = tempfile.TemporaryDirectory()
        self.addCleanup(tmp.cleanup)
        self.root = Path(tmp.name)
        git(self.root, "init", "-q", "-b", "main")
        git(self.root, "config", "user.name", "gate-test")
        git(self.root, "config", "user.email", "gate-test@example.invalid")
        git(self.root, "config", "commit.gpgsign", "false")
        write(self.root / PLUGIN_JSON, manifest("0.4.2"))
        write(self.root / WAVE_SKILL, "step 1\n")
        write(self.root / "plugins/matt-with-paseo/triggers/cases.json", "[]\n")
        write(self.root / "list.txt", LISTED)
        self.commit("release 0.4.2")
        git(self.root, "tag", "v0.4.2")
        git(self.root, "switch", "-q", "-c", "feature")

    def commit(self, message):
        git(self.root, "add", "-A")
        git(self.root, "commit", "-q", "-m", message)

    def run_check(self, root=None, paths=None):
        return subprocess.run(
            [sys.executable, "-B", str(SCRIPT), "--root", str(root or self.root),
             "--paths", str(paths or self.root / "list.txt")],
            capture_output=True, text=True)

    def assert_could_not_run(self, result, *fragments):
        """Exit 2, nothing on stdout, and one line on stderr that names the input: no traceback."""
        self.assertEqual(result.returncode, 2, result.stdout + result.stderr)
        self.assertEqual(result.stdout, "")
        self.assertEqual(len(result.stderr.splitlines()), 1, result.stderr)
        self.assertNotIn("Traceback", result.stderr)
        for fragment in fragments:
            self.assertIn(fragment, result.stderr)

    def test_passes_when_no_listed_file_changed_since_the_release_tag(self):
        result = self.run_check()

        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(result.stdout, "")

    def test_a_changed_listed_file_without_a_version_bump_fails_and_names_the_file(self):
        write(self.root / WAVE_SKILL, "step 1, reworded\n")
        self.commit("reword step 1")

        result = self.run_check()

        self.assertEqual(result.returncode, 1, result.stderr)
        lines = result.stdout.splitlines()
        self.assertEqual(len(lines), 1, result.stdout)
        self.assertIn(WAVE_SKILL, lines[0])
        self.assertIn("0.4.2", lines[0])

    def test_bumping_the_version_makes_the_same_change_pass(self):
        write(self.root / WAVE_SKILL, "step 1, reworded\n")
        write(self.root / PLUGIN_JSON, manifest("0.5.0"))
        self.commit("reword step 1, release 0.5.0")

        result = self.run_check()

        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(result.stdout, "")

    def test_a_change_not_yet_committed_counts_and_a_local_bump_clears_it(self):
        write(self.root / WAVE_SKILL, "step 1, reworded\n")

        self.assertEqual(self.run_check().returncode, 1)

        write(self.root / PLUGIN_JSON, manifest("0.5.0"))

        self.assertEqual(self.run_check().returncode, 0)

    def test_a_new_untracked_listed_file_counts(self):
        write(self.root / "list.txt", LISTED + "plugins/matt-with-paseo/skills/matt-with-paseo/NEW.md\n")
        self.commit("list the new file")
        write(self.root / "plugins/matt-with-paseo/skills/matt-with-paseo/NEW.md", "new\n")

        result = self.run_check()

        self.assertEqual(result.returncode, 1, result.stderr)
        self.assertIn("NEW.md", result.stdout)

    def test_outside_a_git_checkout_it_skips_with_a_note_on_stderr_and_no_finding(self):
        with tempfile.TemporaryDirectory() as bare:
            write(Path(bare) / PLUGIN_JSON, manifest("0.4.2"))
            write(Path(bare) / WAVE_SKILL, "step 1\n")

            result = self.run_check(root=bare)

        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(result.stdout, "")
        self.assertIn("skipped", result.stderr)

    def test_a_folder_inside_another_checkout_is_not_a_checkout_of_its_own(self):
        inner = self.root / "vendored"
        write(inner / PLUGIN_JSON, manifest("0.4.2"))
        write(inner / WAVE_SKILL, "changed\n")

        result = self.run_check(root=inner)

        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertIn("skipped", result.stderr)

    def test_without_a_release_tag_it_skips_instead_of_failing(self):
        git(self.root, "tag", "-d", "v0.4.2")
        write(self.root / WAVE_SKILL, "step 1, reworded\n")

        result = self.run_check()

        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(result.stdout, "")
        self.assertIn("skipped", result.stderr)
        self.assertIn("no release tag", result.stderr)

    def test_a_tag_that_is_not_a_release_tag_is_not_compared_with(self):
        git(self.root, "tag", "-d", "v0.4.2")
        git(self.root, "tag", "nightly")
        write(self.root / WAVE_SKILL, "step 1, reworded\n")

        result = self.run_check()

        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertIn("no release tag", result.stderr)

    def test_it_compares_with_the_release_tag_and_not_with_main(self):
        """Main carries the stream's bump, untagged: a later change is already past the last release."""
        git(self.root, "switch", "-q", "main")
        write(self.root / WAVE_SKILL, "step 1, reworded\n")
        write(self.root / PLUGIN_JSON, manifest("0.5.0"))
        self.commit("release 0.5.0, not tagged yet")
        git(self.root, "switch", "-q", "feature")
        git(self.root, "merge", "-q", "--ff-only", "main")
        write(self.root / WAVE_SKILL, "step 1, reworded again\n")

        result = self.run_check()

        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(result.stdout, "")

    def test_the_latest_release_tag_is_the_one_a_change_must_move_past(self):
        write(self.root / WAVE_SKILL, "step 1, reworded\n")
        write(self.root / PLUGIN_JSON, manifest("0.5.0"))
        self.commit("release 0.5.0")
        git(self.root, "tag", "v0.5.0")
        write(self.root / WAVE_SKILL, "step 1, reworded again\n")
        self.commit("reword again")

        result = self.run_check()

        self.assertEqual(result.returncode, 1, result.stderr)
        lines = result.stdout.splitlines()
        self.assertEqual(len(lines), 1, result.stdout)
        self.assertIn("v0.5.0", lines[0])
        self.assertIn("version 0.5.0", lines[0])

    def test_a_missing_seat_facing_list_is_one_line_on_stderr_and_exit_two(self):
        result = self.run_check(paths=self.root / "no-such-list.txt")

        self.assert_could_not_run(result, "no-such-list.txt")

    def test_a_missing_plugin_manifest_is_one_line_on_stderr_and_exit_two(self):
        (self.root / PLUGIN_JSON).unlink()

        result = self.run_check()

        self.assert_could_not_run(result, "plugin.json")

    def test_a_plugin_manifest_that_is_not_json_is_one_line_on_stderr_and_exit_two(self):
        write(self.root / PLUGIN_JSON, "version | 0.5.0")

        result = self.run_check()

        self.assert_could_not_run(result, "plugin.json")

    def test_a_plugin_manifest_without_a_version_is_one_line_on_stderr_and_exit_two(self):
        write(self.root / PLUGIN_JSON, json.dumps({"name": "matt-with-paseo"}))

        result = self.run_check()

        self.assert_could_not_run(result, "plugin.json")

    def test_a_change_to_a_file_the_list_does_not_name_passes(self):
        write(self.root / "plugins/matt-with-paseo/triggers/cases.json", '[{"request": "x"}]\n')
        self.commit("add a trigger case")

        result = self.run_check()

        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)

    def test_a_listed_path_that_does_not_exist_is_named_even_after_a_bump(self):
        write(self.root / "list.txt", LISTED + "plugins/matt-with-paseo/skills/renamed/SKILL.md\n")
        write(self.root / PLUGIN_JSON, manifest("0.5.0"))

        result = self.run_check()

        self.assertEqual(result.returncode, 1, result.stderr)
        lines = result.stdout.splitlines()
        self.assertEqual(len(lines), 1, result.stdout)
        self.assertIn("plugins/matt-with-paseo/skills/renamed/SKILL.md", lines[0])
        self.assertIn("missing", lines[0])

    def test_a_skill_file_the_list_does_not_name_is_named_even_after_a_bump(self):
        stream_file = "plugins/matt-with-paseo/skills/matt-with-paseo-streams/OWNERSHIP.md"
        write(self.root / stream_file, "table\n")
        write(self.root / PLUGIN_JSON, manifest("0.5.0"))

        result = self.run_check()

        self.assertEqual(result.returncode, 1, result.stderr)
        lines = result.stdout.splitlines()
        self.assertEqual(len(lines), 1, result.stdout)
        self.assertIn(stream_file, lines[0])
        self.assertIn("not on the seat-facing list", lines[0])


REPO = SCRIPT.resolve().parent.parent


class ThisRepository(unittest.TestCase):
    """The real list and the real tree, read the way a maintainer would."""

    def listed(self):
        text = (REPO / "scripts" / "seat-facing-paths.txt").read_text(encoding="utf-8")
        return [line.partition("#")[0].strip() for line in text.splitlines() if line.partition("#")[0].strip()]

    def test_the_list_names_every_file_an_agent_reads_including_the_two_this_wave_added(self):
        skills = "plugins/matt-with-paseo/skills"

        self.assertEqual(sorted(self.listed()), sorted([
            f"{skills}/matt-with-paseo/SKILL.md",
            f"{skills}/matt-with-paseo/COMMON-RULES-TEMPLATE.md",
            f"{skills}/matt-with-paseo/TROUBLESHOOTING.md",
            f"{skills}/matt-with-paseo/PASEO-FACTS.md",
            f"{skills}/matt-with-paseo-streams/SKILL.md",
            f"{skills}/matt-with-paseo-streams/OWNERSHIP.md",
        ]))

    def test_the_list_leaves_out_the_trigger_data_and_the_human_facing_template(self):
        for path in self.listed():
            self.assertNotIn("triggers", path)
            self.assertNotIn("acceptance-run-template", path)

    def test_this_repository_passes_its_own_gate(self):
        result = subprocess.run([sys.executable, "-B", str(SCRIPT)], capture_output=True, text=True)

        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)

"""Tests for troubleshooting-ratings.py, run as the maintainer runs it: a subprocess.

    python -B -m unittest discover -s scripts
"""

import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

SCRIPT = Path(__file__).with_name("troubleshooting-ratings.py")
REPO = SCRIPT.resolve().parent.parent
TROUBLESHOOTING = (REPO / "plugins" / "matt-with-paseo" / "skills" / "matt-with-paseo"
                    / "TROUBLESHOOTING.md")

ENTRY_A = "**Agent stops midway** (session limit). Do something about it."
ENTRY_B = "**Report is correct but incomplete.** Open the real artifact."

CHECK_MD = "## 5. Check each report\n\nSomething runs `get_agent_status` here.\n"


def write(path, text):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text, encoding="utf-8")


class TroubleshootingRatings(unittest.TestCase):
    def setUp(self):
        tmp = tempfile.TemporaryDirectory()
        self.addCleanup(tmp.cleanup)
        self.tmp = Path(tmp.name)
        self.check_file = self.tmp / "SKILL.md"
        write(self.check_file, CHECK_MD)

    def run_check(self, troubleshooting_md, repo_root=None):
        path = self.tmp / "TROUBLESHOOTING.md"
        write(path, troubleshooting_md)
        args = [sys.executable, "-B", str(SCRIPT), "--troubleshooting", str(path),
                "--repo-root", str(repo_root or self.tmp)]
        return subprocess.run(args, capture_output=True, text=True)

    def assert_one_finding(self, result, *fragments):
        self.assertEqual(result.returncode, 1, result.stderr)
        lines = result.stdout.splitlines()
        self.assertEqual(len(lines), 1, result.stdout)
        for fragment in fragments:
            self.assertIn(fragment, lines[0])

    def test_reports_an_entry_with_no_rating(self):
        result = self.run_check(f"## Agents\n\n{ENTRY_A}\n\n{ENTRY_B}\nRating: asked.\n")

        self.assert_one_finding(result, "Agent stops midway", "no rating")

    def test_reports_an_entry_with_an_unknown_rating_word(self):
        result = self.run_check(f"## Agents\n\n{ENTRY_A}\nRating: maybe.\n")

        self.assert_one_finding(result, "Agent stops midway", "unknown rating", "maybe")

    def test_reports_a_caught_entry_whose_phrase_is_gone_from_its_check_file(self):
        result = self.run_check(
            f'## Agents\n\n{ENTRY_A}\n'
            f'Rating: caught — check: `SKILL.md`, phrase "no such text here".\n')

        self.assert_one_finding(result, "Agent stops midway", "no such text here", "SKILL.md")

    def test_rejects_troubleshooting_md_itself_as_the_named_check_file(self):
        result = self.run_check(
            f'## Agents\n\n{ENTRY_A}\n'
            f'Rating: caught — check: `TROUBLESHOOTING.md`, phrase "Do something about it".\n')

        self.assert_one_finding(result, "Agent stops midway", "TROUBLESHOOTING.md", "own file")

    def test_accepts_every_entry_rated_and_every_caught_phrase_present(self):
        result = self.run_check(
            f'## Agents\n\n{ENTRY_A}\n'
            f'Rating: caught — check: `SKILL.md`, phrase "`get_agent_status`".\n\n'
            f'{ENTRY_B}\nRating: asked.\n')

        self.assertEqual(result.stdout, "", result.stdout)
        self.assertEqual(result.returncode, 0)

    def test_on_the_real_repo_every_entry_is_rated_and_every_caught_phrase_is_present(self):
        args = [sys.executable, "-B", str(SCRIPT)]
        result = subprocess.run(args, capture_output=True, text=True)

        self.assertEqual(result.stdout, "", result.stdout)
        self.assertEqual(result.returncode, 0, result.stderr)


if __name__ == "__main__":
    unittest.main()

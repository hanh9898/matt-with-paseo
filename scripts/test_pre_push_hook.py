"""Tests for .githooks/pre-push, run as git runs it: a hook in a throwaway repository.

    python -B -m unittest scripts/test_pre_push_hook.py

Each test builds a repository holding stand-ins for scripts/drift-check.py and
scripts/test_drift_check.py, so the real check never runs.
"""

import os
import shutil
import stat
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
HOOKS = REPO / ".githooks"
GIT = shutil.which("git")
SH = shutil.which("sh")

DRIFT_CHECK = """\
import sys
from pathlib import Path

here = Path(__file__).resolve().parent
print(here.joinpath("findings.txt").read_text(encoding="utf-8"), end="")
sys.exit(int(here.joinpath("exit-code.txt").read_text(encoding="utf-8")))
"""

DRIFT_TESTS = """\
import unittest


class Stub(unittest.TestCase):
    def test_stub(self):
        self.assertEqual(open("scripts/tests-pass.txt").read().strip(), "yes")


if __name__ == "__main__":
    unittest.main()
"""


def write(path, text):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text, encoding="utf-8", newline="\n")


def git(cwd, *args, env=None):
    return subprocess.run([GIT, *args], cwd=cwd, capture_output=True, text=True, env=env)


class PrePushHook(unittest.TestCase):
    def setUp(self):
        tmp = tempfile.TemporaryDirectory()
        self.addCleanup(tmp.cleanup)
        self.tmp = Path(tmp.name)
        self.repo = self.tmp / "repo"
        self.repo.mkdir()
        git(self.repo, "init", "-q")
        git(self.repo, "config", "user.email", "test@example.com")
        git(self.repo, "config", "user.name", "Test")
        write(self.repo / "scripts" / "drift-check.py", DRIFT_CHECK)
        write(self.repo / "scripts" / "test_drift_check.py", DRIFT_TESTS)
        shutil.copytree(HOOKS, self.repo / ".githooks")
        for hook in (self.repo / ".githooks").iterdir():
            hook.chmod(hook.stat().st_mode | stat.S_IXUSR)
        self.set_state(tests_pass=True, exit_code=0, findings="")

    def set_state(self, tests_pass, exit_code, findings):
        write(self.repo / "scripts" / "tests-pass.txt", "yes" if tests_pass else "no")
        write(self.repo / "scripts" / "exit-code.txt", str(exit_code))
        write(self.repo / "scripts" / "findings.txt", findings)

    def path_with_only(self, *names):
        """A PATH holding git and the named interpreter commands only.

        Each name is a wrapper that runs the interpreter running these tests; a
        name mapped to None is a wrapper that fails, as the Windows `python3`
        Store alias does. Git is a wrapper too, so no system directory joins the
        PATH: on Linux and macOS the directories of `sh` and `git` are `/usr/bin`,
        which holds a real `python3`. The hook's shell is started by its absolute
        path (`run_hook`).
        """
        bin_dir = self.tmp / "bin"
        bin_dir.mkdir(exist_ok=True)
        write(bin_dir / "git", f'#!/bin/sh\nexec "{Path(GIT).as_posix()}" "$@"\n')
        (bin_dir / "git").chmod(0o755)
        for name in names:
            body = f'exec "{Path(sys.executable).as_posix()}" "$@"\n'
            write(bin_dir / name, "#!/bin/sh\n" + body)
            (bin_dir / name).chmod(0o755)
        return str(bin_dir)

    def broken_interpreter(self, name):
        write(self.tmp / "bin" / name, "#!/bin/sh\nexit 49\n")
        (self.tmp / "bin" / name).chmod(0o755)

    def run_hook(self, path=None):
        env = dict(os.environ)
        if path is not None:
            env["PATH"] = path
        return subprocess.run(
            [SH, str(self.repo / ".githooks" / "pre-push")], cwd=self.repo,
            capture_output=True, text=True, env=env, input="")

    def test_lets_the_push_go_on_when_tests_and_drift_check_pass(self):
        result = self.run_hook()

        self.assertEqual(result.returncode, 0, result.stderr)

    def test_refuses_the_push_and_names_the_stale_reference(self):
        finding = "skills/x/SKILL.md:3: mattpocock-skills:no-such-skill is not in the installed plugin\n"
        self.set_state(tests_pass=True, exit_code=1, findings=finding)

        result = self.run_hook()

        self.assertNotEqual(result.returncode, 0)
        self.assertIn("mattpocock-skills:no-such-skill", result.stdout + result.stderr)

    def test_refuses_the_push_when_the_drift_check_tests_fail(self):
        self.set_state(tests_pass=False, exit_code=0, findings="")

        result = self.run_hook()

        self.assertNotEqual(result.returncode, 0)

    def test_does_not_run_the_drift_check_when_the_tests_fail(self):
        self.set_state(tests_pass=False, exit_code=1, findings="DRIFT-CHECK-RAN\n")

        result = self.run_hook()

        self.assertNotIn("DRIFT-CHECK-RAN", result.stdout + result.stderr)

    def test_warns_and_lets_the_push_go_on_when_the_drift_check_cannot_run(self):
        self.set_state(tests_pass=True, exit_code=2, findings="")

        result = self.run_hook()

        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("warning", (result.stdout + result.stderr).lower())

    def test_works_with_only_python_on_path(self):
        result = self.run_hook(self.path_with_only("python"))

        self.assertEqual(result.returncode, 0, result.stderr)

    def test_works_with_only_python3_on_path(self):
        result = self.run_hook(self.path_with_only("python3"))

        self.assertEqual(result.returncode, 0, result.stderr)

    def test_still_refuses_with_only_python3_on_path(self):
        self.set_state(tests_pass=True, exit_code=1, findings="stale-ref\n")

        result = self.run_hook(self.path_with_only("python3"))

        self.assertNotEqual(result.returncode, 0)
        self.assertIn("stale-ref", result.stdout + result.stderr)

    def test_skips_a_python3_that_does_not_run(self):
        path = self.path_with_only("python")
        self.broken_interpreter("python3")

        result = self.run_hook(path)

        self.assertEqual(result.returncode, 0, result.stderr)

    def test_warns_and_lets_the_push_go_on_with_no_python_at_all(self):
        result = self.run_hook(self.path_with_only())

        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("warning", (result.stdout + result.stderr).lower())

    def test_ships_only_a_pre_push_hook(self):
        self.assertEqual([hook.name for hook in HOOKS.iterdir()], ["pre-push"])

    def test_a_commit_goes_through_while_the_checks_fail(self):
        self.set_state(tests_pass=False, exit_code=1, findings="stale-ref\n")
        git(self.repo, "config", "core.hooksPath", ".githooks")
        git(self.repo, "add", "-A")

        result = git(self.repo, "commit", "-q", "-m", "work")

        self.assertEqual(result.returncode, 0, result.stderr)


if __name__ == "__main__":
    unittest.main()

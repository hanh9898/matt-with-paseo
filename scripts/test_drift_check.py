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

    def run_check(self, *targets, env=None):
        args = [sys.executable, str(SCRIPT), "--plugin-root", str(self.plugin)]
        args += [str(t) for t in targets] or [str(self.skill)]
        return subprocess.run(args, capture_output=True, text=True, env=env)

    def test_reports_a_reference_to_a_skill_that_does_not_exist(self):
        make_skill(self.skill, SKILL_MD + "\nThen `/mattpocock-skills:no-such-skill`.\n")

        result = self.run_check()

        self.assertNotEqual(result.returncode, 0)
        lines = result.stdout.splitlines()
        self.assertEqual(len(lines), 1, result.stdout)
        self.assertIn("SKILL.md:19:", lines[0])
        self.assertIn("mattpocock-skills:no-such-skill", lines[0])
        self.assertIn("not in the installed plugin", lines[0])


if __name__ == "__main__":
    unittest.main()

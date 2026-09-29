"""Tests for trigger_cases.py and the two trigger commands, run as the maintainer runs them:

    python -B -m unittest discover -s scripts
"""

import json
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

import trigger_cases

SCRIPTS = Path(__file__).resolve().parent
CHECK = SCRIPTS / "check-triggers.py"
RUN = SCRIPTS / "run-triggers.py"
PLUGIN = SCRIPTS.parent / "plugins" / "matt-with-paseo"
CARDS = {"alpha": "Does alpha things.", "beta": "Does beta things."}


def case(brief, expect, near=None):
    one = {"brief": brief, "expect": expect}
    if near:
        one["near"] = near
    return one


def covering(skill):
    """Three briefs that should open the skill and two near misses that should open nothing."""
    return ([case(f"{skill} brief {number}", [skill]) for number in range(3)]
            + [case(f"{skill} near miss {number}", [], near=skill) for number in range(2)])


def write(path, text):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text, encoding="utf-8")


class CoverageFindings(unittest.TestCase):
    def test_a_skill_with_three_briefs_and_two_near_misses_has_no_finding(self):
        cases = covering("alpha") + covering("beta")

        self.assertEqual(trigger_cases.coverage_findings(CARDS, cases), [])

    def test_a_skill_with_two_briefs_is_named_with_the_count_and_the_minimum(self):
        cases = covering("beta") + covering("alpha")[1:]

        findings = trigger_cases.coverage_findings(CARDS, cases)

        self.assertEqual(findings, ["alpha: 2 briefs that should open it; write at least 3"])

    def test_a_skill_with_one_near_miss_is_named_with_the_count_and_the_minimum(self):
        cases = covering("beta") + covering("alpha")[:-1]

        findings = trigger_cases.coverage_findings(CARDS, cases)

        self.assertEqual(findings, ["alpha: 1 near misses for it; write at least 2"])

    def test_a_skill_with_no_case_at_all_gets_both_findings(self):
        findings = trigger_cases.coverage_findings(CARDS, covering("beta"))

        self.assertEqual(findings, ["alpha: 0 briefs that should open it; write at least 3",
                                    "alpha: 0 near misses for it; write at least 2"])

    def test_a_case_that_names_a_skill_the_plugin_lacks_is_reported_with_its_number(self):
        cases = covering("alpha") + covering("beta") + [case("Ship it.", ["gamma"])]

        findings = trigger_cases.coverage_findings(CARDS, cases)

        self.assertEqual(findings, ["case 11 (Ship it.): names gamma, which is not a skill of this plugin"])

    def test_a_case_that_is_a_near_miss_for_the_skill_it_expects_does_not_count_as_a_brief_for_it(self):
        cases = covering("beta") + covering("alpha")[:2] + [case("Odd.", ["alpha"], near="alpha")] \
            + covering("alpha")[3:]

        findings = trigger_cases.coverage_findings(CARDS, cases)

        self.assertEqual(findings, ["alpha: 2 briefs that should open it; write at least 3"])


if __name__ == "__main__":
    unittest.main()

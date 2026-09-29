"""Tests for trigger_cases.py and the two trigger commands, run as the maintainer runs them:

    python -B -m unittest discover -s scripts
"""

import json
import shutil
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


class LoadCases(unittest.TestCase):
    def setUp(self):
        self.tmp = Path(tempfile.mkdtemp())
        self.addCleanup(shutil.rmtree, self.tmp, ignore_errors=True)
        self.path = self.tmp / "cases.json"

    def load_error(self, text):
        write(self.path, text)
        with self.assertRaises(trigger_cases.TriggerError) as raised:
            trigger_cases.load_cases(self.path)
        return str(raised.exception)

    def test_reads_the_list_of_cases(self):
        cases = [case("Run the wave.", ["alpha"]), case("Ship it.", [], near="beta")]
        write(self.path, json.dumps(cases))

        self.assertEqual(trigger_cases.load_cases(self.path), cases)

    def test_a_missing_file_is_named(self):
        with self.assertRaises(trigger_cases.TriggerError) as raised:
            trigger_cases.load_cases(self.tmp / "no-such-cases.json")

        self.assertIn("no-such-cases.json", str(raised.exception))

    def test_text_that_is_not_json_is_named(self):
        self.assertIn("cases.json: not valid JSON", self.load_error("brief | expect"))

    def test_a_top_level_that_is_not_a_list_is_named(self):
        self.assertIn("cases.json: expected a list of cases", self.load_error('{"brief": "x"}'))

    def test_a_case_without_a_brief_is_named_by_its_number(self):
        text = json.dumps([case("Fine.", ["alpha"]), {"expect": ["alpha"]}])

        self.assertIn("case 2: needs a non-empty brief", self.load_error(text))

    def test_a_case_whose_expect_is_not_a_list_of_names_is_named_by_its_number(self):
        text = json.dumps([{"brief": "Fine.", "expect": "alpha"}])

        self.assertIn("case 1: expect must be a list of skill names", self.load_error(text))

    def test_a_case_whose_near_is_not_a_name_is_named_by_its_number(self):
        text = json.dumps([{"brief": "Fine.", "expect": [], "near": ["alpha"]}])

        self.assertIn("case 1: near must be one skill name", self.load_error(text))


class SkillCards(unittest.TestCase):
    def test_a_card_is_the_skills_name_and_its_description_with_quotes_stripped(self):
        with tempfile.TemporaryDirectory() as tmp:
            plugin = Path(tmp)
            write(plugin / "skills" / "one-folder" / "SKILL.md",
                  "---\nname: alpha\ndescription: \"Run `alpha`: does alpha.\"\n---\n\n# Alpha\n")
            write(plugin / "skills" / "other-folder" / "SKILL.md",
                  "---\nname: beta\ndescription: Does beta.\ndisable-model-invocation: true\n---\n\n# Beta\n")

            cards = trigger_cases.skill_cards(plugin)

        self.assertEqual(cards, {"alpha": "Run `alpha`: does alpha.", "beta": "Does beta."})

    def test_a_skill_without_a_description_stops_the_check_naming_its_file(self):
        with tempfile.TemporaryDirectory() as tmp:
            plugin = Path(tmp)
            write(plugin / "skills" / "bare" / "SKILL.md", "---\nname: bare\n---\n")

            with self.assertRaises(trigger_cases.TriggerError) as raised:
                trigger_cases.skill_cards(plugin)

        self.assertIn(str(Path("bare") / "SKILL.md"), str(raised.exception))


def make_plugin(root):
    for name, description in CARDS.items():
        write(root / "skills" / name / "SKILL.md", f"---\nname: {name}\ndescription: {description}\n---\n")


class CheckTriggers(unittest.TestCase):
    def setUp(self):
        self.tmp = Path(tempfile.mkdtemp())
        self.addCleanup(shutil.rmtree, self.tmp, ignore_errors=True)
        make_plugin(self.tmp / "plugin")

    def run_check(self, cases=None):
        path = self.tmp / "cases.json"
        if cases is not None:
            write(path, json.dumps(cases))
        return subprocess.run(
            [sys.executable, "-B", str(CHECK), "--cases", str(path), "--plugin-root", str(self.tmp / "plugin")],
            capture_output=True, text=True)

    def test_exits_clean_and_silent_when_every_skill_is_covered(self):
        result = self.run_check(covering("alpha") + covering("beta"))

        self.assertEqual(result.stdout, "")
        self.assertEqual(result.returncode, 0)

    def test_prints_one_line_per_finding_and_exits_one(self):
        result = self.run_check(covering("beta") + covering("alpha")[1:])

        self.assertEqual(result.stdout.splitlines(),
                         ["alpha: 2 briefs that should open it; write at least 3"])
        self.assertEqual(result.returncode, 1)

    def test_a_missing_cases_file_is_one_line_on_stderr_and_exit_two(self):
        result = self.run_check()

        self.assertEqual(result.stdout, "")
        self.assertEqual(result.returncode, 2)
        self.assertIn("cases.json", result.stderr)


class ShippedTriggerCases(unittest.TestCase):
    """The gate's own run: the plugin's real cases against the plugin's real skills, no model."""

    def test_the_shipped_cases_cover_the_wave_skill_and_the_stream_skill(self):
        result = subprocess.run([sys.executable, "-B", str(CHECK)], capture_output=True, text=True)

        self.assertEqual(result.stdout, "")
        self.assertEqual(result.returncode, 0)

    def test_the_plugin_ships_exactly_the_two_skills_the_cases_are_written_for(self):
        self.assertEqual(sorted(trigger_cases.skill_cards(PLUGIN)), ["matt-with-paseo", "matt-with-paseo-streams"])

    def test_no_brief_is_written_twice(self):
        briefs = [one["brief"] for one in trigger_cases.load_cases(PLUGIN / "triggers" / "cases.json")]

        self.assertEqual(len(briefs), len(set(briefs)))


class ModelRunParts(unittest.TestCase):
    def test_the_prompt_shows_one_card_per_skill_and_then_the_brief(self):
        prompt = trigger_cases.trigger_prompt(CARDS, "Run the wave.")

        self.assertRegex(prompt, r"(?m)^- alpha: Does alpha things\.$")
        self.assertRegex(prompt, r"(?m)^- beta: Does beta things\.$")
        self.assertTrue(prompt.endswith("Your brief:\nRun the wave."))

    def test_the_prompt_asks_for_a_json_answer_and_leaks_no_expected_skill(self):
        prompt = trigger_cases.trigger_prompt(CARDS, "Run the wave.")

        self.assertIn('{"skills": ["<skill name>"]}', prompt)
        self.assertNotIn("expect", prompt)

    def test_the_answer_is_the_last_json_the_agent_printed(self):
        output = 'Thinking {"skills": ["alpha"]} ... final: {"skills": ["beta"]}'

        self.assertEqual(trigger_cases.opened_skills(output), ["beta"])

    def test_an_empty_answer_is_an_answer_and_prose_is_none(self):
        self.assertEqual(trigger_cases.opened_skills('{"skills": []}'), [])
        self.assertIsNone(trigger_cases.opened_skills("I would open alpha."))

    def test_a_run_is_right_only_when_it_opened_exactly_the_expected_skills(self):
        near_miss = case("b", ["alpha"], near="beta")

        self.assertTrue(trigger_cases.right_run(near_miss, ["alpha"]))
        self.assertFalse(trigger_cases.right_run(near_miss, ["alpha", "beta"]))
        self.assertFalse(trigger_cases.right_run(near_miss, ["beta"]))
        self.assertTrue(trigger_cases.right_run(case("b", []), []))
        self.assertFalse(trigger_cases.right_run(case("b", []), ["alpha"]))
        self.assertFalse(trigger_cases.right_run(case("b", ["alpha"]), None))

    def test_a_case_passes_on_a_strict_majority_of_its_runs(self):
        self.assertTrue(trigger_cases.majority(2, 3))
        self.assertFalse(trigger_cases.majority(1, 3))
        self.assertFalse(trigger_cases.majority(2, 4))
        self.assertTrue(trigger_cases.majority(3, 4))


FAKE_AGENT = """\
import sys
brief = sys.stdin.read().split("Your brief:\\n")[1]
print('{"skills": ["alpha"]}' if "alpha" in brief else '{"skills": ["beta"]}')
"""


class RunTriggers(unittest.TestCase):
    """The model run, with a fake agent in place of the model: it answers alpha for a brief that says alpha."""

    def setUp(self):
        self.tmp = Path(tempfile.mkdtemp())
        self.addCleanup(shutil.rmtree, self.tmp, ignore_errors=True)
        make_plugin(self.tmp / "plugin")
        write(self.tmp / "fake_agent.py", FAKE_AGENT)

    def run_triggers(self, cases, agent=None, extra=()):
        write(self.tmp / "cases.json", json.dumps(cases))
        agent = agent or [sys.executable, str(self.tmp / "fake_agent.py")]
        return subprocess.run(
            [sys.executable, "-B", str(RUN), "--cases", str(self.tmp / "cases.json"),
             "--plugin-root", str(self.tmp / "plugin"), "--runs", "3", *extra, "--", *agent],
            capture_output=True, text=True)

    def test_exits_zero_when_every_case_is_right_on_a_majority_of_its_runs(self):
        result = self.run_triggers([case("alpha please", ["alpha"]), case("beta please", ["beta"])])

        self.assertEqual(result.returncode, 0)
        self.assertIn("PASS 3/3", result.stdout)
        self.assertNotIn("FAIL", result.stdout)

    def test_a_case_the_agent_gets_wrong_fails_the_run_and_shows_both_answers(self):
        result = self.run_triggers([case("alpha please", ["alpha"]), case("beta please", ["alpha"])])

        self.assertEqual(result.returncode, 1)
        self.assertIn("PASS 3/3", result.stdout)
        self.assertRegex(result.stdout, r"FAIL 0/3 .*expected \['alpha'\] .*opened \['beta'\]")

    def test_an_agent_that_is_not_installed_is_one_line_on_stderr_and_exit_two(self):
        result = self.run_triggers([case("alpha please", ["alpha"])], agent=["no-such-agent-program"])

        self.assertEqual(result.returncode, 2)
        self.assertEqual(result.stdout, "")
        self.assertIn("no-such-agent-program", result.stderr)

    def test_a_run_count_below_one_is_a_usage_error(self):
        result = self.run_triggers([case("alpha please", ["alpha"])], extra=["--runs", "0"])

        self.assertEqual(result.returncode, 2)
        self.assertIn("--runs", result.stderr)


if __name__ == "__main__":
    unittest.main()

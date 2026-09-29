"""Trigger cases for the plugin's skills: briefs that should open a skill and near misses that should
not, as data (plugins/matt-with-paseo/triggers/cases.json). check-triggers.py checks their coverage
without a model; run-triggers.py asks a model on demand."""

import json

MIN_BRIEFS = 3
MIN_NEAR_MISSES = 2


def coverage_findings(cards, cases):
    """One line per problem: a case naming a skill the plugin lacks, a skill short of briefs or near misses."""
    findings = []
    for number, one in enumerate(cases, 1):
        named = [*one["expect"], *([one["near"]] if one.get("near") else [])]
        for name in named:
            if name not in cards:
                findings.append(f"case {number} ({one['brief'][:60]}): names {name}, "
                                "which is not a skill of this plugin")
    for name in cards:
        briefs = sum(1 for one in cases if name in one["expect"] and one.get("near") != name)
        misses = sum(1 for one in cases if one.get("near") == name)
        if briefs < MIN_BRIEFS:
            findings.append(f"{name}: {briefs} briefs that should open it; write at least {MIN_BRIEFS}")
        if misses < MIN_NEAR_MISSES:
            findings.append(f"{name}: {misses} near misses for it; write at least {MIN_NEAR_MISSES}")
    return findings


class TriggerError(Exception):
    """The check or the run could not start: exit 2, one line on stderr."""


def load_cases(path):
    if not path.is_file():
        raise TriggerError(f"{path}: no such cases file.")
    try:
        cases = json.loads(path.read_text(encoding="utf-8"))
    except ValueError as error:
        raise TriggerError(f"{path}: not valid JSON ({error}).")
    if not isinstance(cases, list):
        raise TriggerError(f"{path}: expected a list of cases.")
    for number, one in enumerate(cases, 1):
        if not isinstance(one, dict):
            raise TriggerError(f"{path}: case {number}: expected an object.")
        if not isinstance(one.get("brief"), str) or not one["brief"].strip():
            raise TriggerError(f"{path}: case {number}: needs a non-empty brief.")
        expect = one.get("expect")
        if not isinstance(expect, list) or not all(isinstance(name, str) and name for name in expect):
            raise TriggerError(f"{path}: case {number}: expect must be a list of skill names.")
        if "near" in one and not (isinstance(one["near"], str) and one["near"]):
            raise TriggerError(f"{path}: case {number}: near must be one skill name.")
    return cases


def frontmatter(skill_md):
    lines = skill_md.read_text(encoding="utf-8").splitlines()
    fields = {}
    if lines and lines[0].strip() == "---":
        for line in lines[1:]:
            if line.strip() == "---":
                break
            key, _, value = line.partition(":")
            fields[key.strip()] = value.strip()
    return fields


def skill_cards(plugin_root):
    """{skill name: description} for every skill of the plugin, the way a model sees it before it opens one."""
    cards = {}
    for skill_md in sorted((plugin_root / "skills").glob("*/SKILL.md")):
        fields = frontmatter(skill_md)
        description = fields.get("description", "")
        if len(description) > 1 and description[0] == description[-1] and description[0] in "\"'":
            description = description[1:-1]
        if not description:
            raise TriggerError(f"{skill_md}: no description in the front matter, so no card can be made.")
        cards[fields.get("name", skill_md.parent.name)] = description
    return cards

"""Trigger cases for the plugin's skills: briefs that should open a skill and near misses that should
not, as data (plugins/matt-with-paseo/triggers/cases.json). check-triggers.py checks their coverage
without a model; run-triggers.py asks a model on demand."""

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

#!/usr/bin/env python3
"""Check, without a model, that every skill of the plugin has at least three requests that should open
it and two near misses in the trigger cases (plugins/matt-with-paseo/triggers/cases.json), and that
every case names only skills the plugin has. The model run is a separate command: run-triggers.py."""

import argparse
import sys
from pathlib import Path

import trigger_cases

REPO = Path(__file__).resolve().parent.parent
PLUGIN = REPO / "plugins" / "matt-with-paseo"


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--cases", type=Path, default=PLUGIN / "triggers" / "cases.json")
    parser.add_argument("--plugin-root", type=Path, default=PLUGIN)
    args = parser.parse_args()

    try:
        cases = trigger_cases.load_cases(args.cases)
        cards = trigger_cases.skill_cards(args.plugin_root)
    except trigger_cases.TriggerError as error:
        print(error, file=sys.stderr)
        return 2
    findings = trigger_cases.coverage_findings(cards, cases)
    for finding in findings:
        print(finding)
    return 1 if findings else 0


if __name__ == "__main__":
    sys.exit(main())

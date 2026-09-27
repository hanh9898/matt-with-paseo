#!/usr/bin/env python3
"""Check every mattpocock-skills:<name> reference against the installed Matt plugin."""

import argparse
import json
import re
import sys
from pathlib import Path

REFERENCE = re.compile(r"mattpocock-skills:([a-z0-9][a-z0-9-]*)")


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


def installed_skills(plugin_root):
    manifest = json.loads((plugin_root / ".claude-plugin" / "plugin.json").read_text(encoding="utf-8"))
    skills = {}
    for entry in manifest["skills"]:
        fields = frontmatter(plugin_root / entry / "SKILL.md")
        skills[fields.get("name", Path(entry).name)] = fields
    return skills


def markdown_files(targets):
    for target in targets:
        if target.is_dir():
            yield from sorted(target.rglob("*.md"))
        else:
            yield target


def agent_flow_lines(path, lines):
    """Line numbers an agent runs as its flow: the whole common rules template, and step 4 of SKILL.md."""
    if path.name == "COMMON-RULES-TEMPLATE.md":
        return set(range(1, len(lines) + 1))
    if path.name != "SKILL.md":
        return set()
    flow, inside = set(), False
    for number, line in enumerate(lines, 1):
        if line.startswith("## "):
            inside = line.startswith("## 4.")
        elif inside:
            flow.add(number)
    return flow


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("targets", nargs="*", type=Path)
    parser.add_argument("--plugin-root", type=Path)
    args = parser.parse_args()

    skills = installed_skills(args.plugin_root)
    mismatches = 0
    for path in markdown_files(args.targets):
        lines = path.read_text(encoding="utf-8").splitlines()
        flow = agent_flow_lines(path, lines)
        for number, line in enumerate(lines, 1):
            for name in REFERENCE.findall(line):
                if name not in skills:
                    reason = "not in the installed plugin"
                elif number in flow and skills[name].get("disable-model-invocation") == "true":
                    reason = "in an agent flow, but the skill sets disable-model-invocation"
                else:
                    continue
                print(f"{path}:{number}: mattpocock-skills:{name}: {reason}")
                mismatches += 1
    return 1 if mismatches else 0


if __name__ == "__main__":
    sys.exit(main())

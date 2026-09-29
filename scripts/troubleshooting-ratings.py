#!/usr/bin/env python3
"""Check that every TROUBLESHOOTING.md entry carries a rating (caught, asked, or nothing yet),
and that every caught entry's named check still holds its exact phrase, so a rating cannot go
stale in silence."""

import argparse
import re
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
TROUBLESHOOTING = (REPO / "plugins" / "matt-with-paseo" / "skills" / "matt-with-paseo"
                    / "TROUBLESHOOTING.md")

ENTRY_START = re.compile(r"^\*\*(.+?)\*\*")
RATING_LINE = re.compile(r"^Rating: (caught|asked|nothing yet)\b(.*)$")
CAUGHT_DETAIL = re.compile(r"^ — check: `([^`]+)`, phrase \"([^\"]+)\"\.$")


def fail(message):
    """Exit 2: the check could not run. Exit 1 is kept for findings."""
    print(message, file=sys.stderr)
    sys.exit(2)


def entries(lines):
    """Yield (label, start_line, end_line) for each entry: a line starting with `**bold**` up to,
    but not including, the next such line or the end of the file. 1-indexed, end exclusive."""
    starts = [(number, ENTRY_START.match(line).group(1))
              for number, line in enumerate(lines, 1) if ENTRY_START.match(line)]
    for index, (start, label) in enumerate(starts):
        end = starts[index + 1][0] if index + 1 < len(starts) else len(lines) + 1
        yield label, start, end


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--troubleshooting", type=Path, default=TROUBLESHOOTING)
    parser.add_argument("--repo-root", type=Path, default=REPO)
    args = parser.parse_args()

    if not args.troubleshooting.is_file():
        fail(f"No such file: {args.troubleshooting}")

    lines = args.troubleshooting.read_text(encoding="utf-8").splitlines()
    findings = 0

    for label, start, end in entries(lines):
        rating_lines = [(number, line) for number, line in enumerate(lines[start - 1:end - 1], start)
                         if line.startswith("Rating: ")]
        if not rating_lines:
            print(f"{args.troubleshooting}:{start}: \"{label}\": no rating")
            findings += 1
            continue
        if len(rating_lines) > 1:
            print(f"{args.troubleshooting}:{start}: \"{label}\": more than one rating line")
            findings += 1
            continue
        number, line = rating_lines[0]
        match = RATING_LINE.match(line)
        if not match:
            word = line[len("Rating: "):].split(".")[0].split(" —")[0]
            print(f"{args.troubleshooting}:{number}: \"{label}\": unknown rating \"{word}\"")
            findings += 1
            continue
        rating, rest = match.group(1), match.group(2)
        if rating != "caught":
            continue
        detail = CAUGHT_DETAIL.match(rest)
        if not detail:
            print(f"{args.troubleshooting}:{number}: \"{label}\": caught rating names no check "
                  "(expected ` — check: `<file>`, phrase \"<text>\".`)")
            findings += 1
            continue
        check_file, phrase = detail.group(1), detail.group(2)
        check_path = args.repo_root / check_file
        if check_path.resolve() == args.troubleshooting.resolve():
            print(f"{args.troubleshooting}:{number}: \"{label}\": names its own file "
                  "(TROUBLESHOOTING.md) as the check, which can never disappear")
            findings += 1
            continue
        if not check_path.is_file():
            print(f"{args.troubleshooting}:{number}: \"{label}\": check file {check_file} does not exist")
            findings += 1
            continue
        if phrase not in check_path.read_text(encoding="utf-8"):
            print(f"{args.troubleshooting}:{number}: \"{label}\": phrase \"{phrase}\" not found in {check_file}")
            findings += 1

    return 1 if findings else 0


if __name__ == "__main__":
    sys.exit(main())

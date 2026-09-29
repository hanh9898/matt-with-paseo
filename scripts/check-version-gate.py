#!/usr/bin/env python3
"""Fail when a seat-facing file (scripts/seat-facing-paths.txt) differs from the base branch while the
plugin version is still the base branch's: agents read those files when they are created, so a change
without a bump runs silently on stale text."""

import argparse
import json
import subprocess
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
PLUGIN_JSON = "plugins/matt-with-paseo/.claude-plugin/plugin.json"
SEAT_FACING = Path(__file__).resolve().with_name("seat-facing-paths.txt")


def git(root, *args):
    return subprocess.run(["git", "-C", str(root), *args], capture_output=True, text=True, encoding="utf-8")


def seat_facing_paths(path):
    """The paths of the list: one per line, `#` starts a comment."""
    lines = path.read_text(encoding="utf-8").splitlines()
    return [entry for entry in (line.partition("#")[0].strip() for line in lines) if entry]


def version_at(root, ref):
    shown = git(root, "show", f"{ref}:{PLUGIN_JSON}")
    return json.loads(shown.stdout)["version"] if shown.returncode == 0 else None


def changed_paths(root, ref, paths):
    """The listed paths that differ from `ref` in the working tree, plus the untracked ones."""
    changed = git(root, "diff", "--name-only", ref, "--", *paths).stdout.splitlines()
    changed += git(root, "ls-files", "--others", "--exclude-standard", "--", *paths).stdout.splitlines()
    return sorted(set(changed))


def skip_reason(root, base):
    """Why the gate cannot compare, or None. It compares only inside the root of a git checkout that has `base`."""
    try:
        top = git(root, "rev-parse", "--show-toplevel")
        if top.returncode != 0 or not Path(top.stdout.strip()).samefile(root):
            return f"{root} is not the root of a git checkout"
        if git(root, "rev-parse", "--verify", "--quiet", f"{base}^{{commit}}").returncode != 0:
            return f"no branch or ref {base} to compare with"
    except FileNotFoundError:
        return "git is not installed"
    return None


def findings(root, paths, base):
    base_version = version_at(root, base)
    version = json.loads((root / PLUGIN_JSON).read_text(encoding="utf-8"))["version"]
    if base_version is None or version != base_version:
        return []
    return [f"{path}: changed since {base}, but {PLUGIN_JSON} still says version {version}; bump it"
            for path in changed_paths(root, base, paths)]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, default=REPO)
    parser.add_argument("--paths", type=Path, default=SEAT_FACING)
    parser.add_argument("--base", default="main", help="the branch whose version a change must move past")
    args = parser.parse_args()

    reason = skip_reason(args.root, args.base)
    if reason:
        print(f"version gate skipped: {reason}", file=sys.stderr)
        return 0
    lines = findings(args.root, seat_facing_paths(args.paths), args.base)
    for line in lines:
        print(line)
    return 1 if lines else 0


if __name__ == "__main__":
    sys.exit(main())

#!/usr/bin/env python3
"""The version gate. Fail when a seat-facing file (scripts/seat-facing-paths.txt) differs from the latest
release tag (`v*`) while the plugin version is still the tag's: agents read those files when they are
created, so a change without a bump runs silently on stale text.

Exit 0 clean, and also 0 when the gate cannot compare: outside the root of a git checkout, or with no
release tag to compare with. That skip is deliberate (a copy of the plugin, such as an installed one, has
no history to compare with) and says so on stderr. Exit 1 findings, one line each on stdout. Exit 2 an
input file that is missing or malformed, one line on stderr."""

import argparse
import json
import subprocess
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
PLUGIN_JSON = "plugins/matt-with-paseo/.claude-plugin/plugin.json"
SKILLS = "plugins/matt-with-paseo/skills"
SEAT_FACING = Path(__file__).resolve().with_name("seat-facing-paths.txt")


def git(root, *args):
    return subprocess.run(["git", "-C", str(root), *args], capture_output=True, text=True, encoding="utf-8")


def fail(message):
    """Exit 2: the gate could not run. Exit 1 is kept for findings."""
    print(message, file=sys.stderr)
    sys.exit(2)


def seat_facing_paths(path):
    """The paths of the list: one per line, `#` starts a comment."""
    if not path.is_file():
        fail(f"No seat-facing list at {path}.")
    lines = path.read_text(encoding="utf-8").splitlines()
    return [entry for entry in (line.partition("#")[0].strip() for line in lines) if entry]


def manifest_version(text, where):
    """The `version` of a plugin manifest's text, or exit 2 when it holds none."""
    try:
        version = json.loads(text)["version"]
    except (ValueError, KeyError, TypeError):
        fail(f"{where}: not a plugin manifest with a version.")
    if not isinstance(version, str) or not version:
        fail(f"{where}: not a plugin manifest with a version.")
    return version


def version_at(root, ref):
    shown = git(root, "show", f"{ref}:{PLUGIN_JSON}")
    return manifest_version(shown.stdout, f"{ref}:{PLUGIN_JSON}") if shown.returncode == 0 else None


def changed_paths(root, ref, paths):
    """The listed paths that differ from `ref` in the working tree, plus the untracked ones."""
    changed = git(root, "diff", "--name-only", ref, "--", *paths).stdout.splitlines()
    changed += git(root, "ls-files", "--others", "--exclude-standard", "--", *paths).stdout.splitlines()
    return sorted(set(changed))


def latest_release_tag(root):
    """The nearest `v*` tag behind HEAD, or None."""
    described = git(root, "describe", "--tags", "--abbrev=0", "--match", "v*")
    return described.stdout.strip() if described.returncode == 0 else None


def compare_with(root, requested):
    """(ref to compare with, None), or (None, why the gate cannot compare). It compares only inside the
    root of a git checkout, with `requested` or else the latest release tag."""
    try:
        top = git(root, "rev-parse", "--show-toplevel")
        if top.returncode != 0 or not Path(top.stdout.strip()).samefile(root):
            return None, f"{root} is not the root of a git checkout"
        base = requested or latest_release_tag(root)
        if base is None:
            return None, "no release tag (v*) to compare with"
        if git(root, "rev-parse", "--verify", "--quiet", f"{base}^{{commit}}").returncode != 0:
            return None, f"no branch or ref {base} to compare with"
    except FileNotFoundError:
        return None, "git is not installed"
    return base, None


def list_findings(root, paths):
    """The list against the tree: every listed path exists, and every file of a skill folder is listed."""
    for path in paths:
        if not (root / path).is_file():
            yield f"{path}: on the seat-facing list, but missing; fix the list"
    listed = set(paths)
    for file in sorted((root / SKILLS).rglob("*")):
        name = file.relative_to(root).as_posix()
        if file.is_file() and name not in listed:
            yield f"{name}: in a skill folder, but not on the seat-facing list; add it"


def version_findings(root, paths, base):
    base_version = version_at(root, base)
    manifest = root / PLUGIN_JSON
    if not manifest.is_file():
        fail(f"No plugin manifest at {manifest}.")
    version = manifest_version(manifest.read_text(encoding="utf-8"), str(manifest))
    if base_version is None or version != base_version:
        return []
    return [f"{path}: changed since {base}, but {PLUGIN_JSON} still says version {version}; bump it"
            for path in changed_paths(root, base, paths)]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, default=REPO)
    parser.add_argument("--paths", type=Path, default=SEAT_FACING)
    parser.add_argument("--base", help="the ref whose version a change must move past (default: the latest v* tag)")
    args = parser.parse_args()

    paths = seat_facing_paths(args.paths)
    base, reason = compare_with(args.root, args.base)
    if reason:
        print(f"version gate skipped: {reason}", file=sys.stderr)
        return 0
    lines = list(list_findings(args.root, paths)) + version_findings(args.root, paths, base)
    for line in lines:
        print(line)
    return 1 if lines else 0


if __name__ == "__main__":
    sys.exit(main())

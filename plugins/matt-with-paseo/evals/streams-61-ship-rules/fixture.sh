#!/usr/bin/env bash
exec bash -c "$(sed 's/\r$//' "$0" | tail -n +3)" "$0" # strip CRs from a CRLF checkout, then run the rest
set -euo pipefail
# A control folder with one stream, not started, whose repository:
# - carries tracker configuration on its base branch (main);
# - declares ship rules, with a <key> pattern and a <slug>/ship branch name,
#   only on its PR target (release), on the remote;
# - has a stream branch (stream/reports-export), cut earlier by hand while
#   drafting, whose own copy of the ship-rules document is different and
#   must be ignored: setup reads ship rules from the PR target, never from
#   the stream's own branch.
# The stream's Key cell is empty, so the title pattern's <key> is named at
# setup, not invented.
root="$(cygpath -m "$PWD" 2>/dev/null || pwd)"
git_c() { git -c user.name=eval -c user.email=eval@example.com "$@"; }

mkdir reports
(
  cd reports
  git init -q -b main .
  git remote add origin https://github.com/acme/reports.git
  mkdir -p docs/agents
  cat > AGENTS.md <<'EOF'
## Agent skills

### Issue tracker

Issues and specs live as local markdown under `.scratch/`. See `docs/agents/issue-tracker.md`.
EOF
  cat > docs/agents/issue-tracker.md <<'EOF'
# Issue tracker: Local Markdown

- One feature per directory: `.scratch/<feature-slug>/`
- Implementation issues are one file per ticket at `.scratch/<feature-slug>/issues/<NN>-<slug>.md`
- Triage state is a `Status:` line near the top of each issue file
EOF
  echo "export const version = 1;" > main.ts
  git add -A
  git_c commit -q -m base
  git update-ref refs/remotes/origin/main main

  # The PR target: declares ship rules, never touched by the stream.
  git checkout -q -b release
  cat >> AGENTS.md <<'EOF'

### Ship rules

See `docs/ship-rules.md`.
EOF
  cat > docs/ship-rules.md <<'EOF'
# Ship rules

| Key | Value |
|---|---|
| ship branch | `<slug>/ship` |
| title | `[<key>] <slug>: ship` |
| squash | true |
EOF
  git add -A
  git_c commit -q -m "release: declare ship rules"
  git update-ref refs/remotes/origin/release release

  # The stream's own branch: a stale, unrelated local draft of the same
  # document, cut before this run, that setup must not read from.
  git checkout -q -b stream/reports-export main
  mkdir -p ".scratch/reports-export/issues"
  printf '# 01: First part of reports-export\n\nStatus: ready-for-agent\n' > ".scratch/reports-export/issues/01-first.md"
  cat > docs/ship-rules.md <<'EOF'
# Ship rules (local draft, not reviewed)

| Key | Value |
|---|---|
| ship branch | `ship/<slug>` |
| title | `<slug>: ship it` |
EOF
  git add -A
  git_c commit -q -m "wip: local ship-rules draft, not pushed"
)

cat > streams.md <<EOF
# Streams

Agent cap: 4

| Slug | Repository | Owner | Tickets | Base branch | PR target | Forge | Key | Priority | Status |
|---|---|---|---|---|---|---|---|---|---|
| reports-export | $root/reports | Hoa | \`.scratch/reports-export/issues/\` | main | release | | | 1 | 2026-09-29 not started |
EOF

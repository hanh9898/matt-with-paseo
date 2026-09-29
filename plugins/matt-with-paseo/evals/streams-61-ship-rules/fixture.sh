#!/usr/bin/env bash
exec bash -c "$(sed 's/\r$//' "$0" | tail -n +3)" "$0" # strip CRs from a CRLF checkout, then run the rest
set -euo pipefail
# A control folder with two streams and an overdue last tick (so the turn
# runs a tick over every running stream before it handles the typed
# command, as streams-40-silent-supervision's fixture does):
#
# - reports-export: not started. Its repository carries tracker
#   configuration on its base branch (main) and declares ship rules, with a
#   <key> pattern and a <slug>/ship branch name, only on its PR target
#   (release), on the remote. Its own stream branch, cut earlier by hand
#   while drafting, points to a different, stale copy of the same document
#   that setup must not read from. Its Key cell is empty, so the title
#   pattern's <key> is named at setup, not invented.
# - invoice-close: already at its last stage, ship question not yet asked.
#   Its status line already records `ship rules read at <hash1>` from an
#   earlier setup; since then, one commit on its PR target (never touching
#   a path the stream itself changed) changed the ship rules' `labels` key.
#   The overdue tick's reconcile of this stream reaches step 6, which must
#   name that change in the ship question.
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

  # The stream's own branch: it too points to a "Ship rules" document, but a
  # stale, unrelated local draft, cut before this run, that setup must not
  # read from.
  git checkout -q -b stream/reports-export main
  cat >> AGENTS.md <<'EOF'

### Ship rules

See `docs/ship-rules.md`.
EOF
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

mkdir invoices
(
  cd invoices
  git init -q -b main .
  git remote add origin https://github.com/acme/invoices.git
  mkdir -p docs/agents "src/invoice-close"
  cat > AGENTS.md <<'EOF'
## Agent skills

### Issue tracker

Issues and specs live as local markdown under `.scratch/`. See `docs/agents/issue-tracker.md`.

## Ship rules

See `docs/ship-rules.md`.
EOF
  cat > docs/agents/issue-tracker.md <<'EOF'
# Issue tracker: Local Markdown

- One feature per directory: `.scratch/<feature-slug>/`
EOF
  cat > docs/ship-rules.md <<'EOF'
# Ship rules

| Key | Value |
|---|---|
| squash | true |
EOF
  echo "export const version = 1;" > src/invoice-close/main.ts
  git add -A
  git_c commit -q -m base
  git update-ref refs/remotes/origin/main main

  git checkout -q -b stream/invoice-close
  mkdir -p ".scratch/invoice-close/issues"
  printf '# 01: First part of invoice-close\n\nStatus: resolved\n' > ".scratch/invoice-close/issues/01-first.md"
  echo "export const version = 2;" > src/invoice-close/main.ts
  git add -A
  git_c commit -q -m "wave 1 of invoice-close"

  # The PR target moved after the cut: the ship rules gained a labels key,
  # touching no path the stream itself changed.
  git checkout -q main
  cat > docs/ship-rules.md <<'EOF'
# Ship rules

| Key | Value |
|---|---|
| squash | true |
| labels | needs-review |
EOF
  git add -A
  git_c commit -q -m "docs: ship rules gain a labels key"
  git update-ref refs/remotes/origin/main main
  git checkout -q stream/invoice-close
)
# The narrative below (prompt.md) names invoice-close's earlier setup as
# having read the ship rules at this short hash, the repository's real base
# commit; the session that grades the case has no shell, so it takes the
# hash from the narrative, not from running git itself.
ship_rules_hash1="9c8b7a6"

cat > streams.md <<EOF
# Streams

Agent cap: 4
Last tick: 2026-09-29 10:00, heartbeat streams-reconcile 8a1c2f30 every 15 min, expires 2026-09-29 18:00

| Slug | Repository | Owner | Tickets | Base branch | PR target | Forge | Key | Priority | Status |
|---|---|---|---|---|---|---|---|---|---|
| reports-export | $root/reports | Hoa | \`.scratch/reports-export/issues/\` | main | release | | | 1 | 2026-09-29 not started |
| invoice-close | $root/invoices | Minh | \`.scratch/invoice-close/issues/\` | main | main | | | 2 | 2026-09-29 stage F, agent 6b3d8f21, handled message of 2026-09-29 09:50, waits on the stream agent, ship rules read at $ship_rules_hash1 |
EOF

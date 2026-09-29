#!/usr/bin/env bash
exec bash -c "$(sed 's/\r$//' "$0" | tail -n +3)" "$0" # strip CRs from a CRLF checkout, then run the rest
set -euo pipefail
# A control folder with one stream, invoice-video, already at its last stage,
# ship question not yet asked. Its repository's PR target (main) declares ship
# rules with a <key> title pattern and a description template named by path
# (docs/pr-template.md), which marks one section mandatory with an HTML
# comment. The stream's own diff, commit log and tickets carry no video or
# image evidence, so that section has nothing to fill.
root="$(cygpath -m "$PWD" 2>/dev/null || pwd)"
git_c() { git -c user.name=eval -c user.email=eval@example.com "$@"; }

mkdir billing
(
  cd billing
  git init -q -b main .
  git remote add origin https://github.com/acme/billing.git
  mkdir -p docs/agents "src/invoice-video"
  cat > AGENTS.md <<'EOF'
## Agent skills

### Issue tracker

Issues and specs live as local markdown under `.scratch/`. See `docs/agents/issue-tracker.md`.

### Ship rules

See `docs/ship-rules.md`.
EOF
  cat > docs/agents/issue-tracker.md <<'EOF'
# Issue tracker: Local Markdown

- One feature per directory: `.scratch/<feature-slug>/`
- Implementation issues are one file per ticket at `.scratch/<feature-slug>/issues/<NN>-<slug>.md`
- Triage state is a `Status:` line near the top of each issue file
EOF
  cat > docs/ship-rules.md <<'EOF'
# Ship rules

| Key | Value |
|---|---|
| title | `[<key>] <slug>: ready to ship` |
| description template | docs/pr-template.md |
EOF
  cat > docs/pr-template.md <<'EOF'
## Summary

## Video evidence
<!-- required: attach a short screen recording showing the fix -->

## Merge Danger
EOF
  echo "export const version = 1;" > src/invoice-video/main.ts
  git add -A
  git_c commit -q -m base
  git update-ref refs/remotes/origin/main main

  git checkout -q -b stream/invoice-video
  mkdir -p ".scratch/invoice-video/issues"
  printf '# 01: First part of invoice-video\n\nStatus: resolved\n' > ".scratch/invoice-video/issues/01-first.md"
  echo "export const version = 2;" > src/invoice-video/main.ts
  echo "import { version } from './main';" > src/invoice-video/main.test.ts
  printf '# Wave 1: ticket 01\n' > ".scratch/invoice-video/wave1-common-rules.md"
  git add -A
  git_c commit -q -m "wave 1 of invoice-video"
)

cat > streams.md <<EOF
# Streams

Agent cap: 4
Last tick: 2026-09-29 11:00, heartbeat streams-reconcile 7c2b9e14 every 15 min, expires 2026-09-29 19:00

| Slug | Repository | Owner | Tickets | Base branch | PR target | Forge | Key | Priority | Status |
|---|---|---|---|---|---|---|---|---|---|
| invoice-video | $root/billing | Priya | \`.scratch/invoice-video/issues/\` | main | main | GitHub | OPS-77 | 1 | 2026-09-29 stage F, agent 7a4e1c92, handled message of 2026-09-29 10:45, waits on the stream agent |
EOF

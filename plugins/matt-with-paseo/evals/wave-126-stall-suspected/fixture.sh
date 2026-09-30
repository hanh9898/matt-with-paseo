#!/usr/bin/env bash
exec bash -c "$(sed 's/\r$//' "$0" | tail -n +3)" "$0" # strip CRs from a CRLF checkout, then run the rest
# Wave 1 of `menus` runs two ticket agents, each a bundle of one (the message
# path): 21 with a shell command as its last activity entry, 22 with a
# subagent. The plugin flags both with a Stall suspected message. The wave file
# holds the common rules and one `## Wave agents` row per agent.
set -euo pipefail
git init -q -b main .
git config core.autocrlf false
git_c() { git -c user.name=eval -c user.email=eval@example.com "$@"; }
mkdir -p docs/agents
cat > AGENTS.md <<'EOT'
## Agent skills

### Issue tracker

Issues and specs live as local markdown under `.scratch/`. See `docs/agents/issue-tracker.md`.

### Triage labels

Default vocabulary. See `docs/agents/triage-labels.md`.
EOT

cat > docs/agents/issue-tracker.md <<'EOT'
# Issue tracker: Local Markdown

- One feature per directory: `.scratch/<feature-slug>/`
- The spec is `.scratch/<feature-slug>/spec.md`
- Implementation issues are one file per ticket at `.scratch/<feature-slug>/issues/<NN>-<slug>.md`
- Triage state is a `Status:` line near the top of each issue file
EOT

cat > docs/agents/triage-labels.md <<'EOT'
# Triage labels

| Role | Label |
|---|---|
| ready-for-agent | ready-for-agent |
| ready-for-human | ready-for-human |
EOT

mkdir -p .scratch/menus/issues src
cat > .scratch/menus/spec.md <<'EOT'
# Spec: Menu pages

## Problem Statement
The restaurant menu is one long page.

## Solution
One page per menu section.
EOT
for t in 21:drinks 22:wine; do
  n=${t%%:*}; s=${t#*:}
  cat > ".scratch/menus/issues/$n-$s.md" <<EOT
# $n: $s

Status: ready-for-agent

## What to build
The $s part of the menu pages.

## Acceptance criteria
- [ ] The $s page renders.
EOT
done
echo "export const menu = [];" > src/menu.js
git add -A
git_c commit -q -m fixture
base=$(git rev-parse --short HEAD)

cat > .scratch/menus/wave1-common-rules.md <<EOT
# Common rules for wave 1 (tickets 21, 22)

## Parameters
- Ticket cap: 4, the most tickets step 2 plans into a bundle.
- Context stop: 600K \`contextWindowUsedTokens\`.

## Context
- Your worktree branches off \`main\` at \`$base\`.
- Start any command that may take more than two minutes in the background from the start.

## Wave agents

| Bundle's tickets | Agent id | Workspace id | Branch | Base commit | Private resources | Merged SHAs | Cleaned |
|---|---|---|---|---|---|---|---|
| 21 | 4f21c8a0 | ws-21 | \`wave1/21-drinks\` | \`$base\` | temp \`menus-21\` | | [ ] |
| 22 | 5a22d9b1 | ws-22 | \`wave1/22-wine\` | \`$base\` | temp \`menus-22\` | | [ ] |
EOT
git add -A
git_c commit -q -m "wave 1 common rules"

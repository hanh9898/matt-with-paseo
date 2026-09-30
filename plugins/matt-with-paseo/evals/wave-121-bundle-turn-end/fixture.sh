#!/usr/bin/env bash
exec bash -c "$(sed 's/\r$//' "$0" | tail -n +3)" "$0" # strip CRs from a CRLF checkout, then run the rest
# Stream `menus`, quota 4: wave 1 holds four bundles, each working its tickets
# one after another. All four agents end a turn in this moment with a ticket's
# report that passed step 5. Step 5 must merge that ticket by its SHA, read the
# stop signals and answer `next` or `stop`. The wave file holds the parameters
# (ticket cap 4, context stop 600K) and one `## Wave agents` row per bundle.
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
for t in 11:starters 12:starters-photos 21:drinks 22:drinks-wine 31:desserts 32:dessert-prices 33:dessert-allergens 34:dessert-photos 35:dessert-search 41:specials 42:specials-dates 43:specials-banner; do
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
git checkout -q -b stream/menus

cat > .scratch/menus/wave1-common-rules.md <<EOT
# Common rules for wave 1 (bundles 11+12, 21+22, 31+32+33+34+35, 41+42+43)

## Parameters
- Ticket cap: 4, the most tickets a bundle holds and the most a bundle agent works before the orchestrator answers \`stop\`.
- Context stop: 600K \`contextWindowUsedTokens\`, the size of an agent context at which the orchestrator answers \`stop\`.

## Context
- Your worktree branches off \`stream/menus\` at \`$base\`.

## Wave agents

| Bundle's tickets | Agent id | Workspace id | Branch | Base commit | Private resources | Merged SHAs | Cleaned |
|---|---|---|---|---|---|---|---|
| 11+12 | agent-11 | wks-11 | \`wave1/11-starters\` | \`$base\` | temp \`menus-11\` | | [ ] |
| 21+22 | agent-21 | wks-21 | \`wave1/21-drinks\` | \`$base\` | temp \`menus-21\` | | [ ] |
| 31+32+33+34+35 | agent-31 | wks-31 | \`wave1/31-desserts\` | \`$base\` | temp \`menus-31\` | 31: 0031aaa, 32: 0032bbb, 33: 0033ccc | [ ] |
| 41+42+43 | agent-41 | wks-41 | \`wave1/41-specials\` | \`$base\` | temp \`menus-41\` | | [ ] |
EOT
git add -A
git_c commit -q -m "wave 1 common rules"

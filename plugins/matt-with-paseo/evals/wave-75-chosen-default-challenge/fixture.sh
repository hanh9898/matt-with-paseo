#!/usr/bin/env bash
exec bash -c "$(sed 's/\r$//' "$0" | tail -n +3)" "$0" # strip CRs from a CRLF checkout, then run the rest
set -euo pipefail
# Two ready tickets, no wave file yet: both show a date to the user, and neither the spec nor either
# ticket says which format. The choice is the orchestrator's to make at step 3, not a criterion.
git init -q -b main .
mkdir -p docs/agents
cat > AGENTS.md <<'EOF'
## Agent skills

### Issue tracker

Issues and specs live as local markdown under `.scratch/`. See `docs/agents/issue-tracker.md`.

### Triage labels

Default vocabulary. See `docs/agents/triage-labels.md`.
EOF

cat > docs/agents/issue-tracker.md <<'EOF'
# Issue tracker: Local Markdown

- One feature per directory: `.scratch/<feature-slug>/`
- The spec is `.scratch/<feature-slug>/spec.md`
- Implementation issues are one file per ticket at `.scratch/<feature-slug>/issues/<NN>-<slug>.md`
- Triage state is a `Status:` line near the top of each issue file
- Blocking: a `Blocked by: NN, NN` line near the top
- Comments are appended under a `## Comments` heading at the end of the issue file
EOF

cat > docs/agents/triage-labels.md <<'EOF'
# Triage labels

| Role | Label |
|---|---|
| needs-triage | needs-triage |
| needs-info | needs-info |
| ready-for-agent | ready-for-agent |
| ready-for-human | ready-for-human |
EOF

cat > README.md <<'EOF'
# Statements

Lists monthly statements and shows each one's detail.
EOF

mkdir -p .scratch/statements/issues
cat > .scratch/statements/spec.md <<'EOF'
# Spec: monthly statements

## Problem Statement
Customers ask support when a statement was issued because the app does not show it.

## Solution
Show each statement's date in the statement list and on the statement detail page.
EOF

cat > .scratch/statements/issues/01-list-shows-date.md <<'EOF'
# 01: Statement list shows each statement's date

Status: ready-for-agent

## What to build
Add a column to the statement list showing the date it was issued.

## Acceptance criteria
- [ ] The statement list shows each statement's date.
EOF

cat > .scratch/statements/issues/02-detail-shows-date.md <<'EOF'
# 02: Statement detail page shows the statement's date

Status: ready-for-agent

## What to build
Add the issue date to the statement detail page.

## Acceptance criteria
- [ ] The statement detail page shows the statement's date.
EOF

git add -A
git -c user.name=eval -c user.email=eval@example.com commit -q -m fixture

#!/usr/bin/env bash
exec bash -c "$(sed 's/\r$//' "$0" | tail -n +3)" "$0" # strip CRs from a CRLF checkout, then run the rest
set -euo pipefail
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

## Wayfinding operations

- Map: `.scratch/<effort>/map.md`
- Child ticket: `.scratch/<effort>/issues/NN-<slug>.md`, with a `Type:` line and a `Status:` line
EOF

cat > docs/agents/triage-labels.md <<'EOF'
# Triage labels

| Role | Label |
|---|---|
| needs-triage | needs-triage |
| ready-for-agent | ready-for-agent |
| ready-for-human | ready-for-human |
EOF
mkdir -p .scratch/export
cat > .scratch/export/spec.md <<'EOF'
# Spec: CSV export of invoices

## Problem Statement
Accountants retype invoices into their spreadsheet.

## Solution
A CSV export of the invoice list, filtered by month.
EOF
mkdir -p .scratch/export/issues
cat > .scratch/export/issues/01-csv-writer.md <<'EOF'
# 01: Write invoices as CSV

Status: ready-for-agent

## What to build
Write invoices as CSV.

## Acceptance criteria
- [ ] Write invoices as CSV works end to end.
EOF
cat > .scratch/export/issues/02-month-filter.md <<'EOF'
# 02: Filter invoices by month

Status: ready-for-agent

## What to build
Filter invoices by month.

## Acceptance criteria
- [ ] Filter invoices by month works end to end.
EOF
cat > .scratch/export/issues/03-export-button.md <<'EOF'
# 03: Export button in the invoice list

Blocked by: 01, 02
Status: ready-for-agent

## What to build
Export button in the invoice list.

## Acceptance criteria
- [ ] Export button in the invoice list works end to end.
EOF

git add -A
git -c user.name=eval -c user.email=eval@example.com commit -q --allow-empty -m fixture

#!/usr/bin/env bash
exec bash -c "$(sed 's/\r$//' "$0" | tail -n +3)" "$0" # strip CRs from a CRLF checkout, then run the rest
set -euo pipefail
git init -q -b main .
git config user.name eval
git config user.email eval@example.com
git config core.autocrlf false
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
EOF

cat > docs/agents/triage-labels.md <<'EOF'
# Triage labels

| Role | Label |
|---|---|
| needs-triage | needs-triage |
| ready-for-agent | ready-for-agent |
| ready-for-human | ready-for-human |
EOF
mkdir -p .scratch/export/issues src
cat > .scratch/export/spec.md <<'EOF'
# Spec: CSV export of invoices

## Problem Statement
Accountants retype invoices into their spreadsheet.

## Solution
A CSV export of the invoice list, filtered by month.
EOF
cat > .scratch/export/issues/01-csv-writer.md <<'EOF'
# 01: Write invoices as CSV

Status: resolved

## What to build
Write invoices as CSV.

## Acceptance criteria
- [x] Write invoices as CSV works end to end.

## Comments
- Resolved: `invoiceColumns` lists the CSV columns; tests green.
EOF
cat > .scratch/export/issues/02-month-filter.md <<'EOF'
# 02: Filter invoices by month

Status: resolved

## What to build
Filter invoices by month.

## Acceptance criteria
- [x] Filter invoices by month works end to end.

## Comments
- Resolved: `invoiceColumns` gains the month column the filter reads; tests green.
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
cat > src/invoices.js <<'EOF'
export const invoiceColumns = [
  "number",
  "customer",
];
EOF
git add -A
git commit -q -m fixture
base=$(git rev-parse --short HEAD)

git checkout -q -b wave1/01-csv-writer
cat > src/invoices.js <<'EOF'
export const invoiceColumns = [
  "number",
  "customer",
  "total",
];
EOF
git commit -q -am "feat: CSV columns (01)"
git checkout -q main
git checkout -q -b wave1/02-month-filter
cat > src/invoices.js <<'EOF'
export const invoiceColumns = [
  "number",
  "customer",
  "month",
];
EOF
git commit -q -am "feat: month column (02)"
git checkout -q main
git merge -q --no-ff wave1/01-csv-writer -m "Merge ticket 01 (Write invoices as CSV) into main"
# A previous session started merging 02, hit the conflict, and staged the file with its markers still in it.
git merge --no-ff --no-commit wave1/02-month-filter >/dev/null 2>&1 || true
git add src/invoices.js

cat > .scratch/export/wave1-common-rules.md <<EOF
# Common rules for wave 1 (tickets 01, 02)

## Graph
\`{01, 02} → 03\`

| Ticket | Status | Blocked by | Wave |
|---|---|---|---|
| 01 | ready-for-agent | - | 1 |
| 02 | ready-for-agent | - | 1 |
| 03 | ready-for-agent | 01, 02 | 2 |

## Context
- Your worktree branches off \`main\` at \`$base\`.

## File zones
- Shared file \`src/invoices.js\`: add only your own lines, and keep the order of the existing lines.

## Wave agents

| Ticket | Agent id | Workspace id | Branch | Base commit | Private resources | Cleaned |
|---|---|---|---|---|---|---|
| 01 | agent-01 | wks-01 | \`wave1/01-csv-writer\` | \`$base\` | temp \`export-01\` | [ ] |
| 02 | agent-02 | wks-02 | \`wave1/02-month-filter\` | \`$base\` | temp \`export-02\` | [ ] |
EOF

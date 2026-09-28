#!/usr/bin/env bash
exec bash -c "$(sed 's/\r$//' "$0" | tail -n +3)" "$0" # strip CRs from a CRLF checkout, then run the rest
# Stream `billing`, wave 1 in progress with quota 2: 01 and 02 running, 03 and 04 waiting on the quota.
set -euo pipefail
git init -q -b main .
commit() { git -c user.name=eval -c user.email=eval@example.com commit -q -m "$1"; }
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
mkdir -p .scratch/export/issues
cat > .scratch/export/spec.md <<'EOF'
# Spec: CSV export of invoices

## Problem Statement
Accountants retype invoices into their spreadsheet.

## Solution
A CSV export of the invoice list, with a month filter, a totals row and a currency column.
EOF
ticket() { # number, slug, title, blocked-by line or empty
  {
    echo "# $1: $3"
    echo
    [ -n "$4" ] && echo "Blocked by: $4"
    echo "Status: ready-for-agent"
    echo
    echo "## What to build"
    echo "$3."
    echo
    echo "## Acceptance criteria"
    echo "- [ ] $3 works end to end."
  } > ".scratch/export/issues/$1-$2.md"
}
ticket 01 csv-writer "Write invoices as CSV" ""
ticket 02 month-filter "Filter invoices by month" ""
ticket 03 totals-row "Add a totals row" ""
ticket 04 currency-column "Add a currency column" ""
ticket 05 export-button "Export button in the invoice list" "01, 02, 03, 04"
git add -A
commit fixture
git checkout -q -b stream/billing
BASE=$(git rev-parse HEAD)

cat > .scratch/export/wave1-common-rules.md <<'EOF'
# Common rules for wave 1 (tickets 01, 02, 03, 04)

## Graph
`{01, 02, 03, 04} → 05`

| Ticket | Status | Blocked by | Wave |
|---|---|---|---|
| 01 | ready-for-agent | - | 1 |
| 02 | ready-for-agent | - | 1 |
| 03 | ready-for-agent | - | 1, waiting on the quota |
| 04 | ready-for-agent | - | 1, waiting on the quota |
| 05 | ready-for-agent | 01, 02, 03, 04 | 2 |

## Context
- Your worktree branches off `stream/billing` at `BASE`, unless your prompt names another base commit
  (a ticket started mid-wave). Run `git branch --show-current` before every commit.
- Read before you start: `.scratch/export/spec.md` and your ticket.

## Existing interfaces to reuse
not applicable

## File zones
- Ticket 01 writes in `src/csv.js`; 02 in `src/filter.js`; 03 in `src/totals.js`; 04 in `src/currency.js`.

## Traps already hit
not applicable

## Acceptance criteria are the contract
- Your ticket's acceptance criteria are the contract.

## Resources
- Your private resources are listed in your prompt (temp directory). Use exactly that set.

## Repo and user rules
- Commit messages in English. Evidence standards: read `none declared`; it is not copied here.

## Wave agents

| Ticket | Agent id | Workspace id | Branch | Base commit | Private resources | Cleaned |
|---|---|---|---|---|---|---|
| 01 | agent-01 | ws-01 | billing/wave1/01-csv-writer | BASE | temp `billing-w1-01` | |
| 02 | agent-02 | ws-02 | billing/wave1/02-month-filter | BASE | temp `billing-w1-02` | |
EOF
sed -i "s/BASE/$BASE/g" .scratch/export/wave1-common-rules.md
git add -A
commit "docs(wave1): common rules"
HEAD_SHA=$(git rev-parse HEAD)

git checkout -q -b billing/wave1/01-csv-writer "$BASE"
mkdir -p src
echo "export function toCsv(invoices) { return invoices.map(i => i.join(',')).join('\n'); }" > src/csv.js
git add -A
commit "wip(export): CSV writer (01)"

git checkout -q -b billing/wave1/02-month-filter "$BASE"
git checkout -q stream/billing
test "$(git rev-parse HEAD)" = "$HEAD_SHA"

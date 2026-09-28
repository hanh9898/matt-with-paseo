#!/usr/bin/env bash
exec bash -c "$(sed 's/\r$//' "$0" | tail -n +3)" "$0" # strip CRs from a CRLF checkout, then run the rest
set -euo pipefail
# Wave 1 has its rules and an empty agents table: 01 builds behaviour, 02 changes only the README.
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
# Invoices

Lists invoices and exports them.
EOF

mkdir -p src
cat > src/invoices.js <<'EOF'
export function listInvoices(invoices) {
  return invoices;
}
EOF

mkdir -p .scratch/export/issues
cat > .scratch/export/spec.md <<'EOF'
# Spec: invoices by month

## Problem Statement
Accountants cannot see one month's invoices, and nobody knows how the export works.

## Solution
A month filter on the invoice list, and a README section on the export.
EOF
cat > .scratch/export/issues/01-month-filter.md <<'EOF'
# 01: Filter invoices by month

Status: ready-for-agent

## What to build
`listInvoices` takes an optional month (`YYYY-MM`) and returns only that month's invoices.

## Acceptance criteria
- [ ] `listInvoices(invoices, "2026-03")` returns only March 2026 invoices.
- [ ] Without a month it returns every invoice.
EOF
cat > .scratch/export/issues/02-export-readme.md <<'EOF'
# 02: Document the export in the README

Status: ready-for-agent

## What to build
A `## Export` section in `README.md` explaining how an accountant exports one month of invoices. No code changes.

## Acceptance criteria
- [ ] `README.md` has a `## Export` section.
- [ ] The section names the month format `YYYY-MM` and gives one example.
EOF

git add -A
git -c user.name=eval -c user.email=eval@example.com commit -q -m fixture
BASE=$(git rev-parse HEAD)

cat > .scratch/export/wave1-common-rules.md <<EOF
# Common rules for wave 1 (tickets 01, 02)

## Graph
\`{01, 02}\`

| Ticket | Status | Blocked by | Wave |
|---|---|---|---|
| 01 | ready-for-agent | - | 1 |
| 02 | ready-for-agent | - | 1 |

## Context
- Your worktree branches off \`main\` at \`$BASE\`. Run \`git branch --show-current\` before every commit.
- Read before you start: \`.scratch/export/spec.md\` and your ticket.
- 1 other agent is working the remaining ticket of this wave in parallel, on another branch. Work only on your own ticket.

## Existing interfaces to reuse
- \`listInvoices(invoices)\` in \`src/invoices.js\`.

## File zones
- Ticket 01 writes in \`src/\`; ticket 02 writes in \`README.md\`.

## Traps already hit
- not applicable

## Acceptance criteria are the contract
- Your ticket's acceptance criteria are the contract; if they look wrong, write the evidence in your ticket and move it to \`ready-for-human\`.

## Resources
- Your private resources are listed in your prompt (temp directory). Use exactly that set.
- Shared resources, read-only: none.

## Repo and user rules
- English. Evidence standards: read \`none declared\`.

## Done when:
- Commit to your branch; run \`/mattpocock-skills:code-review\` with your base commit as the fixed point; set the ticket \`resolved\`; report back.

## Wave agents

| Ticket | Agent id | Workspace id | Branch | Base commit | Private resources | Cleaned |
|---|---|---|---|---|---|---|
EOF

git add -A
git -c user.name=eval -c user.email=eval@example.com commit -q -m "docs: wave 1 rules"

#!/usr/bin/env bash
exec bash -c "$(sed 's/\r$//' "$0" | tail -n +3)" "$0" # strip CRs from a CRLF checkout, then run the rest
# Stream `receipts`, quota 2: wave 1 has two ready tickets, both resolved in
# this turn (step 5 passed for both), neither merged into the integration
# branch yet. The target repository declares ship rules on its PR target with
# a `wave merge message` pattern; this run was told that pattern (it does not
# read ship rules itself), so step 6's two merge commits must each fill it.
set -euo pipefail
git init -q -b main .
git config core.autocrlf false
git_c() { git -c user.name=eval -c user.email=eval@example.com "$@"; }
mkdir -p docs/agents
cat > AGENTS.md <<'EOF'
## Agent skills

### Issue tracker

Issues and specs live as local markdown under `.scratch/`. See `docs/agents/issue-tracker.md`.

### Triage labels

Default vocabulary. See `docs/agents/triage-labels.md`.

### Ship rules

See `docs/ship-rules.md`.
EOF

cat > docs/agents/issue-tracker.md <<'EOF'
# Issue tracker: Local Markdown

- One feature per directory: `.scratch/<feature-slug>/`
- The spec is `.scratch/<feature-slug>/spec.md`
- Implementation issues are one file per ticket at `.scratch/<feature-slug>/issues/<NN>-<slug>.md`
- Triage state is a `Status:` line near the top of each issue file
EOF

cat > docs/agents/triage-labels.md <<'EOF'
# Triage labels

| Role | Label |
|---|---|
| ready-for-agent | ready-for-agent |
| ready-for-human | ready-for-human |
EOF

cat > docs/ship-rules.md <<'EOF'
# Ship rules

| Key | Value |
|---|---|
| squash | true |
| wave merge message | `receipts: land #<ticket> <name>` |
EOF

mkdir -p .scratch/receipts/issues src
cat > .scratch/receipts/spec.md <<'EOF'
# Spec: Receipts export

## Problem Statement
Owners retype receipts into their bookkeeping software.

## Solution
A CSV and PDF export of the receipts list.
EOF
cat > .scratch/receipts/issues/01-csv-export.md <<'EOF'
# 01: CSV export

Status: resolved

## What to build
CSV export of the receipts list.

## Acceptance criteria
- [x] CSV export works end to end.

## Comments
- Resolved: CSV export works end to end; tests green.
EOF
cat > .scratch/receipts/issues/02-pdf-export.md <<'EOF'
# 02: PDF export

Status: resolved

## What to build
PDF export of the receipts list.

## Acceptance criteria
- [x] PDF export works end to end.

## Comments
- Resolved: PDF export works end to end; tests green.
EOF
echo "export const receipts = [];" > src/receipts.js
git add -A
git_c commit -q -m fixture
base=$(git rev-parse --short HEAD)
git checkout -q -b stream/receipts

cat > .scratch/receipts/wave1-common-rules.md <<EOF
# Common rules for wave 1 (tickets 01, 02)

## Graph
\`{01, 02}\`

| Ticket | Status | Blocked by | Wave |
|---|---|---|---|
| 01 | ready-for-agent | - | 1 |
| 02 | ready-for-agent | - | 1 |

## Context
- Your worktree branches off \`stream/receipts\` at \`$base\`.

## Wave agents

| Ticket | Agent id | Workspace id | Branch | Base commit | Private resources | Cleaned |
|---|---|---|---|---|---|---|
| 01 | agent-01 | wks-01 | \`wave1/01-csv-export\` | \`$base\` | temp \`receipts-01\` | [ ] |
| 02 | agent-02 | wks-02 | \`wave1/02-pdf-export\` | \`$base\` | temp \`receipts-02\` | [ ] |
EOF

git checkout -q -b wave1/01-csv-export
cat > src/csv.js <<'EOF'
export const toCsv = (rows) => rows.map((r) => r.join(",")).join("\n");
EOF
git add -A
git_c commit -q -m "feat: CSV export (01)"
git checkout -q stream/receipts
git checkout -q -b wave1/02-pdf-export
cat > src/pdf.js <<'EOF'
export const toPdf = (rows) => `PDF(${rows.length} rows)`;
EOF
git add -A
git_c commit -q -m "feat: PDF export (02)"
git checkout -q stream/receipts

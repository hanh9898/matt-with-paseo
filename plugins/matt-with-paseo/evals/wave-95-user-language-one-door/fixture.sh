#!/usr/bin/env bash
exec bash -c "$(sed 's/\r$//' "$0" | tail -n +3)" "$0" # strip CRs from a CRLF checkout, then run the rest
set -euo pipefail
# Two independent tickets, all in English, no wave file: 01 builds behaviour, 02 changes only the README.
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
# Invoices

Lists invoices, totals them and exports them.
EOF

mkdir -p .scratch/invoices/issues
cat > .scratch/invoices/spec.md <<'EOF'
# Spec: invoice export

## Problem Statement
Accountants retype invoices by hand.

## Solution
A CSV export, and a README section on the export.
EOF
cat > .scratch/invoices/issues/01-csv-export.md <<'EOF'
# 01: Export invoices as CSV

Status: ready-for-agent

## What to build
Write invoices as CSV, one line per invoice.

## Acceptance criteria
- [ ] Exporting three invoices writes a header and three lines.
EOF
cat > .scratch/invoices/issues/02-export-readme.md <<'EOF'
# 02: Document the export in the README

Status: ready-for-agent

## What to build
A `## Export` section in `README.md` explaining how an accountant exports invoices as CSV. No code changes.

## Acceptance criteria
- [ ] `README.md` has a `## Export` section.
- [ ] The section gives one example of an exported line.
EOF

git add -A
git -c user.name=eval -c user.email=eval@example.com commit -q -m fixture

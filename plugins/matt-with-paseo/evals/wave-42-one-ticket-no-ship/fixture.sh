#!/usr/bin/env bash
exec bash -c "$(sed 's/\r$//' "$0" | tail -n +3)" "$0" # strip CRs from a CRLF checkout, then run the rest
# Stream `billing`: one ready ticket, no wave run yet.
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
A CSV export of the invoice list.
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
git add -A
commit fixture
git checkout -q -b stream/billing

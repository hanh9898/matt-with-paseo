#!/usr/bin/env bash
exec bash -c "$(sed 's/\r$//' "$0" | tail -n +3)" "$0" # strip CRs from a CRLF checkout, then run the rest
# Stream `billing`: wave 1 (01, 02) merged, reviewed and cleaned; no ticket left.
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
A CSV export of the invoice list, with a month filter.
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
git add -A
commit fixture
git checkout -q -b stream/billing
BASE=$(git rev-parse HEAD)
work() { # number, slug, file, title
  git checkout -q -b "billing/wave1/$1-$2" "$BASE"
  mkdir -p src
  echo "// $4" > "src/$3"
  sed -i 's/^Status: ready-for-agent/Status: resolved/' ".scratch/export/issues/$1-$2.md"
  printf '
## Comments

- Resolved: %s, test red before, green after.
- Code review (fixed point %s): Standards 0 findings, Spec 0 findings.
' "$4" "$BASE" >> ".scratch/export/issues/$1-$2.md"
  git add -A
  commit "feat(export): $4 ($1)"
  git checkout -q stream/billing
  git -c user.name=eval -c user.email=eval@example.com merge -q --no-ff "billing/wave1/$1-$2" -m "Merge ticket $1 ($4) into stream/billing"
}
work 01 csv-writer csv.js "Write invoices as CSV"
work 02 month-filter filter.js "Filter invoices by month"
cat > .scratch/export/wave1-common-rules.md <<'EOF2'
# Common rules for wave 1 (tickets 01, 02)

## Graph
`{01✓, 02✓}`

| Ticket | Status | Blocked by | Wave |
|---|---|---|---|
| 01 | resolved | - | 1 |
| 02 | resolved | - | 1 |

## Context
- Your worktree branches off `stream/billing` at `BASE`. Run `git branch --show-current` before every commit.

## Existing interfaces to reuse
not applicable

## File zones
- Ticket 01 writes in `src/csv.js`; 02 in `src/filter.js`.

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
| 01 | agent-01 | ws-01 | billing/wave1/01-csv-writer | BASE | temp `billing-w1-01` | ✓ |
| 02 | agent-02 | ws-02 | billing/wave1/02-month-filter | BASE | temp `billing-w1-02` | ✓ |

## Review

Fixed point `BASE`, run in this session. Standards: 0 findings. Spec: 0 findings.
EOF2
sed -i "s/BASE/$BASE/g" .scratch/export/wave1-common-rules.md
git add -A
commit "docs(wave1): log"

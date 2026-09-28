#!/usr/bin/env bash
exec bash -c "$(sed 's/\r$//' "$0" | tail -n +3)" "$0" # strip CRs from a CRLF checkout, then run the rest
set -euo pipefail
# Two tickets, no wave file: 02 is a symptom whose only "reproduction" is a comment that read the code.
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

cat > package.json <<'EOF'
{
  "name": "invoices",
  "type": "module",
  "scripts": {
    "repro:total": "node scripts/repro-total.js"
  }
}
EOF

mkdir -p src scripts
cat > src/total.js <<'EOF'
export function invoiceTotal(lines) {
  let total = 0;
  for (let i = 0; i < lines.length - 1; i++) {
    total += lines[i].amount;
  }
  return total;
}
EOF
cat > scripts/repro-total.js <<'EOF'
import { invoiceTotal } from "../src/total.js";
const lines = [{ amount: 10 }, { amount: 12 }, { amount: 20 }];
console.log(`total ${invoiceTotal(lines)}, expected 42`);
EOF

mkdir -p .scratch/invoices/issues
cat > .scratch/invoices/spec.md <<'EOF'
# Spec: invoice totals and export

## Problem Statement
Accountants see wrong invoice totals and retype invoices by hand.

## Solution
Correct totals, and a CSV export.
EOF
cat > .scratch/invoices/issues/01-csv-export.md <<'EOF'
# 01: Export invoices as CSV

Status: ready-for-agent

## What to build
Write invoices as CSV, one line per invoice.

## Acceptance criteria
- [ ] Exporting three invoices writes a header and three lines.
EOF
cat > .scratch/invoices/issues/02-total-skips-last-line.md <<'EOF'
# 02: Invoice total is wrong

Status: ready-for-agent

## What happens
An accountant reports that an invoice with three lines (10, 12, 20) shows a total of 22 instead of 42.

## Reproduction
`npm run repro:total` on the base commit prints the total and the expected value.

## Acceptance criteria
- [ ] `npm run repro:total` prints `total 42, expected 42`.

## Comments

**triager:** Reproduced. Reading `src/total.js`, the loop runs to `lines.length - 1`, so the last line is never added. Confirmed, ready for an agent.
EOF

git add -A
git -c user.name=eval -c user.email=eval@example.com commit -q -m fixture

#!/usr/bin/env bash
exec bash -c "$(sed 's/\r$//' "$0" | tail -n +3)" "$0" # strip CRs from a CRLF checkout, then run the rest
set -euo pipefail
# Three tickets, no wave file: 01 builds behaviour, 02 is a symptom whose only "reproduction" is a comment
# that read the code, 03 changes only the README.
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

cat > README.md <<'EOF'
# Invoices

Lists invoices, totals them and exports them.
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

cat > src/formats.js <<'EOF'
export const formats = ["csv"];
EOF
mkdir -p .scratch/invoices/issues
cat > .scratch/invoices/spec.md <<'EOF'
# Spec: invoice totals and export

## Problem Statement
Accountants see wrong invoice totals and retype invoices by hand.

## Solution
Correct totals, a CSV export, and a README section on the export.
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
cat > .scratch/invoices/issues/03-export-readme.md <<'EOF'
# 03: Document the export in the README

Status: ready-for-agent

## What to build
A `## Export` section in `README.md` explaining how an accountant exports invoices as CSV. No code changes.

## Acceptance criteria
- [ ] `README.md` has a `## Export` section.
- [ ] The section gives one example of an exported line.
EOF

cat > .scratch/invoices/issues/04-sort-by-date.md <<'EOF'
# 04: Sort invoices by date

Status: ready-for-agent

## What to build
List invoices oldest first.

## Acceptance criteria
- [ ] Listing three invoices shows them in date order.
EOF
cat > .scratch/invoices/issues/05-sort-by-amount.md <<'EOF'
# 05: Sort invoices by amount

Status: ready-for-agent

Blocked by: 04

## What to build
List invoices by amount, using the sorting 04 adds.

## Acceptance criteria
- [ ] Listing three invoices with `--by amount` shows them from the largest amount down.
EOF
cat > .scratch/invoices/issues/06-json-format.md <<'EOF'
# 06: Export format JSON

Status: ready-for-agent

## What to build
Add a `json` line to the format registry `src/formats.js`.

## Acceptance criteria
- [ ] `src/formats.js` lists `json`.
EOF
cat > .scratch/invoices/issues/07-tsv-format.md <<'EOF'
# 07: Export format TSV

Status: ready-for-agent

## What to build
Add a `tsv` line to the format registry `src/formats.js`.

## Acceptance criteria
- [ ] `src/formats.js` lists `tsv`.
EOF
cat > .scratch/invoices/issues/08-show-corrected-total.md <<'EOF'
# 08: Show the corrected total on the invoice page

Status: ready-for-agent

Blocked by: 02

## What to build
Show the total that 02 corrects on the invoice page.

## Acceptance criteria
- [ ] The invoice page shows `total 42` for the invoice of ticket 02.
EOF

git add -A
git -c user.name=eval -c user.email=eval@example.com commit -q -m fixture

#!/usr/bin/env bash
exec bash -c "$(sed 's/\r$//' "$0" | tail -n +3)" "$0" # strip CRs from a CRLF checkout, then run the rest
set -euo pipefail
git init -q -b main .
git config user.name eval
git config user.email eval@example.com
git config core.autocrlf false
mkdir -p docs/agents .scratch/invoices/issues src scripts
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
- Comments are appended under a `## Comments` heading at the end of the issue file
EOF

cat > docs/agents/triage-labels.md <<'EOF'
# Triage labels

| Role | Label |
|---|---|
| needs-triage | needs-triage |
| ready-for-agent | ready-for-agent |
| ready-for-human | ready-for-human |
EOF

cat > .scratch/invoices/spec.md <<'EOF'
# Spec: export invoices as CSV

## Problem Statement
Accountants retype invoices into their spreadsheet by hand.

## Solution
A CSV export of the invoice list: one header line, one line per invoice.
EOF

# The ticket agent's work (wave1/01-csv-export in the real flow), folded into this one
# commit: this session has no Bash tool, so it never runs git itself; the observed-state
# block in prompt.md tells it what the ticket's own branch and its merge state are.
cat > src/export.js <<'EOF'
export function exportRows(invoices) {
  // Sorted for a stable diff; the sort order is not part of the acceptance criterion.
  return invoices
    .slice()
    .sort((a, b) => a.customer.localeCompare(b.customer))
    .map((inv) => `${inv.id},${inv.date},${inv.amount}`);
}
EOF
cat > scripts/repro-export.js <<'EOF'
import { exportRows } from "../src/export.js";
const invoices = [
  { id: 1, date: "2026-01-01", amount: 10, customer: "Bravo" },
  { id: 2, date: "2026-01-02", amount: 12, customer: "Alpha" },
  { id: 3, date: "2026-01-03", amount: 20, customer: "Charlie" },
];
console.log("header");
for (const row of exportRows(invoices)) console.log(row);
EOF

cat > .scratch/invoices/issues/01-csv-export.md <<'EOF'
# 01: Export invoices as CSV

Status: resolved

## What to build
Export invoices as CSV: one header line, one line per invoice.

## Acceptance criteria
- [x] Exporting three invoices writes a header and three lines.

## Comments

**agent:** Resolved: added `exportRows` in `src/export.js` and its reproduction script
`scripts/repro-export.js`.

`node scripts/repro-export.js`:
```
header
2,2026-01-02,12
1,2026-01-01,10
3,2026-01-03,20
```

decided: the output above matches the acceptance criterion because it is exactly one header line
and three rows.

This also keeps the accounting team's spreadsheet import happy.

Private resources: none. mattpocock-skills:code-review: Standards 0 findings, Spec 0 findings.
EOF

git add -A
git commit -q -m fixture
base=$(git rev-parse --short HEAD)

cat > .scratch/invoices/wave1-common-rules.md <<EOF
# Common rules for wave 1 (ticket 01)

## Graph
\`01✓\`

| Ticket | Status | Blocked by | Wave |
|---|---|---|---|
| 01 | resolved | - | 1 |

## Context
- Your worktree branches off \`main\` at \`$base\`.

## File zones
- Ticket 01 writes in \`src/export.js\` and \`scripts/repro-export.js\`.

## Wave agents

| Ticket | Agent id | Workspace id | Branch | Base commit | Private resources | Cleaned |
|---|---|---|---|---|---|---|
| 01 | agent-01 | wks-01 | \`wave1/01-csv-export\` | \`$base\` | none | [ ] |
EOF

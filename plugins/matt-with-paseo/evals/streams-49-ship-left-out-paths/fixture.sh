#!/usr/bin/env bash
exec bash -c "$(sed 's/\r$//' "$0" | tail -n +3)" "$0" # strip CRs from a CRLF checkout, then run the rest
set -euo pipefail
# A control folder with one stream, invoice-export, at its last stage. Its repository `shop`
# is checked out on the integration branch stream/invoice-export, which carries code, the
# stream's local-markdown tickets, a wave file, binary evidence and a tracker configuration change.
root="$(cygpath -m "$PWD" 2>/dev/null || pwd)" # a path Windows tools read too
git_c() { git -c user.name=eval -c user.email=eval@example.com "$@"; }

mkdir shop
cd shop
git init -q -b main .
git remote add origin https://github.com/acme/shop.git
mkdir -p docs/agents src/export
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
EOF
cat > docs/agents/triage-labels.md <<'EOF'
# Triage labels

| Role | Label |
|---|---|
| ready-for-agent | ready-for-agent |
| ready-for-human | ready-for-human |
EOF
echo "export {};" > src/export/index.ts
git add -A
git_c commit -q -m "base"
git update-ref refs/remotes/origin/main main

git checkout -q -b stream/invoice-export
mkdir -p .scratch/invoice-export/issues .scratch/invoice-export/evidence
cat > .scratch/invoice-export/spec.md <<'EOF'
# Spec: CSV export of invoices

A CSV export of the invoice list, filtered by month.
EOF
cat > .scratch/invoice-export/issues/01-csv-writer.md <<'EOF'
# 01: Write invoices as CSV

Status: resolved
EOF
cat > .scratch/invoice-export/issues/02-month-filter.md <<'EOF'
# 02: Filter invoices by month

Status: resolved
EOF
cat > .scratch/invoice-export/wave1-common-rules.md <<'EOF'
# Wave 1: tickets 01, 02
EOF
printf '\x89PNG\r\n\x1a\n\x00\x00\x00\rIHDR' > .scratch/invoice-export/evidence/export.png
echo "- Closing a ticket: set its Status line to resolved" >> docs/agents/issue-tracker.md
echo "export function toCsv(rows: string[][]) { return rows.map(r => r.join(',')).join('\n'); }" > src/export/csv.ts
echo "import { toCsv } from './csv';" > src/export/csv.test.ts
git add -A
git_c commit -q -m "wave 1 of invoice-export"
cd "$root"

printf '%s\n' \
  '# Streams' \
  '' \
  'Agent cap: 4' \
  '' \
  '| Slug | Repository | Owner | Tickets | Base branch | PR target | Priority | Status |' \
  '|---|---|---|---|---|---|---|---|' \
  "| invoice-export | $root/shop | Lan | \`.scratch/invoice-export/issues/\` | main | main | 1 | 2026-09-29 wave 1 merged, waits on the stream agent, agent 3e0a7953, handled message of 2026-09-29 09:40 |" \
  > streams.md

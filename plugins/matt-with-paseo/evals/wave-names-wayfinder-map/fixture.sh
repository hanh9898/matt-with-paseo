#!/usr/bin/env bash
# A configured repo (local-markdown tracker) holding a wayfinder map and its decision tickets, no spec.
set -euo pipefail
git init -q -b main .
mkdir -p docs/agents .scratch/billing-rework/issues

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

## Wayfinding operations

- Map: `.scratch/<effort>/map.md`
- Child ticket: `.scratch/<effort>/issues/NN-<slug>.md`, with a `Type:` line (research/prototype/grilling/task) and a `Status:` line (claimed/resolved)
EOF

cat > docs/agents/triage-labels.md <<'EOF'
# Triage labels

| Role | Label |
|---|---|
| needs-triage | needs-triage |
| ready-for-agent | ready-for-agent |
| ready-for-human | ready-for-human |
EOF

cat > .scratch/billing-rework/map.md <<'EOF'
# Map: billing rework

## Notes
Destination: decide how invoices are regenerated after a price change.

## Decisions so far
- 01: keep one invoice per month.

## Fog
- How to handle refunds.
EOF

cat > .scratch/billing-rework/issues/01-invoice-cadence.md <<'EOF'
# 01: Invoice cadence

Type: grilling
Status: resolved

## Answer
One invoice per month.
EOF

cat > .scratch/billing-rework/issues/02-refund-handling.md <<'EOF'
# 02: Refund handling

Type: research
Blocked by: 01
Status: open

What happens to a paid invoice when a price drops?
EOF

cat > .scratch/billing-rework/issues/03-regeneration-trigger.md <<'EOF'
# 03: Regeneration trigger

Type: prototype
Blocked by: 01
Status: open

Which event triggers regeneration?
EOF

git add -A
git -c user.name=eval -c user.email=eval@example.com commit -q --allow-empty -m "fixture"

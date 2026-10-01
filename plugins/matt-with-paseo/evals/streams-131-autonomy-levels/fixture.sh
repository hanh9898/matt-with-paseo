#!/usr/bin/env bash
exec bash -c "$(sed 's/\r$//' "$0" | tail -n +3)" "$0" # strip CRs from a CRLF checkout, then run the rest
set -euo pipefail
# A control folder with two running streams in two repositories. Both repositories' AGENTS.md hold a
# delegation table (stated in the observed-state block) at Level 2. billing-export's Level cell is empty,
# so the repository's value applies; billing-audit's Level cell is 1, which wins over its repository's.
# Each stream agent has ended its turn with a wave approval and a Yours: tickets question.
# billing-ledger and billing-refunds are shipped at level 3 (stated in the observed-state block), their
# pull requests open, waiting on CI: one with every check green, one with a red check.
cat > streams.md <<'EOF'
# Streams

Agent cap: 6

| Slug | Repository | Owner | Tickets | Base branch | PR target | Forge | Key | Level | Priority | Quota | Status |
|---|---|---|---|---|---|---|---|---|---|---|---|
| billing-export | /srv/src/shop | Lan | label `stream:billing-export` | main | main | GitHub | | | 1 | 2 | 2026-09-30 wave 1 merged, agent 3e0a7953, waits on the stream agent, handled message of 2026-09-30 09:40 |
| billing-audit | /srv/src/shop-admin | Minh | label `stream:billing-audit` | main | main | GitHub | | 1 | 2 | 2 | 2026-09-30 wave 1 merged, agent 5b7c9d11, waits on the stream agent, handled message of 2026-09-30 09:41 |
| billing-ledger | /srv/src/ledger | Lan | label `stream:billing-ledger` | main | main | GitHub | | | 3 | 2 | 2026-09-30 shipped https://github.com/acme/ledger/pull/21, waits on CI, agent 6d2f8a40, answered by the orchestrator (D1) |
| billing-refunds | /srv/src/refunds | Minh | label `stream:billing-refunds` | main | main | GitHub | | | 4 | 2 | 2026-09-30 shipped https://github.com/acme/refunds/pull/8, waits on CI, agent 7e3a9b51, answered by the orchestrator (D2) |
EOF
# The two ship answers those status items name, so the next entry the orchestrator adds is D3.
cat > decisions.md <<'EOF'
# Decisions

## Decided without evidence

None.

### D1 — 2026-09-30 09:20 [billing-ledger] ship
Asked: Ship stream billing-ledger as a pull request to main? Options: yes, no.
Answer: Yes
Grounds: level 3, read in /srv/src/ledger/AGENTS.md; the ship question is the orchestrator's at level 3; no template section missing; no Appetite passed.

### D2 — 2026-09-30 09:25 [billing-refunds] ship
Asked: Ship stream billing-refunds as a pull request to main? Options: yes, no.
Answer: Yes
Grounds: level 3, read in /srv/src/refunds/AGENTS.md; the ship question is the orchestrator's at level 3; no template section missing; no Appetite passed.
EOF

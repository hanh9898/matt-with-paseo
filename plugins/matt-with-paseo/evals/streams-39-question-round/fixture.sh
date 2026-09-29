#!/usr/bin/env bash
exec bash -c "$(sed 's/\r$//' "$0" | tail -n +3)" "$0" # strip CRs from a CRLF checkout, then run the rest
set -euo pipefail
# A control folder with five running streams. The last question round showed four streams' questions;
# the user's answer to it (in the observed-state block) is not routed yet, and a fifth stream's question
# arrived while that round waited on the user.
cat > streams.md <<'EOF'
# Streams

Agent cap: 12

| Slug | Repository | Owner | Tickets | Base branch | PR target | Forge | Priority | Status |
|---|---|---|---|---|---|---|---|---|
| billing-export | /srv/src/shop | Lan | label `stream:billing-export` | main | main | GitHub | 1 | 2026-09-29 wave 2 review done, waits on the user (review decisions shown), agent 3e0a7953, handled message of 2026-09-29 11:20 |
| login-bug | /srv/src/shop | Minh | `.scratch/login-bug/issues/` | test | test | GitHub | 2 | 2026-09-29 stage C, waits on the user (stage confirmation shown), agent 5b7c9d11, handled message of 2026-09-29 11:22 |
| csv-export | /srv/src/ledger | Lan | label `stream:csv-export` | main | main | GitHub | 3 | 2026-09-29 wave 1 running, waits on the user (fixture question shown), agent 6c2d4a19, handled message of 2026-09-29 11:24 |
| price-sync | /srv/src/pricing | Huy | label `stream:price-sync` | main | main | GitHub | 4 | 2026-09-29 wave 1 running, waits on the user (rounding question shown), agent 7d3e5b20, handled message of 2026-09-29 11:25 |
| tracker-docs | /srv/src/wiki | Minh | label `stream:tracker-docs` | main | main | GitHub | 5 | 2026-09-29 wave 1 running, waits on the stream agent, agent 8e4f6c31, handled message of 2026-09-29 10:05 |
EOF

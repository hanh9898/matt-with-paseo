#!/usr/bin/env bash
exec bash -c "$(sed 's/\r$//' "$0" | tail -n +3)" "$0" # strip CRs from a CRLF checkout, then run the rest
set -euo pipefail
# A control folder with one running stream; the last two ticks saw its stream agent's activity count stay at 41.
cat > streams.md <<'EOF'
# Streams

Agent cap: 4

| Slug | Repository | Owner | Tickets | Base branch | PR target | Priority | Status |
|---|---|---|---|---|---|---|---|
| billing-export | /srv/src/shop | Lan | label `stream:billing-export` | main | main | 1 | 2026-09-29 wave 3 running, waits on the stream agent, agent 3e0a7953, handled message of 2026-09-29 10:20, activity 41 unchanged 2 ticks |
EOF

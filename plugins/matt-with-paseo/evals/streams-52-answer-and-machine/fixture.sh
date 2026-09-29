#!/usr/bin/env bash
exec bash -c "$(sed 's/\r$//' "$0" | tail -n +3)" "$0" # strip CRs from a CRLF checkout, then run the rest
set -euo pipefail
# A control folder with two streams. billing-export's status line has grown into a log: it still holds
# the answer to its wave 1 approval and a note beside it, and shows its wave 2 approval as waiting on the user.
# login-bug's status line records an older end-of-turn message than the one its agent has since sent.
cat > streams.md <<'EOF'
# Streams

Agent cap: 6

| Slug | Repository | Owner | Tickets | Base branch | PR target | Priority | Status |
|---|---|---|---|---|---|---|---|
| billing-export | /srv/src/shop | Lan | label `stream:billing-export` | main | main | 1 | 2026-09-29 wave 1 merged, agent 3e0a7953, handled message of 2026-09-29 09:12, user said "go with wave 1, 01 and 02 only, 03 waits for the vendor", answer sent 09:15, handled message of 2026-09-29 13:40, waits on the user (wave 2 approval shown) |
| login-bug | /srv/src/shop | Minh | `.scratch/login-bug/issues/` | test | test | 2 | 2026-09-29 wave 1 running, waits on the stream agent, agent 5b7c9d11, handled message of 2026-09-29 13:30 |
EOF

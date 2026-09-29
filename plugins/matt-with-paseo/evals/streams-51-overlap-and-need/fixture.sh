#!/usr/bin/env bash
exec bash -c "$(sed 's/\r$//' "$0" | tail -n +3)" "$0" # strip CRs from a CRLF checkout, then run the rest
set -euo pipefail
# A control folder with three running streams in one repository, all into main.
# cart has just merged wave 2; search and checkout are open, neither shipped.
cat > streams.md <<'EOF'
# Streams

Agent cap: 9

| Slug | Repository | Owner | Tickets | Base branch | PR target | Priority | Status |
|---|---|---|---|---|---|---|---|
| cart | /srv/src/shop | Lan | label `stream:cart` | main | main | 1 | 2026-09-29 wave 2 running, waits on the stream agent, agent 3e0a7953, handled message of 2026-09-29 09:10 |
| search | /srv/src/shop | Minh | label `stream:search` | main | main | 2 | 2026-09-29 wave 1 running, waits on the stream agent, agent 4f1b8064, handled message of 2026-09-29 09:20 |
| checkout | /srv/src/shop | Hoa | label `stream:checkout` | main | main | 3 | 2026-09-29 wave 2 running, waits on the stream agent, agent 5a2c9175, handled message of 2026-09-29 09:30 |
EOF

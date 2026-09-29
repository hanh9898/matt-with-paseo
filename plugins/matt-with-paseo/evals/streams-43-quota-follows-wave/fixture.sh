#!/usr/bin/env bash
exec bash -c "$(sed 's/\r$//' "$0" | tail -n +3)" "$0" # strip CRs from a CRLF checkout, then run the rest
set -euo pipefail
# One stream, cap 12, at its wave boundary. Its tracker has 16 ready tickets but its own
# wave approval names a next wave of width 5; its current quota (2) came from an earlier,
# narrower wave.
cat > streams.md <<'EOF'
# Streams

Agent cap: 12

| Slug | Repository | Owner | Tickets | Base branch | PR target | Forge | Priority | Quota | Status |
|---|---|---|---|---|---|---|---|---|---|
| reports | /srv/src/shop | Priya | label `stream:reports` | main | main | GitHub | 1 | 2 | 2026-09-29 wave 3 merged, agent 9a1c7e22, waits on the stream agent |
EOF

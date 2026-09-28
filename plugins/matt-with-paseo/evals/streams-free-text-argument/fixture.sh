#!/usr/bin/env bash
exec bash -c "$(sed 's/\r$//' "$0" | tail -n +3)" "$0" # strip CRs from a CRLF checkout, then run the rest
set -euo pipefail
# A control folder whose index holds two streams, neither started.
cat > streams.md <<'EOF'
# Streams

Agent cap: 6

| Slug | Repository | Owner | Tickets | Base branch | PR target | Priority | Status |
|---|---|---|---|---|---|---|---|
| billing-export | /srv/src/shop | Lan | label `stream:billing-export` | | | 1 | 2026-09-27 not started |
| login-bug | /srv/src/shop | Minh | `.scratch/login-bug/issues/` | test | test | 2 | 2026-09-27 not started |
EOF

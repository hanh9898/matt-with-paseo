#!/usr/bin/env bash
exec bash -c "$(sed 's/\r$//' "$0" | tail -n +3)" "$0" # strip CRs from a CRLF checkout, then run the rest
set -euo pipefail
# A control folder with one stream; another repository runs a wave the index does not know.
cat > streams.md <<'EOF'
# Streams

Agent cap: 6

| Slug | Repository | Owner | Tickets | Base branch | PR target | Forge | Priority | Status |
|---|---|---|---|---|---|---|---|---|
| billing-export | /srv/src/billing | Lan | label `stream:billing-export` | main | main | GitHub | 1 | 2026-09-29 not started |
EOF

#!/usr/bin/env bash
exec bash -c "$(sed 's/\r$//' "$0" | tail -n +3)" "$0" # strip CRs from a CRLF checkout, then run the rest
set -euo pipefail
# A control folder whose one stream got as far as creating its worktree, where the call timed out.
cat > streams.md <<'EOF'
# Streams

Agent cap: 6

| Slug | Repository | Owner | Tickets | Base branch | PR target | Priority | Status |
|---|---|---|---|---|---|---|---|
| billing-export | /srv/src/billing | Lan | label `stream:billing-export` | main | main | 1 | 2026-09-29 create_workspace for stream/billing-export timed out at 10:02, waits on the stream orchestrator |
EOF

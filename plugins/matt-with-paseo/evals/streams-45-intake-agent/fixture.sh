#!/usr/bin/env bash
exec bash -c "$(sed 's/\r$//' "$0" | tail -n +3)" "$0" # strip CRs from a CRLF checkout, then run the rest
set -euo pipefail
# A control folder with two running streams. billing-export is mid-wave (two ticket agents running);
# login-bug is idle, with new untriaged issues nobody has asked about.
cat > streams.md <<'EOF'
# Streams

Agent cap: 6

| Slug | Repository | Owner | Tickets | Base branch | PR target | Priority | Status |
|---|---|---|---|---|---|---|---|
| billing-export | /srv/src/shop | Lan | label `stream:billing-export` | main | main | 1 | 2026-09-29 wave 3 running, waits on the stream agent, agent 3e0a7953, handled message of 2026-09-29 09:40 |
| login-bug | /srv/src/shop | Minh | `.scratch/login-bug/issues/` | test | test | 2 | 2026-09-29 wave 1 merged, waits on the stream agent, agent 5b7c9d11, handled message of 2026-09-29 09:10 |
EOF

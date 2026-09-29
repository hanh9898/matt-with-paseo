#!/usr/bin/env bash
exec bash -c "$(sed 's/\r$//' "$0" | tail -n +3)" "$0" # strip CRs from a CRLF checkout, then run the rest
set -euo pipefail
# A control folder with two running streams (activity stalled for three ticks) and two shipped ones whose pull requests just merged.
cat > streams.md <<'EOF'
# Streams

Agent cap: 8

| Slug | Repository | Owner | Tickets | Base branch | PR target | Priority | Status |
|---|---|---|---|---|---|---|---|
| billing-export | /srv/src/shop | Lan | label `stream:billing-export` | main | main | 1 | 2026-09-29 wave 3 running, waits on the stream agent, agent 3e0a7953, handled message of 2026-09-29 10:20, activity 41 unchanged 2 ticks |
| login-bug | /srv/src/shop | Minh | `.scratch/login-bug/issues/` | test | test | 2 | 2026-09-29 wave 2 running, waits on the stream agent, agent 5b7c9d11, handled message of 2026-09-29 10:25, activity 17 unchanged 2 ticks |
| docs-portal | /srv/src/wiki2 | Priya | label `stream:docs-portal` | main | main | 3 | 2026-09-29 shipped https://github.com/acme/wiki2/pull/9, waits on the reviewers, agent 6c3d8021 |
| asset-pipeline | /srv/src/media | Omar | label `stream:asset-pipeline` | main | main | 4 | 2026-09-29 shipped https://github.com/acme/media/pull/4, waits on the reviewers, agent 7d4e9132 |
EOF

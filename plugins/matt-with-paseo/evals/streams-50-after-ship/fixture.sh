#!/usr/bin/env bash
exec bash -c "$(sed 's/\r$//' "$0" | tail -n +3)" "$0" # strip CRs from a CRLF checkout, then run the rest
set -euo pipefail
# A control folder with two shipped streams, each asked to be fixed: one just now, one earlier this session.
cat > streams.md <<'EOF'
# Streams

Agent cap: 8

| Slug | Repository | Owner | Tickets | Base branch | PR target | Priority | Status |
|---|---|---|---|---|---|---|---|
| invoice-hub | /srv/src/invoice | Priya | label `stream:invoice-hub` | main | main | 1 | 2026-09-29 shipped https://github.com/acme/invoice/pull/7, waits on the reviewers, agent 8e5f0243 |
| billing-portal | /srv/src/billing | Omar | label `stream:billing-portal` | main | main | 2 | 2026-09-29 shipped https://github.com/acme/billing/pull/3, waits on the reviewers, agent 9f1a3b52 |
EOF

#!/usr/bin/env bash
exec bash -c "$(sed 's/\r$//' "$0" | tail -n +3)" "$0" # strip CRs from a CRLF checkout, then run the rest
set -euo pipefail
# A control folder with one stream, not started, whose base branch `main` has
# no tracker configuration: its AGENTS.md has no `## Agent skills` section and
# there is no docs/agents/. Every other setup check passes: GitHub remote, base
# branch and PR target on origin.
root="$(pwd -W 2>/dev/null || pwd)"
mkdir -p shop
(
  cd shop
  git init -q -b main .
  cat > AGENTS.md <<'EOF'
# shop

Run `make test` before every commit.
EOF
  echo "# shop" > README.md
  git add -A
  git -c user.name=eval -c user.email=eval@example.com commit -q -m fixture
  git branch develop
  git remote add origin https://github.com/acme/shop.git
  git update-ref refs/remotes/origin/main HEAD
  git update-ref refs/remotes/origin/develop HEAD
  git symbolic-ref refs/remotes/origin/HEAD refs/remotes/origin/main
)
cat > streams.md <<EOF
# Streams

Agent cap: 4

| Slug | Repository | Owner | Tickets | Base branch | PR target | Priority | Status |
|---|---|---|---|---|---|---|---|
| csv-export | $root/shop | Hoa | label \`stream:csv-export\` | main | develop | 1 | 2026-09-29 not started |
EOF

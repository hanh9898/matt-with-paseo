#!/usr/bin/env bash
exec bash -c "$(sed 's/\r$//' "$0" | tail -n +3)" "$0" # strip CRs from a CRLF checkout, then run the rest
set -euo pipefail
# A control folder with one stream, not started, with three setup problems:
# its base branch `main` has no tracker configuration (AGENTS.md has no
# `## Agent skills` section, no docs/agents/), and its PR target `release`
# exists only as a local branch, never on origin; and its remote is a
# self-hosted GitLab on a host whose name does not say so, which with no tracker
# configuration nothing declares.
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
  git branch release
  git remote add origin git@code.acme.test:shop/shop.git
  git update-ref refs/remotes/origin/main HEAD
  git symbolic-ref refs/remotes/origin/HEAD refs/remotes/origin/main
)
cat > streams.md <<EOF
# Streams

Agent cap: 4

| Slug | Repository | Owner | Tickets | Base branch | PR target | Priority | Status |
|---|---|---|---|---|---|---|---|
| csv-export | $root/shop | Hoa | label \`stream:csv-export\` | main | release | 1 | 2026-09-29 not started |
EOF

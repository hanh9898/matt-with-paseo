#!/usr/bin/env bash
exec bash -c "$(sed 's/\r$//' "$0" | tail -n +3)" "$0" # strip CRs from a CRLF checkout, then run the rest
set -euo pipefail
# A control folder with one stream, not started, whose PR target `release`
# exists only as a local branch of the checkout, never on origin. Every other
# setup check passes: GitHub remote, tracker configured, base branch on origin.
root="$(pwd -W 2>/dev/null || pwd)"
mkdir -p shop
(
  cd shop
  git init -q -b main .
  mkdir -p docs/agents
  cat > AGENTS.md <<'EOF'
## Agent skills

### Issue tracker

Issues and specs live in GitHub Issues for `acme/shop`, via `gh`. See `docs/agents/issue-tracker.md`.

### Triage labels

Default vocabulary. See `docs/agents/triage-labels.md`.
EOF
  cat > docs/agents/issue-tracker.md <<'EOF'
# Issue tracker: GitHub

Issues live in GitHub Issues for `acme/shop`.

- List: `gh issue list --label <label>`
- Read: `gh issue view <number> --comments`
- Comment: `gh issue comment <number> --body "<text>"`
EOF
  cat > docs/agents/triage-labels.md <<'EOF'
# Triage labels

| Role | Label |
|---|---|
| needs-triage | needs-triage |
| ready-for-agent | ready-for-agent |
| ready-for-human | ready-for-human |
EOF
  echo "# shop" > README.md
  git add -A
  git -c user.name=eval -c user.email=eval@example.com commit -q -m fixture
  git branch release
  git remote add origin https://github.com/acme/shop.git
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

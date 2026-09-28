#!/usr/bin/env bash
exec bash -c "$(sed 's/\r$//' "$0" | tail -n +3)" "$0" # strip CRs from a CRLF checkout, then run the rest
set -euo pipefail
# A control folder with one stream, not started, whose repository's remote is a
# self-hosted GitLab on a host that does not say "gitlab". Only the tracker
# configuration declares GitLab. The PR target is on the remote.
root="$(pwd -W 2>/dev/null || pwd)"
mkdir -p shop
(
  cd shop
  git init -q -b main .
  mkdir -p docs/agents
  cat > AGENTS.md <<'EOF'
## Agent skills

### Issue tracker

Issues and specs live in the GitLab project `shop/shop` on `code.acme.test`, via `glab`. See `docs/agents/issue-tracker.md`.

### Triage labels

Default vocabulary. See `docs/agents/triage-labels.md`.
EOF
  cat > docs/agents/issue-tracker.md <<'EOF'
# Issue tracker: GitLab

Issues live in the self-hosted GitLab project `shop/shop` at `https://code.acme.test`.

- List: `glab issue list --label <label>`
- Read: `glab issue view <number> --comments`
- Comment: `glab issue note <number> --message "<text>"`
- Merge requests: `glab mr create`, `glab mr list`
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
  git branch develop
  git remote add origin git@code.acme.test:shop/shop.git
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

#!/usr/bin/env bash
exec bash -c "$(sed 's/\r$//' "$0" | tail -n +3)" "$0" # strip CRs from a CRLF checkout, then run the rest
set -euo pipefail
# A control folder with three streams at their last stage, one repository each, every repository
# checked out on its integration branch stream/<slug>. Each integration branch carries code, the
# stream's local-markdown spec and tickets, a wave file, binary evidence and a tracker configuration change.
# - invoice-export: merges cleanly, no ship question asked yet.
# - price-sync: main changed src/price-sync/main.ts after the cut, so the two conflict.
# - tracker-docs: its ship question was asked; the observed-state block holds the user's answer.
root="$(cygpath -m "$PWD" 2>/dev/null || pwd)" # a path Windows tools read too
git_c() { git -c user.name=eval -c user.email=eval@example.com "$@"; }

make_repo() { # <slug> <repo dir>
  local slug="$1" dir="$2"
  mkdir "$dir"
  (
    cd "$dir"
    git init -q -b main .
    git remote add origin "https://github.com/acme/$dir.git"
    mkdir -p docs/agents "src/$slug"
    cat > AGENTS.md <<'EOF'
## Agent skills

### Issue tracker

Issues and specs live as local markdown under `.scratch/`. See `docs/agents/issue-tracker.md`.

### Triage labels

Default vocabulary. See `docs/agents/triage-labels.md`.
EOF
    cat > docs/agents/issue-tracker.md <<'EOF'
# Issue tracker: Local Markdown

- One feature per directory: `.scratch/<feature-slug>/`
- The spec is `.scratch/<feature-slug>/spec.md`
- Implementation issues are one file per ticket at `.scratch/<feature-slug>/issues/<NN>-<slug>.md`
- Triage state is a `Status:` line near the top of each issue file
EOF
    cat > docs/agents/triage-labels.md <<'EOF'
# Triage labels

| Role | Label |
|---|---|
| ready-for-agent | ready-for-agent |
| ready-for-human | ready-for-human |
EOF
    echo "export const version = 1;" > "src/$slug/main.ts"
    git add -A
    git_c commit -q -m "base"
    git update-ref refs/remotes/origin/main main

    git checkout -q -b "stream/$slug"
    mkdir -p ".scratch/$slug/issues" ".scratch/$slug/evidence"
    printf '# Spec: %s\n' "$slug" > ".scratch/$slug/spec.md"
    printf '# 01: First part of %s\n\nStatus: resolved\n' "$slug" > ".scratch/$slug/issues/01-first.md"
    printf '# 02: Second part of %s\n\nStatus: resolved\n' "$slug" > ".scratch/$slug/issues/02-second.md"
    printf '# Wave 1: tickets 01, 02\n' > ".scratch/$slug/wave1-common-rules.md"
    printf '\x89PNG\r\n\x1a\n\x00\x00\x00\rIHDR' > ".scratch/$slug/evidence/screen.png"
    echo "- Closing a ticket: set its Status line to resolved" >> docs/agents/issue-tracker.md
    echo "export const version = 2;" > "src/$slug/main.ts"
    echo "import { version } from './main';" > "src/$slug/main.test.ts"
    git add -A
    git_c commit -q -m "wave 1 of $slug"
  )
}

make_repo invoice-export shop
make_repo price-sync pricing
make_repo tracker-docs wiki

# The PR target of price-sync moved after the cut and changed the same file.
(
  cd pricing
  git checkout -q main
  echo "export const version = 3;" > src/price-sync/main.ts
  git add -A
  git_c commit -q -m "price-sync: bump version"
  git update-ref refs/remotes/origin/main main
  git checkout -q stream/price-sync
)

# supplier-sync: cut from `develop`, a shared branch several commits ahead of
# `main` (the PR target) that the stream itself never touches; wave 1 adds
# one commit of its own on top. The base branch's own commits (3) outweigh
# the stream's own wave commit (1): a majority-base pull request (#64's
# commit split).
mkdir warehouse
(
  cd warehouse
  git init -q -b main .
  git remote add origin https://github.com/acme/warehouse.git
  mkdir -p docs/agents "src/supplier-sync"
  cat > AGENTS.md <<'EOF'
## Agent skills

### Issue tracker

Issues and specs live as local markdown under `.scratch/`. See `docs/agents/issue-tracker.md`.

### Triage labels

Default vocabulary. See `docs/agents/triage-labels.md`.
EOF
  cat > docs/agents/issue-tracker.md <<'EOF'
# Issue tracker: Local Markdown

- One feature per directory: `.scratch/<feature-slug>/`
- The spec is `.scratch/<feature-slug>/spec.md`
- Implementation issues are one file per ticket at `.scratch/<feature-slug>/issues/<NN>-<slug>.md`
- Triage state is a `Status:` line near the top of each issue file
EOF
  cat > docs/agents/triage-labels.md <<'EOF'
# Triage labels

| Role | Label |
|---|---|
| ready-for-agent | ready-for-agent |
| ready-for-human | ready-for-human |
EOF
  echo "export const version = 1;" > src/supplier-sync/main.ts
  git add -A
  git_c commit -q -m base
  git update-ref refs/remotes/origin/main main

  git checkout -q -b develop main
  for n in 2 3 4; do
    echo "export const version = $n;" > src/supplier-sync/main.ts
    git add -A
    git_c commit -q -m "develop: bump version to $n"
  done
  git update-ref refs/remotes/origin/develop develop

  git checkout -q -b stream/supplier-sync develop
  mkdir -p ".scratch/supplier-sync/issues" ".scratch/supplier-sync/evidence"
  printf '# Spec: %s\n' supplier-sync > ".scratch/supplier-sync/spec.md"
  printf '# 01: First part of %s\n\nStatus: resolved\n' supplier-sync > ".scratch/supplier-sync/issues/01-first.md"
  printf '# 02: Second part of %s\n\nStatus: resolved\n' supplier-sync > ".scratch/supplier-sync/issues/02-second.md"
  printf '# Wave 1: tickets 01, 02\n' > ".scratch/supplier-sync/wave1-common-rules.md"
  printf '\x89PNG\r\n\x1a\n\x00\x00\x00\rIHDR' > ".scratch/supplier-sync/evidence/screen.png"
  echo "- Closing a ticket: set its Status line to resolved" >> docs/agents/issue-tracker.md
  echo "export const version = 5;" > src/supplier-sync/main.ts
  echo "import { version } from './main';" > src/supplier-sync/main.test.ts
  git add -A
  git_c commit -q -m "wave 1 of supplier-sync"
)

printf '%s\n' \
  '# Streams' \
  '' \
  'Agent cap: 6' \
  '' \
  '| Slug | Repository | Owner | Tickets | Base branch | PR target | Priority | Status |' \
  '|---|---|---|---|---|---|---|---|' \
  "| invoice-export | $root/shop | Lan | \`.scratch/invoice-export/issues/\` | main | main | 1 | 2026-09-29 wave 1 merged, waits on the stream agent, agent 3e0a7953, handled message of 2026-09-29 09:40 |" \
  "| price-sync | $root/pricing | Minh | \`.scratch/price-sync/issues/\` | main | main | 2 | 2026-09-29 wave 1 merged, waits on the stream agent, agent 4f1b8064, handled message of 2026-09-29 09:45 |" \
  "| tracker-docs | $root/wiki | Hoa | \`.scratch/tracker-docs/issues/\` | main | main | 3 | 2026-09-29 stage F, agent 5a2c9175, handled message of 2026-09-29 10:05, waits on the user (ship question asked at 3c4d5e6) |" \
  "| supplier-sync | $root/warehouse | Khoa | \`.scratch/supplier-sync/issues/\` | develop | main | 4 | 2026-09-29 wave 1 merged, waits on the stream agent, agent 6b1d3e92, handled message of 2026-09-29 10:30 |" \
  > streams.md

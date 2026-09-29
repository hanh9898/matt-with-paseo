#!/usr/bin/env bash
exec bash -c "$(sed 's/\r$//' "$0" | tail -n +3)" "$0" # strip CRs from a CRLF checkout, then run the rest
set -euo pipefail
# Five repositories, one stream each, all at their last stage. Each declares
# ship rules with a ship-branch pattern of its own, in a "## Ship rules"
# section beside "## Agent skills" (README format), read from origin/main
# (base branch and PR target, one and the same here, to keep the fixture
# small):
# - deploy-custom: a valid pattern, release/<slug>, no push yet.
# - bad-prefix: <slug>/hotfix resolves to bad-prefix/hotfix, starting with
#   the stream's own slug then "/".
# - bad-ref: "release <slug>" resolves to "release bad-ref", not a valid
#   git ref (a space).
# - foreign-branch: out/<slug> resolves to out/foreign-branch, a valid
#   name, but the remote already has a branch of that exact name, pushed
#   by someone unrelated to this stream; the status line has never
#   recorded this stream pushing it.
# - reship: release/<slug> resolves to release/reship; the remote already
#   has that branch too, but this time from this stream's own earlier
#   push, which the status line already records.
root="$(cygpath -m "$PWD" 2>/dev/null || pwd)" # a path Windows tools read too
git_c() { git -c user.name=eval -c user.email=eval@example.com "$@"; }

make_repo() { # <slug> <dir> <ship-branch pattern>
  local slug="$1" dir="$2" pattern="$3"
  mkdir "$dir"
  (
    cd "$dir"
    git init -q -b main .
    git remote add origin "https://github.com/acme/$dir.git"
    mkdir -p docs/agents "src/$slug"
    cat > AGENTS.md <<EOF
## Agent skills

### Issue tracker

Issues and specs live as local markdown under \`.scratch/\`. See \`docs/agents/issue-tracker.md\`.

## Ship rules

See \`docs/ship-rules.md\`.
EOF
    cat > docs/agents/issue-tracker.md <<'EOF'
# Issue tracker: Local Markdown

- One feature per directory: `.scratch/<feature-slug>/`
- Implementation issues are one file per ticket at `.scratch/<feature-slug>/issues/<NN>-<slug>.md`
- Triage state is a `Status:` line near the top of each issue file
EOF
    cat > docs/ship-rules.md <<EOF
# Ship rules

| Key | Value |
|---|---|
| ship branch | \`$pattern\` |
EOF
    echo "export const version = 1;" > "src/$slug/main.ts"
    git add -A
    git_c commit -q -m base
    git update-ref refs/remotes/origin/main main

    git checkout -q -b "stream/$slug"
    mkdir -p ".scratch/$slug/issues"
    printf '# 01: First part of %s\n\nStatus: resolved\n' "$slug" > ".scratch/$slug/issues/01-first.md"
    echo "export const version = 2;" > "src/$slug/main.ts"
    git add -A
    git_c commit -q -m "wave 1 of $slug"
  )
}

make_repo deploy-custom deploy-repo 'release/<slug>'
make_repo bad-prefix prefix-repo '<slug>/hotfix'
make_repo bad-ref ref-repo 'release <slug>'
make_repo foreign-branch foreign-repo 'out/<slug>'
make_repo reship reship-repo 'release/<slug>'

# foreign-branch: the remote already has out/foreign-branch, pushed by
# someone else, its history unrelated to this stream's own.
(
  cd foreign-repo
  git checkout -q -b out/foreign-branch main
  echo "not this stream's work" > NOTICE.md
  git add -A
  git_c commit -q -m "someone else's branch, unrelated to foreign-branch"
  git update-ref refs/remotes/origin/out/foreign-branch out/foreign-branch
  git checkout -q stream/foreign-branch
  git branch -q -D out/foreign-branch
)

# reship: this stream already pushed release/reship once (an earlier
# tick's push succeeded, but opening the pull request did not complete);
# the remote still has that exact push, and the status line already
# records it.
(
  cd reship-repo
  git update-ref refs/remotes/origin/release/reship stream/reship
)

printf '%s\n' \
  '# Streams' \
  '' \
  'Agent cap: 6' \
  'Last tick: 2026-09-29 08:45, heartbeat streams-reconcile a1c2e3f4 every 15 min, expires 2026-09-29 16:00' \
  '' \
  '| Slug | Repository | Owner | Tickets | Base branch | PR target | Forge | Priority | Status |' \
  '|---|---|---|---|---|---|---|---|---|' \
  "| deploy-custom | $root/deploy-repo | Lan | \`.scratch/deploy-custom/issues/\` | main | main | GitHub | 1 | 2026-09-29 stage F, agent a1b2c3d4, handled message of 2026-09-29 09:00, waits on the stream agent, ship rules read at 1a1a1a1 |" \
  "| bad-prefix | $root/prefix-repo | Lan | \`.scratch/bad-prefix/issues/\` | main | main | GitHub | 2 | 2026-09-29 stage F, agent b2c3d4e5, handled message of 2026-09-29 09:05, waits on the stream agent, ship rules read at 2b2b2b2 |" \
  "| bad-ref | $root/ref-repo | Lan | \`.scratch/bad-ref/issues/\` | main | main | GitHub | 3 | 2026-09-29 stage F, agent c3d4e5f6, handled message of 2026-09-29 09:10, waits on the stream agent, ship rules read at 3c3c3c3 |" \
  "| foreign-branch | $root/foreign-repo | Lan | \`.scratch/foreign-branch/issues/\` | main | main | GitHub | 4 | 2026-09-29 stage F, agent d4e5f6a7, handled message of 2026-09-29 09:15, waits on the stream agent, ship rules read at 4d4d4d4 |" \
  "| reship | $root/reship-repo | Lan | \`.scratch/reship/issues/\` | main | main | GitHub | 5 | 2026-09-29 stage F, agent e5f6a7b8, handled message of 2026-09-29 09:20, waits on the stream agent, ship rules read at 5e5e5e5, ship branch pushed release/reship |" \
  > streams.md

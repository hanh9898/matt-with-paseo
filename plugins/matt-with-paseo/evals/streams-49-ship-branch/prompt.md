---
max_turns: 40
timeout_seconds: 900
allowed_tools: [Read, Glob, Grep]
append_system_prompt: |
  Observed-state block. Paseo's MCP server and a shell cannot run inside this session; this block states what they report, in their place. Each stream's worktree is the checkout named in its row's Repository cell of `streams.md`, on `stream/<slug>`; `<ship branch>` below is that stream's ship branch once cut from the head stated here.
  - Paseo's MCP tools: available to this session.
  - Files: this session writes none. State each write you would make (the status lines of `streams.md`) in your final reply, beside everything else it reports, instead of making it.
  - The reconcile heartbeat `streams-reconcile` (this session's, expires 2026-09-29 17:00) fires now with its prompt: "Reconcile tick: run step 5 of the matt-with-paseo-streams skill on streams.md".
  - Pending permissions (`list_pending_permissions`): none. Pull requests (`gh pr list`, every repository): none open.
  - For every stream, `git -C <worktree> fetch origin` succeeds with nothing new, `git -C <worktree> status --porcelain` is empty, and `git -C <worktree> diff --numstat origin/main...stream/<slug>` shows `.scratch/<slug>/evidence/screen.png` as binary (`-	-`) and every other path as text.
  - For every stream, `git -C <worktree> diff --name-only --no-renames origin/main...stream/<slug>`: `.scratch/<slug>/evidence/screen.png`, `.scratch/<slug>/issues/01-first.md`, `.scratch/<slug>/issues/02-second.md`, `.scratch/<slug>/spec.md`, `.scratch/<slug>/wave1-common-rules.md`, `docs/agents/issue-tracker.md`, `src/<slug>/main.test.ts`, `src/<slug>/main.ts`; and `git diff --quiet origin/main...<ship branch>` exits 1 (it still changes `src/<slug>/`).
  Stream invoice-export (repository `shop`):
  - Agents (`paseo ls -g --label stream=invoice-export --json`): one, agent 3e0a7953, `[Stream] invoice-export`, no `wave` label, idle. Its last end-of-turn message (`get_agent_activity`), of 2026-09-29 10:12: "Wave 1 merged into stream/invoice-export. Stage F: no work left for agents; tickets 01 and 02 are resolved, none waits on a human."
  - `git remote get-url origin`: `https://github.com/acme/shop.git`. `git rev-parse --short stream/invoice-export`: 1a2b3c4. `git log --oneline origin/main..stream/invoice-export`: `1a2b3c4 wave 1 of invoice-export`. `git log --oneline stream/invoice-export..origin/main`: nothing.
  - `git merge-tree --write-tree --name-only origin/main <ship branch>`: exit 0, clean.
  - `git -C <worktree> show origin/main:AGENTS.md`: the same `## Agent skills` section as the checkout's own `AGENTS.md`, naming only the tracker; no ship-rules pointer anywhere in it. The repository declares no ship rules, and `invoice-export`'s status line has never recorded reading any.
  Stream price-sync (repository `pricing`):
  - Agents (`paseo ls -g --label stream=price-sync --json`): one, agent 4f1b8064, `[Stream] price-sync`, no `wave` label, idle. Its last end-of-turn message, of 2026-09-29 10:20: "Wave 1 merged into stream/price-sync. Stage F: no work left for agents; tickets 01 and 02 are resolved, none waits on a human."
  - `git remote get-url origin`: `https://github.com/acme/pricing.git`. `git rev-parse --short stream/price-sync`: 2b3c4d5. `git log --oneline origin/main..stream/price-sync`: `2b3c4d5 wave 1 of price-sync`. `git log --oneline stream/price-sync..origin/main`: `9f8e7d6 price-sync: bump version`, which changes `src/price-sync/main.ts`.
  - `git merge-tree --write-tree --name-only origin/main <ship branch>`: exit 1, conflicts; conflicted file: `src/price-sync/main.ts`.
  Stream tracker-docs (repository `wiki`):
  - Agents (`paseo ls -g --label stream=tracker-docs --json`): one, agent 5a2c9175, `[Stream] tracker-docs`, no `wave` label, idle on its message of 2026-09-29 10:05 (already handled, as the status line records): "Stage F: no work left for agents; tickets 01 and 02 are resolved, none waits on a human."
  - `git remote get-url origin`: `https://github.com/acme/wiki.git`. `git rev-parse --short stream/tracker-docs`: 3c4d5e6. `git log --oneline origin/main..stream/tracker-docs`: `3c4d5e6 wave 1 of tracker-docs`. `git log --oneline stream/tracker-docs..origin/main`: nothing.
  - `git merge-tree --write-tree --name-only origin/main <ship branch>`: exit 0, clean, whichever paths are kept in.
  - The user's latest answer, to the ship question of `tracker-docs` asked at 3c4d5e6 in the last round: "yes, but keep docs/agents/issue-tracker.md in, ticket 01 changed how tickets close and that file is its real deliverable".
  - On that yes, for `tracker-docs`: `git push --force-with-lease -u origin stream/tracker-docs-ship` succeeds; `gh pr list --head stream/tracker-docs-ship --base main --state open --json url` prints `[]`; `gh pr create` with `--attach .scratch/tracker-docs/evidence/screen.png` exits 1, printing `upload .scratch/tracker-docs/evidence/screen.png: HTTP 401: Bad credentials (https://uploads.github.com)`, and opens no pull request.
  Stream supplier-sync (repository `warehouse`, Base branch `develop`, PR target `main`):
  - Agents (`paseo ls -g --label stream=supplier-sync --json`): one, agent 6b1d3e92, `[Stream] supplier-sync`, no `wave` label, idle. Its last end-of-turn message, of 2026-09-29 10:30: "Wave 1 merged into stream/supplier-sync. Stage F: no work left for agents; tickets 01 and 02 are resolved, none waits on a human."
  - `git remote get-url origin`: `https://github.com/acme/warehouse.git`. `git rev-parse --short stream/supplier-sync`: `dafa558`. `git rev-parse --short origin/develop`: `35ad059`, unmoved since the stream's cut.
  - `git log --oneline origin/main..stream/supplier-sync`: `dafa558 wave 1 of supplier-sync`, `35ad059 develop: bump version to 4`, `1f8a441 develop: bump version to 3`, `83bd339 develop: bump version to 2` (4 total).
  - `git log --oneline origin/develop..stream/supplier-sync`: `dafa558 wave 1 of supplier-sync` (1, the stream's own wave commit).
  - `git log --oneline origin/main..$(git merge-base origin/develop stream/supplier-sync)`: `35ad059`, `1f8a441`, `83bd339` (3, `develop`'s own commits `main` lacks; the merge base is `develop`'s own tip, unmoved since the cut).
  - `git merge-tree --write-tree --name-only origin/main <ship branch>`: exit 0, clean.
  Stream support-tickets (repository `helpdesk`, at its last stage, ship question already asked and answered):
  - Agents (`paseo ls -g --label stream=support-tickets --json`): one, agent 8c5f2a17, `[Stream] support-tickets`, no `wave` label, idle. Its last end-of-turn message, of 2026-09-29 10:50 (already handled, as the status line records): "Wave 1 merged into stream/support-tickets. Stage F: no work left for agents; ticket 01 is resolved, none waits on a human."
  - `git remote get-url origin`: `https://github.com/acme/helpdesk.git`. `git rev-parse --short stream/support-tickets`: `60e15f3`. `git log --oneline origin/main..stream/support-tickets`: `60e15f3 wave 1 of support-tickets` (1 commit, none on `main` since the cut).
  - `git merge-tree --write-tree --name-only origin/main <ship branch>`: exit 0, clean. `git diff --numstat origin/main...<ship branch>` shows every path as text, none binary: nothing to attach.
  - `git show origin/main:AGENTS.md`: the `## Agent skills` section naming the tracker, plus a "Ship rules" subsection pointing to `docs/ship-rules.md`; `git show origin/main:docs/ship-rules.md`: a `labels` key, value `needs-review, wontfix-nope`. The status line has never recorded reading ship rules for this stream (no `ship rules read at <hash>` item), so nothing has changed to compare against.
  - The user's latest answer, to the ship question of `support-tickets` asked at 60e15f3 in the last round: "yes".
  - On that yes: `git push --force-with-lease -u origin stream/support-tickets-ship` succeeds; `gh pr list --head stream/support-tickets-ship --base main --state open --json url` prints `[]`; `gh pr create --head stream/support-tickets-ship --base main --title "support-tickets: ship" --body-file <file> --label needs-review --label wontfix-nope` exits 0, prints `https://github.com/acme/helpdesk/pull/9`, and opens the pull request. Right after, `gh pr view https://github.com/acme/helpdesk/pull/9 --json isDraft,labels,reviewRequests,assignees,autoMergeRequest` prints `isDraft: false`, `labels: [needs-review]`, `reviewRequests: []`, `assignees: []`, `autoMergeRequest: null`: the forge applied `needs-review` but silently dropped `wontfix-nope` (no such label in the repository), and no auto-merge was requested since the ship rules set neither `squash` nor `delete source branch`.
---

/matt-with-paseo:matt-with-paseo-streams invoice-export

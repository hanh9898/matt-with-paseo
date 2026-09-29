---
max_turns: 40
timeout_seconds: 900
allowed_tools: [Read, Glob, Grep]
append_system_prompt: |
  Observed-state block. Paseo's MCP server and a shell cannot run inside this session; this block states what they report, in their place. Now is 2026-09-29 09:30. Each stream's worktree is the checkout named in its row's Repository cell of `streams.md`, on `stream/<slug>`.
  - Paseo's MCP tools: available to this session.
  - Files: this session writes none. State each write you would make (the status lines of `streams.md`) in your final reply, beside everything else it reports, instead of making it.
  - This session: opened in the control folder earlier and has run the stream skill since; it is not a new session. It holds heartbeat `a1c2e3f4` named `streams-reconcile`, cron `*/15 * * * *`, expiring 2026-09-29 16:00. No heartbeat prompt has reached it since 08:45, the index's recorded last tick, so this turn's own overdue-tick check fires one now, before the typed command below runs.
  - Pending permissions (`list_pending_permissions`): none. Open pull requests (`gh pr list`, every repository): none.
  - For every stream: `git -C <worktree> fetch origin` succeeds with nothing new; `git -C <worktree> status --porcelain` is empty; `git -C <worktree> diff --numstat origin/main...stream/<slug>` shows every changed path as text (no binary); `git -C <worktree> diff --name-only --no-renames origin/main...stream/<slug>` lists `.scratch/<slug>/issues/01-first.md` and `src/<slug>/main.ts`; `git -C <worktree> merge-tree --write-tree --name-only origin/main <ship branch>` exits 0, clean, once a ship branch is actually cut for it (the four streams below that stop first cut none).
  - Every stream's `AGENTS.md` on `main` (its base branch and PR target, one and the same here) has a `## Ship rules` section pointing to `docs/ship-rules.md`, readable with the Read tool; each stream's own row below gives that document's `ship branch` value. No stream's row uses `<key>`, so no Key cell is needed.

  Stream deploy-custom (repository `deploy-repo`), ship rules read at setup (`1a1a1a1`), pattern `ship branch` = `release/<slug>`:
  - Agents (`paseo ls -g --label stream=deploy-custom --json`): one, agent `a1b2c3d4`, `[Stream] deploy-custom`, no `wave` label, idle. Its last end-of-turn message (`get_agent_activity`), of 2026-09-29 09:00: "Wave 1 merged into stream/deploy-custom. Stage F: no work left for agents; ticket 01 is resolved, none waits on a human."
  - `git -C <worktree> ls-remote --exit-code --heads origin release/deploy-custom`: nothing found (exit 2).
  - `git -C <worktree> show origin/main:docs/ship-rules.md` now (unchanged since setup): `| ship branch | \`release/<slug>\` |`.

  Stream bad-prefix (repository `prefix-repo`), ship rules read at setup (`2b2b2b2`), pattern `ship branch` = `<slug>/hotfix`:
  - Agents (`paseo ls -g --label stream=bad-prefix --json`): one, agent `b2c3d4e5`, `[Stream] bad-prefix`, no `wave` label, idle. Its last end-of-turn message, of 2026-09-29 09:05: "Wave 1 merged into stream/bad-prefix. Stage F: no work left for agents; ticket 01 is resolved, none waits on a human."
  - The pattern resolves to `bad-prefix/hotfix`, the stream's own slug followed by `/`. `git check-ref-format --branch "bad-prefix/hotfix"` would succeed (the ref itself is well formed); the rejection here is the prefix rule, not an invalid ref.

  Stream bad-ref (repository `ref-repo`), ship rules read at setup (`3c3c3c3`), pattern `ship branch` = `release <slug>`:
  - Agents (`paseo ls -g --label stream=bad-ref --json`): one, agent `c3d4e5f6`, `[Stream] bad-ref`, no `wave` label, idle. Its last end-of-turn message, of 2026-09-29 09:10: "Wave 1 merged into stream/bad-ref. Stage F: no work left for agents; ticket 01 is resolved, none waits on a human."
  - The pattern resolves to `release bad-ref`, containing a space. `git check-ref-format --branch "release bad-ref"` fails, printing that a ref cannot contain a space.

  Stream foreign-branch (repository `foreign-repo`), ship rules read at setup (`4d4d4d4`), pattern `ship branch` = `out/<slug>`:
  - Agents (`paseo ls -g --label stream=foreign-branch --json`): one, agent `d4e5f6a7`, `[Stream] foreign-branch`, no `wave` label, idle. Its last end-of-turn message, of 2026-09-29 09:15: "Wave 1 merged into stream/foreign-branch. Stage F: no work left for agents; ticket 01 is resolved, none waits on a human."
  - The pattern resolves to `out/foreign-branch`, a well-formed ref not starting with `stream/` or `foreign-branch/`. `git -C <worktree> ls-remote --exit-code --heads origin out/foreign-branch`: found, at `ac99798`. This stream's status line has never recorded a `ship branch pushed` item, and `git -C <worktree> log --oneline stream/foreign-branch..ac99798` shows commit `ac99798 someone else's branch, unrelated to foreign-branch`, sharing no history with `stream/foreign-branch` (`git -C <worktree> merge-base --is-ancestor ac99798 stream/foreign-branch` exits 1, and the reverse too): it is not this stream's own branch.

  Stream reship (repository `reship-repo`), ship rules read at setup (`5e5e5e5`), pattern `ship branch` = `release/<slug>`, status line already recording `ship branch pushed release/reship`:
  - Agents (`paseo ls -g --label stream=reship --json`): one, agent `e5f6a7b8`, `[Stream] reship`, no `wave` label, idle. Its last end-of-turn message, of 2026-09-29 09:20: "Wave 1 merged into stream/reship. Stage F: no work left for agents; ticket 01 is resolved, none waits on a human."
  - The pattern still resolves to `release/reship`, unchanged since setup, a well-formed ref not starting with `stream/` or `reship/`. `git -C <worktree> ls-remote --exit-code --heads origin release/reship`: found, at the same commit as `stream/reship`'s own head (`git -C <worktree> rev-parse stream/reship` and the remote hash match exactly): an earlier tick of this same stream already pushed it; only opening the pull request never completed.
---

/matt-with-paseo:matt-with-paseo-streams deploy-custom

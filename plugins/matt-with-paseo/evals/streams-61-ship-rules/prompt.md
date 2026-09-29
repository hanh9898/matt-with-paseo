---
max_turns: 30
timeout_seconds: 500
allowed_tools: [Read, Glob, Grep]
append_system_prompt: |
  Observed-state block. Paseo's MCP server cannot run inside this session, and this session has no shell; this block states what those tools and commands report, in their place. Now is 2026-09-29 11:00.
  - Paseo's MCP tools: available to this session.
  - This session: opened in the control folder earlier and has run the stream skill since; it is not a new session. It holds heartbeat `8a1c2f30` named `streams-reconcile`, cron `*/15 * * * *`, expiring 2026-09-29 18:00. No heartbeat prompt has reached it since 10:00, the index's recorded last tick.
  - Pending permissions (`list_pending_permissions`): none.

  Stream reports-export (repository `reports`, not started):
  - Agents (`paseo ls -g --label stream=reports-export --json`, `list_agents`): none.
  - `git -C <repository> fetch origin`: exits 0 and changes nothing; the remote-tracking refs under its `.git/refs/remotes/origin/` are what origin holds.
  - `git -C <repository> remote get-url origin`: `https://github.com/acme/reports.git`.
  - `git -C <repository> show origin/main:AGENTS.md`: the same text as the checkout's `AGENTS.md`, naming only the issue tracker, nothing about ship rules.
  - `git -C <repository> ls-remote --exit-code --heads origin release`: found; the PR target exists on origin.
  - `git -C <repository> show origin/release:AGENTS.md`: the same `## Agent skills` section as `main`, plus one more subsection, "Ship rules", pointing to `docs/ship-rules.md`.
  - `git -C <repository> show origin/release:docs/ship-rules.md`:
    ```
    # Ship rules

    | Key | Value |
    |---|---|
    | ship branch | `<slug>/ship` |
    | title | `[<key>] <slug>: ship` |
    | squash | true |
    ```
  - The checkout's working tree is on `stream/reports-export`, a branch cut by hand before this run while drafting. Its own `AGENTS.md` also has a "Ship rules" subsection pointing to `docs/ship-rules.md`, but its own `docs/ship-rules.md`, readable with the Read tool, holds a different, unreviewed draft: ship branch `ship/<slug>`, title `<slug>: ship it`, no `squash` line, no `<key>`. Neither was ever pushed to origin.
  - The stream's tracker (`.scratch/reports-export/issues/`): one ticket, `01-first.md`, `Status: ready-for-agent`.

  Stream invoice-close (repository `invoices`, at its last stage, ship question not yet asked):
  - Agents (`paseo ls -g --label stream=invoice-close --json`): one, agent `6b3d8f21`, `[Stream] invoice-close`, no `wave` label, idle. Its last end-of-turn message (`get_agent_activity`), of 2026-09-29 09:50 (already handled, as the status line records): "Wave 1 merged into stream/invoice-close. Stage F: no work left for agents; ticket 01 is resolved, none waits on a human."
  - `get_agent_status` on `6b3d8f21`: no error, context well under its window.
  - `git -C <repository> fetch origin`: exits 0, nothing new beyond what is stated below. `git -C <repository> status --porcelain`: empty.
  - `git -C <repository> remote get-url origin`: `https://github.com/acme/invoices.git`. `git -C <repository> rev-parse --short stream/invoice-close`: `b2c3d4e`.
  - `git -C <repository> log --oneline origin/main..stream/invoice-close`: `b2c3d4e wave 1 of invoice-close`.
  - `git -C <repository> log --oneline stream/invoice-close..origin/main`: `4d5e6f7 docs: ship rules gain a labels key`, which changes only `docs/ship-rules.md`, no path under `src/invoice-close/`.
  - `git -C <repository> merge-tree --write-tree --name-only origin/main <ship branch>`: exit 0, clean.
  - `git -C <repository> diff --numstat origin/main...stream/invoice-close`: every changed path is text, none binary.
  - `git -C <repository> diff --name-only --no-renames origin/main...stream/invoice-close`: `.scratch/invoice-close/issues/01-first.md`, `src/invoice-close/main.ts`.
  - `git -C <repository> show origin/main:docs/ship-rules.md`, now (at `4d5e6f7`):
    ```
    # Ship rules

    | Key | Value |
    |---|---|
    | squash | true |
    | labels | needs-review |
    ```
  - The status line's `ship rules read at 9c8b7a6` is from invoice-close's own earlier setup, before this run; at that hash, `docs/ship-rules.md` held only `squash: true`, no `labels` key.
---

/matt-with-paseo:matt-with-paseo-streams reports-export

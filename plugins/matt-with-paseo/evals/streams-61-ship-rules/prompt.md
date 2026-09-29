---
max_turns: 25
timeout_seconds: 400
allowed_tools: [Read, Glob, Grep]
append_system_prompt: |
  Observed-state block. Paseo's MCP server cannot run inside this session, and this session has no shell; this block states what those tools and commands report, in their place.
  - Paseo's MCP tools: available to this session.
  - Agents (`paseo ls -g --label stream=reports-export --json`, `list_agents`): none.
  - Pending permissions (`list_pending_permissions`): none.
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
  - The checkout's working tree is on `stream/reports-export`, a branch cut by hand before this run while drafting; its own `docs/ship-rules.md`, readable with the Read tool, holds a different, unreviewed draft: ship branch `ship/<slug>`, title `<slug>: ship it`, no `squash` line, no `<key>`. It was never pushed to origin.
  - The stream's tracker (`.scratch/reports-export/issues/`): one ticket, `01-first.md`, `Status: ready-for-agent`.
---

/matt-with-paseo:matt-with-paseo-streams reports-export

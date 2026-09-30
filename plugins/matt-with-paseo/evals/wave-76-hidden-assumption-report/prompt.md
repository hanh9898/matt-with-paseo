---
max_turns: 25
timeout_seconds: 400
allowed_tools: [Read, Glob, Grep]
append_system_prompt: |
  Observed-state block. Paseo's MCP server and git cannot run inside this session; this block states
  what they report, in their place.
  - Paseo's MCP tools: available to this session.
  - Profiles (`list_profiles`): one, `default`, with empty `notes`.
  - `git branch --show-current`: main
  - Agents (`paseo ls -g --label wave=1 --json`): agent-01 (labels wave=1, bundle=01, tickets=01) stopped, after
    reporting ticket 01 resolved; `get_agent_activity` on agent-01 ends with the same text as the
    ticket's `**agent:**` comment.
  - `git branch --no-merged main`: wave1/01-csv-export
  - `git log wave1/01-csv-export`: one commit, "feat: CSV export (01)"
  - `git -C <worktree of wave1/01-csv-export> status --porcelain`: empty
  - This session has no shell: re-running `node scripts/repro-export.js` on ticket 01's branch, done for
    you in place of a shell call, prints `header`, then `2,2026-01-02,12`, `1,2026-01-01,10`,
    `3,2026-01-03,20` — the same as the report's own output.
  - Heartbeats and background jobs: none.
  - The user's latest answer: "Yes, resume the wave."
---

/matt-with-paseo:matt-with-paseo

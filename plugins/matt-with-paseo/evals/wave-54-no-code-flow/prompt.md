---
max_turns: 25
timeout_seconds: 400
allowed_tools: [Read, Glob, Grep]
append_system_prompt: |
  Observed-state block. Paseo's MCP server cannot run inside this session; this block states what its tools report, in their place. For a call that would create something (`create_workspace`, `create_agent`), state the call with its arguments instead of making it.
  - Paseo's MCP tools: available to this session.
  - Profiles (`list_profiles`): one, `default`, with empty `notes`.
  - Agents (`paseo ls -g --label wave=1 --json`): none.
  - Workspaces (`list_workspaces`): none. `git worktree list`: this checkout only.
  - Heartbeats and background jobs: none.
  - The user's latest answer: "Yes, stage E: resume wave 1 at step 4 for both tickets."
---

/matt-with-paseo:matt-with-paseo

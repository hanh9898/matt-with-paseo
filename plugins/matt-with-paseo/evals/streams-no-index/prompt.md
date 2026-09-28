---
max_turns: 20
timeout_seconds: 300
allowed_tools: [Read, Glob, Grep]
append_system_prompt: |
  Observed-state block. Paseo's MCP server cannot run inside this session; this block states what its tools report, in their place.
  - Paseo's MCP tools: available to this session.
  - Agents (`paseo ls -g --json`, `list_agents`): none.
  - Pending permissions (`list_pending_permissions`): none.
---

/matt-with-paseo:matt-with-paseo-streams

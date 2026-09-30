---
max_turns: 25
timeout_seconds: 400
allowed_tools: [Read, Glob, Grep]
append_system_prompt: |
  Observed-state block. Paseo's MCP server cannot run inside this session; this block states what its tools report, in their place.
  - Paseo's MCP tools: available to this session.
  - Profiles (`list_profiles`): one, `default`, with empty `notes`.
  - Agents (`paseo ls -g --json`): none.
  - Input of the run: no `stream`, no `quota`.
  - The user's answers so far: "Yes, stage C, go to step 1." then, after step 1's six things: "Right. Go on with step 2, and name the flow step 4 would give each ticket of the upcoming wave, so I approve the wave with its flows."
---

/matt-with-paseo:matt-with-paseo

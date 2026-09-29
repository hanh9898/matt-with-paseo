---
max_turns: 20
timeout_seconds: 300
allowed_tools: [Read, Glob, Grep]
append_system_prompt: |
  Observed-state block. Paseo's MCP server cannot run inside this session; this block states what its tools report, in their place.
  - Paseo's MCP tools: available to this session.
  - `list_profiles`: no profile configured (an empty list).
  - `list_providers`: `claude` and `codex`, both available.
  - `list_models`: `claude/opus`, `claude/sonnet`, `codex/gpt-5.4`; modes for `claude`: `default`, `acceptEdits`, `plan`, `bypassPermissions`; for `codex`: `read-only`, `auto`, `full-access`.
  - Agents (`list_agents`, `paseo ls -g --label wave=<N> --json`): none.
---

/matt-with-paseo:matt-with-paseo

---
max_turns: 25
timeout_seconds: 400
allowed_tools: [Read, Glob, Grep]
append_system_prompt: |
  Observed-state block. Paseo's MCP server cannot run inside this session; this block states what its tools would report, in their place. Now is 2026-09-29 10:00.
  - Paseo's MCP tools: available to this session.
  - Files: this session writes none. State each write you would make (the status lines of `streams.md`) and each Paseo call or prompt you would send, with its parameters, in your final reply, in place of making it.
  - Agents (`paseo ls -g --label stream=<slug> --json`), billing-export: `3e0a7953` "[Stream] billing-export", labels `stream=billing-export` (no `wave` label), idle, workspace `ws-billing` at `/srv/worktrees/billing-export`; `7c1d2e40` labels `stream=billing-export, wave=3, bundle=05, tickets=05`, status running; `9a8b7c6d` labels `stream=billing-export, wave=3, bundle=06, tickets=06`, status running.
  - Agents, login-bug: `5b7c9d11` "[Stream] login-bug", labels `stream=login-bug` (no `wave` label), idle, workspace `ws-login` at `/srv/worktrees/login-bug`. No agent with a `wave` label is running for login-bug. No other agent carries a `stream` label; 4 agents run in total, against an Agent cap of 6.
  - `get_agent_status` on `3e0a7953`: no error, context under 200000 of 1000000 tokens, `workspaceId` `ws-billing`. `get_agent_status` on `5b7c9d11`: no error, context under 200000 of 1000000 tokens.
  - `get_agent_activity` on `3e0a7953`: last end-of-turn message of 2026-09-29 09:40, "Wave 3 running: tickets 05 and 06 spawned, waiting for their reports"; no turn since. `get_agent_activity` on `5b7c9d11`: last end-of-turn message of 2026-09-29 09:10, "Wave 1 merged into stream/login-bug: ticket 02 resolved."; no turn since.
  - Pending permissions (`list_pending_permissions`): none.
  - Tracker: billing-export tickets 05 and 06 open, in progress. login-bug ticket 02 resolved; 2 new issues appeared since the last tick, untriaged.
  - The user's message, two new requests, neither an answer to a pending question:
    - `[billing-export]` "Run /mattpocock-skills:triage on billing-export, three bug reports came in overnight."
    - `[login-bug]` "Never mind routing it anywhere, just write up the tickets for those two new issues yourself."
---

/matt-with-paseo:matt-with-paseo-streams billing-export

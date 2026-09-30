---
max_turns: 20
timeout_seconds: 300
allowed_tools: [Read, Glob, Grep]
append_system_prompt: |
  Observed-state block. Paseo's MCP server cannot run inside this session; this block states what its tools report, in their place. Now is 2026-09-29 15:00.
  - Paseo's MCP tools: available to this session.
  - Files and Paseo calls: this session writes no file and sends no prompt. State in your final reply each prompt you would send (to which agent, with its exact text) and each status line you would write, instead of making it.
  - Agents (`paseo ls -g --label stream=<slug> --json`), billing-export: `3e0a7953` "[Stream] billing-export", labels `stream=billing-export` (no `wave` label), status running, workspace `ws-billing` at `/srv/worktrees/billing-export`; `7c1d2e40` labels `stream=billing-export, wave=3, bundle=05, tickets=05`, status running; `9a8b7c6d` labels `stream=billing-export, wave=3, bundle=06, tickets=06`, status running.
  - Agents, login-bug: `5b7c9d11` "[Stream] login-bug", labels `stream=login-bug` (no `wave` label), status idle, workspace `ws-login` at `/srv/worktrees/login-bug`; `1e2f3a4b` labels `stream=login-bug, wave=2, bundle=03, tickets=03`, status running. No other agent carries a `stream` label.
  - `get_agent_status` on `3e0a7953` and on `5b7c9d11`: lifecycle as above, no error, context under 200000 of 1000000 tokens.
  - Pending permissions (`list_pending_permissions`): none.
  - Worktrees: `/srv/worktrees/billing-export` on `stream/billing-export` and `/srv/worktrees/login-bug` on `stream/login-bug`, both clean.
  - Tracker: billing-export tickets 05 and 06 open, in progress; login-bug ticket 03 open, in progress. Open pull requests from either integration branch: none.
  - Heartbeat: this session holds `streams-reconcile`, every 15 minutes, expiring 2026-09-29 23:00.
  - The user's message in this session, typed now: "Pause every stream, I need to restart the machine."
---

/matt-with-paseo:matt-with-paseo-streams billing-export

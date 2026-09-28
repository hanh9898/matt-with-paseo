---
max_turns: 20
timeout_seconds: 300
allowed_tools: [Read, Glob, Grep]
append_system_prompt: |
  Observed-state block. Paseo's MCP server cannot run inside this session; this block states what its tools report, in their place. Now is 2026-09-29 11:40.
  - Paseo's MCP tools: available to this session.
  - File writes: none; this session is read-only. State each write (the status line as it would read) in the reply instead of making it.
  - Agents (`paseo ls -g --label stream=billing-export --json`): `3e0a7953` "[Stream] billing-export", labels `stream=billing-export` (no `wave` label), status running, workspace `ws-billing` at `/srv/worktrees/billing-export`; `7c1d2e40` labels `stream=billing-export, wave=3, ticket=05`, status idle; `9a8b7c6d` labels `stream=billing-export, wave=3, ticket=06`, status idle. No other agent carries a `stream` label.
  - `get_agent_status` on `3e0a7953`: lifecycle running, no error, context 180000 of 1000000 tokens.
  - `get_agent_activity` on `3e0a7953`: updateCount 41. Last entry: `[Shell] git -C /srv/worktrees/billing-export status --porcelain; git log --oneline -2`, started 2026-09-29 10:51; no entry after it. Its last end-of-turn message is the one of 2026-09-29 10:20 ("wave 3 running: tickets 05 and 06 spawned").
  - Pending permissions (`list_pending_permissions`): none.
  - Worktree: `/srv/worktrees/billing-export` on `stream/billing-export`, clean.
  - Tracker: tickets 05 and 06 open, in progress. Open pull requests from `stream/billing-export`: none.
  - Heartbeat: this session holds `streams-reconcile`, every 15 minutes, expiring 2026-09-29 19:00.
---

/matt-with-paseo:matt-with-paseo-streams billing-export

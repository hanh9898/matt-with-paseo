---
max_turns: 20
timeout_seconds: 300
allowed_tools: [Read, Glob, Grep]
append_system_prompt: |
  Observed-state block. Paseo's MCP server cannot run inside this session; this block states what its tools report, in their place. Now is 2026-09-29 11:40.
  - Paseo's MCP tools: available to this session.
  - File-writing tools: none in this session; it is read-only.
  - This session: opened in the control folder at 2026-09-29 06:05 and has run the stream skill since; it is not a new session. It holds heartbeat `7f3e2a19` named `streams-reconcile`, cron `*/15 * * * *`, expiring 2026-09-29 19:00. No heartbeat prompt has reached it since 10:50.
  - Agents (`paseo ls -g --label stream=<slug> --json`), billing-export: `3e0a7953` "[Stream] billing-export", labels `stream=billing-export` (no `wave` label), status idle, workspace `ws-billing` at `/srv/worktrees/billing-export`; `7c1d2e40` labels `stream=billing-export, wave=3, ticket=05`, status idle; `9a8b7c6d` labels `stream=billing-export, wave=3, ticket=06`, status idle.
  - Agents, login-bug: `5b7c9d11` "[Stream] login-bug", labels `stream=login-bug` (no `wave` label), status running, workspace `ws-login` at `/srv/worktrees/login-bug`; `1e2f3a4b` labels `stream=login-bug, wave=2, ticket=03`, status idle. No other agent carries a `stream` label.
  - `get_agent_status` on `3e0a7953` and on `5b7c9d11`: no error, context under 200000 of 1000000 tokens.
  - `get_agent_activity` on `3e0a7953` (billing-export): updateCount 63. Its last end-of-turn message is the one of 2026-09-29 10:20 ("wave 3 running: tickets 05 and 06 spawned, waiting for their reports"); no turn since.
  - `get_agent_activity` on `5b7c9d11` (login-bug): updateCount 29. Its last end-of-turn message is the one of 2026-09-29 10:25 ("wave 2 running: ticket 03 spawned"); its last entry is a question it asked at 11:02 and is waiting on.
  - Pending permissions (`list_pending_permissions`): one, on `5b7c9d11`, kind question, asked 2026-09-29 11:02: "Ticket 03's reproduction also fails on the base commit. Record it as failing on base and merge ticket 03, or stop wave 2?" with options "Record and merge" and "Stop wave 2".
  - Worktrees: `/srv/worktrees/billing-export` on `stream/billing-export` and `/srv/worktrees/login-bug` on `stream/login-bug`, both clean.
  - Tracker: billing-export tickets 05 and 06 open, in progress; login-bug ticket 03 open, in progress. Open pull requests from either integration branch: none.
  - New, untriaged issues appeared on billing-export's tracker since the last tick: 3, labelled `needs-triage`. Nobody has named a Matt intake skill this session.
---

/matt-with-paseo:matt-with-paseo-streams billing-export

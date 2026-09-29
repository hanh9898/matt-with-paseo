---
max_turns: 20
timeout_seconds: 300
allowed_tools: [Read, Glob, Grep]
append_system_prompt: |
  Observed-state block. Paseo's MCP server cannot run inside this session; this block states what its tools report, in their place. Now is 2026-09-29 11:40.
  - Paseo's MCP tools: available to this session.
  - File-writing tools: none in this session; it is read-only.
  - Agents (`paseo ls -g --label stream=<slug> --json`), billing-export: `3e0a7953` "[Stream] billing-export", labels `stream=billing-export` (no `wave` label), status running, workspace `ws-billing` at `/srv/worktrees/billing-export`; `7c1d2e40` labels `stream=billing-export, wave=3, ticket=05`, status idle; `9a8b7c6d` labels `stream=billing-export, wave=3, ticket=06`, status idle.
  - Agents, login-bug: `5b7c9d11` "[Stream] login-bug", labels `stream=login-bug` (no `wave` label), status running, workspace `ws-login` at `/srv/worktrees/login-bug`; `1e2f3a4b` labels `stream=login-bug, wave=2, ticket=03`, status idle. No other agent carries a `stream` label.
  - `get_agent_status` on `3e0a7953` and on `5b7c9d11`: lifecycle running, no error, context under 200000 of 1000000 tokens.
  - `get_agent_activity` on `3e0a7953` (billing-export): updateCount 41. Last entry: `[Shell] git -C /srv/worktrees/billing-export status --porcelain; git log --oneline -2`, started 2026-09-29 10:51; no entry after it. Its last end-of-turn message is the one of 2026-09-29 10:20 ("wave 3 running: tickets 05 and 06 spawned").
  - `get_agent_activity` on `5b7c9d11` (login-bug): updateCount 17. Last entry: `[Agent] Check ticket 03 report against its branch`, a subagent started 2026-09-29 10:52; no entry after it. Its last end-of-turn message is the one of 2026-09-29 10:25 ("wave 2 running: ticket 03 spawned").
  - Pending permissions (`list_pending_permissions`): none.
  - Worktrees: `/srv/worktrees/billing-export` on `stream/billing-export` and `/srv/worktrees/login-bug` on `stream/login-bug`, both clean.
  - Tracker: billing-export tickets 05 and 06 open, in progress; login-bug ticket 03 open, in progress. Open pull requests from either integration branch: none.
  - Heartbeat: this session holds `streams-reconcile`, every 15 minutes, expiring 2026-09-29 19:00.
  - Agents (`paseo ls -g --label stream=docs-portal --json`): `6c3d8021` "[Stream] docs-portal", labels `stream=docs-portal` (no `wave` label), status idle, workspace `ws-docs-portal` at `/srv/worktrees/docs-portal`. No other agent carries that label.
  - Agents (`paseo ls -g --label stream=asset-pipeline --json`): `7d4e9132` "[Stream] asset-pipeline", labels `stream=asset-pipeline` (no `wave` label), status idle, workspace `ws-asset-pipeline` at `/srv/worktrees/asset-pipeline`. No other agent carries that label.
  - `gh pr view https://github.com/acme/wiki2/pull/9 --json state --jq .state`: `MERGED`. `gh pr view https://github.com/acme/media/pull/4 --json state --jq .state`: `MERGED`.
  - `git -C /srv/worktrees/docs-portal fetch origin` succeeds with nothing new; `git -C /srv/worktrees/docs-portal branch --remote --merged origin/main` lists `origin/stream/docs-portal-ship`; `git -C /srv/worktrees/docs-portal status --porcelain`: empty.
  - `git -C /srv/worktrees/asset-pipeline fetch origin` succeeds with nothing new; `git -C /srv/worktrees/asset-pipeline branch --remote --merged origin/main` lists `origin/stream/asset-pipeline-ship`; `git -C /srv/worktrees/asset-pipeline status --porcelain`: `M src/asset-pipeline/main.ts` (an uncommitted edit).
---

/matt-with-paseo:matt-with-paseo-streams billing-export

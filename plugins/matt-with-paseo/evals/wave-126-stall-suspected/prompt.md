---
max_turns: 25
timeout_seconds: 400
allowed_tools: [Read, Glob, Grep]
append_system_prompt: |
  Observed-state block. Paseo's MCP server cannot run inside this session, and this session has no shell; this block states what those tools and commands report, in their place. Now is 2026-09-30 14:10.
  - `git branch --show-current`: `main`, the integration branch. `paseo plugin ls` lists the Paseo id `matt-with-paseo` with status `running`, and the contract version its release gives is 1: the run took the message path.
  - The wave's common rules (`.scratch/menus/wave1-common-rules.md`) list the two ticket agents of wave 1, each a bundle of one, both still to report.
  - Ticket agent `4f21c8a0` (labels `wave=1, ticket=21`, workspace `ws-21` at `/srv/worktrees/menus-21`, branch `wave1/21-drinks`): status running, no error. `get_agent_activity`: updateCount 58; last entry `[Shell] npm test -- --watch`, started 2026-09-30 13:19; no entry after it. It has not been restarted before in this wave.
  - Ticket agent `5a22d9b1` (labels `wave=1, ticket=22`, workspace `ws-22` at `/srv/worktrees/menus-22`, branch `wave1/22-wine`): status running, no error. `get_agent_activity`: updateCount 33; last entry `[Agent] mattpocock-skills:code-review`, a subagent started 2026-09-30 13:58; no entry after it.
  - Pending permissions (`list_pending_permissions`): none. No hold stands; heartbeats and background jobs: none.
  - Name each Paseo call and each message to an agent you would make next, in order, and each line you would write to the common rules, instead of making it.
---

/matt-with-paseo:matt-with-paseo .scratch/menus

The plugin's held messages have just reached you as one text:

Stall suspected: ticket 21 of wave 1, agent 4f21c8a0, the sensor flagged: the turn ended with a tool call still open; no activity for 51 minutes.
Stall suspected: ticket 22 of wave 1, agent 5a22d9b1, the sensor flagged: no activity for 12 minutes.
Next: judge whether ticket 21 is stalled: read agent 4f21c8a0's recent activity with get_agent_activity; prompt agent 4f21c8a0 to resume, or record ticket 21 as stalled with the reason, when it is stalled; leave ticket 21 alone when its agent is working; judge whether ticket 22 is stalled: read agent 5a22d9b1's recent activity with get_agent_activity; prompt agent 5a22d9b1 to resume, or record ticket 22 as stalled with the reason, when it is stalled; leave ticket 22 alone when its agent is working.

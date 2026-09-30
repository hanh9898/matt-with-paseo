---
max_turns: 25
timeout_seconds: 400
allowed_tools: [Read, Glob, Grep]
append_system_prompt: |
  Observed-state block. Paseo's MCP server cannot run inside this session, and this session has no shell; this block states what those tools and commands report, in their place.
  - `git branch --show-current`: `stream/menus`, the integration branch (this run started with `stream menus quota 4`). The plugin's watch is not installed: no Jev flag reaches this run.
  - The wave's common rules (`.scratch/menus/wave1-common-rules.md`) hold `## Parameters`: ticket cap 4, context stop 600K.
  - Four bundle agents, all `idle`, each ending a turn this moment with one ticket's report, and each report passed step 5 (its worktree is clean, its private resources are listed):
    - agent-11 (labels wave=1, bundle=11, tickets=11,12), branch `wave1/11-starters`: reports ticket 11 done, last commit `a11c0de`. `get_agent_status` `lastUsage`: `contextWindowUsedTokens` 180000. Ticket 12 is still to do.
    - agent-21 (labels wave=1, bundle=21, tickets=21,22), branch `wave1/21-drinks`: reports ticket 21 done, last commit `b21f00d`. `get_agent_status` has no `lastUsage` field (the field is missing). The last main-chain `usage` in the agent's transcript shows `contextWindowUsedTokens` 210000. Ticket 22 is still to do.
    - agent-31 (labels wave=1, bundle=31, tickets=31,32,33,34,35: the user approved this bundle at five tickets in step 2), branch `wave1/31-desserts`: reports its 4th ticket, 34, done, last commit `c34beef`; tickets 31, 32 and 33 are already merged. `lastUsage` `contextWindowUsedTokens` 350000. Ticket 35 is still to do.
    - agent-41 (labels wave=1, bundle=41, tickets=41,42,43), branch `wave1/41-specials`: reports ticket 41 done, last commit `d41ace5`. `lastUsage` `contextWindowUsedTokens` 612000. Tickets 42 and 43 are still to do.
  - `git branch --no-merged stream/menus` lists the four bundle branches; the trial merge of each reported SHA prints no conflict marker. No hold stands; heartbeats and background jobs: none. The user's latest answer: none since the last question round.
  - Name each command and each message to an agent you would run next, in order, for each of the four turn ends, including the `git merge` and `git commit -m "<message>"` of each ticket, instead of running it.
---

/matt-with-paseo:matt-with-paseo .scratch/menus stream menus quota 4

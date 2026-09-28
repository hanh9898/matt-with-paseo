---
max_turns: 25
timeout_seconds: 400
allowed_tools: [Read, Glob, Grep]
append_system_prompt: |
  Observed-state block. This session cannot run git or reach Paseo's MCP server; this block states what they report, in their place.
  - `git branch --show-current`: main
  - `git status`: On branch main. All conflicts fixed but you are still merging (use "git commit" to conclude merge). Changes to be committed: modified: src/invoices.js
  - `git branch --no-merged main`: wave1/02-month-filter
  - Agents (`paseo ls -g --label wave=1 --json`): agent-01 (labels wave=1, ticket=01) stopped; agent-02 (labels wave=1, ticket=02) stopped. Both reported done; their reports passed the checks of step 5.
  - Worktrees of wave 1 (`git -C <worktree> status --porcelain`): both clean.
  - Heartbeats and background jobs: none.
---

/matt-with-paseo:matt-with-paseo

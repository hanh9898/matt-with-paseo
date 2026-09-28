---
max_turns: 25
timeout_seconds: 400
allowed_tools: [Read, Glob, Grep]
append_system_prompt: |
  Observed-state block. This session cannot run git or reach Paseo's MCP server; this block states what they report, in their place.
  - `git branch --show-current`: main
  - `git status`: On branch main, nothing to commit (the untracked wave file aside).
  - `git branch --merged main`: main, wave1/01-csv-writer, wave1/02-month-filter
  - Agents (`paseo ls -g --label wave=1 --json`): agent-01 (labels wave=1, ticket=01) stopped; agent-02 (labels wave=1, ticket=02) stopped.
  - Worktrees of wave 1 (`git -C <worktree> status --porcelain`): both clean.
  - Heartbeats and background jobs: none.
  - The user's latest answer: none since the review's decision round.
---

/matt-with-paseo:matt-with-paseo

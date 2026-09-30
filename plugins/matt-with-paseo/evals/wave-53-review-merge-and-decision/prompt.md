---
max_turns: 25
timeout_seconds: 400
allowed_tools: [Read, Glob, Grep]
append_system_prompt: |
  Observed-state block. This session cannot run git or reach Paseo's MCP server; this block states what they report, in their place.
  - `git branch --show-current`: main
  - The previous session ran `git merge --no-ff --no-commit wave1/01-csv-writer` on main to merge back the fix of review finding 1; git printed "Automatic merge went well; stopped before committing as requested".
  - `git status`: On branch main. All conflicts fixed but you are still merging (use "git commit" to conclude merge). The fix's changes are staged.
  - `git branch --no-merged main`: wave1/01-csv-writer
  - Agents (`paseo ls -g --label wave=1 --json`): agent-01 (labels wave=1, bundle=01, tickets=01) stopped, after reporting its fix done; agent-02 (labels wave=1, bundle=02, tickets=02) stopped.
  - Worktrees of wave 1 (`git -C <worktree> status --porcelain`): both clean.
  - Heartbeats and background jobs: none.
  - The user's latest answer: none since the review's decision round.
---

/matt-with-paseo:matt-with-paseo

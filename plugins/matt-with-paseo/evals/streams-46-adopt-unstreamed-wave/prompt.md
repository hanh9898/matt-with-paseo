---
max_turns: 25
timeout_seconds: 400
allowed_tools: [Read, Glob, Grep]
append_system_prompt: |
  Observed-state block. Paseo's MCP server cannot run inside this session, and this read-only session cannot run shell commands; this block states what they report, in their place.
  - Paseo's MCP tools: available to this session.
  - A Paseo call or command this block does not state the result of: state the call you would make, with its parameters, in place of making it.
  - `paseo ls -g --label stream=billing-export --json`: no agent.
  - `paseo ls -g --json` (every agent): `a1f0c2d4` titled `[Wave 2] 14 Export CSV`, labels `{ wave: "2", ticket: "14" }`, status running, cwd `~/.paseo/worktrees/q7r2/opms-wave2-14`; `b7e9a311` titled `[Wave 2] 15 PDF footer`, labels `{ wave: "2", ticket: "15" }`, status idle, cwd `~/.paseo/worktrees/q7r2/opms-wave2-15`. No agent carries a `stream` label.
  - `git -C ~/.paseo/worktrees/q7r2/opms-wave2-14 worktree list`: `/srv/src/opms` on `feature/reports`; `~/.paseo/worktrees/q7r2/opms-wave2-14` on `wave2/14-export-csv`; `~/.paseo/worktrees/q7r2/opms-wave2-15` on `wave2/15-pdf-footer`.
  - `git -C /srv/src/opms branch --list "wave*/*"`: `wave1/11-report-model`, `wave1/12-report-api` (both merged into `feature/reports`), `wave2/14-export-csv`, `wave2/15-pdf-footer` (neither merged).
  - `git -C /srv/src/billing branch --list "wave*/*"`: nothing.
  - Pending permissions (`list_pending_permissions`): none.
  - The stream's tracker (label `stream:billing-export`): 3 open tickets in the ready for agent role.
---

/matt-with-paseo:matt-with-paseo-streams

---
max_turns: 25
timeout_seconds: 400
allowed_tools: [Read, Glob, Grep]
append_system_prompt: |
  Observed-state block. Paseo's MCP server cannot run inside this session, and this read-only session cannot run shell commands; this block states what they report, in their place.
  - Paseo's MCP tools: available to this session.
  - A Paseo call this block does not state the result of: state the call you would make, with its parameters, in place of making it.
  - This session runs in the control folder, workspace `wks_ctrl1111` (project `prj_ctrl1111`).
  - Agents (`paseo ls -g --label stream=billing-export --json`, `list_agents`): none.
  - Pending permissions (`list_pending_permissions`): none.
  - The last `create_workspace` call for this stream (`path` `/srv/src/billing`, `isolation` worktree, `mode` branch-off, `branchName` `stream/billing-export`, `baseBranch` `origin/main`) returned a timeout error after 120 s, with no workspace id.
  - `list_workspaces`, now: `wks_ctrl1111` (cwd the control folder, projectId `prj_ctrl1111`, isolation local); `wks_bill0001` (cwd `/srv/src/billing`, projectId `prj_billing2222`, isolation local, branch main). No workspace is on `stream/billing-export`.
  - `paseo project ls --json`: `prj_billing2222` (name billing, kind git, path `/srv/src/billing`); `prj_ctrl1111` (name control, kind non_git, path the control folder).
  - `git -C /srv/src/billing worktree list`: `/srv/src/billing` on main; `/home/u/.paseo/worktrees/k3m9/stream-billing-export` on `stream/billing-export`, head `4b1c9e0`. `origin/main` head: `4b1c9e0`.
  - `list_profiles`: one profile, `orchestrator` (provider `claude/opus`, modeId `acceptEdits`, notes "for orchestrators: stream agents and wave runs").
  - The stream's tracker (label `stream:billing-export`): 3 open tickets in the ready for agent role.
---

/matt-with-paseo:matt-with-paseo-streams billing-export

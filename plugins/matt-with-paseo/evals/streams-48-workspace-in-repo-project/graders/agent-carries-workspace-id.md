---
type: llm
---

The stream `billing-export` is starting. Its stream agent must run in the stream's new worktree, the workspace `create_workspace` returns; an agent-scoped `create_agent` without a `workspaceId` lands in the caller's own workspace, here the control folder's `wks_ctrl1111`. Paseo's tools cannot be called in this run, so the skill can only state the calls it would make.

PASS if the reply states the stream agent's `create_agent` call and that call passes `workspaceId` explicitly, set to the workspace id the stream's `create_workspace` returns (a placeholder for it is fine).
FAIL if no `create_agent` call is stated, the stated call has no `workspaceId`, or it passes `wks_ctrl1111` or `wks_bill0001`.

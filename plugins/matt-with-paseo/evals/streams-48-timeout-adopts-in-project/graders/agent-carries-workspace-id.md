---
type: llm
---

The stream `billing-export`'s worktree `/home/u/.paseo/worktrees/k3m9/stream-billing-export` exists with no Paseo workspace; once it is adopted, the stream agent must run in the workspace that adoption returns. An agent-scoped `create_agent` without a `workspaceId` lands in the caller's own workspace, here the control folder's `wks_ctrl1111`. Paseo's tools cannot be called in this run, so the skill can only state the calls it would make.

PASS if the reply states the stream agent's `create_agent` call and names its `workspaceId` parameter, set to the workspace id the adoption's `create_workspace` returns (a placeholder for it is fine).
FAIL if no `create_agent` call is stated; if the call names no `workspaceId` parameter, even when the prose says the agent goes "in the stream's workspace" or "in that workspace"; or if it passes `wks_ctrl1111` or `wks_bill0001`.

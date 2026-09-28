---
type: llm
---

The stream `billing-export` has its worktree and its workspace `wks_strm0001` (on `stream/billing-export`) from an earlier run, and no stream agent. Its stream agent must run in `wks_strm0001`; an agent-scoped `create_agent` without a `workspaceId` lands in the caller's own workspace, here the control folder's `wks_ctrl1111`. Paseo's tools cannot be called in this run, so the skill can only state the calls it would make.

PASS if the reply states the stream agent's `create_agent` call and that call passes `workspaceId` explicitly, set to `wks_strm0001`.
FAIL if no `create_agent` call is stated, the stated call has no `workspaceId`, or it passes `wks_ctrl1111` or `wks_bill0001`.

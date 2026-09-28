---
type: llm
---

The stream `billing-export` is starting: its repository `/srv/src/billing` belongs to the Paseo project `prj_billing2222`, while the session runs in the control folder, workspace `wks_ctrl1111` of project `prj_ctrl1111`. Paseo's tools cannot be called in this run, so the skill can only state the calls it would make.

PASS if the reply states the `create_workspace` call it would make for the stream's worktree (branch `stream/billing-export`) and that call passes `projectId` set to `prj_billing2222`.
FAIL if no `create_workspace` call is stated, the stated call has no `projectId`, or it passes `prj_ctrl1111` or any other project.

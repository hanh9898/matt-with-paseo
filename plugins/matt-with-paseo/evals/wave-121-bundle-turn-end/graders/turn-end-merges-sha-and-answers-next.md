---
type: llm
---

Bundle 11+12 (agent-11, branch `wave1/11-starters`) ended a turn with ticket 11's report and its last commit `a11c0de`; its `lastUsage` reads `contextWindowUsedTokens` 180000, and it has done 1 of the ticket cap of 4. Ticket 12 is still to do.

PASS if the planned actions for this turn end merge ticket 11 by its SHA (a merge of `a11c0de`, not of the branch `wave1/11-starters`) as its own merge commit, and then send agent-11 the answer `next`.
FAIL if the branch is merged instead of the SHA, if agent-11 is answered `stop`, if no answer is sent to agent-11, or if the answer is sent before the merge.

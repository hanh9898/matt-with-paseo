---
type: llm
---

Bundle 31+32+33+34+35 (agent-31, branch `wave1/31-desserts`) ended a turn with its 4th ticket's report: ticket 34, last commit `c34beef`. Tickets 31 to 33 are already merged. Its `lastUsage` reads `contextWindowUsedTokens` 350000, well under the context stop of 600K. The common rules' ticket cap is 4, and ticket 35 is still to do.

PASS if the plan merges `c34beef` and then answers agent-31 `stop` because the bundle has done the ticket cap, although its context is under the context stop.
FAIL if agent-31 is answered `next`, or given no answer, or if the plan does not merge ticket 34's SHA.

---
type: llm
---

Bundle 41+42+43 (agent-41, branch `wave1/41-specials`) ended a turn with ticket 41's report and its last commit `d41ace5`. Its `lastUsage` reads `contextWindowUsedTokens` 612000, at or past the context stop of 600K, though it has done only 1 of the ticket cap of 4. Tickets 42 and 43 are still to do.

PASS if the plan merges `d41ace5`, and then answers agent-41 `stop` because its context is at or past the context stop, not `next`.
FAIL if agent-41 is answered `next`, or given no answer, or if the plan does not merge ticket 41's SHA.

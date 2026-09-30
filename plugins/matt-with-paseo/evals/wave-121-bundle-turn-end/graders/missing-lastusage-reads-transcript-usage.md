---
type: llm
---

Bundle 21+22 (agent-21, branch `wave1/21-drinks`) ended a turn with ticket 21's report and its last commit `b21f00d`. `get_agent_status` has no `lastUsage` field for it. The last main-chain `usage` in its transcript shows `contextWindowUsedTokens` 210000, under the context stop of 600K.

PASS if the plan reads the context from the last main-chain `usage` in agent-21's transcript because `lastUsage` is missing (it does not skip the read, and does not treat the missing field as a stop or as zero use), merges `b21f00d`, and sends agent-21 `next`.
FAIL if the plan never reads the transcript's `usage` for agent-21, if it answers agent-21 `stop`, or if it sends no answer to agent-21.

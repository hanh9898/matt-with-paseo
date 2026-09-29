---
type: llm
---

The stream `billing-export`'s status line says it waits on the stream agent `3e0a7953` and records the end-of-turn message of 10:20 as handled. Now that agent is idle, its last end-of-turn message is still that one of 10:20, and no question of it is pending. Its wave's ticket agents are idle. The stream waits on an agent that is waiting for nothing.

PASS if the final reply sends `3e0a7953` the prompt "where does the stream stand?" with `send_agent_prompt`, `background: true` and `notifyOnFinish: true`, or says it would send exactly that, so that the agent's answer comes back as a finish notification. This session cannot call Paseo, so saying what it would send is enough.
FAIL if it leaves `3e0a7953` idle with nothing to do, sends the prompt without a finish notification (`notifyOnFinish` false or not named), restarts, kills, cancels or archives it, prompts a ticket agent (`7c1d2e40` or `9a8b7c6d`), or sends the same prompt to `5b7c9d11`.

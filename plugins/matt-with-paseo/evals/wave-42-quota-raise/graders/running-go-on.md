---
type: llm
---

The wave skill runs under stream `billing`; `agent-01` and `agent-02` are running. The prompt `quota 4` arrived.

PASS if the final reply leaves `agent-01` and `agent-02` running, without cancelling, killing, archiving, re-prompting or replacing them.
FAIL if it cancels, kills, archives, re-prompts or replaces either agent.

---
type: llm
---

The wave skill runs under stream `billing` with quota 2 and was held. Under the hold, ticket 01 was merged; `agent-02` (ticket 02) is still running and counts against the quota; 03 and 04 wait. Then the prompt `release` arrived.

PASS if the final reply starts ticket 03 now, as its next actions (a `create_workspace` and a `create_agent` for it, or an equivalent statement that it spawns 03 now), off the integration branch's current head (which includes 01's merge), and keeps 04 waiting on the quota because 02 still counts.
FAIL if it keeps 03 waiting until 02 reports or merges, asks for confirmation first, spawns 04 as well now, or cancels, kills or re-prompts `agent-02`.

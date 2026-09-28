---
type: llm
---

The wave skill runs under stream `billing`. Ticket 01's report just passed step 5; ticket 02's agent is still running. Then the prompt `hold` arrived. A hold stops only new spawns: work already running carries on.

PASS if the final reply still merges 01 into `stream/billing` (or states that it does so as its next action) and leaves `agent-02` running, without cancelling, killing, archiving or interrupting it.
FAIL if it stops the whole run, including leaving 01 unmerged until a release, or if it cancels, kills, archives or interrupts `agent-02`.

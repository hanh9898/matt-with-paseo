---
type: llm
---

The wave skill runs under stream `billing` with quota 3. `agent-02` and `agent-03` are running; ticket 01's report just passed step 5. Then the prompt `quota 1` arrived, which is below the number of running ticket agents.

PASS if the final reply leaves `agent-02` and `agent-03` running (no cancel, kill, archive, interrupt or re-prompt to stop), and still merges 01 or states that it does so next.
FAIL if it cancels, kills, archives or interrupts `agent-02` or `agent-03`, or asks one of them to stop, to bring the count down to the new quota.

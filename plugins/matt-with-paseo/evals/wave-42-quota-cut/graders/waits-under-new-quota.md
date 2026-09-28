---
type: llm
---

The wave skill runs under stream `billing`. Ticket 04 waits on the quota. Ticket 01's report just passed step 5, which under the old quota of 3 would let rolling start spawn 04. Then the prompt `quota 1` arrived; `agent-02` and `agent-03` still count against it.

PASS if the final reply does not spawn 04 now, and says 04 waits until fewer than one ticket agent counts (that is, until both 02 and 03 have stopped counting), under the new quota of 1.
FAIL if it spawns or plans to spawn 04 now, keeps applying the old quota of 3, rejects the prompt, or says the quota can change only by restarting or replacing the run.

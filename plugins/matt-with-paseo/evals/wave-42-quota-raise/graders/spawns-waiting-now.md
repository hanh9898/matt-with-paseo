---
type: llm
---

The wave skill runs under stream `billing` with quota 2. Tickets 01 and 02 are running and have not reported; 03 and 04 wait on the quota. Then the prompt `quota 4` arrived.

PASS if the final reply takes the new quota of 4 and starts 03 and 04 now, as its next actions (a `create_workspace` and a `create_agent` for each, or an equivalent statement that it spawns both now), off the integration branch's current head.
FAIL if it keeps 03 or 04 waiting until 01 or 02 reports, merges or stops, asks the user or the stream skill to confirm first, rejects the prompt, or says the quota can change only by restarting or replacing the run.

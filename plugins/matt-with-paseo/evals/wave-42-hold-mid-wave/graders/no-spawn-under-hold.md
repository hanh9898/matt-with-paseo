---
type: llm
---

The wave skill runs under stream `billing` with quota 2. Tickets 01 and 02 were spawned; 03 and 04 wait on the quota. Ticket 01's report just passed step 5, which would normally let rolling start spawn 03. Then the prompt `hold` arrived.

PASS if the final reply spawns neither 03 nor 04 (no `create_workspace` or `create_agent` for them, now or as its next action) and says they wait until the hold is released.
FAIL if it spawns or plans to spawn 03 or 04 now, including as rolling start after merging 01.

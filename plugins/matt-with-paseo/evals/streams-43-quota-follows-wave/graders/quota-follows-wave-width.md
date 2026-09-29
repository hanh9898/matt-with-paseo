---
type: llm
---

The stream `reports` reaches its wave boundary: its stream agent `9a1c7e22` is idle with no `wave`-labelled agent running for the stream, and its last end-of-turn message is the wave approval "Wave 4: tickets 12 and 13 start now; 14, 15 and 16 wait on the quota. Approve wave 4?" — a next wave of width 5 (2 tickets starting plus 3 waiting on the quota). The tracker separately shows 16 tickets in the ready for agent role, most still blocked by others. The session writes no file, so the final reply states the quota it would give `reports` instead of writing it.

PASS if the reply's proposed new quota for `reports` is 5 or less, and it derives that number from the wave approval's stated width (2 starting plus 3 waiting), not from the tracker's 16 ready tickets.
FAIL if the proposed quota is above 5 (for example 11 or 16), or if the reply sizes the quota from the count of ready tickets on the tracker rather than the wave approval's stated width.

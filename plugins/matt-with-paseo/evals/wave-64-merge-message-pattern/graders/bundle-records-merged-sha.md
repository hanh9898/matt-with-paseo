---
type: llm
---

Tickets 03 and 04 are one bundle whose `## Wave agents` row reads `03+04`, with an empty merged-SHA column. Ticket 03 is reported with `3a1f9c2`, ticket 04 with `7b4e0d8`.

PASS if the reply says that, after merging each ticket, the merged SHA goes into the merged-SHA column of the bundle's row (ticket 03's `3a1f9c2` after the first merge, ticket 04's `7b4e0d8` after the second), rather than once for the bundle or not at all.
FAIL if the reply never records the SHAs in the bundle's row, or records them only after both merges as one entry.

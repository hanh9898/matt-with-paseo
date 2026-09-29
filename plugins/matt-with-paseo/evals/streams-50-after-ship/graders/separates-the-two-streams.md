---
type: llm
---

The control folder has two shipped streams, each asked to be fixed: `invoice-hub` (ticket 03 still open) and `billing-portal` (ticket 04 already resolved, integration branch at a new head `9c8d7e6`). Each stream's action depends only on its own state.

PASS if the final reply keeps the two streams' outcomes separate: it does not ask a ship question for `invoice-hub` (not at its last stage), does ask one for `billing-portal` (at its last stage), and does not apply one stream's finding (open ticket, new head, ship question) to the other stream.
FAIL if it asks to ship `invoice-hub`, fails to ask for `billing-portal`, or otherwise mixes the two streams' status lines, tickets or actions together.

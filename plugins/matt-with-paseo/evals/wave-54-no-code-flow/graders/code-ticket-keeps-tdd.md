---
type: llm
---

Wave 1 has two tickets and no agent yet. Ticket 01 (`.scratch/export/issues/01-month-filter.md`) adds a month filter to `listInvoices` in `src/invoices.js`: behaviour that should exist.

PASS if the final reply gives ticket 01 a flow with `/mattpocock-skills:tdd`.
FAIL if ticket 01's flow has no `/mattpocock-skills:tdd`, or 01 gets no flow at all.

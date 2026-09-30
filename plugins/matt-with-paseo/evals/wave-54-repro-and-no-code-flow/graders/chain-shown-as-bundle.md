---
type: llm
---

Ticket 05 (`.scratch/invoices/issues/05-sort-by-amount.md`) is blocked only by ticket 04 (`.scratch/invoices/issues/04-sort-by-date.md`), and 04 blocks only 05: a chain with no branch.

PASS if the graph in the final reply shows tickets 04 and 05 as one bundle written `[04+05]`, and the upcoming wave it proposes keeps that bundle.
FAIL if the graph shows 04 and 05 only as separate tickets joined by an arrow (for example `04 -> 05`), if no `[NN+NN]` bundle appears in the graph, or if the bundle is left out of the upcoming wave.

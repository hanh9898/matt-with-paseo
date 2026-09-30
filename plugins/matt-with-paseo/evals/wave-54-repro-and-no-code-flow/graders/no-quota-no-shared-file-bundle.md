---
type: llm
---

Tickets 06 (`.scratch/invoices/issues/06-json-format.md`) and 07 (`.scratch/invoices/issues/07-tsv-format.md`) are independent and each adds a line to `src/formats.js`. The run has no `quota`, so every ticket that can run now starts in the wave and nothing waits on a quota. The chain 04 and 05 is the one case that is bundled here.

PASS if the graph in the final reply shows the chain as a bundle `[04+05]` and keeps 06 and 07 as two separate tickets of the upcoming wave, with no bundle joining them.
FAIL if 06 and 07 are grouped in one bundle (for example `[06+07]`), if either is left out of the upcoming wave, or if the graph shows no `[NN+NN]` bundle at all.

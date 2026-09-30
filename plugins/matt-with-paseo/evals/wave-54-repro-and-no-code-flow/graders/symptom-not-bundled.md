---
type: llm
---

Ticket 02 (`.scratch/invoices/issues/02-total-skips-last-line.md`) is a symptom ticket, and ticket 08 (`.scratch/invoices/issues/08-show-corrected-total.md`) is blocked only by 02, so 02 and 08 look like a chain. A symptom ticket needs its own base commit for its reproduction, so it is never bundled.

PASS if the graph in the final reply shows the chain 04 and 05 as `[04+05]`, and shows 02 in no bundle (no `[02+08]`, no `[NN+02]`), with 08 not started in the upcoming wave.
FAIL if 02 appears in any `[NN+NN]` bundle, if 08 is put in the upcoming wave, or if the graph shows no `[NN+NN]` bundle at all.

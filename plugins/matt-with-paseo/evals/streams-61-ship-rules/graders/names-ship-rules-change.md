---
type: llm
---

The stream `invoice-close`'s status line recorded `ship rules read at 9c8b7a6` from its own earlier setup; at that hash, its repository's `docs/ship-rules.md` held only `squash: true`. Since then, one commit on its PR target (`origin/main`, now at `4d5e6f7`) added a `labels` key, `needs-review`, touching no path the stream itself changed. Its ship branch still merges cleanly.

PASS if `invoice-close`'s ship question (or the reply's account of building it) names that the ship rules changed since setup, specifically that a `labels` key is now present with value `needs-review` where none was before, and does not claim there is no change.
FAIL if the reply never reaches a ship question or reconciliation for `invoice-close`, says its ship rules are unchanged since setup, states a change other than the `labels` key described here, or invents a change to a key not affected here (such as `squash`).

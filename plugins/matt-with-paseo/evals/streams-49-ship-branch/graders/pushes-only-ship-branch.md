---
type: llm
---

The control folder has three streams at their last stage. Look at what the final reply plans to push, across all three: `invoice-export`'s clean ship, `price-sync`'s conflict (nothing pushed), and `tracker-docs`'s already-answered yes. The session has no shell, so the reply states what it would run; a command stated that way counts as run.

PASS if every push the reply plans or runs, for any of the three streams, names only a ship branch (`stream/invoice-export-ship`, `stream/tracker-docs-ship`, or the stream's own ship branch by another name it gives) - never `stream/invoice-export`, `stream/tracker-docs`, `stream/price-sync`, `main`, or any wave or ticket branch. Planning no push at all for a stream (as for `price-sync`, and for `invoice-export` before the user answers) is fine.
FAIL if any planned or run push names the integration branch (`stream/<slug>` with no `-ship`), the base branch, or a wave or ticket branch, for any of the three streams.

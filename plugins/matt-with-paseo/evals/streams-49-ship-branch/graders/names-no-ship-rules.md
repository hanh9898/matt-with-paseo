---
type: llm
---

The control folder has three streams at their last stage. Look only at what the final reply says about `invoice-export`: its repository declares no ship rules (`origin/main`'s `AGENTS.md` names only the tracker, no ship-rules pointer), and its status line has never recorded reading any ship rules.

PASS if `invoice-export`'s ship question (or the reply's account of it) says that no ship rules are declared and that it ships on the defaults (ship branch `stream/invoice-export-ship`, a one-line title, a description from `/mattpocock-skills:pr`, no draft, no metadata), without inventing another pattern or claiming a change since some earlier setup.
FAIL if the reply never mentions ship rules for `invoice-export`, invents a custom branch or title pattern not stated here, or claims ship rules changed since setup when no setup ever recorded reading any.

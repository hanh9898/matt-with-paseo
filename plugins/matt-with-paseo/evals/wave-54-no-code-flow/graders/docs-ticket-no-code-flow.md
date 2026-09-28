---
type: llm
---

Wave 1 has two tickets and no agent yet. Ticket 02 (`.scratch/export/issues/02-export-readme.md`) only adds a section to `README.md` and says "No code changes"; ticket 01 changes `src/invoices.js`.

PASS if the final reply gives ticket 02 a flow without a test-first or diagnosis skill (no `/mattpocock-skills:tdd`, no `/mattpocock-skills:diagnosing-bugs`), in which each of 02's acceptance criteria is checked by something actually run or looked at (for example a `grep` for the heading, reading the rendered section), and which may end with `/mattpocock-skills:code-review`.
FAIL if ticket 02's flow includes `/mattpocock-skills:tdd` or `/mattpocock-skills:diagnosing-bugs`, if 02 gets no flow at all while 01 gets one, or if 02 is left out of the wave.

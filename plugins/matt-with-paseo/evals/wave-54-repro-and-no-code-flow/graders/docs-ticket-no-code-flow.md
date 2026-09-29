---
type: llm
---

Ticket 03 (`.scratch/invoices/issues/03-export-readme.md`) only adds a section to `README.md` and says "No code changes"; ticket 01 builds a CSV export in code.

PASS if the final reply gives ticket 03 a flow without a test-first or diagnosis skill (no `/mattpocock-skills:tdd`, no `/mattpocock-skills:diagnosing-bugs`), in which each of 03's acceptance criteria is checked by something actually run or looked at (for example a `grep` for the heading, reading the rendered section), and which may end with `/mattpocock-skills:code-review`.
FAIL if ticket 03's flow includes `/mattpocock-skills:tdd` or `/mattpocock-skills:diagnosing-bugs`, if 03 gets no flow at all while 01 gets one, or if 03 is left out of the upcoming wave.

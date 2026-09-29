---
type: llm
---

`invoice-close`'s ship rules declare `squash: true` and nothing for `delete source branch`.

PASS if `invoice-close`'s ship question (or the reply's account of building it) states squash as on/true for the planned pull request, and states delete-source-branch as not set (the forge's own setting stands) rather than omitting it.
FAIL if the reply never reaches a ship question or reconciliation for `invoice-close`, omits squash or delete-source-branch from the plan entirely, says squash is off or unset, or invents delete-source-branch as set.

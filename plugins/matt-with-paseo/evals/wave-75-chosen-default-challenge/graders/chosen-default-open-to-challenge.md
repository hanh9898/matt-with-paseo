---
type: llm
---

Neither `.scratch/statements/spec.md` nor either ticket (`01-list-shows-date.md`, `02-detail-shows-date.md`) says which date format the list or the detail page should use. Writing the common rules at step 3 is where that choice gets made.

PASS if the final reply's named common-rules content states one date format as its own chosen default, apart from either ticket's acceptance criteria, gives the reason it was picked, and says a ticket agent may challenge it with evidence in its ticket's comments.
FAIL if the date format is folded into a ticket's acceptance criteria as a requirement, stated with no reason, or given with no way for a ticket agent to challenge it.

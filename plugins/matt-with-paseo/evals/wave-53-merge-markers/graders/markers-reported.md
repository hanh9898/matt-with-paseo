---
type: llm
---

The integration branch `main` has a merge of ticket 02's branch in progress: git says all conflicts are fixed, but the staged `src/invoices.js` still holds conflict markers (`<<<<<<< HEAD` … `>>>>>>> wave1/02-month-filter`).

PASS if the final reply reports that `src/invoices.js` still holds conflict markers, and leaves the merge uncommitted: it says the merge must not be committed as it stands (the markers are resolved and searched for again first, or the merge is aborted and redone).
FAIL if it does not mention the conflict markers in `src/invoices.js`, or if it proposes or performs committing that merge (for example "conclude the merge with git commit", "finish the merge, then verify") before the markers are gone.

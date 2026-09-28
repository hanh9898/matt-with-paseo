---
type: llm
---

The integration branch `main` has a merge of ticket 02's branch in progress, which git merged without a conflict and stopped before committing. Ticket 02's branch had itself committed conflict markers, so the staged `src/invoices.js` still holds them (`<<<<<<< HEAD` … `>>>>>>> main`).

PASS if the final reply reports that `src/invoices.js` still holds conflict markers, and leaves the merge uncommitted: it says the merge must not be committed as it stands (the markers are resolved and searched for again first, or the merge is aborted and redone).
FAIL if it does not mention the conflict markers in `src/invoices.js`, or if it proposes or performs committing that merge (for example "conclude the merge with git commit", "finish the merge, then verify") before the markers are gone.

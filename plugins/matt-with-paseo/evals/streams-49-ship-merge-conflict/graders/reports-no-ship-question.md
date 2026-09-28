---
type: llm
---

The stream `invoice-export` is at its last stage, but its PR target `main` has moved since the cut and a merge of the ship branch into `origin/main` conflicts on `src/export/csv.ts`. Nothing has been pushed; the user has not been asked about shipping yet.

PASS if the final reply reports to the user that the stream's branch does not merge cleanly into `main`, naming `src/export/csv.ts`, and asks no ship question: it does not ask whether to push or open the pull request, and does not offer "yes" to ship.
FAIL if it asks the user whether to ship (push, open the pull request) in any form, even with the conflict mentioned beside the question, or if it pushes or opens the pull request.

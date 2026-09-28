---
type: llm
---

The control folder has three streams at their last stage. Look only at what the final reply says about `price-sync`: its PR target `main` moved after the cut, and a merge of its ship branch into `origin/main` conflicts on `src/price-sync/main.ts`. Nothing is pushed; the user has not been asked about shipping it.

PASS if the final reply reports to the user that `price-sync` does not merge cleanly into `main`, naming `src/price-sync/main.ts`, and asks no ship question for `price-sync`: it does not ask whether to push or open its pull request, and does not offer "yes" to ship it.
FAIL if it asks the user whether to ship `price-sync` (push, open the pull request) in any form, even with the conflict mentioned beside the question, if it says nothing about `price-sync`'s conflict, or if it pushes or opens the pull request.

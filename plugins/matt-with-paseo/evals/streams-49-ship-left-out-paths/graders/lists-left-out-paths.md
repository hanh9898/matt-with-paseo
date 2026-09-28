---
type: llm
---

The stream `invoice-export` is at its last stage. Its integration branch `stream/invoice-export` changes code (`src/export/csv.ts`, `src/export/csv.test.ts`), a tracker configuration file (`docs/agents/issue-tracker.md`), and files only agents need: the stream's local-markdown spec and tickets under `.scratch/invoice-export/`, the wave file `.scratch/invoice-export/wave1-common-rules.md`, and a binary `.scratch/invoice-export/evidence/export.png`. Nothing has been pushed; the user has not been asked yet.

PASS if the final reply puts a ship question to the user (whether to push and open the pull request to `main`) that lists as left out of the pull request both the stream's ticket folder (`.scratch/invoice-export/`, or its spec and ticket files by name) and the wave file `wave1-common-rules.md`, while `src/export/csv.ts` still ships.
FAIL if there is no ship question, if the question offers the integration branch with the ticket folder and wave file still in it (or does not say they are left out), if it lists `src/export/csv.ts` as left out, or if it pushes or opens the pull request before the user answers.

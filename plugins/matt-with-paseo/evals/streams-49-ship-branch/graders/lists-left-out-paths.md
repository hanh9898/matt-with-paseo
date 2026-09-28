---
type: llm
---

The control folder has three streams at their last stage. Look only at what the final reply says about `invoice-export`: its integration branch changes code (`src/invoice-export/main.ts`, `main.test.ts`), the tracker configuration file `docs/agents/issue-tracker.md`, and files only agents need: the local-markdown spec and tickets under `.scratch/invoice-export/`, the wave file `.scratch/invoice-export/wave1-common-rules.md`, and a binary `evidence/screen.png`. It merges cleanly into `main`; nothing is pushed and the user has not been asked yet. The session has no shell and writes no file, so the reply may state what it would run instead of running it.

PASS if the final reply puts a ship question for `invoice-export` to the user (whether to push and open the pull request to `main`) that lists as left out of the pull request both the stream's ticket folder (`.scratch/invoice-export/`, or its spec and ticket files by name) and the wave file `wave1-common-rules.md`, while `src/invoice-export/main.ts` still ships. Leaving out `docs/agents/issue-tracker.md` and the png as well is fine, and so is any label the reply gives each path.
FAIL if there is no ship question for `invoice-export`, if the question offers the integration branch with the ticket folder and wave file still in it (or does not say they are left out), if it lists `src/invoice-export/main.ts` as left out, or if it pushes or opens the pull request before the user answers.

# Evidence standards

How this repository proves a change works, and when each proof runs. The wave skill points every agent here from its common rules; this file overrides the wave skill's per-ticket review, per-merge verification and per-wave seam review wherever they differ. The owner set these rules on 2026-09-30 (the control folder's decisions D24, D105 and D108).

## What runs when

| When | What runs | Costs |
|---|---|---|
| Each ticket | Its own new or changed test file, once: red on the base, then green after the change | Seconds of CPU, no tokens |
| Each merge into the integration branch | The conflict-marker search of the wave skill's step 6, nothing else | Nothing |
| Each push of a ship branch | The pre-push hook (`.githooks/pre-push`): the drift check's tests, then the drift check | Seconds of CPU |
| Each pull request into `main` | CI (`.github/workflows/ci.yml`) on Ubuntu, macOS and Windows: every unit test (`python -B -m unittest discover -s scripts`), then the drift check | CI minutes, no tokens |
| Once per stream, after its last wave | One code review over the whole stream diff, on both axes; one fix pass; then the one eval run | Tokens |

## Each ticket

A ticket proves its acceptance criteria with the checks it writes: a test, or for a change to no code, a `grep`, a parse or a link check. Before the change, the ticket agent runs its new or changed test file once and sees it fail; after the change, it runs the same file once and sees it pass. It records both runs in its `Resolved:` comment. It runs no other test file, not the full suite, not the drift check, no eval and no code review.

A test that has never been seen red proves nothing: a test written to match the code it tests is a finding at the stream review.

## Each pull request into `main`

CI runs every unit test and the drift check on the three operating systems. The orchestrator never merges a pull request whose CI is red: the stream agent runs one fix pass on its integration branch, the ship branch is cut again, and CI runs again. A drift check that cannot run (exit 2, for one when Matt's plugin is not installed on the CI runner) warns and does not fail CI.

## Once per stream

After the stream's last wave: one code review over the whole stream diff (`mattpocock-skills:code-review`, both axes, Standards and Spec), one fix pass, then the one eval run: `CLAUDE_CODE_EFFORT_LEVEL=medium claude plugin eval --model sonnet -j 2 --runs 1 --ablation none --scaffold --trust-plugin --no-publish .` from `plugins/matt-with-paseo`.

After that run, re-run only the cases the stream touched or whose verdict changed from the previous stream's run, with `--case <name> --runs 3`. The previous stream's eval report is the baseline: no separate baseline run. Switch the judge to `--judge-model sonnet` only for a case suspected of a wrong verdict. Cases below 1.00 that stay unfixed go into the ship pull request's Merge Danger with the comparison to the previous run.

At most one new eval case per ticket, and only when its acceptance criteria name an eval; extend an existing case where one covers it.

## What a test pins

A test pins behaviour or structure, never wording:

- Allowed: a skill's behaviour through an eval case; a script's output; the structure of a document (a link resolves, a file exists, a table has its columns, a pinned line listed in `scripts/pinned-lines.json` is present).
- Not allowed in a new test: a whole sentence of prose copied into an assertion. Such a test fails each time someone rewords the sentence and catches no change in behaviour.

## Declarations for the wave skill

- **Full check:** `python -B -m unittest discover -s scripts`, then `python -B scripts/drift-check.py`.
- **Branches whose pull requests run CI:** `main`.

## Writing files

Agents write and edit files with the Write and Edit tools, never through a shell heredoc, `python -c` or `sed`: on the owner's machine a shell swallows backslashes, so an escape such as backslash-n or backslash-b arrives broken in the file.

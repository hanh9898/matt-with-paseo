# Common rules template for a wave

Copy the frame below into `wave<N>-common-rules.md` and fill in each section. Each section answers a question every agent in the wave would otherwise ask itself; answered here once, no agent has to guess.

Steps 3, 4 and 7 of the skill append three sections, `## Checkpoints`, `## Wave agents` and `## Review`, to the end of the file; leave all three out when writing the rules.

Copy in only what an agent cannot look up: an unwritten convention, the reason behind a choice, a trap already hit. Anything one command or one file answers (scripts in `package.json`, the directory layout, `CLAUDE.md`) gets a pointer, not a copy.

```markdown
# Common rules for wave <N> (tickets <NN>, <NN>)

## Graph
`<one-line graph from step 2, e.g. 01✓ → {02, 03?} → 04>`

| Ticket | Status | Blocked by | Wave |
|---|---|---|---|
| <NN> | <status> | <NN, NN or -> | <N, or what blocks it> |

## Context
- Your worktree branches off `<integration branch>` at `<base commit>`, unless your prompt names another base commit
  (a ticket started mid-wave). That branch already contains tickets <...>.
  Run `git branch --show-current` before every commit.
- Read before you start: <spec>, <glossary / CONTEXT.md>, <ADRs>, your ticket, and the comments
  of tickets <...> for decisions already made.
- <k> other agents are working the remaining tickets of this wave in parallel, on other branches.
  Work only on your own ticket.
- Do not end your turn while work you started is still running in the background (a build, a test run,
  a long command, the review sub-agents `mattpocock-skills:code-review` launches): wait for it inside
  the same turn. Paseo sends no finish notification for a turn you start on your own afterwards, so
  your "finished" report must mean the work is done.
- Start any command that may take more than two minutes (a test suite, a build, a container, a commit
  with slow hooks) in the background from the start, and read its output when it finishes. A foreground
  command the shell moves to the background halfway can leave your turn waiting on a result that never
  returns.

## Existing interfaces to reuse
- `<function / hook / module>`: <signature>, <what it returns>, <what it already handles, e.g. sending mail, logging>.
- Business rules go through the interfaces above; new layers only call them.

## File zones
- Ticket <NN> writes in `<own file>`; ticket <NN> writes in `<own file>`.
- Shared files (<manifest, package index, route table, permission file>): add only your own lines, and keep
  the order of the existing lines.

## Traps already hit
- <trap>: <symptom>, <how to avoid it>, <how to check you avoided it>.

## Failing on base
- On `<base commit>`, before the first spawn: `<each verification command the repo has: install, build, lint, test>`
  fails in <each failing test or check, with its first error line>, or "none: every command passes".
- A failure listed here is not yours: leave it as it is unless your ticket's acceptance criteria name it, and
  name it in your report as failing on base. A failure not listed here is yours to explain.
- In a repository with a version gate (this plugin's: `scripts/check-version-gate.py`, which compares the files
  agents read with the latest release tag), its self-test `test_this_repository_passes_its_own_gate` fails on the
  base of every ticket started after the stream's first change to such a file, until the stream bumps the version
  once. List it here for those tickets; it is not theirs.

## Acceptance criteria are the contract
- A trap above, or an instruction an earlier ticket left in its comments, is guidance; your ticket's
  acceptance criteria are the contract.
- On conflict, follow the criteria and write the discrepancy and its reason in your ticket's comments;
  do not stop to ask.
- If the criteria themselves look wrong, stop that part, write the evidence in your ticket's comments,
  and move the ticket to `<ready for human label from the triage label file>`. Never rewrite the criteria.

## What must hold, what was chosen, what is not known yet

| Part | What it holds | What you do when your evidence goes against it |
|---|---|---|
| Must hold | Your ticket's acceptance criteria, and the section above. | Follow the section above; never rewrite the criteria. |
| Chosen for you | `<choice>`: `<the reason it was made>`. | Challenge it with evidence, in your ticket's comments and your report. A challenge alone does not move the ticket to `<ready for human label from the triage label file>`. |
| Not known yet | `<the open question>`. | `<who resolves it, or how to proceed while it stays open>`. |

Whoever answers a challenge to a chosen default writes why the plan changes or stands; an answer with no reason is not a resolution.

## Resources
- Your private resources are listed in your prompt (database, port when no service is declared, volume,
  temp directory). Use exactly that set. Create each one when you first need it, and leave it in place
  when you finish: a review finding may come back to you. The orchestrator removes it once your ticket is
  merged and the wave reviewed.
- Shared resources, read-only: <main container, source database, another session's browser profile>.
- Shared resources you may write to, and machine-wide locks: <a shared server, a render lock>: <what it
  guards>, <how to take it, how to see who holds it, how to release it>. Hold a lock only while the command
  that needs it runs.

## Repo and user rules
- <commit and comment language>, <accepted way to verify>, <lint command>, <test accounts>.
- Commit format: <the commit-message format the repository's own agent documents declare, repeated here
  in full rather than pointed to, since a ticket agent commits often and cannot re-read those documents
  before each one>; <or "none declared: match this repo's existing commit style">.
- Credentials: never read, print or pass on a token or credential (no `gh auth token`, no reading a CLI's
  hosts or config file or a token's environment variable, no token in a URL or a command). A `gh`, `glab`,
  push or upload failure goes into your report with the command and its error as printed; never work
  around it with another tool, the forge's API or another account.
- Evidence standards: read `<path to the evidence standards file, or "none declared">`; it is not copied here.
  Name it in your `mattpocock-skills:code-review` call.

## Done when:
- Commit to your branch. The orchestrator merges it. Pull-request descriptions and discussion are written
  by whoever ships, outside this wave: keep none in your worktree, and put what they need in your report.
- Before the last commit: run `/mattpocock-skills:code-review` with your base commit as the fixed point, fix the
  findings, and write the number of findings per axis and the outcome of each into the ticket's comments.
- Change the ticket status: `resolved` if fully done, `<ready for human label from the triage label file>` for the part a human must do.
  Write in the comments what you verified, with evidence, and what remains open.
- For a change the user sees, the screenshots include the screen scrolled past its first view and at a
  narrow width.
- Report back: a design summary, files touched, how you verified with evidence, work not done or still
  in doubt, every change outside your file zone or outside git (a file in another checkout, a machine
  setting, an uncommitted file) with where it is, each private resource you created, and decisions the
  user must make. Tag each decision `decided: X because Y` or `assumed: X, unchecked`, and each finding
  `reproduced` or `traced`, so a reader scans the report instead of parsing its prose.
```

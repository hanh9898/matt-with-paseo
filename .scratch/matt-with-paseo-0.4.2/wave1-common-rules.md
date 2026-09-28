# Common rules for wave 1 (tickets #38, #60, #56)

## Graph
`{38, 60, 56} → {39, 40, 41, 42, 46, 47, 48, 49, 51, 52, 53, 54}; 42 → {43, 44}; {42, 43} → 45; 49 → 50; {41, 48} → 55; {60, 47} → 61 → {62, 64} (also on 49); 62 → 63; {63, 64} → 65; {39…56} → 58; 66 in triage`

| Ticket | Status | Blocked by | Wave |
|---|---|---|---|
| #38 Vocabulary, ADRs 0005–0007, entry guards | open, ready-for-agent | - | 1 |
| #60 Coding standards for agent documents and loops | open (reopened), ready-for-agent | - | 1 |
| #56 Draft upstream bug reports from the run | open, ready-for-agent | - | 1 |
| #39, #40, #41, #42, #46, #47, #48, #49, #51, #52, #53, #54 | open, ready-for-agent | #38 (and reviewed against #60) | after #38, #60 |
| #43, #44 | open, ready-for-agent | #42 | after #42 |
| #45 | open, ready-for-agent | #42, #43 | after #43 |
| #50 | open, ready-for-agent | #49 | after #49 |
| #55 | open, ready-for-agent | #41, #48 | after #41, #48 |
| #61 | open, ready-for-agent | #60, #47 | after #47 |
| #62, #64 | open, ready-for-agent | #61, #49 | after #61 |
| #63 | open, ready-for-agent | #62 | after #62 |
| #65 | open, ready-for-agent | #63, #64 | after #63, #64 |
| #58 Release 0.4.2 | open, ready-for-agent | #39–#56 | last |
| #66 | needs-triage | - | none: operator keeps it in triage |

## Context
- Your worktree branches off `stream/matt-with-paseo-0-4-2` at `ec29c8e` (= `main`, release 0.4.1), unless your prompt names another base commit. That branch contains no ticket of this stream yet.
  Run `git branch --show-current` before every commit.
- **An earlier run of this stream is lost.** Comments on #38, #60 and #66 that mention `stream/v042`, `fa5cc36`, `b714708` or `48d92c6` describe commits that exist nowhere. Ignore what they say is "already there": on `ec29c8e`, `docs/adr/` has only 0001–0004, the words blocks have none of Hold, Intake agent, Pause, Checkpoint or Brief, and `CODING_STANDARDS.md` does not exist. The "uncommitted drafts in the maintainer's checkout" the tickets mention do not exist either (that checkout is clean): write from the spec.
- Read before you start: your ticket; its spec (#37 for #38 and #56, #59 for #60), including their Implementation Decisions; `AGENTS.md` and `docs/agents/domain.md` (the vocabulary lives in the words blocks of the two `SKILL.md` files, no `GLOSSARY.md`); ADRs 0001–0004 in `docs/adr/`; `README.md` sections "Contributing" and "Behaviour evals".
- 2 other agents are working the remaining tickets of this wave in parallel, on other branches. Work only on your own ticket.
- Do not end your turn while work you started is still running in the background (a build, a test run, an eval run, a long command, the review sub-agents `mattpocock-skills:code-review` launches): wait for it inside the same turn. Paseo sends no finish notification for a turn you start on your own afterwards, so your "finished" report must mean the work is done.

## Existing interfaces to reuse
- `scripts/drift-check.py`: checks every `mattpocock-skills:<name>` reference against the installed Matt plugin; default targets are both skill folders and both READMEs; `--plugin-root` overrides the plugin; exit 0 clean, 1 drift, 2 usage error. Its tests: `python -B -m unittest discover -s scripts`.
- The eval suite in `plugins/matt-with-paseo/evals/`: one folder per case with a fixture script; read an existing case (for example `streams-no-index`) and copy its shape. Run: `cd plugins/matt-with-paseo && claude plugin eval . --scaffold --trust-plugin --no-publish -j 4` (the README's "Behaviour evals" section).
- Words blocks: at the top of `plugins/matt-with-paseo/skills/matt-with-paseo/SKILL.md` (wave skill) and `plugins/matt-with-paseo/skills/matt-with-paseo-streams/SKILL.md` (stream skill). Each term is defined in one block only.

## File zones
- **#38** writes: `docs/adr/0005-*.md`, `0006-*.md`, `0007-*.md`; the stream skill (`matt-with-paseo-streams/SKILL.md`): its words block (**Intake agent**, **Pause**) and its entry guards; the wave skill's words block: **Hold** only; `docs/agents/domain.md` and `AGENTS.md` (naming the new terms); README section "Behaviour evals" only; new eval case folders under `plugins/matt-with-paseo/evals/` (prefix `streams-`).
- **#60** writes: `CODING_STANDARDS.md` (new, repo root); the wave skill's words block: **Checkpoint** and **Brief** only; README section "Contributing" above "Behaviour evals"; `scripts/drift-check.py` and its tests under `scripts/`.
- **#56** writes only under `.scratch/improve-matt-with-paseo/bug-reports/`.
- Shared file: the wave skill's words block. Add only your own terms, as whole lines, and keep the order of the existing lines. The orchestrator resolves the merge.
- Outside your zone: name the file and the reason in your report instead of editing it.

## Traps already hit
- Committing on the integration branch moves its HEAD. Commit only on your own branch; never check out or commit to `stream/matt-with-paseo-0-4-2`. Check: `git branch --show-current` before each commit.
- Never edit anything under `.git/` (it is shared by every worktree).
- Do not use bare `git stash`; commit a WIP commit on your branch instead.
- Commit in small steps; do not leave work outside git. Check: `git status --porcelain` is empty before your report.
- If a git command hangs, stop and report; do not delete lock files.
- A worktree directory is named by a slug, not by its branch: use `git branch --show-current`.
- Windows: `python3` is the Microsoft Store alias and fails (exit 49); run `python -B`. A lone single quote inside a Bash heredoc breaks parsing; write file content with the file-writing tool. Python needs `PYTHONIOENCODING=utf-8` for Vietnamese output. Git Bash's `/tmp` is not the path Windows Python sees; use `cygpath -w` or a path under your temp directory.
- Two Matt plugins labelled 1.2.3 are installed. The drift check's default picks the user-scope one from the upstream `mattpocock` marketplace, which ships `pr`, `implement-spec` and `retro`; that one is the reference (operator decision, #66). Do not remove references to those skills. Check: `python -B scripts/drift-check.py` exits 0 with no `--plugin-root`.
- A report said the temp directory was removed while it still existed (0.4.0 wave 3). Before reporting, list your temp directory and quote the result.
- Commands that may take more than two minutes (the eval suite) go in the background from the start, and you wait for them inside the same turn (see Context).

## Acceptance criteria are the contract
- A trap above, or an instruction an earlier ticket left in its comments, is guidance; your ticket's acceptance criteria are the contract.
- On conflict, follow the criteria and write the discrepancy and its reason in a comment on your issue; do not stop to ask.
- If the criteria themselves look wrong, stop that part, write the evidence in a comment on your issue, and add the `ready-for-human` label. Never rewrite the criteria.

## Resources
- Your private resources are listed in your prompt (a temp directory only; this repo has no database, port or volume). Use exactly that set.
- Shared resources, read-only: the run evidence in `D:\stream\` (`chat-2026-09-28.md`, `diagnose-agent-8af25598.md`, `RESUME.md`, `.diag-8af25598/`) and `D:\matt-with-paseo-streams\` (`streams.md`, `decisions.md`); the installed Matt plugins under `~/.claude/plugins/cache/`. Never write there. They name internal hosts, projects and people: nothing from them is copied into the repo in a form that names those.

## Repo and user rules
- Skills, ADRs, README and all GitHub text (issue comments, commit messages) in **English**. Commit messages follow the repo's style (`docs(adr): …`, `feat(streams): …`, `test(evals): …`, see `git log`). End every commit message with `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`.
- Match the surrounding style of each file: numbered steps, a **Done when** line per step, tables for choices, no copied Matt method; ADRs in the shape of 0001–0004.
- Accepted way to verify: turn each acceptance criterion into a check you can run (the drift check, the unit tests, the eval suite, a `grep` that must or must not match, reading a section) and record the command and its output, red before your change where the criterion is new.
- Do not push, do not tag, do not open a PR, do not close your issue.
- Credentials: never read, print or pass on a token or credential; a `gh` failure goes into your report, never worked around.
- Evidence standards: read `none declared`; it is not copied here.

## Done when:
- Commit to your branch. The orchestrator merges.
- Before the last commit: run `/mattpocock-skills:code-review` with your base commit as the fixed point, fix the findings, and write the number of findings per axis and the outcome of each into a comment on your issue.
- Mark the ticket done with a comment starting `Resolved:` (leave the issue open; the orchestrator closes it after the merge), or add `ready-for-human` for the part a human must do. Write in the comments what you verified, with evidence, and what remains open.
- Clean up your temp directory; state the reason for anything you keep.
- Report back: a design summary, files touched, how you verified with evidence, work not done or still in doubt, and decisions the user must make.

## Wave agents

| Ticket | Agent id | Workspace id | Branch | Base commit | Private resources | Cleaned |
|---|---|---|---|---|---|---|
| #38 | 54dc5e7b-e19f-400b-8080-d9d6d14bce69 | wks_e80c4bfd2fbcffa6 | `matt-with-paseo-0-4-2/wave1/38-vocabulary-adrs` | `ec29c8e` | temp `%TEMP%\matt-with-paseo-0-4-2-wave1-38` | [x] |
| #60 | f95e1f89-0070-48bf-956b-6d118fe3100f | wks_a3462c5bbceac754 | `matt-with-paseo-0-4-2/wave1/60-coding-standards` | `ec29c8e` | temp `%TEMP%\matt-with-paseo-0-4-2-wave1-60` | [x] |
| #56 | 195a7220-3c26-4a15-8c6e-74dd10176d63 | wks_8c5dc8972c1497e0 | `matt-with-paseo-0-4-2/wave1/56-upstream-bug-drafts` | `ec29c8e` | temp `%TEMP%\matt-with-paseo-0-4-2-wave1-56` | [x] |

Heartbeats: `bfcdb2f7` (every 10 min, expires 3h) watches #38 agent 54dc5e7b, whose turn ended while its eval suite ran in the background.

Rolling start not applied after #38 merged: these frozen rules give no file zones to the 12 tickets it unblocked (#39–#42, #46–#49, #51–#54), and ten of them edit the stream skill. They open wave 2 with zones of their own.

## Review

Fixed point `ec29c8e`, run in the orchestrator's session (no profile has review notes). Each ticket was reviewed alone by its agent; this pass reports seams only.

- **Standards: 1 finding.** Entry guard 2 (Paseo's tools) was prose next to guard 1's table, against `CODING_STANDARDS.md` H1. **Fixed** by #38's agent in `ee0ea02`, merged as `daca926`; `streams-no-paseo-tools` 1.00 with / 0.33 without, drift check exit 0. Checked clean: the words block (Checkpoint, Brief, Hold under "Words used throughout:"), `AGENTS.md`/`docs/agents/domain.md` term lists, the drift check's scope covering the new eval cases, the bug reports against ADRs 0005–0007.
- **Spec: 5 findings.**
  - **Pause** clashes with step 7's "paused, overlaps …" in the stream skill: **deferred to #51** (overlap), carried into wave 2's zones.
  - **Hold** clashes with the bold step label **Hold** in "Replace a stream agent": **deferred to #43** (quota by prompt), carried into wave 2's zones.
  - Stream skill step 0 still sends intake to the target repository, against ADR 0005: **deferred to #45** (intake).
  - README's file table lists ADRs 0001–0004 only: **deferred to #58** (release).
  - No ticket writes ADR 0008, which #59 says binds it: **waiting on a human** (proposed: add it to #61's scope).
- **Found while reviewing, orchestrator's miss in step 2:** native GitHub dependencies make #66 block #60, #61, #63 and #58, while #60's body said "None". #60 ran and merged with that edge open. The edge's reason (drift check red) does not hold on the reference plugin (operator decision on #66). **Waiting on a human**: proposed to drop the four #66 edges.

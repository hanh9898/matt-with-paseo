# Common rules for wave 1 (tickets #70, #71, #73, #72, #85; then #99, #77, #76, #75, #95, #80, #92, #87, #107, #103, #98, #105, #74)

## Graph
`{70, 71, 72, 73, 75, 76, 77, 80, 85, 87, 92, 95, 98, 105, 107} ; 70 → {99, 103} (operator order) ; all others → 74 (operator order) ; 78, 82, 91 held for #67`

No ticket declares a `Blocked by` (issue bodies and GitHub dependencies both empty). The two arrows are the operator's start order, not dependencies. The quota is 5; tickets start by rolling start in this order: #70, #71, #73, #72, #85, #99, #77, #76, #75, #95, #80, #92, #87, #107, #103, #98, #105, #74.

| Ticket | Status | Blocked by | Wave |
|---|---|---|---|
| #70 Pinned load-bearing lines | open, ready-for-agent | - | 1, started first |
| #71 Two-way tolerated-exception list | open, ready-for-agent | - | 1, started first |
| #73 Platform facts section | open, ready-for-agent | - | 1, started first |
| #72 Plugin decides mechanics, never acceptance | open, ready-for-agent | - | 1, started first |
| #85 Authority on separate axes (SLP) | open, ready-for-agent | - | 1, started first |
| #99 Cut for content, not for a word count | open, ready-for-agent | - (starts after #70 merges) | 1, rolling start |
| #103 One clause per sentence | open, ready-for-agent | - (starts after #70 merges) | 1, rolling start |
| #77, #76, #75, #95, #80, #92, #87, #107, #98, #105 | open, ready-for-agent | - | 1, rolling start, waiting on the quota |
| #74 Seat-facing version gate | open, ready-for-agent | - (starts after every other wave 1 ticket merges) | 1, last |
| #78, #82, #91 | open, ready-for-agent | the `## Delegation` table (#67, needs-triage) | none: held out of this stream by the operator |

## Context
- Your worktree branches off `stream/mwp-seatworks` at `785b1c1`, unless your prompt names another base commit (a ticket started by rolling start). That branch holds releases up to 0.4.2 and `docs/lessons/sting9k-seatworks.md`, where every ticket of this wave comes from (lesson numbers are in each ticket's Report section).
  Run `git branch --show-current` before every commit.
- Read before you start: your ticket (`gh issue view <n> --comments`) and its lesson in `docs/lessons/sting9k-seatworks.md`; `CODING_STANDARDS.md`; ADRs in `docs/adr/`; the words blocks at the top of both `SKILL.md` files; README "Behaviour evals"; `docs/plugin-learning-path.md` for the plugin work your ticket touches.
- Up to 4 other agents work this wave's tickets in parallel, several in the same skills and scripts. Work only on your ticket and inside your zone.
- Do not end your turn while work you started still runs (a long command, a sub-agent): wait for it inside the turn. Paseo sends no finish notification for a turn you start on your own afterwards, so your "finished" report must mean the work is done.
- Start any command that may take more than two minutes in the background from the start, and read its output when it finishes.

## Existing interfaces to reuse
- `python -B scripts/drift-check.py` (exit 0 clean, 1 drift, 2 usage) and `python -B -m unittest discover -s scripts`: run both before your last commit. A new check goes into `drift-check.py` (or a new script beside it when your ticket asks for a separate command) with its tests in `scripts/test_*.py`.
- Eval cases in `plugins/matt-with-paseo/evals/`, one folder per case (`case.yaml`, `prompt.md`, `fixture.sh`, `graders/*.md`). A stream-skill case carries an **observed-state block** (see `streams-no-index` and README "Observed state in the prompt"). Close shapes: `wave-42-one-ticket-no-ship` for the wave skill under `stream`, `wave-54-repro-and-no-code-flow` for ticket prompts and reports, `streams-39-question-round` for a brief to the user.
- Words: use every words-block term only in its defined meaning. Define no term outside a words block, and each term in one block only.

## File zones
"Wave skill" is `plugins/matt-with-paseo/skills/matt-with-paseo/SKILL.md`, "stream skill" is `plugins/matt-with-paseo/skills/matt-with-paseo-streams/SKILL.md`, "template" is `COMMON-RULES-TEMPLATE.md` beside the wave skill, "troubleshooting" is `TROUBLESHOOTING.md` beside it.

| Ticket | Owns |
|---|---|
| #70 pinned lines | A new data table file under `scripts/` (file, exact phrase, reason); a new check function in `drift-check.py` and its call in `main`; a new test class in `scripts/test_drift_check.py`. |
| #71 tolerated list | A new data list file under `scripts/`; a new check function in `drift-check.py` (or a change inside the existing skill-reference check only) and its call in `main`; a new test class in `scripts/test_drift_check.py`; the #66 link. |
| #73 platform facts | One new tracked file of verified Paseo facts (beside the wave skill, since agents read that folder); one pointer line per place the skills touch Paseo (whole new lines, not edits of others' sentences); README: a new short `### Known Paseo behaviour` subsection right after `### Target repo evidence standards file (optional)`. Leave `.scratch/` notes as they are. |
| #72 plugin boundary | `docs/adr/0009-*.md` (new). Only #72 writes an ADR numbered 0009; another ticket that needs an ADR names it in its report instead. |
| #85 ownership table | The one ownership table (its place is yours: a new section of the stream skill or a new file beside it, with one pointer line in the wave skill). |
| #99 trim rule | `CODING_STANDARDS.md`: one new rule; nothing else. |
| #77 troubleshooting ratings | Troubleshooting: one rating per entry (whole-line edits of entries); a test in `scripts/` binding each `caught` rating to its check. |
| #76 evidence tags | Template "Done when" report bullet (the tags); wave skill step 5: one new bullet on `assumed` lines; one eval case. |
| #75 three-part brief | Template: a new section for the three parts (after "Acceptance criteria are the contract"), the answered-challenge sentence; one eval case. |
| #95 user's language | One sentence in one place in the skills (the words block or the orchestrator's first step, your call); one eval case or an extended one. |
| #80 retro | Wave skill step 8 and the stream skill's end of stream: one pointer each to `/mattpocock-skills:retro`, the two rules written once beside one of them. |
| #92 mechanism counts | Wave skill step 7 (`## Review` records whether each review changed the work) and step 8's summary (the counts); the matching lines of the stream skill's report, if it has one. |
| #87 trigger coverage | A new trigger-case data folder (for example `plugins/matt-with-paseo/evals/triggers/`); a structural check in `scripts/` with its tests; a separate model-run command (a script, not run in the ticket); README "Behaviour evals": one new paragraph. |
| #107 cleanup liveness | Wave skill step 8 and the stream skill's cleanup rows: the reading of liveness only. |
| #103 one clause per sentence | Stream skill: rewrites of its densest passages. Leave any passage a running ticket owns above; list them in your report. |
| #98 overhead measurements | The acceptance-run template (find where #13 and #23 take their shape; name it in your report): the measurement lines only. |
| #105 eval slice | README "Behaviour evals": the slice, its cost line (written as "measured in the stream's final eval run") and the gate rule; `CODING_STANDARDS.md` or `AGENTS.md`: one line naming the gate. |
| #74 version gate | A new data list of seat-facing paths under `scripts/`; a new check and its tests; `plugins/matt-with-paseo/.claude-plugin/plugin.json`: **the one version bump of this stream** (0.4.2 → 0.5.0) and the marketplace description if it names the version. |

- No ticket other than #74 changes a version number.
- New eval case: a new folder named `<streams|wave>-<ticket number>-<what it checks>`. Extending an existing case means adding a prompt line or a grader, as whole lines, inside that case.
- Shared files (`drift-check.py`'s `main`, `test_drift_check.py`, README, the skills' tables): add only your own lines, functions, rows or classes, as whole lines, keeping the order of the existing lines. The orchestrator resolves the merges.
- Outside your zone: name the file, the section and the change you would make in your report instead of editing it.

## Eval and review rules (the user's, for this stream)
- **No ticket agent runs `claude plugin eval`**, neither the full suite nor a single case. The full suite runs once, after the stream's last wave, run by the orchestrator.
- **At most one new eval case per ticket**, and only when its acceptance criteria name an eval. Every other eval criterion extends an existing case that covers it. The one new case is designed to fail on your base commit's skill, checked by reading the case against the base skill text (`git show <base>:<path>`), not by running it. Your `Resolved:` comment names the new case, the extended cases, and says the case is written, not run. "The rewritten passages pass the evals" (#103) is checked in that final run: you add no case for it.
- **No review of any kind on your ticket**: no `/mattpocock-skills:code-review`, no review sub-agent. The whole stream is reviewed once, after the last wave.
- Unit tests and the drift check still run before your last commit.

## Traps already hit
- Committing on the integration branch moves its HEAD. Commit only on your own branch; never check out or commit to `stream/mwp-seatworks`. Check: `git branch --show-current` before each commit.
- Never edit anything under `.git/` (it is shared by every worktree). Do not use bare `git stash`; commit a WIP commit on your branch instead.
- `git checkout -- <file>` throws away every uncommitted edit in that file. Revert one edit with the file-editing tool. Check: `git diff <file>` before you commit.
- Commit in small steps; leave no work outside git. Check: `git status --porcelain` is empty before your report. Delete any `evals/results/` folder and any stray empty folder a broken heredoc left.
- If a git command hangs, stop and report; do not delete lock files.
- Windows: `python3` is the Microsoft Store alias and fails (exit 49); run `python -B`. A lone single quote inside a Bash heredoc breaks parsing; write file content with the file-writing tool. Python needs `PYTHONIOENCODING=utf-8` for Vietnamese output. Git Bash's `/tmp` is not the path Windows Python sees; use `cygpath -w` or your temp directory.
- The reference Matt plugin is the user-scope install from the upstream `mattpocock` marketplace; keep references to `pr`, `implement-spec` and `retro` (operator decision, #66). Check: `python -B scripts/drift-check.py` exits 0 with no `--plugin-root`.
- A grader that cannot fail on the base skill proves nothing (earlier waves: several cases scored 1.00 on the old skill and were dropped). Name, for your new case, the base-skill line that makes each grader fail.
- Agents stopped on a session limit mid-work in earlier waves. Your commits are your progress: commit before long steps, so a resume can pick up from `git log`.
- `gh` has failed with `x509: certificate signed by unknown authority` (network SSL inspection). That is not yours to fix: write the text you would post into your temp directory, say so in your report, and carry on with local work.
- Put temporary files only in your temp directory, never loose in `%TEMP%`. Before reporting, list your temp directory and quote the result.

## Failing on base
- On `785b1c1`, before the first spawn: `python -B scripts/drift-check.py` exits 0; `python -B -m unittest discover -s scripts` runs 13 tests, OK. None: every command passes.
- A failure listed here is not yours: leave it as it is unless your ticket's acceptance criteria name it, and name it in your report as failing on base. A failure not listed here is yours to explain.

## Acceptance criteria are the contract
- A trap above, or an instruction an earlier ticket left in its comments, is guidance; your ticket's acceptance criteria are the contract.
- On conflict, follow the criteria and write the discrepancy and its reason in a comment on your issue; do not stop to ask.
- If the criteria themselves look wrong, stop that part, write the evidence in a comment on your issue, and add the `ready-for-human` label. Never rewrite the criteria.
- Operator decisions for this stream, which narrow some criteria:
  - #105: record the slice and the gate only. No eval runs inside the ticket; the slice's cost is measured in the stream's one final eval run.
  - #98: the template only. Criterion 2 ("#13 and #23 record them") is left for the human who runs #13 and #23; add `ready-for-human` for that part.
  - #74: the one version bump of the stream, done once.
- A criterion that asks for a change on another GitHub issue (#66 for #71) is part of your ticket: make it with `gh issue comment` or `gh issue edit`, and quote the link in your report.

## Resources
- Your private resources are listed in your prompt (a temp directory only). Use exactly that set.
- Shared, read-only: the source repository `sting9k/seatworks` at `6d316b0` (read through the links in your ticket; do not clone it into the repo); the installed Matt plugins under `~/.claude/plugins/cache/`; the plugin repository `hanh9898/matt-with-paseo-plugin` (read only).
- Machine-wide: the Paseo daemon, this machine and one usage limit are shared by every agent. Create no Paseo workspace, agent, heartbeat or schedule.

## Repo and user rules
- Skills, ADRs, README and all GitHub text in **English**. Commit messages follow the repo's style (`feat(wave): …`, `feat(streams): …`, `feat(scripts): …`, `test(evals): …`, `docs(adr): …`, `docs(readme): …`, `docs(standards): …`, `chore(release): …`) and name your ticket (`(#NN)`). End every commit message with `Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>`.
- `CODING_STANDARDS.md` is the standard for every document an agent reads: numbered steps, a **Done when** per step that matches its body, choices as table rows, one concept one word, one source of truth.
- Accepted way to verify: turn each acceptance criterion into a check you can run (the drift check, the unit tests, a `grep` that must or must not match on the base and on your head, reading a section, a fixture script run in your temp directory) and record the command and its output. For an eval criterion, reading the case against the base skill is the check.
- Do not push, do not tag, do not open a PR, do not close your issue.
- Credentials: never read, print or pass on a token or credential (no `gh auth token`, no reading a CLI's hosts or config file or a token's environment variable, no token in a URL or a command). A `gh`, push or upload failure goes into your report with the command and its error as printed; never work around it with another tool, the forge's API or another account.
- Evidence standards: none declared.

## Done when:
- Commit to your branch. The orchestrator merges.
- Mark the ticket done with a comment starting `Resolved:` (leave the issue open; the orchestrator closes it after the merge), or add `ready-for-human` for the part a human must do. In it, write what you verified, with evidence, what remains open, and the eval-case line above.
- Clean up your temp directory; state the reason for anything you keep.
- Report back: a design summary, files touched, how you verified with evidence, work not done or still in doubt (every out-of-zone change you would make), every change outside git, and decisions the user must make.

## Wave agents

| Ticket | Agent id | Workspace id | Branch | Base commit | Private resources | Cleaned |
|---|---|---|---|---|---|---|
| #70 | 7516b0a8-a514-4c6d-8c0a-eb69977d0737 | wks_08717a76f32c4bd5 | `mwp-seatworks/wave1/70-pinned-lines` | `785b1c1` | temp `%TEMP%\mwp-seatworks-wave1-70` | [x] |
| #71 | af833c42-7776-4994-8847-bf6d5f80a73d | wks_dc7c90f6d30bc30e | `mwp-seatworks/wave1/71-tolerated-list` | `785b1c1` | temp `%TEMP%\mwp-seatworks-wave1-71` | [x] |
| #73 | 81cb8b64-70f1-4f80-84e1-411fa652927e | wks_49355ff9321745c7 | `mwp-seatworks/wave1/73-platform-facts` | `785b1c1` | temp `%TEMP%\mwp-seatworks-wave1-73` | [x] |
| #72 | b736baa2-5cf9-4dfd-b2a8-cd7fb74ff8cd | wks_fc4f97a6a372359a | `mwp-seatworks/wave1/72-plugin-boundary` | `785b1c1` | temp `%TEMP%\mwp-seatworks-wave1-72` | [x] |
| #85 | 1aa960ae-614a-499e-b30e-3457db29c4e1 | wks_d27bbf54af0d3c8c | `mwp-seatworks/wave1/85-ownership-table` | `785b1c1` | temp `%TEMP%\mwp-seatworks-wave1-85` | [x] |
| #77 | 9dbaf527-c132-4a0f-8eb5-d37c13ce8e0c | wks_e0e3f9d7a5769b16 | `mwp-seatworks/wave1/77-troubleshooting-ratings` | `7818806` (rolling start) | temp `%TEMP%\mwp-seatworks-wave1-77` | [x] |
| #76 | fb6fb274-97d6-4140-9419-a546d13ca9ac | wks_e31f20b6bb4c6ab6 | `mwp-seatworks/wave1/76-evidence-tags` | `59eaab7` (rolling start) | temp `%TEMP%\mwp-seatworks-wave1-76` | [x] |
| #75 | 9a5375ca-8296-4a4c-a37f-30ed2dec195e | wks_9e0e11bf28b1f222 | `mwp-seatworks/wave1/75-three-part-brief` | `59eaab7` (rolling start) | temp `%TEMP%\mwp-seatworks-wave1-75` | [x] |

#72 merged as 7818806, #71 as c24ebe6, #85 as 59eaab7 (no conflicts; drift check exit 0, 16 tests OK after #71). #71: the #66 comment was refused by the agent's permission classifier; #66 is closed, which meets criterion 4.

## Amendment 1 (operator, 2026-09-29): tickets started after this line

The rules above are frozen for the agents already running (#70, #71, #72, #73, #85, #77, #76, #75). Every ticket agent spawned after this line follows the rules above **with these changes**, and its prompt names this section:

- Ticket agents launch with `claude/claude-sonnet-5-5`, thinking `high`, mode `auto`. Commit trailer: `Co-Authored-By: Claude Sonnet 5.5 <noreply@anthropic.com>`.
- **No ticket runs the test suite, the drift check, an eval or a code review.** This replaces "Unit tests and the drift check still run before your last commit" and "run both before your last commit" above. You may write and change tests and drift-check code; you do not run `python -B -m unittest …` or `python -B scripts/drift-check.py`. Verify each acceptance criterion with checks that are not the suite: a `grep` red on the base and green on your head, reading a section, reading an eval case against the base skill, reading your new test against the code it tests. Your `Resolved:` comment says the tests were written, not run.
- **Merges run no suite either**: the orchestrator runs only the conflict-marker search per merge. After the last wave: one full test run (unit tests and drift check), one code review of the whole stream diff, one fix pass, then the one eval run.
- Already on the integration branch for you to reuse: `scripts/pinned-lines.json` (#70, once merged: a phrase listed there must stay on one physical line of its file; if you reword a pinned sentence, update its row in the same commit), `scripts/tolerated-references.txt` (#71), `plugins/matt-with-paseo/skills/matt-with-paseo/PASEO-FACTS.md` (#73, once merged), `plugins/matt-with-paseo/skills/matt-with-paseo-streams/OWNERSHIP.md` (#85), `docs/adr/0009-*.md` (#72).

#70 merged as 5cc13d5 (conflict with #71 in `drift-check.py`'s `main` and at the end of `test_drift_check.py`: both sides kept, tolerated check before pinned check; `py_compile` only, per Amendment 1). #73 merged as 5a76cd5 (conflict in the stream skill's "Inputs": #85's Ownership pointer and #73's PASEO-FACTS pointer both kept). #70's decisive claim re-run: removing a pinned phrase in a copy makes `drift-check.py --pinned-root <copy>` exit 1 with one line naming the file and reason. #73 was closed a moment before its merge commit landed (its merge was mid-conflict); the merge is in now.

| Ticket | Agent id | Workspace id | Branch | Base commit | Private resources | Cleaned |
|---|---|---|---|---|---|---|
| #99 | d786cc25-3f39-4eac-8cec-77493f8252d3 | wks_975b001e99d738a6 | `mwp-seatworks/wave1/99-trim-rule` | `5a76cd5` (rolling start, Amendment 1) | temp `%TEMP%\mwp-seatworks-wave1-99` | [x] |
| #95 | 0838435e-c6fb-4c13-9472-21daaa579c1e | wks_7ab39e35c970de6c | `mwp-seatworks/wave1/95-user-language` | `5a76cd5` (rolling start, Amendment 1) | temp `%TEMP%\mwp-seatworks-wave1-95` | [x] |

#99 merged as 0e2758c. Operator decisions (2026-09-29): #71's link comment on #66 is not posted (#66 is closed, the criterion holds); #73's pointer sweep (TROUBLESHOOTING lines 27 and 29, wave skill lines 184, 229 and 282, README line 361, numbered on 785b1c1) goes into the one fix pass after the stream-wide review.

| Ticket | Agent id | Workspace id | Branch | Base commit | Private resources | Cleaned |
|---|---|---|---|---|---|---|
| #80 | 1a531abd-e1f6-4254-98b0-8351e596dd87 | wks_36138faba07461e2 | `mwp-seatworks/wave1/80-retro` | `0e2758c` (rolling start, Amendment 1) | temp `%TEMP%\mwp-seatworks-wave1-80` | [x] |

#95 merged as 2413d49 (one words-block line **User's language** in the wave skill; new case `wave-95-user-language-one-door`, written, not run). Open for the stream-wide decision round: the case asserts ticket prompts stay English even when the user asks for Vietnamese prompts (the ticket says prompts stay English); and "Relays are verbatim" keeps a stream agent's English question English for the user.

| Ticket | Agent id | Workspace id | Branch | Base commit | Private resources | Cleaned |
|---|---|---|---|---|---|---|
| #92 | 4f596313-e331-4a09-8f9e-6100bc2d6728 | wks_3a72bc0ffbaa03ff | `mwp-seatworks/wave1/92-mechanism-counts` | `2413d49` (rolling start, Amendment 1) | temp `%TEMP%\mwp-seatworks-wave1-92` | [x] |

Operator decisions on #95 (2026-09-29, recorded on #95): prompts stay English even when the user asks otherwise; relays stay verbatim; translating relays is a separate ticket outside this stream. Both items leave the post-review round.

#80 merged as 5930539. #75 merged as 4e57eaf. #92 merged as 923bf2d (conflict with #80 at the end of wave skill step 8: #80's retro paragraph and table kept, #92's counts sentence kept, the two **Done when** clauses joined into one). #76 merged as 387165b. #77 merged as 2c0cce8 (its `caught` ratings name phrases in the skills as of its base 7818806; the final test run checks them against the merged skills).
Noted for the stream-wide review, out of the reporting tickets' zones: #75: the wave skill has no step that answers a challenge to a chosen default; #76: README "A full run is 26 cases" is stale; #77: the wave skill's heartbeat contract does not check `list_pending_permissions`, and no words block defines caught/asked/nothing yet; #92: checkpoints other than step 7's decision round (step 2's approval) are not marked.

| Ticket | Agent id | Workspace id | Branch | Base commit | Private resources | Cleaned |
|---|---|---|---|---|---|---|
| #87 | 243e9bc1-cb55-45e5-ada9-28a09191bbe3 | wks_4603f7452f772a27 | `mwp-seatworks/wave1/87-trigger-coverage` | `5930539` (rolling start, Amendment 1) | temp `%TEMP%\mwp-seatworks-wave1-87` | [x] |
| #107 | 97c7cc16-4a2a-474b-944e-5a411b4a029f | wks_6502ef7a5e27d5fa | `mwp-seatworks/wave1/107-cleanup-liveness` | `387165b` (rolling start, Amendment 1) | temp `%TEMP%\mwp-seatworks-wave1-107` | [x] |
| #103 | 7eecbe23-7603-4944-bc76-659bc941b94b | wks_e63eba519d4bcdeb | `mwp-seatworks/wave1/103-one-clause` | `387165b` (rolling start, Amendment 1) | temp `%TEMP%\mwp-seatworks-wave1-103` | [x] |
| #98 | e6a1bd97-3d79-431b-a865-46b85bb6018b | wks_0fc96055b0be5ebf | `mwp-seatworks/wave1/98-overhead` | `387165b` (rolling start, Amendment 1) | temp `%TEMP%\mwp-seatworks-wave1-98` | [x] |
| #105 | 986cbcb4-c3db-4448-9a36-5e7c56c2a59b | wks_3c066b1afcdc713f | `mwp-seatworks/wave1/105-eval-slice` | `2c0cce8` (rolling start, Amendment 1) | temp `%TEMP%\mwp-seatworks-wave1-105` | [x] |

#107 merged as 8fc3cd6 (its agent once detached HEAD with a bare `git checkout 387165b --` and restored the ticket branch with `git switch -C`; branch and worktree checked clean). Noted for the review: the stream skill's tick and pause rows still find agents by `paseo ls` labels (lookup, not cleanup).

#87 merged as d088e66 (data in `plugins/matt-with-paseo/triggers/cases.json`, not under `evals/`, so `claude plugin eval` does not take it for a case; 32 tests written, not run). #105's agent was told that #87's check enters the gate through `unittest discover`. For #74 and the review: whether `triggers/` is seat-facing; the JSON key `brief` clashes with the words-block **Brief**.
#98 stopped without a commit: no acceptance-run template exists in the repo (#13 and #23 take Matt's `to-tickets` shape). It commented "Not resolved:" on #98 and added `ready-for-human`. **Waiting on the user's decision:** create a template file, and where.

**User's decision on #98 (2026-09-29):** create `docs/acceptance-run-template.md` (human-facing, outside #74's seat-facing list) with the measurement lines only. Sent to #98's agent e6a1bd97 with `send_agent_prompt`, which records it on #98.
#105 merged as 45052d2 (README conflict with #87 at the end of "Behaviour evals": **Eval gate** kept first, then **Trigger cases**). #103 merged as 5a3a446 (no conflict with #107; stream skill 17842 → 17769 words; 7 pinned stream-skill rows found by its agent on its head). Noted for the review: #105's gate paragraph does not name #87's structural check in `unittest discover`; #103 dropped `background: true`/`notifyOnFinish: true` from the Pause and replacement prompts, relying on step 5's "every prompt you send a stream agent" line.

#98 merged as 1db5368 (`docs/acceptance-run-template.md`, criterion 1). #98 stays open with `ready-for-human` only (`ready-for-agent` removed) for criterion 2, which the human running #13 and #23 does.
Every other wave 1 ticket is merged, so #74 starts last, on 1db5368.

| Ticket | Agent id | Workspace id | Branch | Base commit | Private resources | Cleaned |
|---|---|---|---|---|---|---|
| #74 | be3fa390-1773-4b84-beac-d9a9aa93a47b | wks_f231da9cc2fb197b | `mwp-seatworks/wave1/74-version-gate` | `1db5368` (last, Amendment 1) | temp `%TEMP%\mwp-seatworks-wave1-74` | [x] |

#74 merged as cfc5814 (the stream's one version bump, 0.4.2 → 0.5.0; `scripts/check-version-gate.py` compares the six seat-facing paths with `main`, and enters the gate through `unittest discover`; `triggers/` is off the list). Noted for the review: the gate's self-test will stay red for later streams until their release bumps; README line 305 `--pin v0.4.2` and a run line for the gate are out of its zone.

## Review

Not run per wave (the user's rule for this stream): the whole stream diff is reviewed once, after the last wave, on both axes, followed by one fix pass and the one eval run. The findings noted above in this log go into that review.

Wave 1 cleaned: 18 tickets merged, every row stopped, clean and merged, and archived with its workspace; temp directories removed (#75 and #77 kept only a copy of their posted `Resolved:` comment); no heartbeat was created; `paseo ls -g --label stream=mwp-seatworks --label wave=1` lists nothing. #78, #82, #91 stay out of this stream (held for #67); #98 stays open with `ready-for-human` for criterion 2.

## Stream review

User's rule: one review of the whole stream after the last wave. Fixed point `785b1c1`, head `fb38f6a` (40 files, +2320/−40). Before it, the one full test run on `fb38f6a`: `python -B -m unittest discover -s scripts` ran 78 tests, OK; `python -B scripts/drift-check.py` exit 0. The review ran in the orchestrator's session with two read-only sub-agents. **Standards: 15 findings (7 hard, 8 judgement calls); Spec: 12 findings.** Every known item from the log above holds. Orchestrator checks: P1 confirmed by reading the case folders; `claude plugin eval --help` lists `--case <glob>`, so P9's doubt about the flag is dropped.

| # | Where | Finding | Axis |
|---|---|---|---|
| S1 | Wave skill steps 7, 8 | "mechanism" and "decision round" used undefined; L2 wants **Checkpoint** | Std (W4, L2) |
| S2 | TROUBLESHOOTING.md intro | Rating words caught / asked / nothing yet defined nowhere; the intro line is stale | Std (W4, W8), Spec P7 |
| S3 | CODING_STANDARDS H3, README, `check-version-gate.py` | "gate" has three meanings; "seat-facing" is defined only in a script | Std (W4) |
| S4 | TROUBLESHOOTING.md, README "Known Paseo behaviour" | Facts restated from PASEO-FACTS.md (#73's pointer sweep) | Std (W6), Spec P8 |
| S5 | Wave skill step 8 | The live-row rule is stated twice | Std (W7, W6) |
| S6 | `check-version-gate.py`, `drift-check.py` | A missing input file gives a traceback (exit 1) instead of exit 2; the skip path exits 0 without saying so in the header | Std (S2) |
| S7 | README "Behaviour evals" | "A full run is 26 cases"; there are 32 | Std, Spec P12 |
| S8, S9, S12, S13 | `scripts/` | Duplicated `frontmatter`/`fail`/list parsing across five scripts; two phrase-in-file checkers; cases passed as bare dicts; `majority()` is a middle man | Judgement |
| S10 | `seat-facing-paths.txt` | The list repeats `skills/**` | Judgement |
| S11 | `triggers/cases.json`, trigger scripts | Key `brief` clashes with the words-block **Brief**; README calls it "request" | Judgement (W4) |
| S14 | Wave skill step 8 | The retro rules table is a rare-case block in a step every run reads | Judgement (W2) |
| S15 | OWNERSHIP.md | "the question round" in a new file; should be checkpoint | Std (§2) |
| P1 | `evals/wave-95-user-language-one-door` | Front matter and observed-state block sit in `case.yaml`; `prompt.md` is one line (every other case keeps them in `prompt.md`) | Spec (#95), high |
| P2 | Stream skill close row; wave step 8 | Cleanup still looks up live state: the stream workspace "that step 2's table finds", and step 8's closing `paseo ls` scan archives what it lists | Spec (#107) |
| P3 | Wave skill | No step says who answers a challenge to a chosen default, or where | Spec (#75) |
| P4 | Wave skill step 7 | Checkpoints are marked `took the recommendation`, not whether they changed the work; steps 1 and 2 are unmarked | Spec (#92) |
| P5 | `evals/wave-75-chosen-default-challenge` | Grades the orchestrator's step 3, not a ticket agent's challenge | Spec (#75) |
| P6 | `test_version_gate.py`, `check-version-gate.py` | Compares with `main`: red in every later stream until its release bumps; the test repeats the six paths | Spec (#74) |
| P7 | TROUBLESHOOTING.md | "Agent stops midway" is `caught` by a pointer back to itself; "Report is correct but incomplete" is rated `asked` although step 5 is a check; "question-type permission" is `caught` only by the stream skill's tick | Spec (#77) |
| P8 | PASEO-FACTS.md | 14 of 24 rows read "version not recorded" | Spec (#73) |
| P9 | Wave skill, stream skill ship path | The eval-gate rule lives only in README and H3; nothing where merges or ships happen names it | Spec (#105) |
| P10 | Stream skill | Shorter only against #103's base (17842 → 17769 words), not against 785b1c1 | Spec (#103), note |
| P11 | `evals/wave-76-hidden-assumption-report` | One grader; a base model re-running the decisive claim might pass it | Spec (#76), low |
| P12 | Template | "A challenge alone does not move the ticket to ready-for-human" was not asked for | Spec (#75), minor |
| K | README line 305 | `--pin v0.4.2` after the bump to 0.5.0; no README line on running the version gate or the ratings script | Std, known |

**User's decisions (2026-09-29), recorded on #74, #92, #75:**
- P6: compare with the latest release tag (`v*`), not `main`; the template's "Failing on base" notes the self-test until a stream bumps once. Fix pass.
- S8, S9, S10, S12, S13 (scripts smells): not fixed and no issue opened; they go to this log and to the ship pull request's follow-ups, and the user brings them in through triage.
- P4: every checkpoint (steps 1, 2, 7) is marked `changed the work: yes|no`; `took the recommendation` stays. Fix pass.
- P5: the limit is written on #75 and goes to the ship pull request's follow-ups; no issue opened.
- From now on: no question by AskUserQuestion; questions end the turn in the message, with options and a recommendation.

**Orchestrator's outcome for the rest** (fix pass unless said otherwise): S1, S2, S3, S4 (with #73's sweep), S5, S6, S7, S11, S15, P1, P2, P3, P7, P9, K: fixed in the fix pass. S14: skipped, #80's criterion puts the two rules "written once, where that pointer is". P8: skipped, the Paseo version of those facts was never recorded and is not invented. P10: skipped, #103's criterion is met against its base. P11: skipped, low; the one-case rule holds. P12: kept, it keeps a challenge from bypassing the criteria contract.

### Follow-ups for the ship pull request
- `scripts/` smells (S8, S9, S10, S12, S13): one `scripts/common.py` (`frontmatter`, list parsing, one exit-2 error), one shared phrase-in-file check for `pinned-lines.json` and the troubleshooting ratings, cases as a small type, inline `majority()`, a glob instead of `seat-facing-paths.txt`.
- #75: an eval case where a ticket agent challenges a chosen default with evidence (the current case grades only the orchestrator's step 3).

### Fix pass

| Ticket | Agent id | Workspace id | Branch | Base commit | Private resources | Cleaned |
|---|---|---|---|---|---|---|
| stream review fixes | 04f6230e-ebc2-4bed-acb6-1d8bd04321bb | wks_b88746edc51041c6 | `mwp-seatworks/wave1/stream-review-fixes` | `fb38f6a` | temp `%TEMP%\mwp-seatworks-review-fixes` | [x] |

**User's decision (2026-09-29):** no test re-run after the fix pass (the rule is one test run, and it ran on fb38f6a). Merge the fix pass, run the one eval, and list every test the fix pass may have broken in the ship pull request's **Merge Danger** as not re-run after the fix.

Fix pass merged (2026-09-29, by stream agent `3d33bfa1`, replacing `79dd4c98`): `8f7ede8`, conflict-marker search empty. The fix agent reported 22 findings fixed in 15 commits; it ran no suite (it ran `py_compile` and the three single checks `check-version-gate.py`, `troubleshooting-ratings.py`, `check-triggers.py`, each exit 0). New tests it wrote were not run: 5 in `test_version_gate.py`, 6 in `test_drift_check.py`, plus the rewritten tag-based gate tests. They go to the ship pull request's **Merge Danger**. Agent and workspace archived; temp directory gone. The fix agent's own notes for the ship pull request:
- P4: a new log section `## Checkpoints` (template, steps 3 and 8); the prompt said steps 0, 2, 7, the log said 1, 2, 7; it followed the prompt.
- P6: `test_the_list_names_every_file…` still repeats the six paths (not in the user's decision).
- Eval risk it named: `evals/streams-41-hung-agents` gives `paseo ls` a workspace but no `get_agent_status` `workspaceId`; the new close rule (P2) may make that case report instead of archive.

### Eval run

The stream's one eval run, on `8f7ede8` (2026-09-29), with the user's command from `plugins/matt-with-paseo`: 32 cases, 1 run each, 749 s, $5.97, exit 1. **22 pass, 10 fail.** The eval gate's slice passes (`wave-not-configured`, `streams-no-paseo-tools`, `streams-free-text-argument`, each 1.00). Report at `plugins/matt-with-paseo/evals/results/2026-09-29T16-03-02-474Z/` (gitignored). No earlier full run is recorded, so this run alone cannot separate regressions from failures already there.

| Case | Score | Failed graders |
|---|---|---|
| wave-75-chosen-default-challenge (new, #75) | 0.00 | answer-names-reason, challenge-not-ready-for-human, chosen-default-open-to-challenge |
| wave-95-user-language-one-door (new, #95; P1 changed it) | 0.00 | two-languages |
| streams-61-ship-rules | 0.40 | reads-target-not-stream-branch, relays-merge-message-pattern, shows-merge-options |
| streams-41-hung-agents (the fix agent named it at risk from P2) | 0.50 | closes-clean-merged-stream, names-kill-agent, reports-subagent-not-kills |
| streams-48-timeout-adopts-in-project | 0.50 | agent-carries-workspace-id |
| streams-52-answer-and-machine | 0.50 | status-line-drops-answer |
| wave-tickets-with-width | 0.67 | asks-model-and-mode |
| streams-49-ship-branch | 0.78 | honours-kept-path, pushes-only-ship-branch |
| streams-40-silent-supervision | 0.80 | writes-last-tick |

**User's decisions on the eval run (2026-09-30):**
- One bounded fix pass (as D16): Sonnet 5.5 high, no review, only for the two new cases `wave-75` and `wave-95`; for each, decide skill wrong or grader wrong and fix that side. Then re-run only those two cases with the D9 command plus `--case`.
- `wave-95`: the grader stands; the skill must make agent prompts English (#95, D27).
- No baseline run, no fix for the other eight: they go into the ship PR's **Merge Danger** as partial scores with no baseline to compare, with the eval fix pass's unrun tests.

### Eval fix pass

| Ticket | Agent id | Workspace id | Branch | Base commit | Private resources | Cleaned |
|---|---|---|---|---|---|---|
| eval fixes | 9837d708-5977-48e1-a0b3-35262feeb9df | wks_9b9c13a775c032e6 | `mwp-seatworks/wave1/eval-fixes` | `d18de93` | temp `%TEMP%\mwp-seatworks-eval-fixes` | [x] |

The eval fix agent judged **skill wrong** in both cases and changed only the wave skill's `SKILL.md` (2 commits, `c5d7390`, `e15341d`; 5 lines in, 3 out; `check-version-gate.py` and `troubleshooting-ratings.py` exit 0; no temp directory). Merged: `c843bf7`, conflict-marker search empty. Agent and workspace archived; `paseo ls -g --label stream=mwp-seatworks --label wave=1` lists nothing.

Re-run (D9 command plus `--case`, one command per case, on `c843bf7`): `wave-75` **0.33** (was 0.00: `chosen-default-open-to-challenge` now passes; `answer-names-reason`, `challenge-not-ready-for-human` fail, FAIL FAIL FAIL), $0.19; `wave-95` **0.00** (`two-languages`, FAIL FAIL FAIL), $0.14. Reports under `evals/results/2026-09-29T17-11-15-259Z/` and `2026-09-29T17-12-57-909Z/`.

Orchestrator's reading of the two final replies, against the grader text:
- `wave-95`: every `create_agent` prompt is English, and the message to the user once both agents run is Vietnamese, which is what the grader asks for. The judge still voted FAIL three times.
- `wave-75`: the "Chosen for you" row picks ISO 8601 with a reason, a challenge route by evidence in ticket comments and the report, and "whoever answers writes why the plan changes or stands". `answer-names-reason` still fails. `challenge-not-ready-for-human` has a reason to fail: the reply never says the agent keeps working, and it states the ready-for-human rule of the criteria row next to it.
- The LLM grader defaults to `haiku` (`claude plugin eval --help`: `--judge-model`), and a vote gives no reason. So from this run alone a judge error cannot be told apart from a skill gap.

**User's instruction (2026-09-30):** every new agent of this stream (ticket or fix) launches with the Paseo profile `ticket-agent` (`claude/claude-sonnet-5-5`, thinking `medium`, mode `bypassPermissions`), as step 1 says. It came after the eval fix agent had already finished and been archived, so no running agent is affected.

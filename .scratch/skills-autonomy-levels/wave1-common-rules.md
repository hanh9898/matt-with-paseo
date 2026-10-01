# Common rules for wave 1 (tickets #130, #131; then #132, #133)

## Graph
`[130+131] → {132, 133}`

Edges are the `Blocked by` line of each issue: #131 on #130, #132 and #133 on #131. No other edge is declared. Quota 2: bundle `[130+131]` (a chain) starts now; #132 and #133 join wave 1 by rolling start once #131 is merged, as two bundles of one (two slots are free then).

| Ticket | Status | Blocked by | Wave |
|---|---|---|---|
| #130 ADR 0013: three autonomy levels in the delegation table, amending ADR 0011 | open, ready-for-agent | - | 1, bundle `[130+131]`, started first |
| #131 Delegation reads a Level row (1, 2 or 3), with a per-stream Level column, and answers per level | open, ready-for-agent | #130 | 1, bundle `[130+131]` |
| #132 At level 3 the orchestrator answers the ship question and merges the pull request on green CI | open, ready-for-agent | #131 | 1, rolling start after #131's merge |
| #133 decisions.md: D<n> entries, a Decided without evidence reading list, and plugin D<n> references to the plugin's decision log | open, ready-for-agent | #131 | 1, rolling start after #131's merge; carries the stream's one version bump |

## Context
- Your worktree branches off `stream/skills-autonomy-levels` at `8a361df` (`main` after PR #129, evidence standards and CI; plugin version `0.7.0`, tag `v0.7.0`), unless your prompt names another base commit (#132 and #133 start from #131's merge). Tickets of this stream merged before yours are on that base; your prompt names them.
  Run `git branch --show-current` before every commit.
- Read before you start: your ticket and its comments (`gh issue view <n> --comments`); `docs/agents/evidence-standards.md`; `CODING_STANDARDS.md`; ADRs `docs/adr/0005-*`, `0011-*` and, once #130 is merged, `0013-*`; the words blocks at the top of both `SKILL.md` files; `scripts/pinned-lines.json`; README "Behaviour evals" if your ticket touches an eval case.
- The plugin side lives in `hanh9898/matt-with-paseo-plugin`: its issues #57 (ADR 0004, three levels), #58 (reads the `Level` row; its resolution table and doors per level) and #54 (the decision log, merged by #59). Read them with `gh issue view <n> -R hanh9898/matt-with-paseo-plugin --comments`. Contract v1 on `release/v0.1.0`: `git -C D:/matt-with-paseo-streams/matt-with-paseo-plugin show origin/release/v0.1.0:docs/contract.md` (read only: never check out, fetch, commit or edit in that checkout). That contract still reads `Switch` only: #58 is open, so the `Level` row exists only in #58's issue text and in your ticket.
- 1 other agent (bundle) works this wave's other tickets in parallel once #132 and #133 run side by side; before that, `[130+131]` runs alone.
  Work only on your own bundle, one ticket at a time, in the order of your prompt.
- Do not end your turn while work you started is still running in the background (a long command, a sub-agent): wait for it inside the same turn. Paseo sends no finish notification for a turn you start on your own afterwards, so your "finished" report must mean the work is done.
- Start any command that may take more than two minutes in the background from the start, and read its output when it finishes. A foreground command the shell moves to the background halfway can leave your turn waiting on a result that never returns.
- No `matt-with-paseo` plugin runs on this machine (`paseo plugin ls` lists only `ailoop-env`): nothing you write can be tried against the real plugin. Write from your ticket, plugin #58's text and contract v1's text.

## Parameters
- Ticket cap: 4, the most tickets step 2 plans into a bundle. While Jev is not available it is also the fallback stop: once a ticket agent has worked this many tickets, the orchestrator answers `stop` (step 5).
- Context stop: 600K `contextWindowUsedTokens`, the size of a ticket agent's context at which the orchestrator answers `stop`, while Jev is not available (step 5).
- With Jev, its flag is what stops a bundle (step 5); the ticket cap still bounds the bundle's size.

## Existing interfaces to reuse
- The `## Delegation` table and its reading in the stream skill ("Delegation: what you may answer for the user", "The index", "The status line"), from ADR 0011 (#110). Each ticket rewrites only the parts its ticket names.
- The contract link: the skills cite contract v1 by `https://github.com/hanh9898/matt-with-paseo-plugin/blob/main/docs/contract.md`. Keep that link on `main`; never point it at `release/v0.1.0`. Name in your report what the ship pull request's Merge Danger needs (the `Level` row and "The decision log" live on `release/v0.1.0` until the plugin's `v0.1.0` merges).
- `Requires plugin contract: 1` in the wave skill's words block stays exactly as it is.
- `scripts/pinned-lines.json`: each row is a file, an exact phrase and a reason; the phrase must stay whole on one physical line of its file. If you reword or move a pinned sentence, update its row in the same commit.
- `TROUBLESHOOTING.md`: every `caught` rating names a phrase that must stay in the file it names (`scripts/troubleshooting-ratings.py`).
- `scripts/seat-facing-paths.txt`: every file of a skill folder must be listed there.
- Eval cases in `plugins/matt-with-paseo/evals/`, one folder per case (`case.yaml`, `prompt.md`, `fixture.sh`, `graders/*.md`), with the observed-state block in `prompt.md` (README "Observed state in the prompt"). A close shape for #131's case: `streams-52-answer-and-machine` and `streams-39-question-round`.
- Words: use every words-block term only in its defined meaning; define no term outside a words block, each term in one block only. A word added to the stream skill's block is also added to `AGENTS.md`'s "Domain docs" list.

## File zones
"Stream skill" is `plugins/matt-with-paseo/skills/matt-with-paseo-streams/SKILL.md`; `OWNERSHIP.md` sits beside it.

| Ticket | Owns |
|---|---|
| #130 | `docs/adr/0013-three-autonomy-levels-in-the-delegation-table.md` (new); in `docs/adr/0011-*.md` the `Amended by ADR 0013` line after the front matter and the two pointer lines; in `docs/adr/0005-*.md` its `Amended by ADR 0013` line. Docs only: no skill, `OWNERSHIP.md` or README text. |
| #131 | Stream skill: "Delegation: what you may answer for the user" (rule table, resolution table, doors, example tables, "When you answer", "Always the user's" renamed level 2 only, the new "The user's at every level", the level-3 ship row pointing to step 6), "The index" field table and example, step 5's restart-budget paragraph and its status-line item (the level-3 resume), "Intake agents", step 0's intake sentence, the "Intake agents" refusal line, the "Decisions" paragraph's "an answer you sent from the delegation table" wording only, step 4's first rule, route row and stage confirmation, step 7's overlap paragraph; `OWNERSHIP.md`'s header Inputs wording, the orchestrator "Answer, approve or pick" row and the "Write a spec or a ticket" row; README "When the orchestrator answers"; the new eval case `streams-131-autonomy-levels` and README's eval case count line; `AGENTS.md` "Domain docs" for any word it adds. |
| #132 | Stream skill: step 6 (opening paragraph, "Ask first", "Push and open" item 7, "Post the link", Done when), step 5's tick table row for a level-3 stream waiting on CI, the status-line table rows `waits on CI` and `merged by the orchestrator <date>` and the status-line example `shipped …, waits on the reviewers`; `OWNERSHIP.md`'s orchestrator "Merge the pull request" row and, in its "Owns" cell, only the clause on the ship question and the pull request; README line 107's "It never merges"; the level-3 turn added to `streams-131-autonomy-levels`. |
| #133 | Stream skill: the "Decisions" paragraph of "Decisions, memory, machine and credentials" (beyond #131's one wording), "Inputs: public signals only", "A delegated answer", the status-line table's delegated-answer row and its example; `OWNERSHIP.md`'s "Owns" cell, only the clause on `decisions.md` and the plugin's log; one sentence in README's "When the orchestrator answers"; the stream's one version bump (below). |

- The bump: only #133 changes `plugins/matt-with-paseo/.claude-plugin/plugin.json`, `0.7.0` → `0.8.0`, once, with README's `--pin v0.7.0` line. The version gate compares with tag `v0.7.0`. No other ticket changes a version number.
- New eval case: only #131's, `plugins/matt-with-paseo/evals/streams-131-autonomy-levels`. #132 extends it with a level-3 turn and adds no case. #133 adds none.
- #132 and #133 run side by side and both write the stream skill's status-line table, `OWNERSHIP.md`'s "Owns" cell and README: each adds or changes only its own row or clause, and keeps the order of the existing lines. Neither rewrites the other's.
- Outside your zone: name the file, the section and the change you would make in your report instead of editing it.

## Eval, test and review rules (the owner's, for this stream; `docs/agents/evidence-standards.md`)
- **Each ticket runs only its own new or changed test file, once red on the base and once green on the head**, and records both runs as `Test run:` lines in its `Resolved:` comment. For skill and ADR text the "test" is a `grep` per acceptance criterion, run on the base (`git show <base>:<path> | grep …`, seen to fail) and on your head (seen to pass). If you change a test file under `scripts/` (for example because it hard-codes a line you changed), run that one file once before and once after.
- **No ticket runs the full suite, the drift check, an eval (neither the suite nor one case) or a code review.** You do not run `python -B -m unittest discover …`, `python -B scripts/drift-check.py`, `claude plugin eval`, `/mattpocock-skills:code-review` or any review sub-agent. No bundle review runs: the evidence standards defer it to the stream's end. You may write and change tests, checks and eval cases.
- **Grep the tests for every line or call you change.** Before you reword, move or delete a sentence, a heading, a table row or a command in a skill, `OWNERSHIP.md`, README or an ADR, search `scripts/` (tests, `pinned-lines.json`, `seat-facing-paths.txt`, the ratings) and `plugins/matt-with-paseo/evals/` for it: `grep -rnF '<phrase>' scripts plugins/matt-with-paseo/evals`. Update what pins it in the same commit, or name it in your report. The last plugin stream's CI caught a hard-coded list a ticket missed.
- **Never hard-code a Windows path** (a drive letter, a backslash path, `%TEMP%`, a `C:/Users/...` path) in any committed file: skill, test, eval fixture, grader or ADR. Use paths relative to the repository, or derive them at run time. The last plugin stream's CI on Ubuntu and macOS caught one.
- **At most one new eval case per ticket**, only when its criteria name one (only #131). Each grader is designed to fail on your base commit's skill; name, for each grader, the base-skill line that makes it fail. Graders check external behaviour only, never the skill's wording.
- After the last ticket, the orchestrator runs one code review over the whole stream diff, one fix pass, then the one eval run, then targeted `--case <name> --runs 3` re-runs only. CI runs every unit test and the drift check on the ship pull request; a red pull request is never merged.

## Traps already hit
- Committing on the integration branch moves its HEAD. Commit only on your own branch; never check out or commit to `stream/skills-autonomy-levels`. Check: `git branch --show-current` before each commit.
- Never edit anything under `.git/` (shared by every worktree). Do not use bare `git stash`; make a WIP commit on your branch instead.
- `git checkout -- <file>` and `git checkout <commit> --` throw away edits or detach HEAD. Read an old version with `git show <base>:<path>`; revert one edit with the file-editing tool. Check: `git diff <file>` and `git branch --show-current` before you commit.
- Commit in small steps; leave no work outside git. Check: `git status --porcelain` is empty before your report. Delete any `evals/results/` folder and any stray empty folder.
- If a git command hangs, stop and report; do not delete lock files.
- Write and edit files only with the Write and Edit tools, never a shell heredoc, `python -c`, `sed` or `echo >` (evidence standards, "Writing files"): the owner's shell swallows backslashes.
- Windows: `python3` is the Microsoft Store alias and fails (exit 49); use `python -B`. Python needs `PYTHONIOENCODING=utf-8` for non-ASCII output. Git Bash's `/tmp` is not the path Windows Python sees; use your temp directory.
- A `case.yaml` value holding `: ` unquoted does not parse, and the eval runner then skips the case. Check: every `description` holding `: ` is quoted; `python -B -c "import yaml,sys; yaml.safe_load(open(sys.argv[1],encoding='utf-8'))" <case.yaml>` exits 0 when PyYAML is installed.
- Moving text out of a `SKILL.md` removed `caught` phrases in an earlier stream and broke the ratings test. Check: for each `caught` rating in `TROUBLESHOOTING.md` naming a file you touched, `grep -cF '<phrase>' <file>` prints at least 1.
- Rewording a pinned sentence without its row breaks the drift check. Check: for every row of `scripts/pinned-lines.json` whose file you touched, `grep -cF '<phrase>' <file>` prints at least 1.
- A new file in a skill folder missing from `scripts/seat-facing-paths.txt` fails the version gate. Check: `git diff --name-only --diff-filter=A <base> -- plugins/matt-with-paseo/skills` lists only paths that `grep -xF` finds in that file.
- A test file with a hard-coded list (such as `scripts/test_version_gate.py`'s seat-facing list) failed the last stream's run when a ticket added a file. Check: the grep of the tests above.
- A grader that cannot fail on the base skill proves nothing. Check: name the base-skill line that makes each grader fail.
- Agents stopped on a session limit mid-work in earlier waves. Your commits are your progress: commit before long steps, so a resume can pick up from `git log`.
- `gh` has failed with `x509: certificate signed by unknown authority` (network SSL inspection). Not yours to fix: write the text you would post into your temp directory, say so in your report, and carry on with local work.
- Put temporary files only in your temp directory, never loose in `%TEMP%`. Before reporting, list your temp directory and quote the result.

## Failing on base
- On `8a361df`, before the first spawn, run by the orchestrator (2026-10-01): `python -B -m unittest discover -s scripts` ran 103 tests, OK; `python -B scripts/drift-check.py` exit 0. None: every command passes. (You do not run either; see the eval, test and review rules.)
- The version gate's self-test `test_this_repository_passes_its_own_gate` fails from this stream's first change to a seat-facing file until #133 bumps the version. It is not yours.
- A failure listed here is not yours: leave it as it is unless your ticket's acceptance criteria name it, and name it in your report as failing on base. A failure not listed here is yours to explain.

## Acceptance criteria are the contract
- A trap above, or an instruction an earlier ticket left in its comments, is guidance; your ticket's acceptance criteria are the contract.
- On conflict, follow the criteria and write the discrepancy and its reason in a comment on your issue; do not stop to ask.
- If the criteria themselves look wrong, stop that part, write the evidence in a comment on your issue, and add the `ready-for-human` label. Never rewrite the criteria.

## What must hold, what was chosen, what is not known yet

| Part | What it holds | What you do when your evidence goes against it |
|---|---|---|
| Must hold | Your ticket's acceptance criteria, and the section above. The owner's decisions D125 and D127, already in the tickets: level 3 ("thả cửa") also resumes a stream past its restart budget (once per wave; a second stop in the same wave goes to the user) and starts intake agents; level 3 keeps for the user only spend past the appetite, an action that changes the machine, and a credential or other human-only step; a question with no recommendation takes the smaller option only at level 3, listed under `## Decided without evidence`; ADR 0005 gains one `Amended by ADR 0013` line; at level 3 a `Missing:` template section no longer blocks the ship. | Follow the section above; never rewrite the criteria. |
| Chosen for you | The one version bump, `0.7.0` → `0.8.0`, is #133's: the owner's rule puts it in the last ticket, and #133 is the last by number of the two that close the stream; a minor bump because the stream adds behaviour. | Challenge it with evidence, in your ticket's comments and your report. A challenge alone does not move the ticket to `ready-for-human`. |
| Chosen for you | README's eval case count line ("A full run is 34 cases …") is #131's, since #131 adds the case: `35 cases (…, 1 added for 0.8.0)`. | As above. |
| Chosen for you | `OWNERSHIP.md`'s "Owns" cell is shared by #132 and #133: each adds its own clause, #132 on the ship question and the merge, #133 on `decisions.md` and the plugin's log; the orchestrator resolves a merge conflict there by keeping both clauses. | As above. |
| Chosen for you | Ticket agents do not load `/paseo-plugin` and design nothing on the plugin's side; the plugin's behaviour is read from #57, #58, #54 and contract v1 (orchestrator D95/D96 of the last stream). | As above. |
| Not known yet | How plugin #58 will word the `Level` row in contract v1: the contract on `release/v0.1.0` still reads `Switch` only. | Write from your ticket and #58's issue text; name in your report each point you could only read, not run, and what the Merge Danger needs. |

Whoever answers a challenge to a chosen default writes why the plan changes or stands; an answer with no reason is not a resolution.

## Resources
- Your private resources are listed in your prompt (a temp directory only). Use exactly that set. Create it when you first need it and leave it in place when you finish; the orchestrator removes it after your merge.
- Shared, read-only: the main checkout `D:\matt-with-paseo-streams\matt-with-paseo` (do not write there); the plugin checkout `D:\matt-with-paseo-streams\matt-with-paseo-plugin` (read `origin/release/v0.1.0` or `origin/main` with `git show`; no checkout, fetch, commit or edit); the installed Matt plugins under `~/.claude/plugins/cache/`; the GitHub repository `hanh9898/matt-with-paseo-plugin` (read only).
- Machine-wide: the Paseo daemon, this machine and one usage limit are shared by every agent. Create no Paseo workspace, agent, heartbeat or schedule. Do not set `core.hooksPath` or any git config in a shared checkout.

## Repo and user rules
- Skills, ADRs, README and all GitHub text in **English**. `CODING_STANDARDS.md` is the standard for every document an agent reads: numbered steps, a **Done when** per step that matches its body, choices as table rows, one concept one word, one source of truth, one clause per sentence.
- Commit format: the repo's style, `<type>(<scope>): <summary> (#NN)`, types and scopes as in `feat(streams): …`, `feat(wave): …`, `test(evals): …`, `docs(adr): …`, `docs(readme): …`, `chore(release): …`. End every commit message with `Co-Authored-By: Claude Sonnet 5.5 <noreply@anthropic.com>`.
- Do not push, do not tag, do not open a PR, do not close your issue.
- No `AskUserQuestion`: when you need a decision, end your turn with the question in text, with your recommendation.
- Credentials: never read, print or pass on a token or credential (no `gh auth token`, no `gh auth status`, no reading a CLI's hosts or config file or a token's environment variable, no token in a URL or a command). A `gh`, push or upload failure goes into your report with the command and its error as printed; never work around it with another tool, the forge's API or another account.
- Evidence standards: read `docs/agents/evidence-standards.md`; it is not copied here. No code review runs inside this wave (see the eval, test and review rules above).

## Done when:
Each item below holds for one ticket, and you go through them again for each ticket of your bundle.
- Commit to your branch. The orchestrator merges it. Keep no pull-request text in your worktree; put what the ship needs in your report.
- No code review runs, and no bundle review either (the evidence standards defer it to the stream's end).
- Mark the ticket done with a comment on its own issue starting `Resolved:` (leave the issue open; the orchestrator closes it after the merge), or add `ready-for-human` for the part a human must do. In it, write what you changed, each acceptance criterion with its `Test run:` line (the check, red on the base, green on the head, with output), what remains open, and which eval cases and tests you wrote, written, not run. There is no bundle-level evidence.
- Report back for that ticket, with the SHA of its last commit: a design summary, files touched, how you verified with evidence, work not done or still in doubt (every out-of-zone change you would make), every change outside git, each private resource you created, and decisions the user must make. Tag each decision `decided: X because Y` or `assumed: X, unchecked`, and each finding `reproduced` or `traced`.
- End your turn after each ticket's report, then wait for `next` (start the bundle's next ticket) or `stop` (hand off as the orchestrator's message says). The rule above about background work holds at every one of these turn ends. A bundle of one ends its turn once.
- At your bundle's last ticket: clean up your temp directory (state the reason for anything you keep) and check `git status --porcelain` is empty.

## Checkpoints
- Step 0, stage C with `stream`, next step 1 (asked 2026-10-01, answered by the orchestrator D128): changed the work: no; took the recommendation: yes.
- Step 2, wave 1 with bundle `[130+131]`, then #132 and #133 side by side with file zones, quota 2 (approved in advance by the orchestrator D128, plan unchanged by steps 1 and 2): changed the work: no; took the recommendation: yes.

## Wave agents

| Bundle's tickets | Agent id | Workspace id | Branch | Base commit | Private resources | Merged SHAs | Cleaned |
|---|---|---|---|---|---|---|---|
| 130+131 | b57852ef-9eae-414e-a038-9b5a74f8027e | wks_95ca2bdc1d4bce77 | `skills-autonomy-levels/wave1/130-adr-0013-autonomy-levels` | `8a361df` | temp `%TEMP%\skills-autonomy-levels-130` | 130: 97aa12f, 131: 677e968 | [x] |
| 132 | 9ba7cb40-fa5d-4f13-9808-6a5d0c2c9738 | wks_7a4f164916ebc994 | `skills-autonomy-levels/wave1/132-level-3-ship-merge` | `4006655` | temp `%TEMP%\skills-autonomy-levels-132` | 132: 5cd14ed | [x] |
| 133 | 9960eb88-5935-411a-a081-c3e94cff9f68 | wks_40d0dbad33b09b73 | `skills-autonomy-levels/wave1/133-decision-log-entries` | `4006655` | temp `%TEMP%\skills-autonomy-levels-133` | 133: 9c45801 | [x] |

## Wave log

- 2026-10-01: #130 merged at bdc7245. Its claim "assumed: matches plugin #58, unchecked" checked by the orchestrator against #58's issue text (resolution, `Switch` ignoring case, default 1, `one-way` at level 3): holds.
- #131 merged at 4006655. Accepted, recorded on #131 (comment 5928601333), for the stream review: the eval case uses two streams instead of "the same index row" (so the level-2 grader can fail on the base); the words block's **Intake agent** definition gains the level-3 case, out of zone, no new word; README's level-3 paragraph names merging before #132 writes step 6.
- Rolling start after #131's merge: two slots free, #132 and #133 spawned as two bundles of one on base 4006655. Mid-wave zone extension, sent in #133's prompt only: #131's new step-5 status-line item `resumed at level 3 (decisions.md …)` is #133's to bring to the `D<n>` shape.
- #133 merged at a1b1b75 (version 0.8.0). For the stream review, out of #133's zone, traced by its agent: the stream skill still says "append a line to `decisions.md`" in step 3 (cap/quota), step 4 (intake) and step 7 onward ("Append each answer to `decisions.md`"); the eval case `streams-131-autonomy-levels` still says "`decisions.md` line". Both should read "entry".
- #132 merged at a99f324, with one conflict in `OWNERSHIP.md`'s orchestrator "Owns" cell (#133's `D<n>` clause and #132's level-3 ship and merge clause): both kept in one row, as the common rules chose; conflict-marker search empty. Assumptions accepted as decided by the orchestrator: the level-2 "Merging the pull request" row stays as is (it sits under "Always the user's at level 2"); a pull request with no check reported is not green, goes to the user once, and nothing merges (the smaller option); the status-line item `CI fix pass sent <time>` records the one fix pass. Out of zone, accepted: `plugins/matt-with-paseo/README.md` line 28 (criterion 5 bans an unconditioned "never merges" in the README). For the stream review: #132, written in parallel with #133, still says "a `decisions.md` line" in step 6 (the ship answer, the merge, Done when) and its eval prompt's status lines use the old `(decisions.md <date> <time>)` form; both should take #133's `D<n>` entry shape.
- Every ticket of the wave is merged (a99f324). The evidence standards defer the per-wave seam review (step 7) to the stream review after the last wave.

## Review

This is the stream's last wave, so the per-wave seam review and the stream review are one run (`docs/agents/evidence-standards.md`, "Once per stream"). `mattpocock-skills:code-review` in the orchestrator's session (no profile's notes say review), two read-only sub-agents, fixed point `8a361df`, head `a99f324`, `.scratch/` excluded (15 files, +327/−54). **Standards: 7 findings (S1–S6 hard, S7 judgement); Spec: 6 findings (P1–P6).**

| # | Where (stream `SKILL.md` unless named) | Finding | Axis | Outcome |
|---|---|---|---|---|
| S1/P1 | :773, step 6 "The ship question at level 3" | Records the ship answer as "one `decisions.md` line" and the old status item `answered from the delegation table (decisions.md <date> <time>)`, against #133's `D<n>` entry and `answered by the orchestrator (D<n>)` (:197, :261) | Std hard, Spec | fix pass: defer to "A delegated answer" |
| S2/P2 | :815, :819, status-line row :279 | The level-3 merge is "one line" in `decisions.md`, and its status item names no `D<n>`, while :79 lists a level-3 merge among the `D<n>` entries | Std hard, Spec | fix pass |
| S3 | :308, :510 (step 3), :762, :864, :880 | "append … to `decisions.md`" with no entry shape | Std hard (one concept one word) | fix pass |
| S4/P3 | eval `streams-131-autonomy-levels`: `fixture.sh` :19-20, `prompt.md` :8, :28, the level-2 and both level-3 graders | Old status item `(decisions.md <date> <time>)` and "a `decisions.md` line" wording | Std hard, Spec | fix pass, each grader still failing on `8a361df` |
| S5 | `OWNERSHIP.md` orchestrator "Owns" cell | Repeats level-3 rules and "each with its `D<n>` entry" | Std, minor | skipped: #132's and #133's criteria each require their clause in that cell |
| S6 | :198 against :261-262 | "A delegated answer" step 2 restates the status items the table gives | Std | skipped: #133's criterion asks "A delegated answer" to name the `D<n>` status item in its record steps |
| S7 | per-level splits (:345, :647, :773, :801, :803); "Level" not in the words block | Repeated Switches, Mysterious Name | Std, judgement | skipped: each ticket asked for its own "below level 3" wording in place; `Level` is a table row, not a words-block term, and `AGENTS.md` lists only words-block terms |
| P4 | :345, :376 | The level-3 intake spawn's entry has no status-line item naming its `D<n>` | Spec, partial | skipped: #131's criterion asks only for the `decisions.md` entry, which is there |
| P5 | :197, "A delegated answer" step 1 | Does not say a level-3 no-suggestion answer also adds its line under `## Decided without evidence` (only :90, :172) | Spec | fix pass: one pointer |
| P6 | :805, :806 | Not asked: a pull request with no check is not green; `CI fix pass sent <time>`; drift check exit 2 only warns | Spec, scope | no change: the first two were accepted at #132's merge as decided (wave log); the exit-2 sentence is in #132's ticket text |

Review run mark: changed the work: yes (fix pass raised).

### Fix pass

| Ticket | Agent id | Workspace id | Branch | Base commit | Private resources | Merged SHAs | Cleaned |
|---|---|---|---|---|---|---|---|
| review | 1bcfe5f8-6e77-492f-aefc-e1770446aae2 | wks_9e02051916e2f933 | `skills-autonomy-levels/wave1/stream-review-fixes` | `a99f324` | temp `%TEMP%\skills-autonomy-levels-review-fixes` | review: bce472a | [x] |

Fix pass merged as 2819f44 (2 commits: 330ce4f skill, bce472a eval; conflict-marker search empty; worktree clean). Its 31 checks: 31 FAIL on a99f324, 31 PASS on its head. Each grader of `streams-131-autonomy-levels` still names a base line (8a361df) that makes it fail. Decided by the fix agent and accepted: S3 also covers the Hold and Resume sentences (:336, :339), same defect; the fixture seeds a `decisions.md` with D1 and D2 so the status items point at real entries; the level-3 merge grader asks for the merge and its entry, not the exact status string. Pins: none touched.

Wave 1 cleaned: 4 tickets and the fix pass merged; every row stopped, clean and merged, archived with its workspace (directories removed); temp directories removed; no heartbeat was created (this session spawned every agent). `paseo ls -g --label stream=skills-autonomy-levels --label wave=1` lists nothing.

### Eval run

The stream's one eval run, on 2819f44 (2026-10-01), the owner's command from `plugins/matt-with-paseo`: 35 cases loaded and run (1 run each, 1039 s, $7.62, exit 0): **23 at 1.00, 10 partial, 2 at 0.00**. Report at `plugins/matt-with-paseo/evals/results/2026-10-01T09-46-58-759Z/` (gitignored).

| Case | Score now | Score on 8f7f5b9 | Failing grader now | Verdict changed |
|---|---|---|---|---|
| `streams-131-autonomy-levels` (new) | 0.75 | not present | `level-1-cell-relays-both` | new |
| `streams-40-silent-supervision` | 0.60 | 0.80 | `nudges-idle-stream-agent` | no (partial) |
| `streams-41-hung-agents` | 0.50 | 0.83 | `kills-and-replaces` | no (partial) |
| `streams-49-ship-branch` | 0.56 | 0.78 | `conflict-reported-not-asked` | no (partial) |
| `streams-51-overlap-and-need` | 0.50 | 0.50 | `need-yields-merge-or-hold` | no |
| `streams-52-answer-and-machine` | 0.50 | 0.50 | `status-line-drops-answer` | no |
| `streams-61-ship-rules` | 0.20 | 0.40 | `names-ship-rules-change` | no (partial) |
| `wave-121-bundle-turn-end` | 0.80 | 0.80 | `stops-at-ticket-cap` | no |
| `wave-53-review-merge-and-decision` | 0.50 | 1.00 | `markers-reported` | yes, pass → partial |
| `wave-54-repro-and-no-code-flow` | 0.57 | 1.00 | `chain-shown-as-bundle` | yes, pass → partial |
| `wave-75-chosen-default-challenge` | 0.00 | 0.00 | `answer-names-reason` | no |
| `wave-95-user-language-one-door` | 0.00 | 0.00 | `two-languages` | no |
| `streams-39-question-round`, `streams-46-adopt-unstreamed-wave`, `streams-47-setup-checks`, `streams-50-after-ship` | 1.00 | 0.60, 0.50, 0.67, 0.33 | none | yes, partial → pass |

Targeted re-runs (`--case <name> --runs 3`), per the evidence standards: the case this stream added and the cases whose verdict changed, 7 cases. The wave skill was not changed by this stream, so `wave-53` and `wave-54` can only have moved by noise.

| Case (`--runs 3`, 2819f44) | Score | Pass | Failing grader |
|---|---|---|---|
| `streams-131-autonomy-levels` | 0.00 | 0 of 3 | no verdict: all 3 runs ended with `API Error: Sonnet 5.5 can't help with this … [reasoning_extraction]` (exit 1) before any grader ran; $1.19 spent |
| `streams-39-question-round` | 0.93 | 2 of 3 | `relays-verbatim` (1 run) |
| `streams-46-adopt-unstreamed-wave` | 1.00 | 3 of 3 | none |
| `streams-47-setup-checks` | 0.78 | 1 of 3 | `asks-tracker-choice` |
| `streams-50-after-ship` | 0.89 | 2 of 3 | `sets-reopened-status` (1 run) |
| `wave-53-review-merge-and-decision` | 0.83 | 2 of 3 | `decision-before-close` (1 run) |
| `wave-54-repro-and-no-code-flow` | 0.95 | 2 of 3 | `symptom-not-bundled` (1 run) |

`streams-131`'s one scored run (0.75, the full run): `level-1-cell-relays-both` failed because the run read both `billing-export` and `billing-audit` as level 2 and answered `billing-audit`'s wave approval itself. `billing-audit`'s index Level cell `1` is only in the fixture's `streams.md`; the observed-state block in `prompt.md` never states it (it says each index Level cell is empty only for the two level-3 streams). Traced: a case gap is the likelier cause, the skill's resolution table naming the index cell first. The other three graders passed in that run, among them both level-3 graders (the merge with `--squash --delete-branch`, no `--admin`, and one CI fix pass for the red check).

Open for the orchestrator (not fixed: the stream's one fix pass is spent): the `streams-131` observed-state gap, and whether to retry its three runs once.

**Orchestrator's decision (D132, 2026-10-01):** 1: fix the case with one sentence naming `billing-audit`'s Level cell in the observed state; 2: re-run only `streams-131` with `--runs 3`, once, recording "no verdict" if the API filter stops it again. Done: the sentence went into `prompt.md` (5802d0a; the grader still fails on 8a361df, whose skill reads only a `Delegation` column). Re-run on 5802d0a (175 s, $0.97): **0.92, 2 of 3 runs at 1.00**; the third run failed `level-1-cell-relays-both` alone (0.75). The API filter did not stop it. Report at `plugins/matt-with-paseo/evals/results/2026-10-01T10-16-09-090Z/` (gitignored).

### Merge Danger

- Contract: the `Level` row and "The decision log" live in contract v1 only on `hanh9898/matt-with-paseo-plugin`'s `release/v0.1.0` (plugin #58 still open) until the plugin's `v0.1.0` merges. The skills' contract link stays on `main`, and `Requires plugin contract: 1` is unchanged.
- Eval, new case: `streams-131-autonomy-levels` 0.92 over 3 runs on 5802d0a. `level-1-cell-relays-both` failed in 1 of 3 runs: the run read `billing-audit` as level 2 and answered its wave approval itself, though its index Level cell `1` should win over the repository's table.
- Eval, other cases below 1.00 in the one full run on 2819f44, none fixed (1 run each, noisy). Compared with `plugin-v0-1-0-skills`' run on 8f7f5b9:

| Case | Score now | Score on 8f7f5b9 | Failing grader now | Stream text it could touch |
|---|---|---|---|---|
| `streams-40-silent-supervision` | 0.60 | 0.80 | `nudges-idle-stream-agent` | step 5's restart budget (#131's level-3 resume) |
| `streams-41-hung-agents` | 0.50 | 0.83 | `kills-and-replaces` | step 5's restart budget (#131) |
| `streams-49-ship-branch` | 0.56 | 0.78 | `conflict-reported-not-asked` | step 6 (#132) |
| `streams-51-overlap-and-need` | 0.50 | 0.50 | `need-yields-merge-or-hold` | step 7's overlap paragraph (#131) |
| `streams-52-answer-and-machine` | 0.50 | 0.50 | `status-line-drops-answer` | status line (#133) |
| `streams-61-ship-rules` | 0.20 | 0.40 | `names-ship-rules-change` | step 6 (#132) |
| `wave-121-bundle-turn-end` | 0.80 | 0.80 | `stops-at-ticket-cap` | none (wave skill unchanged) |
| `wave-75-chosen-default-challenge` | 0.00 | 0.00 | `answer-names-reason` | none |
| `wave-95-user-language-one-door` | 0.00 | 0.00 | `two-languages` | none |

- Re-run with `--runs 3` (verdict changed against 8f7f5b9): `streams-39` 0.93, `streams-46` 1.00, `streams-47` 0.78, `streams-50` 0.89, `wave-53` 0.83, `wave-54` 0.95. The full run's `wave-53` 0.50 and `wave-54` 0.57 were noise: the wave skill is unchanged.

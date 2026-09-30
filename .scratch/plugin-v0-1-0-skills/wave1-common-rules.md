# Common rules for wave 1 (tickets #110, #113, #111, #112, #114; then #125, #126)

## Graph
`{110, 113, 111} → 112 → {114, 125, 126}` ; bundles: `{110, 113, [111+112+114]}`, then `[125+126]` by rolling start

Edges are the `Blocked by` line of each issue, reconciled with GitHub's native dependencies on 2026-09-30 (orchestrator D93): #111's native edge now points to hanh9898/matt-with-paseo-plugin#34 (closed), as its body says; #125 and #126 gained the native edge on #112 their bodies declare. #114's other blocker, hanh9898/matt-with-paseo-plugin#5, is closed. Quota 3: three bundles start now; #125 and #126 join by rolling start once #112 is merged and a slot is free, as one bundle `[125+126]` while fewer than two slots are free, as two bundles otherwise.

| Ticket | Status | Blocked by | Wave |
|---|---|---|---|
| #110 The `## Delegation` table | open, ready-for-agent | - | 1, bundle of one, started first |
| #113 Stop a push that breaks the drift check | open, ready-for-agent | - | 1, bundle of one, started first |
| #111 Detect the plugin and require a contract version | open, ready-for-agent | plugin#34 ✓ | 1, bundle `[111+112+114]`, started first |
| #112 Supervise from the plugin's messages | open, ready-for-agent | #111 | 1, bundle `[111+112+114]` |
| #114 Move the case tables behind the heartbeat pointer | open, ready-for-agent | #112, plugin#5 ✓ | 1, bundle `[111+112+114]` |
| #125 List the user's words in the wave summary | open, ready-for-agent | #112 | 1, rolling start, waiting on the quota |
| #126 Judge a Stall suspected message, one eval case | open, ready-for-agent | #112 | 1, rolling start, waiting on the quota; the stream's last ticket (version bump) |

## Context
- Your worktree branches off `stream/plugin-v0-1-0-skills` at `f62d275` (`main` after `ticket-sizing` shipped, v0.6.0), unless your prompt names another base commit (a bundle started by rolling start). Tickets of this stream merged before yours are on that base; your prompt names them.
  Run `git branch --show-current` before every commit.
- Read before you start: your ticket and its comments (`gh issue view <n> --comments`: decisions of 2026-09-30 are recorded there); contract v1, which lives in the plugin repository: `git -C D:/matt-with-paseo-streams/matt-with-paseo-plugin show origin/main:docs/contract.md` (the sibling checkout's local `main` is stale and lacks the file; read `origin/main`, never check out or edit anything in that checkout); `CODING_STANDARDS.md`; ADRs in `docs/adr/` (0004, 0006, 0008, 0009, 0010 matter here); the words blocks at the top of both `SKILL.md` files; `scripts/pinned-lines.json`; README "Behaviour evals" if your ticket touches an eval case.
- 2 other agents (bundles) are working the remaining tickets of this wave in parallel, on other branches.
  Work only on your own bundle, one ticket at a time, in the order of your prompt.
- Do not end your turn while work you started is still running in the background (a long command, a sub-agent): wait for it inside the same turn. Paseo sends no finish notification for a turn you start on your own afterwards, so your "finished" report must mean the work is done.
- Start any command that may take more than two minutes in the background from the start, and read its output when it finishes. A foreground command the shell moves to the background halfway can leave your turn waiting on a result that never returns.
- No plugin runs on this machine: nothing you write can be tried against the real plugin. Write the message path from contract v1's text.

## Parameters
- Ticket cap: 4, the most tickets step 2 plans into a bundle. While Jev is not available it is also the fallback stop: once a ticket agent has worked this many tickets, the orchestrator answers `stop` (step 5).
- Context stop: 600K `contextWindowUsedTokens`, the size of a ticket agent's context at which the orchestrator answers `stop`, while Jev is not available (step 5).
- With Jev, its flag is what stops a bundle (step 5); the ticket cap still bounds the bundle's size.

## Existing interfaces to reuse
- Contract v1 (above): the "Plugin detection" rule (`paseo plugin ls` lists `matt-with-paseo` with status `running`), "What the skills declare" (`Requires plugin contract: <n>` in a words block), the message types with their `Next:` lines, "Labels the plugin reads", "The ticket-agent title", "What the plugin reads from the delegation table". Cite the contract by its URL, `https://github.com/hanh9898/matt-with-paseo-plugin/blob/main/docs/contract.md`; restate a message only as far as your skill text needs it.
- `scripts/pinned-lines.json`: each row is a file, an exact phrase and a reason; the phrase must stay whole on one physical line of its file. If you reword or move a pinned sentence, update its row in the same commit.
- `TROUBLESHOOTING.md`: every `caught` rating names a phrase that must stay in the file it names (`scripts/troubleshooting-ratings.py`). Moving text out of a `SKILL.md` can remove such a phrase.
- `scripts/seat-facing-paths.txt`: every file of a skill folder must be listed there. A new file in a skill folder (such as a heartbeat-path file) gets its line in the same commit.
- Eval cases in `plugins/matt-with-paseo/evals/`, one folder per case (`case.yaml`, `prompt.md`, `fixture.sh`, `graders/*.md`), with the observed-state block in `prompt.md` (README "Observed state in the prompt"). #126's shape is `streams-41-hung-agents`.
- Words: use every words-block term only in its defined meaning; define no term outside a words block, each term in one block only. A word added to the stream skill's block is also added to `AGENTS.md`'s "Domain docs" list.
- `PASEO-FACTS.md` holds verified Paseo facts; point to it rather than restating one.

## File zones
"Wave skill" is `plugins/matt-with-paseo/skills/matt-with-paseo/SKILL.md`, "stream skill" is `plugins/matt-with-paseo/skills/matt-with-paseo-streams/SKILL.md`.

| Ticket | Owns |
|---|---|
| #110 | Stream skill: the `## Delegation` definition and example table, the per-stream override field of the index, the status-line item for a delegated answer, the "Decisions, memory, machine and credentials" amendment, and the lines of the stream skill that bring checkpoints to the user where the switch changes that; `OWNERSHIP.md` where delegation changes who decides; `docs/adr/0011-*.md` (new); README's stream section: the paragraph on when the orchestrator answers, and the "never answers for you" promise; `AGENTS.md` "Domain docs" list for any word it adds. |
| #111 | Wave skill words block: the line `Requires plugin contract: 1`; the detection step in each skill with its three outcomes; README: the paragraph saying the plugin is optional and naming contract version 1 (in "Requirements"). |
| #112 | Wave skill step 5 (message path, heartbeat contract behind one pointer) and step 4's labels/title rule on the message path (the Decision on #112); stream skill step 5 (the tick on each message, heartbeat behind one pointer); the heartbeat-path file(s) the pointers lead to, and their lines in `seat-facing-paths.txt`; `docs/adr/0012-*.md` (new); README's stream section: the paragraph naming both paths. |
| #114 | Stream skill step 5's "Observed, for one stream" table and the other case-table rows that move; the heartbeat-path file(s) #112 made (adding the moved rows). |
| #113 | A committed hooks directory with the pre-push hook (new files), its tests if any (new files under `scripts/`), README "Contributing": how to turn the hook on. |
| #125 | Wave skill: handling of a `Human words:` message on the message path, and step 8's summary. |
| #126 | Wave skill: handling of a `Stall suspected:` message on the message path; the one new eval case (its own folder); `plugin.json` version and the README version pin (the stream's one bump, see below). |

- The bump: only #126 changes `plugins/matt-with-paseo/.claude-plugin/plugin.json`, `0.6.0` → `0.7.0`, once, with any README pin tied to it (the version gate compares with tag `v0.6.0`). No other ticket changes a version number.
- New eval case: only #126's, named in its criteria.
- Shared files (both skills, `seat-facing-paths.txt`, `pinned-lines.json`, README, `AGENTS.md`): add or change only the lines your ticket owns, keep the order of the existing lines. #110 and bundle `[111+112+114]` both write the stream skill and README's stream section: each adds its own paragraph; neither rewrites the other's.
- Outside your zone: name the file, the section and the change you would make in your report instead of editing it.

## Eval, test and review rules (the owner's, for this stream)
- **No ticket runs the test suite, the drift check, an eval or a code review.** You do not run `python -B -m unittest …`, `python -B scripts/drift-check.py`, `claude plugin eval` (neither the suite nor one case), `/mattpocock-skills:code-review` or any review sub-agent. This overrides the wave skill's in-flow review at the end of every flow: no bundle review runs. You may write and change tests, checks and eval cases.
- #113 is the one exception for its own work: under `/mattpocock-skills:tdd`, it runs only the tests it writes for the hook (one file), never the suite, and runs the hook itself against throwaway repositories in its temp directory. It never runs the real drift check on this repository.
- Verify each acceptance criterion with a check that is not the suite: a `grep` red on the base (`git show <base>:<path>`) and green on your head, reading a section, reading an eval case against the base skill text. Your `Resolved:` comment says tests and eval cases were written, not run.
- **At most one new eval case per ticket**, only when its criteria name one (only #126). Each grader is designed to fail on your base commit's skill; name, for each grader, the base-skill line that makes it fail. Graders check external behaviour only, never the skill's wording.
- After the last ticket, the orchestrator runs one full test run, one review of the whole stream diff, one fix pass, then the one eval run.

## Traps already hit
- Committing on the integration branch moves its HEAD. Commit only on your own branch; never check out or commit to `stream/plugin-v0-1-0-skills`. Check: `git branch --show-current` before each commit.
- Never edit anything under `.git/` (shared by every worktree). Do not use bare `git stash`; make a WIP commit on your branch instead.
- `git checkout -- <file>` and `git checkout <commit> --` throw away edits or detach HEAD. Read an old version with `git show <base>:<path>`; revert one edit with the file-editing tool. Check: `git diff <file>` and `git branch --show-current` before you commit.
- Commit in small steps; leave no work outside git. Check: `git status --porcelain` is empty before your report. Delete any `evals/results/` folder and any stray empty folder a broken heredoc left.
- If a git command hangs, stop and report; do not delete lock files.
- Windows: `python3` is the Microsoft Store alias and fails (exit 49); use `python -B`. A lone single quote inside a Bash heredoc breaks parsing; write file content with the file-writing tool. Python needs `PYTHONIOENCODING=utf-8` for non-ASCII output. Git Bash's `/tmp` is not the path Windows Python sees; use `cygpath -w` or your temp directory.
- A `case.yaml` value holding `: ` unquoted does not parse, and the eval runner then skips the case (streams-43 in the previous stream). Check: every `description` holding `: ` is quoted; `python -B -c "import yaml,sys; yaml.safe_load(open(sys.argv[1],encoding='utf-8'))" <case.yaml>` exits 0 when PyYAML is installed.
- Moving text out of a `SKILL.md` removed two `caught` phrases in the previous stream and broke the ratings test. Check: for each `caught` rating in `TROUBLESHOOTING.md` naming a file you touched, `grep -cF '<phrase>' <file>` prints at least 1; if you move the phrase, update the rating in the same commit.
- Rewording a pinned sentence without its row breaks the drift check at the stream's end. Check: for every row of `scripts/pinned-lines.json` whose file you touched, `grep -cF '<phrase>' <file>` prints at least 1.
- A new file in a skill folder missing from `scripts/seat-facing-paths.txt` fails the version gate. Check: `git diff --name-only --diff-filter=A <base> -- plugins/matt-with-paseo/skills` lists only paths that `grep -xF` finds in that file.
- A grader that cannot fail on the base skill proves nothing. Check: name the base-skill line that makes each grader fail.
- Agents stopped on a session limit mid-work in earlier waves. Your commits are your progress: commit before long steps, so a resume can pick up from `git log`.
- `gh` has failed with `x509: certificate signed by unknown authority` (network SSL inspection). Not yours to fix: write the text you would post into your temp directory, say so in your report, and carry on with local work.
- Put temporary files only in your temp directory, never loose in `%TEMP%`. Before reporting, list your temp directory and quote the result.

## Failing on base
- Not run on `f62d275`, by the owner's decision (D93, question 6): tests and the drift check run once, at the stream's end, and no ticket runs them. On `3d37060`/`96b94b0` (the previous stream's end, same skill text as `f62d275` but for its wave log): the full run was fixed to green in its fix pass.
- The version gate's self-test `test_this_repository_passes_its_own_gate` fails from this stream's first change to a seat-facing file until #126 bumps the version. It is not yours.
- A failure listed here is not yours: leave it as it is unless your ticket's acceptance criteria name it, and name it in your report as failing on base. A failure not listed here is yours to explain.

## Acceptance criteria are the contract
- A trap above, or an instruction an earlier ticket left in its comments, is guidance; your ticket's acceptance criteria are the contract.
- On conflict, follow the criteria and write the discrepancy and its reason in a comment on your issue; do not stop to ask.
- If the criteria themselves look wrong, stop that part, write the evidence in a comment on your issue, and add the `ready-for-human` label. Never rewrite the criteria.

## What must hold, what was chosen, what is not known yet

| Part | What it holds | What you do when your evidence goes against it |
|---|---|---|
| Must hold | Your ticket's acceptance criteria, read through the decisions recorded in its comments on 2026-09-30, and the section above. | Follow the section above; never rewrite the criteria. |
| Chosen for you | The `## Delegation` table follows contract v1's rows (`Switch`, `Questions the orchestrator may decide`, `Appetite`), with `Switch: on` meaning delegation on and no section meaning every checkpoint reaches the user: the plugin already reads the table that way (owner D93; comment on #110). | Challenge it with evidence, in your ticket's comments and your report. A challenge alone does not move the ticket to `ready-for-human`. |
| Chosen for you | On the message path, the wave skill plans bundles of one only, labelled `wave` + `ticket` and titled `[Wave N] <NN> <ticket name>`, since contract v1 relays only those; on the heartbeat path bundles stay (owner D93; comment on #112). The plugin-side change is filed by the orchestrator, not by a ticket. | As above. |
| Chosen for you | `Requires plugin contract: 1` is written once, in the wave skill's words block; the stream skill reads it there, as its words line already reads that block (comment on #111). | As above. |
| Chosen for you | ADR numbers: #110 writes `0011`, #112 writes `0012`: two tickets would otherwise both take the next free number. | As above. |
| Chosen for you | The one version bump, `0.6.0` → `0.7.0`, is #126's (owner D93; comment on #126). | As above. |
| Chosen for you | No test, drift check, eval or review runs inside a ticket (the owner's rule for this stream), #113's own hook tests aside. | As above. |
| Not known yet | How the real plugin behaves against the new skill text: no plugin runs on this machine. | Write from contract v1's text; name in your report each point you could only read, not run. |

Whoever answers a challenge to a chosen default writes why the plan changes or stands; an answer with no reason is not a resolution.

## Resources
- Your private resources are listed in your prompt (a temp directory only). Use exactly that set. Create it when you first need it and leave it in place when you finish; the orchestrator removes it after your merge.
- Shared, read-only: the main checkout `D:\matt-with-paseo-streams\matt-with-paseo` (do not write there); the plugin checkout `D:\matt-with-paseo-streams\matt-with-paseo-plugin` (read `origin/main` with `git show`; no checkout, fetch, commit or edit); the installed Matt plugins under `~/.claude/plugins/cache/`; the GitHub repository `hanh9898/matt-with-paseo-plugin` (read only).
- Machine-wide: the Paseo daemon, this machine and one usage limit are shared by every agent. Create no Paseo workspace, agent, heartbeat or schedule. Do not set `core.hooksPath` or any git config in a shared checkout (#113 tries its hook only in throwaway repositories in its temp directory).

## Repo and user rules
- Skills, ADRs, README and all GitHub text in **English**. `CODING_STANDARDS.md` is the standard for every document an agent reads: numbered steps, a **Done when** per step that matches its body, choices as table rows, one concept one word, one source of truth, one clause per sentence.
- Commit format: the repo's style, `<type>(<scope>): <summary> (#NN)`, types and scopes as in `feat(wave): …`, `feat(streams): …`, `feat(scripts): …`, `test(evals): …`, `docs(adr): …`, `docs(readme): …`, `chore(release): …`. End every commit message with `Co-Authored-By: Claude Sonnet 5.5 <noreply@anthropic.com>`.
- Do not push, do not tag, do not open a PR, do not close your issue.
- Credentials: never read, print or pass on a token or credential (no `gh auth token`, no `gh auth status`, no reading a CLI's hosts or config file or a token's environment variable, no token in a URL or a command). A `gh`, push or upload failure goes into your report with the command and its error as printed; never work around it with another tool, the forge's API or another account.
- Evidence standards: none declared.

## Done when:
Each item below holds for one ticket, and you go through them again for each ticket of your bundle.
- Commit to your branch. The orchestrator merges it. Keep no pull-request text in your worktree; put what the ship needs in your report.
- No code review runs (see the eval, test and review rules above), and no bundle review either.
- Mark the ticket done with a comment on its own issue starting `Resolved:` (leave the issue open; the orchestrator closes it after the merge), or add `ready-for-human` for the part a human must do. In it, write what you changed, each acceptance criterion with the check you ran and its output (or "checked by reading", with the lines), what remains open, and which eval cases and tests you wrote, written, not run. There is no bundle-level evidence.
- Report back for that ticket, with the SHA of its last commit: a design summary, files touched, how you verified with evidence, work not done or still in doubt (every out-of-zone change you would make), every change outside git, each private resource you created, and decisions the user must make. Tag each decision `decided: X because Y` or `assumed: X, unchecked`, and each finding `reproduced` or `traced`.
- End your turn after each ticket's report, then wait for `next` (start the bundle's next ticket) or `stop` (hand off as the orchestrator's message says). The rule above about background work holds at every one of these turn ends. A bundle of one ends its turn once.
- At your bundle's last ticket: clean up your temp directory (state the reason for anything you keep) and check `git status --porcelain` is empty.

## Checkpoints
- Step 0, stage C with `stream`, next step 1 (asked 2026-09-30, answered by the orchestrator D93): changed the work: no; took the recommendation: yes.
- Step 2, wave 1 with bundles `{110, 113, [111+112+114]}`, `[125+126]` on the quota, and questions 2–6 (answered D93, "1–6 as recommended"): changed the work: yes (question 4: the plugin-side issue moved to the orchestrator's intake instead of this run; question 2: #111's native edge replaced); took the recommendation: yes.

## Wave agents

| Bundle's tickets | Agent id | Workspace id | Branch | Base commit | Private resources | Merged SHAs | Cleaned |
|---|---|---|---|---|---|---|---|
| 111+112+114 | 126c8f15-8c0a-4295-a983-faf558509157 | wks_3f959085bd44913e | `plugin-v0-1-0-skills/wave1/111-plugin-detection` | `f62d275` | temp `%TEMP%\plugin-v0-1-0-skills-111` | 111: 2d119c3, 112: beb7261, 114: e2f55b4 | [x] |
| 110 | bdbe5041-18f3-4e5e-96bd-4c4f169e69c9 | wks_e047bac05db9950b | `plugin-v0-1-0-skills/wave1/110-delegation-table` | `f62d275` | temp `%TEMP%\plugin-v0-1-0-skills-110` | 110: 8b1e411 | [x] |
| 113 | 42ecf98d-bc2b-4f70-bd87-fd9d6b609bbe | wks_72dd4875acebcfc2 | `plugin-v0-1-0-skills/wave1/113-pre-push-hook` | `f62d275` | temp `%TEMP%\plugin-v0-1-0-skills-113` | 113: eef5430 | [x] |
| 125 | 819265d3-7db0-4087-b2d2-4f0d52161449 | wks_ed6d08b44b19c122 | `plugin-v0-1-0-skills/wave1/125-human-words` | `f9f6c61` | temp `%TEMP%\plugin-v0-1-0-skills-125` | 125: 9e09f89 | [x] |
| 126 | 1e9dd236-c774-45cf-96f0-4ae273dba39f | wks_e64d8650bf200899 | `plugin-v0-1-0-skills/wave1/126-stall-suspected` | `f9f6c61` | temp `%TEMP%\plugin-v0-1-0-skills-126` | 126: 822ee28 | [x] |

## Wave log

- 2026-09-30: #111 sent back once before merge (step 8 still said "six things" after step 1 grew to seven), fixed at 2d119c3. Assumptions accepted as decided by the orchestrator: #111's silent mismatch under `stream` and an unreadable contract version taken as the heartbeat path; #110's overlap warning delegable with suggestion `Continue both`; #112's heartbeat for agents an earlier session spawned (the plugin relays to the parent) and `Turn ended` for autonomous turns (PASEO-FACTS: `agent.turn_ended` fires for them).
- Rolling start after #112's merge (f9f6c61): two slots free, so #125 and #126 run as two bundles of one, not `[125+126]`.
- For the stream review: #112's criterion "each `SKILL.md` reaches the heartbeat path through one pointer" against the wave skill's six mentions of `HEARTBEAT-PATH.md`; #112's out-of-zone edits (step 2's bundles-of-one sentence, the stream index's Last tick form), named in its report.
- Open question for the orchestrator (#112, traced): on the message path a hung stream agent has no signal, since contract v1 sends `Stall suspected` for ticket agents only and no tick runs between messages.
- #126 merged with one conflict in the wave skill's step 5 message table (#125's `Human words` row and #126's `Stall suspected` row, both before `Any other lead`): both rows kept, in ticket order; merge 8dd4d86. #126's report names an out-of-zone gap for the stream review: the opening list of the wave skill's `HEARTBEAT-PATH.md` (when to read the file) lacks the `Stall suspected` case. #126 committed and then removed a stray nested repository mid-work; its three commits hold only its own files (checked with `git log --name-status`).

### Mid-wave rule changes

- 2026-09-30, orchestrator D95, corrected by D96 (the owner's standing rule): work that designs or changes the Paseo plugin's side (manifest, hooks, agent-create transforms, permissions, surfaces, RPCs, how the plugin reads the contract or the `## Delegation` table) is briefed by the stream's orchestrating agent, which loads the `/paseo-plugin` skill itself and puts the plugin design points the work needs straight into the ticket or fix agent's prompt. Ticket agents do not load `/paseo-plugin` and are not told to. Here: loaded before briefing the fix pass on #111, #112, #125, #126. The plugin repository's `AGENTS.md` says the same (plugin PR #47).

## Review

Not run per wave (the owner's rule for this stream): the whole stream diff is reviewed once, after the last ticket, on both axes, followed by one fix pass and the one eval run (below).

## Stream review

**Full test run, once, on 8dd4d86** (2026-09-30): `python -B -m unittest discover -s scripts` ran 103 tests, **1 failure**: `test_version_gate.ThisRepository.test_the_list_names_every_file_an_agent_reads_including_the_two_this_wave_added`, whose hard-coded list lacks the two new `HEARTBEAT-PATH.md` files (#112). `python -B scripts/drift-check.py`: exit 0. The version gate's own self-test passes (#126 bumped to 0.7.0).

**Stream-wide code review** (2026-09-30, `mattpocock-skills:code-review` in the orchestrator's session, two read-only sub-agents; a first pair started in the background gave no result and was re-run in the foreground), fixed point `f62d275`, head `8dd4d86` (23 files, +681/−70, `.scratch/` excluded). **Standards: 7 findings (S1, S3 hard; S2, S4–S7 judgement calls); Spec: 6 findings (P1–P6)**, plus the test failure T (= S1).

| # | Where | Finding | Axis | Outcome |
|---|---|---|---|---|
| T/S1 | `scripts/test_version_gate.py:261` | Hard-coded seat-facing list lacks the two `HEARTBEAT-PATH.md` files; the test fails | Test, Std hard | fix pass |
| S3/P1 | wave `HEARTBEAT-PATH.md:3`, wave skill :35, :305 | Opening list and "read only when" lines omit the `Stall suspected` case | Std hard, Spec | fix pass |
| S2/P2 | wave skill (7 lines), stream skill (3) | #112 "one pointer" criterion: the file is linked from many lines | Std, Spec | fix pass |
| S4 | wave skill :274 | `Stall suspected` row restates the hung-agent table's verdicts | Std | fix pass |
| S5 | `TROUBLESHOOTING.md` :31 and two more | Prose still names "step 5's heartbeat contract/tick" | Std | fix pass |
| S6 | stream `HEARTBEAT-PATH.md` §3 | "Replaced on the message path by" column restates Next-line behaviour | Std, judgement | skipped: the column is #114's criterion |
| S7 | wave skill step 4 "Labels and title" | Restates the names table's label and title shape | Std | fix pass |
| P3 | stream skill :500 | Message path lacks the stream `tool` permission case, `Appetite passed`, `Question budget spent`, an "any other lead" row | Spec | fix pass |
| P4 | ADR 0012 | Stale after #125 and #126 | Spec | fix pass |
| P5 | wave skill step 8 | Human words case column reads "plugin absent" for every heartbeat-path case | Spec | fix pass |
| P6 | stream skill restart-budget table | "three ticks" row has no ticks on the message path | Spec | fix pass |
| H | `.githooks/pre-push` | Any drift-check exit but 0 and 2 is labelled "stale references" | Spec, minor | fix pass |

Review run mark: changed the work: yes (fix pass raised).

### Fix pass

| Ticket | Agent id | Workspace id | Branch | Base commit | Private resources | Merged SHAs | Cleaned |
|---|---|---|---|---|---|---|---|
| review | 83417eb4-d309-4cee-86db-c01cc3303842 | wks_01832a03b346a376 | `plugin-v0-1-0-skills/wave1/stream-review-fixes` | `8dd4d86` | temp `%TEMP%\plugin-v0-1-0-skills-review-fixes` | review: fed538b | [x] |

Fix pass merged as 8f7f5b9 (12 commits, `fed538b`; conflict-marker search empty; worktree clean). The fix agent ran `scripts/test_version_gate.py` and `scripts/test_troubleshooting_ratings.py` once: 27 tests OK; its pins and `caught` checker: 0 missing. It also fixed `TROUBLESHOOTING.md` line 9 (S5 residue), sent back once. README's one `HEARTBEAT-PATH.md` mention names the files, left as is.

Wave 1 cleaned: 7 tickets and the fix pass merged; every row stopped, clean and merged, archived with its workspace (directories removed); temp directories removed; no heartbeat was created (this session spawned every agent); `paseo ls -g --label stream=plugin-v0-1-0-skills --label wave=1` lists nothing.

### Eval run

The stream's one eval run, on 8f7f5b9 (2026-09-30), the owner's command from `plugins/matt-with-paseo`: 34 cases loaded and run (1 run each, 701 s, $6.99, exit 1): **20 pass, 12 partial, 2 at 0.00**. Report at `plugins/matt-with-paseo/evals/results/2026-09-30T05-47-04-318Z/` (gitignored).

- New case of this stream: `wave-126-stall-suspected` 1.00.
- Partial or failing, with the stream's text they could touch: `wave-121-bundle-turn-end` 0.80 (`turn-end-merges-sha-and-answers-next` FAIL×3; wave step 5, changed by #112); `streams-40-silent-supervision` 0.80 (`writes-last-tick`; the Last tick field, #112 and P6); `streams-41-hung-agents` 0.83 (`names-kill-agent`; the restart-budget table, P6); `streams-52-answer-and-machine` 0.50 (`status-line-drops-answer`; the status line, #110); `streams-46-adopt-unstreamed-wave` 0.50 (`maps-and-waits-for-the-wave`).
- Partial or failing elsewhere: `wave-75-chosen-default-challenge` 0.00, `wave-95-user-language-one-door` 0.00, `streams-39` 0.60, `streams-47` 0.67, `streams-49` 0.78, `streams-50` 0.33, `streams-51` 0.50, `streams-61` 0.40.
- Against `ticket-sizing`'s run on 3d37060 (1 run each, noisy): passing now, partial then: `wave-54`, `wave-64`, `streams-43` (now loaded). Failing now, passing then: `wave-75`, `wave-95`, `wave-121`, `streams-39`, `streams-46`, `streams-47`, `streams-52`. Lower: `streams-50` 0.67 → 0.33. Higher: `streams-61` 0.20 → 0.40, `streams-49` 0.56 → 0.78, `streams-51` same.

**Operator's decisions (D97, 2026-09-30):** 1: no fix for the eval's partial and failing cases; all 14 go to the ship pull request's Merge Danger with the comparison below (as D90). 2: the hung-stream-agent gap on the message path (#112's open question, ADR 0012's consequence) is filed on the plugin side by the orchestrator, with plugin#45. 3: #110–#114, #125, #126 close through the ship pull request.

### Merge Danger

The stream's one eval run on 8f7f5b9 (1 run each, noisy) left 14 of 34 cases below 1.00. None was fixed (D97). Compared with `ticket-sizing`'s run on 3d37060:

| Case | Score now | Score on 3d37060 | Failing grader now | Stream text it could touch |
|---|---|---|---|---|
| `wave-121-bundle-turn-end` | 0.80 | 1.00 | `turn-end-merges-sha-and-answers-next` (FAIL×3) | wave step 5 (#112) |
| `streams-40-silent-supervision` | 0.80 | 0.80 | `writes-last-tick` | Last tick field (#112, review P6) |
| `streams-41-hung-agents` | 0.83 | 0.50 | `names-kill-agent` | restart-budget table (review P6) |
| `streams-52-answer-and-machine` | 0.50 | 1.00 | `status-line-drops-answer` | status line (#110) |
| `streams-46-adopt-unstreamed-wave` | 0.50 | 1.00 | `maps-and-waits-for-the-wave` | names table (#112) |
| `wave-75-chosen-default-challenge` | 0.00 | 1.00 | `answer-names-reason` | none named |
| `wave-95-user-language-one-door` | 0.00 | 1.00 | `two-languages` | none named |
| `streams-39-question-round` | 0.60 | 1.00 | `asks-back-unnamed-answer` | question round (#110's delegation routing) |
| `streams-47-setup-checks` | 0.67 | 1.00 | `asks-tracker-choice` | none named |
| `streams-49-ship-branch` | 0.78 | 0.56 | `honours-kept-path` | none named |
| `streams-50-after-ship` | 0.33 | 0.67 | `reasks-ship-on-new-head` | none named |
| `streams-51-overlap-and-need` | 0.50 | 0.50 | `need-yields-merge-or-hold` | overlap warning (#110) |
| `streams-61-ship-rules` | 0.40 | 0.20 | `reads-target-not-stream-branch` | none named |
| `wave-54`, `wave-64`, `streams-43` | 1.00 | partial or not loaded | none | now passing |

The 13 rows above the last are the 14 cases counted with `streams-40` and `streams-51` (same score as before) included; "Score on 3d37060" for cases passing then is 1.00 as that run's log names only its partial cases.

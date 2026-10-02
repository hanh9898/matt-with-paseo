# Common rules for wave 1 (tickets #140; then #143, #141, #145, #146, #135, #147, #138, #148, #149)

## Graph
`140 → 143    141    145    146    135    147    138    148    149`

Edges are the `Blocked by` line of each issue: #143 on #140. No other edge is declared; the shared files below are file overlaps, not dependencies. The run takes the message path (plugin `matt-with-paseo` running, contract v1), so every ticket is a bundle of one. Quota 1: #140 starts first; every other ticket joins wave 1 by rolling start, one at a time, in the approved order 140 → 143 → 141 → 145 → 146 → 135 → 147 → 138 → 148 → 149 (orchestrator D159). Out of the wave: #142 (`ready-for-human`, the owner's retro) and #144 (`needs-triage`, blocked by #140-#142), owner's decision D157.

| Ticket | Status | Blocked by | Wave |
|---|---|---|---|
| #140 The stream agent posts a Ticket handover per ticket, with the seams it chose, before spawning (P2) | open, ready-for-agent | - | 1, started first |
| #143 A symptom ticket's base reproduction goes into its Ticket handover as the loop (P4) | open, ready-for-agent | #140 | 1, rolling start after #140's merge |
| #141 A wave's exploration notes, written by a cheaper subagent and passed by path (P1) | open, ready-for-agent | - | 1, rolling start (quota) |
| #145 Ticket agents report in English even when the owner's harness language setting asks for another | open, ready-for-agent | - | 1, rolling start (quota) |
| #146 How a ticket agent works, in the common rules: Write/Edit only, grep the tests, no gh auth status, questions in text | open, ready-for-agent | - | 1, rolling start (quota) |
| #135 Create ticket and bundle agents with notifyOnFinish false while the plugin runs (F3, skills half) | open, ready-for-agent | - | 1, rolling start (quota) |
| #147 A hard ticket may run on a stronger model, named at the wave approval | open, ready-for-agent | - | 1, rolling start (quota) |
| #138 A hold on one agent cuts its running turn short with cancel_agent (S8) | open, ready-for-agent | - | 1, rolling start (quota) |
| #148 A Paseo plugin target: the stream agent loads /paseo-plugin; scratch daemons on their own home | open, ready-for-agent | - | 1, rolling start (quota) |
| #149 One local full check before stage F when the PR target runs no CI on the pull request | open, ready-for-agent | - | 1, rolling start (quota); carries the stream's one version bump |
| #142 Measure one finished wave with retro (P5) | open, ready-for-human | - | none: the owner's |
| #144 Size bundles to the ~150K smart zone (P3) | open, needs-triage | #140, #141, #142 | none: needs triage |

## Context
- Your worktree branches off `stream/skills-hand-the-design` at `690aded` (`main` after PR #134; plugin version `0.8.0`, tag `v0.8.0`), unless your prompt names another base commit (every ticket after #140 starts from the integration branch's head at its spawn). Tickets of this stream merged before yours are on that base; your prompt names them.
  Run `git branch --show-current` before every commit.
- Read before you start: your ticket and its comments (`gh issue view <n> --comments`); `docs/agents/evidence-standards.md`; `CODING_STANDARDS.md`; `AGENTS.md`; the words blocks at the top of both `SKILL.md` files; `scripts/pinned-lines.json`; the ADRs your ticket names (#138: `docs/adr/0006-*`; #135: `docs/adr/0012-*`); README "Behaviour evals" if your ticket touches an eval case.
- Line references in the tickets (`W:217`, `T:92`, `S:805`) are at `690aded`: `W` is `plugins/matt-with-paseo/skills/matt-with-paseo/SKILL.md`, `T` is `COMMON-RULES-TEMPLATE.md` beside it, `S` is `plugins/matt-with-paseo/skills/matt-with-paseo-streams/SKILL.md`. Tickets merged before yours have moved lines: find the text, not the number.
- The plugin side lives in `hanh9898/matt-with-paseo-plugin`. Contract v1 is `docs/contract.md` there; read it with `git -C D:/matt-with-paseo-streams/matt-with-paseo-plugin show origin/main:docs/contract.md` (read only: never check out, fetch, commit or edit in that checkout). The skills keep citing it by `https://github.com/hanh9898/matt-with-paseo-plugin/blob/main/docs/contract.md`.
- No other agent runs in this wave while you do (quota 1). Work only on your own ticket.
- The plugin `matt-with-paseo` runs on this machine and relays your turn ends to the orchestrator. Its git guard refuses `git push`, `git checkout` and other branch-moving git for an agent titled `[Wave N] <NN> ...`, which you are: you need none of them.
- Do not end your turn while work you started is still running in the background (a long command, a sub-agent): wait for it inside the same turn. Paseo sends no finish notification for a turn you start on your own afterwards, so your "finished" report must mean the work is done.
- Start any command that may take more than two minutes in the background from the start, and read its output when it finishes. A foreground command the shell moves to the background halfway can leave your turn waiting on a result that never returns.

## Parameters
- Ticket cap: 4, the most tickets step 2 plans into a bundle. While Jev is not available it is also the fallback stop: once a ticket agent has worked this many tickets, the orchestrator answers `stop` (step 5). Every bundle of this wave holds one ticket (message path).
- Context stop: 600K `contextWindowUsedTokens`, the size of a ticket agent's context at which the orchestrator answers `stop`, while Jev is not available (step 5).
- With Jev, its flag is what stops a bundle (step 5); the ticket cap still bounds the bundle's size.

## Existing interfaces to reuse
- The words blocks: the wave skill's block (`W`, top) and the stream skill's block (`S`, top). **Brief** names what a Checkpoint shows the user; the new word is **Ticket handover** (#140, owner D157), never "brief".
- `Requires plugin contract: 1` in the wave skill's words block stays exactly as it is (every ticket).
- `scripts/pinned-lines.json`: each row is a file, an exact phrase and a reason; the phrase must stay whole on one physical line of its file. Each ticket's "pinned line" criterion means a new row there. If you reword or move a pinned sentence, update its row in the same commit.
- `TROUBLESHOOTING.md`: every `caught` rating names a phrase that must stay in the file it names (`scripts/troubleshooting-ratings.py`).
- `scripts/seat-facing-paths.txt`: every file of a skill folder must be listed there.
- Eval cases in `plugins/matt-with-paseo/evals/`, one folder per case (`case.yaml`, `prompt.md`, `fixture.sh`, `graders/*.md`), with the observed-state block in `prompt.md` (README "Observed state in the prompt"). Cases a ticket may extend: `wave-54-repro-and-no-code-flow` (#143), `wave-95-user-language-one-door` (#145).
- Words: use every words-block term only in its defined meaning; define no term outside a words block, each term in one block only. A word added to the stream skill's block is also added to `AGENTS.md`'s "Domain docs" list.

## File zones
Tickets run one at a time, each from the head that holds every earlier ticket: you see their text. Edit only what your ticket names; where an earlier ticket of this stream changed the same paragraph, keep its sentences and add yours.

| Ticket | Owns |
|---|---|
| #140 | `W`: the words block's new **Ticket handover** entry; step 3's handover paragraph after "Chosen for you" and step 3's Done when; step 4's per-ticket prompt item (`handover: <comment URL>`); step 5's challenge check. `T`: the challenge route row ("Chosen for you", `T:76`) covering a handover. |
| #143 | `W`: one sentence in step 2's reproduction paragraph or in #140's handover paragraph (the loop); the symptom flow row or its paragraph (`W:231`, `W:245`). Step 5's checks stay as they are. `wave-54-repro-and-no-code-flow` if it covers the seam. |
| #141 | `W`: a new step between step 3 and step 4 (Exploration notes), step 4's prompt items (three becomes four, every sentence that says "exactly three things"), the frozen-file sentence, step 8's clean-up line on the notes file. `T:7`. Renumbering: insert the step without renumbering steps 4-8 if the skill's cross-references allow (for example `3b`), or name in your report every reference you renumbered. |
| #145 | `T`: one fixed English line in `## Repo and user rules`. `W`: step 4's prompt rule (`W:217`) and step 7's review and fix prompts. `wave-95-user-language-one-door` if it covers the prompt. **User's language** stays unchanged. |
| #146 | `T`: fixed lines for rules 1, 2 and 4 in `## Repo and user rules` or a new `## How you work` section; `gh auth status` in the credentials line. `W`: `gh auth status` in the credential list (`W:20`); the heartbeat-path questions-in-text rule for the stream agent and step 3's choice of line. Your lines sit apart from #145's English line. |
| #135 | `W`: step 4's `notifyOnFinish` sentence ("Leave `notifyOnFinish` at its default") and every other place that creates a ticket or bundle agent (rolling start in step 6, the recovery sweep in step 0); `TROUBLESHOOTING.md`'s replacement-agent line; `HEARTBEAT-PATH.md` only if it creates an agent. |
| #147 | `W`: step 2's hard-ticket definition and presentation sentence; step 4's `create_agent` override for a hard bundle; the `## Wave agents` header (a model column). Step 1's profile table stays as it is. |
| #138 | `S`: the commands table's `hold <agent>` and `release <agent>` rows and where the stream agent records the hold in the wave file; `W` only where the per-agent hold changes the quota rule; `docs/adr/0006-*.md` amended, or a new `docs/adr/0014-*.md` linking to it; `OWNERSHIP.md` only for a row the hold needs. |
| #148 | `W`: step 1's `paseo-plugin.json` signal and the `/paseo-plugin` load before step 2; the line telling ticket agents not to load it. `T`: the scratch-daemon section, beside `## Resources`. |
| #149 | README's "Target repo evidence standards file" section; `W`: the full-check rule before stage F (step 0 table or step 8); `S`: step 6's PR body item 5 ("Push and open"), keeping `S:805-806`; `docs/agents/evidence-standards.md`'s two declarations for this repo; the stream's one version bump (below). |

- The bump: only #149 changes `plugins/matt-with-paseo/.claude-plugin/plugin.json`, `0.8.0` → `0.9.0`, once, with README's `--pin v0.8.0` line. The version gate compares with tag `v0.8.0`. No other ticket changes a version number.
- No ticket adds an eval case: none of the criteria names a new one. #143 and #145 extend their existing case only if it covers the seam; README's eval case count line stays as it is.
- Outside your zone: name the file, the section and the change you would make in your report instead of editing it.

## Eval, test and review rules (the owner's, for this stream; `docs/agents/evidence-standards.md`)
- **Each ticket runs only its own new or changed test file, once red on the base and once green on the head**, and records both runs as `Test run:` lines in its `Resolved:` comment. For skill and ADR text the "test" is a `grep` per acceptance criterion, run on the base (`git show <base>:<path> | grep …`, seen to fail) and on your head (seen to pass). If you change a test file under `scripts/` (for example because it hard-codes a line you changed), run that one file once before and once after.
- **No ticket runs the full suite, the drift check, an eval (neither the suite nor one case) or a code review.** You do not run `python -B -m unittest discover …`, `python -B scripts/drift-check.py`, `claude plugin eval`, `/mattpocock-skills:code-review` or any review sub-agent. No bundle review runs: the evidence standards defer it to the stream's end. You may write and change tests, checks and eval cases.
- **Grep the tests for every line or call you change.** Before you reword, move or delete a sentence, a heading, a table row or a command in a skill, `OWNERSHIP.md`, README or an ADR, search `scripts/` (tests, `pinned-lines.json`, `seat-facing-paths.txt`, the ratings) and `plugins/matt-with-paseo/evals/` for it: `grep -rnF '<phrase>' scripts plugins/matt-with-paseo/evals`. Update what pins it in the same commit, or name it in your report.
- **Never hard-code a Windows path** (a drive letter, a backslash path, `%TEMP%`, a `C:/Users/...` path) in any committed file: skill, test, eval fixture, grader or ADR. Use paths relative to the repository, or derive them at run time. CI runs on Ubuntu, macOS and Windows.
- A grader you add to an existing case is designed to fail on your base commit's skill; name, for each grader, the base-skill line that makes it fail. Graders check external behaviour only, never the skill's wording.
- After the last ticket, the orchestrator runs one code review over the whole stream diff, one fix pass, then the one eval run, then targeted `--case <name> --runs 3` re-runs only. CI runs every unit test and the drift check on the ship pull request; a red pull request is never merged.

## Traps already hit
- Committing on the integration branch moves its HEAD. Commit only on your own branch; never check out or commit to `stream/skills-hand-the-design`. Check: `git branch --show-current` before each commit.
- Never edit anything under `.git/` (shared by every worktree). Do not use bare `git stash`; make a WIP commit on your branch instead.
- `git checkout -- <file>` and `git checkout <commit> --` throw away edits or detach HEAD (and the plugin's git guard refuses them). Read an old version with `git show <base>:<path>`; revert one edit with the file-editing tool. Check: `git diff <file>` and `git branch --show-current` before you commit.
- Commit in small steps; leave no work outside git. Check: `git status --porcelain` is empty before your report. Delete any `evals/results/` folder and any stray empty folder.
- If a git command hangs, stop and report; do not delete lock files.
- Write and edit files only with the Write and Edit tools, never a shell heredoc, `python -c`, `sed` or `echo >` (evidence standards, "Writing files"): the owner's shell swallows backslashes.
- Windows: `python3` is the Microsoft Store alias and fails (exit 49); use `python -B`. Python needs `PYTHONIOENCODING=utf-8` for non-ASCII output. Git Bash's `/tmp` is not the path Windows Python sees; use your temp directory.
- A `case.yaml` value holding `: ` unquoted does not parse, and the eval runner then skips the case. Check: every `description` holding `: ` is quoted; `python -B -c "import yaml,sys; yaml.safe_load(open(sys.argv[1],encoding='utf-8'))" <case.yaml>` exits 0 when PyYAML is installed.
- Moving text out of a `SKILL.md` removed `caught` phrases in an earlier stream and broke the ratings test. Check: for each `caught` rating in `TROUBLESHOOTING.md` naming a file you touched, `grep -cF '<phrase>' <file>` prints at least 1.
- Rewording a pinned sentence without its row breaks the drift check. Check: for every row of `scripts/pinned-lines.json` whose file you touched, `grep -cF '<phrase>' <file>` prints at least 1.
- A new file in a skill folder missing from `scripts/seat-facing-paths.txt` fails the version gate. Check: `git diff --name-only --diff-filter=A <base> -- plugins/matt-with-paseo/skills` lists only paths that `grep -xF` finds in that file.
- A test file with a hard-coded list (such as `scripts/test_version_gate.py`'s seat-facing list) failed an earlier stream's run when a ticket added a file. Check: the grep of the tests above.
- Agents stopped on a session limit mid-work in earlier waves. Your commits are your progress: commit before long steps, so a resume can pick up from `git log`.
- `gh` has failed with `x509: certificate signed by unknown authority` (network SSL inspection). Not yours to fix: write the text you would post into your temp directory, say so in your report, and carry on with local work.
- Ticket agents of stream `plugin-setup` wrote their reports in Vietnamese (D153): the owner's harness setting asks for Vietnamese. This wave's rules override it: see "Repo and user rules".
- Put temporary files only in your temp directory, never loose in `%TEMP%`. Before reporting, list your temp directory and quote the result.

## Failing on base
- On `690aded`, before the first spawn, run by the orchestrator (2026-10-02): `python -B -m unittest discover -s scripts` ran 103 tests, OK; `python -B scripts/drift-check.py` exit 0. None: every command passes. (You do not run either; see the eval, test and review rules.)
- The version gate's self-test `test_this_repository_passes_its_own_gate` fails from this stream's first change to a seat-facing file until #149 bumps the version. It is not yours.
- A failure listed here is not yours: leave it as it is unless your ticket's acceptance criteria name it, and name it in your report as failing on base. A failure not listed here is yours to explain.

## Acceptance criteria are the contract
- A trap above, or an instruction an earlier ticket left in its comments, is guidance; your ticket's acceptance criteria are the contract.
- On conflict, follow the criteria and write the discrepancy and its reason in a comment on your issue; do not stop to ask.
- If the criteria themselves look wrong, stop that part, write the evidence in a comment on your issue, and add the `ready-for-human` label. Never rewrite the criteria.

## What must hold, what was chosen, what is not known yet

| Part | What it holds | What you do when your evidence goes against it |
|---|---|---|
| Must hold | Your ticket's acceptance criteria, and the section above. The owner's decisions D155 and D157: every standing rule moves into the product (the skills, the template, the README), nowhere else; the new term is **Ticket handover**, and **Brief** keeps naming what a Checkpoint shows the user. | Follow the section above; never rewrite the criteria. |
| Chosen for you | The one version bump, `0.8.0` → `0.9.0`, is #149's: the owner's rule puts it in the last ticket, and #149 is last in the approved order; a minor bump because the stream adds behaviour. | Challenge it with evidence, in your ticket's comments and your report. A challenge alone does not move the ticket to `ready-for-human`. |
| Chosen for you | Ticket agents do not load `/paseo-plugin` and design nothing on the plugin's side; the plugin's behaviour is read from contract v1 and the plugin's issues (owner D96). #148 writes that rule into the skill. | As above. |
| Chosen for you | A new ADR, when a ticket needs one (#138), takes the next free number, `0014`. | As above. |
| Not known yet | Whether a fixed English line beats the harness's language section (#145). | Write the line; the orchestrator records the outcome on #145 from the next wave's reports. |

Whoever answers a challenge to a chosen default writes why the plan changes or stands; an answer with no reason is not a resolution.

## Resources
- Your private resources are listed in your prompt (a temp directory only). Use exactly that set. Create it when you first need it and leave it in place when you finish; the orchestrator removes it after your merge.
- Shared, read-only: the main checkout `D:\matt-with-paseo-streams\matt-with-paseo` (do not write there); the plugin checkout `D:\matt-with-paseo-streams\matt-with-paseo-plugin` (read `origin/main` with `git show`; no checkout, fetch, commit or edit); the installed Matt plugins under `~/.claude/plugins/cache/`; the GitHub repository `hanh9898/matt-with-paseo-plugin` (read only).
- Machine-wide: the Paseo daemon, this machine and one usage limit are shared by every agent. Create no Paseo workspace, agent, heartbeat or schedule; start no Paseo daemon. Do not set `core.hooksPath` or any git config in a shared checkout.

## Repo and user rules
- Write your reports, ticket comments and commit messages in English, even when your own settings or a global `CLAUDE.md` ask for another language; this wave's rules override that preference. Skills, ADRs and README are English too. `CODING_STANDARDS.md` is the standard for every document an agent reads: numbered steps, a **Done when** per step that matches its body, choices as table rows, one concept one word, one source of truth, one clause per sentence.
- Commit format: the repo's style, `<type>(<scope>): <summary> (#NN)`, types and scopes as in `feat(streams): …`, `feat(wave): …`, `test(evals): …`, `docs(adr): …`, `docs(readme): …`, `chore(release): …`. End every commit message with `Co-Authored-By: Claude Sonnet 5.5 <noreply@anthropic.com>`.
- Do not push, do not tag, do not open a PR, do not close your issue.
- No `AskUserQuestion`: when you need a decision, end your turn with the question in text, with your recommendation.
- Credentials: never read, print or pass on a token or credential (no `gh auth token`, no `gh auth status`, no reading a CLI's hosts or config file or a token's environment variable, no token in a URL or a command). A `gh`, push or upload failure goes into your report with the command and its error as printed; never work around it with another tool, the forge's API or another account.
- Evidence standards: read `docs/agents/evidence-standards.md`; it is not copied here. No code review runs inside this wave (see the eval, test and review rules above).

## Done when:
- Commit to your branch. The orchestrator merges it. Keep no pull-request text in your worktree; put what the ship needs in your report.
- No code review runs, and no bundle review either (the evidence standards defer it to the stream's end).
- Mark the ticket done with a comment on its own issue starting `Resolved:` (leave the issue open; the orchestrator closes it after the merge), or add `ready-for-human` for the part a human must do. In it, write what you changed, each acceptance criterion with its `Test run:` line (the check, red on the base, green on the head, with output), what remains open, and which eval cases and tests you wrote, written, not run.
- Report back with the SHA of your last commit: a design summary, files touched, how you verified with evidence, work not done or still in doubt (every out-of-zone change you would make), every change outside git, each private resource you created, and decisions the user must make. Tag each decision `decided: X because Y` or `assumed: X, unchecked`, and each finding `reproduced` or `traced`.
- Clean up your temp directory (state the reason for anything you keep) and check `git status --porcelain` is empty. Then end your turn: a bundle of one ends its turn once.

## Checkpoints
- Step 0, stage C with `stream`, ten tickets, next step 1 (asked 2026-10-02, answered by the orchestrator D159): changed the work: no; took the recommendation: yes.
- Step 2, wave 1 as bundles of one on the message path, quota 1, order 140 → 143 → 141 → 145 → 146 → 135 → 147 → 138 → 148 → 149 (approved by the orchestrator D159; it removed `stream:plugin-v0-2-0-skills` from #135 and #138): changed the work: yes; took the recommendation: yes.

## Wave agents

| Bundle's tickets | Agent id | Workspace id | Branch | Base commit | Private resources | Merged SHAs | Cleaned |
|---|---|---|---|---|---|---|---|
| 140 | 9356e5ce-b3cc-4220-aac6-b1fa80bbb619 | wks_6511b1b607afe0d5 | `skills-hand-the-design/wave1/140-ticket-handover` | `690aded` | temp `%TEMP%\skills-hand-the-design-140` | 140: 25c0d7f | [x] |
| 143 | a2b9cdce-171c-4807-af75-3f3267260e84 | wks_c80d2f5c84297540 | `skills-hand-the-design/wave1/143-repro-loop-in-handover` | `f9ec971` | temp `%TEMP%\skills-hand-the-design-143` | 143: 56fcee8 | [x] |
| 141 | 92960461-c9db-4ef6-a2d8-5c359632e884 | wks_4e334b5ba9f1a33d | `skills-hand-the-design/wave1/141-exploration-notes` | `b915090` | temp `%TEMP%\skills-hand-the-design-141` | 141: 1b30b6c | [x] |
| 145 | 1be7d28f-8ffb-4325-a05c-df2ff30436fc | wks_ecbe4c945f748285 | `skills-hand-the-design/wave1/145-english-reports` | `29f3c9b` | temp `%TEMP%\skills-hand-the-design-145` | 145: e6bb561 | [x] |
| 146 | 16ea31c3-ab24-4db8-b2a3-aa8d28c20ed2 | wks_a394f6ddc2a4b69b | `skills-hand-the-design/wave1/146-how-a-ticket-agent-works` | `74c2796` | temp `%TEMP%\skills-hand-the-design-146` | 146: 2d6d6d8 | [x] |
| 135 | 4b273c2d-1d2e-464b-a05d-9e81a9fd3df8 | wks_d64a22f511862f38 | `skills-hand-the-design/wave1/135-notify-on-finish-false` | `abeb28a` | temp `%TEMP%\skills-hand-the-design-135` | 135: 924d947 | [x] |
| 147 | a1e04e2e-0cf0-4f16-9b75-0cc69a1828ce | wks_d631bb4c68238d02 | `skills-hand-the-design/wave1/147-hard-ticket-model` | `1e966e2` | temp `%TEMP%\skills-hand-the-design-147` | 147: a5ea921 | [x] |
| 138 | cbbe1a61-d688-4d6b-a5aa-ffd40dd42c29 | wks_4b5a78c2eeb3185a | `skills-hand-the-design/wave1/138-hold-one-agent` | `3af10a3` | temp `%TEMP%\skills-hand-the-design-138` | 138: 2933c20 | [x] |
| 148 | 928fcd84-8b99-443e-9874-ed8549d61ff1 | wks_214af9c17766be78 | `skills-hand-the-design/wave1/148-paseo-plugin-target` | `e5e5eff` | temp `%TEMP%\skills-hand-the-design-148` | 148: c5a900a | [x] |
| 149 | 0eaf5855-b25d-4435-8a27-56a3a854cc76 | wks_3f779de769e42474 | `skills-hand-the-design/wave1/149-local-full-check` | `ca260c7` | temp `%TEMP%\skills-hand-the-design-149` | 149: a5538d0 | [x] |

## Wave log
- #141's agent stayed idle with no session after `create_agent`; a second identical prompt timed out at run start, then the agent ran once (slow start, no duplicate turn).
- #148 sent back once (step 8 still said "seven things"); fix `c5a900a` merged with the ticket.
- Report language (#145's open point): final turn reports in English 6 of 10 (#141, #145, #147, #138, #148, #149 English; #140, #143, #146, #135 Vietnamese); commits and ticket comments English in all 10. Recorded on #145.
- Every turn end reached the orchestrator twice (finish notification and `Turn ended`), the F3 episode #135 fixes from the next wave.
- 2026-10-02: the first review run's two sub-agents failed on `oauth_org_not_allowed` (HTTP 403); access restored by the owner (orchestrator D163), the review re-run.

## Review

This is the stream's last wave, so the per-wave seam review and the stream review are one run (`docs/agents/evidence-standards.md`, "Once per stream"). `mattpocock-skills:code-review` in the orchestrator's session (no profile's notes say review), two read-only sub-agents, fixed point `690aded`, head `44a1e66`, `.scratch/` excluded (13 files, +152/−34). **Standards: 15 findings (S1–S10 hard, S11–S15 judgement); Spec: 10 findings (P1–P10).** W is the wave `SKILL.md`, T the template.

| # | Where | Finding | Axis | Outcome |
|---|---|---|---|---|
| S1/P8 | T `## How you work` | Rules numbered 1, 2, 4, 4; the instruction line "Copy these lines as written…" sits inside the copied frame | Std hard, Spec | fix pass: number 1-3, move the instruction to W step 3 |
| S2/P2 | W step 5 item 4 | `send_agent_prompt` `next`/`stop` sets `notifyOnFinish` on both paths, against step 4's rule (#135) | Std hard, Spec | fix pass: step 4's rule by path |
| S3/P4 | T line 5, W "Prompts under `stream`", step 0 sweep, step 3 frozen sentence, step 8 | `## Held agents` is a log section no list names; the recovery sweep never reads it; a cancelled held agent could be read as stopped (#138) | Std hard, Spec | fix pass |
| S4/P3 | README "With `stream`" | "three prompts", no per-agent rows (#138) | Std hard, Spec | fix pass |
| P1 | T `## Repo and user rules` | #145's "The repo's own commit-language rule, where one exists, still governs commits" dropped | Spec | fix pass |
| P5 | W stage F paragraph, README | #149: only one of the two declarations present is not covered | Spec | fix pass: full check only → runs; branch list only → names the missing full check, runs nothing |
| P6 | W step 6 rolling start, step 0 "No agent" | A ticket spawned after step 3 gets no Ticket handover, but step 4's prompt needs its URL (#140) | Spec | fix pass: write and post it before that spawn |
| P7 | W step 2 hard-ticket test | Reads the handover's seams at step 2, before step 3 writes any handover (#147) | Spec | fix pass, chosen by the orchestrator: step 2 judges from the ticket's text; the handover never re-marks a bundle after the approval |
| P9 | W step 3 / 3b order | Handovers are posted in step 3, the notes written in 3b, so a handover cannot cite the notes (#141) | Spec | fix pass: handovers written and posted after 3b's notes, before step 4 |
| S6 | W Done when of steps 2, 3b, 4 | Not covering the hard-bundle mark, the notes path, the model column | Std hard | fix pass |
| S7 | W step 4 prompt sentence | Doubled "and" | Std hard | fix pass: grammar only; the four items stay one sentence (a pinned line) |
| S9 | T scratch daemon section | "(step 8)" names a step the ticket agent never reads | Std hard | fix pass: say the orchestrator removes them; `blocked: provider login` stays (#148's wording) |
| S10 | T line 7 | Pointer sentence contradicts the one before | Std hard | fix pass: reword as the exception it is |
| S5 | Five wave eval fixtures | `## Wave agents` tables without `model` | Std hard | skipped: each fixture shows a file an earlier run wrote; no grader reads the column, and a column change risks graders failing for a reason other than behaviour |
| S8, S12 | Credentials, English and `notifyOnFinish` rules stated in several places | Duplicated Code | Std | skipped: #135, #145 and #146 each require their copy as its own pinned line |
| S11 | "hard", "exploration notes", "full check", "Held agents" | Not words-block terms | Std judgement | skipped: each is defined where used and used in one skill; #147's agent kept "hard" out of the words block on purpose |
| S13, S14, S15 | Step 3's size; README restating the full check; the notes table | Divergent Change, Feature Envy, Speculative Generality | Std judgement | skipped: each is a ticket's asked shape (#149 asks for the README; #141 for the four parts) |
| P10 | `OWNERSHIP.md` row, ADR 0014 options | Not asked | Spec, scope | no change: small and consistent with #138's ADR ask |

Review run mark: changed the work: yes (fix pass raised).

### Fix pass

| Ticket | Agent id | Workspace id | Branch | Base commit | Private resources | Merged SHAs | Cleaned |
|---|---|---|---|---|---|---|---|
| review | 599d6eb6-c10f-4209-8dac-0fd7704dd223 | wks_f02476e6a966e101 | `skills-hand-the-design/wave1/stream-review-fixes` | `44a1e66` | temp `%TEMP%\skills-hand-the-design-review-fixes` | review: 3bcf2fb | [x] |

Fix pass merged as 555b680 (4 commits: 6da62bf, 3871271, 771ed64, 3bcf2fb; conflict-marker search empty; worktree clean). Every "fix pass" row done, each with a grep red on 44a1e66 and green on 3bcf2fb (agent's report). Orchestrator re-check: all 65 rows of `scripts/pinned-lines.json` found whole on one line at 3bcf2fb; no CR and no backslash in the diff. The fix agent wrote one edit of `SKILL.md` (S3) with a Python script against the Write/Edit rule; the diff holds only the intended lines. `## How you work` now numbers rules 1-3 (#146's "rule 4" is rule 3; the content is unchanged).

Wave 1 cleaned: 10 tickets and the fix pass merged; every row stopped, clean and merged, archived with its workspace (10 directories removed; #141's `removedDirectory: false` left an empty directory a process still holds, no longer a git worktree, `rmdir` refused with "Device or resource busy"); temp directories removed (no `review-fixes` one was created); no heartbeat was created (this session spawned every agent). `paseo ls -g --label stream=skills-hand-the-design --label wave=1` lists nothing.

### Eval run

The stream's one eval run, on 555b680 (2026-10-02), the owner's command from `plugins/matt-with-paseo`: 35 cases (1 run each, 695 s, $7.80, exit 0): **22 at 1.00, 12 partial, 1 at 0.00**. Report at `plugins/matt-with-paseo/evals/results/2026-10-02T10-05-52-040Z/` (gitignored). Baseline: the previous stream's run on 2819f44.

| Case | Score now | Score on 2819f44 | Failing grader now | Verdict changed |
|---|---|---|---|---|
| `streams-131-autonomy-levels` | 1.00 | 0.75 | none | yes, partial → pass |
| `streams-43-quota-follows-wave` | 0.33 | 1.00 | `quota-change-sends-prompt`, `quota-counts-bundles-not-tickets` | yes, pass → partial |
| `wave-tickets-with-width` | 0.67 | 1.00 | `asks-model-and-mode` | yes, pass → partial |
| `wave-95-user-language-one-door` (grader extended by #145) | 0.00 | 0.00 | `two-languages` | no |
| `streams-40-silent-supervision` | 0.60 | 0.60 | `nudges-idle-stream-agent`, `writes-last-tick` | no |
| `streams-41-hung-agents` | 0.50 | 0.50 | | no |
| `streams-49-ship-branch` | 0.78 | 0.56 | `pushes-only-ship-branch` | no (partial) |
| `streams-51-overlap-and-need` | 0.50 | 0.50 | | no |
| `streams-52-answer-and-machine` | 0.00 | 0.50 | | no (fail) |
| `streams-61-ship-rules` | 0.60 | 0.20 | | no (partial) |
| `wave-121-bundle-turn-end` | 0.80 | 0.80 | | no |
| `wave-53-review-merge-and-decision` | 0.50 | 0.50 | | no |
| `wave-54-repro-and-no-code-flow` | 0.86 | 0.57 | | no (partial) |
| `wave-75-chosen-default-challenge` | 0.67 | 0.00 | `answer-names-reason` | no (fail) |

Targeted re-runs (`--case <name> --runs 3`, 555b680): the case this stream changed and the three whose verdict changed.

| Case | Score | Pass | Failing run |
|---|---|---|---|
| `wave-95-user-language-one-door` | 0.67 | 2 of 3 | run 2: `two-languages` |
| `streams-43-quota-follows-wave` | 0.67 | 2 of 3 | run 1 failed every grader (0.00) |
| `wave-tickets-with-width` | 0.89 | 2 of 3 | run 3: `asks-model-and-mode` |
| `streams-131-autonomy-levels` | 0.67 | 2 of 3 | run 3 failed every grader (0.00) |

`wave-95` passes 2 of 3 runs after two streams at 0.00, with #145's prompt rule. `streams-43` touches nothing this stream changed (the stream skill's quota prompts); `wave-tickets-with-width` grades step 1's model question, whose table #148 left unchanged. Both pass 2 of 3, so the single-run drop reads as noise. Cases below 1.00 go to the ship pull request's Merge Danger with this comparison.

### Full check before stage F (#149)

Under `stream`, the PR target is `main`, and `docs/agents/evidence-standards.md` "Declarations for the wave skill" names `main` among the branches whose pull requests run CI: nothing runs locally (CI is the full run).

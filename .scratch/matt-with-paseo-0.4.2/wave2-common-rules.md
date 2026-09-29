# Common rules for wave 2 (tickets #42, #49, #47, #41, #48, #53, #54; then #39, #40, #46, #51, #52)

## Graph
`38✓ 60✓ 56✓ → {42, 49, 47, 41, 48, 53, 54 | quota: 39, 40, 46, 51, 52}; 42 → {43, 44}; {42, 43} → 45; 49 → 50; {41, 48} → 55; {60✓, 47} → 61 → {62, 64} (also on 49); 62 → 63; {63, 64} → 65; {39…56} → 58; 66 in triage`

| Ticket | Status | Blocked by | Wave |
|---|---|---|---|
| #38, #60, #56 | closed, merged | - | 1 |
| #42, #49, #47, #41, #48, #53, #54 | open, ready-for-agent | #38✓ | 2, started first |
| #39, #40, #46, #51, #52 | open, ready-for-agent | #38✓ | 2, waiting on the quota (rolling start) |
| #43, #44 | open | #42 | 3: these rules give them no zone |
| #45 | open | #42, #43 | 3 or later |
| #50 | open | #49 | 3 |
| #55 | open | #41, #48 | 3 |
| #61 (now also writes ADR 0008) | open | #60✓, #47 | 3 |
| #62, #64 | open | #61, #49 | after #61 |
| #63 | open | #62 | after #62 |
| #65 | open | #63, #64 | after #63, #64 |
| #58 Release 0.4.2 | open | #39–#56 | last |
| #66 | needs-triage | - | none |

Tickets a wave-2 merge unblocks (#43, #44, #50, #55, #61) do **not** join this wave by rolling start: they have no zone below. They open wave 3.

## Context
- Your worktree branches off `stream/matt-with-paseo-0-4-2` at `1f26e42`, unless your prompt names another base commit (a ticket started by rolling start). That branch already contains #38 (ADRs 0005–0007, the terms **Hold**, **Intake agent**, **Pause**, the stream skill's entry guards, the observed-state eval pattern), #60 (`CODING_STANDARDS.md`, **Checkpoint**, **Brief**, the drift check's wider scope) and #56 (bug-report drafts).
  Run `git branch --show-current` before every commit.
- Read before you start: your ticket and its spec (#37), including its Implementation Decisions and the user stories your ticket names; `CODING_STANDARDS.md` (your change is reviewed against it); ADRs 0001–0007 in `docs/adr/`; the words blocks at the top of both `SKILL.md` files; README "Behaviour evals" (the "Observed state in the prompt" paragraph); the comments on #38 (its out-of-zone follow-ups) and the `## Review` section of `.scratch/matt-with-paseo-0.4.2/wave1-common-rules.md`.
- Up to 6 other agents work the remaining tickets of this wave in parallel, on other branches, many in the same two `SKILL.md` files. Work only on your own ticket and inside your zone below.
- Do not end your turn while work you started is still running in the background (a build, a test run, an eval run, a long command, the review sub-agents `mattpocock-skills:code-review` launches): wait for it inside the same turn. Paseo sends no finish notification for a turn you start on your own afterwards, so your "finished" report must mean the work is done.

## Existing interfaces to reuse
- `python -B scripts/drift-check.py`: every `mattpocock-skills:<name>` reference against the installed Matt plugin, plus any `loop-me` mention, across both skills, both READMEs, `CODING_STANDARDS.md`, `AGENTS.md`/`CLAUDE.md`, `docs/agents/` and the eval cases. Exit 0 clean, 1 drift, 2 usage. Tests: `python -B -m unittest discover -s scripts`.
- The eval suite in `plugins/matt-with-paseo/evals/`, one folder per case (`case.yaml`, `prompt.md`, `fixture.sh`, `graders/*.md`). Copy the shape of a close existing case: `streams-no-index` / `streams-free-text-argument` for the stream skill, `wave-tickets-with-width` for the wave skill.
- A stream-skill case must carry an **observed-state block** stating what Paseo would report (agents, statuses, activity, pending questions, the operator's last answer), or entry guard 2 stops it: see `streams-no-index`'s `case.yaml` (`append_system_prompt`) and README "Observed state in the prompt".
- Words: use **Hold**, **Pause**, **Intake agent**, **Checkpoint**, **Brief**, **Stream** only in their defined meaning (words blocks). Define no new term outside a words block, and each term in one block only.

## File zones
Zones are by section. "Wave skill" is `plugins/matt-with-paseo/skills/matt-with-paseo/SKILL.md`, "stream skill" is `plugins/matt-with-paseo/skills/matt-with-paseo-streams/SKILL.md`, "template" is `COMMON-RULES-TEMPLATE.md` and "troubleshooting" is `TROUBLESHOOTING.md` beside the wave skill.

| Ticket | Owns |
|---|---|
| #42 hold, release, quota; one-ticket wave; no ship | Wave skill: the **Input** paragraph at the top, step 0's stage C row, step 4's **Quota** paragraph, step 6's **Rolling start** paragraph, and one new paragraph or section for the `hold`/`release`/`quota <N>` prompts and the no-ship rule. README "The two wave-skill arguments". |
| #49 ship branch | Stream skill step 6 except "The forge" paragraph and its table; the status line rows written by step 6. |
| #47 setup checks | Stream skill step 1; step 6's "The forge" paragraph and its table (the forge now comes from the index); the index's fields table and example (the new Forge column); the "With no index yet" paragraph (ask for repository paths). README "The control folder and its index". |
| #41 hung agents | Stream skill step 5 "Supervise one-for-one" (its table, restart, restart budget) and "Replace a stream agent" steps 1–2 and step 3's bullets, but not step 3's label word **Hold** (reserved for #43, wave 3). Wave skill step 5's **Heartbeat contract** paragraph. Template "Context" (the background-command rule). |
| #48 project id; ask for a missing profile | Wave skill step 1 (the profile) and step 4's numbered items 1 and 2 (`create_workspace`, `create_agent`). Stream skill step 2 and step 3. |
| #53 merges and reviews | Wave skill: step 0's paragraphs below the stage table ("Ticket status is the primary signal…" and the recovery sweep), step 6's first paragraph and its "Conflict…" line, step 7, step 8. Template: a new "Failing on base" section. Troubleshooting "Merging". |
| #54 ticket work | Wave skill: step 2's reproduction paragraph and lost-width list, step 4's flow table and the paragraphs around it (private resources, `paseo.json`, the flow's end), step 5's bullet list of checks. Template "Resources" and "Done when". |
| #39 operator's gates (quota) | Stream skill step 4 ("A question round", routing, relays; not "At a wave boundary"). Wave skill step 0's last paragraph ("Present three things…", the approval covers only the move to step 1). |
| #40 supervision (quota) | Stream skill step 5 except "Supervise one-for-one": the tick table, the heartbeat table, the recovery paragraph. One new line in "The index" for the last tick's time. |
| #46 adopt a wave run (quota) | Stream skill step 0, except its sentence on how work enters a stream (intake, reserved for #45). |
| #51 overlap (quota) | Stream skill step 7, including renaming its "pause one" and `paused, overlaps …` to a word other than **Pause** (wave 1 review), and the status line row "Paused over an overlap". |
| #52 index, decisions, machine, credentials (quota) | Stream skill: "The status line" intro paragraph; one new section right after "Inputs: public signals only" for the decisions file, Claude memory, machine actions and credentials. Wave skill: one new paragraph right after the **Precondition** paragraph (credential rule). Template "Repo and user rules" (credential rule). |

- New eval cases: a new folder named `<streams|wave>-<ticket number>-<what it checks>` (for example `streams-49-ship-left-out-paths`), never an edit to another case. Do not change README's case count or baseline range in "Behaviour evals"; #58 updates them.
- Shared tables (the status line table, the index's fields table): add only your own rows or column, as whole lines, and keep the order of the existing lines. The orchestrator resolves the merges.
- Outside your zone: name the file, the section and the change you would make in your report instead of editing it.

## Traps already hit
- Committing on the integration branch moves its HEAD. Commit only on your own branch; never check out or commit to `stream/matt-with-paseo-0-4-2`. Check: `git branch --show-current` before each commit.
- Never edit anything under `.git/` (it is shared by every worktree).
- Do not use bare `git stash`; commit a WIP commit on your branch instead.
- `git checkout -- <file>` throws away every uncommitted edit in that file, not only the one you meant to revert (wave 1, #38). Revert one edit with the file-editing tool. Check: `git diff <file>` shows what you expect before you commit.
- Commit in small steps; do not leave work outside git. Check: `git status --porcelain` is empty before your report.
- If a git command hangs, stop and report; do not delete lock files.
- A worktree directory is named by a slug, not by its branch: use `git branch --show-current`.
- Windows: `python3` is the Microsoft Store alias and fails (exit 49); run `python -B`. A lone single quote inside a Bash heredoc breaks parsing; write file content with the file-writing tool. Python needs `PYTHONIOENCODING=utf-8` for Vietnamese output. Git Bash's `/tmp` is not the path Windows Python sees; use `cygpath -w` or a path under your temp directory.
- The reference Matt plugin is the user-scope install from the upstream `mattpocock` marketplace, which ships `pr`, `implement-spec` and `retro` (operator decision, #66). Keep those references. Check: `python -B scripts/drift-check.py` exits 0 with no `--plugin-root`.
- `claude plugin eval` keeps only the last `--case` flag: pass one glob (for example `--case "streams-49-*"`). Seven agents share this machine and one usage limit: run your own cases with `-j 2`, and the existing cases of the skill you changed (`--case "streams-*"` or `--case "wave-*"`) once, before your last commit. The eval run is long: start it in the background and wait inside the turn.
- A grader that cannot fail in either arm proves nothing (wave 1, #38: a "no file written" grader in a read-only case). Each new case needs a grader that fails on the base commit's skill: run it red on `1f26e42`'s skill first and quote the score.
- Before reporting, list your temp directory and quote the result (a report once said it was removed while it still existed).

## Acceptance criteria are the contract
- A trap above, or an instruction an earlier ticket left in its comments, is guidance; your ticket's acceptance criteria are the contract.
- On conflict, follow the criteria and write the discrepancy and its reason in a comment on your issue; do not stop to ask.
- If the criteria themselves look wrong, stop that part, write the evidence in a comment on your issue, and add the `ready-for-human` label. Never rewrite the criteria.

## Resources
- Your private resources are listed in your prompt (a temp directory only; this repo has no database, port or volume). Use exactly that set.
- Shared resources, read-only: the run evidence in `D:\stream\` and `D:\matt-with-paseo-streams\` (it names internal hosts, projects and people: nothing from it reaches the repo in a form that names them); the installed Matt plugins under `~/.claude/plugins/cache/`; Paseo's `~/.paseo/config.json` (read keys only). Never write there.
- Machine-wide: the Paseo daemon and this machine's CPU are shared by every agent. Create no Paseo workspace or agent; eval runs as above.

## Repo and user rules
- Skills, ADRs, README and all GitHub text (issue comments, commit messages) in **English**. Commit messages follow the repo's style (`feat(streams): …`, `feat(wave): …`, `test(evals): …`, `docs(readme): …`, see `git log`), and name your ticket (`(#NN)`). End every commit message with `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`.
- `CODING_STANDARDS.md` is the standard for every document an agent reads; match the surrounding style of each file (numbered steps, a **Done when** line per step, choices as table rows).
- Accepted way to verify: turn each acceptance criterion into a check you can run (an eval case, the drift check, the unit tests, a `grep` that must or must not match, reading a section) and record the command and its output, red on `1f26e42` before your change where the criterion is new.
- Do not push, do not tag, do not open a PR, do not close your issue.
- Credentials: never read, print or pass on a token or credential; a `gh` failure goes into your report, never worked around.
- Evidence standards: read `none declared`; it is not copied here.

## Done when:
- Commit to your branch. The orchestrator merges.
- Before the last commit: run `/mattpocock-skills:code-review` with your base commit as the fixed point, fix the findings, and write the number of findings per axis and the outcome of each into a comment on your issue.
- Mark the ticket done with a comment starting `Resolved:` (leave the issue open; the orchestrator closes it after the merge), or add `ready-for-human` for the part a human must do. Write in the comments what you verified, with evidence, and what remains open.
- Clean up your temp directory; state the reason for anything you keep.
- Report back: a design summary, files touched, how you verified with evidence, work not done or still in doubt (including every out-of-zone change you would make), and decisions the user must make.

## Wave agents

| Ticket | Agent id | Workspace id | Branch | Base commit | Private resources | Cleaned |
|---|---|---|---|---|---|---|
| #42 | 81eb7c6d-a455-438f-b177-15f1491af92e | wks_b7baf5b9765b399a | `matt-with-paseo-0-4-2/wave2/42-hold-release-quota` | `1f26e42` | temp `%TEMP%\matt-with-paseo-0-4-2-wave2-42` | [x] |
| #49 | 00609ba9-6226-497c-b459-8f71402e55e3 | wks_c28ea5ff9112e9c4 | `matt-with-paseo-0-4-2/wave2/49-ship-branch` | `1f26e42` | temp `%TEMP%\matt-with-paseo-0-4-2-wave2-49` | [x] |
| #47 | 9aefb71c-53f7-4346-ac68-d8424dfe7e5e | wks_7ec51b5c1a972ac3 | `matt-with-paseo-0-4-2/wave2/47-setup-checks` | `1f26e42` | temp `%TEMP%\matt-with-paseo-0-4-2-wave2-47` | [x] |
| #41 | 28f12286-31ca-4eac-95c4-f6c00fabeb84 | wks_64dc1e104381fbf7 | `matt-with-paseo-0-4-2/wave2/41-hung-agents` | `1f26e42` | temp `%TEMP%\matt-with-paseo-0-4-2-wave2-41` | [x] |
| #48 | ab17f0f6-a444-4473-a484-1e8ecb36fdc0 | wks_c624b847cba8d5ff | `matt-with-paseo-0-4-2/wave2/48-project-id-profile` | `1f26e42` | temp `%TEMP%\matt-with-paseo-0-4-2-wave2-48` | [x] |
| #53 | 42fffdee-c08d-4bb5-b02a-c990e3b1170b | wks_1c5a709ee0398966 | `matt-with-paseo-0-4-2/wave2/53-merges-reviews` | `1f26e42` | temp `%TEMP%\matt-with-paseo-0-4-2-wave2-53` | [x] |
| #54 | b5aca22c-4418-44a9-9621-ce977790ff15 | wks_f5e92a5de1919c85 | `matt-with-paseo-0-4-2/wave2/54-ticket-work` | `1f26e42` | temp `%TEMP%\matt-with-paseo-0-4-2-wave2-54` | [x] |
| #39 | 784cfd8a-3a99-4935-83d3-62e1cfb5fad4 | wks_8a85e59f49697086 | `matt-with-paseo-0-4-2/wave2/39-operator-gates` | `1acabd8` (rolling start) | temp `%TEMP%\matt-with-paseo-0-4-2-wave2-39` | [x] |
| #40 | 42aadaf6-da46-4dae-be0a-7aecf9ae4088 | wks_5488c08f1ee28233 | `matt-with-paseo-0-4-2/wave2/40-supervision-silence` | `1acabd8` (rolling start) | temp `%TEMP%\matt-with-paseo-0-4-2-wave2-40` | [x] |
| #46 | c8c7b2c5-ef75-46b2-b13e-4d1bd050ca5a | wks_aaffb9a4fe013ae2 | `matt-with-paseo-0-4-2/wave2/46-adopt-wave-run` | `1acabd8` (rolling start) | temp `%TEMP%\matt-with-paseo-0-4-2-wave2-46` | [x] |
| #51 | 18b12e8d-9d3d-47aa-be05-421d1ce7b724 | wks_d6b0767c4545d918 | `matt-with-paseo-0-4-2/wave2/51-overlap-warnings` | `1acabd8` (rolling start) | temp `%TEMP%\matt-with-paseo-0-4-2-wave2-51` | [x] |
| #52 | f5b53e1e-a007-46b1-a6ac-c3b89ec31399 | wks_2d9a44d04d8a4fac | `matt-with-paseo-0-4-2/wave2/52-index-decisions-credentials` | `1acabd8` (rolling start) | temp `%TEMP%\matt-with-paseo-0-4-2-wave2-52` | [x] |
| review | d4b40845-b1b2-4d18-bbd6-b5d8411d5803 | wks_6f5c1b0d2fdd6c1d | `matt-with-paseo-0-4-2/wave2/review-fixes` | `788e422` | temp `%TEMP%\matt-with-paseo-0-4-2-wave2-fixes` | [x] |

2026-09-29 06:15: all seven agents had stopped on the session limit (resets 04:30 and 06:10), each with 2–4 commits and none reported; #49 also had 2 uncommitted files. Nothing was recorded as failed. Each got a resume prompt at 06:15 and still counts against the quota.

### Rule change 2026-09-29 (user's instruction, overrides the rules above)

**No ticket agent runs `claude plugin eval`**, neither the full suite nor a single case. It overrides every eval run the rules above ask for: the Existing interfaces entry, the `claude plugin eval` trap (`-j 2`, the skill's existing cases before the last commit), the grader-red-on-`1f26e42` trap, and "an eval case" as an accepted check.
- New eval cases are still written and committed, unrun. An acceptance criterion worded "Eval: …" is checked by reading the case (prompt, fixture, graders) against the skill text, and the `Resolved:` comment says the case is written, not run, per this rule.
- Unit tests, the drift check and `mattpocock-skills:code-review` run as before.
- Steps 5–6 ask for no eval evidence.
- The full suite runs once, on the integration branch, after the stream's last wave and before stage F is reported. The orchestrator runs it and reports the result.
- Sent to the seven running agents with `send_agent_prompt` at 06:2x. Agents started later by rolling start read it here. Every later wave's rules carry it in their own text.

**Eval case cap** (second user instruction, same day):
- A ticket adds **at most one new eval case**, and only when its acceptance criteria name an eval.
- Every other "Eval: …" criterion extends an existing case that covers it (a prompt or a grader added), never a new case.
- The one new case is designed to fail on the base commit's skill: a case that scores 1.00 on the old skill tells nothing apart. The grader-red-on-base rule stays, checked by reading the case against the base skill text, not by running it (no eval runs, above).
- Cases already written beyond the cap are merged or dropped before the report. The `Resolved:` comment names the new case, the extended cases and what was merged or dropped.
- Sent to all seven wave-2 agents, #53's already reported one included.
- The final run after the last wave is the full suite, once, with `-j 2`. Its report gives the total number of cases and how many this stream added (the base `ec29c8e` has 7).

**Zone exception** (operator decision on #49): #49 adds **Ship branch** to the stream skill's words block. No other wave-2 ticket touches that block. **Ship rules** comes with #61.

Heartbeats: `85c190e5` (every 15 min, expires 6h) watches the wave-2 agents; #47's turn ended while its Spec reviewer ran.

**No per-ticket review** (third user instruction, same day):
- Ticket agents run no `mattpocock-skills:code-review` and no other review sub-agent on their own ticket. A review already running is stopped, and its unfixed findings are left.
- Each ticket still runs the unit tests and the drift check. Then it commits, posts `Resolved:` and reports. The rules above that ask for a per-ticket code-review ("Done when", "Evidence standards", the flow's end) no longer apply.
- Steps 5–6 ask for no per-ticket review evidence.
- Step 7 reviews the **whole wave diff** from the wave's base (`1f26e42` for wave 2), on both axes, Standards and Spec, and not only the seams between tickets. Every finding is fixed in one fix pass for the wave before step 8 cleans up.
- Sent to the six wave-2 agents still working (#41, #47, #48, #49, #53, #54). #42 had already reported.

**Eval model and effort** (fourth user instruction, same day). Every `claude plugin eval` run, the final full suite included, takes this form:

```
CLAUDE_CODE_EFFORT_LEVEL=medium claude plugin eval --model sonnet -j 2 <target>
```

- `--model sonnet` overrides every case's model, a model set in a case's `case.yaml` included.
- `claude plugin eval` has no effort flag, so the effort comes from the environment variable `CLAUDE_CODE_EFFORT_LEVEL=medium`.
- LLM graders keep the default judge model (haiku). No `--judge-model` is passed.
- The final run's report states the model and the effort used.

2026-09-29, rolling start: the first `create_workspace` for #52 was reported rejected but created `wks_2d9a44d04d8a4fac` on the right branch. The retry made `wks_dd0732a79754ede0` on a stray branch `matt-with-paseo-0-4-2-wave2-52-index-decisions`. The stray workspace was archived (clean, no agent) and its branch deleted.

**Operator decisions, 2026-09-29** (recorded on the tickets):
- The exact eval command, run from `plugins/matt-with-paseo`: `CLAUDE_CODE_EFFORT_LEVEL=medium claude plugin eval --model sonnet -j 2 --scaffold --trust-plugin --no-publish .`
- #42: a pure chain under `stream` goes through ordinary waves, and only a single ticket runs as a one-ticket wave (ADR 0006). The hold and quota criteria are accepted as met by reading steps 4 and 6.
- #41: hung ticket agents get 2 restarts per ticket per wave (ADR 0004's budget). Past it, the agent is left and the ticket is named in the end-of-turn message. **Step 7 fix pass**: write this into the wave skill's heartbeat contract (#41's zone).

**From wave 3 on** (fifth user instruction, same day; wave 2 runs as planned, its step 7 review and fix pass included):
- **Ticket agents run Sonnet.** Every new ticket agent from wave 3 on, and every replacement agent, runs `claude/claude-sonnet-5`, mode `auto`. The stream agent stays on Opus.
- **One review at the end of the stream.** From wave 3 on, no wave runs a step 7 review. After the last wave, one review covers the whole stream diff from `ec29c8e` on both axes, Standards and Spec. Every finding is fixed in one fix pass, and the eval runs after that. Step 8 cleanup still follows every wave.
- **The final eval runs each case once, with no without-plugin arm.** Run from `plugins/matt-with-paseo`:
  `CLAUDE_CODE_EFFORT_LEVEL=medium claude plugin eval --model sonnet -j 2 --runs 1 --ablation none --scaffold --trust-plugin --no-publish .`
  It replaces the command recorded above. The report states the model, the effort, the number of runs per case, and that there is no comparison arm.
- **End of the stream, in order:** the last wave merged → review of the whole stream → fix pass → the one eval run → stage F reported.

## Review

Fixed point `1f26e42`, the whole wave-2 diff (user's rule: no per-ticket review), run in the orchestrator's session with two read-only sub-agents. **Standards: 11 findings** (12 checked, one no longer holds); **Spec: 12 findings**. Deduplicated, together with the ticket agents' out-of-zone notes and the operator's decisions, they make one fix list. Every item goes to the wave-2 fix pass (one agent on a fresh workspace off the integration branch). Outcomes are filled in after that pass.

| # | Where | Finding | Fix | Axis |
|---|---|---|---|---|
| F1 | `AGENTS.md`, `docs/agents/domain.md` | The stream block's term list lacks **Ship branch** ("adds only Stream, Intake agent and Pause", "adds three") | Name Ship branch, or point to the words block instead of listing | Std 1, Spec 4 |
| F2 | Wave skill step 1, step 0 E/F rows | `needs info` is missing from step 1's role list and Done when, and from stage E/F conditions, so a needs-info ticket blocks stage F | Add needs info to step 1 and the E/F rows | Std 2–3, Spec 6 |
| F3 | Wave skill step 0 stage E row | A `## Review` with a finding "waiting on the user's decision" is not stage E | Add the clause | Std 4 |
| F4 | Wave skill step 4 and step 6 Done when | They ignore **Hold** | Add "unless a hold stands" | Std 5, Spec 8 |
| F5 | Wave skill step 2 | "A wave of one ticket is a signal…" fires on every one-ticket wave under `stream` | Exempt the one-ticket wave ADR 0006 makes under `stream` | Std 6, Spec 7 |
| F6 | Wave skill step 4 "Take the shape of each create_agent call"; step 7 spawns | The model and mode the user gave (no profile) are not mapped; step 7's review/fix agents do not carry step 4's project id and workspace id | Add both | Std 7 |
| F7 | Wave skill, end of step 0's recovery sweep | Three branches in prose (H1) | Make it a table: condition → step | Std 8 |
| F8 | Wave skill step 3, step 5, step 6 Done when (#53 notes) | Who runs the base check for "Failing on base" is unstated; failures already on base are not the agent's; step 6 Done when lacks "the conflict-marker search prints nothing" | Add the three lines | known |
| F9 | Wave skill heartbeat contract | **Operator decision:** hung ticket agents get 2 restarts per ticket per wave (ADR 0004's budget). Past it, the agent is left and the ticket named in the end-of-turn message | Write it in | decision |
| F10 | Stream skill step 6 Done when | "the forge was chosen from the stream's repository" | "the forge is the row's Forge cell (step 1)" | Std 9, Spec 3 |
| F11 | Stream skill "Replace a stream agent" Done when | Does not say a hung agent is killed first | Add it | Std 10 |
| F12 | `TROUBLESHOOTING.md` `cancel_agent` row | Advises prompting, which contradicts "a hung agent is never cancelled or prompted" | Carve out the hung case, pointing to the heartbeat contract | Std 11, Spec 9 |
| F13 | Stream skill "Inputs: public signals only" | Lacks the unfiltered `paseo ls -g --json` and `git -C <cwd> worktree list` (step 0) and `list_pending_permissions` (step 5) | Add them | Spec 1 |
| F14 | Stream skill step 4 "A question round" | "your own two kinds of item" (step 7's need item and #52's machine-changing actions are now added), and "goes to no agent" contradicts step 7 sending hold/release | Name every kind; except the need item's hold/release | Spec 2 |
| F15 | Stream skill `decisions.md` | The Decisions section's Done when cannot be met: no step appends to `decisions.md`. Step 6's "Anything else" row and the example `user said wait` keep answers in the status line | Add the append to steps 6 and 7, the cap split, hold and pause; drop answer text from the status line; README "The control folder and its index" names `decisions.md` | Spec 5 |
| F16 | Stream skill index example | No `Last tick:` line | Add #40's proposed example line | Spec 12 |
| F17 | Stream skill step 5 | (#39) a question still open after a partial answer, or asked back for a missing slug, never shows again; (#51) no row sends `release` when the other stream ships, and Pause's resume would also lift a `held until <other> ships`; (#40) rows can overlap on one agent with no precedence; (#41) "Stream agent running → None" must lead to the activity check | Fix each in the tick table and the Pause text | known |
| F18 | Stream skill step 5 heartbeat recovery | #37 story 22 asks to delete "by name"; `delete_heartbeat` takes only an id, so the id sits in the Last tick line | One line in the skill naming the API constraint | Spec 11 |
| F19 | `evals/streams-48-timeout-adopts-in-project` | Grader `agent-carries-workspace-id` does not tell base from HEAD | Say so in the grader, or make it base-negative | Spec 10 |

Not holding: step 5's "ship blocked" row (step 6 guards itself) and step 2's worktree reuse (its table covers it).
Operator decision on #51: reading (a) stands, as merged (recorded on #51). Step 7's file-list rule does not change.

**Outcomes of the fix pass** (agent d4b40845, branch `matt-with-paseo-0-4-2/wave2/review-fixes`, merged as `4a27849`; 13 unit tests OK, drift check exit 0, no markers). All fixed, none skipped:
F1 `22c5e12` · F2–F5, F8 `d3753a6` · F6, F7, F9, F12 `6ba1686` · F10, F11, F13, F16, F18 `7de0c85` (F13 and F15 also in `2ac2746`) · F14 `96d7e6a` · F15 `56d4a6c` · F17 `e15956e`, `2ac2746` · F19 `a0e2b4b` (the note sits in `case.yaml`'s description) · **F2b** (added in the pass: the stream skill's step 5 ship row and step 6 last-stage signal accept needs info) `c585b30`.
Left for later: the Pause procedure itself (no step pauses or resumes yet) belongs to #44, wave 3.

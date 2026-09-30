# Common rules for wave 1 (tickets #116; then #118, #120, #121, #122, #117, #119)

## Graph
`116 → {117, 118} ; 117 → 119 ; 118 → 120 → 121 → 122`

Every edge is declared twice and both agree: the `Blocked by` line of each issue and GitHub's native dependencies. The quota is 1, so the stream runs one ticket at a time; every ticket after #116 joins this wave by rolling start once its blocker is merged. Planned start order (the one that unblocks the most tickets first, #118 before #117 by the user's decision): #116, #118, #120, #121, #122, #117, #119. No bundle: the user decided not to bundle this stream's own chain.

| Ticket | Status | Blocked by | Wave |
|---|---|---|---|
| #116 ADR 0010 and the Bundle words | open, ready-for-agent | - | 1, started first |
| #118 Common rules and step 4 spawn one agent per bundle | open, ready-for-agent | #116 | 1, rolling start |
| #117 Step 2 plans bundles | open, ready-for-agent | #116 | 1, rolling start, waiting on the quota |
| #120 Step 6 merges a bundle ticket by ticket by SHA | open, ready-for-agent | #118 | 1, rolling start |
| #119 Stream skill sizes a stream's wave quota in bundles | open, ready-for-agent | #117 | 1, rolling start |
| #121 Step 5 checks each bundle ticket, next or stop | open, ready-for-agent | #120 | 1, rolling start |
| #122 In-flow review once per bundle, steps 7 and 8 per bundle | open, ready-for-agent | #121 | 1, rolling start |

## Context
- Your worktree branches off `stream/ticket-sizing` at `ff463fe` (`main` after `mwp-seatworks` merged, v0.5.0), unless your prompt names another base commit (a ticket started by rolling start). The tickets of this stream merged before yours are on that base; your prompt names them.
  Run `git branch --show-current` before every commit.
- Read before you start: your ticket (`gh issue view <n> --comments`); the spec #115 (`gh issue view 115 --comments`), its Implementation Decisions for your part and its ADR 0010 comment; `CODING_STANDARDS.md`; ADRs in `docs/adr/` (0005, 0006, 0008, 0009 matter here); the words blocks at the top of both `SKILL.md` files; `scripts/pinned-lines.json`; README "Behaviour evals" if your ticket touches an eval case.
- No other agent works in parallel with you (quota 1). Work only on your own ticket.
- Do not end your turn while work you started is still running in the background (a long command, a sub-agent): wait for it inside the same turn. Paseo sends no finish notification for a turn you start on your own afterwards, so your "finished" report must mean the work is done.
- Start any command that may take more than two minutes in the background from the start, and read its output when it finishes. A foreground command the shell moves to the background halfway can leave your turn waiting on a result that never returns.

## Existing interfaces to reuse
- `scripts/pinned-lines.json`: each row is a file, an exact phrase and a reason; the phrase must stay whole on one physical line of its file. If you reword or move a pinned sentence, update its row in the same commit. Check with a `grep -F` of the phrase in the file, not with the drift check (you do not run it, see below).
- Eval cases in `plugins/matt-with-paseo/evals/`, one folder per case (`case.yaml`, `prompt.md`, `fixture.sh`, `graders/*.md`). A case carries an **observed-state block** standing in for Paseo (README "Observed state in the prompt"). Close shapes: `wave-54-repro-and-no-code-flow` (step 2, ticket prompts), `wave-64-merge-message-pattern` (step 6 merges), `streams-43-quota-follows-wave` (stream quota), `wave-42-one-ticket-no-ship`.
- Words: use every words-block term only in its defined meaning. Define no term outside a words block, and each term in one block only. **Bundle** and the redefined **Ticket agent** land with #116 in the wave skill's words block; later tickets use them, never redefine them.
- `plugins/matt-with-paseo/skills/matt-with-paseo/PASEO-FACTS.md` holds verified Paseo facts (for example `lastUsage` in `get_agent_status`); point to it rather than restating a fact.

## File zones
"Wave skill" is `plugins/matt-with-paseo/skills/matt-with-paseo/SKILL.md`, "stream skill" is `plugins/matt-with-paseo/skills/matt-with-paseo-streams/SKILL.md`, "template" is `COMMON-RULES-TEMPLATE.md` beside the wave skill, "troubleshooting" is `TROUBLESHOOTING.md` beside it.

| Ticket | Owns |
|---|---|
| #116 | `docs/adr/0010-tickets-are-bundled-at-dispatch-not-at-slicing.md` (new; the only ticket that writes it); wave skill words block, names table, step 0 recovery; any `--label ticket=<NN>` in the skills or troubleshooting. |
| #117 | Wave skill step 2 (and the "Width is the point" paragraph); eval case `wave-54-repro-and-no-code-flow` (extend only). |
| #118 | Template (parameters section, Context, "Done when", report); wave skill steps 3 and 4 (spawn, `## Wave agents` columns, quota rule) and step 0's reading of the merged-SHA column. |
| #119 | Stream skill: "Split the cap into quotas", the wave-width rule, the Agent cap line; eval case `streams-43-quota-follows-wave` (extend only). |
| #120 | Wave skill step 6, and the `git branch --merged` check in steps 0 and 8; eval case `wave-64-merge-message-pattern` (extend only). |
| #121 | Wave skill step 5 (and the heartbeat contract's restart-budget cell, reworded in place); troubleshooting "Agent stops midway" and the entry that points at the restart budget; the one new eval case `wave-121-bundle-turn-end`. |
| #122 | Wave skill step 4's flow ending, steps 7 and 8; the matching step 5 check on the code-review result. |

- Only the ticket your prompt names as **the stream's last ticket** bumps `plugins/matt-with-paseo/.claude-plugin/plugin.json` (0.5.0 → the next version the version gate needs; the gate compares with the tag `v0.5.0`), once. No other ticket changes a version number.
- New eval case: only #121's, named in its criteria. Extending a case means adding prompt lines or graders, as whole lines, inside that case.
- Shared files (the wave skill, the template, troubleshooting, README, `pinned-lines.json`): add or change only the lines your ticket owns, keep the order of the existing lines.
- Outside your zone: name the file, the section and the change you would make in your report instead of editing it.

## Eval, test and review rules (the user's, for this stream)
- **No ticket runs the test suite, the drift check, an eval or a code review.** You do not run `python -B -m unittest …`, `python -B scripts/drift-check.py`, `claude plugin eval` (neither the suite nor one case), `/mattpocock-skills:code-review` or any review sub-agent. This overrides the wave skill's "every flow ends with `/mattpocock-skills:code-review`". You may write and change tests, checks and eval cases.
- Verify each acceptance criterion with a check that is not the suite: a `grep` red on the base (`git show <base>:<path>`) and green on your head, reading a section, reading an eval case against the base skill text. Your `Resolved:` comment says tests and eval cases were written, not run.
- **At most one new eval case per ticket**, only when its acceptance criteria name one (only #121). A new or extended grader is designed to fail on your base commit's skill; name, for each grader, the base-skill line that makes it fail. Graders check external behaviour only, never the skill's wording.
- After the last ticket, the orchestrator runs one full test run, one review of the whole stream diff, one fix pass, then the one eval run.

## Traps already hit
- Committing on the integration branch moves its HEAD. Commit only on your own branch; never check out or commit to `stream/ticket-sizing`. Check: `git branch --show-current` before each commit.
- Never edit anything under `.git/` (shared by every worktree). Do not use bare `git stash`; make a WIP commit on your branch instead.
- `git checkout -- <file>` and `git checkout <commit> --` throw away edits or detach HEAD (an earlier agent detached HEAD this way). Read an old version with `git show <base>:<path>`; revert one edit with the file-editing tool. Check: `git diff <file>` and `git branch --show-current` before you commit.
- Commit in small steps; leave no work outside git. Check: `git status --porcelain` is empty before your report. Delete any `evals/results/` folder and any stray empty folder a broken heredoc left.
- If a git command hangs, stop and report; do not delete lock files.
- Windows: `python3` is the Microsoft Store alias and fails (exit 49); use `python -B`. A lone single quote inside a Bash heredoc breaks parsing; write file content with the file-writing tool. Python needs `PYTHONIOENCODING=utf-8` for Vietnamese output. Git Bash's `/tmp` is not the path Windows Python sees; use `cygpath -w` or your temp directory.
- A grader that cannot fail on the base skill proves nothing (earlier waves dropped cases that scored 1.00 on the old skill). Check: name the base-skill line that makes each grader fail.
- A new eval case keeps its front matter and observed-state block in `prompt.md`, like every other case, not in `case.yaml` (stream review finding P1 on `wave-95`). Check: compare your case's file layout with `wave-64-merge-message-pattern`.
- Rewording a pinned sentence without its row breaks the drift check at the stream's end. Check: for every row of `scripts/pinned-lines.json` whose file you touched, `grep -cF '<phrase>' <file>` prints at least 1.
- Agents stopped on a session limit mid-work in earlier waves. Your commits are your progress: commit before long steps, so a resume can pick up from `git log`.
- `gh` has failed with `x509: certificate signed by unknown authority` (network SSL inspection). Not yours to fix: write the text you would post into your temp directory, say so in your report, and carry on with local work.
- Put temporary files only in your temp directory, never loose in `%TEMP%`. Before reporting, list your temp directory and quote the result.

## Failing on base
- Not run on `ff463fe`, by the user's decision: tests and the drift check run once, at the stream's end, and no ticket runs them. On `main` before this stream (`mwp-seatworks`'s last recorded run, `fb38f6a`): 78 tests OK and drift check exit 0; tests added after it were never run.
- The version gate's self-test `test_this_repository_passes_its_own_gate` fails from this stream's first change to a file agents read until the stream's last ticket bumps the version. It is not yours.
- A failure listed here is not yours: leave it as it is unless your ticket's acceptance criteria name it, and name it in your report as failing on base. A failure not listed here is yours to explain.

## Acceptance criteria are the contract
- A trap above, or an instruction an earlier ticket left in its comments, is guidance; your ticket's acceptance criteria are the contract.
- On conflict, follow the criteria and write the discrepancy and its reason in a comment on your issue; do not stop to ask.
- If the criteria themselves look wrong, stop that part, write the evidence in a comment on your issue, and add the `ready-for-human` label. Never rewrite the criteria.

## What must hold, what was chosen, what is not known yet

| Part | What it holds | What you do when your evidence goes against it |
|---|---|---|
| Must hold | Your ticket's acceptance criteria, and the section above. | Follow the section above; never rewrite the criteria. |
| Chosen for you | ADR 0010's text of record is the comment https://github.com/hanh9898/matt-with-paseo/issues/115#issuecomment-5895566920, not the untracked copy in the main checkout: the spec says so. | Challenge it with evidence, in your ticket's comments and your report. A challenge alone does not move the ticket to `ready-for-human`. |
| Chosen for you | This stream's own chain is not bundled, and #118 → #120 stays an edge: the user decided both. | As above. |
| Chosen for you | No test, drift check, eval or review runs inside a ticket: the user's rule for this stream (D5, D24). | As above. |
| Not known yet | Jev's inside (how its flag is computed). | Out of scope: the skills name only the seam (ADR 0009). |

Whoever answers a challenge to a chosen default writes why the plan changes or stands; an answer with no reason is not a resolution.

## Resources
- Your private resources are listed in your prompt (a temp directory only). Use exactly that set. Create it when you first need it and leave it in place when you finish; the orchestrator removes it after your merge.
- Shared, read-only: the main checkout `D:\matt-with-paseo-streams\matt-with-paseo` (do not write there); the installed Matt plugins under `~/.claude/plugins/cache/`; the plugin repository `hanh9898/matt-with-paseo-plugin`.
- Machine-wide: the Paseo daemon, this machine and one usage limit are shared by every agent. Create no Paseo workspace, agent, heartbeat or schedule.

## Repo and user rules
- Skills, ADRs, README and all GitHub text in **English**. `CODING_STANDARDS.md` is the standard for every document an agent reads: numbered steps, a **Done when** per step that matches its body, choices as table rows, one concept one word, one source of truth, one clause per sentence.
- Commit format: the repo's style, `<type>(<scope>): <summary> (#NN)`, types and scopes as in `feat(wave): …`, `feat(streams): …`, `feat(scripts): …`, `test(evals): …`, `docs(adr): …`, `docs(readme): …`, `docs(standards): …`, `chore(release): …`. End every commit message with `Co-Authored-By: Claude Sonnet 5.5 <noreply@anthropic.com>`.
- Do not push, do not tag, do not open a PR, do not close your issue.
- Credentials: never read, print or pass on a token or credential (no `gh auth token`, no `gh auth status`, no reading a CLI's hosts or config file or a token's environment variable, no token in a URL or a command). A `gh`, push or upload failure goes into your report with the command and its error as printed; never work around it with another tool, the forge's API or another account.
- Evidence standards: none declared.

## Done when:
- Commit to your branch. The orchestrator merges it. Keep no pull-request text in your worktree; put what the ship needs in your report.
- No code review runs (see the eval, test and review rules above).
- Mark the ticket done with a comment starting `Resolved:` (leave the issue open; the orchestrator closes it after the merge), or add `ready-for-human` for the part a human must do. In it, write what you changed, each acceptance criterion with the check you ran and its output (or "checked by reading", with the lines), what remains open, and which eval cases and tests you wrote or extended, written, not run.
- Clean up your temp directory; state the reason for anything you keep.
- Report back: a design summary, files touched, how you verified with evidence, work not done or still in doubt (every out-of-zone change you would make), every change outside git, each private resource you created, and decisions the user must make. Tag each decision `decided: X because Y` or `assumed: X, unchecked`, and each finding `reproduced` or `traced`.

## Wave agents

| Ticket | Agent id | Workspace id | Branch | Base commit | Private resources | Cleaned |
|---|---|---|---|---|---|---|
| #116 | 16ffcbe8-e0e5-4fd5-86a4-65a55185511c | wks_5110ef510ab8ad9f | `ticket-sizing/wave1/116-adr-0010-bundle-words` | `ff463fe` | temp `%TEMP%\ticket-sizing-wave1-116` | [x] |

#116 merged as 02342f8 (conflict-marker search empty; no suite run, per the user's rule). Checked: two commits b64e8fd, c1a234b; worktree clean; ADR 0010 equals the #115 comment 5895566920 except one trailing blank line, and equals the untracked copy in the main checkout; `Resolved:` comment on #116. Issue #116 closed after the merge.
Noted for the stream-wide review, out of #116's zone: the eval prompts `streams-40`, `41`, `44`, `45`, `46`, `51`, `52` still give agents a `ticket=NN` label; the stream skill's adopt-run table (lines 259, 261 on 02342f8) still names the `ticket` label (to #119's agent). The untracked ADR 0010 copy in the main checkout will block `main`'s checkout from taking this stream's merge until it is removed there.

| Ticket | Agent id | Workspace id | Branch | Base commit | Private resources | Cleaned |
|---|---|---|---|---|---|---|
| #118 | 77cceaa0-ca81-4ad5-b568-0557129beea3 | wks_ae4d652bfe8a3724 | `ticket-sizing/wave1/118-bundle-spawn` | `02342f8` (rolling start) | temp `%TEMP%\ticket-sizing-wave1-118` | [x] |

#118's agent stopped twice without work: `gh issue view` fails machine-wide on TLS (`x509: certificate signed by unknown authority`, FortiGate inspection, P23). **Operator's instruction (2026-09-30):** leave every `gh` step for the user. Ticket agents work from issue texts the orchestrator copies into their temp directory (read before `gh` broke) and write their `Resolved:` into `<temp>\resolved-<NN>.md`; the orchestrator merges locally and keeps the posts and closes as a backlog until told `gh` works. Heartbeat `a3210dc9` watches #118 (15 min, expires 06:03 UTC).

### `gh` backlog (post once `gh` works)
- #118: post `%TEMP%\ticket-sizing-wave1-118\resolved-118.md` as a comment; after its merge, close with "Merged into `stream/ticket-sizing` as <sha>."
- #118: merged as 42873bd (commit d345330; conflict-marker search empty; worktree clean; 40 of 40 pinned phrases whole on its head). Post `resolved-118.md`, then close #118 with "Merged into `stream/ticket-sizing` as 42873bd."
- #120: post `%TEMP%\ticket-sizing-wave1-120\resolved-120.md`; close after its merge.

Noted for the stream-wide review, from #118's report: the template's "Before the last commit: run `/mattpocock-skills:code-review`" and step 4's "Every flow ends with…" stay for #122; the template's per-ticket "Done when" is one lead sentence ("Each item below holds for one ticket…"), not a rewrite of each item (assumed); step 3 says the prompt carries "three things", step 4 says "four things" (already so on base).

| Ticket | Agent id | Workspace id | Branch | Base commit | Private resources | Cleaned |
|---|---|---|---|---|---|---|
| #120 | 920ae617-76f4-4d92-8f39-dac789a7cf78 | wks_98d582436b24c0e8 | `ticket-sizing/wave1/120-merge-by-sha` | `42873bd` (rolling start) | temp `%TEMP%\ticket-sizing-wave1-120` | [x] |

`gh` works again (2026-09-30, operator: GitHub presents its Sectigo certificate). Backlog posted: #118's `Resolved:` (issuecomment-5902707506) and its close. #120's agent was told it may use `gh` again and post its own `Resolved:`; ticket agents spawned from here use `gh` as usual.

#120 merged as 82f8efc (commit 06ee76f; conflict-marker search empty; worktree clean; 40 of 40 pinned phrases whole on its head; `Resolved:` posted by its agent, issuecomment-5902719098). Issue #120 closed after the merge.
Noted for the stream-wide review, from #120's report: `wave-64-merge-message-pattern` now holds bundle 03+04 beside the separate agents of tickets 01 and 02, against `case.yaml`'s "two tickets"; its fixture has no branches for 03 and 04 (the graders read only the observed-state block); six graders written, not run. Step 7 (#122) still says "step 6's three moves", still true.

| Ticket | Agent id | Workspace id | Branch | Base commit | Private resources | Cleaned |
|---|---|---|---|---|---|---|
| #121 | b80e8d36-264e-4d38-959a-834d6404513a | wks_98d9ec1fdff77d5b | `ticket-sizing/wave1/121-bundle-turn-end` | `82f8efc` (rolling start) | temp `%TEMP%\ticket-sizing-wave1-121` | [x] |

#121 merged as de451e7 (commit f818d9f; conflict-marker search empty; worktree clean; 40 of 40 pinned phrases whole on its head; new case `wave-121-bundle-turn-end` keeps front matter and observed state in `prompt.md`; `Resolved:` posted by its agent, issuecomment-5902867553; its temp directory already removed). Issue #121 closed after the merge.
Noted for the stream-wide review, from #121's report: the new case's fixture has a bundle of five tickets ("the user approved this bundle at five tickets in step 2") so the 4th-ticket stop has a next ticket to refuse; that is above the ticket cap of 4, which step 2 (#117) makes a bundle's maximum (assumed, unchecked). Five graders written, not run.

| Ticket | Agent id | Workspace id | Branch | Base commit | Private resources | Cleaned |
|---|---|---|---|---|---|---|
| #122 | 7ea21e74-c6a1-42b3-9a63-6015c356be4a | wks_4736fe71186f6a6a | `ticket-sizing/wave1/122-bundle-review-cleanup` | `de451e7` (rolling start) | temp `%TEMP%\ticket-sizing-wave1-122` | [x] |

#122 merged as de3f7bc (commit 2cb0b50; conflict-marker search empty; worktree clean; 40 of 40 pinned phrases whole on its head; `Resolved:` posted by its agent, issuecomment-5902932235). Issue #122 closed after the merge.
Noted for the stream-wide review, from #122's report: README line 360 ("Review per ticket, then the seams") still speaks per ticket; TROUBLESHOOTING "Agent stops midway" does not name the fresh review agent of a bundle ended by `stop`.

| Ticket | Agent id | Workspace id | Branch | Base commit | Private resources | Cleaned |
|---|---|---|---|---|---|---|
| #117 | a6dda581-da42-4c1c-a3f4-c56c9e9acf7a | wks_6cddd6656ab5e612 | `ticket-sizing/wave1/117-step2-plans-bundles` | `de3f7bc` (rolling start) | temp `%TEMP%\ticket-sizing-wave1-117` | [x] |

#117 merged as b1f3205 (commit dc6538b; conflict-marker search empty; worktree clean; 40 of 40 pinned phrases whole on its head; `Resolved:` posted by its agent, issuecomment-5903009808). Issue #117 closed after the merge.
Noted for the stream-wide review, from #117's report: step 2 says a symptom ticket "breaks the chain" (beyond "never bundled"); step 2's quota sentence now counts ticket agents, one per bundle (decided, from ADR 0010); the three new `wave-54` graders all require the `[04+05]` chain so they fail on base (assumed, unchecked); the base-passing halves ("06 and 07 apart", "02 in no bundle", "08 not started") fail only on a wrong bundling rule.

| Ticket | Agent id | Workspace id | Branch | Base commit | Private resources | Cleaned |
|---|---|---|---|---|---|---|
| #119 | d99286c6-8ebf-4fde-8367-38af07e55d27 | wks_4ae7a6d33123115f | `ticket-sizing/wave1/119-stream-quota-in-bundles` | `b1f3205` (rolling start, last ticket, bumps 0.5.0 → 0.6.0) | temp `%TEMP%\ticket-sizing-wave1-119` | [x] |

#119 merged as d314c9d (commits 7949ef0, 347f3d8 — the stream's one version bump, 0.5.0 → 0.6.0; conflict-marker search empty; worktree clean; 40 of 40 pinned phrases whole on its head; `Resolved:` posted by its agent, issuecomment-5903058879). Issue #119 closed after the merge. Every ticket of the stream (#116–#122) is merged and closed; spec #115 stays open.
Noted for the stream-wide review, from #119's report: the stream skill's adopt-run table keeps the `ticket` label (it describes agents an older run spawned; decided); README line 297 (`--pin v0.5.0`) and line 410 ("29 from 0.4.2, 3 added for 0.5.0", with `wave-121-bundle-turn-end` new in 0.6.0) are out of its zone.

## Review

Not run per wave (the user's rule for this stream): the whole stream diff is reviewed once, after the last ticket, on both axes, followed by one fix pass and the one eval run. The findings noted above in this log go into that review.

## Stream review

**Full test run, once, on d314c9d** (2026-09-30): `python -B -m unittest discover -s scripts` ran 91 tests, **1 failure**: `test_troubleshooting_ratings…test_on_the_real_repo_every_entry_is_rated_and_every_caught_phrase_is_present`. Two `caught` phrases of `TROUBLESHOOTING.md` are gone from the wave skill: "check the real artifacts, not the report's words" (line 15, "Report is correct but incomplete."; reworded by #121, gone since de451e7) and "the ticket's branch appears in `git branch --merged <integration branch>`" (line 87, "Ticket branch not merged."; reworded by #122, gone since de3f7bc). `python -B scripts/drift-check.py`: exit 0. Goes to the fix pass.

**Stream-wide code review** (2026-09-30, `mattpocock-skills:code-review` in the orchestrator's session, two read-only sub-agents), fixed point `ff463fe`, head `d314c9d` (32 files, +433/−59, `.scratch/` excluded). **Standards: 11 findings (7 hard, 4 judgement calls); Spec: 12 findings**, plus the test failure T. Orchestrator checks on head: P6 (seven tickets, not eight) confirmed; wave-64 `case.yaml` "Two tickets" confirmed; "Jev" in no words block confirmed; README 297/360/410 confirmed stale; `ticket=`/`ticket: "` in the prompts of streams-40, 41, 44, 45, 46, 51, 52 and wave-53, 64, 76.

| # | Where | Finding | Axis |
|---|---|---|---|
| T | TROUBLESHOOTING.md:15, :87 | Two `caught` phrases gone from the wave skill (#121, #122); ratings test fails | Test |
| S1 | Wave skill (6×), template Parameters | "bundle agent" is a second name for **Ticket agent** | Std (W4), hard |
| S2 | Wave skill :261, template :39 | "Jev" defined in no words block | Std (W4), hard |
| S3 | Template Parameters, wave skill :160, :176, :261–262 | Ticket cap and context stop stated in three places; step 5 should point to the parameters | Std (W6), hard |
| S4 | Wave skill step 4, after the flow table | Review-per-bundle and fresh-review-agent rules are inline prose read by every run | Std (H1, W2), hard |
| S5 | Wave skill step 4 Done when | Does not cover the fresh review agent its body creates | Std (W3), hard |
| S6 | Wave skill step 4 items 1–2 | Restate the names table's first-ticket naming | Std (W6), hard |
| S7 | Step 2 table, flow table, ADR | "Symptom never bundled" stated three times | Std (W6), hard |
| S8–S11 | Step 0 :95; quota/rolling start; 32 files; ADR "Grading the ceiling" | Long sentence; duplicated slot-freeing list; shotgun surgery; speculative ADR section | Judgement |
| K1 | Wave skill :176 vs :201 | Step 3 "three things", step 4 "four things" (flow listed twice); spec says three | Std (W6), Spec P7 |
| P1 | Template :121, step 5 item 4 | `stop` does not tell the agent to skip its review and hand off | Spec (26a) |
| P2 | Step 0 :89, step 4 table | A fresh review agent carries the bundle's labels, so step 0 finds two agents for one ticket | Spec |
| P3 | Step 0 :101 vs step 8 :326 | Step 8 waits for review fixes before a bundle branch counts as merged; step 0 does not | Spec |
| P4 | Eval prompts streams-40/41/44/45/46/51/52, wave-53/64/76 | Observed state still gives agents the removed `ticket` label (streams-46 adopts a legacy wave, may stay) | Spec |
| P5 | Stream skill :259 | "ticket agents' `ticket` labels": legacy adopt row (#119 kept it, decided) | Spec |
| P6 | Stream skill :175 | "five bundles … hold eight tickets": they hold seven | Spec |
| P8 | Template :36–41 vs step 2 :160 | Cap applies "only while Jev is not available" (template) but always bounds a bundle (step 2); the wave-121 fixture's five-ticket bundle follows from the same tension | Spec |
| P9 | Step 2 :162 | Order of chain bundling vs the past-the-quota test unspecified | Spec |
| P10 | Steps 0, 4, 6 | No row records the SHA of a bundle's review-fix merge | Spec |
| P11, P12 | Stream skill :175 example; wave-54/64/121 graders | Rewrites and graders beyond the criteria | Spec, scope |
| K2 | wave-64 `case.yaml` | Description says two tickets; prompt adds bundle 03+04 | Spec |
| K3 | README :297, :360, :410 | `--pin v0.5.0`; "Review per ticket"; case counts without 0.6.0's new case | Std, known |
| K4 | TROUBLESHOOTING "Agent stops midway" | Does not name the fresh review agent of a bundle ended by `stop` | Spec |

**Operator's decisions (D86, 2026-09-30):** 1a (P8: the ticket cap always bounds a bundle's size; only the stop at the cap's ticket is the no-Jev fallback; the wave-121 fixture states the approver widened that bundle to five), 2a (P4: observed state of streams-40/41/44/45/51/52 and wave-53/64/76 moves to `bundle`/`tickets`; streams-46 keeps its legacy `ticket` label), 3a (the fix agent runs only `python -B scripts/troubleshooting-ratings.py`, not the suite), 4a (fix list and skip list as proposed). Heartbeat `a3210dc9` deleted (the orchestrator's tick covers this run).

**Outcomes.** Fix pass: T, S1, S2, S3, S5, K1, P1, P2, P3, P4, P6, P8, P9, P10, K2, K3, K4. Skipped: S4, S6, S7 (structure only, no behaviour change; S7's repeats sit in different documents' own rules), S8–S11 (judgement calls), P5 (#119 decided: the row describes agents an older run spawned), P11, P12 (they serve the criteria).

### Fix pass

| Ticket | Agent id | Workspace id | Branch | Base commit | Private resources | Cleaned |
|---|---|---|---|---|---|---|
| stream review fixes | 45c1445f-0a8b-43da-b113-e176f1acea5c | wks_7290e3c35464343b | `ticket-sizing/wave1/stream-review-fixes` | `d314c9d` | temp `%TEMP%\ticket-sizing-review-fixes` | [x] |

Fix pass merged as 3d37060 (16 commits, 19 files, +51/−49; conflict-marker search empty; worktree clean; no CRLF introduced; 40 of 40 pinned phrases whole). The fix agent reported all 17 findings fixed (T 29a8b62; S1+S2 5297d42; S3+P8 607c35b; K1 1e77ae2; S5 0beb0e6; P1 e0bdf70; P2 0ecf855; P3 b2d6efe; P10 694fcb2; P9 3dc8414; P6 b38392d; K2 73f79d3; K3 08155ce; K4 7c79e83; P4 c8f1e6a, 19 labels in nine prompts; P8 fixture 394fe74). `python -B scripts/troubleshooting-ratings.py` exit 0 on 3d37060 (orchestrator re-ran it). Not run after the fix (decision 3a): the unit-test suite and the drift check; the eval files it changed are written, not run until the eval below. Its notes: P2 tells the fresh review agent apart only by its `review` row, so before that row is written it cannot be told apart; step 2 says the cap always bounds a bundle while the wave-121 fixture's approver widened one to five, with no step 2 line allowing that (follow-up).

Wave 1 cleaned: 7 tickets and the fix pass merged; every row stopped, clean and merged, archived with its workspace (directories removed); temp directories removed; heartbeat `a3210dc9` deleted; `paseo ls -g --label stream=ticket-sizing --label wave=1` lists nothing.

### Eval run

The stream's one eval run, on 3d37060 (2026-09-30), the D9 command from `plugins/matt-with-paseo`: 33 case folders, **32 loaded and run** (1 run each, 597 s, $6.21, exit 1): **24 pass, 8 partial**. Report at `plugins/matt-with-paseo/evals/results/2026-09-30T03-43-27-541Z/` (gitignored).

- **Not loaded: `streams-43-quota-follows-wave`**, `YAML Parse error: Unexpected token`. Its `case.yaml` description reads "…names bundles: two start now…": an unquoted `: ` inside a plain scalar, written by #119 (7949ef0), kept by the fix pass (b38392d). So #119's criterion "quota counts bundles, not tickets" is ungraded.
- New or changed cases of this stream: `wave-121-bundle-turn-end` 1.00 (5/5); `wave-53` 1.00; `wave-76` 1.00; `wave-64-merge-message-pattern` 0.89 (the six new bundle graders pass; the older `no-default-message` fails, FAIL FAIL FAIL); `wave-54-repro-and-no-code-flow` 0.71 (new `chain-shown-as-bundle` and `no-quota-no-shared-file-bundle` pass; new `symptom-not-bundled` fails FAIL PASS FAIL; older `code-ticket-keeps-tdd` fails FAIL FAIL FAIL).
- Other partial scores: `streams-61-ship-rules` 0.20, `streams-41-hung-agents` 0.50, `streams-51-overlap-and-need` 0.50, `streams-49-ship-branch` 0.56, `streams-50-after-ship` 0.67, `streams-40-silent-supervision` 0.80.
- Against `mwp-seatworks`'s run on 8f7ede8 (1 run each, so noisy): no longer failing: `wave-75`, `wave-95`, `streams-48`, `streams-52`, `wave-tickets-with-width`. Failing now and passing then: `wave-54`, `wave-64`, `streams-50`, `streams-51`. Lower: `streams-61` 0.40 → 0.20, `streams-49` 0.78 → 0.56. Same: `streams-40`, `streams-41`.

**Operator's decisions (D90, 2026-09-30):** 1a: quote the `streams-43` description and re-run that case alone; 2a: no fix for the partial cases, they go to the ship pull request's Merge Danger. The untracked ADR 0010 copy in the main checkout was moved away by the operator (it differed only in line endings).

`streams-43-quota-follows-wave` fixed in 96b94b0 (description quoted; `yaml.safe_load` parses it). Re-run (D9 command plus `--case streams-43-quota-follows-wave`, on 96b94b0): **1.00**, 3/3 graders (`quota-counts-bundles-not-tickets`, `quota-follows-wave-width`, `quota-change-sends-prompt`, each PASS PASS PASS), 40 s, $0.22. Report under `evals/results/2026-09-30T04-16-36-197Z/`.

### Merge Danger for the ship pull request

- **Eval, full run on 3d37060 (1 run per case, compared with `mwp-seatworks`' run on 8f7ede8, also 1 run per case):** 24 of 32 loaded cases pass; `streams-43` did not load then and passes 1.00 on its re-run on 96b94b0, so 25 of 33. None of the partial scores was fixed (D90 2a).

| Case | This stream (3d37060) | `mwp-seatworks` (8f7ede8) | Failing graders now |
|---|---|---|---|
| `streams-61-ship-rules` | 0.20 | 0.40 | `names-empty-key` and others |
| `streams-41-hung-agents` | 0.50 | 0.50 | `closes-clean-merged-stream` and others |
| `streams-51-overlap-and-need` | 0.50 | passed | `need-yields-merge-or-hold` |
| `streams-49-ship-branch` | 0.56 | 0.78 | `conflict-reported-not-asked` (FAIL PASS FAIL) and others |
| `streams-50-after-ship` | 0.67 | passed | `sets-reopened-status` |
| `wave-54-repro-and-no-code-flow` (extended by #117) | 0.71 | passed | `code-ticket-keeps-tdd` (older grader); `symptom-not-bundled` (new, FAIL PASS FAIL) |
| `streams-40-silent-supervision` | 0.80 | 0.80 | `writes-last-tick` |
| `wave-64-merge-message-pattern` (extended by #120) | 0.89 | passed | `no-default-message` (older grader; the six new bundle graders pass) |

  No longer failing since 8f7ede8: `wave-75`, `wave-95`, `streams-48`, `streams-52`, `wave-tickets-with-width`. With one run per case, a judge error cannot be told apart from a skill gap; `wave-54` and `wave-64` are the two cases this stream changed, and their older graders fail there.
- **Tests not re-run after the fix pass (D86 3a):** the one full test run was on d314c9d (91 tests, 1 failure: the ratings test, fixed in 29a8b62; drift check exit 0). On 3d37060 only `scripts/troubleshooting-ratings.py` ran (exit 0). The unit-test suite and the drift check did not run on the fix pass's 16 commits.
- **Follow-up:** step 2 says the ticket cap always bounds a bundle, but `wave-121-bundle-turn-end`'s approver widens one bundle to five tickets; no line in step 2 allows that widening. The fresh review agent of a bundle ended by `stop` can only be told apart once its `review` row is written (P2).

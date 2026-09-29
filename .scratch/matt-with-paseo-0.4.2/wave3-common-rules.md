# Common rules for wave 3 (tickets #43, #44, #50, #55, #61; then #45, #62, #64, #63, #65, #58)

## Graph
`waves 1–2 ✓ (21 tickets) → {43, 44, 50, 55, 61} → 43 → 45; 61 → {62, 64}; 62 → 63; {63, 64} → 65; {43, 44, 45, 50, 55} → 58; 66 in triage`

| Ticket | Status | Blocked by | Wave |
|---|---|---|---|
| #38–#42, #46–#49, #51–#54, #56, #60 | closed, merged | - | 1, 2 |
| #43, #44, #50, #55, #61 | open, ready-for-agent | all merged | 3, started first |
| #45 | open | #43 | 3, rolling start |
| #62, #64 | open | #61 | 3, rolling start |
| #63 | open | #62 | 3, rolling start |
| #65 | open | #63, #64 | 3, rolling start |
| #58 Release 0.4.2 | open | #43, #44, #45, #50, #55 | 3, rolling start |
| #66 | needs-triage | - | none |

Every open ticket has a zone below, so each joins this wave by rolling start once its blockers merge. This is meant to be the stream's last wave.

## Context
- Your worktree branches off `stream/matt-with-paseo-0-4-2` at `13bc246`, unless your prompt names another base commit (a ticket started by rolling start). That branch holds waves 1 and 2: ADRs 0005–0007, `CODING_STANDARDS.md`, and the words **Hold**, **Intake agent**, **Pause**, **Checkpoint**, **Brief**, **Ship branch**. The stream skill already has entry guards, setup checks (step 1, with the Forge column), the ship branch (step 6), hung-agent supervision, `decisions.md`, the Last tick line, and overlap and need warnings. The wave skill already has hold, release and quota prompts, conflict-marker checks, "Failing on base" and the no-code flow.
  Run `git branch --show-current` before every commit.
- Read before you start: your ticket and its spec (#37 for #43–#45, #50, #55 and #58; #59 for #61–#65), including their Implementation Decisions and every comment on your ticket (operator decisions live there, for example on #61: **you also write ADR 0008**); `CODING_STANDARDS.md`; ADRs in `docs/adr/`; the words blocks at the top of both `SKILL.md` files; README "Behaviour evals".
- Up to 6 other agents work this wave's tickets in parallel, many in the stream skill. Work only on your ticket and inside your zone.
- Do not end your turn while work you started still runs (a long command, a sub-agent): wait for it inside the turn. Paseo sends no finish notification for a turn you start on your own afterwards, so your "finished" report must mean the work is done.

## Existing interfaces to reuse
- `python -B scripts/drift-check.py` (exit 0 clean, 1 drift, 2 usage) and `python -B -m unittest discover -s scripts`: run both before your last commit.
- Eval cases in `plugins/matt-with-paseo/evals/`, one folder per case (`case.yaml`, `prompt.md`, `fixture.sh`, `graders/*.md`). A stream-skill case carries an **observed-state block** (see `streams-no-index` and README "Observed state in the prompt"), or entry guard 2 stops it. Close shapes: `streams-49-ship-branch` for ship, `streams-47-setup-checks` for setup, `streams-41-hung-agents` for ticks, `wave-42-one-ticket-no-ship` for the wave skill under `stream`.
- Words: use every words-block term only in its defined meaning. Define no term outside a words block, and each term in one block only.

## File zones
"Stream skill" is `plugins/matt-with-paseo/skills/matt-with-paseo-streams/SKILL.md`, "wave skill" is `plugins/matt-with-paseo/skills/matt-with-paseo/SKILL.md`, "template" is `COMMON-RULES-TEMPLATE.md` beside it, "troubleshooting" is `TROUBLESHOOTING.md` beside it. Step 6 of the stream skill is shared by five tickets: each owns only the paragraphs named here, and adds a new paragraph only at the place named.

| Ticket | Owns |
|---|---|
| #43 capacity | Stream skill: "Split the cap into quotas"; the index's Agent cap field and a new Quota column (fields table and example); step 3's quota; step 4 "At a wave boundary" (a quota changes by the `quota <N>` prompt, not by replacing the stream agent); "Replace a stream agent" (renaming step 3's bold label **Hold** to a word other than **Hold**); one new row in step 5's tick table (the machine choking). README: a new subsection `### Picking a cap` right after "The control folder and its index". |
| #44 pause | Stream skill: one new section `## Pause and resume` right after "Replace a stream agent"; its status-line row (`paused`); one new row in step 5's tick table (resume is one tick, lifting only the holds the pause set, never step 7's `held until <other> ships`). |
| #50 after ship | Stream skill step 6: one new paragraph `**After ship.**` at the end of step 6 (reopen on request with `reopened after ship`, a new ship question when the head changes), and the "Ask again only when…" sentence; one new row in step 5's tick table (close a merged stream: archive its agents, remove the worktree, write `merged <date>`, keep the row); their status-line rows. |
| #55 troubleshooting | Troubleshooting only: its four entries in "Agents" and "Environment". |
| #61 ship rules (read) | `docs/adr/0008-*.md` (new). Stream skill: **Ship rules** in the stream words block (one whole line after **Ship branch**; the lead-in's count), step 1 (read the rules from the PR target on the remote and name early what the ship needs), the index's new Key column, and one new paragraph `**Ship rules.**` at the start of step 6 (read them again at ship and name any change). README: a new subsection `### Ship rules` right after "The control folder and its index" (and after #43's `### Picking a cap` if it has merged), plus the Key column in "The control folder and its index". `AGENTS.md` and `docs/agents/domain.md`: add **Ship rules** to their term lists. |
| #45 intake (rolling) | Stream skill: step 0's sentence on how work enters a stream; one new section `## Intake agents` right after `## Pause and resume` (or after "Replace a stream agent" if #44 has not merged); the intake agent's place in #43's cap count. |
| #62 ship branch name (rolling) | Stream skill step 6: the paragraph that cuts the ship branch (its name from the rules' pattern and the checks on it) and the push step (only the ship branch is pushed; a reship updates this stream's earlier push). |
| #64 commit messages (rolling) | Stream skill step 6: the ship commit's message and one new paragraph in the ship question for the commit split. Wave skill step 6: the merge commit's message pattern. Template "Repo and user rules": repeating a declared commit format. |
| #63 pull request shape (rolling) | Stream skill step 6: "Push and open" from the description onwards (title pattern, template filled from `/mattpocock-skills:pr`, draft, labels, reviewers, assignees, merge options, refused metadata reported after opening) and the ship question's lines for branch, title, template, metadata and merge options. |
| #65 release notes for ship rules (rolling) | The `## Ship rules and coding standards` section of `.scratch/matt-with-paseo-0.4.2/release-notes-0.4.2.md` (create the file with only that section if it does not exist yet); README `### Ship rules` (one pointer to the standards file, if missing); the #23 comment it asks for. |
| #58 release (rolling) | `plugins/matt-with-paseo/.claude-plugin/plugin.json` (version `0.4.2`) and the marketplace description if one names the version; `.scratch/matt-with-paseo-0.4.2/release-notes-0.4.2.md` except #65's section (create the file if it does not exist yet); README everywhere else, including the "Behaviour evals" case count and baseline wording and the file table's ADR range; the edits to #15 and #23 its criteria ask for. |

- New eval case: a new folder named `<streams|wave>-<ticket number>-<what it checks>`. Extending an existing case means adding a prompt line or a grader, as whole lines, inside that case.
- Shared tables (the status line table, the index's fields table, step 5's tick table): add only your own rows or column, as whole lines, keeping the order of the existing lines. The orchestrator resolves the merges.
- Outside your zone: name the file, the section and the change you would make in your report instead of editing it.

## Eval and review rules (the user's, for this stream)
- **No ticket agent runs `claude plugin eval`**, neither the full suite nor a single case. The full suite runs once, after the stream's last wave, run by the orchestrator.
- **At most one new eval case per ticket**, and only when its acceptance criteria name an eval. Every other "Eval: …" criterion extends an existing case that covers it. The one new case is designed to fail on your base commit's skill, checked by reading the case against the base skill text (`git show <base>:<path>`), not by running it. Your `Resolved:` comment names the new case, the extended cases, and says the case is written, not run.
- **No review of any kind on your ticket**: no `/mattpocock-skills:code-review`, no review sub-agent. The whole stream is reviewed once, after the last wave.
- Unit tests and the drift check still run before your last commit.

## Traps already hit
- Committing on the integration branch moves its HEAD. Commit only on your own branch; never check out or commit to `stream/matt-with-paseo-0-4-2`. Check: `git branch --show-current` before each commit.
- Never edit anything under `.git/` (it is shared by every worktree). Do not use bare `git stash`; commit a WIP commit on your branch instead.
- `git checkout -- <file>` throws away every uncommitted edit in that file. Revert one edit with the file-editing tool. Check: `git diff <file>` before you commit.
- Commit in small steps; leave no work outside git. Check: `git status --porcelain` is empty before your report. Delete any `evals/results/` folder and any stray empty folder a broken heredoc left (wave 2, #54).
- If a git command hangs, stop and report; do not delete lock files.
- Windows: `python3` is the Microsoft Store alias and fails (exit 49); run `python -B`. A lone single quote inside a Bash heredoc breaks parsing; write file content with the file-writing tool. Python needs `PYTHONIOENCODING=utf-8` for Vietnamese output. Git Bash's `/tmp` is not the path Windows Python sees; use `cygpath -w` or your temp directory.
- The reference Matt plugin is the user-scope install from the upstream `mattpocock` marketplace; keep references to `pr`, `implement-spec` and `retro` (operator decision, #66). Check: `python -B scripts/drift-check.py` exits 0 with no `--plugin-root`.
- A grader that cannot fail on the base skill proves nothing (waves 1–2: several cases scored 1.00 on the old skill and were dropped). Name, for your new case, the base-skill line that makes each grader fail.
- In wave 2 every agent hit the session limit at once and stopped mid-work. If you stop on a limit, your commits are your progress: commit before long steps, so a resume can pick up from `git log`.
- Put temporary files only in your temp directory, never loose in `%TEMP%` (wave 2, #46). Before reporting, list your temp directory and quote the result.

## Acceptance criteria are the contract
- A trap above, or an instruction an earlier ticket left in its comments, is guidance; your ticket's acceptance criteria are the contract.
- On conflict, follow the criteria and write the discrepancy and its reason in a comment on your issue; do not stop to ask.
- If the criteria themselves look wrong, stop that part, write the evidence in a comment on your issue, and add the `ready-for-human` label. Never rewrite the criteria.
- A criterion that asks for a change on another GitHub issue (#15, #23 for #58, #65) is part of your ticket: make it with `gh issue comment` or `gh issue edit` as the criterion says, and quote the link in your report.

## Resources
- Your private resources are listed in your prompt (a temp directory only). Use exactly that set.
- Shared, read-only: the run evidence in `D:\stream\` and `D:\matt-with-paseo-streams\` (it names internal hosts, projects and people, so nothing from it reaches the repo in a form that names them); the installed Matt plugins under `~/.claude/plugins/cache/`; Paseo's `~/.paseo/config.json` (read keys only).
- Machine-wide: the Paseo daemon, this machine and one usage limit are shared by every agent. Create no Paseo workspace, agent, heartbeat or schedule.

## Repo and user rules
- Skills, ADRs, README, release notes and all GitHub text in **English**. Commit messages follow the repo's style (`feat(streams): …`, `feat(wave): …`, `test(evals): …`, `docs(adr): …`, `docs(readme): …`, `chore(release): …`) and name your ticket (`(#NN)`). End every commit message with `Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>`.
- `CODING_STANDARDS.md` is the standard for every document an agent reads: numbered steps, a **Done when** per step that matches its body, choices as table rows, one concept one word, one source of truth.
- Accepted way to verify: turn each acceptance criterion into a check you can run (the drift check, the unit tests, a `grep` that must or must not match on the base and on your head, reading a section, a fixture script run in your temp directory) and record the command and its output. For an "Eval: …" criterion, reading the case against the base skill is the check.
- Do not push, do not tag, do not open a PR, do not close your issue.
- Credentials: never read, print or pass on a token or credential. A `gh` failure goes into your report, never worked around.
- Evidence standards: none declared.

## Done when:
- Commit to your branch. The orchestrator merges.
- Mark the ticket done with a comment starting `Resolved:` (leave the issue open; the orchestrator closes it after the merge), or add `ready-for-human` for the part a human must do. In it, write what you verified, with evidence, what remains open, and the eval-case line above.
- Clean up your temp directory; state the reason for anything you keep.
- Report back: a design summary, files touched, how you verified with evidence, work not done or still in doubt (every out-of-zone change you would make), and decisions the user must make.

## Wave agents

| Ticket | Agent id | Workspace id | Branch | Base commit | Private resources | Cleaned |
|---|---|---|---|---|---|---|
| #43 | 3ae30d22-ce38-49d6-b442-547b6f92bd19 | wks_86709db5db8db6f9 | `matt-with-paseo-0-4-2/wave3/43-capacity` | `13bc246` | temp `%TEMP%\matt-with-paseo-0-4-2-wave3-43` | [x] |
| #44 | bf234b11-64b0-4b8a-8b2b-ddb0e898a663 | wks_06af45c6e876daf4 | `matt-with-paseo-0-4-2/wave3/44-pause` | `13bc246` | temp `%TEMP%\matt-with-paseo-0-4-2-wave3-44` | [x] |
| #50 | dc1e5d04-867e-498d-b7f5-dc3b88530b02 | wks_b48b81153176e823 | `matt-with-paseo-0-4-2/wave3/50-after-ship` | `13bc246` | temp `%TEMP%\matt-with-paseo-0-4-2-wave3-50` | [x] |
| #55 | 61a44eca-5e38-433c-8e85-fe222f341927 | wks_c9ef684fecd3ed39 | `matt-with-paseo-0-4-2/wave3/55-troubleshooting` | `13bc246` | temp `%TEMP%\matt-with-paseo-0-4-2-wave3-55` | [x] |
| #61 | 02e52c1a-89c4-460b-a5ca-668d8e4b8540 | wks_f0242862dc1f809d | `matt-with-paseo-0-4-2/wave3/61-ship-rules` | `13bc246` | temp `%TEMP%\matt-with-paseo-0-4-2-wave3-61` | [x] |
| #45 | a74ee1bc-f8cc-4616-8d90-72c53c3c2807 | wks_e66b776ffed5b5c5 | `matt-with-paseo-0-4-2/wave3/45-intake-agents` | `3ed2741` (rolling start) | temp `%TEMP%\matt-with-paseo-0-4-2-wave3-45` | [x] |
| #58 | 8294d94d-c38f-4349-9b24-f584740c038d | wks_a70a0151c002e174 | `matt-with-paseo-0-4-2/wave3/58-release-0-4-2` | `9556ea3` (rolling start) | temp `%TEMP%\matt-with-paseo-0-4-2-wave3-58` | [x] |
| #62 | fde44b8e-a7e3-412f-ba6c-3cc34d0ed3aa | wks_0a5ca736a283c157 | `matt-with-paseo-0-4-2/wave3/62-ship-branch-name` | `9556ea3` (rolling start) | temp `%TEMP%\matt-with-paseo-0-4-2-wave3-62` | [x] |
| #64 | dc22621c-9d26-4256-bb5c-82080169fe3b | wks_88cf06dc96b2858d | `matt-with-paseo-0-4-2/wave3/64-commit-messages` | `9556ea3` (rolling start) | temp `%TEMP%\matt-with-paseo-0-4-2-wave3-64` | [x] |
| #64 (replacement 1/2) | e5b1e0ae-24a4-4fbb-bf2b-10ace2ba97d3 | wks_88cf06dc96b2858d | `matt-with-paseo-0-4-2/wave3/64-commit-messages` | `9556ea3` | temp `%TEMP%\matt-with-paseo-0-4-2-wave3-64` | [x] |
| #63 | 83a585f6-8e07-4b93-8c0d-42697a4e8699 | wks_a9fbea4aed37bf4d | `matt-with-paseo-0-4-2/wave3/63-pull-request-shape` | `7b789eb` (rolling start) | temp `%TEMP%\matt-with-paseo-0-4-2-wave3-63` | [x] |
| #65 | 49fa65a0-e4f5-42d0-9d5c-097ba65cb8f0 | wks_8ef1a07b6328e658 | `matt-with-paseo-0-4-2/wave3/65-ship-rules-release-notes` | `a295dc5` (rolling start) | temp `%TEMP%\matt-with-paseo-0-4-2-wave3-65` | [x] |
| stream review fixes | 5f1c1a4c-89c8-4887-8eb6-cfbe5f3b6c8c | wks_9756b76953a7782f | `matt-with-paseo-0-4-2/wave3/stream-review-fixes` | `e484061` | temp `%TEMP%\matt-with-paseo-0-4-2-stream-fixes` | [x] |

2026-09-29 09:15: #61 (303k of a 200k window, 3 commits plus much uncommitted work) and #45 (217k, no commit yet) ran past their context. Both were told to commit now and report, and #61 to stop iterating on an unrun fixture. Heartbeat `00bcf805` (every 15 min, expires 4h) watches them. git commands in this checkout were slow (over 60 s) at the same time.

2026-09-29, after #45 merged (326f518): `gh` fails with `tls: failed to verify certificate: x509: certificate signed by unknown authority` (two tries). #45 is merged but its close comment was not posted. #58's workspace `wks_a70a0151c002e174` (branch `matt-with-paseo-0-4-2/wave3/58-release-0-4-2`, base 326f518) exists with no agent: the spawn waits until `gh` works, since #58 must read its ticket and edit #15 and #23. Reported to the user; nothing worked around.

#61 merged as 9556ea3 (base 13bc246). Conflicts: README (`### Picking a cap` and `### Ship rules` both kept, cap first) and the index example (Forge, Key, Priority and Quota columns together). 13 unit tests OK, drift check exit 0. Its `Resolved:` comment was not posted: `gh auth status` says the keyring token for hanh9898 is invalid (after the TLS error). Waiting on the user to log `gh` in again: the close comments for #45 and #61, #61's `Resolved:` (its agent 02e52c1a is kept to post it), and the rolling start of #58, #62 and #64.

`gh` works again (the user: a FortiGate firewall on the network did SSL inspection). #45 closed; #61's `Resolved:` posted by its agent, then #61 closed; #58, #62 and #64 started by rolling start on 9556ea3.

Session reopened (heartbeat tick): #64's agent dc22621c is gone ("not found"). Its worktree held `ec00e80`, `f127eeb` and an uncommitted eval folder. Replaced by e5b1e0ae (Sonnet) in the same workspace, restart 1/2 for #64 in wave 3. `gh` fails with the TLS error again, so the replacement reads the ticket from a saved copy and writes its `Resolved:` text to a file instead of posting it.

**Operator decision (2026-09-29), waits on `gh`:** edit #15's Out of Scope line ("an intake process of the stream skill's own") into a pointer to ADR 0005, as #58 did for story 36. The TLS error is FortiGate SSL inspection (certificate issued by `Fortinet CN=FG200FT923927699`), and the user has been told. Until `gh` works: local git work only.
**Pending `gh` actions:** edit #15; close comments for the tickets merged meanwhile; `Resolved:` comments of #62 and #64; #63 and #65 need their ticket text (saved copies under `/tmp/t/`).

`gh` works again (api.github.com certificate issued by Sectigo, no longer through FortiGate). Done: #15's Out of Scope line now points to ADR 0005 (comments on #15 and #58). No ticket was merged during the outage, so there were no close comments to post, and no `Resolved:` file had been written yet. #62's agent had stopped idle mid-read with no commit, and was prompted to continue. #64's replacement was told to post its own `Resolved:`.

#64 merged as 7f97fff and #62 as 7b789eb (one conflict in step 6 "cut it": #62's naming table plus #64's ship commit message, taken from the same reading). #63 started on 7b789eb.

#63's agent 83a585f6 ended a turn on an API connection error (ECONNREFUSED), with 1 commit and eval work uncommitted. The network came back (`gh` OK). The same agent got a resume prompt: not a replacement, so no restart spent.

#63 merged as a295dc5. #65, the last ticket, started on a295dc5.

Wave 3 cleaned: 11 tickets merged, every row stopped, clean and merged, and archived with its workspace (agent dc22621c was already gone). Temp directories removed, heartbeat `00bcf805` deleted. Per the user's rules there was no step 7 review for this wave; the whole stream is reviewed next.

## Stream review

User's rule: one review of the whole stream after the last wave. Fixed point `ec29c8e`, head `cdb0f2d` (143 commits, 176 files). It ran in the orchestrator's session with two read-only sub-agents. **Standards: 8 findings; Spec: 6 findings**, one known item no longer holding (the **Ship branch** definition agrees everywhere). Deduplicated below, every row goes to one fix pass.

| # | Where | Finding | Fix | Axis |
|---|---|---|---|---|
| S1 | Stream skill, "Replace a stream agent" | Opens "the one procedure that archives a stream agent", but step 5's merged-stream row (#50) also archives one | Say it is the one procedure that replaces a stream agent; name step 5's close-out as the other archive | Std 1, Spec 1 |
| S2 | Stream skill, Pause and resume / "Supervise one-for-one" | After a real restart the agents are gone, so each paused stream spends a restart ("Gone from `paseo ls` → spends one"), and a step-7 `held until <other> ships` may be lost on replacement | An agent gone while its stream is `paused` spends no restart; its replacement is spawned with the holds the status line records | Std 2, Spec 5 |
| S3 | Stream skill, Intake agents; step 5 tick table; "Split the cap into quotas" | Two notes say "out of this ticket's zone … not added here": no tick row re-checks "wait until quiet" for `held for <skill> intake`, and the cap walk does not take the intake agent's slot | Add the tick row and the cap line; delete the two notes | Std 3, Spec 4 |
| S4 | Stream skill steps 1, 3, and "Replace a stream agent"; wave skill step 6 | The `wave merge message` pattern is "told to this run by the stream skill", but step 3's fixed spawn command carries no ship rules, so #59 story 26 goes unmet | Step 3 and the replacement spawn send the resolved `wave merge message` pattern after the command (an initial-prompt line or a `send_agent_prompt`), and the step's Done when checks it | Std 4, Spec 2 |
| S5 | `evals/wave-64-merge-message-pattern` | It states the pattern as given, so it cannot catch S4's missing handoff | Extend an existing stream case (for example `streams-61-ship-rules`) with a grader on the spawn or relay carrying the pattern, not a new case | Std 5 |
| S6 | Stream skill step 5, the machine-choking row | Restates the diagnosis instead of pointing to TROUBLESHOOTING's two Environment entries (#55) | Point to them | Std 6, Spec 3 |
| S7 | Stream skill, the index's Quota field | "Empty while the stream has no stream agent … or shipped", but no step blanks it, and a shipped stream keeps an idle agent | Rewrite the clause to what the steps write | Std 7 |
| S8 | `evals/streams-61-ship-rules` | Graders `no-setup-stop` and `overdue-tick-covers-invoice-close` also pass on the base skill (#61's own note) | Replace them with ship-rules-specific checks, or drop them | Spec 6 |

Skipped: Standards 8, `docs/agents/domain.md`'s generic GLOSSARY walkthrough. It predates the stream (written by `setup-matt-pocock-skills`, before `ec29c8e`), so trimming it would be out of the stream's scope. It is left for a separate ticket.

**Outcomes of the stream fix pass** (agent 5f1c1a4c, branch `matt-with-paseo-0-4-2/wave3/stream-review-fixes`, merged as `2bf35cd`; 13 unit tests OK, drift check exit 0, no markers; workspace archived). All fixed, none skipped: S1 S2 `caf0344` · S3 S6 `763f3b6` · S4 S7 `4ca0653` · S5 S8 `22ff3e5`. S5 extends `streams-61-ship-rules` with the grader `relays-merge-message-pattern`. S8 drops two graders that also passed on base.

## Final eval run

Integration head `c1f955c`, run once from `plugins/matt-with-paseo`: `CLAUDE_CODE_EFFORT_LEVEL=medium claude plugin eval --model sonnet -j 2 --runs 1 --ablation none --scaffold --trust-plugin --no-publish .`
- **Model** sonnet (every case), **effort** medium, **runs per case** 1, **no comparison arm** (`--ablation none`), judge model left at its default. Duration 402 s, cost $4.40, **exit 1**.
- **29 cases**: 7 at `ec29c8e`, 22 added by this stream. **25 ran; 4 did not load**: `streams-39-question-round` ("case.yaml must be a YAML object"), and `streams-44-pause`, `streams-49-ship-branch`, `streams-61-ship-rules` (YAML parse error on line 3, an unquoted value).
- **16 of 25 scored 1.00.** Below 1.00:

| Case | Score | Failing grader |
|---|---|---|
| streams-40-silent-supervision | 0.80 | writes-last-tick (pattern not found) |
| streams-41-hung-agents | 0.67 | kills-and-replaces (judge PASS FAIL FAIL) |
| streams-51-overlap-and-need | 0.50 | need-yields-merge-or-hold (PASS FAIL FAIL) |
| streams-52-answer-and-machine | 0.50 | status-line-drops-answer (FAIL PASS FAIL) |
| streams-63-pull-request-shape | 0.33 | names-missing-mandatory-section (FAIL FAIL FAIL) |
| wave-54-repro-and-no-code-flow | 0.50 | docs-ticket-no-code-flow (FAIL FAIL FAIL) |
| wave-64-merge-message-pattern | 0.33 | ticket-01-pattern (pattern not found) |
| wave-not-configured (a base case) | 0.67 | stops-at-setup (FAIL PASS FAIL) |

With one run per case, a split judge vote (PASS FAIL FAIL) may be noise, but a unanimous FAIL or a missing regex pattern is a real miss. Report: `plugins/matt-with-paseo/evals/results/2026-09-29T04-48-01-009Z/report.html`.

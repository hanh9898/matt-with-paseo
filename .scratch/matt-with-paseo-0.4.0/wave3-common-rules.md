# Common rules for wave 3 (tickets #16, #17, then by rolling start #18, #19, #20, #21)

Waves of 0.4.0 continue the numbering of 0.3.0 (waves 1 and 2, in `.scratch/matt-with-paseo-0.3.0/`), so the `wave=<N>` agent label never names two waves.

## Graph
`{#16, #17✓} → {#18, #19, #20, #21} (rolling start at 1489a0c) → #22⛔(←#16…#21) → #23👤`

| Ticket | Status | Blocked by | Wave |
|---|---|---|---|
| #16 Wave skill takes optional stream and quota arguments | ready for agent | - | 3 |
| #17 Stream skill runs one stream end to end | resolved (merged ea35025) | - (edge to #16 dropped, see #17's comments) | 3 |
| #18 Many streams under one agent cap, questions in one round | ready for agent | #17 | 3 (rolling start, base 1489a0c) |
| #19 Reconcile loop and one-for-one supervision | ready for agent | #17 | 3 (rolling start, base 1489a0c) |
| #20 Ship a stream: push and open its pull request | ready for agent | #17 | 3 (rolling start, base 1489a0c) |
| #21 Warn when two streams change the same file | ready for agent | #17 | 3 (rolling start, base 1489a0c) |
| #22 Release 0.4.0 | ready for agent | #16–#21 | after #16–#21 |
| #23 Acceptance run: two streams in one repository | ready for human | #22 | human, after #22 |

## Context
- Your worktree branches off `continue-9d6d8bfc` at `560705dd5db9f2775c6f9ee3c41e87577c036a29`, unless your prompt names another base commit (a ticket started mid-wave). Run `git branch --show-current` before every commit; commit only to your own branch.
- This repo **is** the `matt-with-paseo` plugin. Edit files **inside your worktree** only. Never touch `~/.claude/skills/matt-with-paseo/`: it is the installed copy running this orchestrator.
- Read before you start, in this order: your ticket **and its comments**; the spec #15; ADRs `docs/adr/0001` to `0004`; the design record `.scratch/streams/grilling-settled.md` (decisions T1–T7); `docs/agents/issue-tracker.md`, `docs/agents/domain.md`. Read issues with `gh issue view <n> -R hanh9898/matt-with-paseo --comments`. The prototype diagram `.scratch/streams/prototype.html` is optional.
- **The seam is fixed.** The wave skill's interface is exactly two optional arguments, `stream <slug>` and `quota <N>`, as written in ADR 0002 and #15. No ticket renames, adds or drops an argument. #16 implements them; #17 writes the stream skill against them without waiting for #16.
- Standing rules: the skills keep only orchestration; Matt's method is pointed to (always with the `mattpocock-skills:` prefix) or read at run time, never copied. Coin no term where Matt or the wave skill already has one; the stream skill defines only **Stream**.
- 1 other agent works the other ticket of this wave in parallel, on another branch. Work only on your own ticket.
- Do not end your turn while work you started still runs in the background; the rule and why are in the template's Context section, and it covers the review sub-agents of `mattpocock-skills:code-review`.

## Existing interfaces to reuse
- `python -B scripts/drift-check.py` (exit 0 = no stale Matt reference) and `python -B -m unittest discover -s scripts` (9 tests at the base commit). How to run them is in the README's Contributing section.
- The wave skill (`skills/matt-with-paseo/`) as released in 0.3.0: its steps, template and troubleshooting are the behaviour #16 must keep unchanged when `stream` is absent.
- Matt's installed skills: `~/.claude/plugins/marketplaces/mattpocock/skills/`. Paseo reference: `~/.claude/skills/paseo/SKILL.md` (tool shapes, labels, heartbeats, `paseo ls -g --label`).

## File zones
- **#16** writes only in the wave skill's folder: `skills/matt-with-paseo/SKILL.md`, `COMMON-RULES-TEMPLATE.md`, `TROUBLESHOOTING.md`.
- **#17** writes only in the new folder `skills/matt-with-paseo-streams/` (any files it needs there) and in `scripts/drift-check.py` and `scripts/test_drift_check.py`.
- Neither ticket edits `README.md` or `.claude-plugin/plugin.json`; both belong to #22. Report anything you think they need in your issue comment.

## Traps already hit
- Committing on the integration branch after the base commit is written moves HEAD. Commit only on your own branch; never check out or commit to `continue-9d6d8bfc`.
- Never edit anything under `.git/` (it is shared by every worktree).
- Do not use bare `git stash`; commit a WIP commit on your branch instead.
- Commit in small steps; do not leave work outside git.
- If a git command hangs, stop and report; do not delete lock files.
- A worktree directory is named by a slug, not by its branch: use `git branch --show-current`.
- Windows: a lone single quote inside a Bash heredoc breaks parsing; write file content with the file-writing tool. Python needs `PYTHONIOENCODING=utf-8` for Vietnamese output; run Python with `-B` so no `__pycache__` lands in the repo. Git Bash's `/tmp` is not the path Windows Python sees; use `cygpath -w` or a path under your temp directory.
- Background work: see Context; it was hit twice in wave 1.

## Acceptance criteria are the contract
- A trap here, or an instruction an earlier ticket left in its comments, is guidance; your ticket's acceptance criteria (issue body plus its comments) are the contract.
- On conflict, follow the criteria and write the discrepancy and its reason in a comment on your issue; do not stop to ask.
- If the criteria themselves look wrong, stop that part, write the evidence in a comment on your issue, and add the `ready-for-human` label. Never rewrite the criteria.

## Resources
- No database, port or service; the repo has no `paseo.json`. Your only private resource is the temp directory named in your prompt.
- Shared, read-only: the integration checkout `C:\Users\HBLAB_OPMS\.paseo\worktrees\298b4o4g\fragile-dragonfly`, Matt's installed skills, `~/.claude/skills/`, other issues.
- Do not create Paseo agents, workspaces or heartbeats to try your skill; running the skills for real is #23's job.

## Repo and user rules
- Skills, README and all GitHub text (issue comments, commit messages) in **English**. End every commit message with `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`.
- Match the surrounding style of the wave skill: numbered steps, a **Done when** line per step, tables for choices, no copied Matt method.
- Accepted way to verify: turn each acceptance criterion into a check you can run (the drift check, the tests, a `grep` that must or must not match, reading a section) and record the command and its output, red before your change where the criterion is new.
- Do not push, do not tag, do not open a PR, do not close your issue.
- Evidence standards: read `none declared`; it is not copied here.

## Done when:
- Commit to your branch. The orchestrator merges.
- Before the last commit: run `/mattpocock-skills:code-review` with your base commit as the fixed point, wait for both sub-agents inside the same turn, fix the findings, and write the number of findings per axis and the outcome of each into a comment on your issue.
- Comment on your issue: what you changed, each acceptance criterion with its check and evidence, anything left open. Leave the issue open and its label unchanged; the orchestrator closes it on merge. For a part a human must do, add the `ready-for-human` label and say why.
- Clean up your temp directory; state the reason for anything you keep.
- Report back: a design summary, files touched, how you verified with evidence, work not done or still in doubt, and decisions the user must make.

## Wave agents

| Ticket | Agent id | Workspace id | Branch | Base commit | Private resources | Cleaned |
|---|---|---|---|---|---|---|
| #16 | bbd66b8b-3816-46c2-857b-532501b3f5e9 | wks_b41f8da6e0d9bce7 | wave3/16-wave-stream-args | 560705d | temp C:\Users\HBLAB_OPMS\AppData\Local\Temp\wave3-16 | ✓ |
| #17 | b9459e25-fc04-4de8-aa73-6cbc786f43e3 | wks_7a22274fb66d31c1 | wave3/17-stream-skill | 560705d | temp C:\Users\HBLAB_OPMS\AppData\Local\Temp\wave3-17 | ✓ |
| #18 | 01401d97-c793-445f-8f67-eab250659a4d | wks_f3a5a548eea98c74 | wave3/18-cap-and-rounds | 1489a0c | temp C:\Users\HBLAB_OPMS\AppData\Local\Temp\wave3-18 | ✓ |
| #19 | 3e0a7953-dd13-40fb-bd5e-889d68ee16a2 | wks_edadce591822cf8b | wave3/19-reconcile | 1489a0c | temp C:\Users\HBLAB_OPMS\AppData\Local\Temp\wave3-19 | ✓ |
| #20 | 10d06a11-275c-46df-9561-210cd14b8a90 | wks_f00beb91cf52ef93 | wave3/20-ship | 1489a0c | temp C:\Users\HBLAB_OPMS\AppData\Local\Temp\wave3-20 | ✓ |
| #21 | 85acacc3-9e7d-4fe4-b9b7-c803e06a61ab | wks_41e5e8c7ec3087c6 | wave3/21-overlap-warning | 1489a0c | temp C:\Users\HBLAB_OPMS\AppData\Local\Temp\wave3-21 | ✓ |
| #24 | 4c2a5d8e-0010-493d-8f4f-909b1cc927d4 | wks_c90b41980e5bea97 | wave3/24-seam-fixes | b315a71 | temp C:\Users\HBLAB_OPMS\AppData\Local\Temp\wave3-24 | ✓ |
## Log

- 15:23 #16 and #17 spawned on base 560705d (the #17 edge to #16 was dropped at step 2 with the user's agreement; the seam is fixed by ADR 0002). Heartbeat `wave3-watch` (id 2b32b0a1, every 10 min, expires after 3 h) created at spawn, because both flows end in `code-review`, whose background sub-agents made two wave 1 agents stop with no notification.
- 15:4x #16 reported "finished" with "Still waiting on the two review sub-agents": the background-work trap again, despite the rule in Context. No artifacts yet (no issue comment); treated as still working, per step 5. `wave3-watch` already covers it. Trap stays for the next wave, now with evidence that a written rule alone does not stop it.
- 16:0x #17 passed step 5 (4 commits, 3 files in its zone, 11 tests OK, drift check exit 0, review Standards 5 / Spec 4 with outcomes) and merged as ea35025; issue #17 closed.
- 16:0x Coordinator commit 1489a0c on the integration branch: placeholder headings `## 5. Reconcile and supervise`, `## 6. Ship the stream`, `## 7. Warn when streams change the same file` at the end of the stream skill, so the four rolling-start tickets write in separate places.
- **Rolling start at base 1489a0c: #18, #19, #20, #21 join wave 3.** File zones, all inside `skills/matt-with-paseo-streams/SKILL.md`, which is the only file these four tickets edit:
  - **#18** writes in the section `## The index` (the agent cap and priority), in step 3 only where the quota is decided, and in step 4 (batched question rounds).
  - **#19** writes only between `## 5. Reconcile and supervise` and the next heading.
  - **#20** writes only between `## 6. Ship the stream` and the next heading.
  - **#21** writes only between `## 7. Warn when streams change the same file` and the end of the file.
  - Nobody edits the Inputs section, steps 0 to 2, `README.md`, `.claude-plugin/plugin.json` or `scripts/`. A change you need outside your zone goes into a comment on your issue; the seam review of step 7 handles it.
  - Replace your own placeholder line; do not rename your heading.
- 16:1x #18, #19, #20, #21 spawned on base 1489a0c; their prompts repeat the background-work rule. Heartbeat 2b32b0a1 replaced by `wave3-watch` 3498dca2 (every 10 min, expires after 3 h) watching #16 and #18-#21.
- 16:2x #21 passed step 5 (2 commits, only its section 7, 11 tests OK, drift 0, review Standards 4 / Spec 3 with outcomes) and merged as f7b393c; issue #21 closed. Seam notes for step 7: step 4 (#18) must accept the overlap warning as an item in a question round; the reconcile loop (#19) must not treat a stream held at wave approval as failed; ship (#20) must say when a shipped stream stops counting as open for step 7.
- 16:2x #20 passed step 5 (2 commits, only its section 6, 11 tests OK, drift 0, review Standards 2 / Spec 4 with outcomes) and merged as 19b4721; issue #20 closed. Seam notes for step 7: step 4 (#18) should point to the ship question; step 5's tick (#19) should call step 6's last-stage check; step 6 handles GitHub remotes only (user decision).
- 16:3x #16 found idle by `wave3-watch` with no finish notification (self-started turn after its review sub-agents, as predicted). Passed step 5 (6 commits, SKILL.md and TROUBLESHOOTING.md only, 29 checks, review Standards 5 / Spec 3 with outcomes) and merged as 4d970a4; issue #16 closed. Seam note for step 7: the stream skill names the integration branch `stream/<slug>` while #16's troubleshooting warns git refuses `<slug>/...` beside a branch named exactly `<slug>`; check the two agree.
- 16:4x #18 passed step 5 (3 commits, index section + step 3 quota + step 4, 29 checks, review Standards 4 / Spec 3 with outcomes) and merged as 206852c; issue #18 closed. Seam notes: step 3's Done when line edited at the zone edge; a stream waiting on the cap has no stream agent on purpose, so #19's tick must not respawn it nor count a boundary archive against the restart budget; archive-and-respawn of #18 and #19 should be one procedure.
- 16:5x #19 passed step 5 (3 commits, only its section 5, 9 checks, review Standards 3 / Spec 3 with outcomes) and merged as e1609df; issue #19 closed. All six wave-3 tickets merged; no placeholder left. Heartbeat `wave3-watch` 3498dca2 deleted. Seam notes: step 0 should run a tick instead of going straight to step 4; step 5 writes status-line items step 4 and the index do not define; step 6's gap row re-fires unless step 6 records its question; open doubt whether archiving a stream agent touches its ticket agents (parent-agent-id label) -> check in #23 or by probe.
- 28/09 00:1x Step 7 seam review (fixed point 560705d, run in this session with two fresh sub-agents): Standards 4 findings, Spec 5, plus 1 found by the coordinator. User decisions: one fix agent on a fresh workspace; Owner is the one word; the branch-name rule is explained once (wave troubleshooting); shipping must support GitLab as well as GitHub. Probe C1 run by the coordinator: archiving a parent agent archives its running children, so no step may archive a stream agent while its ticket agents run. Fix ticket #24 opened (sub-issue of #15, blocks #22), spawned on base b315a71 (probe C1 committed); heartbeat wave3-watch-24 (every 10 min, expires after 3 h).
- 28/09 01:0x #24 passed step 5 (2 commits, both skills, 22 item checks red 1/21 then green 22/22, review Standards 10 / Spec 3 with outcomes) and merged as 5c85d98; issue #24 closed; heartbeat wave3-watch-24 deleted. Three Paseo behaviours it could not verify were added to #23 as a comment.

## Review

Fixed point `560705d` (wave 3's first base), run in this session with two fresh-context sub-agents, seam findings only.

**Standards: 4 findings**
1. The Agent cap did not mention the wave skill's step 7 review and fix agents: **fixed** in #24 (cap line, plus one sentence in the wave skill capping step 7 at N agents).
2. Archive-and-respawn written twice (step 4, step 5): **fixed** in #24 (one `## Replace a stream agent` procedure, pointed to from steps 4 and 5).
3. "Owner" and "requester" for one concept: **fixed** in #24 (Owner, defined once).
4. The `<slug>` versus `<slug>/...` branch rule explained twice: **fixed** in #24 (the stream skill points to the wave skill's troubleshooting entry).

**Spec: 5 findings, plus 1 from the coordinator**
1. The Status field did not list what steps 5-7 write: **fixed** (one status-line table).
2. Step 0 sent a reopened session to step 4 instead of a tick: **fixed**.
3. Step 5's ship row re-fired every tick: **fixed** (guarded by the status line).
4. Step 7 counted shipped streams as open: **fixed**.
5. Step 4 did not carry step 6's ship question and step 7's warning: **fixed**.
6. (coordinator) "Should run" included a stream waiting on the cap, and a boundary archive could count against the restart budget: **fixed**.

**Decisions and additions from the review round:** shipping supports GitLab as well as GitHub (**done** in #24, forge chosen from the remote and the tracker configuration); probe C1 found `archive_agent` on a parent archives its running children, so a stream agent is archived only when no wave-labelled agent of its stream runs (**done** in #24). **Waiting on the user:** #24 moved the context respawn to the wave boundary, and a held check at a boundary lets a stream run one more wave over the cap. **Waiting on #23:** three Paseo behaviours listed in #23's comments.
- 28/09 01:1x Step 8: all seven rows checked (agent idle, worktree clean, branch merged), agents and workspaces archived (directories removed), temp directories already gone; every row marked cleaned. `paseo ls -g --label wave=3` lists nothing; no wave-3 heartbeat remains. The probe C1 agents ran in this checkout's own workspace, which is not archived.
- 28/09 01:1x Correction: the temp directory `wave3-20` was still there, empty (#20's report said it was cleaned); removed by the coordinator. Next wave: check temp directories at step 8 instead of trusting the report.

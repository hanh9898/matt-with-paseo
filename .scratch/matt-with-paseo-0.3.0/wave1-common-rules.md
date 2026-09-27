# Common rules for wave 1 (tickets #2, #3, #4, #5, #6, #7, #8, #10, #9, #11)

## Graph
`{#2, #3, #4, #5, #6, #7, #8} → #9(←#3,#5) · #10(←#8) → #11(←#5,#9) → #12(←#2…#11) → #13👤`

| Ticket | Status | Blocked by | Wave |
|---|---|---|---|
| #2 Drift check for Matt skill references | ready-for-agent | - | 1 |
| #3 Locating step keeps only the stages it can detect | ready-for-agent | - | 1 |
| #4 One vocabulary: Wave, Integration branch, Common rules | ready-for-agent | - | 1 |
| #5 Spawning points to Matt instead of copying him | ready-for-agent | - | 1 |
| #6 A finished report always means the work is done | ready-for-agent | - | 1 |
| #7 Traps are guidance, acceptance criteria are the contract | ready-for-agent | - | 1 |
| #8 Wave labels, recovery by label, and agent stop controls | ready-for-agent | - | 1 |
| #9 Triage roles read from the target repo | ready-for-agent | #3, #5 | rolling start after #3 and #5 merge |
| #10 Use the target repo's paseo.json for setup and ports | ready-for-agent | #8 | rolling start after #8 merges |
| #11 Evidence standards slot and review profile | ready-for-agent | #5, #9 | after #9 |
| #12 Release 0.3.0 | ready-for-agent | #2–#11 | last |
| #13 Acceptance wave on a real target repo | ready-for-human | #12 | human |

## Context
- Your worktree branches off `continue-9d6d8bfc` at `1d80000ea1d00045f4e334a5e01dd5b40b2eb4e5`, unless your prompt names another base commit. Run `git branch --show-current` before every commit; commit only to your own branch.
- This repo **is** the `matt-with-paseo` skill. You edit the files under `skills/matt-with-paseo/` (and `README.md` where your zone says so) **inside your worktree**. Never touch `~/.claude/skills/matt-with-paseo/`: that is the installed copy running this wave's orchestrator.
- Read before you start: the spec, GitHub issue #1 **and its comments** (one comment amends the locating step: stages A and D stay, only B and C go to `ask-matt`); your own ticket issue; `docs/agents/issue-tracker.md` and `docs/agents/domain.md` (the vocabulary lives in the words block at the top of the skill; there is no `GLOSSARY.md`). Read issues with `gh issue view <n> -R hanh9898/matt-with-paseo --comments`.
- The decisions behind every ticket, with their evidence, are in `.scratch/improve-matt-with-paseo/` of the integration checkout (`map.md` indexes them; each `issues/NN-*.md` holds one decision under `## Answer`; `probes-07.md` holds the Paseo measurements). Read them when your ticket's reason is unclear. That folder is a finished wayfinder map: **read-only**, never edit it.
- Standing rule of this release: the skill keeps only orchestration. Anything that is Matt's method is a pointer by skill name (always with the `mattpocock-skills:` prefix) or is read at run time from the target repo; never copy Matt's method in. Never coin a term where Matt already has one.
- 6 other agents are working the remaining tickets of this wave in parallel, on other branches, in the same files. Work only on your own ticket and stay inside your file zone below.

## Existing interfaces to reuse
- Matt's installed skills, the source of truth for anything the skill points to: `~/.claude/plugins/marketplaces/mattpocock/skills/` (branch `release/v1.3`). Read `engineering/ask-matt/SKILL.md` before writing any routing sentence.
- The Paseo reference skill: `~/.claude/skills/paseo/SKILL.md` (the `create_agent` shape is there).
- The tracker: `gh` against `hanh9898/matt-with-paseo`, as described in `docs/agents/issue-tracker.md`.

## File zones
The skill's main file is shared by every ticket. Edit only your zone; do not reflow, reword or renumber anything outside it. If your ticket needs a change outside your zone, do not make it: write it in your report as a follow-up.

| Ticket | Main skill file | Common rules template | Troubleshooting guide | README / other |
|---|---|---|---|---|
| #2 | — | — | — | the new drift-check script (a new file of your choosing, not inside `skills/`), and the README's **Contributing** section (how to run it) |
| #3 | frontmatter `description`; step 0 from its first line **through** the paragraph "Present three things to the user…" and its **Done when**, **excluding** the recovery sweep (the three bullets starting "`git worktree list`…", "`list_agents` for titles…", "Every background job…") and the list "Then take each unfinished ticket…" plus the paragraph "Once every ticket of the wave is done…" | — | — | README **How it works** section (the stage table and the prose around it) |
| #4 | the words block only ("Three words used throughout:" and its three bullets) | the `## Done means` heading and its first line only (rename to the "Done when:" form) | the one reference to that heading (the entry "Install is green but the real run fails.") | — |
| #5 | step 4 from the sentence "The **flow** is the chain of skills…" **through** the paragraph "If the wave's first agent reports it cannot find a skill…" (the flow table and the three paragraphs after it); add the `create_agent`-shape pointer as a new sentence at the start of this zone | — | — | — |
| #6 | step 5 in full; in step 4 only the paragraph "Leave `notifyOnFinish` at its default…" | add one bullet at the **end** of the `## Context` section of the template frame | — | — |
| #7 | step 3 in full | the `## Traps already hit` section; add the acceptance-criteria contract rule as a **new section right after it** | the intro paragraph under the title (the sentence about copying a trap into the next wave) | — |
| #8 | in step 0 only the recovery sweep bullets, the list "Then take each unfinished ticket…", and the paragraph "Once every ticket of the wave is done…"; in step 4 only the numbered items 1 and 2; step 8 in full | — | append new entries at the **end** of the `## Agents` section (cancel / kill / archive; answering a question-type permission) | — |

Where two zones sit next to each other (template sections, step 0), leave one blank line between your text and your neighbour's so the merge stays clean.

## Traps already hit
- Committing a file on the integration branch after the base commit is written moves HEAD (wave 6 and 7 had to fix the base by hand). For agents: commit only on your own branch; never check out or commit to `continue-9d6d8bfc`.
- Agents wrote into `.git/info/exclude`, which every worktree shares (wave 6). Never edit anything under `.git/`.
- Bare `git stash` in a shared repo: another session can pop your entry. Do not stash; commit a WIP commit on your branch instead.
- Work sat outside git for two days (876 lines). Commit in small steps as you go.
- `git commit` hung for more than 120 s on the shared index once. If a git command hangs, stop and report; do not delete lock files.
- A worktree directory is named by a slug, not by its branch. Get the branch with `git branch --show-current`, never from the path.
- Windows shell: in this environment Bash commands with a lone single quote inside a heredoc fail to parse. Write file content with the file-writing tool, then commit in a separate command. Python needs `PYTHONIOENCODING=utf-8` to print Vietnamese.
- Paseo sends no finish notification for a turn you start on your own after a background command. **Do not end your turn while work is running in the background**; wait for it inside the same turn. Your "finished" must mean finished.

## Resources
- No database, port or service in this wave. Your only private resource is the temp directory named in your prompt; put scratch files there, not in the repo.
- Shared, read-only: the integration checkout `C:\Users\HBLAB_OPMS\.paseo\worktrees\298b4o4g\fragile-dragonfly`, Matt's installed skills, `~/.claude/skills/`, the GitHub issues of other tickets.

## Repo and user rules
- The skill, README and all GitHub text (issue comments, commit messages) are in **English**. End every commit message with `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`.
- Match the surrounding style of the skill: plain imperative sentences, bold for defined words, tables for mappings, "**Done when**:" lines per step. No new headings unless your ticket needs one.
- Accepted way to verify: this repo has no test suite. For text changes, turn each acceptance criterion of your ticket into a check you can run or read (a `grep` that must find or must not find a phrase, a walk-through of the changed step against a concrete repo state) and record the command and its output. For the drift check (#2), real runs on planted copies are the evidence.
- Do not push, do not open a PR, do not close your issue.

## Done means
- Commit to your branch. The orchestrator pushes and merges.
- Before the last commit: run `/mattpocock-skills:code-review` with your base commit as the fixed point, fix the findings, and write the number of findings per axis and the outcome of each into a comment on your ticket's GitHub issue.
- Comment on your ticket's GitHub issue (`gh issue comment <n> -R hanh9898/matt-with-paseo`): what you changed, each acceptance criterion with its check and evidence, anything left open. Leave the issue **open** and its label unchanged; the orchestrator closes it after the merge. If a part needs a human, add the `ready-for-human` label and say what.
- Clean up your temp directory; state the reason for anything you keep.
- Report back: a design summary, files touched, how you verified with evidence, work not done or still in doubt, follow-ups outside your zone, and decisions the user must make.

## Wave agents

| Ticket | Agent id | Workspace id | Branch | Base commit | Private resources | Cleaned |
|---|---|---|---|---|---|---|
| #2 | 565944d6-c1ad-458c-8361-affc5b2f4716 | wks_41a5217a0aca6c17 | wave1/2-drift-check | 1d80000 | C:/Users/HBLAB_OPMS/AppData/Local/Temp/wave1-2 | [x] |
| #3 | 02c58976-275e-4171-b1d8-2eb5d5067ff6 | wks_989a4e393409d6bc | wave1/3-locating-step | 1d80000 | C:/Users/HBLAB_OPMS/AppData/Local/Temp/wave1-3 | [x] |
| #4 | 5ef77899-94cf-47f8-90d9-cc547e7fe56b | wks_dac4ff03c4e30a68 | wave1/4-vocabulary | 1d80000 | C:/Users/HBLAB_OPMS/AppData/Local/Temp/wave1-4 | [x] |
| #5 | 75c0b529-0136-4098-a428-112caccdbed3 | wks_f78f6c55516933b8 | wave1/5-spawn-pointers | 1d80000 | C:/Users/HBLAB_OPMS/AppData/Local/Temp/wave1-5 | [x] |
| #6 | bd29baea-e271-49de-a760-bbbb753e9ecf | wks_ad36363d18a26a74 | wave1/6-finished-means-done | 1d80000 | C:/Users/HBLAB_OPMS/AppData/Local/Temp/wave1-6 | [x] |
| #7 | 7c060896-565d-4a5e-b08b-1c1129146c4a | wks_a317ef286bd657d6 | wave1/7-traps-contract | 1d80000 | C:/Users/HBLAB_OPMS/AppData/Local/Temp/wave1-7 | [x] |
| #8 | e16dece0-300b-4d3b-8541-c66bff56278f | wks_9939fb405b9ee512 | wave1/8-labels-stop | 1d80000 | C:/Users/HBLAB_OPMS/AppData/Local/Temp/wave1-8 | [x] |
| #10 | 84c29437-f098-425b-ab6f-126e83c433e3 | wks_c4da25a0592c35ac | wave1/10-target-paseo-json | 57b3893 | C:/Users/HBLAB_OPMS/AppData/Local/Temp/wave1-10 | [x] |
| #9 | d8595b52-4ea5-40df-8405-1ac809de173a | wks_801045214bd0b343 | wave1/9-triage-roles | ad41fea | C:/Users/HBLAB_OPMS/AppData/Local/Temp/wave1-9 | [x] |
| #11 | 9c0a8374-eefd-44d6-b2b7-5187c99c8185 | wks_3e456e79eae0bfaf | wave1/11-evidence-standards | a02fcba | C:/Users/HBLAB_OPMS/AppData/Local/Temp/wave1-11 | [x] |
| #14 (seam fixes) | 7b9ce1e7-8e24-4a7a-b1a5-56d9c2e9b656 | wks_55531dcc2822d0cf | wave1/14-seam-fixes | 2fed66b | C:/Users/HBLAB_OPMS/AppData/Local/Temp/wave1-14 | [x] |

## Log

- 08:49 #3 reported "finished" while its two `code-review` sub-agents were still running in the background: 2 commits, no issue comment, review not done. Treated as still working. Heartbeat `e019f0fa` (every 10 min, expires 11:49 UTC) created. Rule clarification sent to #2, #4, #5, #6, #7, #8: `code-review`'s sub-agents count as background work; wait for them inside the same turn. **Trap for the next wave's rules.**
- 08:51 Orchestrator mistake: the clarification prompts were sent with `notifyOnFinish: false`, so turns they start report to nobody. #6 also reported "finished" while waiting for its reviewers. Heartbeat `e019f0fa` deleted and replaced by `wave1-watch` covering all 7 agents (every 10 min, expires after 3 h). **Trap for the next wave's rules:** never send a prompt to a wave agent with `notifyOnFinish: false`.
- 08:5x #4 passed step 5 (2 commits, 3 lines in its zone, orchestrator re-ran the `Done` grep: none left) and merged. Issue #4 closed.
- 09:0x #7 passed step 5 (2 commits, hunks only in its zone) and merged cleanly after #4. Issue #7 closed. Open for the user: keep or drop the pointer to `mattpocock-skills:retro` in step 3 (orchestrator text, not an agent flow).
- 09:1x #5 passed step 5 and merged. Issue #5 closed. Carried to step 7: unprefixed Matt skill names outside any zone (SKILL.md step 1 to-spec/to-tickets mention, step 5 and 6 code-review) and a second hand-written invocability list in README.md. #9 still waits on #3.
- 09:2x #8 and #2 passed step 5 and merged (db0d0e2, 57b3893). Drift check exits 0 on the integration tree; 9 tests pass. Issues #8 and #2 closed. #8 found Paseo exposes no workspace label in MCP or CLI: agents carry the wave label, workspaces are found through them (add to the Paseo reports).
- Rolling start: #10 unblocked by #8. Base commit `57b389369f86a8a1354cdc0165302c2a886f7f67`. **Zone for #10:** in step 4, only the private-resources wording of numbered item 2 plus one new sentence right after item 2; in the README, a new subsection at the end of **Requirements** for target-repo `paseo.json` notes. Do not touch step 0 (#3) or step 5 (#6), both still running.
- 09:3x #3, #6 (found idle with no notification by `wave1-watch`, reports complete on their issues) and #10 passed step 5 and merged. Head `ad41feac8b6a848a03b80b376e3d654ea6d0efd2`. Drift check exits 0, 9 tests pass. Issues #3, #6, #10 closed.
- Rolling start: #9 unblocked by #3 and #5. Base commit `ad41feac8b6a848a03b80b376e3d654ea6d0efd2`. **Zone for #9:** it runs alone, so any line of the skill, the template or the troubleshooting guide that names a triage state, plus step 1 (add the triage label file to what preparation reads). Leave `resolved` as is.
- Carried to step 7 (seam review): step 0's "reading its report from the ticket's comments" vs step 5 reading through `get_agent_activity` (#6); template's private-resources line still lists a port even when services are declared (#10); unprefixed Matt skill names in steps 1, 5, 6 and README's own invocability list (#5); troubleshooting "Install is green" entry copies a check into two places (#7).
- 09:4x `wave1-watch` deleted (all 7 original tickets passed step 5); replaced by `wave1-watch-9` for #9 only (every 10 min, expires after 2 h).
- 09:5x #9 passed step 5 and merged (a02fcba); label grep clean, drift check 0. Issue #9 closed; heartbeat `wave1-watch-9` deleted. Carried to step 7: README's stage table still hard-codes a triage label.
- Rolling start: #11 unblocked by #5 and #9. Base commit `a02fcba347e98fa2b6d47678cd0558d534a004c4`. **Zone for #11:** it runs alone: step 1, step 4's `code-review` sentence, step 7, the template's `## Repo and user rules`, and a README subsection on declaring the evidence standards file.
- 10:0x #11 passed step 5 and merged (2fed66b). Issue #11 closed; heartbeat `wave1-watch-11` deleted. Carried to step 7: step 0's "take each unfinished ticket" also meets the new `review` row; `code-review` still unprefixed in steps 5 and 6.
- #12 (release) is unblocked but **held back from rolling start on purpose**: the seam review edits the files #12 releases, so #12 opens after step 7.
- 10:1x Seam review run (fixed point 1d80000). Findings and the user's decisions recorded in issue #14 (created, sub-issue of #1, blocks #12). **Zone for #14:** it runs alone: any line of the skill files and README named in its issue.
- 10:3x #14 passed step 5 and merged (47e6af6). Issue #14 closed; heartbeat `wave1-watch-14` deleted.

## Review

- **Fixed point:** `1d80000ea1d00045f4e334a5e01dd5b40b2eb4e5` (the wave's first base; covers #9, #10, #11 started by rolling start). Run by the orchestrator with `mattpocock-skills:code-review`, seam findings only; both sub-agents awaited in the same turn.
- **Standards: 5 findings.** (1) README stage table hard-coded a triage label: fixed in #14. (2) Template private resources listed a port unconditionally: fixed in #14. (3) Step 0 read reports from ticket comments vs step 5 through agent activity: fixed in #14. (4) Unprefixed Matt skill names in steps 5-6 and README, and README's hand-written invocability list: fixed in #14 (list removed, points to step 4's flag rule). (5) Recovery blind to the `review` row: fixed in #14. Rejected by this axis: the "Install is green" duplication (pre-dates the wave).
- **Spec: 7 findings.** (1)-(4), (6) as above: fixed in #14. (5) "Install is green" copies a check into two places, against step 3's pointer rule: fixed in #14 (user decision: point). (7) The background-work rule did not name `mattpocock-skills:code-review`'s sub-agents, the failure seen twice in this wave: fixed in #14.
- **Decisions by the user (recorded in #14):** fix by one agent on a fresh workspace; remove the README list; point instead of copy in troubleshooting; keep the `retro` pointer in step 3 and the fixed-port warning in step 4.
- **Left for later:** the README's opening "It locates…" list does not mention the wayfinder-map case (candidate for #12). Workspace labels are not exposed by Paseo MCP/CLI (add to the Paseo reports).
- 10:4x Step 8: all 11 rows passed the three checks (agent idle, worktree clean, branch merged); agents and workspaces archived, temp directories removed, every row checked. No heartbeat of the wave remains (e019f0fa, d582395e, a6f8701a, 523b1b27, 9ccb08c7 all deleted). Ticket branches kept locally (merged).

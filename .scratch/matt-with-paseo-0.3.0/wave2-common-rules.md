# Common rules for wave 2 (ticket #12)

## Graph
`{#2✓, #3✓, #4✓, #5✓, #6✓, #7✓, #8✓, #14✓} → #9✓ · #10✓ → #11✓ → #12 → #13👤`

| Ticket | Status | Blocked by | Wave |
|---|---|---|---|
| #2–#11, #14 | resolved (closed, merged) | - | 1 |
| #12 Release 0.3.0 | ready for agent | #2–#11, #14 (all merged) | 2 |
| #13 Acceptance wave on a real target repo | ready for human | #12 | human, after #12 |

## Context
- Your worktree branches off `continue-9d6d8bfc` at `70f47930e7baac5f1dd44bf0fa28cb7e26b0079a`. Run `git branch --show-current` before every commit; commit only to your own branch.
- This repo **is** the `matt-with-paseo` skill. Edit files **inside your worktree** only. Never touch `~/.claude/skills/matt-with-paseo/`: it is the installed copy running this orchestrator.
- Read before you start: your ticket, GitHub issue #12 **and its comments** (one comment adds a README item); the spec #1 and its comments; `docs/agents/issue-tracker.md`, `docs/agents/domain.md`. Read issues with `gh issue view <n> -R hanh9898/matt-with-paseo --comments`.
- Wave 1's full log and seam review: `.scratch/matt-with-paseo-0.3.0/wave1-common-rules.md` in the integration checkout (read-only). The decisions behind the release: `.scratch/improve-matt-with-paseo/` (read-only; `issues/11-co-che-phat-hanh.md` holds the release decision).
- Standing rule: the skill keeps only orchestration; Matt's method is pointed to (always with the `mattpocock-skills:` prefix) or read at run time, never copied. Coin no term where Matt has one.
- You are the only agent of this wave.

## Existing interfaces to reuse
- `python -B scripts/drift-check.py` (exit 0 = no stale Matt reference) and `python -B -m unittest discover -s scripts` (9 tests). How to run them is in the README's Contributing section.
- Matt's installed skills: `~/.claude/plugins/marketplaces/mattpocock/skills/`. Paseo reference: `~/.claude/skills/paseo/SKILL.md`.
- Previous releases (`git log --oneline`, `git tag`): bump `.claude-plugin/plugin.json`, tag after merge to main, no changelog.

## File zones
- Only agent of the wave: any file the ticket and its comment name (the plugin manifest, `README.md`). Do not edit the skill's step text unless the drift check forces it; if it does, say so in your report.

## Traps already hit
- Committing on the integration branch after the base commit is written moves HEAD. Commit only on your own branch; never check out or commit to `continue-9d6d8bfc`.
- Never edit anything under `.git/` (it is shared by every worktree).
- Do not use bare `git stash`; commit a WIP commit on your branch instead.
- Commit in small steps; do not leave work outside git.
- If a git command hangs, stop and report; do not delete lock files.
- A worktree directory is named by a slug, not by its branch: use `git branch --show-current`.
- Windows: a lone single quote inside a Bash heredoc breaks parsing; write file content with the file-writing tool. Python needs `PYTHONIOENCODING=utf-8` for Vietnamese output; run Python with `-B` so no `__pycache__` lands in the repo.
- **Background work (seen twice in wave 1):** do not end your turn while work runs in the background. `/mattpocock-skills:code-review` runs its two review sub-agents in the background: wait for both results inside the same turn, fix the findings, comment on your issue, then end your turn. The rule is also in the template's Context section.

## Acceptance criteria are the contract
- A trap here or an instruction from an earlier ticket is guidance; your ticket's acceptance criteria (issue #12 body plus its comment) are the contract. On conflict, follow the criteria and record the discrepancy and why in a comment on your issue, without stopping to ask. If the criteria themselves look wrong, stop that part, record the evidence, add the `ready-for-human` label, and never rewrite the criteria.

## Resources
- No database, port or service. Your only private resource is the temp directory named in your prompt.
- Shared, read-only: the integration checkout `C:\Users\HBLAB_OPMS\.paseo\worktrees\298b4o4g\fragile-dragonfly`, Matt's installed skills, `~/.claude/skills/`, other issues.

## Repo and user rules
- Skill, README and all GitHub text (issue comments, commit messages) in **English**. End every commit message with `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`.
- Match the surrounding style of the README and skill.
- Accepted way to verify: turn each acceptance criterion into a check you can run (the drift check, the tests, a `grep` that must or must not match, reading the manifest) and record the command and its output.
- Do not push, do not tag, do not open a PR, do not close your issue. Tagging and pushing are the maintainer's: write the exact commands in your issue comment.
- Evidence standards: none declared.

## Done when:
- Commit to your branch. The orchestrator merges.
- Before the last commit: run `/mattpocock-skills:code-review` with your base commit as the fixed point, wait for both sub-agents, fix the findings, and write the number of findings per axis and the outcome of each into a comment on issue #12.
- Comment on issue #12: what you changed, each acceptance criterion with its check and evidence, the maintainer's tag and push commands, anything left open. Leave the issue open and its label unchanged.
- Clean up your temp directory; state the reason for anything you keep.
- Report back: a design summary, files touched, how you verified with evidence, work not done or in doubt, and decisions the user must make.

## Wave agents

| Ticket | Agent id | Workspace id | Branch | Base commit | Private resources | Cleaned |
|---|---|---|---|---|---|---|
| #12 | a2e8a12b-319b-4525-a122-5e85f39d9d3f | wks_705ac1bb6577aa22 | wave2/12-release-0.3.0 | 70f4793 | C:/Users/HBLAB_OPMS/AppData/Local/Temp/wave2-12 | [x] |

## Log

- 10:05 #12 spawned. Heartbeat `wave2-watch` (every 10 min, expires after 2 h) created at spawn, because the flow ends in `code-review`, whose background sub-agents made two wave 1 agents stop with no notification.
- 10:2x #12 passed step 5 (manifest 0.3.0, drift check 0, 9 tests) and merged (ccada67). Issue #12 closed; heartbeat `wave2-watch` deleted. The agent stopped normally and the finish notification did arrive this time.

## Review

Not applicable: one-ticket wave, reviewed by its agent (Standards 0 findings; Spec 2 scope notes, one fixed, one kept with reason).

- Step 8: agent idle, worktree clean, branch merged; agent and workspace archived, temp directory removed, row checked. No heartbeat remains.

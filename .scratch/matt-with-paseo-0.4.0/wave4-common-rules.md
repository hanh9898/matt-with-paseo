# Common rules for wave 4 (ticket #22)

## Graph
`{#16✓, #17✓, #18✓, #19✓, #20✓, #21✓, #24✓} → #22 → #23👤`

| Ticket | Status | Blocked by | Wave |
|---|---|---|---|
| #16–#21, #24 | resolved (closed, merged) | - | 3 |
| #22 Release 0.4.0 | ready for agent | #16–#21, #24 (all merged) | 4 |
| #23 Acceptance run: two streams in one repository | ready for human | #22 | human, after #22 |

## Context
- Your worktree branches off `continue-9d6d8bfc` at `5a32a7141b7a71aca71368ec394dfbe710826c67`. Run `git branch --show-current` before every commit; commit only to your own branch.
- This repo **is** the `matt-with-paseo` plugin. Edit files **inside your worktree** only. Never touch `~/.claude/skills/matt-with-paseo/`: it is the installed copy running this orchestrator.
- Read before you start: your ticket, issue #22 **and its comments** (one comment lists README items from wave 3); the spec #15; both skills as merged (`skills/matt-with-paseo/`, `skills/matt-with-paseo-streams/`); ADRs `docs/adr/0001` to `0004`; `docs/agents/issue-tracker.md`, `docs/agents/domain.md`. Read issues with `gh issue view <n> -R hanh9898/matt-with-paseo --comments`.
- Wave 3's log and seam review: `.scratch/matt-with-paseo-0.4.0/wave3-common-rules.md` in the integration checkout (read-only). The 0.3.0 release (wave 2, `.scratch/matt-with-paseo-0.3.0/wave2-common-rules.md`) is the precedent: bump the manifest, README install options copy the manifest, tag after merge to main, no changelog.
- Standing rules: the skills keep only orchestration; Matt's method is pointed to (always with the `mattpocock-skills:` prefix), never copied; coin no term; the README describes, it does not restate the skills' steps.
- You are the only agent of this wave.
- Do not end your turn while work you started still runs in the background; the rule and why are in the template's Context section. It covers the two review sub-agents of `mattpocock-skills:code-review`, and was hit again in wave 3.

## Existing interfaces to reuse
- `python -B scripts/drift-check.py` (exit 0 = no stale Matt reference, both skills and the README) and `python -B -m unittest discover -s scripts` (11 tests at the base commit).
- Matt's installed skills: `~/.claude/plugins/marketplaces/mattpocock/skills/`. Paseo reference: `~/.claude/skills/paseo/SKILL.md`.

## File zones
- Only agent of the wave: `README.md` and `.claude-plugin/plugin.json`. Do not edit either skill unless the drift check forces it; if it does, say so in your report.

## Traps already hit
- Committing on the integration branch after the base commit is written moves HEAD. Commit only on your own branch; never check out or commit to `continue-9d6d8bfc`.
- Never edit anything under `.git/` (it is shared by every worktree).
- Do not use bare `git stash`; commit a WIP commit on your branch instead.
- Commit in small steps; do not leave work outside git.
- If a git command hangs, stop and report; do not delete lock files.
- A worktree directory is named by a slug, not by its branch: use `git branch --show-current`.
- Windows: a lone single quote inside a Bash heredoc breaks parsing; write file content with the file-writing tool. Python needs `PYTHONIOENCODING=utf-8` for Vietnamese output; run Python with `-B`. Git Bash's `/tmp` is not the path Windows Python sees; use `cygpath -w` or a path under your temp directory.
- Background work: see Context.
- A report said the temp directory was removed while it still existed (wave 3, #20). Before reporting, list your temp directory and quote the result.
- The manual install options must copy **both** skill folders and the manifest; test the copy commands into a scratch home under your temp directory, bash and PowerShell, and quote the resulting tree.

## Acceptance criteria are the contract
- A trap here, or an instruction in a comment, is guidance; your ticket's acceptance criteria (issue #22 body plus its comments) are the contract.
- On conflict, follow the criteria and write the discrepancy and its reason in a comment on your issue; do not stop to ask.
- If the criteria themselves look wrong, stop that part, write the evidence in a comment on your issue, and add the `ready-for-human` label. Never rewrite the criteria.

## Resources
- No database, port or service. Your only private resource is the temp directory named in your prompt.
- Shared, read-only: the integration checkout `C:\Users\HBLAB_OPMS\.paseo\worktrees\298b4o4g\fragile-dragonfly`, Matt's installed skills, `~/.claude/skills/`, other issues.
- Do not create Paseo agents, workspaces or heartbeats.

## Repo and user rules
- README and all GitHub text (issue comments, commit messages) in **English**. End every commit message with `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`.
- Match the surrounding style of the README.
- Accepted way to verify: turn each acceptance criterion into a check you can run (the drift check, the tests, a `grep` that must or must not match, reading the manifest, the install copy into a scratch home) and record the command and its output.
- Do not push, do not tag, do not open a PR, do not close your issue. Tagging and pushing are the maintainer's: write the exact commands in your issue comment.
- Evidence standards: read `none declared`; it is not copied here.

## Done when:
- Commit to your branch. The orchestrator merges.
- Before the last commit: run `/mattpocock-skills:code-review` with your base commit as the fixed point, wait for both sub-agents inside the same turn, fix the findings, and write the number of findings per axis and the outcome of each into a comment on issue #22.
- Comment on issue #22: what you changed, each acceptance criterion with its check and evidence, the maintainer's tag and push commands, anything left open. Leave the issue open and its label unchanged.
- Clean up your temp directory and quote the listing that shows it gone.
- Report back: a design summary, files touched, how you verified with evidence, work not done or in doubt, and decisions the user must make.

## Wave agents

| Ticket | Agent id | Workspace id | Branch | Base commit | Private resources | Cleaned |
|---|---|---|---|---|---|---|
| #22 | 2e3f7dd4-9101-49ca-86ba-407c89a98fb0 | wks_238a2d35e2e20ba6 | wave4/22-release-0.4.0 | 5a32a71 | temp C:\Users\HBLAB_OPMS\AppData\Local\Temp\wave4-22 | ✓ |

## Log

- 28/09 01:2x #22 spawned on base 5a32a71. Heartbeat `wave4-watch` (every 10 min, expires after 2 h) created at spawn, because the flow ends in `code-review`. README items from wave 3 added to #22 as a comment before spawning.
- 28/09 01:4x #22 passed step 5 (5 commits, README and manifest only, 20 checks, install copies tested in a scratch home, review Standards 2 / Spec 0 with outcomes) and merged as c84dcce; issue #22 closed; heartbeat `wave4-watch` deleted. The command-form doubt (`/matt-with-paseo` versus `/matt-with-paseo:matt-with-paseo` under a plugin install) was added to #23.

## Review

Not applicable: one-ticket wave, reviewed by its agent (Standards 2 findings, one fixed, one kept with reason; Spec 0).
- 28/09 01:4x Step 8: agent idle, worktree clean, branch merged, then agent and workspace archived (directory removed); temp directory checked gone by listing; row cleaned. `paseo ls -g --label wave=4` lists nothing; no heartbeat remains.

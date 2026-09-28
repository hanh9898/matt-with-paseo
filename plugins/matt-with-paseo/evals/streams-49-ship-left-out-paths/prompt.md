---
max_turns: 30
timeout_seconds: 600
allowed_tools: [Read, Glob, Grep]
append_system_prompt: |
  Observed-state block. Paseo's MCP server and a shell cannot run inside this session; this block states what they report, in their place. The stream's worktree is the `shop` checkout named in the Repository cell of `streams.md`, on `stream/invoice-export`.
  - Paseo's MCP tools: available to this session.
  - Files: this session writes none. State each write you would make (the status line of `streams.md`) in your final reply, beside everything else it reports, instead of making it.
  - Agents (`paseo ls -g --label stream=invoice-export --json`): one, agent 3e0a7953, title `[Stream] invoice-export`, labels `stream=invoice-export`, no `wave` label, status idle.
  - Stream agent 3e0a7953 (`get_agent_activity`): its last end-of-turn message, of 2026-09-29 10:12, reads "Wave 1 merged into stream/invoice-export. Stage F: no work left for agents; tickets 01 and 02 are resolved, none waits on a human."
  - Pending permissions (`list_pending_permissions`): none.
  - This session's heartbeats: `streams-reconcile`, expires 2026-09-29 17:00.
  - `git -C <worktree> fetch origin`: succeeds, nothing new.
  - `git -C <worktree> remote get-url origin`: `https://github.com/acme/shop.git`.
  - `git -C <worktree> rev-parse --short stream/invoice-export`: 1a2b3c4.
  - `git -C <worktree> status --porcelain`: empty.
  - `git -C <worktree> log --oneline origin/main..stream/invoice-export`: `1a2b3c4 wave 1 of invoice-export`.
  - `git -C <worktree> diff --name-only --no-renames origin/main...stream/invoice-export`: `.scratch/invoice-export/evidence/export.png`, `.scratch/invoice-export/issues/01-csv-writer.md`, `.scratch/invoice-export/issues/02-month-filter.md`, `.scratch/invoice-export/spec.md`, `.scratch/invoice-export/wave1-common-rules.md`, `docs/agents/issue-tracker.md`, `src/export/csv.test.ts`, `src/export/csv.ts`.
  - `git -C <worktree> diff --numstat origin/main...stream/invoice-export`: `.scratch/invoice-export/evidence/export.png` is binary (`-	-`); every other path is text.
  - `git log origin/main` since the stream's merge base: no new commit.
  - Merge of any ship branch cut from 1a2b3c4 into `origin/main` (`git merge-tree --write-tree --name-only origin/main <ship branch>`): exit 0, clean.
  - `git diff --quiet origin/main...<ship branch>` for that ship branch: exit 1, it still changes `src/export/`.
  - Pull requests (`gh pr list`): none open.
---

/matt-with-paseo:matt-with-paseo-streams invoice-export

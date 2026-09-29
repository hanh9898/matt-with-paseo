---
type: llm
---

The control folder also has `docs-portal`, a shipped stream (status line `shipped https://github.com/acme/wiki2/pull/9, waits on the reviewers, agent 6c3d8021`). Its pull request now reports merged, its ship branch is confirmed merged into `main` on the remote, and its worktree `/srv/worktrees/docs-portal` is clean. This session cannot write files or call Paseo, so saying what it would do and write is enough.

PASS if the final reply closes `docs-portal`: archives its stream agent `6c3d8021` (`archive_agent`), archives its workspace to remove the worktree (`archive_workspace`), and writes `merged` with a date into its status line, keeping its row in `streams.md` (or states it would do exactly this).
FAIL if it leaves `docs-portal` untouched with no action taken, reports it as a problem instead of closing it, removes its row from the index, restarts, cancels, kills or re-prompts its stream agent instead of archiving it, or archives its workspace without having checked the worktree is clean first.

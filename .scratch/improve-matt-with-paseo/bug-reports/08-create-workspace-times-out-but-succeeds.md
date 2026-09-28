# `create_workspace` returns a timeout after 120 s while the worktree is still being created

## Summary

On a loaded machine, `create_workspace` with `isolation: "worktree"` returned a timeout error after 120 s, but the git worktree had been created (or was still being checked out) on disk. The caller cannot tell from the error whether the workspace exists, half exists, or failed. Callers that retried got a second worktree or a name clash; callers that adopted the existing directory as a local workspace found it in a new Paseo project instead of the repository's, and those worktrees were later not removed by archiving.

## Reproduce

Reproduction pending: it needs a machine slow enough that a checkout takes more than 120 s. Proposed steps:

1. Pick a repository with a large working tree (tens of thousands of files) that already has a Paseo project.
2. Load the disk (for example two other large checkouts or a file copy running at the same time), or use a slow external disk.
3. Call `create_workspace` with `isolation: "worktree"`, `mode: "branch-off"`, and the repository's project.
4. When it returns a timeout, run `git worktree list` in the repository right away and again after a minute, and call `list_workspaces`.
5. Red: the call reports a timeout while the worktree appears (or keeps growing) on disk, and no workspace for it appears in `list_workspaces`. Green: the call waits for the checkout, or returns a workspace id that ends up ready, or rolls the worktree back.

## Expected and actual

| | Expected | Actual |
|---|---|---|
| Result of the call | a workspace id, or a failure with nothing left on disk | timeout error after 120 s |
| On disk | consistent with the result | worktree created; once, interrupted in the middle of its checkout |
| After the timeout | a way to find or finish the pending workspace | none; the caller adopts the directory by hand as a local workspace |
| Adopted directory | stays in the repository's Paseo project | landed in a new Paseo project (reported by the operator) |
| Clean-up | archiving removes the worktree | adopted worktrees had to be removed with `git worktree remove` by hand |

## Evidence

- Paseo daemon (version at the time of the run not recorded; CLI 0.8.0), Windows 11, 2026-09-28; one repository with five worktree streams, each creating one workspace per ticket. Times in UTC.
- About 03:27: one stream's `create_workspace` had timed out three times; its agent removed the orphaned worktrees and created them again.
- About 07:17: another stream's `create_workspace` for one ticket went past 120 s twice.
- About 08:03: a third stream's `create_workspace` went past 120 s all three times, including when run alone; one ticket's worktree was cut off in the middle of its checkout and had to be created again.
- About 09:38: the orchestrator's own `create_workspace` went past 120 s; the worktree was complete on disk, and it was adopted as a local workspace.
- A later wave of one stream stopped using `create_workspace` with worktree isolation and created the worktree with git, then adopted it as a local workspace.
- The machine was short of memory through the afternoon (0.5–2 GB free of 15.7 GB); at the worst point, about 10:50, `git status` took 67–212 s and the daemon's `git ls-files` timed out at 30 s (report 10).

## Current workaround and its cost

After a timeout, check `git worktree list`; if the worktree is there and complete, adopt it as a local workspace with the repository's project id passed explicitly; if it is partial, remove it and create it again. Each case costs the calling agent several extra turns, leaves worktrees that archiving does not remove, and depends on the caller remembering the project id.

## Suggested fix

Either make `create_workspace` wait for the worktree (or return a pending workspace id the caller can poll), or roll back what it created when it gives up. If a timeout must stay, say in the error whether the worktree exists, and let a later call adopt it into the same project.

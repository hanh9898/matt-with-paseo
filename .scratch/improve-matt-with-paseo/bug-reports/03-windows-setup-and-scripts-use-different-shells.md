# Windows: `worktree.setup` runs in PowerShell, `scripts` and terminals run in cmd, docs show sh syntax

## Summary

On Windows the three places Paseo runs commands use two different shells, and the `paseo.json` examples in the docs use sh variable syntax (`$PASEO_WORKTREE_PORT`), which silently expands to an empty string under PowerShell and stays literal under cmd.

## Reproduce

1. Commit this `paseo.json` on a branch and `create_workspace` with `isolation: "worktree"`, `mode: "branch-off"`, `baseBranch` set to that branch:

   ```json
   {
     "worktree": {
       "setup": "echo cmd=%PASEO_WORKTREE_PORT% sh=$PASEO_WORKTREE_PORT > setup-probe.txt"
     },
     "scripts": {
       "probe": { "command": "echo port=$PASEO_WORKTREE_PORT%PASEO_WORKTREE_PORT% > script-probe.txt" }
     }
   }
   ```

2. Read `setup-probe.txt` after the workspace is created.
3. `start_workspace_script` with `scriptName: "probe"`, then read `script-probe.txt`.
4. Separately, `create_terminal` and send `ping -n 11 127.0.0.1 > NUL; echo done`.

## Expected and actual

| Where | Expected (from docs) | Actual on Windows |
|---|---|---|
| `worktree.setup` | `$PASEO_WORKTREE_PORT` expands | runs in **Windows PowerShell**: file is UTF-16, `%VAR%` literal, `$PASEO_WORKTREE_PORT` **empty** (needs `$env:PASEO_WORKTREE_PORT`) |
| `scripts` | `$PASEO_WORKTREE_PORT` expands | runs in **cmd**: `%PASEO_WORKTREE_PORT%` → `53449`, `$PASEO_WORKTREE_PORT` literal |
| `create_terminal` | not specified | **cmd**: PowerShell-style `;` and `$(...)` are not interpreted, no error shown |

None of these fail loudly; the command "succeeds" with wrong values.

## Evidence

- Daemon 0.9.2, CLI 0.8.0, Windows 11 (10.0.26200), 2026-09-27.
- Workspace `wks_b6c457d1063cf26d` (archived), terminal `62068974-73df-4f42-a5c7-e3e45f344c2d` (killed).
- Docs: `https://paseo.sh/docs/worktrees.md` examples use `$PASEO_SOURCE_CHECKOUT_PATH`, `$PASEO_PORT`.

## Current workaround and its cost

Write setup in PowerShell syntax and scripts in cmd syntax, per platform; a `paseo.json` shared by macOS/Linux and Windows users cannot be written once.

## Suggested fix

Either run all three with one documented shell per platform (or let `paseo.json` choose one), or document which shell each uses on Windows, with a Windows example.

## Also noticed

`archive_workspace` returned `removedDirectory: false` for a worktree with untracked files, and no sign that `worktree.teardown` ran. Keeping a dirty worktree is sensible; the docs say teardown "runs during archive before deletion", so it is unclear whether teardown is skipped when deletion is skipped.

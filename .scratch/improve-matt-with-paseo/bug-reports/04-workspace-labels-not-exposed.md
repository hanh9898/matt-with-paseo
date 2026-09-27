# Workspace labels cannot be set or filtered through MCP or the CLI

## Summary

Paseo has workspace labels (0.5.0 changelog: "Added workspace labels for sidebar organization and filtering"), but an orchestrating agent cannot use them: `create_workspace` has no `labels` parameter, `list_workspaces` cannot filter by label, and `paseo workspace create` has no label option. Agent labels, by contrast, can be set at `create_agent` and filtered with `paseo ls --label`.

## Reproduce

1. Call the MCP tool `create_workspace` with `isolation: "worktree"`: its schema has no `labels` field.
2. Run `paseo workspace create --help`: no label option.
3. Call `list_workspaces`: no label filter.
4. Compare with agents: `create_agent` accepts `labels`, and `paseo ls -g --label wave=1 --json` returns exactly the agents carrying that label.

## Expected and actual

- Expected: an orchestrator that creates one workspace per task can tag each workspace (for example `wave=1`, `ticket=8`) and later list the workspaces of a batch by label, the same way it lists agents.
- Actual: workspace labels exist only in the daemon's internal protocol and the app sidebar. An orchestrator must find its workspaces indirectly, by matching the `cwd` of labelled agents against `list_workspaces` and `git worktree list`, which breaks for a workspace whose agent was never spawned or was already archived (the orphan case a recovery sweep most needs to find).

## Evidence

- Daemon 0.9.2, CLI 0.8.0, Windows 11, 2026-09-27.
- Observed while running a batch of 11 worktree workspaces with labelled agents; `paseo ls -g --label wave=1` returned all 11 agents, while no command listed the 11 workspaces by label.

## Current workaround and its cost

Label the agent, then map agent `cwd` to workspace. An interrupted spawn that created the workspace but not the agent leaves a workspace nothing can find by label.

## Suggested fix

Accept `labels` on `create_workspace` (MCP) and `paseo workspace create` (CLI), and a label filter on `list_workspaces` / `paseo workspace ls`, mirroring agents.

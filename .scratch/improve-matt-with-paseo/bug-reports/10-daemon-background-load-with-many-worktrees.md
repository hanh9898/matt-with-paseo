# The daemon's background git work grows with the number of worktrees and stalls its event loop on a loaded machine

## Summary

With many worktrees open, the daemon keeps running git in the background for every watched directory: file listing that includes ignored files, and periodic fetches, including a fetch that fails the same way every 3 minutes. On a machine already short of memory, these commands hit the daemon's 30 s git timeout over and over, dozens queue up, and the daemon's event loop stalls for up to 16 s. That is when agent turns, hooks and workspace creation slowed down and one agent hung (reports 05 and 08). The operator has no setting to reduce this work and no view of it outside the log.

## Reproduce

Reproduction pending: the numbers below come from the daemon log of the run. Proposed steps:

1. Open about 30 worktree workspaces of one large repository (tens of thousands of files each, some with large ignored folders such as `node_modules` or build output).
2. Add one project whose remote fails TLS verification (for example a self-signed certificate).
3. Keep the machine near its memory limit (for example with containers), and leave the daemon running for 30 minutes without agent activity.
4. Read `~/.paseo/daemon.log`: count `Git command timed out after 30000ms`, note the git queue's pending count, `ws_runtime_metrics.eventLoopDelay.maxMs`, and how often the failing fetch repeats.
5. Red: git timeouts every few minutes, a git queue in the tens, or event-loop delays of several seconds while no agent is active. Green: background git work stays bounded (and backs off after repeated failures) as worktrees are added.

## Expected and actual

| | Expected | Actual |
|---|---|---|
| Background git per watched directory | bounded, skippable for idle worktrees | 34 watched directories, about 89 800 files |
| Listing files | fast, not scanning ignored folders | `git ls-files` including ignored files timing out at 30 s |
| A fetch that keeps failing | backs off, reported once | fails with `SEC_E_UNTRUSTED_ROOT` every 3 minutes |
| Git queue under load | small | 45–76 pending |
| Event loop | well under a second | `eventLoopDelay.maxMs` 9 571, 10 536, 9 244, 5 159, **16 475** ms between 10:49 and 10:51 UTC |

## Evidence

- Paseo daemon (version at the time of the run not recorded; CLI 0.8.0), Windows 11, 15.7 GB RAM with 8 GB given to WSL, 2026-09-28; one repository with five streams and about 15 Claude processes running.
- Daemon log: 22 `Git command timed out after 30000ms` between 10:40 and 12:00 UTC, two of them on the worktree of the agent that hung (10:49:35, 10:50:17 UTC).
- Hooks of every agent timed out at 17–21 s against 10 s in the same window, and `git status` in an agent took 67–212 s.
- The daemon's event loop was back to 0.3–1.7 s from 10:54:42 UTC, as the load dropped.
- Unrelated noise in the same log: the app asked for a subagent `provider:<agent>:toolu_…` of a Bash call and got `Agent not found` (`agent.timeline.list_prompts.request`).

## Current workaround and its cost

Lower the number of agents and worktrees open at once, archive finished workspaces early, and fix or remove the project with the failing remote. That caps the parallel work the operator can run on one machine, and nothing tells the operator which part of the daemon's load comes from which directory.

## Suggested fix

Bound the background git work: skip or slow it for worktrees with no running agent, list files without scanning ignored folders, back off a fetch after repeated identical failures (and report it once), and cap the git queue. A daemon status line with the watched directory count, git queue length and event-loop delay would let an orchestrator see the machine choking.

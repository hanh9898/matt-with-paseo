# Paseo facts

Verified Paseo behaviour that surprised a run, one row each. Read the table that matches before a change that spawns, prompts, cancels, archives or waits on Paseo agents, before writing a `paseo.json`, and when Paseo does something the skills do not explain: the row may already say why. What a user of the plugin will notice is in the README's "Known Paseo behaviour".

- **Basis** says how the fact was learned. `reproduced` means a loop repeated it, `measured` one probe, `read` a tool schema, the docs or git, `seen` an observation made live or in a run and not repeated. A `seen in a run` row is a warning to act on, not a rule to lean on.
- **Seen on** is the Paseo version recorded when the fact was seen. `version not recorded` means nobody wrote it down; it is left as it is, not filled in from today's Paseo.
- A row changes when a newer Paseo changes the fact: replace it with the new fact and the version it was seen on.

## Turns and notifications

| Fact | Basis | Seen on |
|---|---|---|
| A finish notification goes to the agent that sent the prompt with `notifyOnFinish`, not to the parent agent. A session that did not send the prompt receives none | measured in a probe, 2026-09-27 | daemon 0.9.2, CLI 0.8.0 |
| A turn an agent starts on its own after a background command sends no finish notification, and `attentionTimestamp` stays on the earlier turn. The earlier turn's "finished" arrives before the work is done | reproduced 10 of 10, 2026-09-27 | daemon 0.9.2, CLI 0.8.0 |
| A server plugin's `agent.turn_ended` hook fires for such a turn (`turnId` `autonomous-turn-N`, against `foreground-turn-N`) and carries `agent.parentAgentId`. `agents.ref(<any agent id>).send(...)` reaches an agent other than the one that fired the event | measured in a probe, 2026-09-27 | daemon 0.9.2, CLI 0.8.0 |
| `cancel_agent` on a turn stuck in a tool call is recorded as `turn_canceled`, and the next `send_agent_prompt` shows as a running turn while the provider only queued it | seen once in a run, 2026-09-28 | daemon version not recorded, CLI 0.8.0 |

## Permissions and modes

| Fact | Basis | Seen on |
|---|---|---|
| A `kind: "question"` permission is answered with `respond_to_permission`, `behavior: "allow"` and an `updatedInput` holding `questions` plus `answers`, a map from each question's text to the chosen label. Without `answers` the agent read the answer as ambiguous, twice | measured with `answers`, 2026-09-27; without, seen in two waves, 2026-09-24 and 2026-09-25 | daemon 0.9.2, CLI 0.8.0 |
| A pending permission does not expire: one was still pending after 6 min 10 s | measured in a probe, 2026-09-27 | daemon 0.9.2, CLI 0.8.0 |
| `set_agent_mode` on a running agent takes effect from its next tool call. A request already pending stays pending until answered | measured in a probe, 2026-09-27 | version not recorded |
| A child agent's four-part question waited, unseen by its parent, until the user asked about that stream. In the probe of 2026-09-27 the caller that created the child did receive `needs permission` | seen once in a run, 2026-09-28 | daemon version not recorded, CLI 0.8.0 |

## Workspaces and worktrees

| Fact | Basis | Seen on |
|---|---|---|
| `create_workspace` takes `baseBranch` as a ref: `origin/main` is the remote-tracking branch, `refs/heads/main` the local one, and a bare `main` prefers the local one. A bare commit SHA has not been tried | read from the tool schema and the `paseo` skill, 2026-09-27 | version not recorded |
| `create_workspace` with `isolation: "worktree"` can return a timeout after 120 s while the worktree is created or half checked out, and `list_workspaces` then lacks it | seen several times in a run, 2026-09-28 | daemon version not recorded, CLI 0.8.0 |
| Archiving a parent agent archives and interrupts its running child agents | measured in a probe, 2026-09-28 | version not recorded |
| `archive_workspace` deleted two worktrees that held untracked files and an edited `paseo.json` (`removedDirectory: true`). It returned `removedDirectory: false` once, cause not found | measured, 2026-09-27 | daemon 0.9.2, CLI 0.8.0 |
| Every worktree of one project shares one git stash stack: their `git rev-parse --git-common-dir` is the same | read from git on three worktrees, 2026-09-27 | version not recorded |
| Paseo neither stops nor warns when several agents share one `cwd`: three agents lived in one `cwd` at once | seen live, 2026-09-27 | version not recorded |
| `create_workspace` has no `labels` parameter and `list_workspaces` no label filter, so a workspace is found through the labelled agent that runs in it. Agents take `labels`, and `paseo ls --label` filters them | read from the tool schemas and `--help`, 2026-09-27 | daemon 0.9.2, CLI 0.8.0 |
| `list_agents` filters by `cwd`, `statuses`, `sinceHours` and `includeArchived`, not by title or label | read from the `paseo` skill | version not recorded |

## Configuration and commands

| Fact | Basis | Seen on |
|---|---|---|
| On Windows `worktree.setup` runs in Windows PowerShell, `scripts` and `create_terminal` in cmd. The sh form `$VAR` in the Paseo docs expands to nothing in PowerShell and stays literal in cmd, with no error | measured, 2026-09-27 | daemon 0.9.2, CLI 0.8.0 |
| A service with a fixed `port` gets that port in every worktree of the project. On Windows the processes all bind it, one worktree's proxy serves another's files and `health` stays healthy. Without `port`, Paseo assigns one per worktree | measured, 2026-09-27 | daemon 0.9.2, CLI 0.8.0 |
| `scripts` read the worktree's own `paseo.json` when they run, uncommitted edits included | measured, 2026-09-27 | daemon 0.9.2, CLI 0.8.0 |
| A terminal sends no notification when its command ends. Another agent reads its output with `capture_terminal` and the `terminalId` | measured in a probe, 2026-09-27 | daemon 0.9.2, CLI 0.8.0 |

## Status calls and heartbeats

| Fact | Basis | Seen on |
|---|---|---|
| `get_agent_status` is one snapshot (state, mode, pending permissions, `lastUsage`). `get_agent_activity` is the recent timeline as a curated summary, with an `updateCount` | called on a running agent, 2026-09-27 | version not recorded |
| The MCP has no heartbeat update tool: changing a heartbeat's task or cadence means `delete_heartbeat`, then `create_heartbeat` | read from the `paseo` skill | version not recorded |
| A heartbeat tick due while its session was mid-turn was not delivered later (twice). One heartbeat delivered nothing for about four hours before its expiry, and `list_schedules` does not list heartbeats | seen in a run, 2026-09-28 | daemon version not recorded, CLI 0.8.0 |

## Machine load

| Fact | Basis | Seen on |
|---|---|---|
| With 34 watched directories the daemon's background git work hit its 30 s timeout 22 times in 80 minutes and stalled its event loop for up to 16.5 s (`eventLoopDelay.maxMs` in `~/.paseo/daemon.log`). Agents' hooks and `git status` slowed with it | seen once in a run, 2026-09-28 | daemon version not recorded, CLI 0.8.0 |

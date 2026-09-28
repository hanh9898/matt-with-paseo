# Claude Code: a Bash command moved to the background finishes, its result never reaches the turn, and the turn cannot be interrupted

Product: Claude Code (and the Agent SDK it runs under Paseo), not Paseo itself.

## Summary

A Bash tool call that ran past its 120 s timeout was moved to the background. The background task completed (exit 0, full output on disk) and its completion was queued, but the `tool_result` never came back to the agent loop, so the turn never ended. Later interrupts and prompts were only queued (`enqueue` without `dequeue`); the turn stayed stuck until the process was closed about 50 minutes later. The machine was heavily loaded at the moment the command was moved to the background and had recovered two minutes later; the agent did not continue.

## Reproduce

Reproduction pending: the steps below are proposed from the diagnosis and have not been run yet.

1. In a throwaway Claude Code session (under Paseo or the Agent SDK), configure a `PreToolUse` and a `PostToolUse` hook that runs a `.cmd` (or shell script) sleeping about 15 s, above its `timeout: 10`, to imitate slow process spawns on a loaded machine.
2. Ask the agent to run `sleep 150; git status` in the foreground, so it passes the 120 s limit and is moved to the background, and let it finish 30–60 s after the move.
3. After the completion is queued, call `interrupt()` through the Agent SDK (or `cancel_agent` in Paseo), then send a new prompt.
4. Red: the transcript has `queue-operation enqueue` with no `dequeue`, or the turn does not abort within 2 minutes. Green: `[Request interrupted by user]` appears and the new prompt is dequeued.
5. Repeat about 20 times with and without the slow hook, and optionally with artificial CPU and disk load, to learn whether the slow hook is the deciding variable.

## Expected and actual

| | Expected | Actual |
|---|---|---|
| Background task completes | `tool_result` returned, turn continues | completion queued (`<task-id>…</task-id><tool-use-id>…</tool-use-id><status>completed</status>`), **no `tool_result`**, no hook record for that tool call |
| Interrupt before the move to the background (same session, 3 minutes earlier) | turn aborts | turn aborted: works |
| Interrupt and new prompt after the move | turn aborts, prompt runs | prompt only `enqueue`d, never `dequeue`d; turn never ends |
| Machine recovers | agent continues | agent stayed stuck 27 minutes after recovery, until it was archived |

## Evidence

- Claude Code 2.1.283, Windows 11, provider `claude`, model `claude-opus-5-5`, under Paseo (daemon version at the time of the run not recorded), 2026-09-28.
- Timeline from the session transcript (UTC):
  - 10:45:35 a Bash call is moved to the background after 120 s and completes normally (task `bxfwlh1c7`, exit 0; its `tool_result` "Command did not complete within its 120s timeout and was moved to the background" arrives at 10:49:07). The same path worked once.
  - 10:50:36 interrupt during a foreground Bash call: works (`[Request interrupted by user for tool use]`).
  - 10:51:09 Bash call `toolu_…dL6Ry6` (`git status --porcelain; git log --oneline -2; grep …`). This is the last `tool_use` of the session; it never gets a `tool_result`, and no Pre/PostToolUse hook record is written for it.
  - 10:54:18 the background task `bgzvxi871` completes with exit 0; its output file holds the full expected output; the completion is queued in the transcript with the matching `tool-use-id`.
  - 11:21:42 cancel plus a new prompt: the transcript records only `queue-operation enqueue`, no `dequeue`, no `[Request interrupted]`.
  - 11:40:20 the agent is archived; closing logs `ProcessTransport is not ready for writing` and `Claude query operation did not settle cleanly (close query interrupt)`.
- Tool latency in the session grew up to the hang: 12 s, 26 s, 124 s, 34 s, 107 s, 212 s, 67 s (interrupted), then no result.
- Load at the time (trigger, not sufficient cause): hooks timed out at 17–21 s against a 10 s limit (last hook record 10:51:02, `UserPromptSubmit` 20 974 ms), the Paseo daemon's event loop delay peaked at 16 475 ms, and `git` on the same worktree timed out at 30 s. From 10:54:42 the event loop delay was back to 0.3–1.7 s.
- Ruled out: OOM (the CLI itself wrote `enqueue` records 30 minutes after the hang, and the child command exited 0; no resource-exhaustion events), subagents (both had returned), an API or advisor stall (the last response ended with `stop_reason=tool_use`), and context limits.
- Not settled: which internal await does not resolve (the `PostToolUse` hook of a backgrounded call, or the move-to-background step itself). The CLI ran without debug logging.
- A read-only detector over transcripts flags the signature (an open `tool_use` followed only by `enqueue` records); on that day it flagged this session only.

## Current workaround and its cost

- Kill the agent (or close it) and resume the session, or start a new agent from the last commit; cancel plus prompt does not recover it (tried twice).
- Tell every agent to start any command that may take more than two minutes with `run_in_background` from the start, so the auto-background path is never taken.
- Until someone notices, the agent shows `running` and holds a slot; in the run it sat for about 50 minutes.

## Suggested fix

Make sure a Bash call moved to the background always returns its `tool_result` to the turn, and that `interrupt()` aborts a turn that is waiting on such a call. Writing a debug record when a backgrounded call's result or hook is still pending after N seconds would make the case diagnosable.

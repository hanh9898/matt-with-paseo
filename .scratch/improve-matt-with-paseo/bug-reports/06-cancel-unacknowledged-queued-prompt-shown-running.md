# `cancel_agent` reports success without the provider acknowledging it, and a prompt that is only queued shows as a running turn

## Summary

When a Claude agent's turn is stuck inside a tool call, `cancel_agent` followed by `send_agent_prompt` makes Paseo record `turn_canceled`, `turn_started` and a new user message, and the agent shows `running` on a new turn. The provider never acknowledged the cancel and never started the prompt: Claude Code only queued it behind the stuck turn. Nothing in Paseo's state tells the caller that the new turn is not running.

## Reproduce

Reproduction pending: it needs an agent whose turn is stuck in a tool call. Report 05 gives the proposed way to get one; the Paseo side would then be:

1. Get an agent into the state of report 05 (a backgrounded Bash call whose result never returns), or any turn that ignores the provider's interrupt.
2. Call `cancel_agent`, then `send_agent_prompt` with a short prompt ("reply OK").
3. Read `get_agent_status` / `list_agents`, `get_agent_activity`, and the provider's session transcript.
4. Red: Paseo shows a new running turn (`turn_started`, `lastUserMessageAt` moved) while the transcript has only `queue-operation enqueue` for the prompt and no `[Request interrupted]`. Green: either the cancel is acknowledged and the prompt runs, or Paseo reports that the cancel was not acknowledged.

## Expected and actual

| | Expected | Actual |
|---|---|---|
| `cancel_agent` on a turn the provider cannot interrupt | failure, or a state such as "cancel requested, not acknowledged" | treated as done: `turn_canceled` recorded, no log line, no error |
| The next `send_agent_prompt` | runs, or is shown as queued | shown as a new running turn (`turn_started`, `timeline:user_message`) while the provider only queued it |
| Later cancels | same | a third cancel about 13 minutes later was also recorded, with no effect |

## Evidence

- Paseo daemon (version at the time of the run not recorded; CLI 0.8.0), Claude Code 2.1.283, Windows 11, 2026-09-28.
- Stuck agent `8af25598` (full id in the run's records), turn stuck from 10:51:09 UTC on Bash call `toolu_…dL6Ry6` (see report 05).
- 11:21:42 UTC, parent cancels and sends a prompt. Paseo: `turn_canceled`, `turn_started`, `timeline:user_message`, `lastUserMessageAt=11:21:42.802Z`; daemon runtime metrics at 11:21:45 count one cancel and one start. Claude Code transcript: one `queue-operation enqueue`, no `dequeue`, no interrupt record; the transcript is not written again.
- ~11:34:45 UTC, one more `turn_canceled` in the metrics; the transcript is unchanged.
- 11:40:20 UTC, archiving the agent logs `ProcessTransport is not ready for writing` and `Claude query operation did not settle cleanly (close query interrupt)`: only then does Paseo see that the process was no longer taking input.
- For contrast, in the same session at 10:50:36 UTC a prompt that interrupted a normal foreground tool call worked: the transcript shows `[Request interrupted by user for tool use]`, then `enqueue` → `dequeue` of the new prompt.

## Current workaround and its cost

Do not trust `running` after a cancel. Check the provider transcript for a `dequeue` or a new user message within 2–3 minutes, and if there is none, kill the agent and resume or replace it. That needs file access to the provider's transcript, which an orchestrating agent working through MCP does not normally have; in the run the stuck agent looked busy for about 50 minutes.

## Suggested fix

Treat a cancel as done only when the provider acknowledges it (for Claude, the interrupt settles), and otherwise surface it, for example `cancelRequested` with a timestamp in `get_agent_status`. Show a prompt the provider has queued but not started as queued, not as a running turn.

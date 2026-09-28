# A turn the agent starts on its own (after a background command) sends no finish notification

## Summary

When an agent ends a turn while a background command is still running, the caller gets a "finished" notification for that turn. When the background command completes, the agent starts a new turn by itself and finishes the real work, but **that turn produces no finish notification**, and the agent's `attentionTimestamp` / `attentionReason` stay on the earlier turn. From the caller's side the agent reported "finished" too early and then went silent while it completed the work.

## Reproduce

Deterministic, 10 out of 10.

1. From an agent-scoped session, call `create_agent` with `notifyOnFinish` left at its default (`true`), provider `claude/claude-haiku-4-5`, and this `initialPrompt`:

   ```
   Step 1: run the shell command `ping -n 21 127.0.0.1 > NUL` with run_in_background set to true.
   Step 2: immediately end your turn by replying exactly: WAITING.
   Later, when you are told the background command completed, reply exactly: DONE
   ```

2. Wait about 40 seconds.

## Expected and actual

| | Turn 1 (`WAITING`) | Turn 2, started by the agent after the background command (`DONE`) |
|---|---|---|
| Expected | finish notification to the caller | finish notification to the caller |
| Actual | notification delivered: 10/10 | **no notification: 0/10** |

`get_agent_activity` shows turn 2 ran and replied `DONE` in all 10 agents. `list_agents` shows `updatedAt` 20–40 s after `attentionTimestamp`, and `attentionTimestamp` never moves to turn 2.

It also happens without being asked: Claude Code blocks a foreground `sleep`, so in a batch of 10 agents told only to "run `sleep 30` then reply OK", 5 moved the sleep to the background, ended the turn with "waiting…", and 4 of those later finished in a self-started turn with no notification.

## Evidence

- Daemon build 0.9.2 (`paseo daemon status`: `daemonVersion 0.9.2`, `cliVersion 0.8.0`), Windows 11, provider `claude`, models `claude-haiku-4-5` (probes) and `claude-opus-5-5` (caller).
- Caller agent `47538630-e6a2-47ac-b9a4-a7a0ac1ef9d6`; probe agents `[probe A2] 11`–`20`, created 2026-09-27 07:32 UTC, e.g. `e4b98cc2-3124-48b0-8485-cb7e385bed01`, `c8e3ccf9-7416-4336-b896-1e8fdd5ee54c`, `dc1df1c9-3a47-43f2-87ab-cc0411317da9` (archived after the test).
- A server plugin on `agent.turn_ended` **does** see turn 2: its `turnId` is `autonomous-turn-2` (turn 1 is `foreground-turn-1`), `outcome.kind` is `completed`, and `agent.parentAgentId` is set. So the daemon knows the turn ended; only the notification is missing.
- Related, observed in the same test: the notification goes to whoever sent the prompt for that turn with `notifyOnFinish`, not to the parent agent. A self-started turn has no such sender, which is probably why nobody is notified.
- Docs: `docs/orchestration.md` says "Your main agent receives a notification when the worker finishes"; nothing says a self-started turn is excluded.

## New evidence from the 2026-09-28 run

A twelve-hour run with three levels of agents (an orchestrating session, one agent per stream, ticket agents under each) on Windows 11, Claude Code 2.1.283, provider `claude`, model `claude-opus-5-5`; the daemon version at the time was not recorded. Times in UTC.

- **Ended while background work still ran, then went quiet.** Three ticket agents of one stream ended their turns cleanly (`stop_reason=end_turn` at 07:05, 07:17 and 07:26) while the two review subagents each had started were still running in the background. Their stream agent recorded them as "reported done, reviews still running in the background" and waited. No notification moved it on: at 07:34 all three ticket agents were idle, each ticket's deliverable was on disk (written 06:50, 07:05 and 07:13), no ticket was resolved, and the stream agent had had no activity since about 07:00. It resumed only when the orchestrator prompted it at 07:34. The stall cost about 30 minutes on the stream with the highest priority.
- **Notifications missing one level up.** Between about 03:00 and 09:22 the orchestrating session learned of four events from its stream agents only by reading their activity, not from a notification: a ticket merged, two waves closed, and a four-part question (see report 11). The run did not record whether these fell in turns the stream agents started on their own, so they support this report only as the same symptom.
- **A caller-side cause to rule out first.** Later in the run the orchestrator sent three notes to stream agents with `notifyOnFinish: false`, so the next turn end of those agents could not notify it. Those cases are excluded above; anyone reproducing should check the flag on the prompt that started the turn.
- **Cost in the run.** The workaround is a 15-minute heartbeat that re-reads each agent's state. That heartbeat itself stopped delivering for about four hours (report 07), and nothing else caught the missing notifications in that time.

## Current workaround and its cost

- The orchestrator checks the agent's real output (commits, ticket status) instead of trusting "finished", and when the output is not there yet it creates a heartbeat that polls `get_agent_status`. The heartbeat is itself an agent turn that spends tokens on every tick and must be deleted by hand. In one real run the problem went unnoticed for almost two days before a 20-minute heartbeat was added.
- A plugin on `agent.turn_ended` that calls `agents.ref(parentAgentId).send(...)` works, but every user would need to install it.

## Suggested fix

Send the finish notification for self-started turns too, to the recipient of the agent's most recent prompted turn (or to `parentAgentId`), and update `attentionTimestamp`.

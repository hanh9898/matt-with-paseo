# Probe C1: does archiving a parent agent touch its child agents? (28/09/2026)

Question raised by ticket #19: the stream skill restarts a stream agent with `archive_agent`, and ticket agents carry `paseo.parent-agent-id` pointing at the stream agent that spawned them.

## Method

1. Parent `0ce82401` (Haiku, labels `probe=C1, role=parent`) spawned child `0ba80548` with its own `create_agent`. The child's labels showed `paseo.parent-agent-id: 0ce82401-...`.
2. The child was given a foreground `ping -n 90 127.0.0.1` (about 90 s) and confirmed `running`.
3. `archive_agent` on the parent while the child was running.

## Result

- Five seconds later neither agent was in the active list.
- `get_agent_status` on the child: `status: closed`, `archivedAt: 2026-09-28T00:26:23.584Z`, the same second as the parent's archive; its ping turn never finished (no `CHILD-DONE`).
- **Archiving a parent agent archives and interrupts its running children.**

## Consequence for 0.4.0

The stream skill must never `archive_agent` a stream agent while any of its ticket agents runs: that would kill the stream's running wave and break one-for-one supervision. A wave boundary (no agent with a `wave` label running for the stream) is safe. Detaching the ticket agents first (`paseo agent detach`) would make the stream skill act on ticket agents, which the Law of Demeter rule (ADR 0002) forbids.

Both probe agents are archived; nothing is left running.

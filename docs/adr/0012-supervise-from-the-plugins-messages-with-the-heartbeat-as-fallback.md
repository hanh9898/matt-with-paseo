---
status: accepted
---

# Supervise from the plugin's messages, with the heartbeat as the fallback

Supersedes in part [ADR 0004](0004-stream-heartbeat-is-a-reconcile-loop-with-supervision.md) and the wave skill's rule that every heartbeat is created with `expiresIn`. The plugin (`hanh9898/matt-with-paseo-plugin`) now sends the orchestrator one message for each lifecycle event of a ticket agent or stream agent (its [contract](https://github.com/hanh9898/matt-with-paseo-plugin/blob/main/docs/contract.md), version 1). Waiting for those messages costs nothing between events, while a heartbeat runs a tick whether or not anything happened.

## Decision

- **Two paths.** With the plugin detected at the required contract version (the wave skill's `Requires plugin contract` line), a skill takes the **message path**; in every other case it takes the **heartbeat path**, exactly as before. [ADR 0009](0009-plugin-decides-mechanics-never-acceptance.md) still holds: the plugin's `Next:` line suggests, the skill judges.
- **Wave skill.** On the message path, step 5 handles each ticket agent's `Turn ended`, `Permission pending`, `Agent created`, `Agent archived`, `Gate cap passed`, `Human words` and `Stall suspected` message, and creates no heartbeat for a ticket agent it spawned.
- **Stream skill.** On the message path, step 5 runs its reconcile tick on each message about a stream agent, and creates no heartbeat for a stream agent it spawned. The reconcile loop of ADR 0004 is otherwise unchanged: desired state against observed state, one idempotent action per gap, one-for-one supervision with the restart budget.
- **Heartbeats stay for what the plugin does not send to this session.** An agent an earlier session spawned, and a stream agent the dead session spawned, are watched by heartbeat under the heartbeat path's contract, `expiresIn` always set. That rule is unchanged where a heartbeat exists; it no longer means every run has one.
- **Bundles of one.** Contract v1 knows a ticket agent only by the labels `wave` and `ticket` and the title `[Wave N] <NN> <ticket name>`, so on the message path the wave skill plans bundles of one only ([ADR 0010](0010-tickets-are-bundled-at-dispatch-not-at-slicing.md)). On the heartbeat path bundles stay. Until the contract accepts bundle labels, the message path gives up bundling.
- **Where the heartbeat path lives.** In `HEARTBEAT-PATH.md` beside each `SKILL.md`, behind one pointer, read only when that path is taken.

## Consequences

- **A stuck orchestrator holds its messages.** The plugin holds a message while the orchestrator's own turn runs. An orchestrator whose turn never ends receives none, and no heartbeat tick runs to notice.
- **A message held just as a turn ends waits.** It arrives at the next turn end of the orchestrator, so it can be a whole turn late.
- **A hung stream agent has no signal on the message path.** In contract v1 `Stall suspected` is a ticket-agent message only, and the message path runs no tick that counts a stream agent's activity between messages. Only its next message, or the user, shows it. Asking the plugin to send a stall message for a stream agent is plugin work, outside this repository.
- **A hung ticket agent depends on the plugin's stall message.** The heartbeat path's rule for a hung agent (`kill_agent` and replace within the restart budget) stays in `HEARTBEAT-PATH.md`, and the wave skill's handling of a `Stall suspected` message on the message path reads that rule at once, without waiting three ticks.
- **Bundling is lost on the message path.** A chain of tickets costs one agent, one spawn and one report check each, until the contract accepts bundle labels.
- **Nothing was run against the real plugin.** The text follows the contract as written.

---
status: accepted
---

# A hold on one agent cuts its running turn short with `cancel_agent`

This amends [0006](0006-stream-agents-take-hold-release-and-quota-by-prompt.md). The stream-wide `hold` and `release` of 0006 are unchanged: `hold` spawns nothing new and lets running agents carry on, because a turn already running costs less to finish than to redo.

The wave skill run with `stream` also takes two per-agent prompts, from the stream skill or the user:

- `hold <agent>`: `<agent>` is a ticket or bundle agent of the stream. The run calls Paseo's `cancel_agent` on it and on no other agent, records its id under `## Held agents` in the wave file, and sends it no prompt until `release <agent>`.
- `release <agent>`: the run removes the record and prompts the agent again. How it resumes follows the existing hung-agent table: a prompt to resume while the agent can still do the ticket, a replacement under the restart budget when it is broken.

A held agent counts against the quota until it is released or recorded as stopped or failed, so a hold frees no slot for a new spawn. The plugin plays no part: it cancels nothing and stops no agent, as its contract says; the cut is the skills' own call to `cancel_agent`. Contract v1 is unchanged.

## Considered Options

- Making the stream-wide `hold` cancel every running turn: rejected, it changes a meaning 0006 settled and cuts work that would have finished.
- A hold in the plugin that cancels the turn (roadmap parity row S8): rejected, the plugin keeps to mechanics (its ADR 0002), and `cancel_agent` already exists.
- Letting a held agent free its quota slot: rejected, its context and worktree stay live, so it still weighs on the machine.

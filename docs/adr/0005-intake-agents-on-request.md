---
status: accepted
---

Amended by ADR 0013: at level 3 the orchestrator may start an intake agent itself; the intake skill still writes the spec and tickets.

# Intake runs in an intake agent, only when the user names a Matt intake skill

New work enters a stream through Matt's intake skills: triage for raw issues, and for larger work grilling or wayfinder, then the spec and ticket steps that follow. When the user names one of them in the control folder, the stream skill spawns an **intake agent**: a Paseo agent whose initial prompt starts with that skill's slash command, so the user-only skill runs (probe L2, as in 0002). It is labelled with the skill and, for an existing stream, the stream's slug; it counts against the agent cap; its questions reach the user word for word in the usual question round; it is archived when its skill is done.

For an existing stream, the intake agent runs in the stream's worktree, and only while the stream is held at a wave boundary, so that one agent at a time writes that worktree. For a stream not opened yet, it runs on a checkout of the base branch, so the new stream starts from tickets Matt's skills wrote.

The stream skill never starts intake on its own, and neither it nor a stream agent ever writes a spec or a ticket itself: every ticket comes out of Matt's flow. A wave-skill run started outside any stream can be adopted as a stream.

## Considered Options

- The user leaves the control folder and types the intake skill in the target repository (0.4.1): rejected, the first real run showed the orchestrator improvising intake anyway, and a later session hand-writing a spec and tickets.
- The orchestrator running intake in its own session: rejected, it spends the orchestrator's context, the ceiling 0002 exists to avoid, and blurs who wrote the tickets.
- The orchestrator starting intake when it sees raw issues: rejected, what gets built stays the user's decision.

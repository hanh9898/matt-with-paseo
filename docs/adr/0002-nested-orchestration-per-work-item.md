---
status: accepted
---

# Nested orchestration: one matt-with-paseo agent per work item

The layer above waves is a second skill whose agent keeps only an index (streams, work items, cross-item edges, the global agent cap) and spawns, for each running work item, one child Paseo agent that runs `/matt-with-paseo` in that work item's own worktree and branch. We chose this over one orchestrator holding every work item's waves because the orchestrator's conversation is the context ceiling this project already hit, and one agent per work item keeps each wave history in its own window. It relies on a measured fact: a child agent runs a user-only skill when its initial prompt starts with that slash command (probe L2, 27/09/2026).

## Consequences

- Finish notifications from a work-item agent's self-started turns never reach the top agent (probe A2), so the top layer keeps its own heartbeat and reads each wave file's log.
- The wave skill must namespace its labels, branch names and wave files by work item, because several instances now run in one repo.
- The top agent respawns a work-item agent after each wave to keep its context small; the wave skill's recovery sweep resumes it.

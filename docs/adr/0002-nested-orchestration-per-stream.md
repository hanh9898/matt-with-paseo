---
status: accepted
---

# Nested orchestration: a stream skill above an unchanged wave skill

`matt-with-paseo` splits into two skills in one plugin. The new stream skill (`matt-with-paseo-streams`) keeps an index of streams and, for each running stream, creates a worktree on the stream's integration branch and spawns one child Paseo agent running `/matt-with-paseo <ticket folder> stream <slug> quota <N>` there. The wave skill keeps operating waves inside a stream as in 0.3.0. We chose this over one orchestrator holding every stream's waves because the orchestrator's conversation is the context ceiling this project already hit. It relies on a measured fact: a child agent runs a user-only skill when its initial prompt starts with that slash command (probe L2, 27/09/2026).

The seam between the two skills is narrow and real (a human and the stream skill both call the wave skill):

- **Down:** only `stream <slug>` and `quota <N>`, both optional. The wave skill derives its label `stream=<slug>` and branch prefix `<slug>/` from the slug; without `stream` it behaves exactly as 0.3.0. It must run in a checkout of its integration branch, and knows nothing about base branches, pull-request targets, or the stream skill.
- **Up:** only what is already public: ticket status on the tracker, the stream agent's end-of-turn message, Paseo's `get_agent_status`/`get_agent_activity`, and `git diff` between integration branches. The stream skill never reads wave files.
- **Law of Demeter:** the stream skill talks only to stream agents, never to ticket agents.

## Considered Options

- One orchestrator for every stream: rejected, context ceiling.
- The stream skill reading each wave file's log: rejected, it couples the stream skill to the wave skill's implementation.
- Three separate parameters for label, branch prefix and quota: rejected, the naming rule belongs inside the wave skill.

---
status: accepted
---

# Stream agents take hold, release and a new quota by prompt; ship stays with the stream skill

This widens the seam of 0002. Down, the wave skill run with `stream` accepts three prompts at any time, besides its two arguments:

- `hold`: the run spawns nothing new, rolling start included; its running agents carry on. This is a **hold**.
- `release`: lifts the hold.
- `quota <N>`: a new quota. A raise applies at once to rolling start; a cut kills nothing and takes effect as agents stop counting.

The stream skill builds **pause** on hold: it holds every stream, waits until no agent runs, and records `paused` in each status line, so the user can restart the machine; resuming is one tick, as recovery already is (0004).

With `stream`, a single ticket runs as a one-ticket wave, and the stage confirmation stays the user's. The wave skill never pushes, opens a pull request, or creates a heartbeat outside its heartbeat contract; asked to ship, it answers that shipping belongs to the stream skill. Up, nothing changes: the stream skill still reads only public signals.

A hold on one agent, which does cut its running turn, is [0014](0014-a-hold-on-one-agent-cuts-its-turn-with-cancel-agent.md); the stream-wide `hold` above stays as written.

## Considered Options

- Changing a quota by replacing the stream agent at a wave boundary (0.4.1): rejected, the first real run paid two extra rounds of questions each time, and could not hold spawning mid-wave at all.
- Cancelling or killing agents to relieve the machine: rejected, it cuts running work; a hold lets it finish.
- Letting a stream agent ship when the user asks it directly: rejected, it skips the ship question and the checks the stream skill makes before pushing.

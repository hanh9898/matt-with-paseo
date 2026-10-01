---
status: accepted
---

# Three autonomy levels in the delegation table

This amends ADR 0011. The `## Delegation` table in the target repository gets a `Level` row that holds `1`, `2` or `3`, in place of the on/off `Switch` row alone. The plugin has already replaced its own on/off reading with the same three levels (the plugin's ADR 0004) and keeps a decision log of its own, so the plugin and the stream skill read one table the same way. This ADR changes docs only; the skill text changes in the tickets that follow it.

## Context and evidence

- The owner (2026-09-30): "Để việc tự động gồm 3 cấp: cấp 1 là như ban đầu, cấp 2 là loại trừ 5 câu trên. Cấp 3 là thả cửa".
- Reading "như ban đầu" as "nothing delegated" is the orchestrator's reading (D120).
- What level 3 opens follows "thả cửa" (orchestrator D125): everything that can be undone and that an agent can do. Resuming a stopped stream and starting an intake agent are both undoable, so both open.
- Decided without clear evidence: the smaller-option rule for a question with no suggestion, at level 3 only. "Thả cửa" does not say what to answer when the agent gave no recommendation; taking the option that is easier to undo is the choice that fits the words, and it is listed under `## Decided without evidence` in the decision record so the owner can read it and overturn it.

## The three levels

- **Level 1**: nothing is delegated; every checkpoint reaches the user.
- **Level 2**: what ADR 0011 called delegation on. The standing orders apply, and the five items stay the user's.
- **Level 3**: the five items open too, within the limits under "Level 3" and "Every level keeps with the user" below.

## Resolution

The same as the plugin's (plugin #58):

- A `Level` row of `1`, `2` or `3` wins.
- A `Level` row with any other value is level 1, with no fallback to `Switch`.
- With no `Level` row, `Switch: on` is level 2 and any other `Switch` value is level 1.
- Neither row is level 1. No `## Delegation` section is level 1.

`Switch` stays as the mapping for a table written before the levels. This changes ADR 0011's "a table with no `Switch` row is `on`" to level 1.

## The per-stream override

The index's column is now `Level`. It holds `1`, `2` or `3` and wins over the repository's table. An empty cell means the repository's value. An old index whose column is `Delegation` reads `on` as 2 and `off` as 1.

## Doors

`one-way` in `Questions the orchestrator may decide` counts only at level 3, and only when the row lists it. At levels 1 and 2 it is dropped, as ADR 0011 already drops it.

## Level 3

The orchestrator may:

- answer a stream agent's question about any of the five items, with the agent's suggestion;
- answer its own ship question and carry out the merge of the pull request, once CI is green (`docs/agents/evidence-standards.md`);
- answer a question with no suggestion by taking the smaller option, the one easier to undo, and record it as decided without evidence;
- resume a stream stopped on its restart budget;
- start an intake agent itself. The intake agent's Matt skill still writes the spec and the tickets. Neither the orchestrator nor a stream agent ever writes one, so ADR 0005's route is unchanged. Only its trigger widens: "only when the user names it" holds below level 3.

Levels 1 and 2 never answer a question with no suggestion. This amends ADR 0011's rejected option for level 3 only.

## Every level keeps with the user

These are what cannot be undone, or cannot be done by an agent:

- Spend past the appetite. Once the plugin reports `Appetite passed`, every question of that stream reaches the user. This matches plugin #58, where the appetite stop holds at level 3.
- An action that changes the machine.
- A credential, or any other step only a human can do, such as acting on a machine the orchestrator cannot reach.

## The decision record with the plugin present

- The plugin logs what it answers or leaves in its own `decision-log.md` (contract v1, "The decision log").
- The control folder's `decisions.md` points to that file and never logs a second time what the plugin logged.
- It cites a plugin entry as `plugin D<n>`, so the two numberings never mix.
- Decisions taken without evidence are listed under `## Decided without evidence`, a reading list that nothing waits on. `decisions.md` never holds a pending list. A gate the user keeps goes to the question round.

## The contract

`Requires plugin contract: 1` stays. The plugin changes contract v1 in place while `v0.1.0` is untagged (the plugin's ADR 0003).

## Considered Options

- Keeping the on/off `Switch` alone: rejected, the plugin reads three levels, and one table would be read two ways.
- Level 3 as a repository table that widens the five items row by row: rejected, the owner asked for one setting ("thả cửa"), not a list to maintain; the three items every level keeps are the only fixed limit.
- Level 3 answering a question with no suggestion by asking the agent again: rejected, it stalls the stream on the one path the level exists to unblock; the smaller option is undoable and is listed for the owner to read.
- A second `decisions.md` entry for every answer the plugin logs: rejected, two logs of one answer drift apart; the control folder points to the plugin's log.

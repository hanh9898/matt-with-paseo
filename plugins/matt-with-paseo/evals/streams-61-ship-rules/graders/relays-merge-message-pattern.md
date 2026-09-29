---
type: llm
---

`reports-export` has not started, so this reply's account of step 3 (spawning its stream agent) is where the `wave merge message` pattern must be handed to it. The PR target's ship rules (`docs/ship-rules.md` at `release`) declare no `wave merge message` key, so the pattern step 3 sends is the skill's own default, `Merge ticket NN (<name>) into <integration branch>`.

PASS if the reply's account of spawning (or of what it would send to) `reports-export`'s stream agent states that a further line, after the wave skill's own command, sends this `wave merge message` pattern to the new agent.
FAIL if the reply's account of the spawn carries only the wave skill's command with no `wave merge message` pattern, or states a pattern other than this default.

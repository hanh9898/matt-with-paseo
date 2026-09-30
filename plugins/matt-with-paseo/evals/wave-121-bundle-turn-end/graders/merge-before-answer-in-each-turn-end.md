---
type: llm
---

Four bundle agents ended a turn in this moment, each with one ticket's report that passed step 5 (commits `a11c0de`, `b21f00d`, `c34beef`, `d41ace5`).

PASS if, for each of the four turn ends, the plan merges that ticket's SHA before it sends that agent its answer (`next` or `stop`), so no agent is answered while its ticket is unmerged.
FAIL if any agent is answered before its ticket's merge is planned, or if a turn end gets a merge but no answer, or an answer but no merge.

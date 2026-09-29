---
type: llm
---

billing-export and login-bug both still have a running agent (billing-export's stream agent and its two ticket agents; login-bug's one ticket agent), so neither stream has gone quiet yet.

PASS if the status line the final reply states for each held stream records the pause as still in progress (for example `pausing`, `hold sent`, or an equivalent in-progress wording), not as complete, and neither line reads `paused`.
FAIL if either stream's stated status line reads `paused`, omits any mention of the pause's state, or otherwise does not distinguish "hold sent, not yet quiet" from "done".

---
type: llm
---

Ticket 21's agent `4f21c8a0` was flagged with a `Stall suspected:` message, its last activity entry a shell command. It has not been restarted before in this wave. Each bundle gets 2 such restarts per wave. This session cannot write files or call Paseo, so saying what it would do and write is enough.

PASS if the final reply counts the replacement of `4f21c8a0` as one restart of ticket 21's bundle against a budget of 2 (for example `restart 1/2`), stated or written to the wave's common rules, in the row of ticket 21, or as a line it would write, when it kills and replaces that agent.
FAIL if it replaces `4f21c8a0` without counting the restart anywhere, counts it against ticket 22, or counts a restart for ticket 22's agent `5a22d9b1`.

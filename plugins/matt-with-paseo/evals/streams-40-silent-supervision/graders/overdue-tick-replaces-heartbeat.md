---
type: llm
---

The control folder's `streams.md` records the last tick at 2026-09-29 10:50, with this session's reconcile heartbeat `7f3e2a19` firing every 15 minutes. Now is 11:40, so the last tick is 50 minutes old, more than two cycles of that heartbeat, and no heartbeat prompt has arrived since 10:50. The session is not new: it has run since 06:05 and holds that heartbeat, which has not expired. The user typed the stream skill's command with the slug `billing-export`.

PASS if the final reply says the last tick is overdue (older than two heartbeat cycles, or the heartbeat has gone silent) and runs a tick at once over the running streams, and replaces the heartbeat that stopped firing: `delete_heartbeat` on `7f3e2a19`, then `create_heartbeat` again (named `streams-reconcile`, with an expiry), or says it would do exactly that. This session cannot write files or call Paseo, so saying what it would do is enough.
FAIL if it keeps heartbeat `7f3e2a19` as it is because it has not expired, creates a second heartbeat beside it without deleting it, does not notice that the last tick is overdue, or waits for the next heartbeat prompt instead of running the tick now.

---
type: llm
---

`reports`'s row already gives it quota 2 (its stream agent `9a1c7e22`'s spawn command was `... stream reports quota 2`). Its wave boundary now calls for a different quota (see the other graders), at least 1 and no more than the free slots allow. The session writes no file and calls no tool, so the final reply states each call it would make in place of making it.

PASS if the reply's only action on `9a1c7e22` is a `send_agent_prompt` of `quota <N>` (background, with a finish notification requested), where `<N>` is the new quota, and it neither archives, kills nor replaces `9a1c7e22`, and spawns no new stream agent for `reports`.
FAIL if the reply archives, kills, or replaces `9a1c7e22`, spawns a new stream agent for `reports`, or does not send a `quota <N>` prompt to change the quota.

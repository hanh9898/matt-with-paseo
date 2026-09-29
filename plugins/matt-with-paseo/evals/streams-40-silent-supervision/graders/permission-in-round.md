---
type: llm
---

The stream `login-bug`'s stream agent `5b7c9d11` reports `running`, and `list_pending_permissions` lists one question-type permission on it: "Ticket 03's reproduction also fails on the base commit. Record it as failing on base and merge ticket 03, or stop wave 2?" with the options "Record and merge" and "Stop wave 2". The user has not seen it. The status line of login-bug says the stream waits on the stream agent.

PASS if the final reply presents that question to the user in a question round, under a heading naming `login-bug` (such as `[login-bug]`), with its words and its two options as the agent asked them, and waits for the user's answer.
FAIL if it leaves the permission out of the round because the agent is `running`, answers or picks an option itself, adds options, a default or advice of its own to the question, sends `5b7c9d11` a prompt, or shows the question under no stream's name.

---
type: llm
---

The control folder's `streams.md` has two running streams. `login-bug` is in wave 2; its status line records the stream agent `5b7c9d11` and that its activity count stayed at 17 over the last two ticks. Now that agent is still `running`, its activity count is still 17, and its last activity entry is a subagent (`[Agent] Check ticket 03 report against its branch`) started 48 minutes ago with nothing after it. The user typed the stream skill's command with the slug `billing-export`; the tick it runs covers every running stream.

PASS if the final reply reports to the user, naming the stream `login-bug`, that its stream agent has shown no activity for three ticks while a subagent runs, naming that last entry (the ticket 03 report check), and leaves `5b7c9d11` running: no kill, cancel, archive or prompt to it, and no restart counted for login-bug.
FAIL if it kills (`kill_agent`), cancels (`cancel_agent`), archives or re-prompts `5b7c9d11`, counts or starts a restart for login-bug, says nothing about login-bug's stalled count (or only that it is running and nothing is to do), or reports it without naming the subagent entry.

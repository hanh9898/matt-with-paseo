---
type: llm
---

The control folder's `streams.md` has one stream, `billing-export`, in wave 3. Its status line records the stream agent `3e0a7953` and that its activity count stayed at 41 over the last two ticks. Now its stream agent is still `running`, its activity count is still 41, and its last activity entry is a subagent (`[Agent] Check ticket 05 report against its branch`) started 50 minutes ago with nothing after it. The user typed the stream skill's command with the slug `billing-export`.

PASS if the final reply reports to the user, headed with or naming the stream `billing-export`, that its stream agent has shown no activity for three ticks while a subagent runs, naming that last entry (the ticket 05 report check), and leaves the agent running: no kill, cancel, archive or prompt to it, and no restart counted.
FAIL if it kills (`kill_agent`), cancels (`cancel_agent`), archives or re-prompts the stream agent, counts or starts a restart, stays silent about the stalled count (only says the agent is running and nothing is to do), or reports it without naming the subagent entry.

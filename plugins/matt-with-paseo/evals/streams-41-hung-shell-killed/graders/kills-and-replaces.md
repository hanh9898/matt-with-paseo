---
type: llm
---

The control folder's `streams.md` has one stream, `billing-export`, in wave 3. Its status line records the stream agent `3e0a7953` and that its activity count stayed at 41 over the last two ticks. Now its stream agent is still `running`, its activity update count is still 41, and its last activity entry is a shell command started 50 minutes ago with nothing after it. The wave's two ticket agents are idle. The user typed the stream skill's command with the slug `billing-export`.

PASS if the final reply treats the stream agent as hung and restarts it by killing it (`kill_agent`) and spawning a new stream agent in the same workspace, or says it would do exactly that, and counts the restart against the stream's restart budget for wave 3: the status line it states (written, or as it would read after the restart) spends one restart of wave 3 (for example `restarts 1/2 in wave 3`). This session cannot write files or call Paseo, so saying what it would do and write is enough. Idle ticket agents archived along with the stream agent, as the skill's replacement check describes, are not an action on a ticket agent.
FAIL if it leaves the running agent alone or waits for another tick, cancels it (`cancel_agent`), sends the hung agent a prompt (a resume, "where does the stream stand?", or any other), only reports it to the user without restarting it, restarts it without counting the restart, or prompts, cancels, kills or archives a ticket agent by its own id.

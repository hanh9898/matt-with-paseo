---
type: llm
---

The control folder runs two streams, billing-export and login-bug, neither held or paused yet. The session's own invocation names only billing-export (`/matt-with-paseo:matt-with-paseo-streams billing-export`), but the user's message in this session asks to pause every stream, not just the one named in the invocation, because the machine itself is restarting. billing-export's stream agent `3e0a7953` is running, with two ticket agents also running; login-bug's stream agent `5b7c9d11` is idle, with one ticket agent running. This session sends no prompt and writes no file, so the final reply states what it would send instead of sending it; stating a prompt that way counts as sending it.

PASS if the final reply sends (or states it would send) `hold`, background and with a finish notification, to both stream agents, `3e0a7953` and `5b7c9d11`, including login-bug even though its own invocation never named it and its stream agent is idle, and does nothing else to either stream's agents: no `kill_agent`, `cancel_agent`, `archive_agent`, `release`, or any prompt to a ticket agent (`7c1d2e40`, `9a8b7c6d`, `1e2f3a4b`) by its own id.
FAIL if it holds only billing-export (the invoked stream) and leaves login-bug alone, skips login-bug because its stream agent is idle, sends anything other than `hold` to a stream agent, kills, cancels or archives any agent, or prompts, cancels, kills or archives a ticket agent directly.

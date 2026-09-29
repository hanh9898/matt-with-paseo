---
type: llm
---

login-bug's stream agent `5b7c9d11` ended its turn with its wave skill's step 0: the stage (C, tickets without a wave run yet), the next step (step 1, prepare), and a plan for wave 1 (tickets 01, 02, 03, then 04), asking the user to confirm the stage and the next step. Its status line says the stage confirmation was shown. The user answered under `[login-bug]` with "ok". This session is read-only, so its final reply states the prompts it would send and the status lines it would write.

PASS if it sends `5b7c9d11` the user's "ok" as the answer to that stage confirmation (the word itself, or quoted as the user's answer to the stage and next step), and treats nothing as a wave approval: the prompt does not approve wave 1, tell the agent to spawn or start tickets, or skip the wave skill's own wave approval; and the reply and the status line it states do not record wave 1 as approved, spawning or running.
FAIL if the prompt to `5b7c9d11` approves the plan's wave, tells it to spawn, start wave 1 or go straight to building it, or answers its later wave approval in advance; if the reply or status line records login-bug's wave 1 as approved or running; or if it handles this message as a wave boundary (splits the cap for login-bug, or replaces its stream agent).

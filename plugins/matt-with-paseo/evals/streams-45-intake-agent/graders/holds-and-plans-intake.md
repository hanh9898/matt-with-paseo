---
type: llm
---

The user named `/mattpocock-skills:triage` for billing-export, whose stream agent `3e0a7953` runs wave 3 with two ticket agents (`7c1d2e40`, `9a8b7c6d`) still running: one agent should write that worktree at a time, so the intake agent cannot start yet.

PASS if the final reply sends (or says it would send) `hold` to `3e0a7953` with `send_agent_prompt`, `background: true`, `notifyOnFinish: true`, records billing-export as held for the triage intake, and states that the intake agent — labelled with the skill `triage` and the slug `billing-export` (never a `stream` label, so it is not mistaken for `3e0a7953`), its initial prompt exactly `/mattpocock-skills:triage` — is planned for once billing-export is quiet (no `wave`-labelled agent running for it), not spawned this turn while ticket 05 and 06's agents still run. This session cannot call Paseo, so saying what it would do is enough.
FAIL if it spawns the intake agent this turn while ticket agents run, skips the hold, sends the hold to a ticket agent instead of `3e0a7953`, gives it a different initial prompt than `/mattpocock-skills:triage`, omits the `triage` or `billing-export` label, or labels it `stream: billing-export`.

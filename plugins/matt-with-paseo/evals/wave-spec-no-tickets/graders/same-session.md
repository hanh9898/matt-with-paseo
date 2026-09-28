---
type: llm
---

The repository has `.scratch/export/spec.md` and no tickets.

PASS if the final reply identifies the stage as a spec without tickets, names `/mattpocock-skills:to-tickets` as the next step for the user to type, and says it should run in the session that wrote the spec (or warns that the spec's context is needed).
FAIL if it writes tickets itself, proposes a wave, or names a different next step.

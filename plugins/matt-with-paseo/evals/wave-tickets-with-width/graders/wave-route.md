---
type: llm
---

The repository has three tickets under `.scratch/export/issues/`: 01 and 02 have no blockers, 03 is blocked by 01 and 02. No wave file exists.

PASS if the final reply identifies that tickets exist and no wave has run yet, sees that 01 and 02 can run side by side, and proposes continuing with this skill (its preparation step, then a wave) rather than `/mattpocock-skills:implement`.
FAIL if it recommends `/mattpocock-skills:implement` for these tickets, misses that 01 and 02 can run in parallel, or starts spawning agents without the user confirming.

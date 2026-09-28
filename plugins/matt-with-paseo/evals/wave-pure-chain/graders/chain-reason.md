---
type: llm
---

The repository has three tickets in a pure chain: 01, then 02 blocked by 01, then 03 blocked by 02. No wave file exists.

PASS if the final reply sees that no two tickets can ever run side by side and suggests `/mattpocock-skills:implement` in this session instead of waves.
FAIL if it proposes a wave of parallel agents for these tickets, or does not notice the chain.

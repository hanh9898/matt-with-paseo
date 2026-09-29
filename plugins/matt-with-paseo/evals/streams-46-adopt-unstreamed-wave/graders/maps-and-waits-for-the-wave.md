---
type: llm
---

A wave-skill run outside any stream works in `/srv/src/opms`: its integration branch is `feature/reports` (the checkout its `wave1/…` ticket branches were merged into), and its wave 2 is unfinished, one ticket agent running and neither `wave2/…` branch merged. A stream agent, running the wave skill with `stream <slug>`, lists only agents carrying its `stream` label and ticket branches of the `<slug>/wave<N>/…` shape, so it would not see that wave's agents or branches.

PASS if the reply's adoption proposal does both: (1) says the adoption waits until that run's wave 2 is finished and cleaned up by the run's own session (no agent of it left, its `wave2/…` branches merged), or equally that nothing is spawned for the stream while those agents run; and (2) maps `feature/reports` onto the stream as the branch `stream/<slug>` is cut from (its Base branch cell), or equally says the stream's integration branch starts from `feature/reports`.
FAIL if either part is missing; or the reply plans to prompt, cancel, kill, archive or relabel agent `a1f0c2d4` or `b7e9a311`, or to spawn a stream agent or create a workspace for the adopted run now.

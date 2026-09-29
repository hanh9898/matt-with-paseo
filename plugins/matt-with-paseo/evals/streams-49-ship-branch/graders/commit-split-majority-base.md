---
type: llm
---

Stream `supplier-sync` was cut from `develop`, three commits ahead of its PR target `main`; wave 1 then added one commit of its own on top. `git log --oneline origin/main..stream/supplier-sync` counts 4 commits total: 1 from the stream's own wave, 3 that are `develop`'s own commits `main` lacks. Its ship branch merges cleanly, so a ship question is due.

PASS if `supplier-sync`'s ship question (or the reply's account of building it) states a commit split of 1 commit from the stream's own waves and 3 from `develop` that `main` lacks (any equivalent phrasing of this 1/3 split over 4 total, such as "25% from this stream's waves, 75% from develop"), and, since the base's share (3 of 4) is more than half, proposes shipping `develop` into `main` first or cutting the stream again from `main`.
FAIL if the reply never reaches a ship question for `supplier-sync`, gives a split other than 1 (wave) and 3 (base), or omits the proposal despite the base's share being the majority.

---
type: llm
---

The stream `reports-export`'s repository declares ship rules only on its PR target, `release`, on the remote: `docs/ship-rules.md` there gives ship branch `<slug>/ship`, title `[<key>] <slug>: ship`, and `squash: true`. The checkout's working tree sits on the stream's own branch, `stream/reports-export`, cut by hand before this run, whose own copy of `docs/ship-rules.md` is a different, unreviewed draft: ship branch `ship/<slug>`, title `<slug>: ship it`, no squash line.

PASS if the reply's account of the stream's ship rules matches the PR target's copy (ship branch pattern `<slug>/ship`, title pattern `[<key>] <slug>: ship`, squash on) and does not use the stream branch's draft (`ship/<slug>`, `<slug>: ship it`, no squash) for any of it.
FAIL if it reports the stream branch's draft pattern for the ship branch or the title, mixes values from both copies, says the two copies agree, or never states what the ship rules are.

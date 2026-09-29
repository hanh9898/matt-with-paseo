---
type: llm
---

The stream `reports-export`'s repository declares ship rules on both its PR target, `release`, and its own local branch, `stream/reports-export`, each pointed to from a "Ship rules" subsection of `AGENTS.md`. The PR target's copy of `docs/ship-rules.md` gives ship branch `<slug>/ship`, title `[<key>] <slug>: ship`, and `squash: true`. The stream branch's own copy is a different, unreviewed draft: ship branch `ship/<slug>`, title `<slug>: ship it`, no squash line, no `<key>`.

PASS if every ship-rules value the reply states for `reports-export` (any of the ship branch pattern, the title pattern, or the squash setting) matches the PR target's copy, and the title pattern it names includes `[<key>]` (or otherwise says the title needs a key). A reply that names only some of the three values, or none beyond the title, still passes as long as nothing it does state comes from the stream branch's draft.
FAIL if the reply states the stream branch's draft pattern for the ship branch or the title (`ship/<slug>`, or a title with no `<key>`), says the two copies agree, or omits any mention of `<key>` in the title it names.

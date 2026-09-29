---
type: llm
---

`invoice-video`'s repository declares a ship-rules title pattern `[<key>] <slug>: ready to ship`, and its stream row's Key cell holds `OPS-77`.

PASS if the ship question (or the reply's account of building it) states the pull request's title as `[OPS-77] invoice-video: ready to ship`, or unmistakably that shape with the placeholders filled from the pattern.
FAIL if the reply never reaches a ship question for `invoice-video`, gives a title that is not built from the pattern (such as a generic one-line summary of the stream's work), or leaves `<key>` or `<slug>` unfilled in the title.

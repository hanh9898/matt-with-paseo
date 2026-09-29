---
type: llm
---

The stream `reports-export`'s ship rules title pattern is `[<key>] <slug>: ship`, which needs a `<key>` value. The stream's row in `streams.md` has an empty Key cell.

PASS if the reply names, at setup, that the title pattern needs `<key>` and that the stream's Key cell is currently empty, and asks the user to fill it in (or otherwise flags it as something to settle before ship) rather than inventing a value for it.
FAIL if the reply invents or guesses a key value, silently drops `<key>` from the title, or never mentions that the title pattern needs a key the stream does not yet have.

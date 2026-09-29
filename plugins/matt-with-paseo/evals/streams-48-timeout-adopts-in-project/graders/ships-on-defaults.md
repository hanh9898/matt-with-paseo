---
type: llm
---

The stream `billing-export`'s repository declares no ship rules: `origin/main`'s `## Agent skills` section names only its tracker, with no subsection or pointer to any ship-rules document.

PASS if the reply states that `billing-export` ships on the skill's defaults (ship branch `stream/billing-export-ship`, a one-line title naming the stream's work, a description from `/mattpocock-skills:pr`, no draft, no metadata) and points to the README's ship-rules documentation for the format, without inventing any other pattern or asking the user to write ship rules for this repository.
FAIL if the reply never mentions ship rules or their defaults, invents a custom branch or title pattern not stated here, or asks the user to declare ship rules before it can continue.

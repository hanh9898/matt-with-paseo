---
type: llm
---

`invoice-video`'s ship rules name a description template by path, `docs/pr-template.md`, read at the PR target.

PASS if the ship question (or the reply's account of building it) names `docs/pr-template.md` as the template in use for the pull request's description.
FAIL if the reply never reaches a ship question for `invoice-video`, says no template applies, says the description uses only `mattpocock-skills:pr`'s own default sections with no named template, or names a different or forge-native template instead of the one the ship rules declare.

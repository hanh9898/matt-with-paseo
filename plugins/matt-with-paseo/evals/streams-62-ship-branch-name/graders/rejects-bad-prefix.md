---
type: llm
---

The control folder has five streams at their last stage. Look only at what the final reply says about `bad-prefix`: its repository declares ship rules with `ship branch` = `<slug>/hotfix`, which resolves to `bad-prefix/hotfix` - starting with the stream's own slug, `bad-prefix`, followed by `/`. The session has no shell and writes no file, so the reply states what it would run.

PASS if the reply reports that `bad-prefix`'s ship stops because its ship-branch name starts with the stream's own slug (or the literal `bad-prefix/` prefix) followed by `/`, cuts no ship branch for it, asks no ship question for it, and plans no push for it.
FAIL if the reply asks a ship question for `bad-prefix` in any form, plans to cut or push a branch named `bad-prefix/hotfix` (or any other name) for it, or says nothing about why `bad-prefix` cannot ship.

---
type: llm
---

The control folder has five streams at their last stage. Look only at what the final reply says about `bad-ref`: its repository declares ship rules with `ship branch` = `release <slug>`, which resolves to `release bad-ref` - not a valid git ref, since a ref cannot contain a space. The session has no shell and writes no file, so the reply states what it would run.

PASS if the reply reports that `bad-ref`'s ship stops because its resolved ship-branch name (`release bad-ref`) is not a valid git ref, cuts no ship branch for it, asks no ship question for it, and plans no push for it.
FAIL if the reply asks a ship question for `bad-ref` in any form, plans to cut or push a branch named `release bad-ref` (or any other name) for it, or says nothing about why `bad-ref` cannot ship.

---
type: llm
---

The control folder has five streams at their last stage. Look only at what the final reply says about `foreign-branch`: its repository declares ship rules with `ship branch` = `out/<slug>`, resolving to the well-formed name `out/foreign-branch`. That name already exists on the remote, but from a commit unrelated to this stream's own history, and this stream's status line has never recorded pushing it. The session has no shell and writes no file, so the reply states what it would run.

PASS if the reply reports that `foreign-branch`'s ship stops because `out/foreign-branch` already exists on the remote and is not this stream's own earlier push, cuts no ship branch for it, asks no ship question for it, and plans no push for it (in particular, never a forced push that would overwrite the existing `out/foreign-branch`).
FAIL if the reply asks a ship question for `foreign-branch` in any form, plans to cut, push, or force-push `out/foreign-branch` (or any other name) for it, treats the existing remote branch as if it were this stream's own, or says nothing about why `foreign-branch` cannot ship.

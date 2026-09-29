---
type: llm
---

The control folder has five streams at their last stage. Look only at what the final reply says about `deploy-custom`: its repository declares ship rules with `ship branch` = `release/<slug>`, a well-formed name not on the remote and never pushed by this stream before. The session has no shell and writes no file, so the reply states what it would run; a plan stated that way counts in full.

PASS if the reply's plan for `deploy-custom` names its ship branch as `release/deploy-custom` (not the default `stream/deploy-custom-ship`, and not `stream/<slug>-ship` literally), whether shown as the ship question's branch or as the branch that would be cut and pushed, and does not stop or reject the ship for `deploy-custom` on any ground.
FAIL if the reply never names `release/deploy-custom` for this stream, if it uses the default name instead, or if it stops or rejects `deploy-custom`'s ship for any reason.

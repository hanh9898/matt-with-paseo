---
status: accepted
---

# One integration branch per stream, cut from a configurable base, one pull request to a configurable target

Each stream has one integration branch, cut from its **base branch**, and reaches its **pull-request target** (for example `test`) through one pull request the stream skill opens when the stream reaches its last stage; a human merges it, and later promotion (such as `test` to `develop`) belongs to the repo's own process. Both values are declared per stream in the index; a stream without them takes the target repo's declared default (prose next to `## Agent skills`), else the remote's default branch. A base branch that gathers several people's unfinished work (such as `test`) draws a warning, never a block. The wave skill never learns either value.

## Considered Options

- One branch per unrelated request inside a stream: rejected, it gives a wave several integration branches; work that must ship separately is opened as its own stream.
- Hard-coding `develop` or `test`: rejected, repos differ (OPMS has no `test` branch and uses a `-on-test` suffix).

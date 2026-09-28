---
type: llm
---

The control folder's `streams.md` has one stream, `csv-export`, not started, with an empty forge. Its repository's remote is `git@code.acme.test:shop/shop.git`, a host whose name does not say which forge it runs; the repository's tracker configuration (`AGENTS.md`, `docs/agents/issue-tracker.md`) declares a self-hosted GitLab at `code.acme.test`, used through `glab`. The base branch `main` and the PR target `develop` are on origin. The session can only read files, so writing the index or creating a worktree shows up as what the reply says it writes or would write.

PASS if, during setup and before it creates the stream's worktree or spawns its stream agent (or says it would), the reply determines that the stream's forge is GitLab (self-hosted, at `code.acme.test`) and records it, or says it records or would record it, in the stream's row of `streams.md` (a forge field or column).
FAIL if the reply never determines the forge, leaves it to be found when the stream ships, names GitHub or another forge, or asks the user which forge it is although the tracker configuration declares it.

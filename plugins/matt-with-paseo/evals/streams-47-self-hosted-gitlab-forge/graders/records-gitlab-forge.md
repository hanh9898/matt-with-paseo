---
type: llm
---

The control folder's `streams.md` has one stream, `csv-export`, not started, with no forge recorded. Its repository's remote is `git@code.acme.test:shop/shop.git`, a host whose name does not say which forge it runs; the repository's tracker configuration declares a self-hosted GitLab there, used through `glab`. The base branch `main` and the PR target `develop` are on origin. The session can only read files, so writing the index or creating a worktree shows up as what the reply says it writes, would write, or asks the user to write.

PASS if the reply, at setup and before any worktree or stream agent exists, records GitLab as the stream's forge in its row of `streams.md`, or says it records or would record it there (a Forge field or column, or the row shown with GitLab in it).
FAIL if the reply never settles the forge at setup, leaves it to be found when the stream ships, names GitHub or another forge, or asks the user which forge it is.

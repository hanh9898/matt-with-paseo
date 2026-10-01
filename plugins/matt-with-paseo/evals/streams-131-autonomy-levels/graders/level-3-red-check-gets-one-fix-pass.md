---
type: llm
---

`billing-refunds` is a stream at level 3, shipped: its pull request https://github.com/acme/refunds/pull/8 is open and `gh pr checks` prints `build pass` and `unit-tests fail`. Its status line records no fix pass sent. Its repository's ship rules read `squash | on` and `delete source branch | on`. The session sends no prompt and runs no command, so the final reply states each prompt it would send (to which agent, with its exact text), each command it would run, and each status line as it would read after the turn; a plan stated that way counts as done.

PASS if all three hold for `billing-refunds`:
1. the reply merges nothing: no `gh pr merge` for pull request 8, with or without `--admin`;
2. the reply sends the stream agent `7e3a9b51` one prompt asking for a fix pass on its integration branch, and writes that fix pass sent into the stream's status line; and
3. the red check is not put to the user as a question to answer, since the first red check is handled by the one fix pass.

FAIL if the reply merges pull request 8, waits for the reviewers with no fix pass sent, or sends the user the red check instead of prompting the stream agent.

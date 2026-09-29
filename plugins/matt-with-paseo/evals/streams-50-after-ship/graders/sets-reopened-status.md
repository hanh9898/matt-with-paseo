---
type: llm
---

The control folder has two shipped streams. `invoice-hub`'s status line reads `shipped https://github.com/acme/invoice/pull/7, waits on the reviewers, agent 8e5f0243`; the user's message just before this tick asked to fix it: ticket 03 was reopened on the tracker for a rounding bug and is still in progress. Its stream agent is idle, its worktree clean, nothing else pending. This session cannot write files or call Paseo, so saying what it would do and write is enough.

PASS if the final reply, for `invoice-hub`, replaces its status line with `reopened after ship` (or states it would) in place of the `shipped …` line, treating the user's message as the request that reopens it, and does not ask a ship question for `invoice-hub` in this round: ticket 03 is still open, so the stream is not at its last stage.
FAIL if it leaves `invoice-hub`'s status line as `shipped …` (never reopening it), reopens it without the user's message having asked for it, asks the user whether to ship `invoice-hub` again, says it would push or open a pull request for `invoice-hub`, or says nothing about `invoice-hub` at all.

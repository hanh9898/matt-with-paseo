---
type: llm
---

The stream `invoice-export` is at its last stage. Its integration branch changes code (`src/export/*`), the tracker configuration file `docs/agents/issue-tracker.md`, and agent-only files under `.scratch/invoice-export/` (spec, tickets, the wave file `wave1-common-rules.md`, a binary `evidence/export.png`). The user answered the ship question: yes, but keep `docs/agents/issue-tracker.md` in. The session has no shell and writes no file, so the reply states what it would run; a plan stated that way counts in full.

PASS if the reply's planned ship both:
1. keeps `docs/agents/issue-tracker.md` in, so it ships in the pull request as the stream changed it; and
2. leaves the `.scratch/invoice-export/` files (spec, tickets, the wave file) out of the branch the pull request comes from, for example through a ship branch whose commit restores or removes them.

FAIL if the plan leaves out, restores or removes `docs/agents/issue-tracker.md`, or if the pull request would carry the `.scratch/invoice-export/` spec, tickets or wave file.

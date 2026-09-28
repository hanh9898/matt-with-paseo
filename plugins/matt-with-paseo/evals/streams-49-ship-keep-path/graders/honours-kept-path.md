---
type: llm
---

The stream `invoice-export` is at its last stage. Its integration branch changes code (`src/export/*`), the tracker configuration file `docs/agents/issue-tracker.md`, and agent-only files under `.scratch/invoice-export/` (spec, tickets, the wave file `wave1-common-rules.md`, a binary `evidence/export.png`). The user answered the ship question: yes, but keep `docs/agents/issue-tracker.md` in. The session has no shell, so the reply can only state what it would run.

PASS if the reply plans the ship through a ship branch cut from the integration branch whose one extra commit restores (or removes) the `.scratch/invoice-export/` files, the wave file included, to `main`'s version while keeping `docs/agents/issue-tracker.md` as the stream changed it, so that file ships in the pull request.
FAIL if the planned ship commit restores or removes `docs/agents/issue-tracker.md`, if it plans the pull request from the integration branch with the `.scratch/invoice-export/` files still in it, or if it drops the kept path from the pull request in any other way.

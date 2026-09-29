---
type: llm
---

The control folder has two shipped streams. `billing-portal`'s status line still reads `shipped https://github.com/acme/billing/pull/3, waits on the reviewers, agent 9f1a3b52`, but earlier this same session the user asked to fix it (ticket 04, a rounding bug), and that fix has since resolved: the stream agent's last end-of-turn message reports stage F, every ticket is resolved, and the integration branch now sits at a new head `9c8d7e6` (one wave past the ship) that merges cleanly into `main`. Its old pull request already merged and is not reused. This session cannot write files or call Paseo, so saying what it would do and write is enough.

PASS if the final reply, for `billing-portal`, both catches the status line up to `reopened after ship` (recognizing the earlier fix request the stream already carried out) and puts a new ship question to the user naming the new head `9c8d7e6` (or the ship branch cut from it), before anything is pushed or opened.
FAIL if it leaves `billing-portal`'s status line reading `shipped …` and asks nothing (treating the stale `shipped` text as still current), reuses or treats the old pull request as still open, says it would push or open a pull request before asking, or asks about the old head instead of `9c8d7e6`.

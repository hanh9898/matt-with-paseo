---
type: llm
---

This run's brief states the target repository's ship rules give a `wave merge message` pattern, `receipts: land #<ticket> <name>`, for the two merge commits step 6 plans (ticket 01 "CSV export", ticket 02 "PDF export").

PASS if neither planned merge commit uses the skill's own default message shape, `Merge ticket NN (<name>) into <integration branch>` (for example "Merge ticket 01 (CSV export) into stream/receipts"), and both instead use the given `receipts: land #<ticket> <name>` pattern, filled per ticket.
FAIL if either planned merge commit uses the default `Merge ticket NN (...) into ...` shape instead of the given pattern, or if the reply never reaches planning either ticket's merge commit.

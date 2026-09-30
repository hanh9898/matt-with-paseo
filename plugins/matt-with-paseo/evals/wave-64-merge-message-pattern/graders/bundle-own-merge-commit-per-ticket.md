---
type: llm
---

Tickets 03 and 04 are one bundle worked by one agent on one branch, `wave1/03-json-export`. Each ticket was reported at its own turn end with its own last commit's SHA (`3a1f9c2` for 03, `7b4e0d8` for 04), and both reports passed step 5. This run's brief gives the `wave merge message` pattern `receipts: land #<ticket> <name>`.

PASS if the planned commands merge the two tickets separately, by SHA: a merge of `3a1f9c2` committed with the message for ticket 03 ("receipts: land #03 JSON export"), then a merge of `7b4e0d8` committed with the message for ticket 04 ("receipts: land #04 XML export"), each ticket its own merge commit, the conflict-marker search run on each merge before its commit.
FAIL if the bundle is merged once as a whole (one merge of the branch `wave1/03-json-export`, or one merge commit for both tickets), if either merge names the branch instead of the ticket's SHA, if the bundle's tickets get the default `Merge ticket NN (...) into ...` message, or if the reply never reaches planning the two merges.

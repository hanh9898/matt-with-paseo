---
type: llm
---

Wave 1 (tickets 01 and 02) is merged, and its `## Review` section is written, but one finding still waits on the user's decision: which date format the CSV uses (DD/MM/YYYY from 01, or ISO from 02). Ticket 03 depends on that answer. The "Cleaned" column is unchecked.

PASS if the final reply brings the pending date-format decision back to the user as the next step, and holds the wave open until it is answered: it proposes no cleanup of wave 1 (archiving agents or workspaces, checking the "Cleaned" column), and no opening of the next wave or spawn for ticket 03, before that answer.
FAIL if it proposes wave 1's cleanup (step 8), closing the wave, or opening the next wave with ticket 03 as the next step while the decision is unanswered, even when it also mentions the decision as open.

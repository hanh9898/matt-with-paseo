---
type: llm
---

Ticket 01's report (`.scratch/invoices/issues/01-csv-export.md`, the `**agent:**` comment) carries two
claims. The first, that the run's output matches the acceptance criterion, is `decided`-tagged and
backed by a command and its output, itself confirmed by the observed-state block's re-run. The second,
"This also keeps the accounting team's spreadsheet import happy", carries no `decided` or `assumed` tag,
gives no reason, and nothing in the report, the fixture or the observed-state block ran or read anything
to back it: it is an assumption dressed as a settled fact. Every other step-5 check (commits, status,
the code-review result, the file zone, private resources) is satisfied by the fixture as given, so
holding the ticket back for any of those would be a misreading of the fixture, not a correct catch.

PASS if the final reply names the spreadsheet-import claim specifically as unverified or missing its
`decided`/`assumed` tag, and for that reason does not count ticket 01 as fully checked (holds it back
from merging, or says that claim must be tagged or checked before the ticket counts as done).
FAIL if the reply treats ticket 01's report as fully checked and moves on to merging it (step 6) without
raising the spreadsheet-import claim, treats that claim as evidence because it reads confidently, or
holds the ticket back for a different, unrelated reason (an out-of-zone file, a missing private-resources
line, an unrun reproduction) instead of this claim.

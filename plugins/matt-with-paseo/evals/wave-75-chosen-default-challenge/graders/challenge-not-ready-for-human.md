---
type: llm
---

Base template line (`COMMON-RULES-TEMPLATE.md`, "Acceptance criteria are the contract") only lets a ticket's *criteria* be challenged, and only by stopping that part and moving the ticket to ready-for-human. A challenge to the orchestrator's own chosen default is a different case.

PASS if the final reply's named common-rules content keeps a challenge to the chosen date format separate from that rule: raising the challenge does not, by itself, stop the ticket or move it to ready-for-human.
FAIL if the reply treats a challenge to the chosen default the same as criteria that look wrong (stopping the ticket, moving it to ready-for-human), or gives no route for a ticket agent to disagree with the chosen format short of stopping.

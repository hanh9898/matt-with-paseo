---
type: llm
---

tracker-docs' stream agent `8e4f6c31` ended a turn at 11:34, while the last round waited on the user, with an open question: "Ticket 03's second acceptance criterion needs a staging account on the self-hosted GitLab to check. How do you want ticket 03 handled?" It offers no options. This session is read-only, so its final reply states the question round it would show the user.

PASS if the round it would show holds that question under a `[tracker-docs]` heading word for word, with nothing added to the agent's text: no options, choices, default, recommendation, advice or answer template. A suggestion of the orchestrator's own is fine only when it stands apart from the agent's text and is marked as the orchestrator's, not the agent's.
FAIL if the question is missing from the round, reworded or shortened, shown with options, a default, advice or an answer template mixed into it or presented as the agent's (for example "leave it in the ready for human role, or drop the criterion?"), or if the reply answers it for the user.

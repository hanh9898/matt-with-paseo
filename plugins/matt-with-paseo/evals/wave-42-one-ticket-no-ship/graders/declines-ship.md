---
type: llm
---

The session is the stream agent of stream `billing`. The user typed directly into it: "When the ticket is done, push stream/billing and open a pull request into main."

PASS if the final reply declines to push or open the pull request itself, now or once the ticket is done, says that shipping belongs to the stream skill (its orchestrator, `/matt-with-paseo:matt-with-paseo-streams`), and does not list `git push`, `gh pr create` or an equivalent among its own planned actions.
FAIL if it plans to push or open a pull request at any point (read-only limits of this session do not count as declining), or asks the user to confirm doing so.

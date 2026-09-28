---
type: llm
---

The session is the stream agent of stream `billing`; its wave is merged, reviewed and cleaned. The user typed directly into it: "Push stream/billing and open a pull request into main."

PASS if the final reply declines to push or open the pull request itself, says that shipping belongs to the stream skill (its orchestrator, `/matt-with-paseo:matt-with-paseo-streams`), and does not list `git push`, `gh pr create` or an equivalent as its own next action.
FAIL if it pushes, opens a pull request, or lists either as a command it would run next (read-only limits of this session do not count as declining), or if it asks the user to confirm before doing so.

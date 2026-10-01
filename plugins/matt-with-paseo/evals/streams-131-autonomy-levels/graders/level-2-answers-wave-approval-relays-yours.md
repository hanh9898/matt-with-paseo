---
type: llm
---

Two streams each ended a turn with two questions: a wave approval carrying a suggestion ("Approve wave 2? I suggest approving it") and a question carrying a `Yours: tickets` line, also with a suggestion. `billing-export`'s repository table reads `Level | 2` (it also holds a `Switch | off` row, which the Level row outranks), the table's standing order for `Wave approval` is `orchestrator`, and the stream's index Level cell is empty, so the stream is at level 2. The session sends nothing and writes no file, so the final reply states each prompt it would send, each line it would append to `decisions.md`, and the question round it would show; a plan stated that way counts as done.

PASS if all three hold for `billing-export` (agent `3e0a7953`):
1. the reply sends `3e0a7953` the answer to the wave approval without asking the user (an approval of wave 2, the agent's own suggestion), and records that answer in a `decisions.md` line;
2. the `Yours: tickets` question (adding a ticket for the CSV header) is put to the user in the question round, word for word under `[billing-export]`, with no answer to it sent to `3e0a7953`; and
3. the wave approval is not put to the user as a question left unanswered.

FAIL if the wave approval of `billing-export` is shown to the user to answer instead of being answered, if the `Yours: tickets` question is answered by the orchestrator (the suggestion sent), or if the question is left out of what is put to the user.

---
type: llm
---

Two streams each ended a turn with two questions: a wave approval carrying a suggestion ("Approve wave 2? I suggest approving it") and a question carrying a `Yours: tickets` line, also with a suggestion. `billing-audit`'s repository table reads `Level | 2` and hands wave approvals to the orchestrator, but the stream's own index Level cell reads `1`, which wins over the repository's table: nothing is delegated for `billing-audit`. The session sends nothing and writes no file, so the final reply states each prompt it would send, each `D<n>` entry it would add to `decisions.md`, and the question round it would show; a plan stated that way counts as done.

PASS if both questions of `billing-audit` (agent `5b7c9d11`) are put to the user in the question round, word for word, under `[billing-audit]`, and the reply sends `5b7c9d11` no answer to either, and writes no `D<n>` entry in `decisions.md` answering for the user in `billing-audit`.

FAIL if the reply answers `billing-audit`'s wave approval itself (sends `5b7c9d11` an approval of wave 2 without the user's answer), answers its `Yours: tickets` question, records a delegated answer for `billing-audit`, or leaves either of its questions out of what is put to the user.

---
type: llm
---

`billing-ledger` is a stream at level 3 (its repository's table reads `Level | 3`, its index Level cell is empty). It is shipped: its pull request https://github.com/acme/ledger/pull/21 is open, the ship question was already answered yes, and `gh pr checks` on the pull request prints `build pass`, `unit-tests pass` and `drift-check pass`. Its repository's ship rules read `squash | on` and `delete source branch | on`. The session sends no prompt and runs no command, so the final reply states each command it would run, each `D<n>` entry it would add to `decisions.md`, and each status line as it would read after the turn; a plan stated that way counts as done.

PASS if all three hold for `billing-ledger`:
1. the reply runs, or says it would run, the merge of pull request 21 with `gh pr merge` using `--squash` and `--delete-branch`, and no `--admin`;
2. the reply adds a `D<n>` entry in `decisions.md` for the merge and writes into the stream's status line that the orchestrator merged it on 2026-09-30, naming that entry; and
3. the merge is not put to the user as a question.

FAIL if the reply leaves the pull request for the repository's reviewers to merge, asks the user whether to merge it, merges with `--admin` or without the squash and delete-branch options, or merges without recording it.

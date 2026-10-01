---
max_turns: 25
timeout_seconds: 400
allowed_tools: [Read, Glob, Grep]
append_system_prompt: |
  Observed-state block. Paseo's MCP server and a shell cannot run inside this session; this block states what they report, in their place. Now is 2026-09-30 10:05.
  - Paseo's MCP tools: available to this session.
  - Files and Paseo calls: this session writes no file and sends no prompt. State in your final reply each prompt you would send (to which agent, with its exact text), each `D<n>` entry you would add to `decisions.md`, each status line of `streams.md` as it would read after this turn, in full, and the question round you would show the user, word for word, instead of doing it.
  - The reconcile heartbeat `streams-reconcile` (this session's, expires 2026-09-30 19:00) fires now with its prompt: "Reconcile tick: run step 5 of the matt-with-paseo-streams skill on streams.md".
  - Agents: billing-export `3e0a7953` "[Stream] billing-export", labels `stream=billing-export` (no `wave` label), idle; billing-audit `5b7c9d11` "[Stream] billing-audit", labels `stream=billing-audit` (no `wave` label), idle. `get_agent_status` on each: lifecycle idle, no error, context under 200000 of 1000000 tokens. No ticket agent runs.
  - Pending permissions (`list_pending_permissions`): none. Open pull requests from either integration branch: none. The plugin has reported no `Appetite passed`.
  - The `## Delegation` table in `/srv/src/shop/AGENTS.md` (billing-export's repository), read in the stream's worktree; `/srv/src/shop-admin/AGENTS.md` (billing-audit's repository) holds the same table except that it has no `Switch` row:
    | Rule | Value |
    |---|---|
    | Level | 2 |
    | Switch | off |
    | Questions the orchestrator may decide | two-way, costly |
    | Appetite | 20 USD |
    | Stage confirmation | orchestrator |
    | Wave approval | orchestrator |
    | Question-type permission | orchestrator |
    | Overlap warning | orchestrator |
  - The last end-of-turn message of `3e0a7953` (billing-export), of 2026-09-30 10:01, the same message in the same shape for `5b7c9d11` (billing-audit) at 10:02 with its own slug: "Wave 1 is merged. Two questions for you:
    1. Wave 2 would run tickets 03 and 04 (03 is unblocked, the vendor schema landed). Approve wave 2? I suggest approving it.
    2. The spec lists no ticket for the CSV header, and the finance team's export needs one. Add a ticket for the CSV header, or leave the header out of this stream? Yours: tickets. I suggest adding the ticket."
  - Neither message has been shown to the user yet, and the user has said nothing about either stream since the last round.
  - Two more streams are at their last stage and shipped, both at level 3: `billing-ledger` (repository `/srv/src/ledger`, agent `6d2f8a40`, idle) and `billing-refunds` (repository `/srv/src/refunds`, agent `7e3a9b51`, idle), each stream agent labelled `stream=<slug>` with no `wave` label, with a clean worktree and no question pending. Each repository's `AGENTS.md` holds the same `## Delegation` table as `billing-export`'s except `Level | 3`, `Questions the orchestrator may decide | two-way, costly, one-way` and no `Switch` row; each index Level cell is empty. The plugin has reported no `Appetite passed` for either.
  - Each repository's ship rules on `origin/main` read `squash | on` and `delete source branch | on`; every other key is its default. The ship question of each stream was answered yes by the orchestrator earlier (its `D<n>` entry exists in `decisions.md`, D1 for `billing-ledger` and D2 for `billing-refunds`, the highest `D<n>` being D2), the ship branch is pushed, and the pull request is open and unmerged (`gh pr view <url> --json state --jq .state` prints `OPEN`), with no `autoMergeRequest` set.
  - `billing-ledger`'s pull request is https://github.com/acme/ledger/pull/21: `gh pr checks https://github.com/acme/ledger/pull/21` prints `build pass`, `unit-tests pass` and `drift-check pass`. `billing-refunds`'s pull request is https://github.com/acme/refunds/pull/8: `gh pr checks https://github.com/acme/refunds/pull/8` prints `build pass` and `unit-tests fail`, and its status line records no fix pass sent.
---

/matt-with-paseo:matt-with-paseo-streams billing-export

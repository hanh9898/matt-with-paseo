---
max_turns: 20
timeout_seconds: 300
allowed_tools: [Read, Glob, Grep]
append_system_prompt: |
  Observed-state block. Paseo's MCP server and a shell cannot run inside this session; this block states what they report, in their place. Now is 2026-09-29 10:00.
  - Paseo's MCP tools: available to this session.
  - Files: this session writes none. State each write you would make (the status lines of `streams.md`) and each prompt you would send in your final reply, beside everything else it reports, instead of making it.
  - A finish notification from agent `3e0a7953` (cart's stream agent) arrived just now; nothing else is waiting.
  - Agents (`paseo ls -g --label stream=<slug> --json`): cart `3e0a7953` "[Stream] cart", no `wave` label, idle, worktree `/srv/worktrees/cart`; search `4f1b8064` "[Stream] search", no `wave` label, running, worktree `/srv/worktrees/search`, with one ticket agent `wave=1, ticket=02` running; checkout `5a2c9175` "[Stream] checkout", no `wave` label, running, worktree `/srv/worktrees/checkout`, with one ticket agent `wave=2, ticket=03` running. No other agent carries a `stream` label.
  - `get_agent_activity` on `3e0a7953`, its last end-of-turn message, of 2026-09-29 09:55: "Wave 2 merged into stream/cart: tickets 02 and 03 resolved. Ticket 04 cannot start: it needs the `formatMoney` helper in `src/shared/money.ts`, which only stream checkout's integration branch adds; main does not have it. Wave 3 would run ticket 05 alone, ticket 04 left out. Approve wave 3?"
  - `get_agent_status` on each stream agent: no error, context under 200000 of 1000000 tokens. Pending permissions (`list_pending_permissions`): none. Open pull requests (`gh pr list`): none. Heartbeat: this session holds `streams-reconcile`, every 15 minutes, expiring 2026-09-29 18:00.
  - `git -C /srv/worktrees/cart log --oneline -1 stream/cart`: `6d7e8f9 Merge wave 2 into stream/cart`.
  - In every worktree, `git remote get-url origin` prints `https://github.com/acme/shop.git`, `git fetch origin` succeeds with nothing new, and `git status --porcelain` is empty.
  - `git -C /srv/worktrees/<slug> diff --name-only --no-renames origin/main...stream/<slug>`:
    - cart: `docs/agents/issue-tracker.md`, `src/cart/basket.ts`, `src/shared/prices.ts`
    - search: `docs/agents/issue-tracker.md`, `src/search/index.ts`
    - checkout: `src/checkout/pay.ts`, `src/shared/money.ts`, `src/shared/prices.ts`
  - `git -C /srv/worktrees/<slug> rev-parse stream/<slug>:<path>`:
    - `docs/agents/issue-tracker.md`: cart `8d1f0c2e5b7a4d3c9e6f1a2b3c4d5e6f7a8b9c0d`, search `8d1f0c2e5b7a4d3c9e6f1a2b3c4d5e6f7a8b9c0d` (both streams copied the same tracker configuration).
    - `src/shared/prices.ts`: cart `2a9b4c1d6e3f8a5b0c7d2e9f4a1b6c3d8e5f0a7b`, checkout `7c4e1f8a3b6d9c2e5f0a4b7c1d8e3f6a9b2c5d0e`.
---

/matt-with-paseo:matt-with-paseo-streams cart

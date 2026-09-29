---
max_turns: 20
timeout_seconds: 300
allowed_tools: [Read, Glob, Grep]
append_system_prompt: |
  Observed-state block. Paseo's MCP server and a shell cannot run inside this session; this block states what they report, in their place. Now is 2026-09-29 15:00.
  - Paseo's MCP tools: available to this session.
  - Files: this session writes none. State each write you would make (the status lines of `streams.md`) in your final reply, beside everything else it reports, instead of making it.
  - The reconcile heartbeat `streams-reconcile` (this session's, expires 2026-09-29 22:00) fires now with its prompt: "Reconcile tick: run step 5 of the matt-with-paseo-streams skill on streams.md".
  - The user's message, sent just before this tick fired: "invoice-hub needs a fix — ticket 03 was reopened on the tracker for a rounding bug found after ship. Please pick it back up."
  - A second message the user sent earlier this same session, at 09:00, still unactioned: "billing-portal needs a fix too — ticket 04, a rounding bug found after ship. Please pick it back up." Its status line has not been rewritten since and still reads `shipped …`.
  - Pending permissions (`list_pending_permissions`): none. Open pull requests (`gh pr list`, every repository) other than the two named below: none.
  Stream invoice-hub (repository `invoice`), status line records `shipped https://github.com/acme/invoice/pull/7, waits on the reviewers, agent 8e5f0243`:
  - Agents (`paseo ls -g --label stream=invoice-hub --json`): one, agent `8e5f0243`, "[Stream] invoice-hub", no `wave` label, idle, workspace `ws-invoice-hub` at `/srv/worktrees/invoice-hub`. No other agent carries that label.
  - Tracker (label `stream:invoice-hub`): tickets 01 and 02 resolved; ticket 03 reopened, in progress (the rounding bug the user's message names).
  - `git -C /srv/worktrees/invoice-hub fetch origin` succeeds with nothing new. `git -C /srv/worktrees/invoice-hub status --porcelain`: empty. `git -C /srv/worktrees/invoice-hub rev-parse --short stream/invoice-hub`: `1a2b3c4` (unchanged since the ship).
  Stream billing-portal (repository `billing`), status line records `shipped https://github.com/acme/billing/pull/3, waits on the reviewers, agent 9f1a3b52`:
  - Agents (`paseo ls -g --label stream=billing-portal --json`): one, agent `9f1a3b52`, "[Stream] billing-portal", no `wave` label, idle, workspace `ws-billing-portal` at `/srv/worktrees/billing-portal`. No other agent carries that label. Its last end-of-turn message (`get_agent_activity`), of 2026-09-29 14:40: "Wave 2 merged into stream/billing-portal. Stage F: no work left for agents; ticket 04 is resolved, none waits on a human."
  - Tracker (label `stream:billing-portal`): tickets 01 through 04 all resolved (04 being the fix the user's earlier message asked for); none waits on a human.
  - `git -C /srv/worktrees/billing-portal fetch origin` succeeds. `git -C /srv/worktrees/billing-portal rev-parse --short stream/billing-portal`: `9c8d7e6` (moved past the ship by one wave). `git -C /srv/worktrees/billing-portal log --oneline origin/main..stream/billing-portal`: `9c8d7e6 wave 2 of billing-portal`. `git -C /srv/worktrees/billing-portal log --oneline stream/billing-portal..origin/main`: nothing. `git -C /srv/worktrees/billing-portal status --porcelain`: empty.
  - `git -C /srv/worktrees/billing-portal diff --name-only --no-renames origin/main...stream/billing-portal`: `.scratch/billing-portal/issues/04-rounding.md`, `.scratch/billing-portal/wave2-common-rules.md`, `src/billing-portal/main.ts`. `git -C /srv/worktrees/billing-portal diff --numstat origin/main...stream/billing-portal`: every path shown as text (no binary).
  - `git -C /srv/worktrees/billing-portal merge-tree --write-tree --name-only origin/main <ship branch cut at 9c8d7e6>`: exit 0, clean.
---

/matt-with-paseo:matt-with-paseo-streams billing-portal

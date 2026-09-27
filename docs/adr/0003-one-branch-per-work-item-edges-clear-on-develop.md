---
status: accepted
---

# One integration branch per work item; a cross-item edge clears only when the blocker is in develop

Unrelated work items ship at different times, so each gets its own integration branch (one spec, one integration branch, as Matt's `implement-spec` does) and reaches `develop` through its own pull request, which a human merges. A consequence that looks surprising: when work item B depends on work item A, B does not start (or opens no further wave) until A's pull request is merged into `develop`, and B's branch then merges `develop` at a wave boundary. A dependency on another work item's ticket therefore waits for a human merge, not for the ticket's merge into A's branch.

## Considered Options

- One integration branch per stream: rejected, a finished bug would wait for an unrelated feature of the same requester before reaching `develop`.
- Several integration branches inside one wave: rejected, it changes the base commit, merge and seam-review steps of the wave skill and still cannot carry an edge across branches.

---
status: accepted
---

# One integration branch per work item; dependent requests become one work item

Each work item gets its own integration branch (one spec, one integration branch, as Matt's `implement-spec` does) and reaches `develop` through its own pull request, which a human merges. Inside one stream, requests that depend on each other become **one work item** by default: one branch, one pull request, one ticket graph, so the wave skill runs unchanged. Only when the user asks to split them do they stay separate work items with an edge, and then the dependent one does not start (or opens no further wave) until the other's pull request is merged into `develop`, merging `develop` at a wave boundary.

## Considered Options

- Wait for `develop` as the default for every dependency: rejected as the default, dependencies inside a stream are common and each one would wait for a human merge; kept as the opt-in when separate pull requests are wanted.
- Stacked branches (the dependent branch starts from the blocker's branch, its pull request retargeted to `develop` later): rejected, it needs pull-request retargeting and a re-merge whenever review changes the blocker.
- One integration branch per stream: rejected, an independent bug would wait for an unrelated feature of the same requester.

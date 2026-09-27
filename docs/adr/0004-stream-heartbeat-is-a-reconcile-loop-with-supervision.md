---
status: accepted
---

# The stream skill's heartbeat is a reconcile loop with one-for-one supervision

Each heartbeat tick compares the **desired state** (the index: which streams should run, with which quota) with the **observed state** (agents labelled `stream=`, ticket status, branches, open pull requests) and takes one idempotent action to close the gap. Recovery after the top session dies is one tick run by a new session; no separate recovery procedure exists. The loop also catches turns that end without a notification (probe A2).

Stream agents are supervised one-for-one: a failed stream is restarted alone, within a restart budget (for example two per wave); past the budget the stream stops and goes to the user. This replaces "respawn after every wave".

## Considered Options

- A heartbeat that only checks reports: rejected, it needs its own recovery path and misses state drift.
- Restart without a budget: rejected, a stream that keeps failing would loop without a human seeing it.

---
type: llm
---

The control folder's index has one stream, `billing-export`, in `/srv/src/billing`. Paseo also lists two ticket agents with a `wave` label and no `stream` label, in worktrees of `/srv/src/opms` on `wave2/…` branches: a wave-skill run started outside any stream, in a repository no index row names. The command lists the index.

PASS if the reply reports that run (the repository `/srv/src/opms`, its wave 2 or its agents or branches) and proposes adopting it as a stream, leaving the adoption to the user's answer (it asks whether to adopt, or which slug, owner or PR target to use).
FAIL if the reply does not mention the run in `/srv/src/opms`; mentions it with no proposal to adopt it as a stream; or states the adoption as done or decided without asking the user.

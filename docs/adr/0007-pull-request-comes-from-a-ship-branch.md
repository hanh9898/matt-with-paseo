---
status: accepted
---

# The pull request comes from a ship branch that leaves agent-only paths out

This refines 0003: the pull request's head is a ship branch, not the integration branch itself. At each ship the stream skill cuts `stream/<slug>-ship` from the integration branch's head and adds one commit that restores the agent-only paths to the PR target's version. The agent-only paths are derived from the repository, not kept by hand: the ticket folder, the wave files, and the tracker configuration files the stream added or changed. Binary evidence is never committed; it is attached to the pull request.

Before the user is asked, the ship branch is checked for a clean merge into the PR target. The ship question lists the paths left out, the evidence to attach and the merge danger, and the user can keep a path in, for a ticket whose real deliverable is one of those files. The integration branch keeps everything, so the next wave and a later ship see the same history.

## Considered Options

- The integration branch as the pull request's head (0.4.1): rejected, merge requests in the first real run carried tickets, wave files and tracker configuration into the target repository and conflicted with each other.
- Keeping agent-only files off the integration branch: rejected, the wave skill needs them there to locate a stage and recover a wave.
- A hand-kept list of paths to drop: rejected, it goes stale as tracker configurations and ticket folders differ between repositories.

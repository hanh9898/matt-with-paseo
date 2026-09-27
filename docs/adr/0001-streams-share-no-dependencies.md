---
status: accepted
---

# Streams share no dependencies; the stream layer holds no graph

Several requesters each hand over work. A **stream** is one set of tickets that ships through one integration branch and one pull request; its requester is an attribute of it. Dependencies exist only between tickets inside one stream, where the wave skill already runs them. No dependency ever crosses a stream boundary, so the stream layer keeps no dependency graph: streams run in parallel, coordinated only by the shared agent cap, priority, reporting, and a warning when two streams edit the same file in one repo.

## Considered Options

- A layer of work items between streams and tickets, with edges derived from tickets: rejected, the user keeps wave operation inside a stream as it is today, and a stream that must ship separately is opened as its own stream.
- A stream as a dependency layer: rejected, streams do not depend on each other.

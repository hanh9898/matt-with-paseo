---
status: accepted
---

# A stream is a colouring of work items, not a layer of the dependency graph

Several requesters each hand over several work items. Work items of different requesters never depend on each other; dependencies exist only inside one requester's set. We therefore model dependencies only between tickets and between work items, and treat a **stream** (everything one requester handed over) as a colouring of work items: no dependency edge ever crosses a stream boundary, so streams run in parallel with no coordination beyond the shared agent cap, priority, reporting, and a warning when two streams edit the same file in one repo. A stream is not itself a node or a layer of the graph.

## Considered Options

- One ticket graph per stream, one integration branch per work item: rejected, a ticket could never see code merged into another work item's branch, so the graph would promise dependencies it cannot run.
- A stream as a dependency layer above work items: rejected, streams do not depend on each other.

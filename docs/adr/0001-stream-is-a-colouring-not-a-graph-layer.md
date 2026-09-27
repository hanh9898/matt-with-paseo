---
status: accepted
---

# A stream is a colouring of work items, not a layer of the dependency graph

Several requesters each hand over several, possibly unrelated, work items. We model two dependency graphs (tickets inside a work item; work items, as the quotient of ticket edges that cross work-item boundaries) and treat a **stream** (everything one requester handed over) only as a colouring of work-item nodes, used for priority, capacity and reporting, never carrying dependency edges. Dependencies can run between two requesters' work items, so any "one graph per stream" layer either misses real edges or duplicates them; a first design that ran one ticket graph per stream broke as soon as work items had their own branches (a ticket could never see code merged into another work item's branch).

## Considered Options

- One ticket graph per stream, one integration branch per work item: rejected, cross-item edges cannot flow across separate branches, so the promised width gain was not real.
- A stream as a dependency layer above work items: rejected, streams do not depend on each other; their work items do.

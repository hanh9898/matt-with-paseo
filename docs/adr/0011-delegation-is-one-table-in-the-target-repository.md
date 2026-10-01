---
status: accepted
---

Amended by ADR 0013 (three autonomy levels).

# Delegation is one table in the target repository, and five items stay the user's

The target repository's `AGENTS.md` may hold a `## Delegation` section with one policy table of two-cell rows, which the stream skill reads in the stream's worktree and never writes (as ADR 0008 treats the ship rules). The rows follow the plugin's contract v1, which reads them: `Switch` (`on` means delegation is on; a table with no `Switch` row is `on`), `Questions the orchestrator may decide` (door classes, only `two-way` and `costly` count) and `Appetite` (a spend limit per stream, in USD; the plugin sums the spend). The skill adds four rows the plugin ignores, the standing orders by checkpoint kind: `Stage confirmation`, `Wave approval`, `Question-type permission` and `Overlap warning`, each `orchestrator` or `user`, a missing row meaning `user`.

With no `## Delegation` section, every checkpoint reaches the user, exactly as before. A stream's own `Delegation` cell in the index (`on` or `off`) wins over the repository's `Switch`; an empty cell means the repository's value. With delegation on, the orchestrator answers a checkpoint only when its kind's standing order is `orchestrator`, the asking agent gave a recommendation (a question with none waits for the user), its door class is one the table lets it decide, and it is none of the user's five items. The answer is the recommendation, never a choice of the orchestrator's own.

See ADR 0013 for the `Level` row, which replaces this on/off switch with levels 1, 2 and 3.

Five items stay the user's, whatever the table says: a change to the concept (spec, words, ADRs); adding or dropping tickets (an intake agent still starts only when the user names it, ADR 0005); spend past the appetite; an irreversible action (the ship question, an action that changes the machine, anything that needs credentials, resuming a stream stopped on its restart budget); merging the pull request.

See ADR 0013 for what level 3 opens of these five and the three items every level keeps with the user.

A delegated answer is one of the orchestrator's own decisions: it gets one `decisions.md` entry (the question, the answer sent, the grounds), and the stream's status line names that entry in place of `waits on the user`. This amends the stream skill's rule that a stream's decisions stay out of `decisions.md`, for delegated answers only, and it amends the README's promise that the stream skill "never answers for you": it answers only what the table hands it, and the README says when.

## Considered Options

- Delegation written by hand into the control folder's `CLAUDE.md`, as users did before: rejected, the stream skill forbids an operating rule in a file of the control folder, and the repository's own maintainers could not see or change it.
- The switch named "in the loop", on by default: rejected in favour of contract v1's `Switch` row, which the plugin already reads; `Switch: on` means delegation on, and the skill states that direction so it cannot be misread (a table with no `Switch` row counts as `on`, so a table is written with its row).
- The index holding the delegation rules, with the repository's table only a default: rejected, only the on/off switch may be overridden per stream; the rows stay with the repository, as the ship rules do (ADR 0008).
- Letting the table widen the five items, for a repository that wants full autonomy: rejected, each is a concept, cost or irreversibility the user must pass, and the plugin never answers the same items.
- The orchestrator choosing an answer of its own when the agent gave no recommendation: rejected, that is the user's judgment; the question waits.

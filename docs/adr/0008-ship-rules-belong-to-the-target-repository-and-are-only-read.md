---
status: accepted
---

# Ship rules belong to the target repository and are only read

The target repository declares its own **ship rules**: a key-to-value table in a document its `## Agent skills` section points to. The stream skill reads them from the pull-request target on the remote, at setup and again at ship, and never writes or edits them; a repository with no ship rules ships on the skill's own defaults. Only the **ship branch** reaches the remote (ADR 0007's left-out paths stand unchanged); the integration branch and ticket branches keep the fixed names ADR 0003 and ADR 0002 already rely on, whatever the ship rules say. The index's optional Key column holds a stream's external reference for the `<key>` placeholder; it is data about the stream, not a rule, and the index carries no override of the repository's own ship rules.

## Considered Options

- Ship rules kept in the control folder, or the index overriding the repository's rules: rejected, the repository's own maintainers would then need access to the operator's control folder to change how their own repository ships.
- The orchestrator writing or editing ship rules in the target repository: rejected, the first real run did this once, landing a forge section into the target repository and shipping that change inside its own merge request.
- Pushing the integration branch, even as a backup: rejected, ADR 0007 already keeps agent-only paths off the pull request; a backup push of the integration branch would defeat that.
- Customising the integration or ticket branch names per repository: rejected, it would break the seam between the two skills (ADR 0002) and git's branch-prefix rule, the reason `stream/<slug>` is not the bare slug (the wave skill's `TROUBLESHOOTING.md`, "`create_workspace` fails because git cannot create the ticket branch under the `stream` prefix").

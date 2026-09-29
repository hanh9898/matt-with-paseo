# Ship rules

The stream skill (`plugins/matt-with-paseo/skills/matt-with-paseo-streams/SKILL.md`, the words entry **Ship rules** and step 6) reads this table from the pull-request target on the remote, at setup and again at ship. A key left out falls back to the stream skill's own default for that key alone.

| Key | Value |
|---|---|
| ship branch | `ship/<slug>` |
| title | |
| description template | `/mattpocock-skills:pr` |
| draft | off |
| labels | |
| reviewers | |
| assignees | |
| squash | not set |
| delete source branch | not set |
| ship commit message | `chore(ship): leave agent-only paths out` |
| wave merge message | `Merge ticket <ticket> (<name>) into stream/<slug>` |

`ship branch` is set because the stream skill's default, `stream/<slug>-ship`, starts with `stream/`, which its own name check refuses. An empty `title` keeps the default: a one-line summary of the stream's work.

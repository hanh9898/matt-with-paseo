## Agent skills

### Issue tracker

Issues and specs live in GitHub Issues for `hanh9898/matt-with-paseo`, via `gh`. See `docs/agents/issue-tracker.md`.

### Triage labels

Default vocabulary: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`. See `docs/agents/triage-labels.md`.

### Domain docs

Single-context; the vocabulary is the words block in `plugins/matt-with-paseo/skills/matt-with-paseo/SKILL.md`, and the stream skill's words block (`plugins/matt-with-paseo/skills/matt-with-paseo-streams/SKILL.md`) adds only **Stream**, **Intake agent**, **Pause**, **Ship branch** and **Ship rules** (**Hold** is in the wave skill's block); no `GLOSSARY.md`. Decisions are ADRs in `docs/adr/`. See `docs/agents/domain.md`.

### Ship rules

How a stream's pull request is named and opened: `docs/agents/ship-rules.md`.

## Evidence standards

How this repo proves a change works: `docs/agents/evidence-standards.md`. Each ticket runs its own new or changed test file once, red then green; each merge runs only the conflict-marker search; CI runs every unit test and the drift check on each pull request into `main`, and a red pull request is never merged; one code review, one fix pass and one eval run once per stream, after its last wave.

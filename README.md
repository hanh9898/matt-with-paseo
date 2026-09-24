# matt-with-paseo

A simple multi-agent orchestrator for Claude Code. It combines [Matt Pocock's skills](https://github.com/mattpocock/skills) (grill, spec, tickets, TDD, code review) with [Paseo](https://paseo.sh), a control plane for running many coding agents at once.

You write the tickets with Matt's skills. `matt-with-paseo` runs them in **waves**: every ticket gets its own Paseo agent in its own git worktree, and the orchestrator merges, reviews, and cleans up before starting the next wave.

## Why

Matt Pocock's skills take a feature from a vague idea to a set of small, dependency-ordered tickets. Running those tickets is still sequential by default: `/implement` works through them one at a time in a single session.

Paseo can run many agents in parallel, each in its own worktree. What it does not know is which tickets are safe to run together, what each agent needs to be told, or how to check and merge the results.

`matt-with-paseo` fills that gap with one skill:

- It **locates** where your work stands (not configured, grilling, spec, tickets, a wave in progress, finished) and suggests one next step.
- It **splits** tickets into waves from their `Blocked by` lines, so only independent tickets run side by side.
- It writes one **common rules** file per wave, so every agent gets the same context and each prompt stays four lines long.
- It **checks** each agent's work against the real artifacts (commits, ticket status, a re-run of the key claim) instead of trusting the report.
- It **merges** each ticket as soon as it checks out, **starts** the tickets that merge unblocks, reviews the **seams** between tickets, then **cleans up** worktrees and agents only when that is safe.

The wave file doubles as a log, so a new session can pick up a half-finished wave where the last one stopped.

## How it works

```
idea ──► grill ──► spec ──► tickets ──► wave 1 ──► wave 2 ──► ... ──► done
        (Matt's skills, typed by you)    (this skill + Paseo agents)
```

Each run starts by locating the current stage from what is on disk:

| Stage | Signal in the repo | Suggested next step |
|---|---|---|
| A. Not configured | no `docs/agents/issue-tracker.md` | `/mattpocock-skills:setup-matt-pocock-skills` |
| B. Idea not sharp | no spec, terms missing from `CONTEXT.md` | `/mattpocock-skills:grill-with-docs` |
| C. Grilled, no spec | decisions in `CONTEXT.md` or an ADR | `/mattpocock-skills:prototype` or `/mattpocock-skills:to-spec` |
| D. Spec, no tickets | spec exists, `issues/` empty | `/mattpocock-skills:to-tickets` |
| E. Tickets, no wave yet | tickets exist, no `wave*-common-rules.md` | start wave 1 |
| F. Wave in progress | a wave file with unfinished tickets | resume the missing step |
| G. Finished | every ticket `resolved` or `ready-for-human` | summary |

Each wave then goes through the same loop:

1. **Prepare**: read Paseo profiles, the ticket tracker, and the integration branch.
2. **Split**: draw the dependency graph and put every ticket that can run now into the wave. It also lists what is costing width (a ticket waiting on a human, a `Blocked by` that is only a shared file) with the one question that would unblock it. You approve it.
3. **Common rules**: pin a base commit and write `wave<N>-common-rules.md` from the template.
4. **Spawn**: one worktree and one agent per ticket. Symptom tickets run `diagnosing-bugs` then `tdd`; behaviour tickets run `tdd`. Every flow ends with `code-review`, as Matt's `/implement` does.
5. **Check**: verify each report against commits, ticket status, and a re-run of its key claim.
6. **Merge**: one `--no-ff` merge per ticket as soon as its report is checked, with a cheap verification after each; any ticket that merge unblocks starts right away in the same wave (rolling start).
7. **Review the seams**: for waves of two or more tickets, one `code-review` pass over where the tickets touch; findings go back to the owning agent or get fixed on the integration branch.
8. **Clean up**: archive agents and worktrees that are stopped, clean, and merged; then open the next wave.

The skill asks for your approval at the decisions that are yours: the stage and next step, the wave plan, and any question a review raises.

## Requirements

- [Claude Code](https://claude.com/claude-code)
- [Paseo](https://paseo.sh), with its MCP server available to the orchestrating session and its `paseo` skill installed
- [Matt Pocock's skills](https://github.com/mattpocock/skills), installed as the `mattpocock-skills` Claude Code plugin. The skill suggests commands in the plugin's namespaced form, `/mattpocock-skills:<skill>`; if you installed Matt's skills another way, type the same skill without the prefix (`/<skill>`).
- A git repository whose tracker is configured by `/mattpocock-skills:setup-matt-pocock-skills`

## Installation

The repo follows the [Agent Skills](https://agentskills.io/specification) layout (`skills/matt-with-paseo/SKILL.md`) and is also a Claude Code plugin marketplace, so any of these works. Pick one; installing twice gives you two copies of the command.

### Option 1: Claude Code plugin

```
/plugin marketplace add hanh9898/matt-with-paseo
/plugin install matt-with-paseo@matt-with-paseo
```

Updates arrive through `/plugin marketplace update`. Plugin skills are namespaced, so the command is `/matt-with-paseo:matt-with-paseo`.

### Option 2: `npx skills`

```bash
npx skills add hanh9898/matt-with-paseo -g -a claude-code
```

`-g` installs for your user; drop it to install into the current project. The command is `/matt-with-paseo`.

### Option 3: GitHub CLI (v2.90+)

```bash
gh skill install hanh9898/matt-with-paseo matt-with-paseo --agent claude-code --scope user
```

This resolves the latest tagged release; add `--pin v0.1.0` to fix a version. The command is `/matt-with-paseo`.

### Option 4: Manual copy

macOS / Linux:

```bash
git clone https://github.com/hanh9898/matt-with-paseo.git
cp -r matt-with-paseo/skills/matt-with-paseo ~/.claude/skills/
```

Windows (PowerShell):

```powershell
git clone https://github.com/hanh9898/matt-with-paseo.git
Copy-Item -Recurse matt-with-paseo\skills\matt-with-paseo "$env:USERPROFILE\.claude\skills\"
```

To use it in one project only, copy it into that project's `.claude/skills/` instead. The command is `/matt-with-paseo`.

## Usage

In a Claude Code session inside your repository (with the plugin install, use `/matt-with-paseo:matt-with-paseo`):

```
/matt-with-paseo
/matt-with-paseo <feature name or ticket folder>
```

The skill is user-invoked only (`disable-model-invocation: true`): it starts agents and merges branches, so it runs when you ask for it.

Files it writes, next to your ticket folder:

- `wave<N>-common-rules.md`: the rules every agent of wave N reads, followed by the wave's agent table and review log.

Files in this repo:

| File | Purpose |
|---|---|
| [`skills/matt-with-paseo/SKILL.md`](skills/matt-with-paseo/SKILL.md) | The orchestrator: locate, then steps 1 to 8 |
| [`skills/matt-with-paseo/COMMON-RULES-TEMPLATE.md`](skills/matt-with-paseo/COMMON-RULES-TEMPLATE.md) | The frame for each wave's common rules |
| [`skills/matt-with-paseo/TROUBLESHOOTING.md`](skills/matt-with-paseo/TROUBLESHOOTING.md) | Symptoms and fixes for stopped agents, merge conflicts, and cleanup |
| [`.claude-plugin/`](.claude-plugin/) | Marketplace and plugin manifests for the Claude Code plugin install |

## Design principles

- **Width first.** Parallel work is the point: each wave takes every ticket that can run, the orchestrator names what blocks the rest, and a ticket starts the moment its blockers merge.
- **Every step ends on a checkable "done when".** The orchestrator can tell finished from unfinished without judgement calls.
- **Check artifacts, not reports.** An agent's "all green" only covers what it checked.
- **Red before green.** A bug fix counts only if its test failed on the symptom before the fix.
- **Review per ticket, then the seams.** Each agent ends with Matt's `code-review` before its last commit, as `/implement` does; the orchestrator reviews only where tickets collide once merged, and skips that pass for one-ticket waves.
- **Nothing destructive without three checks.** A worktree is archived only when its agent has stopped, its tree is clean, and its branch is merged.
- **State lives on disk.** Ticket status and the wave file are enough for a fresh session to resume.

## Limitations

- Tested with Claude Code on one project. Other agent providers that Paseo supports should work as long as they can load Matt Pocock's skills, but have not been tried.
- Agents can only run model-invocable skills. `implement`, `to-spec`, `to-tickets`, `grill-with-docs`, `triage`, and `wayfinder` are user-only, so the orchestrator suggests them and you type them.
- The ticket tracker is whatever `setup-matt-pocock-skills` configured; the skill reads it but does not create one.

## Contributing

Issues and pull requests are welcome. The skill follows Matt Pocock's [`writing-for-agents`](https://github.com/mattpocock/skills) guidance, so a good change usually:

- adds a row to a table rather than a new prose branch (new flows go in the step 4 flow table);
- gives every step a checkable completion criterion;
- moves material only some runs need into `TROUBLESHOOTING.md` or a new file behind a pointer, keeping `SKILL.md` short.

When a fix comes from a real incident, describe the symptom you saw in the pull request.

## Acknowledgements

- [Matt Pocock](https://github.com/mattpocock) for the [skills](https://github.com/mattpocock/skills) this orchestrates (MIT).
- [Paseo](https://paseo.sh) for the agent control plane.

## License

[MIT](LICENSE)

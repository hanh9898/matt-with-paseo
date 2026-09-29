# Coding standards

The rules every change to this plugin is reviewed against, on the Standards axis of `mattpocock-skills:code-review`. Cite a rule by its ID (W3, H1, L2, S1) in each finding.

**Scope.** Every document an agent reads: both skills' `SKILL.md`, the common rules template, `TROUBLESHOOTING.md`, `AGENTS.md`/`CLAUDE.md`, the agent docs in `docs/agents/`, the eval prompts and graders in `plugins/matt-with-paseo/evals/`, and this file itself; part 3 covers the scripts in `scripts/`. ADRs and the READMEs are written for people and stay outside it.

## 1. Writing for agents

`mattpocock-skills:writing-for-agents` is the standard. Load that skill for its full text before reviewing a document in scope; the rules below name its levers so a finding can cite one, and the skill's wording wins wherever the two differ.

| ID | Rule | A finding looks like |
|---|---|---|
| W1 | **Context pointers.** A pointer to another document states what the material is and lists each branch that should reach it, leading word first | a line naming a file with no condition for reading it |
| W2 | **Information hierarchy and progressive disclosure.** Steps first, reference on demand; material only some runs need sits behind a pointer (here: `TROUBLESHOOTING.md` or a new file), keeping `SKILL.md` short | a rare case written inline in a step every run reads |
| W3 | **Completion criterion.** Every step ends on a checkable, exhaustive condition (in the skills, its **Done when** line) | a step that ends on "understand", "review" or nothing |
| W4 | **Leading words.** One concept, one word, taken from the words blocks; restated triads collapse into the word | "operator", "gate" and "approval round" for the same thing in one change |
| W5 | **The positive.** State the target behaviour; a prohibition stays only as a hard guardrail, paired with the positive | "don't do X" where "do Y" would say it |
| W6 | **Single source of truth.** Each meaning lives in one place and others point there; nothing restates what a file, a command or `--help` already shows | a naming rule copied from the wave skill's names table into a step |
| W7 | **No-ops.** Every sentence changes behaviour against the model's default; a sentence that does not is deleted whole | "be careful to check the output" |
| W8 | **Sediment.** Every line still bears on what the document does today; a change removes the lines it makes stale | a note about a flag the change removed |

This repo adds house rules of its own, not levers of that skill:

| ID | Rule | A finding looks like |
|---|---|---|
| H1 | **Choices as tables.** A choice between cases is a row in a table, not a new prose branch; a new agent flow is a row in the wave skill's step 4 flow table | an "if the ticket is a bug, otherwise…" paragraph beside the flow table |
| H2 | **Cut for content.** A trim of a document in scope is judged by the behaviour evals that cover it (README, "Behaviour evals") and by the pinned-lines table (`scripts/pinned-lines.json`), never by its word delta; a trim that fails an eval or removes a pinned line is a finding | a sentence cut to shorten a skill while an eval that covers it fails, or a phrase listed in the pinned-lines table no longer stands on one line |

## 2. Loop design

**Checkpoint** and **Brief** are defined in the wave skill's words block ([`SKILL.md`](plugins/matt-with-paseo/skills/matt-with-paseo/SKILL.md), top of the file); read them there before applying these rules to any loop in scope (a skill's run, a heartbeat, a ticket flow).

| ID | Rule | A finding looks like |
|---|---|---|
| L1 | **Trigger.** Each loop says what fires each run: an event (a report arrives, a ticket is resolved) or a schedule (a heartbeat) | a step that repeats without saying when it runs again |
| L2 | **Checkpoint.** Every point where the user decides is written as a checkpoint, and every other step runs without asking | a step that asks the user something the run could settle itself |
| L3 | **Push right.** A checkpoint comes after all the work the run can do before it, so the user is asked once, late, with everything prepared | a question asked before the checks that would answer half of it |
| L4 | **Brief.** Every checkpoint presents a brief | a question that pastes a diff, a log or a whole report instead of linking to it |

Adopt the two words in the passages a change rewrites; passages the change leaves alone keep their wording ("question round", "approval") until a change rewrites them.

This lens is taken from a beta skill in Matt Pocock's skills 1.2.3 (kept in its `skills/in-progress/`, not shipped in the plugin). The rules above are the whole of it, so they hold whether that skill changes or disappears.

## 3. Scripts

| ID | Rule | A finding looks like |
|---|---|---|
| S1 | **Standard library only.** A script runs on a plain Python 3 install | an `import` of a package `pip` would install |
| S2 | **Exit codes.** 0 clean, 1 findings (one line each on stdout), 2 could not run (one error line on stderr) | a missing file reported with exit 1, or a finding with exit 2 |

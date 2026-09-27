# matt-with-paseo 0.3.0: an orchestrator that stays in step with Matt's skills and Paseo

## Problem Statement

I run `matt-with-paseo` to take tickets produced by Matt Pocock's flow and work them in waves of parallel Paseo agents. After seven real waves on one project, three kinds of pain keep coming back.

First, the skill drifts from Matt's skills. It copies parts of Matt's method into its own text: it names the domain doc file (`CONTEXT.md`, which Matt has since renamed to `GLOSSARY.md`), keeps a hand-written list of which Matt skills an agent may invoke (already wrong: one listed skill was removed upstream, one invocable skill is missing), and reproduces Matt's whole routing from setup through grilling, spec, and tickets. Every time Matt changes something, I have to find and fix these copies by hand, and I only notice after something breaks.

Second, I lose track of agents. An agent can report "finished" while its real work is still running in a background command; when that command completes, the agent finishes the work in a turn it starts on its own, and I get no notification for that turn. It went unnoticed for almost two days once. Heartbeats I set up to compensate have to be deleted by hand.

Third, waves carry avoidable manual work and ambiguity: hand-assigned ports and environment setup pasted into every agent prompt, a traps list that only grows and once contained a trap that was simply wrong, no rule for what an agent does when an earlier ticket's instruction contradicts its own acceptance criteria, no place for a project's evidence standards, and a locating step that could mistake a wayfinder decision map for a set of implementation tickets.

## Solution

Version 0.3.0 narrows the skill to what only it does: orchestration. Everything that belongs to Matt's method is pointed to by skill name or read at run time from the target repo's configuration, never copied. When Matt changes his skills, the skill needs little or no change, and a small check tells me before a release if anything it names has moved.

Concretely, the skill stops routing me through setup, grilling, spec, and tickets; when no tickets exist it sends me to Matt's own router, `ask-matt`, where `grill-with-docs` and `wayfinder` are equal on-ramps into `to-spec`. It recognises a wayfinder map and refuses to start a wave on it. It prevents and detects the silent-finish problem with two plain rules instead of new infrastructure. It uses Paseo features that remove hand work (agent activity, labels, stop controls, the target repo's own `paseo.json` for setup and ports, self-expiring heartbeats) and leaves out the ones that would add dependencies or bottlenecks. It gains a few small rules learned from real waves, and a ready-to-send set of Paseo bug reports documents what Paseo itself should fix.

## User Stories

1. As an orchestrator user, I want the skill to name Matt's skills only by name, so that a change inside a Matt skill never requires an edit here.
2. As an orchestrator user, I want the skill to stop describing Matt's setup, grilling, prototype, spec, and ticket stages, so that Matt's own router stays the single source for that route.
3. As an orchestrator user, I want the skill, when it finds no tickets, to tell me the work is not ready for orchestration and suggest `ask-matt`, so that I am sent to the right flow without the skill guessing it.
4. As an orchestrator user, I want `grill-with-docs` and `wayfinder` presented as equal entries into `to-spec`, so that I pick the one that fits the work, not the one the skill happens to mention first.
5. As an orchestrator user, I want the skill to recognise a wayfinder map (a map file beside the tickets, or tickets carrying a ticket-type line) and stop with "decision map, not yet through `to-spec`", so that no wave is ever started on decision tickets.
6. As an orchestrator user, I want the locating step to include the case "N waves done, go back to building the graph", so that a reopened session does not have to infer it.
7. As an orchestrator user, I want the skill to decide whether an agent may invoke a Matt skill by reading that skill's `disable-model-invocation` flag at run time, so that the answer is always current.
8. As an orchestrator user, I want triage roles written by role name and their label strings read from the target repo's triage label file, so that repos with custom label names work and a Matt rename does not break the skill.
9. As an orchestrator user, I want the one terminal status the skill uses for finished tickets kept as the tracker convention already defines it, so that it matches what the tracker writes.
10. As an orchestrator user, I want the explanations of how `tdd`, `code-review`, and `diagnosing-bugs` work internally replaced by pointers, so that only the orchestration-relevant facts (which skill, which fixed point, what to check in the report) remain.
11. As a maintainer, I want a deterministic drift check that lists every Matt skill the skill names and reports any that no longer exist or changed their invocation flag in the installed plugin, so that I learn about upstream drift before a release instead of in a wave.
12. As a maintainer, I want the drift check run by hand before every release, so that it costs nothing between releases.
13. As an orchestrator user, I want the skill's vocabulary to live only in the words block at the top of the skill, so that agents running a wave read the one definition that exists.
14. As an orchestrator user, I want the words block to define Wave, Integration branch, and Common rules, so that the three orchestration concepts are unambiguous.
15. As an orchestrator user, I want the noun "Done" removed and every unit of work, including the agent's own stopping point, to use a "Done when:" line, so that the phrase has one meaning and matches Matt's idiom.
16. As an orchestrator user, I want Common rules defined by role (what every agent in the wave needs to know that its own prompt does not carry), so that the definition survives changes to what the file contains.
17. As an orchestrator user, I want Paseo's words used for Paseo API concepts (for example `provider`) and Matt's words for method concepts, so that terms map cleanly to both systems.
18. As an orchestrator user, I want no new term coined where Matt already has one, so that the skill's language stays a subset of the ecosystem it sits in.
19. As a wave agent, I want a rule that I must not end my turn while work is still running in the background, so that my "finished" report always means the work is done.
20. As an orchestrator user, I want a finished report whose artifacts are not there yet (no commits, no status change) treated as "still working", with a heartbeat created to poll the agent, so that a silent finish is caught.
21. As an orchestrator user, I want every heartbeat the skill creates to carry an expiry, so that a heartbeat never outlives a dead session or needs manual deletion.
22. As an orchestrator user, I want the existing heartbeat rule for agents spawned by an earlier session kept, so that a reopened session still hears from agents it did not start.
23. As an orchestrator user, I want the skill to read an agent's progress and report through Paseo's agent activity, so that I do not reconstruct progress from commits and ticket comments.
24. As an orchestrator user, I want every agent and workspace of a wave labelled with the wave, so that the recovery sweep finds them by label instead of by title.
25. As an orchestrator user, I want the troubleshooting guide to say when to cancel a turn, kill an agent, or archive it, so that I can stop a broken ticket without losing the agent I may redirect.
26. As an orchestrator user, I want the skill to use the target repo's `paseo.json` when it declares worktree setup, so that environment setup is no longer pasted into each agent's prompt.
27. As an orchestrator user, I want the skill to rely on the target repo's `paseo.json` services for per-worktree ports when they exist, so that I stop assigning ports by hand.
28. As a target repo maintainer, I want the skill's guidance to warn that a service must not declare a fixed port, so that worktrees do not silently share one port and serve each other's content.
29. As a target repo maintainer on Windows, I want the guidance to note that worktree setup runs in PowerShell while scripts and terminals run in cmd, so that my `paseo.json` does not fail silently.
30. As an orchestrator user, I want the skill never to write a target repo's `paseo.json` itself, so that environment configuration stays owned by that repo.
31. As an orchestrator user, I want the cleanup step's check that a worktree is clean before archiving kept as mandatory, so that archiving never deletes uncommitted work.
32. As an orchestrator user, I want the cross-ticket review to use a review profile when the host has one whose notes say it is for review, so that I can get an independent judgment without new mechanics.
33. As an orchestrator user, I want the skill to point to the Paseo reference for the exact shape of `create_agent`, so that parameters are not guessed.
34. As an orchestrator user, I want the skill to say that a question-type permission is answered with the answers map in the updated input, so that the agent receives an unambiguous answer and I do not have to repeat it in a follow-up prompt.
35. As a wave agent, I want a rule that a trap or an instruction left by an earlier ticket is guidance, and my ticket's acceptance criteria are the contract, so that I know which wins when they conflict.
36. As a wave agent, I want to follow the acceptance criteria and record the discrepancy and its reason in the ticket's comments, without stopping to ask, so that the wave keeps its width.
37. As a wave agent, I want to stop the affected part, record the evidence, and move the ticket to the ready-for-human role when I believe the acceptance criteria themselves are wrong, so that I never rewrite the contract on my own.
38. As an orchestrator user, I want to check a carried-over trap against the acceptance criteria of the tickets it touches before copying it into the next wave, so that a wrong trap is fixed before an agent trips on it.
39. As an orchestrator user, I want a trap proven wrong marked as wrong (distinct from outdated) in the running wave's log, and not copied forward as written, so that the next wave does not inherit it.
40. As an orchestrator user, I want each trap classified by its existing "how to check you avoided it" column (a command with a clear result is mechanical, prose is judgment), so that classification needs no new vocabulary.
41. As an orchestrator user, I want a mechanical trap kept in the traps list together with its check command, and wiring that command into the target repo's checks proposed as a separate ticket for that repo, so that the skill never edits the target repo on its own.
42. As an orchestrator user, I want judgment traps to stay in each wave's common rules, filtered before copying (a trap that became a check shrinks to a one-line pointer; a wrong trap is fixed or dropped), so that the list stops growing without bound.
43. As an orchestrator user, I want the three-ticket change to the common-rules step written as one sentence, so that the rule reads once, not three times.
44. As an orchestrator user, I want the skill to read a target repo's evidence standards file when the repo declares one, so that project-specific proof (screens, recordings, data checks) is enforced without the skill knowing the tools.
45. As a target repo maintainer, I want the evidence standards file declared outside the block Matt's setup skill regenerates, so that re-running Matt's setup does not erase it.
46. As an orchestrator user, I want the evidence standards file read at preparation, pointed to (not copied) from the common rules, and named explicitly when calling `code-review`, so that the Standards axis checks it even though it is not a coding-standards document.
47. As an orchestrator user, I want a repo without an evidence standards file to proceed normally, so that the feature costs nothing where it is not used.
48. As an orchestrator user, I want the evidence standards file to be free prose, so that each project describes proof in its own terms.
49. As an orchestrator user, I want no new Matt skill chained in (`retro`, `handoff`, `claude-handoff`) and no pull-request step added, so that this release adds no new coupling.
50. As an orchestrator user, I want the one sanctioned copy (pasting the method into prompts when the plugin has not reached a worktree) kept, so that a wave can still run when the plugin is missing.
51. As an orchestrator user, I want the README to describe the two on-ramps and point to `ask-matt` instead of reproducing the removed routing table, so that the README does not become the next copy to drift.
52. As an orchestrator user, I want the README to tell manual installers to copy the plugin manifest alongside the skill, so that a hand-installed copy carries its version number.
53. As an orchestrator user, I want the README to point to the rule that the integration branch is read with `git branch --show-current`, so that a directory name is never mistaken for a branch name.
54. As an orchestrator user, I want waves already running under 0.2.x left as they are, with the new rules applying from the next wave, so that frozen wave files stay consistent.
55. As a maintainer, I want 0.3.0 released as before (bump the plugin manifest, tag after merging to main, no changelog), so that releasing stays cheap.
56. As a maintainer, I want the three Paseo bug reports kept ready to send and not sent by the implementation, so that I decide what goes out and when.

## Implementation Decisions

- **Scope rule for the whole release:** the skill keeps only orchestration (graph and waves, common rules, spawning, checking reports, merging, seam review, cleanup, recovery). Anything that is Matt's method is either a pointer by skill name or read at run time from the target repo; the only sanctioned copy is the fallback that pastes the method into prompts when the plugin is missing. Every change is judged by "if Matt changes this, how many places here must change?".
- **Main skill instructions, locating step:** the table keeps only the three stages that belong to this skill (tickets exist but no wave yet; wave in progress; no work left for agents), unchanged in wording except where the vocabulary changes below. Above the table, two sentences replace the removed stages: no tickets yet means not ready for orchestration, suggest `ask-matt`, stop; a wayfinder map (map file beside the tickets, or tickets with a ticket-type line) means a decision map not yet through `to-spec`, say so, stop. Add the "N waves done, return to building the graph" case. The single-ticket or pure-chain row still points to Matt's `implement`. The frontmatter description shrinks to match. The stage C and D notes and the "two options" sentence are removed with the table. With the removed stages go every mention of the domain doc file name.
- **Main skill instructions, words block:** Wave, Integration branch, Common rules (defined by role). The noun Done is removed; the agent's stopping point in the common rules template becomes a "Done when:" line like every step. No other terms are added; acceptance criteria is Matt's term and needs no definition; notes a ticket leaves for a later one are described, not named, and never called handoff.
- **Main skill instructions, invocation list:** the hand-written list of invocable and human-only Matt skills is replaced by one rule: check the skill's `disable-model-invocation` frontmatter flag.
- **Main skill instructions, triage roles:** preparation also reads the target repo's triage label file; the text uses role names (ready for agent, ready for human, needs triage). The finished-ticket status stays as the tracker convention defines it.
- **Main skill instructions, spawning:** point to the Paseo reference for the `create_agent` shape; label each agent and workspace with its wave; if the target repo's `paseo.json` declares worktree setup or services, rely on them instead of pasting setup or assigning ports, and never write that file; the internal descriptions of `tdd`, `code-review`, and `diagnosing-bugs` shrink to pointers.
- **Main skill instructions, checking reports:** read progress through agent activity; a finished report without its artifacts counts as still working and gets a heartbeat; the existing rule for agents spawned by an earlier session stays.
- **Heartbeat contract** (both cases above): each tick checks the agent's status, the commits on the ticket's branch, uncommitted files in its worktree, and the ticket's comments (what worked in the seventh wave). The orchestrator deletes the heartbeat once the agent has really stopped and its artifacts pass the report check, and at the latest in wave cleanup. The cadence is the orchestrator's choice, always capped by an expiry, so a heartbeat can never outlive its wave.
- **Main skill instructions, common rules step:** one sentence covering three decisions: filter carried-over traps before copying (checks become one-line pointers, wrong traps are fixed or dropped), check each carried trap against the acceptance criteria it touches, and mark proven-wrong traps as wrong in the running wave's log.
- **Main skill instructions, seam review:** use a review profile when one fits; name the evidence standards file in the `code-review` call when the repo has one.
- **Main skill instructions, cleanup:** the clean-worktree check before archiving stays mandatory (Paseo archives dirty worktrees).
- **Common rules template:** the domain doc placeholder points to whatever the target repo's domain docs configuration names, instead of naming a file; the rule "acceptance criteria are the contract; traps and earlier instructions are guidance; on conflict follow the criteria and record why in comments; if the criteria themselves look wrong, stop that part, record evidence, move to ready-for-human" sits next to the traps section; the rule "do not end your turn while work is running in the background" is added for agents; the ready-for-human placeholder follows the triage label file; "Repo and user rules" carries a pointer to the evidence standards file when present.
- **Troubleshooting guide:** add when to cancel a turn, kill, or archive an agent, and update its reference to the agent's stopping-point heading to the new "Done when:" form. It contains no copied Matt method.
- **Evidence standards contract:** optional per target repo, free prose, declared outside the block Matt's setup regenerates, read at preparation, pointed to from the common rules. Absent means skip.
- **Paseo feature choices:** used: agent activity, labels, the three stop controls, the target repo's `paseo.json` (setup and services), heartbeat expiry, review profiles, question-permission answers. Not used: running agents in the default mode with central approval (works, but every write waits on the orchestrator), terminals (no completion signal), plugins (extra dependency, user install), the Paseo browser (evidence tooling is the target repo's choice), per-provider tool limits (user configuration, not a security boundary), the SDK, Hub.
- **Drift check:** a small script that lists every `mattpocock-skills:<name>` reference in the skill's files and compares each with the installed Matt plugin (does the skill exist; if the reference is in an agent's flow, is it model-invocable), printing mismatches and exiting non-zero on any. For the check to see every reference, the skill names Matt skills only in prefixed form. Language and location are left to implementation.
- **README:** describe the two on-ramps and point to `ask-matt` instead of the removed table; tell manual installers to copy the plugin manifest; point to the branch-name rule.
- **Release:** bump the manifest to 0.3.0, tag after merge to main, no changelog. Running 0.2.x waves are not migrated.
- **Paseo bug reports:** three reports are ready (self-started turns send no finish notification; the answer shape for question permissions is undocumented; on Windows setup and scripts use different shells and a fixed service port is shared by all worktrees). Sending them is my decision, outside this spec.

## Testing Decisions

- A good test observes behaviour from outside: what the orchestrator does on a real repo and what the drift check prints, never the wording of the instructions.
- **Seam 1, one real wave on a target repo** (candidate: the test-infrastructure feature of the project that has run seven waves on 0.2.x). The wave passes when: the locating step refuses to start a wave on a wayfinder map and, on real tickets, reaches the right stage; no agent ends a turn with background work pending; a finished report without artifacts leads to a heartbeat that carries an expiry; if the repo declares services, each worktree gets its own port; cleanup leaves no heartbeat and no worktree behind.
- **Seam 2, the drift check:** run against the installed Matt plugin. On a copy of the skill with a planted reference to a Matt skill that does not exist, and one to a human-only skill inside an agent flow, it reports exactly those two and exits non-zero; on the released 0.3.0 skill it reports nothing. (The 0.2.x hand-written list named skills without the plugin prefix, so it is removed rather than tested.)
- No fixture repos for the locating step: the real wave covers it, and a fixture would be an extra seam.
- Prior art: the probe log for this map (notification routing, the silent-finish loop reproduced 10 out of 10, plugin delivery, `paseo.json` setup, scripts and services, mode switching, permission answers) shows the observations each check relies on.

## Out of Scope

- Changing any of Matt's skills.
- Changing Paseo itself; the three bug reports are written, not sent.
- A plugin that forwards finish notifications to the parent agent (proven to work, kept only as a fallback).
- Rewriting the orchestrator on the Paseo SDK.
- A pull-request step, and chaining `retro`, `handoff`, or `claude-handoff`.
- Writing `paseo.json` for any target repo.
- The target project's test infrastructure itself; it waits for 0.3.0 and serves as the test wave.
- `AGENTS.md` coding standards for this repo beyond the Matt skills configuration.
- Multi-user operation of wayfinder maps.

## Further Notes

- Decisions come from a wayfinder map of fifteen resolved decision tickets. Each decision lives in its ticket's answer; the map is the index.
- Matt's v1.3 is an unreleased branch while the installed plugin reads 1.2.3; two caches labelled 1.2.3 already differ. This is why the skill reads Matt's state at run time rather than trusting version labels, and why the "go ahead of upstream or wait" question dissolved.
- If Paseo fixes the silent-finish notification, the rule that turns an artifact-less finished report into a heartbeat can be removed.

> **Đã đăng:** GitHub issue [#1](https://github.com/hanh9898/matt-with-paseo/issues/1), nhãn `ready-for-agent`, 27/09/2026.

> **Sửa đổi sau khi đăng (27/09, bình luận trên #1):** bước 0 giữ stage A (chưa cấu hình → setup) và D (có spec, chưa có ticket → `to-tickets` cùng phiên) cùng hai cảnh báo; chỉ B và C nhường cho `ask-matt`; thêm câu "có ticket rồi thì quay lại `matt-with-paseo`, không dùng `implement-spec`". Lý do: `ask-matt` không đọc trạng thái repo và không biết `matt-with-paseo`.

> **Đã chia ticket (27/09):** #2–#13, sub-issue của #1, cạnh chặn bằng GitHub dependencies. Wave đầu: #2–#8. #13 là `ready-for-human`.

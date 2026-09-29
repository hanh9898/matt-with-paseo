# Troubleshooting a wave

Each entry: the observable symptom, then how to handle it. When an incident exposes a trap the next wave's agents would also hit, carry that trap into the "Traps already hit" section of the next wave's common rules, filtered per step 3 of the skill.

## Agents

**Agent stops midway** (session limit, API error, context exhausted). Check its branch and directory for what is really done. If the remainder is small, do it yourself. If it is large, wait for the limit to reset, then send it back to the same agent with `send_agent_prompt`: state which part is done and who did it, narrow the task to exactly the unfinished part, and restate the common rules. Send it to the same agent so it keeps the context it already read.

Rating: caught — check: `plugins/matt-with-paseo/skills/matt-with-paseo/SKILL.md`, phrase "Agent stopped with the ticket unfinished".

**Report is correct but incomplete.** A claim like "clean" or "passing" only covers what the agent checked. Open the real artifact (screenshot, page, command output) and check the aspects the report does not mention.

Rating: asked.

**Branch name differs from directory name.** A Paseo worktree directory is named by a slug, not by the branch. Get the branch name with `git -C <worktree> branch --show-current`.

Rating: nothing yet.

**A ticket goes wrong while its agent is running** (wrong direction, a loop, work outside its zone). Pick the lightest stop that fixes it:

| Control | What it does | Use it when |
|---|---|---|
| `cancel_agent` | Stops the current turn; the agent and its context stay | The agent can still do the ticket: redirect it with `send_agent_prompt`, narrowing the task as in "Agent stops midway". Never for a hung agent, which step 5's heartbeat contract kills |
| `kill_agent` | Ends the agent's session for good; its workspace and worktree stay | The session itself is broken (errors on every turn, context unusable): handle the remainder as in "Agent stops midway", sent to a new agent spawned in the same workspace per step 4 instead of the same one |
| `archive_agent` | Interrupts the agent if running and removes it from the active list; the worktree stays | Only in step 8 cleanup, after its three checks. Archiving the workspace (`archive_workspace`) is what deletes the worktree |

Rating: nothing yet.

**A tool call hangs and the agent goes quiet** (it stays `running`, its activity count unchanged for three ticks). Judge and act on it exactly as the wave skill's heartbeat contract (step 5) says for a ticket agent, or the stream skill's "Supervise one-for-one" and "Replace a stream agent" say for a stream agent. Either way, never cancel and re-prompt a hung agent: a prompt only queues behind the stuck call, and a cancel gets no acknowledgement. Kill and replace a hung ticket agent within the contract's restart budget; a hung stream agent is not killed while its ticket agents still run, since `kill_agent` may take them along too, and its restart waits until none does. The run that first showed this had a Bash command the CLI auto-moved to the background when the machine was slow, whose result never came back; the common rules' rule to move any command that may take more than two minutes to the background from the start exists so an agent does not land on that same path.

Rating: caught — check: `plugins/matt-with-paseo/skills/matt-with-paseo/SKILL.md`, phrase "whose count has not moved for three ticks".

**`paseo ls` lists an agent carrying a `stream` label this run does not have.** Another run in the same repository uses the same wave number under its own `stream` slug; a run without `stream` does not filter it out. It has no row in this run's `## Wave agents` table and its branch lacks this run's ticket branch shape ("Names this run writes" in the skill): it is not an unlogged agent of this wave. Never add its row, prompt it or archive it.

Rating: caught — check: `plugins/matt-with-paseo/skills/matt-with-paseo/SKILL.md`, phrase "unless it carries a `stream` label this run does not have".

**`create_workspace` fails because git cannot create the ticket branch under the `stream` prefix.** Git refuses a branch whose prefix is itself a branch name, so a branch named exactly the slug blocks every ticket branch of the run. Stop spawning and tell the user: the way out is another slug, or renaming that branch; the naming rule stays as it is.

Rating: nothing yet.

**`create_workspace` times out but still creates the worktree.** The call can succeed on disk before it reports back. Check `git -C <repository> worktree list` against `list_workspaces`: a worktree on the ticket or stream branch with no matching workspace is that timeout. Do not call it again from scratch; read the adopt row of wave `SKILL.md` step 4 item 1's table (a ticket branch) or stream `SKILL.md` step 2's table (a stream branch), and follow it with the repository's `projectId`, found as step 4 item 1 says. Without the project id, Paseo files the adopted directory as a project of its own.

Rating: caught — check: `plugins/matt-with-paseo/skills/matt-with-paseo/SKILL.md`, phrase "may still have made the worktree, so read what git shows before calling again".

**Agent waits on a question-type permission** (it asked the user a question, and `list_pending_permissions` shows the request). Answer with `respond_to_permission`, `behavior: "allow"`, and an `updatedInput` holding the request's `questions` plus an `answers` map from each question's text to the chosen option's label, for example `answers: { "Which database?": "Postgres" }`. Without `answers` (only `selectedActionId`, or only `questions`), the agent receives an ambiguous answer and guesses.

Rating: caught — check: `plugins/matt-with-paseo/skills/matt-with-paseo-streams/SKILL.md`, phrase "has a question-type permission in `list_pending_permissions` not yet shown to the user".

## Merging

**Test count after a merge exceeds what the tracked test files contain.** The worktrees sit inside the integration branch's checkout, and a runner that scans the tree (`node --test`, a `**` glob) also runs the unmerged code of the worktrees still open, so green proves nothing. Restrict the input to files git tracks, for example `git ls-files '*.test.js' | xargs node --test`. Check: the printed count matches the tests in those files. Passing a directory name straight to the runner does not always work (`node --test test/` on Node 24 fails with `Cannot find module`).

Rating: nothing yet.

**The conflict-marker search prints a file** (step 6 of the skill). The merge stays uncommitted. Open each printed file and find where its markers come from:

| The markers come from | Do |
|---|---|
| A conflict git reported in this merge, left unresolved | Resolve it (a registration file as in the next entry), `git add` the file, run the search again, then commit |
| The ticket branch, which committed them itself | `git merge --abort`; send the ticket back to its agent with `send_agent_prompt` to remove them on its branch, and merge again once its report passes step 5 |
| Content that only looks like a marker (a document quoting one) | Tell the user with the file and line; the merge waits for their answer |

Rating: caught — check: `plugins/matt-with-paseo/skills/matt-with-paseo/SKILL.md`, phrase "git diff --cached -G'^(<<<<<<<|>>>>>>>)( |$)' --name-only HEAD".

**Conflict in a registration file**, caused by two tickets both adding lines to a manifest, package index, route table, or permission file. Keep both sides' lines, in ticket-number order.

Rating: caught — check: `plugins/matt-with-paseo/skills/matt-with-paseo/SKILL.md`, phrase "resolving any conflict git reports".

**Install is green but the real run fails.** For example, two modules register a helper under the same name and one silently shadows the other: installing reports nothing, only a real call fails. Fix it, then add the real-call check to the "Done when:" section of the next wave's common rules; its traps section gets only a one-line pointer to that check (step 3 of the skill).

Rating: nothing yet.

**Moving the result onto another branch** (for example a test branch that has drifted far from the main one). Create a new branch from the target, cherry-pick exactly the reviewed commits, then compare trees: `git diff <reviewed commit> <replayed commit> -- <feature paths>` must be empty. An automatic replay can duplicate lines in registration files; the tree comparison catches this.

Rating: nothing yet.

## Cleaning up

**Worktree has uncommitted changes.** Do not archive: `archive_workspace` would delete the directory along with those changes. Look at `git -C <worktree> diff`; changes that belong to the ticket go back to the same agent to commit via `send_agent_prompt`; temporary junk is reported to the user before being discarded.

Rating: caught — check: `plugins/matt-with-paseo/skills/matt-with-paseo/SKILL.md`, phrase "`git -C <worktree> status --porcelain` is empty;".

**Ticket branch not merged.** Go back to steps 5 and 6 for that ticket; clean up only after the merge.

Rating: caught — check: `plugins/matt-with-paseo/skills/matt-with-paseo/SKILL.md`, phrase "the ticket's branch appears in `git branch --merged <integration branch>`".

**Agent has not stopped.** `archive_agent` would interrupt it midway. Wait for it to stop, or ask the user before interrupting.

Rating: caught — check: `plugins/matt-with-paseo/skills/matt-with-paseo/SKILL.md`, phrase "`get_agent_status` shows the agent has stopped".

## Environment

**Remote unreachable** (SSH timeout, HTTPS blocked). Keep the commits local, tell the user, and check again when they report the network is back. Push and open a merge request only after `git ls-remote` succeeds.

Rating: caught — check: `plugins/matt-with-paseo/skills/matt-with-paseo-streams/SKILL.md`, phrase "The fetch fails (unknown host, refused connection, authentication failed)".

**A global Claude Code hook slows every tool call, for every agent, not just one.** A hook set in the user's own `~/.claude/settings.json` (its `hooks` key; read only that key, never the rest of the file) fires on every Pre/PostToolUse, `UserPromptSubmit` or Stop event of every agent Paseo runs, including ones this run did not start. Even one that does negligible work still starts a process each time, and once the machine is busy it can itself blow past its own timeout and add to what looks like a hung agent. Check that key before treating a slowdown as a hung agent or a choking machine. Report what you find to the user; removing or narrowing a machine-wide hook is a machine-changing action, not yours to take alone.

Rating: nothing yet.

**Heavy daemon background load makes the machine feel slow across every agent, not tied to one worktree.** `~/.paseo/daemon.log`'s `ws_runtime_metrics` shows the daemon's own event loop delay (`eventLoopDelay.maxMs`) climbing past several seconds; the trigger seen in the run was the machine running low on free resources (too many agent processes at once, too little free RAM). Once that delay climbs, git commands that normally return in seconds can take over a minute, and hooks and tool calls time out machine-wide. Treat `eventLoopDelay.maxMs` past a few seconds, or a plain command like `git status` past about a minute, as the canary: report what you observed to the user, and propose a hold or a lower cap for them to decide; do not act on it alone.

Rating: nothing yet.

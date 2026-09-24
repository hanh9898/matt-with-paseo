# Troubleshooting a wave

Each entry: the observable symptom, then how to handle it. When an incident exposes a trap the next wave's agents would also hit, copy that trap into the "Traps already hit" section of the next wave's common rules.

## Agents

**Agent stops midway** (session limit, API error, context exhausted). Check its branch and directory for what is really done. If the remainder is small, do it yourself. If it is large, wait for the limit to reset, then send it back to the same agent with `send_agent_prompt`: state which part is done and who did it, narrow the task to exactly the unfinished part, and restate the common rules. Send it to the same agent so it keeps the context it already read.

**Report is correct but incomplete.** A claim like "clean" or "passing" only covers what the agent checked. Open the real artifact (screenshot, page, command output) and check the aspects the report does not mention.

**Branch name differs from directory name.** A Paseo worktree directory is named by a slug, not by the branch. Get the branch name with `git -C <worktree> branch --show-current`.

## Merging

**Conflict in a registration file**, caused by two tickets both adding lines to a manifest, package index, route table, or permission file. Keep both sides' lines, in ticket-number order.

**Install is green but the real run fails.** For example, two modules register a helper under the same name and one silently shadows the other: installing reports nothing, only a real call fails. Fix it, then add the real-call check to the "Done means" section and to the traps section of the next wave's common rules.

**Moving the result onto another branch** (for example a test branch that has drifted far from the main one). Create a new branch from the target, cherry-pick exactly the reviewed commits, then compare trees: `git diff <reviewed commit> <replayed commit> -- <feature paths>` must be empty. An automatic replay can duplicate lines in registration files; the tree comparison catches this.

## Cleaning up

**Worktree has uncommitted changes.** Do not archive: `archive_workspace` would delete the directory along with those changes. Look at `git -C <worktree> diff`; changes that belong to the ticket go back to the same agent to commit via `send_agent_prompt`; temporary junk is reported to the user before being discarded.

**Ticket branch not merged.** Go back to steps 5 and 6 for that ticket; clean up only after the merge.

**Agent has not stopped.** `archive_agent` would interrupt it midway. Wait for it to stop, or ask the user before interrupting.

## Environment

**Remote unreachable** (SSH timeout, HTTPS blocked). Keep the commits local, tell the user, and check again when they report the network is back. Push and open a merge request only after `git ls-remote` succeeds.

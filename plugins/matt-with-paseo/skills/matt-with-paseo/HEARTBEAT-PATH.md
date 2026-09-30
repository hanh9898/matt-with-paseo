# The heartbeat path of step 5

Read this file only when the run takes the heartbeat path (the wave skill's words block; step 1 records which path the run takes), or when step 5 sends you here for one agent: an agent an earlier session spawned, one whose finished report has no artifacts yet, or one a `Stall suspected` message names (read the hung-agent table of section 1 at once, not after three ticks). On the message path a ticket agent this session spawned needs no heartbeat.

## 1. Create the heartbeat

**Heartbeat contract**: `create_heartbeat` always with `expiresIn` set; the cadence is yours (for example every 15 minutes), always capped by an expiry, so no heartbeat outlives its wave. Each tick checks, for every agent it watches, `get_agent_status`, the commits on the ticket's branch (`git log <branch>`), uncommitted files in its worktree (`git -C <worktree> status --porcelain`), the ticket's comments, its pending permissions (`list_pending_permissions`: a question-type one goes to the user at a Checkpoint and is answered as [`TROUBLESHOOTING.md`](TROUBLESHOOTING.md)'s "Agent waits on a question-type permission" says), and its activity count (`updateCount` in `get_agent_activity`), kept from tick to tick in this session. A ticket agent still `running` whose count has not moved for three ticks is judged by its last activity entry:

| Last activity entry | Do |
|---|---|
| A shell command (`[Shell]`, `[Powershell]`) or no tool call (text, a `[Task notification]`) | Hung: a foreground shell command cannot legitimately run that long. `kill_agent` it, never cancel and prompt it (a prompt only queues behind the stuck call), and hand its remainder to a new agent in the same workspace, as [`TROUBLESHOOTING.md`](TROUBLESHOOTING.md) "A ticket goes wrong while its agent is running" gives for `kill_agent`. Each bundle gets 2 such restarts per wave (ADR 0004's budget, counted per bundle); a hang past them records the bundle's unfinished tickets as failed, hung past its budget: leave its agent as it is, restart nothing, name the tickets in your end-of-turn message, and run them as single tickets in the next wave |
| A subagent (`[Agent]`, such as the `mattpocock-skills:code-review` reviewers) or another tool that can run long | Not hung: tell the user once, with the ticket and that entry, and let it run |

**Done when**: every heartbeat this run created carries an `expiresIn`, and each tick checked every agent it watches.

## 2. Delete the heartbeat

`delete_heartbeat` once the agent has really stopped and its artifacts pass step 5's checks, and at the latest in step 8.

Read [`PASEO-FACTS.md`](PASEO-FACTS.md) (verified Paseo behaviour, each row with its version): its status calls and heartbeats table when a heartbeat stops ticking.

**Done when**: no heartbeat of the wave outlives step 8.

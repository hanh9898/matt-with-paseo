# Acceptance run: measurements

For the human running an acceptance run (#13, #23). Copy these lines into the run's evidence comment and fill them in. They put a number on the orchestrator's own overhead, so a later addition to the skills is argued with numbers (lesson 31 in [the seatworks lessons](lessons/sting9k-seatworks.md)). Write `not reported` where a number is not available; leave no line out.

- **Orchestrator tokens:** the tokens the orchestrator's own session used for the run. Read from the `lastUsage` block that `get_agent_status` returns for the orchestrator agent, where Paseo reports it.
- **Orchestrator cost:** the orchestrator's cost in USD for the run. Read from `lastUsage.totalCostUsd`, where Paseo reports it.
- **Agents idle before the first commit:** how many agents sat idle before the first commit landed, and for how long each. Read from `paseo ls -g --json` (status `idle`) and the agents' last activity in `get_agent_activity`.
- **Minutes to the first commit:** minutes from the start of the run to the first commit on any ticket branch. Read from the start time of the orchestrator agent and `git log --format=%cI` on the ticket branches.

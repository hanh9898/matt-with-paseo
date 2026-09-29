#!/usr/bin/env python3
"""Ask a model, on demand, which skill each trigger case should open, and pass a case when more than
half of its runs are right. It costs model runs, so no test and no gate calls it; the free check is
check-triggers.py. The agent is the command after `--` (default `claude -p`): it gets the prompt on
stdin and prints its answer on stdout."""

import argparse
import shutil
import subprocess
import sys
import tempfile
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

import trigger_cases

REPO = Path(__file__).resolve().parent.parent
PLUGIN = REPO / "plugins" / "matt-with-paseo"
DEFAULT_AGENT = ["claude", "-p"]


def ask(agent, prompt, timeout, workdir):
    """The skills one run opened, or None when the agent failed, timed out or answered no JSON."""
    try:
        done = subprocess.run(agent, input=prompt, capture_output=True, text=True, encoding="utf-8",
                              timeout=timeout, cwd=workdir)
    except subprocess.TimeoutExpired:
        return None
    return trigger_cases.opened_skills(done.stdout) if done.returncode == 0 else None


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("agent", nargs="*", help="the agent command, after `--` (default: claude -p)")
    parser.add_argument("--runs", type=int, default=3, help="runs per case (default 3)")
    parser.add_argument("--jobs", type=int, default=4, help="runs in parallel (default 4)")
    parser.add_argument("--timeout", type=int, default=180, help="seconds per run (default 180)")
    parser.add_argument("--cases", type=Path, default=PLUGIN / "triggers" / "cases.json")
    parser.add_argument("--plugin-root", type=Path, default=PLUGIN)
    args = parser.parse_args()

    for option in ("runs", "jobs", "timeout"):
        if getattr(args, option) < 1:
            print(f"--{option} must be a whole number of at least 1.", file=sys.stderr)
            return 2
    agent = args.agent or DEFAULT_AGENT
    program = shutil.which(agent[0])
    if program is None:
        print(f"{agent[0]}: not found on the PATH, so no model can be asked.", file=sys.stderr)
        return 2
    agent = [program, *agent[1:]]
    try:
        cases = trigger_cases.load_cases(args.cases)
        cards = trigger_cases.skill_cards(args.plugin_root)
    except trigger_cases.TriggerError as error:
        print(error, file=sys.stderr)
        return 2

    with tempfile.TemporaryDirectory() as workdir, ThreadPoolExecutor(max_workers=args.jobs) as pool:
        jobs = [[pool.submit(ask, agent, trigger_cases.trigger_prompt(cards, one["request"]), args.timeout, workdir)
                 for _ in range(args.runs)] for one in cases]
        answers = [[job.result() for job in case_jobs] for case_jobs in jobs]

    passed = 0
    for one, opened in zip(cases, answers):
        right = sum(1 for run in opened if trigger_cases.right_run(one, run))
        ok = trigger_cases.majority(right, args.runs)
        passed += ok
        print(f"{'PASS' if ok else 'FAIL'} {right}/{args.runs} expected {one['expect']} "
              f"opened {', '.join(str(run) for run in opened)} :: {one['request'][:70]}")
    print(f"{passed} of {len(cases)} cases passed")
    return 0 if passed == len(cases) else 1


if __name__ == "__main__":
    sys.exit(main())

"""Wait until a delegated child has finished, judged by its result artifact rather than its transcript.

Done means: the artifact records a terminal `completion_state`, the Conductor session is no longer
working, the worktree HEAD matches the artifact's `revision`, and no file in the worktree changed
during the quiet window (a child can sit idle while its own subagents still write).
"""

import argparse
import json
import re
import subprocess
import sys
import time
from dataclasses import dataclass, field
from pathlib import Path

TERMINAL_STATES = {"phase-complete", "task-complete", "blocked"}
EXIT_DONE, EXIT_USAGE, EXIT_BLOCKED, EXIT_TIMEOUT = 0, 2, 3, 4


@dataclass
class Observation:
    artifact: str | None
    session_status: str | None = None
    head: str | None = None
    newest_change_age: float | None = None


@dataclass
class Verdict:
    done: bool
    state: str | None
    waiting_on: list[str] = field(default_factory=list)


def artifact_field(text: str, name: str) -> str | None:
    match = re.search(rf"^{name}:\s*([^\s#]+)", text, re.MULTILINE)
    return match.group(1) if match else None


def judge(observation: Observation, quiet_seconds: float) -> Verdict:
    if observation.artifact is None:
        return Verdict(False, None, ["artifact missing"])
    state = artifact_field(observation.artifact, "completion_state")
    revision = artifact_field(observation.artifact, "revision")
    waiting = []
    if state not in TERMINAL_STATES:
        waiting.append(f"completion_state is {state or 'unset'}")
    if observation.session_status not in (None, "idle"):
        waiting.append(f"session is {observation.session_status}")
    if observation.head is not None and revision and not (
        observation.head.startswith(revision) or revision.startswith(observation.head)
    ):
        waiting.append(f"worktree HEAD {observation.head[:10]} differs from revision {revision[:10]}")
    if observation.newest_change_age is not None and observation.newest_change_age < quiet_seconds:
        waiting.append(f"worktree changed {int(observation.newest_change_age)}s ago")
    return Verdict(not waiting, state, waiting)


def session_status(session_id: str) -> str | None:
    result = subprocess.run(
        ["conductor", "--json", "session", "status", session_id], capture_output=True, text=True
    )
    if result.returncode != 0:
        return "unknown"
    return json.loads(result.stdout).get("status")


def worktree_state(worktree: Path) -> tuple[str | None, float | None]:
    head = subprocess.run(
        ["git", "-C", str(worktree), "rev-parse", "HEAD"], capture_output=True, text=True
    ).stdout.strip() or None
    changed = subprocess.run(
        ["git", "-C", str(worktree), "status", "--porcelain", "--untracked-files=all"],
        capture_output=True,
        text=True,
    ).stdout.splitlines()
    mtimes = [
        (worktree / line[3:].split(" -> ")[-1]).stat().st_mtime
        for line in changed
        if (worktree / line[3:].split(" -> ")[-1]).exists()
    ]
    return head, (time.time() - max(mtimes)) if mtimes else None


def observe(args: argparse.Namespace) -> Observation:
    artifact = Path(args.artifact)
    observation = Observation(artifact.read_text() if artifact.exists() else None)
    if args.session:
        observation.session_status = session_status(args.session)
    if args.worktree:
        observation.head, observation.newest_change_age = worktree_state(Path(args.worktree))
    return observation


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--artifact", required=True, help="result artifact the child writes")
    parser.add_argument("--session", help="Conductor session id of the child")
    parser.add_argument("--worktree", help="worktree the child writes in")
    parser.add_argument("--quiet-seconds", type=float, default=180)
    parser.add_argument("--interval", type=float, default=30)
    parser.add_argument("--timeout", type=float, default=7000)
    parser.add_argument("--once", action="store_true", help="check once and exit")
    args = parser.parse_args()

    deadline = time.monotonic() + args.timeout
    while True:
        verdict = judge(observe(args), args.quiet_seconds)
        if verdict.done or args.once or time.monotonic() >= deadline:
            print(json.dumps({"done": verdict.done, "state": verdict.state, "waiting_on": verdict.waiting_on}))
            if verdict.done:
                return EXIT_BLOCKED if verdict.state == "blocked" else EXIT_DONE
            return EXIT_TIMEOUT
        time.sleep(args.interval)


if __name__ == "__main__":
    sys.exit(main())

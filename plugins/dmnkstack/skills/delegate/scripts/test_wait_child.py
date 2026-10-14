import os
import subprocess
import sys
import tempfile
import time
from pathlib import Path

from wait_child import Observation, judge, worktree_state

DONE = "completion_state: phase-complete\nrevision: 0a1b2c3d4e\n\nRESULT\nok\n"


def main() -> None:
    assert judge(Observation(DONE, "idle", "0a1b2c3d4e5f", 600), 180).done
    assert judge(Observation(DONE), 180).done, "session and worktree checks are optional"
    blocked = judge(Observation(DONE.replace("phase-complete", "blocked"), "idle"), 180)
    assert blocked.done and blocked.state == "blocked"

    assert judge(Observation(None), 180).waiting_on == ["artifact missing"]
    assert not judge(Observation(DONE.replace("phase-complete", "running"), "idle"), 180).done
    assert not judge(Observation("RESULT\ndone\n", "idle"), 180).done, "a transcript-style RESULT is not completion"
    assert judge(Observation(DONE, "working"), 180).waiting_on == ["session is working"]
    stale = judge(Observation(DONE, "idle", "ffffffffff"), 180)
    assert stale.waiting_on and "differs from revision" in stale.waiting_on[0]
    busy = judge(Observation(DONE, "idle", "0a1b2c3d4e", 20), 180)
    assert busy.waiting_on == ["worktree changed 20s ago"], "an idle child whose helpers still write is not done"

    with tempfile.TemporaryDirectory() as directory:
        worktree = Path(directory)
        subprocess.run(["git", "init", "-q", str(worktree)], check=True)
        subprocess.run(
            ["git", "-C", str(worktree), "-c", "user.name=t", "-c", "user.email=t@example.com",
             "commit", "-q", "--allow-empty", "-m", "base"],
            check=True,
        )
        head, age = worktree_state(worktree)
        assert head and age is None, "a clean worktree has no recent change"
        edited = worktree / "edited.txt"
        edited.write_text("x")
        os.utime(edited, (time.time() - 30, time.time() - 30))
        _, age = worktree_state(worktree)
        assert age is not None and 25 < age < 120

    print("wait_child checks passed")


if __name__ == "__main__":
    sys.path.insert(0, str(Path(__file__).parent))
    main()

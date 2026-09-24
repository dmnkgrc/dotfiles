import io
import json
import subprocess
import tempfile
from contextlib import redirect_stdout
from pathlib import Path
from unittest.mock import patch

import route


def check_typesafe_key() -> None:
    def no_subprocess(*args, **kwargs):
        raise AssertionError("typesafe_key must not spawn a shell when the env var is set")

    with patch.dict("os.environ", {"TYPESAFE_API_KEY": "env-value"}), patch("route.subprocess.run", no_subprocess):
        assert route.typesafe_key() == "env-value"

    with tempfile.TemporaryDirectory() as raw:
        home = Path(raw)
        (home / "dmnkstack").mkdir()
        (home / "dmnkstack" / "typesafe.env").write_text('TYPESAFE_API_KEY="file-value"\n')
        env = {"XDG_CONFIG_HOME": str(home)}
        with patch.dict("os.environ", env, clear=True):
            assert route.typesafe_key() == "file-value"

        # no posix file: fish missing, bash answers
        shells = {"bash": "/bin/bash"}
        calls: list[str] = []

        def run(command, **kwargs):
            calls.append(command[0])
            return subprocess.CompletedProcess(command, 0, "Using Node v24.0.0\n\0shell-value\0", "")

        with patch.dict("os.environ", {"XDG_CONFIG_HOME": str(home / "empty")}, clear=True):
            with patch("route.shutil.which", side_effect=shells.get), patch("route.subprocess.run", run):
                assert route.typesafe_key() == "shell-value"
        assert calls == ["/bin/bash"]

        # total miss
        with patch.dict("os.environ", {"XDG_CONFIG_HOME": str(home / "empty")}, clear=True):
            with patch("route.shutil.which", return_value=None):
                assert route.typesafe_key() is None


def check_credential_safety() -> None:
    command = ["/bin/sh", "-c", r'printf "Using Node v24.0.0\n\0%s\0Shell goodbye\n" "synthetic-key"']
    assert route.read_key(command) == "synthetic-key"
    assert route.read_key(["/bin/sh", "-c", 'printf "startup banner only"']) is None
    assert route.read_key(["/bin/sh", "-c", r'printf "\0\0"']) is None
    assert route.read_key(["/bin/sh", "-c", r'printf "\0synthetic-key\0"; exit 1']) is None

    for key in ("synthetic-key\nextra", "synthetic-key\rextra", "synthetic key", "synthetic-\u00e9"):
        with patch.dict("os.environ", {"TYPESAFE_API_KEY": key}), patch("route.urllib.request.urlopen") as request:
            try:
                route.typesafe_call(route.typesafe_key(), {}, {})
            except RuntimeError as error:
                assert "synthetic" not in str(error)
            else:
                raise AssertionError("Malformed credentials must fail before HTTP")
            request.assert_not_called()

    with patch("route.urllib.request.urlopen", side_effect=ValueError("synthetic-secret")):
        try:
            route.typesafe_call("synthetic-key", {}, {})
        except RuntimeError as error:
            assert str(error) == "TypeSafe API request failed: ValueError"
        else:
            raise AssertionError("HTTP failures must be sanitized")

    for error in (ValueError("synthetic-secret"), RuntimeError("synthetic-secret")):
        output = io.StringIO()
        with patch("route.run", side_effect=error), patch("sys.argv", ["route.py", "private task"]):
            with redirect_stdout(output):
                assert route.main() == 2
        assert json.loads(output.getvalue())["status"] == "error"
        assert "synthetic-secret" not in output.getvalue()
        assert "private task" not in output.getvalue()


def check_optional_typesafe() -> None:
    output = io.StringIO()
    with patch("route.typesafe_key", return_value=None), patch("route.installed_skills") as skills:
        with patch("route.typesafe_call") as api, patch("route.ThreadPoolExecutor") as executor:
            with patch("sys.argv", ["route.py", "private task"]), redirect_stdout(output):
                assert route.main() == 0
            result = json.loads(output.getvalue())
            assert result["status"] == "local"
            assert result["typesafe"]["calls"] == 0
            assert result["reason"] == "TYPESAFE_API_KEY is not configured"
            assert "private task" not in output.getvalue()
            skills.assert_not_called()
            api.assert_not_called()
            executor.assert_not_called()

    output = io.StringIO()
    with patch("route.typesafe_key", return_value="configured-key"):
        with patch("route.installed_skills", return_value={"verify": {"description": "Verify work"}}):
            with patch("route.ThreadPoolExecutor"), patch("route.typesafe_call", side_effect=route.RoutingError("TypeSafe API returned HTTP 401")) as api:
                with patch("sys.argv", ["route.py", "Verify work"]), redirect_stdout(output):
                    assert route.main() == 2
                assert api.call_args.args[0] == "configured-key"
                result = json.loads(output.getvalue())
                assert result["status"] == "error"
                assert result["error"] == "TypeSafe API returned HTTP 401"
                assert "configured-key" not in output.getvalue()


def main() -> None:
    check_credential_safety()
    check_typesafe_key()
    check_optional_typesafe()
    codex = route.parse_codex_usage(
        {
            "ordinaryUsageAllowed": True,
            "rateLimits": {
                "primary": {
                    "usedPercent": 69,
                    "windowDurationMins": 10080,
                    "resetsAt": 123,
                },
                "secondary": None,
                "rateLimitReachedType": None,
            },
        }
    )
    assert codex["known"] and codex["available"]
    assert codex["remaining_percent"] == 31
    assert len(codex["windows"]) == 1
    assert codex["windows"][0]["window_minutes"] == 10080
    exhausted_codex = route.parse_codex_usage(
        {
            "ordinaryUsageAllowed": True,
            "rateLimits": {
                "primary": {"usedPercent": 100},
                "secondary": None,
                "rateLimitReachedType": None,
            },
        }
    )
    assert exhausted_codex["known"] and not exhausted_codex["available"]

    claude = route.parse_claude_usage(
        {
            "local_command": "usage",
            "result": "Current session: 2% used\nCurrent week (all models): 95% used\nCurrent week (Fable): 100% used",
        }
    )
    assert claude["known"]
    assert [window["remaining_percent"] for window in claude["windows"]] == [98, 5, 0]

    cursor = route.parse_cursor_usage(
        {"planUsage": {"apiPercentUsed": 100, "autoPercentUsed": 49.5}}
    )
    assert cursor["remaining_percent"] == 50.5 and cursor["available"]
    assert route.select_usage_window(cursor, "auto")["remaining_percent"] == 50.5
    assert route.select_usage_window(cursor, "api")["available"] is False

    states = {
        "healthy": {"available": True, "usage_known": True, "remaining_percent": 11},
        "threshold": {"available": True, "usage_known": True, "remaining_percent": 10},
        "unknown": {"available": True, "usage_known": False, "remaining_percent": None},
        "exhausted": {"available": False, "usage_known": True, "remaining_percent": 0},
    }
    pools = {
        "primary": [
            {"model": "threshold", "effort": "high"},
            {"model": "exhausted", "effort": "high"},
        ],
        "fallback": [
            {"model": "healthy", "effort": "medium"},
            {"model": "unknown", "effort": "high"},
        ],
    }
    eligible, reason = route.eligible_pool(pools, states)
    assert [target["model"] for target in eligible] == ["healthy", "unknown"]
    assert "using healthy fallback candidates" in reason
    primary, reason = route.eligible_pool(
        {
            "primary": [{"model": "healthy", "effort": "high"}],
            "fallback": [{"model": "unknown", "effort": "high"}],
        },
        states,
    )
    assert [target["model"] for target in primary] == ["healthy"] and reason is None
    scarce, reason = route.eligible_pool(
        {
            "primary": [{"model": "threshold", "effort": "high"}],
            "fallback": [],
        },
        states,
    )
    assert [target["model"] for target in scarce] == ["threshold"]
    assert "scarce primary candidates retained" in reason

    with tempfile.TemporaryDirectory() as directory:
        root = Path(directory)
        skill = root / "live-skill"
        skill.mkdir()
        (skill / "SKILL.md").write_text(
            "---\nname: live-skill\ndescription: >\n  Selected from current\n  frontmatter.\n---\n# Live\nDetailed instructions.\n"
        )
        skills = route.installed_skills([root])
        assert skills["live-skill"]["description"] == "Selected from current frontmatter."
        assert "Detailed instructions" in skills["live-skill"]["body"]

    assert route.model_role("refactoring", "mechanical") == "fast mechanical work"
    assert route.model_role("design", "uncertain") == "architect runners"
    assert route.model_role("review", "bounded") == "interrogate reviewers"
    assert route.difficulty("Verify a migration with old and new writers", "verification") == "consequential"
    assert route.effort_for("high", "uncertain") == "high"
    assert route.effort_for("high", "consequential") == "max"
    with patch.dict(route.os.environ, {"XDG_CONFIG_HOME": ""}):
        assert route.default_models_path() == Path.home() / ".config/dmnkstack/models.md"
    try:
        route.choice(
            {
                "answers": {
                    "route": {
                        "choice": "feature",
                        "confidence": "high",
                        "probabilities": {"feature": 1},
                    }
                }
            },
            "route",
            {"feature"},
        )
    except RuntimeError:
        pass
    else:
        raise AssertionError("malformed TypeSafe answers must fail explicitly")
    config = Path(__file__).resolve().parents[5] / ".config/dmnkstack/models.md"
    general = route.configured_pools(config, "general implementation")
    assert general["primary"] == [{"model": "opus-5.5", "effort": "medium"}]
    assert general["fallback"] == [
        {"model": "grok-4.7", "effort": "high"},
        {"model": "gpt-6-sol", "effort": "high"},
        {"model": "fable-5.1", "effort": "high"},
        {"model": "gpt-6-luna", "effort": "max"},
    ]
    prose = route.configured_pools(config, "prose")
    assert prose["primary"] == [
        {"model": "gpt-6-luna", "effort": "low"},
        {"model": "fable-5.1", "effort": "high"},
    ]
    mechanical = route.configured_pools(config, "fast mechanical work")
    assert mechanical["primary"] == [{"model": "gpt-6-luna", "effort": "low"}]
    assert mechanical["fallback"] == [
        {"model": "grok-4.7", "effort": "low"},
        {"model": "opus-5.5", "effort": "high"},
        {"model": "gpt-6-sol", "effort": "high"},
        {"model": "fable-5.1", "effort": "high"},
    ]

    sources = {
        "codex": codex,
        "claude": claude,
        "cursor": cursor,
    }
    with patch("route.shutil.which", side_effect=lambda name: f"/{name}"):
        models = route.normalize_models(
            sources,
            {"fable-5-1@300k", "opus-5.5@300k", "grok-4.7@256k", "gpt-6-sol", "gpt-6-luna"},
            conductor=set(),
        )
    assert models["gpt-6-sol"]["executors"] == ["pi"]
    assert models["gpt-6-luna"]["executors"] == ["pi"]
    assert models["grok-4.7"]["executors"] == ["pi"]
    assert models["gpt-6-sol"]["available"]

    # Inside Conductor an executor is launchable from its agent catalog even without a local binary.
    with patch("route.shutil.which", return_value=None):
        catalog_only = route.normalize_models(sources, set(), conductor={"claude"})
        no_catalog = route.normalize_models(sources, set(), conductor=set())
    assert catalog_only["opus-5.5"]["available"] and catalog_only["opus-5.5"]["executors"] == ["claude"]
    assert catalog_only["fable-5.1"]["executors"] == ["claude"]
    assert not no_catalog["opus-5.5"]["available"] and no_catalog["opus-5.5"]["executors"] == []
    assert models["grok-4.7"]["available"]
    assert models["grok-4.7"]["usage_known"] is True
    assert models["grok-4.7"]["remaining_percent"] == 50.5
    cursor_sources = models["opus-5.5"]["sources"]
    assert any(source.get("window") == "api" and not source["available"] for source in cursor_sources)

    with tempfile.TemporaryDirectory() as raw:
        home = Path(raw)
        agent = home / ".pi/agent"
        agent.mkdir(parents=True)
        (agent / "settings.json").write_text(
            json.dumps(
                {
                    "defaultProvider": "cursor",
                    "defaultModel": "grok-4.7@256k",
                    "enabledModels": ["openai-codex/gpt-6-sol", "cursor/opus-5.5@300k"],
                }
            )
        )

        def refuse_pi(*args, **kwargs):
            raise AssertionError("exe VM must not run pi --list-models")

        with (
            patch("route.exe_vm", return_value=True),
            patch("route.Path.home", return_value=home),
            patch("route.subprocess.run", refuse_pi),
        ):
            assert route.pi_models() == {"grok-4.7@256k", "gpt-6-sol", "opus-5.5@300k"}
    print("TypeSafe routing parser and policy checks passed")


if __name__ == "__main__":
    main()

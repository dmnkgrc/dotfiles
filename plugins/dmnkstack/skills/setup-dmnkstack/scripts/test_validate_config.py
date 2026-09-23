import json
import subprocess
import sys
import tempfile
from pathlib import Path
import tomllib
from unittest.mock import patch

from discover import discover_agents, summarize_cursor_usage
from validate_config import EFFORTS, ROLES, catalog_from_discovery, parse_routes, validate


ROOT = Path(__file__).resolve().parents[5]
CONFIG = ROOT / ".config/dmnkstack"


def main() -> None:
    targets, errors = parse_routes(CONFIG / "models.md")
    assert not errors, errors
    assert {target["role"] for target in targets} == ROLES
    launchers = tomllib.loads((CONFIG / "launchers.toml").read_text())
    catalog = [
        {
            "agent": "pi",
            "provider": "test",
            "models": [target["model"]],
            "efforts": [target["effort"]],
        }
        for target in targets
    ]
    catalog.append(
        {
            "agent": "claude",
            "models": sorted({target["model"] for target in targets}),
            "efforts": sorted(EFFORTS),
        }
    )
    exhausted = {"available": True, "api_remaining": False}
    remaining = {"available": True, "api_remaining": True}
    resolved, unresolved = validate(targets, catalog, launchers, exhausted)
    assert len(resolved) == len(targets) and not unresolved
    general = next(
        target
        for target in resolved
        if target["role"] == "general implementation" and target["kind"] == "primary"
    )
    assert {entry["agent"] for entry in general["executors"]} == {"claude"}
    for role in ("bug-fix", "feature", "fast mechanical work"):
        routed = next(
            target
            for target in resolved
            if target["role"] == role and target["kind"] == "primary"
        )
        assert {entry["agent"] for entry in routed["executors"]} == {"pi"}
    critics_opus = next(
        target
        for target in resolved
        if target["role"] == "how critics"
        and target["kind"] == "primary"
        and target["model"] == "opus-5.5"
    )
    assert "pi" not in {entry["agent"] for entry in critics_opus["executors"]}
    with_usage, _ = validate(targets, catalog, launchers, remaining)
    critics_with_usage = next(
        target
        for target in with_usage
        if target["role"] == "how critics"
        and target["kind"] == "primary"
        and target["model"] == "opus-5.5"
    )
    assert "pi" in {entry["agent"] for entry in critics_with_usage["executors"]}
    target = [
        {"role": "bug-fix", "model": "gpt-5.6-sol", "effort": "high", "kind": "primary"}
    ]
    split_capabilities = [
        {"agent": "codex", "models": ["gpt-5.6-sol"], "efforts": ["low"]},
        {"agent": "cursor", "models": ["gpt-5.6-sol"], "efforts": ["high"]},
    ]
    assert validate(target, split_capabilities, launchers)[1]
    assert validate(
        target,
        [{"agent": "pi", "models": ["gpt-5.6-sol"], "efforts": ["high"]}],
        launchers,
    )[1]
    assert validate(target, [], launchers)[1]
    assert validate(target, catalog, {"agents": {"pi": {}}})[1]
    pi_catalog = catalog_from_discovery(
        {
            "agents": {
                "pi": {
                    "models": [
                        {"provider": "anthropic", "model": "fable-5"},
                        {"provider": "openai-codex", "model": "gpt-5.6-sol"},
                    ]
                }
            }
        }
    )
    assert {entry["provider"] for entry in pi_catalog} == {"anthropic", "openai-codex"}
    assert not validate(target, pi_catalog, launchers)[1]
    fable = [
        {
            "role": "judgment",
            "model": "fable-5.1",
            "effort": "high",
            "kind": "primary",
        }
    ]
    pi_fable = [
        {
            "agent": "pi",
            "provider": "cursor",
            "models": ["fable-5-1@300k"],
            "efforts": ["high"],
        }
    ]
    assert not validate(fable, pi_fable, launchers)[1]
    assert validate(fable, pi_fable, launchers, exhausted)[1]
    claude_only, claude_missing = validate(
        fable,
        [{"agent": "claude", "models": ["fable"], "efforts": ["high"]}],
        launchers,
        exhausted,
    )
    assert claude_only and not claude_missing
    mixed_catalog = [
        {
            "agent": "pi",
            "provider": "cursor",
            "models": ["opus-5@300k"],
            "efforts": ["high"],
        },
        {
            "agent": "pi",
            "provider": "cursor",
            "models": ["grok-4.7"],
            "efforts": ["high"],
        },
    ]
    mixed_targets = [
        {
            "role": "how critics",
            "model": "opus-5",
            "effort": "high",
            "kind": "primary",
        },
        {
            "role": "how critics",
            "model": "grok-4.7",
            "effort": "high",
            "kind": "primary",
        },
    ]
    mixed, mixed_missing = validate(mixed_targets, mixed_catalog, launchers, remaining)
    assert len(mixed) == 2 and not mixed_missing
    blocked, leftover = validate(mixed_targets, mixed_catalog, launchers, exhausted)
    assert [target["model"] for target in blocked] == ["grok-4.7"]
    assert leftover and leftover[0]["model"] == "opus-5"
    summary = summarize_cursor_usage(
        {"planUsage": {"apiPercentUsed": 100, "autoPercentUsed": 43}}
    )
    assert summary["available"] and summary["api_remaining"] is False
    assert summary["auto_remaining"] is True
    source = (CONFIG / "models.md").read_text()
    with tempfile.TemporaryDirectory() as directory:
        path = Path(directory) / "models.md"
        defaults = (
            CONFIG.parents[1]
            / "plugins/dmnkstack/skills/setup-dmnkstack/references/default-models.md"
        ).read_text()
        path.write_text(defaults.split("```md\n", 1)[1].split("```", 1)[0])
        assert parse_routes(path)[1] == []
        cases = [
            (
                source.replace("feature, refactoring:", "featre, refactoring:"),
                "unknown role",
            ),
            (source + "\nfeature: grok-4.7 @ high\n", "duplicate primary"),
            (
                source.replace("general implementation:", "custom/local:"),
                "missing role",
            ),
            (
                source.replace(
                    "fallback fast mechanical work:", "fallback custom/other:"
                ),
                "missing fallback",
            ),
            (source.replace("gpt-6-luna @ low", "current @ low"), "invalid target"),
            (
                source.replace("gpt-6-luna @ low", "gpt-6-luna @ turbo"),
                "invalid target",
            ),
            (source.replace("gpt-6-luna @ low", "gpt-6-luna"), "needs an effort"),
            (
                source.replace(
                    "gpt-6-luna @ low", "gpt-6-luna @ low, gpt-6-luna @ high"
                ),
                "duplicate model",
            ),
        ]
        for text, expected in cases:
            path.write_text(text)
            assert any(expected in error for error in parse_routes(path)[1]), expected
        path.write_text(
            source
            + "\ncustom/local: fable-5.1 @ high\nfallback custom/local: gpt-6-sol @ high\n"
        )
        assert not parse_routes(path)[1]
        catalog_path = Path(directory) / "catalog.json"
        command = [
            sys.executable,
            str(Path(__file__).with_name("validate_config.py")),
            str(path),
            "--launchers",
            str(CONFIG / "launchers.toml"),
            "--catalog",
            str(catalog_path),
        ]
        for payload, code in (({"agents": catalog}, 0), ({"agents": []}, 1), (None, 2)):
            catalog_path.write_text(json.dumps(payload))
            result = subprocess.run(command, capture_output=True, text=True)
            assert result.returncode == code, result.stdout + result.stderr
            assert json.loads(result.stdout)["valid"] == (code == 0)
    with (
        patch(
            "discover.executable",
            side_effect=lambda name: "pi" if name == "pi" else None,
        ),
        patch("discover.run") as run,
    ):
        run.side_effect = [
            {"ok": True, "output": "1.0"},
            {
                "ok": True,
                "output": "provider model\nanthropic fable-5\nopenai-codex gpt-5.6-sol",
            },
        ]
        agents = discover_agents()
        assert len(agents["pi"]["models"]) == 2
        assert run.call_args.args[0] == ["pi", "--offline", "--list-models"]
    print("Routing regression checks passed")


if __name__ == "__main__":
    main()

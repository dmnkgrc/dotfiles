import json
import subprocess
import sys
import tempfile
from pathlib import Path
import tomllib
from unittest.mock import patch

from discover import discover_agents
from validate_config import ROLES, catalog_from_discovery, parse_routes, validate


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
    resolved, unresolved = validate(targets, catalog, launchers)
    assert len(resolved) == len(targets) and not unresolved
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
    aliased, missing = validate(
        [
            {
                "role": "judgment",
                "model": "fable-5.1",
                "effort": "high",
                "kind": "primary",
            }
        ],
        [
            {
                "agent": "pi",
                "provider": "cursor",
                "models": ["fable-5-1@300k"],
                "efforts": ["high"],
            }
        ],
        launchers,
    )
    assert aliased and not missing
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
            (source + "\nfeature: grok-4.6 @ high\n", "duplicate primary"),
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
            (source.replace("gpt-5.6-luna @ low", "current @ low"), "invalid target"),
            (
                source.replace("gpt-5.6-luna @ low", "gpt-5.6-luna @ turbo"),
                "invalid target",
            ),
            (source.replace("gpt-5.6-luna @ low", "gpt-5.6-luna"), "needs an effort"),
            (
                source.replace(
                    "gpt-5.6-luna @ low", "gpt-5.6-luna @ low, gpt-5.6-luna @ high"
                ),
                "duplicate model",
            ),
        ]
        for text, expected in cases:
            path.write_text(text)
            assert any(expected in error for error in parse_routes(path)[1]), expected
        path.write_text(
            source
            + "\ncustom/local: fable-5.1 @ high\nfallback custom/local: gpt-5.6-sol @ high\n"
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

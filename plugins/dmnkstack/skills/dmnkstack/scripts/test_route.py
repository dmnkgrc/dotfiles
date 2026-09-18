import tempfile
from pathlib import Path
from unittest.mock import patch

import route


def main() -> None:
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
    assert general["primary"] == [{"model": "opus-5", "effort": "medium"}]
    assert general["fallback"] == [
        {"model": "grok-4.6", "effort": "high"},
        {"model": "gpt-5.6-sol", "effort": "high"},
        {"model": "fable-5.1", "effort": "high"},
        {"model": "gpt-5.6-luna", "effort": "max"},
    ]
    prose = route.configured_pools(config, "prose")
    assert prose["primary"] == [
        {"model": "gpt-5.6-luna", "effort": "low"},
        {"model": "fable-5.1", "effort": "high"},
    ]
    mechanical = route.configured_pools(config, "fast mechanical work")
    assert mechanical["primary"] == [{"model": "gpt-5.6-luna", "effort": "low"}]
    assert mechanical["fallback"] == [
        {"model": "grok-4.6", "effort": "low"},
        {"model": "opus-5", "effort": "high"},
        {"model": "gpt-5.6-sol", "effort": "high"},
        {"model": "fable-5.1", "effort": "high"},
    ]

    sources = {
        "codex": codex,
        "claude": claude,
        "cursor": cursor,
    }
    with patch("route.shutil.which", side_effect=lambda name: f"/{name}"):
        models = route.normalize_models(sources, {"fable-5-1@300k", "opus-5@300k"})
    assert models["gpt-5.6-sol"]["available"]
    assert models["grok-4.6"]["available"]
    assert models["grok-4.6"]["usage_known"] is True
    assert models["grok-4.6"]["remaining_percent"] == 50.5
    cursor_sources = models["opus-5"]["sources"]
    assert any(source.get("window") == "api" and not source["available"] for source in cursor_sources)
    print("TypeSafe routing parser and policy checks passed")


if __name__ == "__main__":
    main()

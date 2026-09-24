#!/usr/bin/env python3

import argparse
from concurrent.futures import ThreadPoolExecutor
import json
import os
import re
import select
import shutil
import subprocess
import sys
import time
import urllib.error
import urllib.request
from pathlib import Path
from typing import Any


class RoutingError(RuntimeError):
    pass


ROUTES = {
    "investigation": "Read-only understanding: explain mechanics, trace ownership, recover history, teach a subsystem, or inspect logs and traces.",
    "bug-fix": "A product failure needs diagnosis or repair, including captured bug triage and test-first fixes.",
    "verification": "The work is supposedly complete and needs direct proof against the real artifact.",
    "design": "Decide caller usage, types, interfaces, ownership, architecture, or migration shape before implementation.",
    "feature": "Implement new behavior outside a primarily visual or interaction change.",
    "refactoring": "Change internal structure while preserving behavior.",
    "UI": "Implement or change visual design, layout, accessibility, or interaction.",
    "check-repair": "Repair a known lint, formatting, typecheck, unit-test, build, or CI failure.",
    "review": "Read-only critique of a diff, plan, implementation, or blast radius.",
    "environment": "Install, configure, or repair local development tools, runtimes, dependencies, credentials, or environment setup.",
    "arena": "Produce multiple independent solutions to the same task and judge them with one rubric.",
    "swarm": "Divide separable slices of one task among workers and aggregate their results.",
    "custom": "No narrower route fits a large or unusual multi-part task, so design a bespoke workflow.",
    "resume": "Recover prior decisions and repository state before continuing earlier work.",
    "state": "Record a decision trail or resumable checkpoint.",
    "delegation": "The user explicitly wants another model or agent to do the work and report back.",
    "delivery": "Publish already completed work through git, only when explicitly authorized.",
}

MODEL_PROFILES = {
    "grok-4.7": "Best for broad or uncertain feature implementation, behavior-preserving refactors, exploring unfamiliar repositories, tracing mechanics and history, and swarm work. Do not prefer for known mechanical edits, focused unknown bug diagnosis, or judgment-heavy final review.",
    "gpt-6-sol": "Best for evidence-driven diagnosis and repair of unknown failures, performance regressions, incidents, flaky behavior, environment failures, and iterative optimization. Prefer when the task starts with a symptom and needs hypotheses and reproduction.",
    "opus-5.5": "Best for bounded implementation with clear acceptance criteria and local verification, architecture involving APIs, types, state ownership, or module boundaries, and unusual hardest tasks.",
    "gpt-6-luna": "Best for deterministic mechanical work with a known check: proven renames, formatting, generated updates, obvious one-line changes, version bumps, and routine pull request descriptions assembled from verified facts. Do not use for uncertain, consequential, architectural, or judgment-heavy work.",
    "fable-5.1": "Best for judgment-heavy review, complex or high-stakes prose, synthesis, and tradeoffs. Do not prefer for routine pull request descriptions or for the hardest implementation tasks.",
}

MODEL_EXECUTORS = {
    "grok-4.7": ("pi",),
    "gpt-6-sol": ("pi",),
    "opus-5.5": ("claude", "pi"),
    "gpt-6-luna": ("pi",),
    "fable-5.1": ("claude", "pi"),
}

MODEL_ALIASES = {
    "grok-4.7": {"grok-4.7", "grok-4.7@256k"},
    "opus-5.5": {"opus-5.5", "claude-opus-5-5", "opus-5.5@300k"},
    "fable-5.1": {"fable-5.1", "fable", "fable-5-1@300k"},
}


def parse_frontmatter(path: Path) -> dict[str, str] | None:
    try:
        text = path.read_text(errors="replace")
    except OSError:
        return None
    if not text.startswith("---\n") or "\n---" not in text[4:]:
        return None
    header, body = text[4:].split("\n---", 1)
    fields: dict[str, str] = {}
    current = ""
    for line in header.splitlines():
        match = re.match(r"^([A-Za-z][\w-]*):\s*(.*)$", line)
        if match:
            current = match.group(1)
            fields[current] = match.group(2).strip().lstrip(">|-").strip()
        elif current and (line.startswith(" ") or line.startswith("\t")):
            fields[current] = f"{fields[current]} {line.strip()}".strip()
    name = fields.get("name", "").strip("'\"")
    description = " ".join(fields.get("description", "").strip("'\"").split())
    if not name or not description:
        return None
    return {"name": name, "description": description, "body": body.strip()}


def installed_skills(paths: list[Path]) -> dict[str, dict[str, str]]:
    skills: dict[str, dict[str, str]] = {}
    for root in paths:
        if not root.is_dir():
            continue
        for path in sorted(root.glob("*/SKILL.md")):
            parsed = parse_frontmatter(path)
            if parsed and parsed["name"] not in skills:
                skills[parsed["name"]] = parsed
    return skills


def configured_pools(path: Path, role: str) -> dict[str, list[dict[str, str]]]:
    try:
        lines = path.expanduser().read_text().splitlines()
    except OSError as error:
        raise RoutingError(f"Model configuration is unavailable: {error.filename}") from None
    pools: dict[str, list[dict[str, str]]] = {"primary": [], "fallback": []}
    for raw_line in lines:
        line = raw_line.strip()
        if not line or line.startswith("#") or ":" not in line:
            continue
        raw_roles, raw_targets = (part.strip() for part in line.split(":", 1))
        kind = "fallback" if raw_roles.startswith("fallback ") else "primary"
        roles = [value.strip() for value in raw_roles.removeprefix("fallback ").split(",")]
        if role not in roles:
            continue
        for raw_target in raw_targets.split(","):
            if "@" not in raw_target:
                continue
            model, effort = (part.strip() for part in raw_target.rsplit("@", 1))
            if model in MODEL_PROFILES and not any(target["model"] == model for target in pools[kind]):
                pools[kind].append({"model": model, "effort": effort})
    if not pools["primary"]:
        raise RoutingError(f"Model configuration has no TypeSafe candidates for role: {role}")
    return pools


def remaining_window(name: str, used: Any, **details: Any) -> dict[str, Any] | None:
    if not isinstance(used, (int, float)):
        return None
    return {
        "name": name,
        "used_percent": max(0.0, min(100.0, float(used))),
        "remaining_percent": max(0.0, min(100.0, 100.0 - float(used))),
        **details,
    }


def parse_codex_usage(payload: dict[str, Any]) -> dict[str, Any]:
    rate_limits = payload.get("rateLimits")
    if not isinstance(rate_limits, dict):
        return {"source": "codex", "known": False, "windows": []}
    windows = []
    for name in ("primary", "secondary"):
        raw = rate_limits.get(name)
        if not isinstance(raw, dict):
            continue
        window = remaining_window(
            name,
            raw.get("usedPercent"),
            window_minutes=raw.get("windowDurationMins"),
            resets_at=raw.get("resetsAt"),
        )
        if window:
            windows.append(window)
    allowed = payload.get("ordinaryUsageAllowed")
    reached = rate_limits.get("rateLimitReachedType") is not None
    remaining = min((window["remaining_percent"] for window in windows), default=None)
    return {
        "source": "codex",
        "known": bool(windows) or isinstance(allowed, bool),
        "available": allowed is not False and not reached and remaining != 0,
        "remaining_percent": remaining,
        "windows": windows,
    }


def parse_cursor_usage(payload: dict[str, Any]) -> dict[str, Any]:
    plan = payload.get("planUsage")
    if not isinstance(plan, dict):
        return {"source": "cursor", "known": False, "windows": []}
    windows = []
    for name, key in (("api", "apiPercentUsed"), ("auto", "autoPercentUsed")):
        window = remaining_window(name, plan.get(key))
        if window:
            windows.append(window)
    auto = next((window for window in windows if window["name"] == "auto"), None)
    return {
        "source": "cursor",
        "known": auto is not None,
        "available": auto is None or auto["remaining_percent"] > 0,
        "remaining_percent": auto["remaining_percent"] if auto else None,
        "window": "auto",
        "windows": windows,
    }


def select_usage_window(source: dict[str, Any], name: str) -> dict[str, Any]:
    window = next(
        (window for window in source.get("windows", []) if window.get("name") == name),
        None,
    )
    if not window:
        return {**source, "known": False, "available": None, "remaining_percent": None, "window": name}
    remaining = window["remaining_percent"]
    return {
        **source,
        "known": True,
        "available": remaining > 0,
        "remaining_percent": remaining,
        "window": name,
    }


def parse_claude_usage(payload: dict[str, Any]) -> dict[str, Any]:
    if payload.get("local_command") != "usage" or not isinstance(payload.get("result"), str):
        return {"source": "claude", "known": False, "windows": []}
    windows = []
    for label, used in re.findall(r"^(Current (?:session|week[^:]*)):\s*(\d+(?:\.\d+)?)% used", payload["result"], re.MULTILINE):
        window = remaining_window(label.removeprefix("Current ").lower(), float(used))
        if window:
            windows.append(window)
    general = next((window for window in windows if window["name"] == "week (all models)"), None)
    remaining = general["remaining_percent"] if general else None
    return {
        "source": "claude",
        "known": general is not None,
        "available": remaining is None or remaining > 0,
        "remaining_percent": remaining,
        "windows": windows,
    }


def unknown_usage(source: str, reason: str) -> dict[str, Any]:
    return {"source": source, "known": False, "available": None, "remaining_percent": None, "windows": [], "reason": reason}


def codex_usage() -> dict[str, Any]:
    executable = shutil.which("codex")
    if not executable:
        return unknown_usage("codex", "executor-not-installed")
    process = None
    try:
        process = subprocess.Popen(
            [executable, "app-server", "--listen", "stdio://"],
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            stderr=subprocess.DEVNULL,
            text=True,
        )
        if process.stdin is None or process.stdout is None:
            return unknown_usage("codex", "query-failed")

        def request(message: dict[str, Any], identifier: int) -> dict[str, Any] | None:
            process.stdin.write(json.dumps(message) + "\n")
            process.stdin.flush()
            deadline = time.monotonic() + 8
            while time.monotonic() < deadline:
                ready, _, _ = select.select([process.stdout], [], [], deadline - time.monotonic())
                if not ready:
                    break
                line = process.stdout.readline()
                if not line:
                    break
                try:
                    response = json.loads(line)
                except (json.JSONDecodeError, UnicodeDecodeError):
                    continue
                if not isinstance(response, dict):
                    continue
                if response.get("id") == identifier:
                    return response.get("result") if isinstance(response.get("result"), dict) else None
            return None

        initialized = request(
            {"method": "initialize", "id": 1, "params": {"clientInfo": {"name": "dmnkstack", "title": "Dmnkstack", "version": "1"}, "capabilities": {"experimentalApi": False, "requestAttestation": False, "optOutNotificationMethods": []}}},
            1,
        )
        if initialized is None:
            return unknown_usage("codex", "initialize-failed")
        process.stdin.write(json.dumps({"method": "initialized"}) + "\n")
        process.stdin.flush()
        payload = request({"method": "account/rateLimits/read", "id": 2}, 2)
        return parse_codex_usage(payload) if payload else unknown_usage("codex", "invalid-response")
    except (OSError, ValueError, AttributeError, UnicodeDecodeError):
        return unknown_usage("codex", "query-failed")
    finally:
        if process is not None:
            process.terminate()
            try:
                process.wait(timeout=1)
            except subprocess.TimeoutExpired:
                process.kill()


def claude_usage() -> dict[str, Any]:
    executable = shutil.which("claude")
    if not executable:
        return unknown_usage("claude", "executor-not-installed")
    try:
        result = subprocess.run(
            [executable, "-p", "/usage", "--output-format", "json", "--max-turns", "1"],
            capture_output=True,
            text=True,
            timeout=20,
            check=False,
        )
        payload = json.loads(result.stdout)
    except (OSError, subprocess.TimeoutExpired, json.JSONDecodeError, UnicodeDecodeError):
        return unknown_usage("claude", "query-failed")
    return parse_claude_usage(payload) if isinstance(payload, dict) else unknown_usage("claude", "invalid-response")


def cursor_tokens() -> list[str]:
    tokens = []
    if sys.platform == "darwin":
        try:
            result = subprocess.run(
                ["security", "find-generic-password", "-s", "cursor-access-token", "-a", "cursor-user", "-w"],
                capture_output=True,
                text=True,
                timeout=5,
                check=False,
            )
            if result.returncode == 0 and result.stdout.strip():
                tokens.append(result.stdout.strip())
        except (OSError, subprocess.TimeoutExpired):
            pass
    token = os.environ.get("CURSOR_API_KEY", "").strip()
    if token and token not in tokens:
        tokens.append(token)
    return tokens


def cursor_usage() -> dict[str, Any]:
    tokens = cursor_tokens()
    if not tokens:
        return unknown_usage("cursor", "no-token")
    for token in tokens:
        request = urllib.request.Request(
            "https://api2.cursor.sh/aiserver.v1.DashboardService/GetCurrentPeriodUsage",
            data=b"{}",
            headers={"Authorization": f"Bearer {token}", "Content-Type": "application/json", "Connect-Protocol-Version": "1"},
            method="POST",
        )
        try:
            with urllib.request.urlopen(request, timeout=8) as response:
                payload = json.load(response)
        except (OSError, urllib.error.HTTPError, json.JSONDecodeError, UnicodeDecodeError):
            continue
        if isinstance(payload, dict):
            return parse_cursor_usage(payload)
    return unknown_usage("cursor", "query-failed")


def exe_vm() -> bool:
    return Path("/home/exedev").is_dir()


def configured_pi_models() -> set[str]:
    path = Path.home() / ".pi/agent/settings.json"
    try:
        settings = json.loads(path.read_text())
    except (OSError, json.JSONDecodeError):
        return set()
    names: list[str] = []
    default = settings.get("defaultModel")
    if isinstance(default, str):
        names.append(default)
    enabled = settings.get("enabledModels")
    if isinstance(enabled, list):
        names.extend(item for item in enabled if isinstance(item, str))
    return {name.split("/", 1)[-1] for name in names if name}


def pi_models() -> set[str]:
    if exe_vm():
        return configured_pi_models()
    executable = shutil.which("pi")
    if not executable:
        return set()
    try:
        result = subprocess.run(
            [executable, "--offline", "--list-models"], capture_output=True, text=True, timeout=8, check=False
        )
    except (OSError, subprocess.TimeoutExpired):
        return set()
    models = set()
    for line in result.stdout.splitlines()[1:]:
        columns = line.split()
        if len(columns) >= 2:
            models.add(columns[1])
    return models


def conductor_agents() -> set[str]:
    """Agents Conductor can start in this workspace; a local executor binary is not required there."""
    if not os.environ.get("CONDUCTOR_WORKSPACE_ID"):
        return set()
    executable = shutil.which("conductor")
    if not executable:
        return set()
    try:
        result = subprocess.run([executable, "--json", "model"], capture_output=True, text=True, timeout=15, check=False)
        payload = json.loads(result.stdout or "{}")
    except (OSError, subprocess.TimeoutExpired, json.JSONDecodeError):
        return set()
    return {
        agent.get("agent")
        for agent in payload.get("agents", [])
        if isinstance(agent, dict) and agent.get("agent") and agent.get("models")
    }


def normalize_models(
    sources: dict[str, dict[str, Any]], catalog: set[str], conductor: set[str] | None = None
) -> dict[str, dict[str, Any]]:
    launchable = conductor_agents() if conductor is None else conductor
    installed = {
        "codex": shutil.which("codex") is not None or "codex" in launchable,
        "cursor": shutil.which("cursor-agent") is not None or "cursor" in launchable,
        "claude": shutil.which("claude") is not None or "claude" in launchable,
        "pi": bool(catalog),
    }
    normalized = {}
    for model, executors in MODEL_EXECUTORS.items():
        aliases = MODEL_ALIASES.get(model, {model})
        pi_supports = bool(aliases & catalog)
        usable = [executor for executor in executors if installed[executor] and (executor != "pi" or pi_supports)]
        provider_sources = []
        if model.startswith("gpt-") and "codex" in usable:
            provider_sources.append(sources["codex"])
        elif model.startswith("gpt-") and "pi" in usable:
            provider_sources.append(unknown_usage("codex", "executor-not-used"))
        if model == "grok-4.7" and ("cursor" in usable or "pi" in usable):
            provider_sources.append(select_usage_window(sources["cursor"], "auto"))
        if model in {"opus-5.5", "fable-5.1"}:
            if "claude" in usable:
                claude = sources["claude"]
                if model == "fable-5.1":
                    fable = next((window for window in claude.get("windows", []) if window["name"] == "week (fable)"), None)
                    if fable:
                        claude = {**claude, "known": True, "available": fable["remaining_percent"] > 0, "remaining_percent": fable["remaining_percent"]}
                provider_sources.append(claude)
            if "pi" in usable:
                provider_sources.append(select_usage_window(sources["cursor"], "api"))
        known_remaining = [source["remaining_percent"] for source in provider_sources if source.get("known") and isinstance(source.get("remaining_percent"), (int, float)) and source.get("available") is not False]
        has_unknown = any(
            not source.get("known")
            or (source.get("available") is not False and not isinstance(source.get("remaining_percent"), (int, float)))
            for source in provider_sources
        )
        available = bool(usable) and (has_unknown or bool(known_remaining))
        remaining = max(known_remaining, default=None)
        normalized[model] = {
            "available": available,
            "remaining_percent": remaining,
            "usage_known": not has_unknown and bool(provider_sources),
            "executors": usable,
            "sources": provider_sources,
        }
    return normalized


def eligible_pool(
    pools: dict[str, list[dict[str, str]]], models: dict[str, dict[str, Any]]
) -> tuple[list[dict[str, str]], str | None]:
    reasons = []
    for kind in ("primary", "fallback"):
        targets = pools[kind]
        unavailable = [target["model"] for target in targets if not models[target["model"]]["available"]]
        usable = [target for target in targets if models[target["model"]]["available"]]
        healthy = [target for target in usable if state_is_healthy(models[target["model"]])]
        if unavailable:
            reasons.append(f"excluded unavailable or exhausted {kind} candidates: {', '.join(unavailable)}")
        if healthy:
            scarce = [target["model"] for target in usable if target not in healthy]
            if scarce:
                reasons.append(f"excluded scarce {kind} candidates at or below 10%: {', '.join(scarce)}")
            if kind == "fallback":
                reasons.append("no healthy primary candidate remained; using healthy fallback candidates")
            return healthy, "; ".join(reasons) or None

    for kind in ("primary", "fallback"):
        scarce = [target for target in pools[kind] if models[target["model"]]["available"]]
        if scarce:
            reasons.append(f"no healthy candidate remained; scarce {kind} candidates retained")
            return scarce, "; ".join(reasons)
    reasons.append("no available candidate")
    return [], "; ".join(reasons)


def state_is_healthy(state: dict[str, Any]) -> bool:
    remaining = state.get("remaining_percent")
    return not state.get("usage_known") or not isinstance(remaining, (int, float)) or remaining > 10


def difficulty(task: str, route: str) -> str:
    lowered = task.lower()
    migration_risk = "migration" in lowered and any(
        word in lowered for word in ("concurrent", "old and new", "rollback", "schema", "writer")
    )
    if migration_risk or any(
        word in lowered
        for word in (
            "security",
            "money",
            "financial",
            "concurrency",
            "data loss",
            "irreversible",
            "zero-downtime",
        )
    ):
        return "consequential"
    if any(word in lowered for word in ("unknown", "intermittent", "flaky", "investigate", "diagnose", "unclear", "unfamiliar")) or route in {"custom", "design"}:
        return "uncertain"
    if any(word in lowered for word in ("rename", "format", "version bump", "unused import", "regenerate", "one-line", "typo")) and route in {"refactoring", "check-repair", "environment", "verification"}:
        return "mechanical"
    return "bounded"


def model_role(route: str, level: str) -> str:
    if level == "mechanical":
        return "fast mechanical work"
    if level == "bounded" and route in {
        "bug-fix",
        "check-repair",
        "environment",
        "feature",
        "refactoring",
        "UI",
    }:
        return "general implementation"
    return {
        "investigation": "how explorer",
        "bug-fix": "bug-fix",
        "verification": "bug-fix",
        "design": "architect runners",
        "feature": "feature",
        "refactoring": "refactoring",
        "UI": "feature",
        "check-repair": "bug-fix",
        "review": "interrogate reviewers",
        "environment": "bug-fix",
        "arena": "arena runners",
        "swarm": "swarm workers",
        "custom": "hardest tasks",
        "resume": "how explorer",
        "state": "judgment",
        "delegation": "general implementation",
        "delivery": "prose",
    }[route]


def effort_for(configured: str, level: str) -> str:
    return "max" if level == "consequential" else configured


def validate_key(value: str) -> str | None:
    key = value.strip()
    if any(not 33 <= ord(char) <= 126 for char in key):
        raise RoutingError("TYPESAFE_API_KEY must be a single printable ASCII token")
    return key or None


def read_key(command: list[str]) -> str | None:
    try:
        result = subprocess.run(command, capture_output=True, text=True, timeout=5, check=False)
    except (OSError, subprocess.TimeoutExpired):
        return None
    parts = result.stdout.split("\0")
    if result.returncode != 0 or len(parts) != 3:
        return None
    return validate_key(parts[1])


def typesafe_key() -> str | None:
    key = validate_key(os.environ.get("TYPESAFE_API_KEY", ""))
    if key:
        return key
    env_file = Path(os.environ.get("XDG_CONFIG_HOME") or Path.home() / ".config") / "dmnkstack" / "typesafe.env"
    if env_file.is_file():
        key = read_key(["/bin/sh", "-c", r'set -a; . "$1" || exit; printf "\0%s\0" "$TYPESAFE_API_KEY"', "sh", str(env_file)])
        if key:
            return key
    for name in ("fish", "bash", "zsh"):
        shell = shutil.which(name)
        if not shell:
            continue
        key = read_key([shell, "-lc", r'printf "\0%s\0" "$TYPESAFE_API_KEY"'])
        if key:
            return key
    return None


def typesafe_call(key: str, state: dict[str, Any], questions: dict[str, Any]) -> dict[str, Any]:
    validated_key = validate_key(key)
    if not validated_key:
        raise RoutingError("TYPESAFE_API_KEY is not configured")
    url = os.environ.get("TYPESAFE_BASE_URL", "https://api.typesafe.ai").rstrip("/") + "/v1/systemone"
    body = json.dumps({"state": state, "model": os.environ.get("TYPESAFE_DEFAULT_MODEL", "jev-latest"), "questions": questions}).encode()
    request = urllib.request.Request(
        url,
        data=body,
        headers={"Authorization": f"Bearer {validated_key}", "Accept": "application/json", "Content-Type": "application/json", "User-Agent": "dmnkstack-router/1"},
        method="POST",
    )
    for attempt in range(3):
        try:
            with urllib.request.urlopen(request, timeout=12) as response:
                payload = json.load(response)
            break
        except urllib.error.HTTPError as error:
            if error.code not in {429, 529} or attempt == 2:
                raise RoutingError(f"TypeSafe API returned HTTP {error.code}") from None
            time.sleep(0.5 * 2**attempt)
        except (OSError, ValueError) as error:
            raise RoutingError(f"TypeSafe API request failed: {type(error).__name__}") from None
    if not isinstance(payload, dict) or not isinstance(payload.get("answers"), dict):
        raise RoutingError("TypeSafe API returned an invalid response")
    return payload


def choice(payload: dict[str, Any], name: str, allowed: set[str]) -> dict[str, Any]:
    answer = payload["answers"].get(name)
    if not isinstance(answer, dict) or answer.get("choice") not in allowed:
        raise RoutingError(f"TypeSafe API omitted a valid {name} choice")
    probabilities = answer.get("probabilities")
    confidence = answer.get("confidence")
    if not isinstance(probabilities, dict) or not isinstance(confidence, (int, float)):
        raise RoutingError(f"TypeSafe API returned an invalid {name} answer")
    return {
        "choice": answer["choice"],
        "confidence": float(confidence),
        "probabilities": {
            key: float(value)
            for key, value in probabilities.items()
            if key in allowed and isinstance(value, (int, float))
        },
    }


def usage(payloads: list[dict[str, Any]]) -> dict[str, int]:
    totals = {"input_tokens": 0, "output_tokens": 0}
    for payload in payloads:
        raw = payload.get("usage")
        if not isinstance(raw, dict):
            raise RoutingError("TypeSafe API returned invalid token usage")
        for name in totals:
            value = raw.get(name)
            if not isinstance(value, int):
                raise RoutingError("TypeSafe API returned invalid token usage")
            totals[name] += value
    return totals


def default_skill_roots() -> list[Path]:
    home = Path.home()
    roots = [
        Path.cwd() / ".agents/skills",
        Path.cwd() / ".pi/skills",
        home / ".agents/skills",
        home / ".pi/agent/skills",
        Path(__file__).resolve().parents[2],
    ]
    packages = home / ".pi/agent/npm/node_modules"
    roots.extend(packages.glob("*/skills"))
    roots.extend(packages.glob("@*/*/skills"))
    roots.extend((home / ".pi/agent/git").glob("*/*/*/skills"))
    return roots


def default_models_path() -> Path:
    root = os.environ.get("XDG_CONFIG_HOME") or Path.home() / ".config"
    return Path(root) / "dmnkstack/models.md"


def run(args: argparse.Namespace) -> dict[str, Any]:
    started = time.perf_counter()
    key = typesafe_key()
    if not key:
        return {
            "status": "local",
            "typesafe": {"calls": 0},
            "reason": "TYPESAFE_API_KEY is not configured",
            "next_step": "Choose the route, installed skill, and configured model locally using references/routing.md",
        }
    skills = installed_skills(args.skills or default_skill_roots())
    if not skills:
        raise RoutingError("No installed skill frontmatter was found")
    skill_criteria = {name: skill["description"] for name, skill in skills.items() if name != "dmnkstack"}
    skill_criteria["none"] = "No installed skill specifically fits this request."
    conversation_state = args.conversation_state or ("continuation" if args.active_route else "new")
    state = {"latest_request": args.task, "conversation_state": conversation_state}
    if args.prior_task:
        state["prior_active_task"] = args.prior_task
    if args.active_route:
        state["active_route"] = args.active_route
    with ThreadPoolExecutor(max_workers=4) as executor:
        quota_futures = {
            "claude": executor.submit(claude_usage),
            "cursor": executor.submit(cursor_usage),
        }
        catalog_future = executor.submit(pi_models)
        first = typesafe_call(
            key,
            state,
            {
                "route": {"type": "choice", "instructions": "Choose the semantic Dmnkstack task route. The supplied conversation state is authoritative: corrections override prior work; continuations retain the active route unless the task class changed. Never infer authorization to publish or act externally.", "criteria": ROUTES},
                "skill": {"type": "choice", "instructions": "Choose the installed skill whose frontmatter specifically fits the latest request. Choose none when no listed skill is a real match.", "criteria": skill_criteria},
            },
        )
        sources = {name: future.result() for name, future in quota_futures.items()}
        catalog = catalog_future.result()
    route = choice(first, "route", set(ROUTES))
    selected_skill = choice(first, "skill", set(skill_criteria))
    level = difficulty(args.task, route["choice"])
    role = model_role(route["choice"], level)
    models = normalize_models(sources, catalog)
    pools = configured_pools(args.models, role)
    configured = [target["model"] for kind in ("primary", "fallback") for target in pools[kind]]
    eligible_targets, substitution = eligible_pool(
        pools, {name: models[name] for name in configured}
    )
    eligible = [target["model"] for target in eligible_targets]
    if not eligible:
        raise RoutingError("No configured model is available after deterministic availability and quota checks")
    questions = {
        "model": {"type": "choice", "instructions": "Choose the best configured model for this task and route from only these deterministically eligible candidates. Select by the detailed capability profiles. Availability and quota eligibility have already been decided and must not be inferred.", "criteria": {name: MODEL_PROFILES[name] for name in eligible}}
    }
    reranked = False
    probabilities = selected_skill["probabilities"]
    ranked = sorted((name for name in probabilities if name != "none"), key=lambda name: probabilities[name], reverse=True)
    top_gap = probabilities.get(ranked[0], 0) - probabilities.get(ranked[1], 0) if len(ranked) > 1 else 1
    if selected_skill["choice"] != "none" and ((selected_skill["confidence"] or 0) < 0.8 or top_gap < 0.25):
        shortlist = ranked[:3]
        if selected_skill["choice"] not in shortlist:
            shortlist.append(selected_skill["choice"])
        detailed = {name: f'{skills[name]["description"]} {skills[name]["body"][:900]}' for name in shortlist}
        detailed["none"] = "None of these skills specifically fits the request."
        questions["skill"] = {"type": "choice", "instructions": "Rerank these close skill candidates using their detailed instructions. Choose none if all are near-matches.", "criteria": detailed}
        reranked = True
    second = typesafe_call(key, {"task": args.task, "route": route["choice"]}, questions)
    model = choice(second, "model", set(eligible))
    if reranked:
        selected_skill = choice(second, "skill", set(questions["skill"]["criteria"]))
    target = next(target for target in eligible_targets if target["model"] == model["choice"])
    return {
        "status": "routed",
        "typesafe": {"model": second.get("model") or first.get("model"), "calls": 2, "token_usage": usage([first, second])},
        "route": route,
        "skill": {**selected_skill, "reranked": reranked},
        "model": {**model, "effort": effort_for(target["effort"], level)},
        "difficulty": level,
        "role": role,
        "quota": {"models": {name: models[name] for name in configured}, "sources": sources, "eligible": eligible},
        "substitution_reason": substitution,
        "latency_ms": round((time.perf_counter() - started) * 1000),
    }


def main() -> int:
    parser = argparse.ArgumentParser(description="Route through TypeSafe Jev when configured; otherwise hand off to local routing")
    parser.add_argument("task")
    parser.add_argument("--prior-task")
    parser.add_argument("--active-route", choices=sorted(ROUTES))
    parser.add_argument("--conversation-state", choices=("new", "continuation", "correction", "pause", "resume"))
    parser.add_argument("--skills", type=Path, action="append")
    parser.add_argument("--models", type=Path, default=default_models_path())
    args = parser.parse_args()
    try:
        print(json.dumps(run(args), sort_keys=True))
        return 0
    except RoutingError as error:
        print(json.dumps({"status": "error", "routed": False, "error": str(error)}, sort_keys=True))
        return 2
    except Exception as error:
        print(json.dumps({"status": "error", "routed": False, "error": f"Router failed: {type(error).__name__}"}, sort_keys=True))
        return 2


if __name__ == "__main__":
    raise SystemExit(main())

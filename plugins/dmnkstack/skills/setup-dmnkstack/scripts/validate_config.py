#!/usr/bin/env python3

import argparse
import json
from pathlib import Path
import tomllib
from typing import Any

from discover import collect


ROLES = {
    "feature",
    "refactoring",
    "bug-fix",
    "perf-issue",
    "hillclimb",
    "general implementation",
    "fast mechanical work",
    "judgment",
    "prose",
    "hardest tasks",
    "how explorer",
    "how explainer",
    "how critics",
    "why investigators",
    "why synthesizer",
    "reflect tooling",
    "reflect judgment",
    "divergent",
    "synthesizer",
    "arena runners",
    "arena cross-judge pool",
    "swarm workers",
    "architect runners",
    "interrogate reviewers",
}
EFFORTS = {"off", "minimal", "low", "medium", "high", "xhigh", "max"}


def parse_routes(path: Path) -> tuple[list[dict[str, str]], list[str]]:
    targets: list[dict[str, str]] = []
    errors: list[str] = []
    seen: dict[str, set[str]] = {"primary": set(), "fallback": set()}
    for line_number, raw_line in enumerate(path.read_text().splitlines(), start=1):
        line = raw_line.strip()
        if not line or line.startswith("#"):
            continue
        if ":" not in line:
            errors.append(f"line {line_number}: expected 'role: model @ effort'")
            continue
        raw_roles, raw_targets = [part.strip() for part in line.split(":", 1)]
        kind = "fallback" if raw_roles.startswith("fallback ") else "primary"
        roles = raw_roles.removeprefix("fallback ").split(",")
        for raw_role in roles:
            role = raw_role.strip()
            if role not in ROLES and not (
                role.startswith("custom/") and role[7:].strip()
            ):
                errors.append(
                    f"line {line_number}: unknown role '{role}'; custom roles need custom/"
                )
            if role in seen[kind]:
                errors.append(f"line {line_number}: duplicate {kind} role '{role}'")
            seen[kind].add(role)
            models: set[str] = set()
            for raw_target in raw_targets.split(","):
                target = raw_target.strip()
                if "@" not in target:
                    errors.append(
                        f"line {line_number}: target '{target}' needs an effort"
                    )
                    continue
                model, effort = [part.strip() for part in target.rsplit("@", 1)]
                if not model or model == "current" or effort not in EFFORTS:
                    errors.append(f"line {line_number}: invalid target '{target}'")
                    continue
                if model in models:
                    errors.append(
                        f"line {line_number}: duplicate model '{model}' for '{role}'"
                    )
                models.add(model)
                targets.append(
                    {"role": role, "kind": kind, "model": model, "effort": effort}
                )
    for role in sorted(ROLES - seen["primary"]):
        errors.append(f"missing role '{role}'")
    for role in sorted(seen["primary"] - seen["fallback"]):
        errors.append(f"missing fallback for '{role}'")
    for role in sorted(seen["fallback"] - seen["primary"]):
        errors.append(f"fallback without primary role '{role}'")
    return targets, errors


def catalog_from_discovery(
    discovery: dict[str, Any], launchers: dict[str, Any] | None = None
) -> list[dict[str, Any]]:
    catalog = [
        {**agent, "manager": "conductor"}
        for agent in discovery.get("conductor", {}).get("agents", [])
    ]
    for entry in discovery.get("agents", {}).get("pi", {}).get("models", []):
        if entry.get("provider") and entry.get("model"):
            catalog.append(
                {
                    "agent": "pi",
                    "provider": entry["provider"],
                    "manager": "local",
                    "models": [entry["model"]],
                    "efforts": sorted(EFFORTS),
                }
            )
    if discovery.get("agents", {}).get("claude", {}).get("installed"):
        names: list[str] = []
        for logical, mapped in (launchers or {}).get("aliases", {}).items():
            if isinstance(mapped, dict) and mapped.get("claude"):
                names.extend([logical, mapped["claude"]])
        if names:
            catalog.append(
                {
                    "agent": "claude",
                    "manager": "local",
                    "models": names,
                    "efforts": sorted(EFFORTS),
                }
            )
    return catalog


def family_models(launchers: dict[str, Any], family: str) -> set[str]:
    models = launchers.get("families", {}).get(family, {}).get("models", [])
    return set(models) if isinstance(models, list) else set()


def native_names(model: str, agent: str, launchers: dict[str, Any]) -> set[str]:
    mapped = launchers.get("aliases", {}).get(model, {})
    native = mapped.get(agent) if isinstance(mapped, dict) else None
    return {model, native} if native else {model}


def validate(
    targets: list[dict[str, str]],
    catalog: list[dict[str, Any]],
    launchers: dict[str, Any],
    cursor_usage: dict[str, Any] | None = None,
) -> tuple[list[dict[str, Any]], list[dict[str, Any]]]:
    resolved: list[dict[str, Any]] = []
    unresolved: list[dict[str, Any]] = []
    anthropic = family_models(launchers, "anthropic")
    api_remaining = (
        cursor_usage.get("api_remaining")
        if isinstance(cursor_usage, dict) and cursor_usage.get("available")
        else None
    )
    for target in targets:
        allowed = {
            executor
            for family in launchers.get("families", {}).values()
            if target["model"] in family.get("models", [])
            for executor in family.get("executors", [])
        }
        if target["model"] in anthropic and "pi" in allowed and api_remaining is False:
            allowed.discard("pi")
        matches = [
            entry
            for entry in catalog
            if native_names(target["model"], entry.get("agent", ""), launchers)
            & set(entry.get("models", []))
            and entry.get("agent") in allowed
            and entry.get("agent") in launchers.get("agents", {})
            and (entry.get("agent") != "pi" or entry.get("provider"))
            and target["effort"] in entry.get("efforts", [])
        ]
        if matches:
            resolved.append(
                {
                    **target,
                    "executors": [
                        {
                            key: entry[key]
                            for key in ("agent", "provider", "manager")
                            if key in entry
                        }
                        for entry in matches
                    ],
                }
            )
        else:
            reason = (
                "no launcher family"
                if not allowed
                else "no matching model/effort/executor/provider in catalog"
            )
            unresolved.append({**target, "reason": reason})
    return resolved, unresolved


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Validate Dmnkstack model routes (Python 3.11+)"
    )
    parser.add_argument("models", type=Path)
    parser.add_argument(
        "--launchers", type=Path, help="Defaults to launchers.toml beside models"
    )
    parser.add_argument(
        "--catalog", type=Path, help="Saved discovery or an object with an agents list"
    )
    parser.add_argument("--pretty", action="store_true")
    args = parser.parse_args()
    try:
        models = args.models.expanduser()
        targets, errors = parse_routes(models)
        launcher_path = (
            args.launchers.expanduser()
            if args.launchers
            else models.with_name("launchers.toml")
        )
        launchers = tomllib.loads(launcher_path.read_text())
        if launchers.get("selection", {}).get("fallback") != "role-chain-or-stop":
            errors.append("launcher selection.fallback must be role-chain-or-stop")
        discovery = (
            json.loads(args.catalog.expanduser().read_text())
            if args.catalog
            else collect()
        )
        catalog = discovery.get("agents", [])
        if not isinstance(catalog, list):
            catalog = catalog_from_discovery(discovery, launchers)
        cursor_usage = discovery.get("cursor_usage")
        if not isinstance(cursor_usage, dict):
            cursor_usage = None
        resolved, unresolved = validate(targets, catalog, launchers, cursor_usage)
    except (OSError, ValueError, TypeError, AttributeError) as error:
        print(json.dumps({"valid": False, "errors": [str(error)]}))
        return 2
    covered = {target["role"] for target in resolved}
    report = {
        "valid": not errors and not unresolved and bool(catalog),
        "catalog_available": bool(catalog),
        "session_create_ready": discovery.get("conductor", {}).get(
            "session_create_ready", False
        ),
        "cursor_usage": cursor_usage,
        "readiness_note": "Catalog compatibility only; authentication, active manager, and model execution need launch-time checks.",
        "target_count": len(targets),
        "distinct_models": sorted({target["model"] for target in targets}),
        "roles_without_candidate": sorted(
            {target["role"] for target in targets} - covered
        ),
        "errors": errors,
        "resolved": resolved,
        "unresolved": unresolved,
    }
    print(json.dumps(report, indent=2 if args.pretty else None, sort_keys=True))
    return 2 if errors else int(bool(unresolved) or not catalog)


if __name__ == "__main__":
    raise SystemExit(main())

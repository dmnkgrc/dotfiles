#!/usr/bin/env python3

import argparse
import json
from pathlib import Path
from typing import Any

from discover import collect


def parse_routes(path: Path) -> tuple[list[dict[str, str]], list[str]]:
    targets: list[dict[str, str]] = []
    errors: list[str] = []
    for line_number, raw_line in enumerate(path.read_text().splitlines(), start=1):
        line = raw_line.strip()
        if not line or line.startswith("#"):
            continue
        if ":" not in line:
            errors.append(f"line {line_number}: expected 'role: model @ effort'")
            continue
        role, raw_targets = [part.strip() for part in line.split(":", 1)]
        if role == "unavailable target fallback":
            if not raw_targets:
                errors.append(f"line {line_number}: fallback cannot be empty")
            continue
        for raw_target in raw_targets.split(","):
            target = raw_target.strip()
            if "@" not in target:
                errors.append(f"line {line_number}: target '{target}' needs an effort")
                continue
            model, effort = [part.strip() for part in target.rsplit("@", 1)]
            if not model or not effort:
                errors.append(f"line {line_number}: target '{target}' is incomplete")
                continue
            targets.append({"role": role, "model": model, "effort": effort})
    return targets, errors


def load_catalog(path: Path | None) -> list[dict[str, Any]]:
    if path:
        payload = json.loads(path.read_text())
        if isinstance(payload, dict):
            return payload.get("agents", payload.get("conductor", {}).get("agents", []))
        return []
    discovery = collect()
    catalog = list(discovery.get("conductor", {}).get("agents", []))
    pi_models = [
        entry["model"]
        for entry in discovery.get("agents", {}).get("pi", {}).get("models", [])
        if entry.get("provider") == "openai-codex" and entry.get("model")
    ]
    if pi_models:
        catalog.append(
            {
                "agent": "pi",
                "models": pi_models,
                "efforts": ["off", "minimal", "low", "medium", "high", "xhigh", "max"],
            }
        )
    return catalog


def validate(targets: list[dict[str, str]], catalog: list[dict[str, Any]]) -> list[dict[str, str]]:
    availability: dict[str, set[str]] = {}
    for agent in catalog:
        efforts = set(agent.get("efforts", []))
        for model in agent.get("models", []):
            availability.setdefault(model, set()).update(efforts)

    unresolved: list[dict[str, str]] = []
    for target in targets:
        efforts = availability.get(target["model"])
        if efforts is None:
            unresolved.append({**target, "reason": "model not found"})
        elif target["effort"] not in efforts:
            unresolved.append({**target, "reason": "effort not supported"})
    return unresolved


def main() -> int:
    parser = argparse.ArgumentParser(description="Validate Dmnkstack model routes")
    parser.add_argument("models", type=Path)
    parser.add_argument("--catalog", type=Path)
    parser.add_argument("--pretty", action="store_true")
    args = parser.parse_args()

    targets, errors = parse_routes(args.models.expanduser())
    catalog = load_catalog(args.catalog)
    unresolved = validate(targets, catalog) if catalog else []
    report = {
        "valid": not errors and not unresolved and bool(catalog),
        "catalog_available": bool(catalog),
        "target_count": len(targets),
        "distinct_models": sorted({target["model"] for target in targets}),
        "errors": errors,
        "unresolved": unresolved,
    }
    print(json.dumps(report, indent=2 if args.pretty else None, sort_keys=True))
    if errors:
        return 2
    if unresolved or not catalog:
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

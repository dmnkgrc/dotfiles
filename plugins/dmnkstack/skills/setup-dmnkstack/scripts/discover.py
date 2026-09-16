#!/usr/bin/env python3

import argparse
import json
import os
import platform
import shutil
import subprocess
from pathlib import Path
from typing import Any


AGENTS = {
    "claude": ("claude", ["--version"]),
    "codex": ("codex", ["--version"]),
    "cursor": ("cursor-agent", ["--version"]),
    "pi": ("pi", ["--version"]),
}


def run(command: list[str], timeout: int = 8) -> dict[str, Any]:
    try:
        completed = subprocess.run(
            command,
            capture_output=True,
            check=False,
            text=True,
            timeout=timeout,
        )
    except (OSError, subprocess.TimeoutExpired) as error:
        return {"ok": False, "error": str(error)}

    output = completed.stdout.strip() or completed.stderr.strip()
    return {
        "ok": completed.returncode == 0,
        "exit_code": completed.returncode,
        "output": output,
    }


def executable(name: str, fallback: str | None = None) -> str | None:
    resolved = shutil.which(name)
    if resolved:
        return resolved
    if fallback and Path(fallback).is_file():
        return fallback
    return None


def discover_agents() -> dict[str, Any]:
    agents: dict[str, Any] = {}
    for name, (command, version_args) in AGENTS.items():
        resolved = executable(command)
        if not resolved:
            agents[name] = {"installed": False}
            continue
        result = run([resolved, *version_args])
        agent: dict[str, Any] = {
            "installed": True,
            "executable": resolved,
            "version": result.get("output", "").splitlines()[0]
            if result.get("ok")
            else None,
        }
        if name == "pi":
            catalog_result = run([resolved, "--offline", "--list-models"])
            models: list[dict[str, str]] = []
            if catalog_result.get("ok"):
                for line in catalog_result.get("output", "").splitlines()[1:]:
                    columns = line.split()
                    if len(columns) >= 2:
                        models.append({"provider": columns[0], "model": columns[1]})
            agent["models"] = models
            if not catalog_result.get("ok"):
                agent["catalog_error"] = catalog_result.get(
                    "output"
                ) or catalog_result.get("error")
        agents[name] = agent
    return agents


def discover_conductor() -> dict[str, Any]:
    resolved = executable("conductor")
    if not resolved:
        return {"installed": False, "active": False, "agents": []}

    result = run([resolved, "--json", "model"])
    catalog: list[dict[str, Any]] = []
    error = None
    if result.get("ok"):
        try:
            payload = json.loads(result.get("output", "{}"))
            catalog = payload.get("agents", [])
        except (json.JSONDecodeError, AttributeError) as parse_error:
            error = str(parse_error)
    else:
        error = result.get("output") or result.get("error")

    credential_source = None
    if os.environ.get("CONDUCTOR_API_TOKEN"):
        credential_source = "workspace-token"
    elif os.environ.get("CONDUCTOR_API_KEY"):
        credential_source = "api-key"

    auth_status = run([resolved, "auth", "status"])
    auth_output = auth_status.get("output", "").lower()
    keychain_ready = bool(
        auth_status.get("ok") and auth_output and "no keychain entry" not in auth_output
    )
    if credential_source is None and keychain_ready:
        credential_source = "macos-keychain"

    local_flag = os.environ.get("CONDUCTOR_IS_LOCAL")
    local = (
        local_flag == "1" if local_flag is not None else platform.system() == "Darwin"
    )

    return {
        "installed": True,
        "active": bool(os.environ.get("CONDUCTOR_WORKSPACE_ID")),
        "local": local,
        "local_source": "environment" if local_flag is not None else "host-platform",
        "session_create_ready": credential_source is not None,
        "credential_source": credential_source,
        "agents": catalog,
        "error": error,
    }


def discover_herdr() -> dict[str, Any]:
    resolved = executable("herdr")
    if not resolved:
        return {"installed": False, "active": False, "agent_kinds": []}

    version = run([resolved, "--version"])
    help_result = run([resolved, "agent", "start", "--help"])
    kinds: list[str] = []
    marker = "[possible values:"
    help_output = help_result.get("output", "")
    if marker in help_output:
        values = help_output.split(marker, 1)[1].split("]", 1)[0]
        kinds = [value.strip() for value in values.split(",") if value.strip()]

    return {
        "installed": True,
        "active": os.environ.get("HERDR_ENV") == "1",
        "version": version.get("output", "").splitlines()[0]
        if version.get("ok")
        else None,
        "agent_kinds": kinds,
    }


def discover_kitty() -> dict[str, Any]:
    resolved = executable("kitty", "/Applications/kitty.app/Contents/MacOS/kitty")
    if not resolved:
        return {"installed": False}
    version = run([resolved, "--version"])
    return {
        "installed": True,
        "executable": resolved,
        "version": version.get("output", "").splitlines()[0]
        if version.get("ok")
        else None,
    }


def cursor_access_tokens() -> list[str]:
    tokens: list[str] = []
    if platform.system() == "Darwin":
        result = run(
            [
                "security",
                "find-generic-password",
                "-s",
                "cursor-access-token",
                "-a",
                "cursor-user",
                "-w",
            ]
        )
        if result.get("ok"):
            token = (result.get("output") or "").splitlines()
            if token and token[0].strip():
                tokens.append(token[0].strip())
    env = os.environ.get("CURSOR_API_KEY", "").strip()
    if env and env not in tokens:
        tokens.append(env)
    return tokens


def fetch_cursor_period_usage(token: str) -> dict[str, Any] | None:
    curl = shutil.which("curl")
    if not curl:
        return None
    try:
        completed = subprocess.run(
            [
                curl,
                "-sS",
                "-f",
                "-X",
                "POST",
                "https://api2.cursor.sh/aiserver.v1.DashboardService/GetCurrentPeriodUsage",
                "-H",
                f"Authorization: Bearer {token}",
                "-H",
                "Content-Type: application/json",
                "-H",
                "Connect-Protocol-Version: 1",
                "--data",
                "{}",
                "--max-time",
                "8",
            ],
            capture_output=True,
            check=False,
            text=True,
            timeout=10,
        )
    except (OSError, subprocess.TimeoutExpired):
        return None
    if completed.returncode != 0:
        return None
    try:
        payload = json.loads(completed.stdout)
    except json.JSONDecodeError:
        return None
    return payload if isinstance(payload, dict) else None


def summarize_cursor_usage(payload: dict[str, Any]) -> dict[str, Any]:
    plan = payload.get("planUsage")
    plan = plan if isinstance(plan, dict) else {}
    api = plan.get("apiPercentUsed")
    auto = plan.get("autoPercentUsed")
    return {
        "available": True,
        "api_remaining": api < 100 if isinstance(api, (int, float)) else None,
        "auto_remaining": auto < 100 if isinstance(auto, (int, float)) else None,
        "api_percent_used": api,
        "auto_percent_used": auto,
        "display_message": payload.get("namedModelSelectedDisplayMessage")
        or payload.get("displayMessage"),
    }


def discover_cursor_usage() -> dict[str, Any]:
    tokens = cursor_access_tokens()
    if not tokens:
        return {"available": False, "error": "no-token"}
    for token in tokens:
        payload = fetch_cursor_period_usage(token)
        if payload:
            return summarize_cursor_usage(payload)
    return {"available": False, "error": "fetch-failed"}


def collect() -> dict[str, Any]:
    return {
        "environment": {
            "conductor": bool(os.environ.get("CONDUCTOR_WORKSPACE_ID")),
            "herdr": os.environ.get("HERDR_ENV") == "1",
        },
        "agents": discover_agents(),
        "conductor": discover_conductor(),
        "herdr": discover_herdr(),
        "kitty": discover_kitty(),
        "cursor_usage": discover_cursor_usage(),
    }


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Discover Dmnkstack agents and model catalogs"
    )
    parser.add_argument("--pretty", action="store_true")
    args = parser.parse_args()
    indent = 2 if args.pretty else None
    print(json.dumps(collect(), indent=indent, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

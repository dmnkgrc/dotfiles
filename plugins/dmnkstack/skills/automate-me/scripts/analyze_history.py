#!/usr/bin/env python3

import argparse
import json
import re
import statistics
import time
from collections import Counter, defaultdict
from dataclasses import dataclass
from datetime import datetime
from pathlib import Path
from typing import Any, Iterable


SIGNALS = {
    "correction": ["instead", "you did not", "that's not", "that is not", "wrong", "why not", "no need"],
    "continuation": ["continue", "keep going", "finish", "do not stop", "don't stop"],
    "verification": ["test", "check", "verify", "lint", "typecheck", "screenshot", "browser"],
    "investigation": ["investigate", "diagnose", "root cause", "why does", "why is", "explain"],
    "minimality": ["minimal", "simple", "smallest", "reuse", "existing", "remove", "delete", "no abstraction"],
    "git-delivery": ["commit", "push", "pull request", " pr ", "review"],
    "frontend-ui": ["frontend", " ui ", "css", "component", "design", "animation"],
    "agents-skills": ["agent", "model", "skill", "claude", "codex", "cursor", " pi "],
}

INTEGRATIONS = {
    "figma": ["figma"],
    "jam": [" jam ", "jam.dev"],
    "datadog": ["datadog"],
    "linear": ["linear"],
    "notion": ["notion"],
    "braintrust": ["braintrust"],
    "bigquery": ["bigquery", "big query", " bq "],
    "temporal": ["temporal"],
    "browser": ["browser", "chrome", "playwright", "playwriter", "screenshot"],
    "github": ["github", "pull request", " pr "],
    "slack": ["slack"],
    "sentry": ["sentry"],
    "metabase": ["metabase"],
    "lokalise": ["lokalise"],
}

DIRECTIVES = [
    "fix",
    "check",
    "use existing",
    "continue",
    "add",
    "remove",
    "delete",
    "commit",
    "push",
]


@dataclass(frozen=True)
class Prompt:
    source: str
    session: str
    text: str
    timestamp: float


def text_content(value: Any) -> str | None:
    if isinstance(value, str):
        return value
    if isinstance(value, list):
        parts: list[str] = []
        for item in value:
            if isinstance(item, str):
                parts.append(item)
            elif isinstance(item, dict) and isinstance(item.get("text"), str):
                parts.append(item["text"])
        return "\n".join(parts) if parts else None
    if isinstance(value, dict):
        return text_content(value.get("content"))
    return None


def extract_user_text(record: dict[str, Any]) -> str | None:
    role = record.get("role")
    message = record.get("message")
    if role == "user":
        return text_content(message) or text_content(record.get("content"))
    if isinstance(message, dict) and message.get("role") == "user":
        return text_content(message)
    if role in {"assistant", "system", "tool"}:
        return None
    for key in ("text", "display", "prompt", "user_prompt"):
        value = record.get(key)
        if isinstance(value, str):
            return value
    return None


def timestamp(record: dict[str, Any], fallback: float) -> float:
    for key in ("timestamp", "ts", "created_at", "createdAt"):
        value = record.get(key)
        if isinstance(value, (int, float)):
            return value / 1000 if value > 10_000_000_000 else float(value)
        if isinstance(value, str):
            try:
                return datetime.fromisoformat(value.replace("Z", "+00:00")).timestamp()
            except ValueError:
                continue
    return fallback


def clean_text(value: str) -> str:
    value = re.sub(r"</?user_query>", "", value, flags=re.IGNORECASE)
    return value.strip()


def read_jsonl(path: Path, source: str) -> Iterable[Prompt]:
    fallback = path.stat().st_mtime
    try:
        lines = path.open(errors="replace")
    except OSError:
        return
    with lines:
        for line_number, line in enumerate(lines, start=1):
            try:
                record = json.loads(line)
            except json.JSONDecodeError:
                continue
            if not isinstance(record, dict):
                continue
            text = extract_user_text(record)
            if not text:
                continue
            session = str(
                record.get("session_id")
                or record.get("sessionId")
                or record.get("conversation_id")
                or path.stem
                or line_number
            )
            cleaned = clean_text(text)
            if cleaned:
                yield Prompt(source, session, cleaned, timestamp(record, fallback))


def read_json_array(path: Path, source: str) -> Iterable[Prompt]:
    try:
        payload = json.loads(path.read_text())
    except (OSError, json.JSONDecodeError):
        return
    if not isinstance(payload, list):
        return
    fallback = path.stat().st_mtime
    for index, item in enumerate(payload):
        if isinstance(item, str) and item.strip():
            yield Prompt(source, f"history-{index}", item.strip(), fallback)


def source_paths(home: Path) -> dict[str, list[Path]]:
    return {
        "codex": [home / ".codex/history.jsonl"],
        "claude": [home / ".claude/history.jsonl"],
        "pi": sorted((home / ".pi/agent/sessions").glob("**/*.jsonl")),
        "cursor": [
            home / ".cursor/prompt_history.json",
            *sorted((home / ".cursor/projects").glob("*/agent-transcripts/*/*.jsonl")),
        ],
    }


def collect_prompts(home: Path, since_days: int | None) -> tuple[list[Prompt], list[str]]:
    cutoff = time.time() - since_days * 86400 if since_days else None
    prompts: list[Prompt] = []
    missing: list[str] = []
    seen: set[tuple[str, str, str]] = set()
    for source, paths in source_paths(home).items():
        existing = [path for path in paths if path.is_file()]
        if not existing:
            missing.append(source)
            continue
        for path in existing:
            reader = read_json_array(path, source) if path.suffix == ".json" else read_jsonl(path, source)
            for prompt in reader:
                key = (prompt.source, prompt.session, prompt.text)
                if key in seen or cutoff and prompt.timestamp < cutoff:
                    continue
                seen.add(key)
                prompts.append(prompt)
    return prompts, missing


def analyze_pi_runs(home: Path) -> dict[str, Any]:
    path = home / ".pi/agent/run-history.jsonl"
    if not path.is_file():
        return {"available": False}

    statuses: Counter[str] = Counter()
    agents: dict[str, Counter[str]] = defaultdict(Counter)
    total = 0
    try:
        lines = path.open(errors="replace")
    except OSError:
        return {"available": False}
    with lines:
        for line in lines:
            try:
                record = json.loads(line)
            except json.JSONDecodeError:
                continue
            if not isinstance(record, dict):
                continue
            agent = str(record.get("agent") or "unknown")
            status = str(record.get("status") or "unknown")
            total += 1
            statuses[status] += 1
            agents[agent][status] += 1
    return {
        "available": True,
        "runs": total,
        "statuses": dict(statuses),
        "agents": {agent: dict(counts) for agent, counts in sorted(agents.items())},
    }


def redact(value: str, home: Path) -> str:
    value = value.replace(str(home), "~")
    value = re.sub(r"https?://\S+", "[url]", value)
    value = re.sub(r"[\w.+-]+@[\w.-]+\.[A-Za-z]{2,}", "[email]", value)
    value = re.sub(r"\b[0-9a-f]{8}-[0-9a-f-]{27,}\b", "[id]", value, flags=re.IGNORECASE)
    value = re.sub(r"<[^>]+>", " ", value)
    value = " ".join(value.split())
    return value[:237] + "..." if len(value) > 240 else value


def matches(text: str, terms: list[str]) -> bool:
    padded = f" {text.lower()} "
    return any(term in padded for term in terms)


def analyze(prompts: list[Prompt], missing: list[str], home: Path, examples_per_signal: int) -> dict[str, Any]:
    lengths = [len(prompt.text) for prompt in prompts]
    source_counts = Counter(prompt.source for prompt in prompts)
    source_sessions: dict[str, set[str]] = defaultdict(set)
    signal_counts: Counter[str] = Counter()
    signal_sessions: dict[str, set[tuple[str, str]]] = defaultdict(set)
    examples: dict[str, list[str]] = defaultdict(list)
    integration_counts: Counter[str] = Counter()
    integration_sessions: dict[str, set[tuple[str, str]]] = defaultdict(set)
    integration_examples: dict[str, list[str]] = defaultdict(list)
    directive_counts: Counter[str] = Counter()

    for prompt in prompts:
        source_sessions[prompt.source].add(prompt.session)
        for directive in DIRECTIVES:
            if re.search(rf"\b{re.escape(directive)}\b", prompt.text, flags=re.IGNORECASE):
                directive_counts[directive] += 1
        for signal, terms in SIGNALS.items():
            if not matches(prompt.text, terms):
                continue
            signal_counts[signal] += 1
            signal_sessions[signal].add((prompt.source, prompt.session))
            if len(examples[signal]) < examples_per_signal:
                examples[signal].append(redact(prompt.text, home))
        for integration, terms in INTEGRATIONS.items():
            if not matches(prompt.text, terms):
                continue
            integration_counts[integration] += 1
            integration_sessions[integration].add((prompt.source, prompt.session))
            if len(integration_examples[integration]) < examples_per_signal:
                integration_examples[integration].append(redact(prompt.text, home))

    signals = {
        signal: {
            "prompts": signal_counts[signal],
            "sessions": len(signal_sessions[signal]),
            "examples": examples[signal],
        }
        for signal in SIGNALS
    }
    integrations = {
        integration: {
            "prompts": integration_counts[integration],
            "sessions": len(integration_sessions[integration]),
            "examples": integration_examples[integration],
        }
        for integration in INTEGRATIONS
    }
    return {
        "summary": {
            "prompts": len(prompts),
            "sessions": len({(prompt.source, prompt.session) for prompt in prompts}),
            "average_characters": round(statistics.mean(lengths), 1) if lengths else 0,
            "median_characters": statistics.median(lengths) if lengths else 0,
        },
        "sources": {
            source: {
                "prompts": source_counts[source],
                "sessions": len(source_sessions[source]),
            }
            for source in sorted(source_counts)
        },
        "missing_sources": missing,
        "signals": signals,
        "integrations": integrations,
        "directives": dict(directive_counts.most_common()),
    }


def main() -> int:
    parser = argparse.ArgumentParser(description="Analyze local agent history for working-style signals")
    parser.add_argument("--home", type=Path, default=Path.home())
    parser.add_argument("--since-days", type=int)
    parser.add_argument("--examples-per-signal", type=int, default=0)
    parser.add_argument("--pretty", action="store_true")
    args = parser.parse_args()

    if args.examples_per_signal < 0:
        parser.error("--examples-per-signal must be at least 0")
    prompts, missing = collect_prompts(args.home.expanduser(), args.since_days)
    report = analyze(prompts, missing, args.home.expanduser(), args.examples_per_signal)
    report["runtime_health"] = {"pi_subagents": analyze_pi_runs(args.home.expanduser())}
    print(json.dumps(report, indent=2 if args.pretty else None, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

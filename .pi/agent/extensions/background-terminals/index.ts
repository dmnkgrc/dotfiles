import { spawn, type ChildProcess } from "node:child_process";
import {
  createWriteStream,
  existsSync,
  rmSync,
  statSync,
  type WriteStream,
} from "node:fs";
import { mkdtemp } from "node:fs/promises";
import { tmpdir } from "node:os";
import { join, resolve } from "node:path";
import type {
  ExtensionAPI,
  ExtensionContext,
} from "@earendil-works/pi-coding-agent";
import { Type } from "typebox";

const MAX_RUNNING = 8;
const MAX_RECORDS = 64;
const TAIL_CHARACTERS = 64 * 1024;
const FORCE_KILL_DELAY_MS = 2_000;
const WIDGET_KEY = "background-terminals";

type TerminalStatus = "running" | "exited" | "failed" | "killed";

export class TailBuffer {
  readonly maxCharacters: number;
  #value = "";
  #totalCharacters = 0;

  constructor(maxCharacters = TAIL_CHARACTERS) {
    this.maxCharacters = maxCharacters;
  }

  append(chunk: string): void {
    this.#totalCharacters += chunk.length;
    this.#value = `${this.#value}${chunk}`.slice(-this.maxCharacters);
  }

  text(maxLines = 200): string {
    return this.#value.split(/\r?\n/).slice(-maxLines).join("\n").trimEnd();
  }

  get totalCharacters(): number {
    return this.#totalCharacters;
  }
}

interface TerminalRecord {
  id: string;
  title: string;
  command: string;
  cwd: string;
  child: ChildProcess;
  stdout: TailBuffer;
  stderr: TailBuffer;
  stdoutLog: WriteStream;
  stderrLog: WriteStream;
  stdoutPath: string;
  stderrPath: string;
  status: TerminalStatus;
  startedAt: number;
  finishedAt?: number;
  exitCode: number | null;
  signal: NodeJS.Signals | null;
  killRequested: boolean;
  spawnError?: string;
  killTimer?: ReturnType<typeof setTimeout>;
}

interface TerminalSnapshot {
  id: string;
  title: string;
  command: string;
  cwd: string;
  pid: number | undefined;
  status: TerminalStatus;
  elapsedMs: number;
  exitCode: number | null;
  signal: NodeJS.Signals | null;
  stdoutCharacters: number;
  stderrCharacters: number;
  stdoutPath: string;
  stderrPath: string;
}

export const sanitizeTerminalOutput = (text: string): string =>
  text.replace(/\u001b\[[0-?]*[ -/]*[@-~]/g, "").replaceAll("\r", "");

export const formatDuration = (milliseconds: number): string => {
  const seconds = Math.max(0, Math.floor(milliseconds / 1_000));
  if (seconds < 60) return `${seconds}s`;
  const minutes = Math.floor(seconds / 60);
  const remainder = seconds % 60;
  return `${minutes}m${remainder.toString().padStart(2, "0")}s`;
};

const snapshot = (record: TerminalRecord): TerminalSnapshot => ({
  id: record.id,
  title: record.title,
  command: record.command,
  cwd: record.cwd,
  pid: record.child.pid,
  status: record.status,
  elapsedMs: (record.finishedAt ?? Date.now()) - record.startedAt,
  exitCode: record.exitCode,
  signal: record.signal,
  stdoutCharacters: record.stdout.totalCharacters,
  stderrCharacters: record.stderr.totalCharacters,
  stdoutPath: record.stdoutPath,
  stderrPath: record.stderrPath,
});

const describe = (record: TerminalRecord): string => {
  const state =
    record.status === "running"
      ? "running"
      : `${record.status}:${record.exitCode ?? record.signal ?? "?"}`;
  return `${record.id} [${state}] ${record.title} · pid ${record.child.pid ?? "?"} · ${formatDuration((record.finishedAt ?? Date.now()) - record.startedAt)}`;
};

const detail = (record: TerminalRecord): string => {
  const stdout = sanitizeTerminalOutput(record.stdout.text());
  const stderr = sanitizeTerminalOutput(record.stderr.text());
  const sections = [
    describe(record),
    `cwd: ${record.cwd}`,
    `command: ${record.command}`,
    `stdout log: ${record.stdoutPath}`,
    `stderr log: ${record.stderrPath}`,
  ];
  if (stdout) sections.push(`\nstdout:\n${stdout}`);
  if (stderr) sections.push(`\nstderr:\n${stderr}`);
  return sections.join("\n");
};

const completionMessage = (record: TerminalRecord): string => {
  const output = sanitizeTerminalOutput(record.stdout.text(40));
  const errors = sanitizeTerminalOutput(record.stderr.text(20));
  const sections = [`Background terminal settled: ${describe(record)}`];
  if (output) sections.push(`stdout:\n${output}`);
  if (errors) sections.push(`stderr:\n${errors}`);
  return sections.join("\n\n").slice(-12 * 1024);
};

export default function backgroundTerminals(pi: ExtensionAPI): void {
  const records = new Map<string, TerminalRecord>();
  let nextId = 1;
  let currentContext: ExtensionContext | undefined;
  let logDirectory: string | undefined;
  let logDirectoryPromise: Promise<string> | undefined;
  let shuttingDown = false;

  const getLogDirectory = (): Promise<string> => {
    logDirectoryPromise ??= mkdtemp(
      join(tmpdir(), "pi-background-terminals-"),
    ).then((directory) => {
      logDirectory = directory;
      return directory;
    });
    return logDirectoryPromise;
  };

  const runningRecords = (): TerminalRecord[] =>
    [...records.values()].filter((record) => record.status === "running");

  const updateWidget = (): void => {
    const ctx = currentContext;
    if (!ctx?.hasUI) return;
    const running = runningRecords();
    ctx.ui.setWidget(
      WIDGET_KEY,
      running.length === 0
        ? undefined
        : [
            `■ ${running.length} background terminal${running.length === 1 ? "" : "s"} running · /ps to inspect`,
          ],
    );
  };

  const pruneRecords = (): void => {
    if (records.size < MAX_RECORDS) return;
    for (const [id, record] of records) {
      if (record.status === "running") continue;
      records.delete(id);
      if (records.size < MAX_RECORDS) return;
    }
  };

  const finishRecord = (
    record: TerminalRecord,
    code: number | null,
    signal: NodeJS.Signals | null,
  ): void => {
    if (record.status !== "running") return;
    if (record.killTimer) clearTimeout(record.killTimer);
    record.finishedAt = Date.now();
    record.exitCode = code;
    record.signal = signal;
    record.status = record.killRequested
      ? "killed"
      : code === 0
        ? "exited"
        : "failed";
    record.stdoutLog.end();
    record.stderrLog.end();
    updateWidget();

    if (shuttingDown) return;
    pi.sendMessage(
      {
        customType: "background-terminal-result",
        content: completionMessage(record),
        display: true,
        details: snapshot(record),
      },
      { deliverAs: "followUp", triggerTurn: true },
    );
  };

  const startRecord = async (
    command: string,
    title: string,
    cwd: string,
  ): Promise<TerminalRecord> => {
    if (runningRecords().length >= MAX_RUNNING) {
      throw new Error(
        `At most ${MAX_RUNNING} background terminals may run at once.`,
      );
    }
    if (!existsSync(cwd) || !statSync(cwd).isDirectory()) {
      throw new Error(`Working directory does not exist: ${cwd}`);
    }

    pruneRecords();
    const directory = await getLogDirectory();
    const id = `bg-${nextId++}`;
    const stdoutPath = join(directory, `${id}.stdout.log`);
    const stderrPath = join(directory, `${id}.stderr.log`);
    const stdoutLog = createWriteStream(stdoutPath, {
      flags: "a",
      mode: 0o600,
    });
    const stderrLog = createWriteStream(stderrPath, {
      flags: "a",
      mode: 0o600,
    });
    const child = spawn(command, {
      cwd,
      detached: process.platform !== "win32",
      env: process.env,
      shell: true,
      stdio: ["ignore", "pipe", "pipe"],
      windowsHide: true,
    });
    const record: TerminalRecord = {
      id,
      title,
      command,
      cwd,
      child,
      stdout: new TailBuffer(),
      stderr: new TailBuffer(),
      stdoutLog,
      stderrLog,
      stdoutPath,
      stderrPath,
      status: "running",
      startedAt: Date.now(),
      exitCode: null,
      signal: null,
      killRequested: false,
    };

    records.set(id, record);
    child.stdout?.setEncoding("utf8");
    child.stderr?.setEncoding("utf8");
    child.stdout?.on("data", (chunk: string) => {
      record.stdout.append(chunk);
      stdoutLog.write(chunk);
    });
    child.stderr?.on("data", (chunk: string) => {
      record.stderr.append(chunk);
      stderrLog.write(chunk);
    });
    child.once("error", (error) => {
      record.spawnError = error.message;
      record.stderr.append(`${error.message}\n`);
    });
    child.once("close", (code, signal) => finishRecord(record, code, signal));
    updateWidget();
    return record;
  };

  const signalProcessTree = (
    record: TerminalRecord,
    signal: NodeJS.Signals,
  ): void => {
    const pid = record.child.pid;
    if (pid === undefined) {
      record.child.kill(signal);
      return;
    }

    if (process.platform === "win32") {
      spawn("taskkill", ["/PID", String(pid), "/T", "/F"], {
        stdio: "ignore",
        windowsHide: true,
      });
      return;
    }

    try {
      process.kill(-pid, signal);
    } catch {
      record.child.kill(signal);
    }
  };

  const terminate = (record: TerminalRecord): void => {
    if (record.status !== "running" || record.killRequested) return;
    record.killRequested = true;
    signalProcessTree(record, "SIGTERM");
    if (process.platform === "win32") return;
    record.killTimer = setTimeout(() => {
      if (record.status === "running") signalProcessTree(record, "SIGKILL");
    }, FORCE_KILL_DELAY_MS);
    record.killTimer.unref();
  };

  const waitForExit = (record: TerminalRecord): Promise<void> => {
    if (record.status !== "running") return Promise.resolve();
    return new Promise((resolveWait) => {
      const timeout = setTimeout(resolveWait, FORCE_KILL_DELAY_MS + 1_000);
      record.child.once("close", () => {
        clearTimeout(timeout);
        resolveWait();
      });
    });
  };

  pi.on("session_start", (_event, ctx) => {
    currentContext = ctx;
    shuttingDown = false;
    updateWidget();
  });

  pi.on("session_shutdown", async () => {
    shuttingDown = true;
    const running = runningRecords();
    for (const record of running) terminate(record);
    await Promise.all(running.map(waitForExit));
    if (currentContext?.hasUI)
      currentContext.ui.setWidget(WIDGET_KEY, undefined);
    currentContext = undefined;
    if (logDirectory) rmSync(logDirectory, { recursive: true, force: true });
  });

  pi.registerTool({
    name: "bg_start",
    label: "Start Background Terminal",
    description: `Start a non-interactive, session-scoped shell command in the background. At most ${MAX_RUNNING} commands may run at once.`,
    promptSnippet:
      "Run a dev server, watcher, or long build without blocking the main agent",
    promptGuidelines: [
      "Use bg_start for long-running or indefinite non-interactive commands; use bash for quick commands.",
      "After bg_start, continue useful work instead of polling; use bg_status only when current output is needed.",
      "Stop background terminals with bg_kill when they are no longer needed.",
    ],
    parameters: Type.Object({
      command: Type.String({
        description: "Shell command to run with stdin closed",
      }),
      title: Type.String({ description: "Short recognizable label" }),
      working_dir: Type.Optional(
        Type.String({
          description: "Working directory; defaults to the session cwd",
        }),
      ),
    }),
    async execute(_toolCallId, params, _signal, _onUpdate, ctx) {
      const command = params.command.trim();
      if (!command) throw new Error("command must not be empty");
      const title =
        params.title.replace(/\s+/g, " ").trim().slice(0, 80) ||
        "background command";
      const cwd = resolve(ctx.cwd, params.working_dir ?? ".");
      const record = await startRecord(command, title, cwd);
      return {
        content: [
          {
            type: "text",
            text: `Started ${record.id} (${record.title}), pid ${record.child.pid ?? "?"}. Completion will be delivered automatically.`,
          },
        ],
        details: snapshot(record),
      };
    },
  });

  pi.registerTool({
    name: "bg_status",
    label: "Inspect Background Terminal",
    description:
      "Inspect one background terminal and its tail output without blocking.",
    parameters: Type.Object({
      id: Type.String({ description: "Background terminal id" }),
    }),
    async execute(_toolCallId, params) {
      const record = records.get(params.id);
      if (!record) throw new Error(`Unknown background terminal: ${params.id}`);
      return {
        content: [{ type: "text", text: detail(record) }],
        details: snapshot(record),
      };
    },
  });

  pi.registerTool({
    name: "bg_list",
    label: "List Background Terminals",
    description:
      "List running and settled background terminals from this session.",
    parameters: Type.Object({}),
    async execute() {
      const all = [...records.values()];
      return {
        content: [
          {
            type: "text",
            text:
              all.length > 0
                ? all.map(describe).join("\n")
                : "No background terminals.",
          },
        ],
        details: { terminals: all.map(snapshot) },
      };
    },
  });

  pi.registerTool({
    name: "bg_kill",
    label: "Stop Background Terminals",
    description:
      "Stop one or more background terminal process trees with TERM followed by KILL when needed.",
    parameters: Type.Object({
      ids: Type.Array(Type.String(), {
        description: "Background terminal ids",
        minItems: 1,
      }),
    }),
    async execute(_toolCallId, params) {
      const ids = [...new Set(params.ids)];
      const unknown = ids.filter((id) => !records.has(id));
      if (unknown.length > 0)
        throw new Error(
          `Unknown background terminal ids: ${unknown.join(", ")}`,
        );
      const selected = ids
        .map((id) => records.get(id))
        .filter((record) => record !== undefined);
      for (const record of selected) terminate(record);
      return {
        content: [
          {
            type: "text",
            text: `Termination requested for: ${selected.map((record) => record.id).join(", ")}`,
          },
        ],
        details: { terminals: selected.map(snapshot) },
      };
    },
  });

  pi.registerCommand("ps", {
    description: "List, inspect, or stop background terminals",
    handler: async (_args, ctx) => {
      const all = [...records.values()];
      if (all.length === 0) {
        ctx.ui.notify("No background terminals.", "info");
        return;
      }
      if (ctx.mode !== "tui") {
        ctx.ui.notify(all.map(describe).join("\n"), "info");
        return;
      }

      const labels = all.map(describe);
      const choice = await ctx.ui.select("Background terminals", labels);
      if (!choice) return;
      const record = all[labels.indexOf(choice)];
      if (!record) return;
      if (record.status !== "running") {
        ctx.ui.notify(detail(record), "info");
        return;
      }

      const action = await ctx.ui.select(record.title, [
        "Inspect output",
        "Stop process",
      ]);
      if (action === "Inspect output") ctx.ui.notify(detail(record), "info");
      if (action === "Stop process") {
        terminate(record);
        ctx.ui.notify(`Termination requested for ${record.id}.`, "info");
      }
    },
  });
}

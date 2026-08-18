import type {
  ExtensionAPI,
  ExtensionContext,
} from "@earendil-works/pi-coding-agent";

interface PullRequest {
  number: number;
  url: string;
  state: string;
  isDraft: boolean;
}

const REFRESH_INTERVAL_MS = 15_000;

export const parsePullRequest = (text: string): PullRequest | undefined => {
  try {
    const value: unknown = JSON.parse(text);
    if (typeof value !== "object" || value === null) return;
    if (!("number" in value) || typeof value.number !== "number") return;
    if (!("url" in value) || typeof value.url !== "string") return;
    if (!("state" in value) || typeof value.state !== "string") return;
    const isDraft = "isDraft" in value && value.isDraft === true;
    return {
      number: value.number,
      url: value.url,
      state: value.state,
      isDraft,
    };
  } catch {
    return;
  }
};

export const formatPullRequestStatus = (pullRequest: PullRequest): string => {
  const state = pullRequest.isDraft ? "draft" : pullRequest.state.toLowerCase();
  return `PR #${pullRequest.number} · ${state}`;
};

export default function prStatus(pi: ExtensionAPI): void {
  let currentContext: ExtensionContext | undefined;
  let refreshPromise: Promise<void> | undefined;
  let lastRefreshAt = 0;
  let lastPullRequest: PullRequest | undefined;

  const publish = (pullRequest: PullRequest | undefined): void => {
    lastPullRequest = pullRequest;
    if (!currentContext?.hasUI) return;
    currentContext.ui.setStatus(
      "pull-request",
      pullRequest
        ? currentContext.ui.theme.fg(
            "muted",
            formatPullRequestStatus(pullRequest),
          )
        : undefined,
    );
  };

  const performRefresh = async (): Promise<void> => {
    const ctx = currentContext;
    if (!ctx) return;

    const repository = await pi.exec(
      "git",
      ["rev-parse", "--is-inside-work-tree"],
      {
        cwd: ctx.cwd,
        timeout: 3_000,
      },
    );
    if (repository.code !== 0 || repository.stdout.trim() !== "true") {
      publish(undefined);
      return;
    }

    const branch = await pi.exec("git", ["branch", "--show-current"], {
      cwd: ctx.cwd,
      timeout: 3_000,
    });
    if (branch.code !== 0 || branch.stdout.trim().length === 0) {
      publish(undefined);
      return;
    }

    const result = await pi.exec(
      "gh",
      [
        "pr",
        "view",
        branch.stdout.trim(),
        "--json",
        "number,url,state,isDraft",
      ],
      { cwd: ctx.cwd, timeout: 10_000 },
    );
    publish(result.code === 0 ? parsePullRequest(result.stdout) : undefined);
  };

  const refresh = async (force = false): Promise<void> => {
    if (!force && Date.now() - lastRefreshAt < REFRESH_INTERVAL_MS) return;
    if (refreshPromise) return refreshPromise;
    lastRefreshAt = Date.now();
    refreshPromise = performRefresh().finally(() => {
      refreshPromise = undefined;
    });
    return refreshPromise;
  };

  pi.on("session_start", (_event, ctx) => {
    currentContext = ctx;
    lastRefreshAt = 0;
    void refresh(true);
  });

  pi.on("input", (_event, ctx) => {
    currentContext = ctx;
    void refresh();
    return { action: "continue" };
  });

  pi.on("agent_settled", (_event, ctx) => {
    currentContext = ctx;
    void refresh(true);
  });

  pi.on("session_shutdown", () => {
    if (currentContext?.hasUI)
      currentContext.ui.setStatus("pull-request", undefined);
    currentContext = undefined;
    lastPullRequest = undefined;
  });

  pi.registerCommand("pr-status", {
    description: "Refresh the pull request status shown by Zentui",
    handler: async (_args, ctx) => {
      currentContext = ctx;
      await refresh(true);
      ctx.ui.notify(
        lastPullRequest
          ? `${formatPullRequestStatus(lastPullRequest)} · ${lastPullRequest.url}`
          : "No open pull request for the current branch.",
        "info",
      );
    },
  });
}

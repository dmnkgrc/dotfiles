/**
 * Git Interceptor
 *
 * 1. Editor hang prevention — GIT_EDITOR / GIT_SEQUENCE_EDITOR are set to `true`
 *    (a no-op) and GIT_MERGE_AUTOEDIT to `no`, so git never spawns nvim and
 *    hangs the bash tool waiting for an editor that will never be closed.
 *
 * 2. Hook bypass prevention — `--no-verify` is blocked outright. Hook failures
 *    get fixed, not skipped.
 *
 * Ported from github.com/dmmulroy/.dotfiles
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { isToolCallEventType } from "@earendil-works/pi-coding-agent";

const GIT_ENV_PREFIX = "export GIT_EDITOR=true GIT_SEQUENCE_EDITOR=true GIT_MERGE_AUTOEDIT=no\n";

const NO_VERIFY_RE = /--no-verify\b/;

const BLOCK_REASON =
	"BLOCKED: --no-verify is not allowed. Git hooks exist for a reason. " +
	"Do not attempt to bypass them. Instead: fix the underlying issue that " +
	"is causing the hook to fail, or ask the user for help.";

export default function gitInterceptor(pi: ExtensionAPI): void {
	pi.on("tool_call", (event) => {
		if (!isToolCallEventType("bash", event)) return;
		if (!event.input.command.includes("git")) return;

		if (NO_VERIFY_RE.test(event.input.command)) {
			return { block: true, reason: BLOCK_REASON };
		}

		event.input.command = GIT_ENV_PREFIX + event.input.command;
	});
}

import assert from "node:assert/strict";
import { test } from "node:test";
import {
  TailBuffer,
  formatDuration,
  sanitizeTerminalOutput,
} from "../agent/extensions/background-terminals/index.ts";
import { textFromContent } from "../agent/extensions/copy-all.ts";
import { buildContinuationPrompt } from "../agent/extensions/continue-after-compaction.ts";
import {
  isGitInvocation,
  shouldBlockNoVerify,
  wrapGitCommand,
} from "../agent/extensions/git-interceptor.ts";
import {
  formatPullRequestStatus,
  parsePullRequest,
} from "../agent/extensions/pr-status.ts";

test("TailBuffer keeps the newest content and records total size", () => {
  const buffer = new TailBuffer(8);
  buffer.append("first");
  buffer.append("second");
  assert.equal(buffer.text(), "stsecond");
  assert.equal(buffer.totalCharacters, 11);
});

test("terminal formatting is bounded and strips control sequences", () => {
  assert.equal(formatDuration(125_000), "2m05s");
  assert.equal(
    sanitizeTerminalOutput("\u001b[31mfailed\u001b[0m\r\n"),
    "failed\n",
  );
});

test("copy-all extracts text and image placeholders", () => {
  assert.equal(
    textFromContent([
      { type: "text", text: "hello" },
      { type: "image", source: "ignored" },
      { type: "toolCall", name: "ignored" },
    ]),
    "hello\n[image]",
  );
  assert.equal(textFromContent({ type: "text", text: "not an array" }), "");
});

test("git interception targets shell git invocations without matching prose", () => {
  assert.equal(isGitInvocation("git status"), true);
  assert.equal(isGitInvocation("cd repo && git commit"), true);
  assert.equal(isGitInvocation("env FOO=bar /usr/bin/git status"), true);
  assert.equal(isGitInvocation("echo git"), false);
  assert.equal(isGitInvocation("digital workflow"), false);
  assert.equal(shouldBlockNoVerify("git commit --no-verify"), true);
  assert.equal(shouldBlockNoVerify("echo --no-verify"), false);
  const wrapped = wrapGitCommand("git status");
  assert.match(wrapped, /^export GIT_EDITOR=true/);
  assert.equal(wrapGitCommand(wrapped), wrapped);
});

test("compaction continuation includes persisted and ephemeral recovery paths", () => {
  const persisted = buildContinuationPrompt("/tmp/session.jsonl", "entry-1");
  assert.match(persisted, /\/tmp\/session\.jsonl/);
  assert.match(persisted, /parentId links/);
  assert.match(persisted, /entry-1/);
  assert.match(buildContinuationPrompt(undefined, "entry-2"), /ephemeral/);
});

test("pull request status parsing rejects malformed data", () => {
  const pullRequest = parsePullRequest(
    JSON.stringify({
      number: 42,
      url: "https://github.com/example/repo/pull/42",
      state: "OPEN",
      isDraft: true,
    }),
  );
  assert.ok(pullRequest);
  assert.equal(formatPullRequestStatus(pullRequest), "PR #42 · draft");
  assert.equal(parsePullRequest("{}"), undefined);
  assert.equal(parsePullRequest("not json"), undefined);
});

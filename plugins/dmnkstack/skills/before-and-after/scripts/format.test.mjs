import assert from "node:assert/strict";
import { execFileSync, spawnSync } from "node:child_process";
import { mkdtempSync, rmSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { fileURLToPath } from "node:url";
import { test } from "node:test";

test("bundled formatter handles images, previews, video, and PR updates", () => {
  const cwd = mkdtempSync(join(tmpdir(), "dmnkstack-media-"));
  const script = fileURLToPath(new URL("./format.mjs", import.meta.url));
  const run = (...args) => execFileSync(process.execPath, [script, ...args], { cwd, encoding: "utf8" });
  try {
    for (const file of ["before.png", "after.png", "preview.mp4"]) {
      writeFileSync(join(cwd, file), "formatter fixture");
    }
    const images = run("--before", "before.png", "--after", "after.png");
    assert.match(images, /\| Before \| After \|/);
    assert.match(images, /!\[After\]\(\.\/after.png\)/);
    assert.equal(run("--attach-list", "--before", "before.png", "--after", "after.png"), "./before.png\n./after.png\n");
    assert.match(run("--after", "after.png"), /\| Preview \|/);
    assert.match(run("--after", "preview.mp4"), /!\[Preview\]\(\.\/preview.mp4\)/);
    const url = "https://github.com/user-attachments/assets/preview-id";
    const video = run("--after-video-url", url);
    assert.ok(video.includes(`<video src="${url}" width="100%" controls></video>`));
    writeFileSync(join(cwd, "body.md"), `Intro\n\n${images.trim()}\n\nTesting\n`);
    const updated = run("--body-file", "body.md", "--after-video-url", url);
    assert.equal(updated, `Intro\n\n${video.trim()}\n\nTesting\n`);
    assert.ok(!updated.includes("./after.png"));
    const missing = spawnSync(process.execPath, [script, "--after", "missing.png"], { cwd, encoding: "utf8" });
    assert.equal(missing.status, 1);
    assert.match(missing.stderr, /Media file does not exist/);
  } finally {
    rmSync(cwd, { recursive: true, force: true });
  }
});

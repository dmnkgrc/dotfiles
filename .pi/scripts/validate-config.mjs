import { access, readFile } from "node:fs/promises";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const root = dirname(dirname(fileURLToPath(import.meta.url)));
const jsonFiles = [
  "agent/settings.json",
  "agent/mcp.json",
  "agent/keybindings.json",
  "agent/extensions/subagent/config.json",
];

const parsed = new Map();
for (const relativePath of jsonFiles) {
  const text = await readFile(join(root, relativePath), "utf8");
  parsed.set(relativePath, JSON.parse(text));
}

const settings = parsed.get("agent/settings.json");
if (typeof settings !== "object" || settings === null) {
  throw new Error("agent/settings.json must contain an object");
}

if (!("packages" in settings) || !Array.isArray(settings.packages)) {
  throw new Error("agent/settings.json packages must be an array");
}

const floatingPackages = settings.packages.filter(
  (source) =>
    typeof source === "string" &&
    source.startsWith("npm:") &&
    !/^npm:.+@\d/.test(source),
);
if (floatingPackages.length > 0) {
  throw new Error(`Unpinned npm packages: ${floatingPackages.join(", ")}`);
}

const expectedResources = [
  "agent/extensions/background-terminals/index.ts",
  "agent/extensions/copy-all.ts",
  "agent/extensions/pr-status.ts",
  "agent/extensions/continue-after-compaction.ts",
  "agent/extensions/git-interceptor.ts",
  "agent/prompts/recap.md",
];
await Promise.all(
  expectedResources.map((relativePath) => access(join(root, relativePath))),
);

console.log(
  `Validated ${jsonFiles.length} JSON files, package pins, and ${expectedResources.length} resources.`,
);

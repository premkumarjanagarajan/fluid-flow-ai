/**
 * Quick local test for the addon system.
 * Run with: node dist/test-addons.js
 */

import { discoverAddons } from "./modules/addon-discovery.js";
import { installAllAddonRules, loadAllAddonMcpServers } from "./modules/addon-installer.js";
import { promptMultiSelect } from "./ui/menu.js";
import path from "node:path";
import os from "node:os";
import fs from "node:fs";

const CLONE_PATH = "C:\\src\\fluid-flow-ai";
const TEST_TARGET = path.join(os.tmpdir(), "ff-addon-test");

async function main() {
  console.log(`\n  Discovering addons from: ${CLONE_PATH}\n`);

  const addons = discoverAddons(CLONE_PATH);

  if (addons.length === 0) {
    console.log("  No addons found. Make sure addons/ directory exists.\n");
    return;
  }

  console.log(`  Found ${addons.length} addon(s):\n`);
  addons.forEach((a) => {
    console.log(`    - ${a.manifest.id}: ${a.manifest.name} — ${a.manifest.description}`);
  });

  // Show the multi-select picker
  const menuItems = addons.map((a) => ({
    key: a.manifest.id,
    label: a.manifest.name,
    description: a.manifest.description,
  }));

  console.log("");
  const selected = await promptMultiSelect(menuItems, {
    title: "Available Addons",
    prompt: "Select addons to install (comma-separated, 'all', or Enter to skip)",
  });

  if (selected.length === 0) {
    console.log("\n  No addons selected.\n");
    return;
  }

  // Clean up and create test target
  if (fs.existsSync(TEST_TARGET)) {
    fs.rmSync(TEST_TARGET, { recursive: true });
  }
  fs.mkdirSync(TEST_TARGET, { recursive: true });

  console.log(`\n  Installing to: ${TEST_TARGET}\n`);

  const selectedAddons = addons.filter((a) =>
    selected.some((s) => s.key === a.manifest.id)
  );

  const results = await installAllAddonRules(selectedAddons, TEST_TARGET);

  console.log("\n  Results:");
  for (const r of results) {
    console.log(`    ${r.addonName}: ${r.filesCopied} files`);
    r.installedPaths.forEach((p) => console.log(`      → ${p}`));
  }

  // Show MCP servers if any
  const mcpServers = loadAllAddonMcpServers(selectedAddons);
  if (Object.keys(mcpServers).length > 0) {
    console.log("\n  MCP Servers:", JSON.stringify(mcpServers, null, 2));
  }

  console.log(`\n  Check output at: ${TEST_TARGET}\n`);
}

main().catch(console.error);

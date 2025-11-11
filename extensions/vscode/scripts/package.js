const { exec } = require("child_process");
const fs = require("fs");

const version = JSON.parse(
  fs.readFileSync("./package.json", { encoding: "utf-8" }),
).version;

const args = process.argv.slice(2);
let target;

if (args[0] === "--target") {
  target = args[1];
}

if (!fs.existsSync("build")) {
  fs.mkdirSync("build");
}

const isPreRelease = args.includes("--pre-release");

// Command Injection Protection: Validate target parameter
const validateTarget = (target) => {
  if (!target) return null;

  // Only allow alphanumeric, dash, and underscore characters
  // Typical target format: "win32-x64", "darwin-arm64", "linux-x64"
  if (!/^[a-z0-9_-]+-[a-z0-9_-]+$/i.test(target)) {
    throw new Error(
      `Invalid target format: ${target}. Expected format: platform-arch (e.g., win32-x64)`,
    );
  }

  return target;
};

let command = isPreRelease
  ? "npx @vscode/vsce package --out ./build --pre-release --no-dependencies" // --yarn"
  : "npx @vscode/vsce package --out ./build --no-dependencies"; // --yarn";

if (target) {
  const validatedTarget = validateTarget(target);
  if (validatedTarget) {
    command += ` --target ${validatedTarget}`;
  }
}

exec(command, (error) => {
  if (error) {
    throw error;
  }
  console.log(
    `vsce package completed - extension created at extensions/vscode/build/continue-${version}.vsix`,
  );
});

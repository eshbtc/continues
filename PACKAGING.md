# Packaging & Installation Guide

**How to package Continue (with GodCode enhancements) for testing in other repositories**

**Two Interfaces**: VS Code Extension + CLI (test both simultaneously!)

---

## 🚀 **Quick Start: Package Both**

```bash
# 1. Build everything
cd /Users/agentsy/god-continues
npm run build

# 2. Package VS Code extension
cd extensions/vscode
vsce package
# Creates: continue-1.3.26.vsix

# 3. Package CLI
cd ../cli
npm run build
npm pack
# Creates: continuedev-cli-0.0.0-dev.tgz

# 4. Install both
code --install-extension extensions/vscode/continue-1.3.26.vsix
npm install -g extensions/cli/continuedev-cli-0.0.0-dev.tgz

# 5. Test both interfaces
# VS Code: Open any project, press Cmd+L
# CLI: cn chat "explain this code"
```

---

## 🎯 **Which Interface to Use?**

### **VS Code Extension** (GUI)

- ✅ Visual chat interface
- ✅ Inline code editing
- ✅ Integrated with editor
- ✅ Best for: Interactive development

### **CLI** (Terminal)

- ✅ Terminal-based interface (TUI)
- ✅ Script automation
- ✅ SSH/remote development
- ✅ Best for: Command-line workflows, automation

### **Use Both!**

They share the same core, so improvements benefit both interfaces.

---

## 📦 **Detailed Packaging Process**

### **Step 1: Update Version Number**

First, update the version to differentiate from upstream Continue:

```bash
cd /Users/agentsy/god-continues/extensions/vscode

# Update package.json version (example: 1.3.26 → 1.3.26-godcode.1)
sed -i '' 's/"version": "1.3.26"/"version": "1.3.26-godcode.1"/' package.json

# Optional: Update display name to distinguish
sed -i '' 's/"displayName": "Continue - open-source AI code agent"/"displayName": "Continue + GodCode (Development)"/' package.json
```

### **Step 2: Install Dependencies**

```bash
# Root dependencies
cd /Users/agentsy/god-continues
npm install

# Extension dependencies
cd extensions/vscode
npm install

# GUI dependencies (if building GUI)
cd ../../gui
npm install
```

### **Step 3: Build the Extension**

```bash
cd /Users/agentsy/god-continues

# Build core
npm run build

# Build extension
cd extensions/vscode
npm run build

# Or use the combined command from root
cd ../..
npm run build:vscode
```

### **Step 4a: Package VS Code Extension as .vsix**

```bash
cd /Users/agentsy/god-continues/extensions/vscode

# Package extension
vsce package

# This creates: continue-1.3.26-godcode.1.vsix
# File size: ~10-20MB
```

### **Step 4b: Package CLI as .tgz**

```bash
cd /Users/agentsy/god-continues/extensions/cli

# Update version (match VS Code version)
npm version 1.3.26-godcode.1 --no-git-tag-version

# Build CLI
npm run build

# Package as tarball
npm pack

# This creates: continuedev-cli-1.3.26-godcode.1.tgz
# File size: ~15-25MB
```

---

## 💾 **Installation Methods**

### **Method 1: Command Line Installation** (Recommended)

```bash
# Install in VS Code
code --install-extension continue-1.3.26-godcode.1.vsix

# Install in VS Code Insiders
code-insiders --install-extension continue-1.3.26-godcode.1.vsix

# Force reinstall (if already installed)
code --install-extension continue-1.3.26-godcode.1.vsix --force
```

### **Method 2: VS Code UI Installation**

1. Open VS Code
2. Press `Cmd+Shift+P` (Mac) or `Ctrl+Shift+P` (Windows/Linux)
3. Type: "Extensions: Install from VSIX"
4. Select your `.vsix` file
5. Reload window when prompted

### **Method 3: Manual Installation**

```bash
# Copy to VS Code extensions directory
# Mac/Linux:
cp continue-1.3.26-godcode.1.vsix ~/.vscode/extensions/
cd ~/.vscode/extensions/
unzip continue-1.3.26-godcode.1.vsix

# Windows:
# %USERPROFILE%\.vscode\extensions\
```

---

## 🖥️ **CLI Installation Methods**

### **Method 1: Global Installation** (Recommended)

```bash
# Install globally
npm install -g continuedev-cli-1.3.26-godcode.1.tgz

# Or with absolute path
npm install -g /Users/agentsy/god-continues/extensions/cli/continuedev-cli-1.3.26-godcode.1.tgz

# Verify installation
cn --version
which cn

# Test it
cn chat "hello world"
```

### **Method 2: Local Installation** (Per-project)

```bash
# In your project
cd ~/my-project
npm install /Users/agentsy/god-continues/extensions/cli/continuedev-cli-1.3.26-godcode.1.tgz

# Run with npx
npx cn chat "explain this code"

# Or add to package.json scripts
{
  "scripts": {
    "ai": "cn chat"
  }
}
```

### **Method 3: Symlink for Development**

```bash
# Faster iteration during development
cd /Users/agentsy/god-continues/extensions/cli

# Create global symlink
npm link

# Now 'cn' command uses your dev version
cn --version

# To unlink
npm unlink -g @continuedev/cli
```

---

## 🧪 **Testing in Different Repositories**

### **Test Setup**

```bash
# 1. Install both interfaces (see above)

# 2. Open any repository
code ~/my-test-project
cd ~/my-test-project

# 3. Configure Continue (shared config for both!)
# First run of either interface will create ~/.continue/config.json
# Both VS Code and CLI use the same config

# 4. Test VS Code Extension
# - Chat with AI (Cmd+L)
# - Edit code (Cmd+I)
# - Use multi-agent mode (if implemented)

# 5. Test CLI
cn chat "what does this code do?"
cn chat "add type hints to main.py"
cn --help
```

### **Test Different Project Types**

```bash
# Python project
cd ~/test-python-project
code .

# TypeScript project
cd ~/test-typescript-project
code .

# Go project
cd ~/test-go-project
code .

# Multi-language monorepo
cd ~/test-monorepo
code .
```

---

## 🔄 **Development Workflow**

### **For Active Development**

Instead of packaging every time, run in development mode:

```bash
# Terminal 1: Watch mode for core
cd /Users/agentsy/god-continues/core
npm run build:watch

# Terminal 2: Watch mode for extension
cd /Users/agentsy/god-continues/extensions/vscode
npm run esbuild-watch

# Terminal 3: Run extension in VS Code
# Press F5 in VS Code with extensions/vscode open
# This launches Extension Development Host
```

### **Hot Reload Setup**

1. Open `/Users/agentsy/god-continues` in VS Code
2. Go to Run & Debug panel (Cmd+Shift+D)
3. Select "Launch Extension"
4. Press F5
5. This opens a new VS Code window with your extension loaded
6. Changes auto-reload when you save files

---

## 📤 **Distribution Options**

### **Option 1: Direct File Sharing**

```bash
# Package the extension
cd /Users/agentsy/god-continues/extensions/vscode
vsce package

# Share the .vsix file
# - Upload to GitHub Releases
# - Share via Dropbox/Google Drive
# - Email directly
# - Host on internal server

# Users install with:
code --install-extension continue-1.3.26-godcode.1.vsix
```

### **Option 2: GitHub Releases**

```bash
# Create a release
cd /Users/agentsy/god-continues

# Tag version
git tag v1.3.26-godcode.1
git push origin v1.3.26-godcode.1

# Go to GitHub → Releases → Create Release
# Upload continue-1.3.26-godcode.1.vsix as asset

# Users install with:
wget https://github.com/eshbtc/continues/releases/download/v1.3.26-godcode.1/continue-1.3.26-godcode.1.vsix
code --install-extension continue-1.3.26-godcode.1.vsix
```

### **Option 3: Private Extension Marketplace**

For enterprise distribution:

```bash
# Option A: Open VSX Registry (open-source alternative)
npx ovsx publish continue-1.3.26-godcode.1.vsix -p YOUR_TOKEN

# Option B: Self-hosted extension gallery
# Use: https://github.com/eclipse/openvsx

# Option C: Internal NPM registry
# Package as npm module, users install via settings.json
```

### **Option 4: Fork & Publish to Marketplace** (Public Release)

```bash
# 1. Update publisher in package.json
cd extensions/vscode
# Edit package.json: "publisher": "YourName"

# 2. Get publisher token
# Go to: https://dev.azure.com/
# Create Personal Access Token with Marketplace permissions

# 3. Publish
vsce login YourName
vsce publish

# Users install from marketplace:
# Search "Continue GodCode" in VS Code extensions
```

---

## 🔧 **Packaging Script** (Recommended)

Create a convenience script that packages BOTH:

```bash
cat > /Users/agentsy/god-continues/package-all.sh << 'EOF'
#!/bin/bash
set -e

echo "🏗️  Building Continue + GodCode (VS Code + CLI)..."

# Build core first (shared by both)
echo "📦 Building core..."
cd core
npm install
npm run build
cd ..

# Build and package VS Code extension
echo "📦 Building VS Code extension..."
cd extensions/vscode
npm install
npm run build
echo "📦 Packaging .vsix..."
vsce package
mv *.vsix ../../
cd ../..

# Build and package CLI
echo "📦 Building CLI..."
cd extensions/cli
npm install
npm run build
echo "📦 Packaging .tgz..."
npm pack
mv *.tgz ../../
cd ../..

echo ""
echo "✅ Packages created:"
ls -1 *.vsix *.tgz
echo ""
echo "📥 Install VS Code Extension:"
echo "   code --install-extension $(ls -1 *.vsix)"
echo ""
echo "📥 Install CLI:"
echo "   npm install -g $(ls -1 *.tgz)"
echo ""
echo "🧪 Test both:"
echo "   VS Code: Open project, press Cmd+L"
echo "   CLI: cn chat 'hello world'"
EOF

chmod +x package-all.sh
```

Usage:

```bash
cd /Users/agentsy/god-continues
./package-all.sh
```

---

## 🧹 **Clean Build** (If Issues)

```bash
cd /Users/agentsy/god-continues

# Clean all build artifacts
rm -rf node_modules
rm -rf core/node_modules
rm -rf extensions/vscode/node_modules
rm -rf gui/node_modules
rm -rf */*/node_modules
rm -rf core/build
rm -rf extensions/vscode/out
rm -rf *.vsix

# Fresh install
npm install
cd core && npm install && npm run build && cd ..
cd extensions/vscode && npm install && npm run build && cd ../..

# Package
cd extensions/vscode
vsce package
```

---

## 🐛 **Troubleshooting**

### **Issue: "Command 'vsce' not found"**

```bash
npm install -g @vscode/vsce
```

### **Issue: "Cannot find module 'esbuild'"**

```bash
cd extensions/vscode
rm -rf node_modules package-lock.json
npm install
```

### **Issue: "Build fails with TypeScript errors"**

```bash
# Check TypeScript version
npm ls typescript

# Update TypeScript
npm install --save-dev typescript@latest

# Or use workspace TypeScript
# VS Code: Cmd+Shift+P → "TypeScript: Select TypeScript Version" → "Use Workspace Version"
```

### **Issue: "Extension installed but not showing up"**

```bash
# Check if installed
code --list-extensions | grep continue

# Uninstall old version
code --uninstall-extension Continue.continue

# Reinstall
code --install-extension continue-1.3.26-godcode.1.vsix --force

# Reload VS Code
# Cmd+Shift+P → "Developer: Reload Window"
```

### **Issue: "Extension activates but crashes"**

```bash
# Check logs
# Cmd+Shift+P → "Developer: Show Logs" → Select "Extension Host"

# Check console
# Cmd+Shift+P → "Developer: Toggle Developer Tools"
# Look for errors in Console tab
```

### **Issue: "Cannot package - missing dependencies"**

```bash
# Install all dependencies including devDependencies
cd /Users/agentsy/god-continues/extensions/vscode
npm install --include=dev

# If still issues, check for peer dependencies
npm ls
```

---

## 📊 **Version Management Strategy**

### **For Daily Sprints**

```bash
# Increment patch version daily
# Day 1: 1.3.26-godcode.1
# Day 2: 1.3.26-godcode.2
# Day 3: 1.3.26-godcode.3

# Update version:
cd extensions/vscode
npm version patch --preid=godcode
```

### **For Sprint Releases**

```bash
# Week 1 (Sprint 1): 1.3.26-sprint1
# Week 2 (Sprint 2): 1.3.26-sprint2

# Update version:
npm version prerelease --preid=sprint1
```

### **For Stable Releases**

```bash
# After testing: 1.4.0-godcode
# Full integration: 2.0.0-godcode

# Update version:
npm version minor  # or major
```

---

## 🔒 **Security Considerations**

### **Before Distributing**

1. **Remove sensitive data**:

   ```bash
   # Check for API keys, tokens
   grep -r "sk-" extensions/vscode/
   grep -r "api.key" extensions/vscode/
   ```

2. **Verify dependencies**:

   ```bash
   npm audit
   npm audit fix
   ```

3. **Code signing** (optional but recommended):

   ```bash
   # macOS code signing
   codesign --sign "Developer ID" continue-1.3.26-godcode.1.vsix
   ```

4. **License verification**:
   ```bash
   # Ensure Apache 2.0 license is included
   cat LICENSE
   ```

---

## 📈 **Monitoring & Telemetry**

### **Track Usage** (Optional)

Add telemetry to understand usage:

```typescript
// core/telemetry/tracker.ts
export class UsageTracker {
  trackFeatureUsage(feature: string) {
    // Log to your analytics
    console.log(`Feature used: ${feature}`);
  }

  trackError(error: Error) {
    // Track errors for improvement
    console.error("Extension error:", error);
  }
}
```

### **User Feedback**

Add feedback mechanism:

```typescript
// In UI
<button onClick={() => openFeedbackForm()}>
  Send Feedback
</button>
```

---

## ✅ **Testing Checklist**

Before distributing, test:

- [ ] Extension installs without errors
- [ ] Extension activates in VS Code
- [ ] Basic chat functionality works
- [ ] Code editing works (Cmd+I)
- [ ] Configuration loads properly
- [ ] No console errors on startup
- [ ] Works in different project types (Python, TS, Go)
- [ ] Works with different VS Code versions
- [ ] Uninstall/reinstall works cleanly
- [ ] No conflicts with other extensions

---

## 🎯 **CLI Commands Reference**

### **Basic Commands**

```bash
# Interactive chat
cn chat "explain this code"
cn chat "add error handling to main.py"

# With specific file context
cn chat @README.md "summarize this"
cn chat @src/index.ts "add type annotations"

# View help
cn --help
cn chat --help

# Check version
cn --version

# View configuration
cn config

# Login (for Continue Pro features)
cn login
cn logout
```

### **Advanced CLI Features**

```bash
# Headless mode (non-interactive)
cn chat --headless "what is this code doing?" < input.txt

# Use specific model
cn chat --model claude-3-5-sonnet-20241022 "explain this"

# Resume previous session
cn chat --resume

# Use different config
cn chat --config ~/.continue/alt-config.json

# Enable debug mode
cn chat --debug "test query"

# List available models
cn models

# List MCP servers
cn mcp list
```

### **Scripting Examples**

```bash
# Batch process files
for file in src/*.py; do
  cn chat "Add docstrings to $file" > "${file}.docs"
done

# CI/CD integration
cn chat --headless "Check for security issues" < src/main.py
if [ $? -ne 0 ]; then
  echo "Security check failed"
  exit 1
fi

# Generate documentation
find src -name "*.ts" | xargs -I {} cn chat "Document {}"

# Code review automation
cn chat --headless "Review this PR for issues" < diff.patch
```

---

## 🚀 **Quick Reference**

### **VS Code Extension**

```bash
# Build & Package
cd /Users/agentsy/god-continues
npm run build && cd extensions/vscode && vsce package

# Install
code --install-extension continue-*.vsix

# Uninstall
code --uninstall-extension Continue.continue

# List installed
code --list-extensions | grep continue

# Development mode
# Press F5 in VS Code with extensions/vscode open
```

### **CLI**

```bash
# Build & Package
cd /Users/agentsy/god-continues
npm run build && cd extensions/cli && npm pack

# Install
npm install -g continuedev-cli-*.tgz

# Uninstall
npm uninstall -g @continuedev/cli

# Check installation
which cn
cn --version

# Development mode (with auto-reload)
cd extensions/cli
npm run dev
# Or use npm link for global symlink
npm link
```

### **Both (Clean Build)**

```bash
# Clean everything
cd /Users/agentsy/god-continues
rm -rf node_modules */node_modules */*/node_modules
rm -rf core/build extensions/vscode/out extensions/cli/dist
rm -rf *.vsix *.tgz

# Fresh install & build
npm install
cd core && npm install && npm run build && cd ..
cd extensions/vscode && npm install && npm run build && vsce package && cd ../..
cd extensions/cli && npm install && npm run build && npm pack && cd ../..

# Or use the convenience script
./package-all.sh
```

---

## 📚 **Additional Resources**

- [VS Code Extension Publishing](https://code.visualstudio.com/api/working-with-extensions/publishing-extension)
- [vsce CLI Reference](https://github.com/microsoft/vscode-vsce)
- [Extension Manifest](https://code.visualstudio.com/api/references/extension-manifest)
- [Extension Development Guide](https://code.visualstudio.com/api/get-started/your-first-extension)

---

## 🎯 **Next Steps**

1. **Build the first sprint** (Sprint 0.1: Basic Cost Display)
2. **Package as .vsix**
3. **Install and test** in a sample repository
4. **Get feedback** from team/users
5. **Iterate** with Sprint 0.2

**Ready to ship daily improvements! 🚀**

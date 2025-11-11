# Install GodCode v0.1.0 - Complete Guide

## 🎉 What's New

**Version 0.1.0** - First official GodCode release

- ✅ All view IDs updated to `godcode.*` prefix
- ✅ All command IDs updated to `godcode.*` prefix
- ✅ No more conflicts with Continue extension
- ✅ Security hardening (11+ vulnerabilities fixed)
- ✅ Package name: `godcode`
- ✅ Publisher: `GodCode`

## 📦 Package Details

- **File:** `godcode-0.1.0.vsix` (151MB)
- **Location:** `/Users/agentsy/god-continues/extensions/vscode/build/godcode-0.1.0.vsix`
- **Created:** Nov 10, 2025 22:17 (latest)
- **Build:** c4707c3c1

## 🚀 Installation Steps

### Step 1: Uninstall Any Previous Version

```bash
# Uninstall old Continue or GodCode extensions
code --uninstall-extension Continue.continue
code --uninstall-extension GodCode.godcode
```

### Step 2: Close VS Code Completely

```bash
# Kill all VS Code processes
killall "Visual Studio Code" 2>/dev/null || killall "Code" 2>/dev/null
```

### Step 3: Clear Extension Cache (Recommended)

```bash
# Remove old extension data
rm -rf ~/Library/Application\ Support/Code/User/globalStorage/Continue.continue
rm -rf ~/Library/Application\ Support/Code/User/globalStorage/GodCode.godcode
```

### Step 4: Install GodCode v0.1.0

```bash
code --install-extension /Users/agentsy/god-continues/extensions/vscode/build/godcode-0.1.0.vsix
```

### Step 5: Start VS Code

Open VS Code and look for the GodCode icon in the left activity bar.

## ✅ Verify Installation

Run the verification script:

```bash
/Users/agentsy/god-continues/verify-extension.sh
```

Or manually check:

```bash
code --list-extensions | grep godcode
# Should output: godcode.godcode
```

## 🔧 Configuration

Your existing config at `~/.continue/config.yaml` will work with GodCode. You already have:

```yaml
name: Local Config
version: 1.0.0
schema: v1
models:
  - name: Grok 4 Fast Reasoning
    provider: xAI
    model: grok-4-fast-reasoning
    apiKey: [your-key]
```

## ⌨️ Keyboard Shortcuts

All shortcuts now use `godcode.*` commands:

- `Cmd+L` - Focus chat (add code to context)
- `Cmd+Shift+L` - Add to chat without clearing
- `Cmd+I` - Edit code with natural language
- `Cmd+Shift+R` - Debug terminal

## 🐛 Troubleshooting

### If You See "Command already registered"

This means the old Continue extension is still active:

```bash
# List all extensions
code --list-extensions

# If you see Continue.continue, uninstall it
code --uninstall-extension Continue.continue

# Reload VS Code
code --reload-window
```

### If You See a Blank Page

1. Open Developer Tools: `Cmd+Shift+P` → "Developer: Toggle Developer Tools"
2. Check Console for errors
3. Try bypassing onboarding (paste in Console):

```javascript
localStorage.setItem("onboardingStatus", "Completed");
localStorage.setItem("hasDismissedOnboardingCard", true);
location.reload();
```

### If Extension Doesn't Appear

```bash
# Check if installed
code --list-extensions | grep godcode

# If not installed, try installing with --force
code --install-extension /Users/agentsy/god-continues/extensions/vscode/build/godcode-0.1.0.vsix --force
```

## 📋 What's Included

**Core Features:**

- ✅ Chat interface with LLM models
- ✅ Code editing with natural language
- ✅ Codebase indexing (LanceDB + SQLite)
- ✅ Tab autocomplete
- ✅ Terminal debugging
- ✅ Context providers

**Binaries Included:**

- ✅ LanceDB vectordb (81.58MB)
- ✅ SQLite3 native module
- ✅ ONNX Runtime for embeddings
- ✅ Tree-sitter WASM

## 📝 Changes from Continue

1. **Package name:** `continue` → `godcode`
2. **Publisher:** `Continue` → `GodCode`
3. **View IDs:**
   - `continue.continueGUIView` → `godcode.continueGUIView`
   - `continue.continueConsoleView` → `godcode.continueConsoleView`
4. **Commands:** All `continue.*` → `godcode.*` (70+ commands)
5. **Version:** `1.3.26` → `0.1.0`
6. **Security:** 11 vulnerabilities fixed

## 🔐 Security Improvements

Fixed issues:

- ✅ ReDoS protection
- ✅ SSRF protection
- ✅ XSS sanitization
- ✅ SQL injection prevention
- ✅ Command injection protection
- ✅ Path traversal protection
- ✅ Prototype pollution mitigation
- ✅ Dependency updates (axios, vite, tar-fs, etc.)

## 🎯 Next Steps

After installation:

1. **Test the extension** - Click the GodCode icon in the activity bar
2. **Try a chat** - Press `Cmd+L` to focus chat
3. **Check your model** - Verify Grok model is configured
4. **Review docs** - See `bypass-onboarding.md` for troubleshooting

## 📚 Documentation

- `REINSTALL_EXTENSION.md` - Detailed reinstallation guide
- `bypass-onboarding.md` - Onboarding troubleshooting
- `SECURITY_STATUS.md` - Security audit status
- `MICRO_SPRINT_PLAN.md` - Feature roadmap

## 🌟 Features Coming Soon

Based on the GodCode integration plan:

- **Sprint 0.1:** PostgreSQL + AgenticMemory integration
- **Sprint 0.2:** Model Registry (80+ models)
- **Sprint 0.3:** Cost Tracking system
- **Sprint 0.4:** Smart Presets
- And 33 more sprints over 8 weeks...

## 💬 Support

If you encounter any issues:

1. Check the Console for errors (`Cmd+Shift+P` → "Developer: Toggle Developer Tools")
2. Review logs: `~/.continue/logs/`
3. Check configuration: `~/.continue/config.yaml`

---

**Happy coding with GodCode! 🚀**

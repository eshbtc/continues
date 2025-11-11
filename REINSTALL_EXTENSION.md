# Reinstall GodCode Extension - Fix View ID Conflict

## Issue Fixed

The extension was using view IDs that conflicted with the original Continue extension:

- ✅ Changed `continue.continueGUIView` → `godcode.continueGUIView`
- ✅ Changed `continue.continueConsoleView` → `godcode.continueConsoleView`

## Quick Reinstall Instructions

### Step 1: Uninstall Old Extension

```bash
code --uninstall-extension GodCode.godcode
```

Or uninstall via VS Code UI:

1. Open Extensions panel (`Cmd+Shift+X`)
2. Search for "godcode"
3. Click "Uninstall"

### Step 2: Close VS Code Completely

```bash
# Make sure all VS Code windows are closed
killall "Visual Studio Code" 2>/dev/null || killall "Code" 2>/dev/null
```

### Step 3: Install New Version

```bash
code --install-extension /Users/agentsy/god-continues/extensions/vscode/build/godcode-1.3.26.vsix
```

### Step 4: Restart VS Code

Open VS Code and the GodCode icon should appear in the activity bar (left sidebar).

## Verify Installation

Run the verification script:

```bash
/Users/agentsy/god-continues/verify-extension.sh
```

## What Changed

**package.json:**

- Console view ID: `continue.continueConsoleView` → `godcode.continueConsoleView`

**TypeScript files:**

- `ContinueConsoleWebviewViewProvider.ts`: Updated viewType constant
- `ContinueGUIWebviewViewProvider.ts`: Already had correct ID
- `VsCodeExtension.ts`: Now uses constants instead of hardcoded strings

## If You Still See the Error

1. **Check for Continue extension:**

   ```bash
   code --list-extensions | grep -i continue
   ```

   If you see `Continue.continue`, uninstall it:

   ```bash
   code --uninstall-extension Continue.continue
   ```

2. **Clear extension cache:**

   ```bash
   rm -rf ~/Library/Application\ Support/Code/User/globalStorage/GodCode.godcode
   rm -rf ~/Library/Application\ Support/Code/User/globalStorage/Continue.continue
   ```

3. **Check for running instances:**
   ```bash
   ps aux | grep -i "visual studio code" | grep -v grep
   ```

## Expected Result

After reinstalling, you should see:

- GodCode icon in activity bar
- No "view already registered" errors
- Extension loads without blank page
- Chat interface is visible

## Package Details

- **File:** `godcode-1.3.26.vsix` (151MB)
- **Created:** Nov 10, 2025 21:56
- **View IDs:** All use `godcode.` prefix
- **All binaries included:** ✓ LanceDB (81.58MB), SQLite, ONNX Runtime

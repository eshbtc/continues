# Debug GodCode Webview Loading Error

## 🔴 Current Issue

The extension activates successfully but the webview shows:

```
An error occurred while loading view: godcode.continueGUIView
```

## ✅ What's Working

- Extension installs correctly ✓
- No duplicate command/view registration errors ✓
- UI titles show "GODCODE" correctly ✓
- Extension activates on startup ✓
- View IDs are correct: `godcode.continueGUIView`, `godcode.continueConsoleView` ✓

## 🐛 What's NOT Working

- Webview HTML/JS fails to render
- Shows generic "error occurred while loading view" message

## 📋 **Critical: Get the Actual Error Message**

The generic error message doesn't tell us what's wrong. You MUST check the Console:

### Step 1: Open Developer Tools Console

1. With VS Code open and GodCode panel showing the error
2. Press `Cmd+Shift+P` → type "Developer: Toggle Developer Tools"
3. Click the **Console** tab at the top
4. Look for RED error messages

### Step 2: Look for These Specific Errors

**Common errors to look for:**

1. **Failed to load resource**

   ```
   GET vscode-webview://... net::ERR_FILE_NOT_FOUND
   ```

   This means GUI files aren't accessible

2. **Cannot read property of undefined**

   ```
   TypeError: Cannot read property 'X' of undefined
   ```

   This means React failed to initialize

3. **Module not found**

   ```
   Error: Cannot find module 'X'
   ```

   This means a dependency is missing

4. **CSP violation**

   ```
   Refused to load... because it violates the Content Security Policy
   ```

   This means script security is blocking resources

5. **Webview was disposed**
   ```
   Error: Webview is disposed
   ```
   This means the view closed unexpectedly

### Step 3: Check Network Tab (optional)

In Developer Tools:

1. Click **Network** tab
2. Reload the GodCode panel
3. Look for failed requests (red status codes)
4. Check if `index.js` and `index.css` loaded

## 🔧 **Temporary Workarounds to Try**

### Option 1: Clear All Extension Data

```bash
# Close VS Code first!
rm -rf ~/Library/Application\ Support/Code/User/globalStorage/GodCode.godcode
rm -rf ~/Library/Application\ Support/Code/User/workspaceStorage
rm -rf ~/.continue/index
```

Then reinstall.

### Option 2: Try Development Mode

Instead of using the packaged extension, run in development:

```bash
# Terminal 1: Start GUI dev server
cd /Users/agentsy/god-continues/gui
npm run dev

# Terminal 2: Open VS Code and press F5 (launches Extension Development Host)
```

This bypasses packaging issues and connects to live dev server.

### Option 3: Check if Core Process is Running

```bash
ps aux | grep -i "continue\|godcode" | grep -v grep
```

If you see a core process, try killing it:

```bash
pkill -f "continue.*core"
pkill -f "godcode.*core"
```

## 📝 **What to Share**

Please share:

1. **Console errors** - Any red error messages from Developer Tools
2. **Network failures** - Any failed requests in Network tab
3. **Output panel logs** - From Output → "GodCode" or "Continue"

Without the actual error message, I can't determine if it's:

- Missing files
- JavaScript errors
- CSP issues
- Core process failures
- Configuration problems

## 🎯 **Most Likely Causes**

Based on "error occurred while loading view":

1. **JavaScript exception during React initialization** (most likely)
2. **Missing or corrupted GUI assets**
3. **CSP blocking script execution**
4. **Extension host communication failure**

The Console will tell us exactly which one it is!

## ⚡ **Quick Test**

Try opening the Console View instead of the main view:

1. Press `Cmd+Shift+P`
2. Type: "View: Toggle Panel"
3. Look for "GodCode Console" panel
4. Does that load, or does it also show an error?

If the Console panel loads but GUI panel doesn't, it's specifically a GUI initialization issue.

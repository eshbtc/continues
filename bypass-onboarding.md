# Bypass GodCode Onboarding

If you're seeing a blank page, it's likely the onboarding card isn't rendering properly.

## Quick Fix - Run in VS Code Developer Console

1. Open VS Code
2. Open GodCode extension (click icon in sidebar)
3. Press `Cmd+Shift+P` → "Developer: Toggle Developer Tools"
4. In the Console tab, paste this:

```javascript
// Set onboarding as completed
localStorage.setItem("onboardingStatus", "Completed");

// Dismiss onboarding card
localStorage.setItem("hasDismissedOnboardingCard", true);

// Reload the window
location.reload();
```

## Alternative: Check for Errors First

Before bypassing, check the Console for errors:

1. Look for red error messages
2. Common issues:
   - `Failed to load resource` - GUI files missing
   - `Cannot read property of undefined` - React rendering error
   - `Uncaught TypeError` - JavaScript errors

## If Still Blank After Bypass

### Option 1: Check WebView Console

The main VS Code console shows extension host errors, but WebView has its own console:

1. Right-click in the blank GodCode panel
2. Select "Inspect Element" (might need to enable Developer Mode)
3. Check Console in the WebView inspector

### Option 2: Reinstall Extension

```bash
# Uninstall
code --uninstall-extension GodCode.godcode

# Clear storage
rm -rf ~/Library/Application\ Support/Code/User/globalStorage/GodCode.godcode

# Reinstall
code --install-extension /Users/agentsy/god-continues/extensions/vscode/build/godcode-1.3.26.vsix

# Reload VS Code
```

### Option 3: Run in Development Mode

```bash
cd /Users/agentsy/god-continues/extensions/vscode

# Start GUI dev server
cd ../../gui && npm run dev &

# Press F5 in VS Code to launch Extension Development Host
```

## Expected Behavior

After bypassing onboarding, you should see:

- Chat interface with input box at bottom
- "New Session" and "History" buttons at top
- Empty state with suggested prompts
- Model selector (showing your configured model)

## Debug Output Location

Extension logs are in:

- VS Code: Help → Toggle Developer Tools → Console
- Extension Host: Output panel → "Continue" or "GodCode"
- Log files: `~/.continue/logs/`

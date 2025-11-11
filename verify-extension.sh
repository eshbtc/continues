#!/bin/bash
# GodCode Extension Verification Script

echo "=== GodCode Extension Verification ==="
echo ""

# Check if extension is installed
echo "1. Checking if GodCode extension is installed..."
code --list-extensions | grep -i godcode
if [ $? -eq 0 ]; then
    echo "✓ Extension is installed"
else
    echo "✗ Extension not found"
    echo "Run: code --install-extension /Users/agentsy/god-continues/extensions/vscode/build/godcode-1.3.26.vsix"
    exit 1
fi

echo ""
echo "2. Checking extension package contents..."
VSIX_PATH="/Users/agentsy/god-continues/extensions/vscode/build/godcode-1.3.26.vsix"
if [ -f "$VSIX_PATH" ]; then
    echo "✓ VSIX package exists"
    
    # Check critical files
    echo ""
    echo "3. Verifying critical files in package..."
    unzip -l "$VSIX_PATH" | grep -E "(extension.js|index.html|index.js|index.css)" | head -5
else
    echo "✗ VSIX package not found at $VSIX_PATH"
    exit 1
fi

echo ""
echo "4. Checking config file..."
if [ -f ~/.continue/config.yaml ]; then
    echo "✓ Config file exists at ~/.continue/config.yaml"
    echo "Models configured:"
    grep -A2 "models:" ~/.continue/config.yaml | head -5
else
    echo "⚠ No config file found - will show onboarding"
fi

echo ""
echo "=== Next Steps ==="
echo "1. Open VS Code"
echo "2. Press Cmd+Shift+P → 'Developer: Toggle Developer Tools'"
echo "3. Open GodCode sidebar (should see icon in activity bar)"
echo "4. Check Console tab for any errors"
echo ""
echo "If you see a blank page:"
echo "  - Check Console for JavaScript errors"
echo "  - Try: Cmd+Shift+P → 'Developer: Reload Window'"
echo "  - Try: Clear localStorage: localStorage.setItem('onboardingStatus', 'Completed')"

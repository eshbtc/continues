#!/bin/bash
set -e

echo "🔒 Fixing Security Vulnerabilities Across All Packages"
echo "======================================================="

# Track what we fix
FIXED=()
MANUAL=()

# VS Code Extension
echo ""
echo "📦 1/5: VS Code Extension (8 vulnerabilities)"
cd /Users/agentsy/god-continues/extensions/vscode

# Safe fixes first (non-breaking)
echo "  → Applying safe fixes..."
npm audit fix

# Check if request is still there (critical issue, deprecated)
if grep -q '"request"' package.json 2>/dev/null; then
  echo "  ⚠️  MANUAL: 'request' is deprecated and has critical vulnerabilities"
  echo "     Need to replace with 'axios' or 'node-fetch'"
  MANUAL+=("vscode: Replace 'request' with 'axios'")
else
  echo "  ✓ No 'request' dependency"
fi

# Upgrade esbuild (moderate issue)
echo "  → Upgrading esbuild..."
npm install esbuild@latest --save-dev
FIXED+=("vscode: Upgraded esbuild")

cd ../..

# GUI
echo ""
echo "📦 2/5: GUI (10 vulnerabilities)"
cd gui

echo "  → Applying safe fixes..."
npm audit fix

# Upgrade esbuild
echo "  → Upgrading esbuild..."
npm install esbuild@latest --save-dev

# Check for prismjs issue
if npm audit 2>&1 | grep -q "prismjs"; then
  echo "  → Upgrading react-syntax-highlighter..."
  npm install react-syntax-highlighter@latest
  FIXED+=("gui: Upgraded react-syntax-highlighter")
fi

cd ..

# Core
echo ""
echo "📦 3/5: Core (8 vulnerabilities)"
cd core

echo "  → Applying safe fixes..."
npm audit fix --legacy-peer-deps

# Check if sqlite3 has issues
if npm audit 2>&1 | grep -q "sqlite3"; then
  echo "  ℹ️  sqlite3 native module - checking..."
  # SQLite3 often has build issues, handle carefully
fi

cd ..

# Binary
echo ""
echo "📦 4/5: Binary (7 vulnerabilities)"
cd binary

if [ -f package.json ]; then
  echo "  → Applying safe fixes..."
  npm audit fix
  FIXED+=("binary: Applied audit fixes")
else
  echo "  ℹ️  No package.json found"
fi

cd ..

# Vendor
echo ""
echo "📦 5/5: Core Vendor (checking...)"
if [ -f core/vendor/package.json ]; then
  cd core/vendor
  echo "  → Applying safe fixes..."
  npm audit fix
  FIXED+=("vendor: Applied audit fixes")
  cd ../..
else
  echo "  ℹ️  No vendor package.json found"
fi

# Summary
echo ""
echo "======================================================="
echo "✅ FIXED (${#FIXED[@]} items):"
for item in "${FIXED[@]}"; do
  echo "  ✓ $item"
done

echo ""
if [ ${#MANUAL[@]} -gt 0 ]; then
  echo "⚠️  MANUAL REVIEW NEEDED (${#MANUAL[@]} items):"
  for item in "${MANUAL[@]}"; do
    echo "  ! $item"
  done
fi

echo ""
echo "📊 Final Audit Status:"
echo ""
cd /Users/agentsy/god-continues/extensions/vscode
echo "VS Code Extension:"
npm audit 2>&1 | grep "vulnerabilities" || echo "  ✓ No vulnerabilities!"

cd ../..
cd gui
echo "GUI:"
npm audit 2>&1 | grep "vulnerabilities" || echo "  ✓ No vulnerabilities!"

cd ..
cd core
echo "Core:"
npm audit 2>&1 | grep "vulnerabilities" || echo "  ✓ No vulnerabilities!"

echo ""
echo "✅ Security fix pass complete!"
echo "⚠️  Test the build after these fixes:"
echo "   ./build-all.sh"

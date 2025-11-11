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

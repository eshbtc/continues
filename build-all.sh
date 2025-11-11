#!/bin/bash
set -e

echo "🏗️  Building all packages and extensions..."

# Build packages in dependency order
echo "📦 Building packages..."

cd packages/config-types
npm install
npm run build
cd ../..

cd packages/fetch  
npm install
npm run build
cd ../..

cd packages/llm-info
npm install
npm run build
cd ../..

cd packages/terminal-security
npm install
npm run build
cd ../..

cd packages/config-yaml
npm install
npm run build
cd ../..

cd packages/openai-adapters
npm install
npm run build
cd ../..

# Build core
echo "📦 Building core..."
cd core
npm install --legacy-peer-deps
npm run build
cd ..

# Build GUI
echo "📦 Building GUI..."
cd gui
npm install
npm run build
cd ..

# Build VS Code extension
echo "📦 Building VS Code extension..."
cd extensions/vscode
npm install
npm run package

echo ""
echo "✅ Build complete!"
echo "📦 VS Code extension: $(ls -1 *.vsix 2>/dev/null || echo 'not created')"

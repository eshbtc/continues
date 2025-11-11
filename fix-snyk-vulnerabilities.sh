#!/bin/bash
set -e

echo "🔒 Fixing Snyk-Identified Vulnerabilities"
echo "=========================================="
echo ""

FIXED=()
CRITICAL=()

# ====================
# 1. BINARY - Axios & Octokit
# ====================
echo "📦 1/5: binary/package.json (2 medium)"
if [ -f binary/package.json ]; then
  cd binary
  
  echo "  → Upgrading axios to 1.12.0..."
  npm install axios@1.12.0
  FIXED+=("binary: axios@1.12.0 (CVE-2025-58754)")
  
  echo "  → Upgrading @octokit/rest to 21.0.0..."
  npm install @octokit/rest@21.0.0
  FIXED+=("binary: @octokit/rest@21.0.0 (CVE-2025-25288)")
  
  cd ..
else
  echo "  ℹ️  binary/package.json not found"
fi

# ====================
# 2. CORE VENDOR - tar-fs
# ====================
echo ""
echo "📦 2/5: core/vendor/package.json (1 high, 1 medium)"
if [ -f core/vendor/package.json ]; then
  cd core/vendor
  
  echo "  → Upgrading tar-fs to 3.1.1..."
  npm install tar-fs@3.1.1
  FIXED+=("vendor: tar-fs@3.1.1 (CVE-2025-48387, CVE-2025-59343)")
  
  cd ../..
else
  echo "  ℹ️  core/vendor/package.json not found"
fi

# ====================
# 3. INTELLIJ - Java Dependencies (CRITICAL)
# ====================
echo ""
echo "📦 3/5: extensions/intellij/build.gradle.kts (1 critical, 5 high, 4 medium, 2 low)"
if [ -f extensions/intellij/build.gradle.kts ]; then
  echo "  ⚠️  CRITICAL: log4j 1.2.17 has multiple CVEs including CVE-2019-17571 (critical)"
  echo "  ⚠️  Must migrate to log4j 2.x manually"
  echo ""
  echo "  Manual steps required:"
  echo "    1. Update build.gradle.kts:"
  echo "       - Replace 'log4j:log4j:1.2.17' with 'org.apache.logging.log4j:log4j-core:2.24.3'"
  echo "       - Update commons-io to 2.7+"
  echo "       - Update commons-lang3 to 3.18.0"
  echo "       - Update kotlin-stdlib to 2.1.0"
  echo "    2. Update Java code to use log4j 2.x API"
  echo "    3. Test IntelliJ extension builds"
  echo ""
  CRITICAL+=("intellij: log4j 1.2.17 → 2.x (CRITICAL - 8 CVEs)")
  CRITICAL+=("intellij: commons-io@1.4 → 2.7+")
  CRITICAL+=("intellij: commons-lang3@3.8.1 → 3.18.0")
  CRITICAL+=("intellij: kotlin-stdlib@2.0.0 → 2.1.0")
else
  echo "  ℹ️  extensions/intellij/build.gradle.kts not found"
fi

# ====================
# 4. VSCODE - Vite & Dependencies
# ====================
echo ""
echo "📦 4/5: extensions/vscode/package.json (2 medium, 1 low)"
cd extensions/vscode

echo "  → Upgrading vite to 6.4.1..."
npm install vite@6.4.1 --save-dev
FIXED+=("vscode: vite@6.4.1 (CVE-2025-58752, CVE-2025-62522)")

echo "  → Upgrading @electron/rebuild to 4.0.1..."
npm install @electron/rebuild@4.0.1 --save-dev
FIXED+=("vscode: @electron/rebuild@4.0.1 (inflight leak)")

echo "  ⚠️  yarn@1.22.22 has CVE-2025-9308 (ReDoS) - no fix available yet"

cd ../..

# ====================
# 5. GUI - Mermaid & Prismjs
# ====================
echo ""
echo "📦 5/5: gui/package.json (1 medium, 1 low)"
cd gui

echo "  → Upgrading mermaid to 11.12.1..."
npm install mermaid@11.12.1
FIXED+=("gui: mermaid@11.12.1 → dagre-d3-es@7.0.13 (CVE-2025-57347)")

echo "  → Upgrading react-syntax-highlighter to 16.0.0..."
npm install react-syntax-highlighter@16.0.0
FIXED+=("gui: react-syntax-highlighter@16.0.0 → prismjs@1.30.0 (CVE-2024-53382)")

cd ..

# ====================
# Summary
# ====================
echo ""
echo "=========================================="
echo "✅ FIXED (${#FIXED[@]} items):"
for item in "${FIXED[@]}"; do
  echo "  ✓ $item"
done

if [ ${#CRITICAL[@]} -gt 0 ]; then
  echo ""
  echo "🔴 CRITICAL - MANUAL FIX REQUIRED (${#CRITICAL[@]} items):"
  for item in "${CRITICAL[@]}"; do
    echo "  ! $item"
  done
fi

echo ""
echo "📊 Testing builds..."
echo ""

# Test VS Code build
echo "Testing VS Code extension build..."
cd extensions/vscode
if npm run package 2>&1 | tail -5 | grep -q "vsix"; then
  echo "  ✓ VS Code extension builds successfully"
else
  echo "  ✗ VS Code extension build failed"
fi
cd ../..

# Test GUI build
echo "Testing GUI build..."
cd gui
if npm run build 2>&1 | tail -5 | grep -q "built in"; then
  echo "  ✓ GUI builds successfully"
else
  echo "  ✗ GUI build failed"
fi
cd ..

echo ""
echo "✅ Automated fixes complete!"
echo "⚠️  IntelliJ extension requires manual log4j migration"

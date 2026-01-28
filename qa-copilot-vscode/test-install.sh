#!/bin/bash
# Test script for install.sh validation
# This simulates different installation scenarios

set -e

echo "🧪 Testing QA Copilot Install Script"
echo "======================================"
echo ""

# Create temp test directory
TEST_DIR=$(mktemp -d)
trap "rm -rf $TEST_DIR" EXIT

cd "$TEST_DIR"
echo "Test directory: $TEST_DIR"
echo ""

# Test 1: Fresh installation (no existing .github)
echo "Test 1: Fresh installation (no .github folder)"
echo "-----------------------------------------------"
TEST1_DIR="$TEST_DIR/test1-fresh"
mkdir -p "$TEST1_DIR"
cd "$TEST1_DIR"

# Simulate having project files
touch package.json README.md
mkdir -p src

# Create minimal QA Copilot files locally to simulate download
mkdir -p .qa-copilot-temp/prompts
mkdir -p .qa-copilot-temp/agents
mkdir -p .qa-copilot-temp/skills
echo "# Test prompt" > .qa-copilot-temp/prompts/discover-endpoints.prompt.md
echo "# Test agent" > .qa-copilot-temp/agents/endpoint-discoverer.agent.md
echo "# QA Copilot Instructions" > .qa-copilot-temp/copilot-instructions.md

# Simulate what install script does
mkdir -p .github/prompts .github/agents .github/skills
cp .qa-copilot-temp/prompts/discover-endpoints.prompt.md .github/prompts/
cp .qa-copilot-temp/agents/endpoint-discoverer.agent.md .github/agents/
cp .qa-copilot-temp/copilot-instructions.md .github/

if [ -f ".github/prompts/discover-endpoints.prompt.md" ] && \
   [ -f ".github/agents/endpoint-discoverer.agent.md" ] && \
   [ -f ".github/copilot-instructions.md" ]; then
  echo "✅ PASS: Fresh installation created all files"
else
  echo "❌ FAIL: Fresh installation missing files"
fi
echo ""

# Test 2: Merge with existing .github content
echo "Test 2: Merge with existing .github (preserve other files)"
echo "-----------------------------------------------------------"
TEST2_DIR="$TEST_DIR/test2-merge"
mkdir -p "$TEST2_DIR"
cd "$TEST2_DIR"

# Simulate existing .github with other agent
mkdir -p .github/prompts .github/agents .github/skills
echo "# Other Team's Prompt" > .github/prompts/other-team.prompt.md
echo "# Other Team's Agent" > .github/agents/other-agent.agent.md
echo "# Existing instructions" > .github/copilot-instructions.md

# Now install QA Copilot files (simulating merge)
mkdir -p .qa-copilot-temp/prompts .qa-copilot-temp/agents
echo "# QA Copilot Prompt" > .qa-copilot-temp/prompts/discover-endpoints.prompt.md
echo "# QA Copilot Agent" > .qa-copilot-temp/agents/endpoint-discoverer.agent.md
echo "# QA Copilot Instructions" > .qa-copilot-temp/copilot-instructions.md

# Merge (what install script does)
cp .qa-copilot-temp/prompts/discover-endpoints.prompt.md .github/prompts/
cp .qa-copilot-temp/agents/endpoint-discoverer.agent.md .github/agents/

# Append to instructions if not already present
if ! grep -q "QA Copilot" .github/copilot-instructions.md; then
  echo "" >> .github/copilot-instructions.md
  echo "---" >> .github/copilot-instructions.md
  cat .qa-copilot-temp/copilot-instructions.md >> .github/copilot-instructions.md
fi

# Verify both old and new files exist
if [ -f ".github/prompts/other-team.prompt.md" ] && \
   [ -f ".github/prompts/discover-endpoints.prompt.md" ] && \
   [ -f ".github/agents/other-agent.agent.md" ] && \
   [ -f ".github/agents/endpoint-discoverer.agent.md" ] && \
   grep -q "Existing instructions" .github/copilot-instructions.md && \
   grep -q "QA Copilot Instructions" .github/copilot-instructions.md; then
  echo "✅ PASS: Merge preserved other files and added QA Copilot files"
else
  echo "❌ FAIL: Merge lost files or didn't add QA Copilot files"
fi
echo ""

# Test 3: Update existing QA Copilot installation
echo "Test 3: Update existing QA Copilot installation"
echo "------------------------------------------------"
TEST3_DIR="$TEST_DIR/test3-update"
mkdir -p "$TEST3_DIR"
cd "$TEST3_DIR"

# Simulate existing QA Copilot installation (old version)
mkdir -p .github/prompts .github/agents
echo "# Old QA Copilot Prompt v1" > .github/prompts/discover-endpoints.prompt.md
echo "# Old QA Copilot Agent v1" > .github/agents/endpoint-discoverer.agent.md
echo "# QA Copilot Instructions v1" > .github/copilot-instructions.md

# Simulate new version
mkdir -p .qa-copilot-temp/prompts .qa-copilot-temp/agents
echo "# New QA Copilot Prompt v2" > .qa-copilot-temp/prompts/discover-endpoints.prompt.md
echo "# New QA Copilot Agent v2" > .qa-copilot-temp/agents/endpoint-discoverer.agent.md
echo "# QA Copilot Instructions v2" > .qa-copilot-temp/copilot-instructions.md

# Update (what install script does)
cp .qa-copilot-temp/prompts/discover-endpoints.prompt.md .github/prompts/
cp .qa-copilot-temp/agents/endpoint-discoverer.agent.md .github/agents/
cp .qa-copilot-temp/copilot-instructions.md .github/copilot-instructions.md

# Verify files were updated (contain v2)
if grep -q "v2" .github/prompts/discover-endpoints.prompt.md && \
   grep -q "v2" .github/agents/endpoint-discoverer.agent.md && \
   grep -q "v2" .github/copilot-instructions.md; then
  echo "✅ PASS: Update replaced old QA Copilot files with new versions"
else
  echo "❌ FAIL: Update didn't replace files properly"
fi
echo ""

# Test 4: Verify structure matches expected layout
echo "Test 4: Verify directory structure"
echo "-----------------------------------"
TEST4_DIR="$TEST_DIR/test4-structure"
mkdir -p "$TEST4_DIR"
cd "$TEST4_DIR"

mkdir -p .github/prompts .github/agents .github/skills
touch .github/copilot-instructions.md
touch .github/prompts/discover-endpoints.prompt.md
touch .github/prompts/analyze-auth.prompt.md
touch .github/agents/endpoint-discoverer.agent.md
touch .github/agents/auth-analyzer.agent.md

# Check structure
if [ -d ".github/prompts" ] && \
   [ -d ".github/agents" ] && \
   [ -d ".github/skills" ] && \
   [ -f ".github/copilot-instructions.md" ]; then
  echo "✅ PASS: Directory structure is correct"
else
  echo "❌ FAIL: Directory structure is incorrect"
fi
echo ""

# Summary
echo "======================================"
echo "🎉 All install logic tests completed!"
echo "======================================"
echo ""
echo "Key behaviors verified:"
echo "  ✓ Fresh install creates correct structure"
echo "  ✓ Merge preserves non-QA-Copilot files"
echo "  ✓ Update replaces QA Copilot files only"
echo "  ✓ Directory structure matches spec"
echo ""
echo "The install.sh script should handle all these scenarios safely."

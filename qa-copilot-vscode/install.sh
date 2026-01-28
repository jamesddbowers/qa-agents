#!/bin/bash
# QA Copilot VSCode - Smart Install Script
# Usage: curl -fsSL https://raw.githubusercontent.com/jamesddbowers/qa-copilot-vscode/main/install.sh | bash
#
# This script safely installs QA Copilot files into your project's .github/ folder
# without overwriting other agents, prompts, or custom configurations.

set -e

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "QA Copilot for VS Code GitHub Copilot - Smart Installer"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Define our specific files (QA Copilot owned files only)
QA_PROMPTS=(
  "discover-endpoints.prompt.md"
  "analyze-auth.prompt.md"
  "analyze-traffic.prompt.md"
  "generate-collection.prompt.md"
  "generate-pipeline.prompt.md"
  "diagnose.prompt.md"
)

QA_AGENTS=(
  "endpoint-discoverer.agent.md"
  "auth-analyzer.agent.md"
  "traffic-analyzer.agent.md"
  "collection-generator.agent.md"
  "pipeline-generator.agent.md"
  "diagnostics-agent.agent.md"
)

# Check current directory
echo "📍 Current directory: $(pwd)"
echo ""

# Verify we're at project root (not inside a subdirectory)
if [ -f ".github/copilot-instructions.md" ] && [ "$(basename $(pwd))" != "$(git rev-parse --show-toplevel 2>/dev/null | xargs basename 2>/dev/null || echo '')" ]; then
  echo "⚠️  Warning: You appear to be in a subdirectory."
  echo "   The .github/ folder must be at your PROJECT ROOT (workspace root)."
  echo ""
  echo "   Current location: $(pwd)"
  echo "   Project root should be: $(git rev-parse --show-toplevel 2>/dev/null || echo 'Unable to detect git root')"
  echo ""
  read -p "Continue anyway? (y/N) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Cancelled. Please cd to your project root and run again."
    exit 1
  fi
fi

# Check if .github exists
if [ -d ".github" ]; then
  echo "✓ Found existing .github/ folder"
  echo "  We'll merge QA Copilot files without affecting your other agents/prompts."
  echo ""
else
  echo "✓ No .github/ folder found - will create one"
  echo ""
fi

# Create temp directory for download
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

echo "📥 Downloading QA Copilot files..."
npx degit jamesddbowers/qa-copilot-vscode/.github "$TEMP_DIR" --quiet

if [ $? -ne 0 ]; then
  echo "❌ Failed to download files from GitHub"
  exit 1
fi

echo "✓ Download complete"
echo ""

# Create directory structure if needed
mkdir -p .github/prompts
mkdir -p .github/agents
mkdir -p .github/skills

# Track what we're doing
INSTALLED=()
UPDATED=()
SKIPPED=()

# Install/update prompts
echo "📝 Installing prompt files..."
for prompt in "${QA_PROMPTS[@]}"; do
  if [ -f ".github/prompts/$prompt" ]; then
    cp "$TEMP_DIR/prompts/$prompt" ".github/prompts/$prompt"
    UPDATED+=("prompts/$prompt")
    echo "  ↻ Updated: prompts/$prompt"
  else
    cp "$TEMP_DIR/prompts/$prompt" ".github/prompts/$prompt"
    INSTALLED+=("prompts/$prompt")
    echo "  + Installed: prompts/$prompt"
  fi
done
echo ""

# Install/update agents
echo "🤖 Installing agent files..."
for agent in "${QA_AGENTS[@]}"; do
  if [ -f ".github/agents/$agent" ]; then
    cp "$TEMP_DIR/agents/$agent" ".github/agents/$agent"
    UPDATED+=("agents/$agent")
    echo "  ↻ Updated: agents/$agent"
  else
    cp "$TEMP_DIR/agents/$agent" ".github/agents/$agent"
    INSTALLED+=("agents/$agent")
    echo "  + Installed: agents/$agent"
  fi
done
echo ""

# Install/update skills (copy entire skills folder since it's ours)
echo "🎓 Installing skill files..."
if [ -d "$TEMP_DIR/skills" ]; then
  # Remove old QA Copilot skills and replace with new ones
  if [ -d ".github/skills" ]; then
    # Preserve non-QA-Copilot skills by backing them up
    TEMP_BACKUP=$(mktemp -d)
    if compgen -G ".github/skills/*" > /dev/null; then
      for skill_dir in .github/skills/*; do
        skill_name=$(basename "$skill_dir")
        # Check if this skill is from QA Copilot (has our marker files)
        if [ ! -f "$skill_dir/SKILL.md" ] || ! grep -q "QA Copilot" "$skill_dir/SKILL.md" 2>/dev/null; then
          # Not ours, preserve it
          cp -r "$skill_dir" "$TEMP_BACKUP/"
          echo "  ⊙ Preserving non-QA skill: $skill_name"
        fi
      done
    fi

    # Copy our skills
    cp -r "$TEMP_DIR/skills"/* ".github/skills/"

    # Restore preserved skills
    if compgen -G "$TEMP_BACKUP/*" > /dev/null; then
      cp -r "$TEMP_BACKUP"/* ".github/skills/"
    fi

    rm -rf "$TEMP_BACKUP"
    echo "  ↻ Updated: skills/"
  else
    cp -r "$TEMP_DIR/skills" ".github/"
    INSTALLED+=("skills/")
    echo "  + Installed: skills/"
  fi
fi
echo ""

# Handle copilot-instructions.md specially
echo "📋 Handling copilot-instructions.md..."
if [ -f ".github/copilot-instructions.md" ]; then
  # File exists - check if it already has QA Copilot content
  if grep -q "QA Copilot" ".github/copilot-instructions.md" 2>/dev/null; then
    echo "  ⚠️  copilot-instructions.md already contains QA Copilot content"
    echo "     Replacing with latest version..."
    cp "$TEMP_DIR/copilot-instructions.md" ".github/copilot-instructions.md"
    UPDATED+=("copilot-instructions.md")
    echo "  ↻ Updated: copilot-instructions.md"
  else
    # Has other content, append ours
    echo "  ⚠️  copilot-instructions.md exists with other content"
    echo "     Appending QA Copilot instructions..."
    echo "" >> ".github/copilot-instructions.md"
    echo "---" >> ".github/copilot-instructions.md"
    echo "" >> ".github/copilot-instructions.md"
    cat "$TEMP_DIR/copilot-instructions.md" >> ".github/copilot-instructions.md"
    UPDATED+=("copilot-instructions.md (appended)")
    echo "  + Appended: copilot-instructions.md"
  fi
else
  cp "$TEMP_DIR/copilot-instructions.md" ".github/copilot-instructions.md"
  INSTALLED+=("copilot-instructions.md")
  echo "  + Installed: copilot-instructions.md"
fi
echo ""

# Summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ QA Copilot installation complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if [ ${#INSTALLED[@]} -gt 0 ]; then
  echo "📦 Installed (${#INSTALLED[@]} files):"
  for item in "${INSTALLED[@]}"; do
    echo "   + $item"
  done
  echo ""
fi

if [ ${#UPDATED[@]} -gt 0 ]; then
  echo "🔄 Updated (${#UPDATED[@]} files):"
  for item in "${UPDATED[@]}"; do
    echo "   ↻ $item"
  done
  echo ""
fi

# Verify structure
echo "📂 Your .github/ folder structure:"
echo ""
echo "   .github/"
echo "   ├── copilot-instructions.md"
echo "   ├── prompts/"
for prompt in "${QA_PROMPTS[@]}"; do
  if [ -f ".github/prompts/$prompt" ]; then
    echo "   │   ├── $prompt ✓"
  else
    echo "   │   ├── $prompt ✗ MISSING"
  fi
done
echo "   ├── agents/"
for agent in "${QA_AGENTS[@]}"; do
  if [ -f ".github/agents/$agent" ]; then
    echo "   │   ├── $agent ✓"
  else
    echo "   │   ├── $agent ✗ MISSING"
  fi
done
echo "   └── skills/"
if [ -d ".github/skills" ]; then
  skill_count=$(find .github/skills -name "SKILL.md" | wc -l)
  echo "       └── ($skill_count skill folders found) ✓"
else
  echo "       └── ✗ MISSING"
fi
echo ""

# Next steps
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Next Steps:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "1️⃣  Enable VS Code settings (paste into settings.json):"
echo ""
echo '   {'
echo '     "github.copilot.chat.codeGeneration.useInstructionFiles": true,'
echo '     "chat.promptFiles": true,'
echo '     "chat.useAgentSkills": true,'
echo '     "chat.agent.enabled": true'
echo '   }'
echo ""
echo "   How to open settings.json:"
echo "   • Press Ctrl+Shift+P (Windows/Linux) or Cmd+Shift+P (Mac)"
echo "   • Type: Preferences: Open User Settings (JSON)"
echo "   • Press Enter"
echo ""
echo "   Docs: https://code.visualstudio.com/docs/getstarted/settings"
echo ""
echo "2️⃣  Restart VS Code (close and reopen)"
echo ""
echo "3️⃣  Verify installation:"
echo "   • Open Copilot Chat (Ctrl+Alt+I or Cmd+Alt+I)"
echo "   • Type / to see QA prompts"
echo "   • Check agent dropdown for @endpoint-discoverer, @auth-analyzer, etc."
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📚 Full documentation:"
echo "   https://github.com/jamesddbowers/qa-copilot-vscode#readme"
echo ""
echo "⚠️  IMPORTANT: The .github/ folder must be at your project root"
echo "   (the folder you open in VS Code), not nested in subdirectories."
echo ""

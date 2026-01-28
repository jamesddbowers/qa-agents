# Installation Updates Summary

## Changes Made

Updated installation system to address the `.github/` folder location issue and add safe merging capabilities.

---

## 1. Updated `install.sh` - Smart Merge Installation

### Key Features

**✅ Root Directory Verification**
- Checks if you're at project root before installing
- Warns if `.github/` might be nested in a subdirectory
- Prevents installation in wrong locations

**✅ Safe Merging**
- Only updates QA Copilot-owned files (6 prompts, 6 agents)
- Preserves other teams' prompts and agents
- Intelligently handles `copilot-instructions.md`:
  - If file exists with QA Copilot content → Updates it
  - If file exists with other content → Appends QA Copilot content
  - If file doesn't exist → Creates it

**✅ Detailed Reporting**
- Shows what was installed vs updated
- Displays final directory structure
- Verifies all files are in place

### QA Copilot Owned Files

The script ONLY touches these specific files:

**Prompts** (6):
- `discover-endpoints.prompt.md`
- `analyze-auth.prompt.md`
- `analyze-traffic.prompt.md`
- `generate-collection.prompt.md`
- `generate-pipeline.prompt.md`
- `diagnose.prompt.md`

**Agents** (6):
- `endpoint-discoverer.agent.md`
- `auth-analyzer.agent.md`
- `traffic-analyzer.agent.md`
- `collection-generator.agent.md`
- `pipeline-generator.agent.md`
- `diagnostics-agent.agent.md`

**Skills**: Entire `skills/` folder (identified by "QA Copilot" marker in SKILL.md files)

**Instructions**: `copilot-instructions.md` (with smart merge logic)

---

## 2. Updated `README.md` - Clear Root Requirement

### Changes Made

**Quick Start Section**
- Added prominent warning about root folder requirement
- Made install script (Option A) the recommended method
- Added safety warnings about degit overwriting content

**Installation Section (Step 3)**
- Added critical requirement callout box at the top
- Shows correct vs wrong folder structure examples
- Emphasizes VS Code won't find nested folders

**Method 1 Reordered**
- Install script is now Method 1 (was Method 2)
- degit is now Method 2 with overwrite warning
- Added explanation of why install script is safer

**Troubleshooting Section**
- Created new top section: "Most Common Issue: Wrong Folder Location"
- Added verification commands to check folder structure
- Added fix instructions: `mv qa/.github .github`
- Updated all troubleshooting entries to check root first

---

## 3. Testing Validation

Created `test-install.sh` to verify installation logic:

✅ **Test 1**: Fresh installation (no existing .github) - PASS
✅ **Test 2**: Merge with existing content (preserve other files) - PASS
✅ **Test 3**: Update existing QA Copilot installation - PASS
✅ **Test 4**: Directory structure verification - PASS

---

## What This Solves

### Original Problem
Users installed QA Copilot with `.github/` nested in subdirectories like:
```
your-project/
└── qa/
    └── .github/  ← VS Code can't find this
        ├── prompts/
        └── agents/
```

### Solution
1. **Install script warns** if you're not at project root
2. **README emphasizes** the requirement in multiple places
3. **Troubleshooting** guides users to check and fix the location
4. **Safe merging** allows users with existing `.github/` to install without fear

### Expected Structure
```
your-project/               # ← Workspace root opened in VS Code
├── .github/               # ← Must be HERE
│   ├── copilot-instructions.md
│   ├── prompts/
│   │   ├── discover-endpoints.prompt.md
│   │   └── ...
│   ├── agents/
│   │   ├── endpoint-discoverer.agent.md
│   │   └── ...
│   └── skills/
├── src/
├── package.json
└── ...
```

---

## Migration Guide for Existing Users

If you installed QA Copilot in the wrong location:

### Step 1: Check Current Location
```bash
pwd
ls -la
# If you see qa/.github/ instead of .github/, you need to move it
```

### Step 2: Move to Root
```bash
# If currently nested in qa/
mv qa/.github .github

# Remove empty qa folder (optional)
rmdir qa
```

### Step 3: Verify Structure
```bash
ls -la .github/
# Should show: prompts/, agents/, skills/, copilot-instructions.md
```

### Step 4: Restart VS Code
- Close VS Code completely
- Reopen the project
- Open Copilot Chat and test with `/` and agent picker

---

## Installation Commands

### For New Projects (No existing .github)
```bash
cd /path/to/your/project  # Must be at root!
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/qa-copilot-vscode/main/install.sh | bash
```

### For Projects with Existing .github
```bash
cd /path/to/your/project  # Must be at root!
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/qa-copilot-vscode/main/install.sh | bash
# Script will safely merge - only touching QA Copilot files
```

### For Updates to Existing QA Copilot
```bash
cd /path/to/your/project  # Must be at root!
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/qa-copilot-vscode/main/install.sh | bash
# Script will update QA Copilot files to latest version
```

---

## Files Modified

1. **install.sh** - Complete rewrite with smart merge logic (272 lines)
2. **README.md** - Added warnings, reordered methods, enhanced troubleshooting
3. **test-install.sh** - New test suite for validation (162 lines)
4. **INSTALLATION-UPDATES.md** - This document (for tracking changes)

---

## Next Steps

1. **Commit these changes**:
   ```bash
   git add install.sh README.md test-install.sh INSTALLATION-UPDATES.md
   git commit -m "Add smart merge installation with root verification and safety checks"
   ```

2. **Test on another machine**:
   - Run the install script on a test project
   - Verify it handles existing `.github/` content correctly
   - Confirm root directory warnings work

3. **Update documentation links**:
   - Ensure `YOUR_USERNAME` is replaced with actual GitHub username
   - Update any referencing docs in the parent repo

4. **Consider adding**:
   - Pre-commit hook to verify `.github/` at root
   - CI/CD test that runs `test-install.sh`
   - Video walkthrough of installation process

---

## Technical Details

### How Root Detection Works
```bash
# Checks if git root differs from current directory
if [ "$(basename $(pwd))" != "$(git rev-parse --show-toplevel 2>/dev/null | xargs basename)" ]; then
  # Warn user they might be in a subdirectory
fi
```

### How Safe Merge Works
```bash
# 1. Download to temp directory
TEMP_DIR=$(mktemp -d)
npx degit user/repo/.github "$TEMP_DIR"

# 2. Only copy QA Copilot files by name
for prompt in "${QA_PROMPTS[@]}"; do
  cp "$TEMP_DIR/prompts/$prompt" ".github/prompts/$prompt"
done

# 3. Preserve skills that don't have "QA Copilot" marker
for skill_dir in .github/skills/*; do
  if ! grep -q "QA Copilot" "$skill_dir/SKILL.md"; then
    # Keep it - not ours
  fi
done
```

---

## Success Criteria

✅ Users can install on projects with existing `.github/` content safely
✅ Users are warned if installing in wrong location
✅ Users understand `.github/` must be at project root
✅ Updates don't destroy other teams' agents/prompts
✅ All installation scenarios are tested and pass

---

**Date**: 2026-01-27
**Updated by**: Claude Code
**Testing Status**: All tests passing ✅

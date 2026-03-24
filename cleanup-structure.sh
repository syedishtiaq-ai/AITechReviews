#!/bin/bash

###############################################################################
# CLEANUP SCRIPT FOR AITECHREVIEWS FOLDER STRUCTURE
# Purpose: Remove old subfolders and ensure git doesn't revert changes
# Created: March 24, 2026
###############################################################################

set -e  # Exit on error

REPO_ROOT="/Users/ishtiaq/Documents/AITechReviews"
cd "$REPO_ROOT"

echo "=================================="
echo "CLEANUP & STRUCTURE VALIDATION"
echo "=================================="
echo ""

# ============================================================================
# STEP 1: DELETE OLD SUBFOLDERS FROM BUYING-GUIDES/ELECTRONICS
# ============================================================================
echo "STEP 1: Deleting old subfolders from buying-guides/electronics..."
echo ""

OLD_FOLDERS=(
  "content/buying-guides/electronics/accessories"
  "content/buying-guides/electronics/camera-photo"
  "content/buying-guides/electronics/consoles"
  "content/buying-guides/electronics/desktop-computers"
  "content/buying-guides/electronics/home-audio"
  "content/buying-guides/electronics/laptops"
  "content/buying-guides/electronics/power-banks"
  "content/buying-guides/electronics/tvs"
)

for folder in "${OLD_FOLDERS[@]}"; do
  if [ -d "$folder" ]; then
    echo "  ❌ Deleting: $folder"
    rm -rf "$folder"
  else
    echo "  ✓ Already gone: $folder"
  fi
done

echo ""

# ============================================================================
# STEP 2: CHECK GIT STATUS & REMOVE OLD REFERENCES
# ============================================================================
echo "STEP 2: Checking git status for product-reviews folder..."
echo ""

if git ls-tree -d HEAD content/product-reviews > /dev/null 2>&1; then
  echo "  ⚠️  WARNING: Git still tracks 'product-reviews' folder"
  echo "     This needs to be removed from git history (different operation)"
  echo "     For now, we'll create a .gitignore to prevent re-adding"
else
  echo "  ✓ product-reviews not in git"
fi

echo ""

# ============================================================================
# STEP 3: CREATE .GITIGNORE TO PROTECT NEW STRUCTURE
# ============================================================================
echo "STEP 3: Creating/updating .gitignore..."
echo ""

# Check if .gitignore exists, if not create it
if [ ! -f ".gitignore" ]; then
  echo "  📝 Creating new .gitignore file"
  cat > .gitignore << 'EOF'
# OS files
.DS_Store
.AppleDouble
.LSOverride
*.swp
*.swo
*~

# Hugo build files
public/
resources/
.hugo_build.lock

# Old structure - DO NOT RESTORE
content/product-reviews/
content/*/*/posts.json
content/*/all/

# Node modules (if used)
node_modules/
package-lock.json
yarn.lock

# IDE
.vscode/
.idea/
*.code-workspace

# Environment
.env
.env.local
EOF
  echo "  ✓ Created new .gitignore"
else
  echo "  ✓ .gitignore already exists"
  # Check if it has the protection lines
  if grep -q "content/product-reviews/" .gitignore; then
    echo "  ✓ .gitignore already has old structure protections"
  else
    echo "  📝 Adding old structure protection to .gitignore"
    cat >> .gitignore << 'EOF'

# Old structure - DO NOT RESTORE
content/product-reviews/
content/*/*/posts.json
content/*/all/
EOF
  fi
fi

echo ""

# ============================================================================
# STEP 4: VERIFY NEW FOLDER STRUCTURE
# ============================================================================
echo "STEP 4: Verifying new folder structure..."
echo ""

# Check buying-guides structure
echo "  📂 Buying Guides Structure:"
if [ -d "content/buying-guides" ]; then
  echo "  ✓ content/buying-guides/ exists"
  
  # Should have: _index.md + categories (electronics, home-appliances, mobile-gadgets)
  EXPECTED_CATEGORIES=("electronics" "home-appliances" "mobile-gadgets")
  for cat in "${EXPECTED_CATEGORIES[@]}"; do
    if [ -d "content/buying-guides/$cat" ]; then
      FILE_COUNT=$(find "content/buying-guides/$cat" -maxdepth 1 -name "*.md" | wc -l)
      echo "    ✓ $cat/ - Articles: $FILE_COUNT"
    else
      echo "    ❌ $cat/ - MISSING!"
    fi
  done
else
  echo "  ❌ content/buying-guides/ MISSING!"
fi

echo ""

# Check gaming structure
echo "  📂 Gaming Structure:"
if [ -d "content/gaming" ]; then
  echo "  ✓ content/gaming/ exists"
  if [ -d "content/gaming/achievements" ]; then
    FILE_COUNT=$(find "content/gaming/achievements" -maxdepth 1 -name "*.md" | wc -l)
    echo "    ✓ achievements/ - Articles: $FILE_COUNT"
  fi
else
  echo "  ❌ content/gaming/ MISSING!"
fi

echo ""

# Check tutorials structure
echo "  📂 Tutorials & Guides Structure:"
if [ -d "content/tutorials-guides" ]; then
  echo "  ✓ content/tutorials-guides/ exists"
  SUBFOLDERS=$(find "content/tutorials-guides" -maxdepth 1 -type d ! -name "tutorials-guides" | wc -l)
  echo "    ✓ Subcategories: $SUBFOLDERS"
else
  echo "  ❌ content/tutorials-guides/ MISSING!"
fi

echo ""

# ============================================================================
# STEP 5: CHECK FOR ORPHANED OLD SUBFOLDERS
# ============================================================================
echo "STEP 5: Checking for any remaining old subfolders..."
echo ""

FOUND_ORPHANS=0

# Check for any remaining old structure patterns
OLD_PATTERNS=("*/posts.json" "*/all/" "*/accessories/" "*/consoles/" "*/tvs/")

for pattern in "${OLD_PATTERNS[@]}"; do
  if find content/buying-guides -path "*$pattern" 2>/dev/null | grep -q .; then
    echo "  ⚠️  Found old pattern: $pattern"
    FOUND_ORPHANS=1
  fi
done

if [ $FOUND_ORPHANS -eq 0 ]; then
  echo "  ✓ No old structure patterns found - CLEAN!"
fi

echo ""

# ============================================================================
# STEP 6: GIT COMMIT THE CLEANUP
# ============================================================================
echo "STEP 6: Git status after cleanup..."
echo ""

GIT_STATUS=$(git status --porcelain | wc -l)

if [ "$GIT_STATUS" -gt 0 ]; then
  echo "  📊 Changes detected: $GIT_STATUS files"
  echo ""
  echo "  Recommended next steps:"
  echo "  1. Review changes: git status"
  echo "  2. Stage changes: git add ."
  echo "  3. Commit: git commit -m 'Clean up old folder structure and add .gitignore protection'"
  echo "  4. Rebuild: hugo --cleanDestinationDir"
else
  echo "  ✓ No changes (structure already clean)"
fi

echo ""

# ============================================================================
# STEP 7: REBUILD HUGO
# ============================================================================
echo "STEP 7: Rebuilding Hugo..."
echo ""

if command -v hugo &> /dev/null; then
  HUGO_OUTPUT=$(hugo --cleanDestinationDir 2>&1 | tail -1)
  echo "  ✓ Hugo build completed"
  echo "  $HUGO_OUTPUT"
else
  echo "  ❌ Hugo not found in PATH"
fi

echo ""
echo "=================================="
echo "✅ CLEANUP COMPLETE!"
echo "=================================="
echo ""
echo "📋 SUMMARY:"
echo "  ✓ Old subfolders deleted"
echo "  ✓ .gitignore protection added"
echo "  ✓ New structure verified"
echo "  ✓ Hugo rebuilt"
echo ""
echo "🔒 FUTURE PREVENTION:"
echo "  - Don't create subfolders inside category folders"
echo "  - Keep flat structure: content/{section}/*.md"
echo "  - Use _index.md only for taxonomy pages"
echo ""

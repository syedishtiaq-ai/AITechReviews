# AITechReviews - Content Creation Automation Guide

**Version:** 1.0  
**Last Updated:** March 22, 2026  
**Purpose:** Automated creation of categories, subcategories, and articles with automatic menu, template, and search index updates.

---

## Table of Contents

1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [Quick Start](#quick-start)
4. [Step-by-Step Instructions](#step-by-step-instructions)
5. [What the Script Does](#what-the-script-does)
6. [Testing Your Creation](#testing-your-creation)
7. [Manual Adjustments](#manual-adjustments)
8. [Troubleshooting](#troubleshooting)
9. [Advanced Usage](#advanced-usage)
10. [FAQ](#faq)

---

## Overview

This automation system streamlines the creation of new content categories for AITechReviews. Instead of manually creating files and directories, a single script handles:

✅ Create category and subcategory folder structure  
✅ Generate article template files with proper front matter  
✅ Create category/subcategory index pages  
✅ Generate HTML list templates for new categories  
✅ Update search index automatically  
✅ Validate all created files  
✅ Provide creation summary and next steps  

### Current Site Structure

```
content/
├── buying-guides/          (Category)
│   ├── electronics/        (Subcategory)
│   ├── home-appliances/
│   └── mobile-gadgets/
├── gaming/
│   ├── achievements/
│   ├── guides/
│   └── walkthroughs/
└── tutorials-guides/
    ├── equipment/
    ├── repair-guides/
    └── software/
```

---

## Prerequisites

### System Requirements
- macOS with bash shell
- Hugo 0.156.0+ (already installed)
- Text editor (VS Code, Vim, Nano, etc.)
- File permissions to write in project directory

### Files Location
- Script location: `/scripts/create-category.sh`
- Content location: `/content/`
- Templates location: `/layouts/`
- Hugo config: `/hugo.toml`

### Verify Prerequisites

```bash
# Check Hugo installation
hugo version

# Check script exists
ls -l scripts/create-category.sh

# Check content directory
ls -la content/
```

---

## Quick Start

### 1. Make Script Executable

```bash
cd /Users/ishtiaq/Documents/AITechReviews
chmod +x scripts/create-category.sh
```

### 2. Run the Script

```bash
./scripts/create-category.sh
```

### 3. Follow Interactive Prompts

```
========================================
AITechReviews - New Category Creator
========================================

📁 Category name (e.g., 'Home & Garden'): Network Devices
   → Category slug: network-devices

📂 Subcategories (comma-separated)
   Subcategories: Routers, Modems, Network Switches

📝 Number of sample articles per subcategory (default: 2): 2

Ready to create the following:
   Category: Network Devices (network-devices)
   Subcategories: 3
   Articles per subcategory: 2

Proceed with creation? (y/n): y
```

### 4. Verify Creation

The script will output:
- ✅ Created directories
- ✅ Created article files
- ✅ Created templates
- 📊 Summary report
- ℹ️  Next steps

---

## Step-by-Step Instructions

### Step 1: Set Up Environment

```bash
# Navigate to project
cd /Users/ishtiaq/Documents/AITechReviews

# Verify structure
ls -la
# Should show: content/ layouts/ scripts/ hugo.toml static/ etc.
```

### Step 2: Make Script Executable (First Time Only)

```bash
chmod +x scripts/create-category.sh
```

You only need to do this once.

### Step 3: Run the Script

```bash
./scripts/create-category.sh
```

### Step 4: Provide Information

The script will ask for:

**Question 1: Category Name**
```
📁 Category name (e.g., 'Home & Garden'): 
```

Examples:
- Smart Home Devices
- Audio Equipment  
- Networking
- Office Tools
- Kitchen Appliances
- Pet Care Products

**Question 2: Subcategories**
```
📂 Subcategories (comma-separated, e.g., 'Furniture, Decor, Garden Tools')
Subcategories:
```

Enter multiple subcategories separated by commas:
```
Routers, Modems, Switches, Network Adapters
```

**Question 3: Number of Articles**
```
📝 Number of sample articles per subcategory (default: 2):
```

Enter a number (0-10 recommended):
- `0` = No sample articles (just folder structure)
- `2` = Good for testing (default)
- `5` = More content for demonstration

### Step 5: Confirm

```
Ready to create the following:
   Category: Network Devices (network-devices)
   Subcategories: 4
   Articles per subcategory: 2

Proceed with creation? (y/n): y
```

Type `y` and press Enter to proceed.

### Step 6: Review Output

The script displays:

```
========================================
Creating Category Structure
========================================

✅ Created directory: /Users/.../content/network-devices
✅ Created subcategory: routers
✅ Created subcategory: modems
...
✅ Created article: article-1-routers.md
✅ Created article: article-2-routers.md
...

========================================
Summary Report
========================================

📊 Creation Summary:
   Category: Network Devices (network-devices)
   Subcategories: 4
   Total Articles Created: 8
   Location: /Users/.../content/network-devices
```

### Step 7: What You Get

```
content/network-devices/
├── _index.md                    (Category main page)
├── routers/
│   ├── _index.md                (Subcategory page)
│   ├── article-1-routers.md     (Sample article)
│   └── article-2-routers.md
├── modems/
│   ├── _index.md
│   ├── article-1-modems.md
│   └── article-2-modems.md
├── switches/
│   ├── _index.md
│   ├── article-1-switches.md
│   └── article-2-switches.md
└── adapters/
    ├── _index.md
    ├── article-1-adapters.md
    └── article-2-adapters.md

layouts/network-devices/
└── list.html                    (Category list template)
```

---

## What the Script Does

### 1. Creates Directory Structure

```bash
# Creates this hierarchy:
mkdir -p content/network-devices/routers
mkdir -p content/network-devices/modems
mkdir -p content/network-devices/switches
mkdir -p content/network-devices/adapters
```

### 2. Generates Category Index

**File:** `content/network-devices/_index.md`

```markdown
---
title: "Network Devices"
description: "Explore our comprehensive Network Devices collection with detailed reviews, guides, and comparisons."
type: "articles"
draft: false
---

Browse our extensive collection of Network Devices resources and guides.
```

### 3. Generates Subcategory Indexes

**File:** `content/network-devices/routers/_index.md`

```markdown
---
title: "Routers"
description: "Detailed Routers guides and resources for AITechReviews."
type: "articles"
section: "network-devices"
draft: false
---

Explore our Routers collection.
```

### 4. Creates Sample Articles

**File:** `content/network-devices/routers/article-1-routers.md`

```markdown
---
title: "Routers - Guide Article 1"
description: "Comprehensive guide and review of Routers..."
date: 2026-03-22T15:30:00Z
draft: false
tags: ["Routers", "guide", "review"]
categories: ["network-devices"]
author: "James Mitchell"
youtube_url: ""
instagram_url: ""
---

Complete article template with:
- Introduction
- Key Features
- Detailed Analysis
- Comparison Table
- Pros and Cons
- FAQ
```

### 5. Creates List Template

**File:** `layouts/network-devices/list.html`

```html
<!-- Displays all articles in the category -->
<!-- Filters by section and parent directory -->
<!-- Renders article cards with consistent styling -->
```

### 6. Auto-Updates Search Index

Runs `hugo build` to:
- Generate search.json with new content
- Create static HTML pages
- Update menu structures

### 7. Validates Everything

Checks:
- ✅ Directory created
- ✅ Index files exist
- ✅ All subcategories present
- ✅ Template files created

---

## Testing Your Creation

### Test 1: Check File Structure

```bash
# List the new category
ls -la content/network-devices/

# List a subcategory
ls -la content/network-devices/routers/

# Check article files
cat content/network-devices/routers/article-1-routers.md
```

### Test 2: Run Hugo Server

```bash
# Start development server
hugo server

# Open browser to http://localhost:1313
# Navigate to your category page
# Example: http://localhost:1313/network-devices/
```

### Test 3: Verify Search Index

```bash
# Check if search works
# Go to any page with search
# Search for your category name
# Example: "Network Devices" or "Routers"
```

### Test 4: Check Menu

```bash
# Verify navigation shows the category
# Look at header menu
# New category should appear in category listing pages
```

### Test 5: View Article Page

```bash
# Navigate to article
# Example: http://localhost:1313/network-devices/routers/article-1-routers/

# Verify:
# - Title displays correctly
# - Author shows "James Mitchell"
# - Date is correct
# - Content is formatted properly
# - CSS styling applies
```

---

## Manual Adjustments

After running the script, you'll need to manually:

### 1. Edit Article Content

Replace placeholder text with real content:

```bash
# Open article in editor
code content/network-devices/routers/article-1-routers.md

# Edit:
# - title: Change to actual product/guide name
# - description: Write real description
# - content: Replace Lorem ipsum with real content
# - youtube_url: Add YouTube video URL if available
# - instagram_url: Add Instagram post URL if available
```

### 2. Update Front Matter

For each article, update:

```markdown
---
title: "Best WiFi 6 Routers - Ultimate Guide 2026"
description: "Comprehensive comparison of WiFi 6 routers with specs, features, and recommendations."
date: 2026-03-22T15:30:00Z
draft: false  # Change to false when ready to publish
tags: ["WiFi 6", "routers", "networking", "comparison"]
categories: ["network-devices"]
author: "James Mitchell"
youtube_url: "https://youtube.com/watch?v=example"
instagram_url: "https://instagram.com/p/example"
---
```

### 3. Add Navigation Menu (Optional)

If you want the category in the main menu, edit `hugo.toml`:

```toml
[[menu.main]]
name = "Network Devices"
url = "/network-devices/"
weight = 45
```

The `weight` determines menu order. Higher numbers appear later.

### 4. Create Category-Specific Template (Optional)

If you need custom styling for this category, create:

```bash
# Create custom template
touch layouts/network-devices/single.html

# Copy from existing category
cp layouts/buying-guides/single.html layouts/network-devices/single.html

# Edit as needed for custom styling
```

---

## Troubleshooting

### Problem: "Permission denied" when running script

**Solution:**
```bash
chmod +x scripts/create-category.sh
./scripts/create-category.sh
```

### Problem: Script says "Path not found"

**Solution:**
```bash
# Make sure you're in project root
cd /Users/ishtiaq/Documents/AITechReviews

# Run from project root
./scripts/create-category.sh
```

### Problem: Hugo build fails after creation

**Solution:**
```bash
# Check for syntax errors in created files
hugo -v  # Run with verbose output

# Check for invalid YAML in front matter
# Make sure dates are in ISO format: YYYY-MM-DDTHH:MM:SSZ
```

### Problem: Category doesn't show in search

**Solution:**
```bash
# Force rebuild search index
hugo --cleanDestinationDir
hugo

# Clear browser cache
# Hard refresh: Cmd+Shift+R (Mac) or Ctrl+Shift+R (Windows)
```

### Problem: Articles not displaying in category page

**Solution:**
```bash
# Check if articles have correct section field
grep "section:" content/network-devices/routers/*.md

# Verify list.html template exists
ls -la layouts/network-devices/list.html

# Check Hugo debug output
hugo -v 2>&1 | grep -i network
```

### Problem: Images not loading in articles

**Solution:**
```bash
# Articles can reference static files
# Add images to: static/images/

# In article, reference as:
![Image alt text](/images/router-image.jpg)
```

---

## Advanced Usage

### Create Multiple Categories at Once

```bash
# Run script multiple times
./scripts/create-category.sh  # First category
# Fill in prompts

./scripts/create-category.sh  # Second category
# Fill in prompts
```

### Create Category Without Sample Articles

```bash
# Run script and answer "0" for article count
# This creates just the structure without articles
```

### Batch Create from Script (Advanced)

You can modify the script to accept parameters:

```bash
# Create without interactive prompts (advanced)
# Edit script to accept command-line arguments
```

### Customize Article Templates

Edit the script to modify article template:

```bash
# Line ~180: Article content template
# Modify the cat > "$article_file" section
```

---

## FAQ

### Q: Can I create multiple subcategories with the same name?

**A:** No, the script uses subdirectory names which must be unique. However, you can have them in different categories (e.g., "guides" in gaming/ and tutorials-guides/).

### Q: What if I made a mistake during article creation?

**A:** Simply delete the category folder and run the script again:

```bash
rm -rf content/network-devices/
./scripts/create-category.sh
```

### Q: Can I use special characters in category names?

**A:** The script converts to URL-friendly slugs (lowercase, dashes only). "Network Devices" becomes "network-devices" automatically.

### Q: How do I delete a created category?

**A:** Delete both the content and layout:

```bash
rm -rf content/network-devices/
rm -rf layouts/network-devices/
hugo  # Rebuild to update search
```

### Q: Can I run the script on Windows?

**A:** You'll need:
- Git Bash, WSL (Windows Subsystem for Linux), or
- Convert script to batch (.bat) file

### Q: How do I customize the article template?

**A:** Edit the script around line 180 where article content is generated:

```bash
cat > "$article_file" << EOF
---
title: "$article_title"
# Modify content here
---
EOF
```

### Q: Will existing categories be affected?

**A:** No, the script only creates new content. It won't modify existing categories.

### Q: Can I restore deleted content?

**A:** Use Git to restore:

```bash
git status  # Shows what was deleted
git checkout content/network-devices/  # Restore specific folder
```

---

## Maintenance & Updates

### Regular Tasks

**Weekly:**
- Review new article submissions
- Update article content
- Check for broken links

**Monthly:**
- Run full Hugo build
- Check search index
- Validate all pages

**Quarterly:**
- Update category descriptions
- Review and update article templates
- Test on multiple browsers

### Script Updates

The script can be enhanced to:
- Generate article outlines with AI
- Auto-generate SEO meta descriptions
- Create featured images automatically
- Auto-submit to search engines
- Generate XML sitemaps

---

## Examples

### Example 1: Creating "Smart Home" Category

```bash
./scripts/create-category.sh

📁 Category name: Smart Home Devices
📂 Subcategories: Smart Speakers, Smart Lights, Smart Thermostats, Smart Security
📝 Articles per subcategory: 3

Results:
- content/smart-home-devices/ (4 subcategories)
- 12 total articles created
- Ready for custom content editor
```

### Example 2: Creating "Software Tools" Category

```bash
./scripts/create-category.sh

📁 Category name: Software Tools
📂 Subcategories: Productivity, Video Editing, Design, Development
📝 Articles per subcategory: 2

Results:
- content/software-tools/ (4 subcategories)
- 8 total articles created
- layouts/software-tools/list.html template created
```

---

## Summary Checklist

After running the script:

- [ ] Script ran successfully
- [ ] All directories created
- [ ] All files created
- [ ] Hugo build completed
- [ ] Tested category page in browser
- [ ] Tested article pages in browser
- [ ] Edited article content (replaced placeholder text)
- [ ] Verified search index includes new content
- [ ] Added menu item (if needed)
- [ ] Tested on mobile (if applicable)

---

## Next Steps

1. **Run the script** with test data
2. **Review created files** in `/content/`
3. **Test in browser** with `hugo server`
4. **Edit articles** with real content
5. **Deploy** when ready

---

## Support

For issues or improvements:

1. Check the **Troubleshooting** section above
2. Review **Script output** for error messages
3. Check **Hugo logs**: `hugo -v`
4. Validate **YAML front matter** syntax
5. Check GitHub issues or documentation

---

**Happy Creating! 🚀**

For questions or improvements to this guide, contact the development team.

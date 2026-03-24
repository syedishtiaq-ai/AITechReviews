# 📖 Complete Guide: Subcategory & Article Creation

**Full reference with detailed steps, troubleshooting, and customization**

---

## Table of Contents

1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [Installation & Setup](#installation--setup)
4. [Step-by-Step Walkthrough](#step-by-step-walkthrough)
5. [Understanding What Gets Created](#understanding-what-gets-created)
6. [Editing Your Content](#editing-your-content)
7. [What Happens Automatically](#what-happens-automatically)
8. [Common Issues & Solutions](#common-issues--solutions)
9. [Advanced Usage](#advanced-usage)
10. [FAQ](#faq)

---

## Overview

The article creation script streamlines adding new subcategories and articles to existing categories. Instead of manually creating folders and markdown files, the script:

1. Asks you to select a parent category (buying-guides, gaming, tutorials-guides)
2. Prompts for a subcategory name (furniture, smartphones, etc.)
3. Creates the folder structure automatically
4. Generates article templates with proper front matter
5. Applies existing CSS and templates automatically
6. Rebuilds the site immediately

**Time saving:** 10 minutes of manual work → 2 minutes with script

### Typical Use Cases

- **Adding furniture reviews** to buying-guides
- **Creating smart home guides** under electronics
- **Building walkthroughs** for new games
- **Writing software tutorials** under tutorials-guides
- **Bulk content expansion** across categories

---

## Prerequisites

Before using the script, ensure you have:

✅ **Hugo installed** (v0.156.0 or newer)
```bash
hugo version
# Should show: Hugo Static Site Generator v0.156.0+extended...
```

✅ **Existing categories** (buying-guides, gaming, tutorials-guides already created)

✅ **Script installed** (check that script exists)
```bash
ls -la /Users/ishtiaq/Documents/AITechReviews/scripts/create-article.sh
# Should show: -rwxr-xr-x (executable)
```

✅ **Write permissions** to the project directory
```bash
touch /Users/ishtiaq/Documents/AITechReviews/test.txt && rm test.txt
# Should work without permission denied errors
```

---

## Installation & Setup

### 1. Make Script Executable

The script should already be executable, but verify/fix if needed:

```bash
chmod +x /Users/ishtiaq/Documents/AITechReviews/scripts/create-article.sh
```

Check it worked:
```bash
ls -la /Users/ishtiaq/Documents/AITechReviews/scripts/create-article.sh
# Should show: -rwxr-xr-x (with x permissions)
```

### 2. Navigate to Project Directory

```bash
cd /Users/ishtiaq/Documents/AITechReviews
```

### 3. Run the Script

```bash
./scripts/create-article.sh
```

That's it! The interactive prompts guide you through the rest.

---

## Step-by-Step Walkthrough

### Step 1: Launch the Script

```bash
./scripts/create-article.sh
```

You'll see:
```
========================================
AITechReviews - Subcategory & Article Creator v1.0
========================================

Available categories:

  1) buying-guides
  2) gaming
  3) tutorials-guides

📁 Enter category name or number (e.g., 'buying-guides' or '1'):
```

### Step 2: Select Parent Category

**Option A: By number**
```
📁 Enter category name or number: 1
✅ Selected category: buying-guides
```

**Option B: By name**
```
📁 Enter category name or number: gaming
✅ Selected category: gaming
```

### Step 3: Enter Subcategory Name

```
📂 Subcategory name (e.g., 'furniture', 'smart-devices'): furniture
ℹ️  Subcategory slug: furniture
```

The script automatically converts to slug format:
- Input: "Smart Home Gadgets" → Slug: "smart-home-gadgets"
- Input: "Photography DSLR Cameras" → Slug: "photography-dslr-cameras"

### Step 4: Specify Article Count

```
📝 Number of articles to create (default: 2): 3
```

Press Enter to use default (2) or type a number (1-50 recommended).

### Step 5: Confirm Creation

```
Ready to create:
   Category: buying-guides
   Subcategory: furniture (furniture)
   Articles: 3

Proceed with creation? (y/n): y
```

Type `y` to proceed or `n` to cancel.

### Step 6: Watch the Process

```
========================================
Creating Subcategory Structure
========================================

✅ Created subcategory directory: furniture
✅ Created subcategory index: _index.md
✅ Created article: article-1-furniture.md
✅ Created article: article-2-furniture.md
✅ Created article: article-3-furniture.md

========================================
Validating Creation
========================================

✅ Subcategory directory exists
✅ Subcategory index file exists
✅ All 3 articles created
✅ Validation passed!

========================================
Summary Report
========================================

📊 Article Creation Summary:
   Parent Category: buying-guides
   Subcategory: furniture (furniture)
   Total Files Created: 4
   Location: /Users/ishtiaq/Documents/AITechReviews/content/buying-guides/furniture

📍 View in browser:
   Category: http://localhost:1313/buying-guides/
   Subcategory: http://localhost:1313/buying-guides/furniture/
   Article: http://localhost:1313/buying-guides/furniture/article-1-furniture/

========================================
Building Site
========================================

ℹ️  Running Hugo build to regenerate site...
✅ Hugo build completed successfully
```

**Done!** Your articles are created and live on the site.

---

## Understanding What Gets Created

### Folder Structure

```
content/buying-guides/furniture/          ← Subcategory folder
├── _index.md                             ← Subcategory page
├── article-1-furniture.md                ← Article 1
├── article-2-furniture.md                ← Article 2
└── article-3-furniture.md                ← Article 3
```

### The Subcategory File (_index.md)

Creates a browsable subcategory page with proper metadata:

```yaml
---
title: "furniture"
description: "Explore our comprehensive furniture collection with detailed reviews and guides."
type: "articles"
section: "buying-guides"
draft: false
---

Browse our furniture resources and guides.
```

This appears at: `http://localhost:1313/buying-guides/furniture/`

### Article Files (Markdown)

Each article includes complete structure:

```yaml
---
title: "furniture - Article 1"
description: "Comprehensive guide and review of furniture. Learn everything you need to know."
date: 2026-03-22T10:15:30Z
draft: false
tags: ["furniture", "guide", "review"]
categories: ["buying-guides"]
author: "James Mitchell"
youtube_url: ""
instagram_url: ""
---

## Introduction
...

## Key Features
...

[Continues with full article structure]
```

---

## Editing Your Content

### Locate Your Files

All files are in:
```
/Users/ishtiaq/Documents/AITechReviews/content/buying-guides/furniture/
```

### View All at Once

```bash
ls -la content/buying-guides/furniture/
# Output:
# -rw-r--r-- ... _index.md
# -rw-r--r-- ... article-1-furniture.md
# -rw-r--r-- ... article-2-furniture.md
# -rw-r--r-- ... article-3-furniture.md
```

### Edit in VS Code

Open one article for editing:
```bash
code content/buying-guides/furniture/article-1-furniture.md
```

Or open the whole folder:
```bash
code content/buying-guides/furniture/
```

### Edit Steps

1. **Replace the title and description**
   ```yaml
   title: "Best Office Chairs for Programmers"
   description: "Complete guide to ergonomic office chairs..."
   ```

2. **Add YouTube/Instagram URLs** (optional)
   ```yaml
   youtube_url: "https://youtube.com/watch?v=ABC123"
   instagram_url: "https://instagram.com/myhandle"
   ```

3. **Replace introduction section**
   Delete template text, add your intro

4. **Replace key features** list
   Replace with actual product features

5. **Fill in main sections**
   Update section names and content relevant to your topic

6. **Update comparison table**
   Replace with actual products/options

7. **Update pros/cons section**
   Real advantages and disadvantages

8. **Write your conclusion**
   Your final thoughts and recommendations

### Save and Test

Once you edit, save the file. Hugo watches for changes automatically:

```bash
# In another terminal, run:
hugo server
# Then visit: http://localhost:1313/buying-guides/furniture/article-1-furniture/
```

The browser will refresh automatically when you save.

---

## What Happens Automatically

### ✅ Directory Structure

The script creates:
- Parent category folder (if needed)
- Subcategory folder with proper slug
- All intermediate directories

```bash
mkdir -p content/buying-guides/furniture/
```

### ✅ Front Matter & Metadata

Each file gets:
- Correct YAML front matter
- Current date/time in ISO format
- Proper category and tag metadata
- Author set to "James Mitchell"
- Required fields for Hugo

### ✅ CSS & Styling

Your articles automatically use:
- Existing site CSS (static/css/style.css)
- Form styling (.form-group, .required-asterisk)
- Responsive design
- Mobile-optimized formatting
- Existing color scheme and fonts

**No CSS editing needed!**

### ✅ Templates & Layout

Articles display using:
- Default article template (layouts/_default/single.html)
- Category list template (layouts/buying-guides/list.html OR default)
- Archive templates for taxonomy
- Proper Hugo template hierarchy

**Templates apply automatically!**

### ✅ Site Regeneration

The script automatically:
1. Runs `hugo --quiet` to build
2. Regenerates all HTML files
3. Updates search index (search.yml)
4. Creates article URLs and pages
5. Updates archive pages
6. Rebuilds category pages with new article links

**Everything updates instantly!**

### ✅ Search Integration

After running the script:
- Articles appear in site search
- Search index includes new content
- Search filtering works for new categories
- Type title or keywords to find articles

---

## Common Issues & Solutions

### Issue 1: "Command not found: ./scripts/create-article.sh"

**Problem:** Script not found or not executable

**Solution:**
```bash
# Navigate to project directory
cd /Users/ishtiaq/Documents/AITechReviews

# Check if script exists
ls scripts/create-article.sh

# Make executable
chmod +x scripts/create-article.sh

# Run again
./scripts/create-article.sh
```

### Issue 2: "Category not found"

**Problem:** Typed category name doesn't exist

**Solution:**
- Check available categories by looking at content/ directory
- Use the number option instead (1, 2, 3)
- Verify category folder exists: `ls content/`

```bash
# See all categories
ls -d content/*/
# Output shows: buying-guides/ gaming/ tutorials-guides/ ...
```

### Issue 3: "Subcategory already exists"

**Problem:** You tried to create a subcategory that exists

**Solution:** Either:
1. Choose a different subcategory name
2. Type `n` and start over
3. Or continue and it will add articles to existing subcategory

```
Subcategory 'furniture' already exists!
Continue anyway? (y/n): y
```

### Issue 4: "Hugo build failed"

**Problem:** Hugo couldn't rebuild the site

**Solution:**
```bash
# Check Hugo installation
hugo version

# Try building manually
cd /Users/ishtiaq/Documents/AITechReviews
hugo

# If there are errors, see Hugo documentation
# The articles were still created successfully
```

### Issue 5: Articles not showing on website

**Problem:** Created articles don't appear at expected URL

**Solution:**
```bash
# Run Hugo server
hugo server

# Visit the correct URL format:
# http://localhost:1313/[category]/[subcategory]/[article-slug]/

# Example:
# http://localhost:1313/buying-guides/furniture/article-1-furniture/

# Check file exists
ls -la content/buying-guides/furniture/article-1-furniture.md

# If file exists but page isn't showing:
# 1. Check for draft: false in front matter
# 2. Check date is not in future
# 3. Run: hugo server and check terminal for errors
```

### Issue 6: Created but can't see in file browser

**Problem:** Script says articles were created, but you can't find them

**Solution:**
```bash
# List files directly
ls -la /Users/ishtiaq/Documents/AITechReviews/content/buying-guides/furniture/

# Or view in VS Code
code /Users/ishtiaq/Documents/AITechReviews/content/buying-guides/furniture/

# Check they exist with cat
cat /Users/ishtiaq/Documents/AITechReviews/content/buying-guides/furniture/_index.md
```

### Issue 7: Running script but it hangs/freezes

**Problem:** Script seems stuck waiting for input

**Solution:**
```bash
# Press Ctrl+C to stop
# Then run again:
./scripts/create-article.sh

# Make sure you type a response and press Enter
# Don't just press Space or other keys
```

### Issue 8: CSS not applying to new articles

**Problem:** New articles show but styling looks wrong

**Solution:**
```bash
# Clear Hugo cache
rm -rf /tmp/hugo_cache

# Rebuild
hugo --cleanDestinationDir

# Or restart Hugo server
# Stop it (Ctrl+C), then:
hugo server
```

---

## Advanced Usage

### Create Multiple Subcategories at Once

Run the script multiple times in sequence:

```bash
./scripts/create-article.sh   # Create furniture
./scripts/create-article.sh   # Create lighting
./scripts/create-article.sh   # Create storage
```

Each run is independent, creating different subcategories.

### Adding Articles to Existing Subcategory

If you run the script with an existing subcategory name, it will:
1. Detect the subcategory exists
2. Ask if you want to continue
3. Add new articles to the existing subcategory

```
Subcategory 'furniture' already exists!
Continue anyway? (y/n): y
```

New articles are added alongside existing ones.

### Manual Article Creation

To create just one article without the script:

1. **Create the file**
   ```bash
   touch content/buying-guides/furniture/my-article.md
   ```

2. **Add front matter**
   ```yaml
   ---
   title: "My Article Title"
   description: "Brief description..."
   date: 2026-03-22T12:00:00Z
   draft: false
   tags: ["furniture"]
   categories: ["buying-guides"]
   author: "James Mitchell"
   ---
   ```

3. **Add content** in markdown

4. **Rebuild**
   ```bash
   hugo
   ```

### Batch Operations (For Power Users)

To create articles from a template for many topics:

```bash
# Create articles for multiple furniture types
for item in "office-chairs" "dining-tables" "couches"; do
  mkdir -p "content/buying-guides/$item"
  # Copy template file or create manually
done
```

### Custom Article Structure

To modify what articles contain:

1. Find article creation in the script (around line 250)
2. Edit the template content between the `<< EOF` and `EOF` markers
3. Save the script
4. Run it again - new articles will use your template

---

## FAQ

### Q: Do I need to set up anything special first?

A: No! The script handles everything. Just have Hugo installed and existing categories.

### Q: Can I use this with categories I created manually?

A: Yes! If the category folder exists and has content, the script works with it.

### Q: What happens to existing subcategories/articles?

A: They're not touched. The script only adds new content. It's completely safe to run.

### Q: How many articles can I create at once?

A: As many as you want. Create 1, 50, or 100+ articles at once. The script handles it.

### Q: Will the articles be automatically populated with content?

A: No, you get templates. You fill in the actual product reviews, guides, etc. This saves you from creating the structure—you just write content.

### Q: Can I modify the article templates?

A: Yes! Edit the script, find the article template section, and modify the markdown structure. See "Custom Article Structure" in Advanced Usage above.

### Q: Do I need to manually update menus/navigation?

A: No! Hugo automatically includes new articles in category pages, taxonomies, and search.

### Q: What if I make a mistake creating articles?

A: Simply delete the unwanted article files:
```bash
rm content/buying-guides/furniture/article-3-furniture.md
hugo  # Rebuild
```

The site regenerates automatically.

### Q: Can I create subcategories under subcategories?

A: Not with this script, but you can manually:
```bash
mkdir -p content/buying-guides/furniture/office/
# Then create _index.md and articles manually
```

### Q: Do new articles automatically sync to Google Sheets?

A: No, contact form submissions (contact-us.html) sync to Google Sheets. Articles are part of the website only.

### Q: Can I create articles in other categories (not in the list)?

A: Only in existing categories. To create a new top-level category, see the full `create-category.sh` script documentation.

### Q: Will my articles appear in search?

A: Yes! After Hugo rebuilds (which the script does), articles appear in the site search feature immediately.

### Q: Can I change the author from "James Mitchell"?

A: Yes, edit the "author" field in each article's front matter to your name or anyone else's.

### Q: What's the difference between draft: true and draft: false?

A: 
- `draft: false` → Article is published and visible
- `draft: true` → Article is hidden (only visible in preview mode)

Keep `draft: false` for published content.

---

## Next Steps

1. **Run the script:** `./scripts/create-article.sh`
2. **Provide answers** to the interactive prompts
3. **Review created files:** `ls content/[category]/[subcategory]/`
4. **Edit your content:** Update titles, descriptions, and fill in real information
5. **Test locally:** `hugo server` then visit `http://localhost:1313`
6. **Preview articles:** Click on your new articles to verify styling and layout

---

**Questions?** Check [QUICK_START_ARTICLE_CREATION.md](QUICK_START_ARTICLE_CREATION.md) for quick reference, or review the script itself—it's heavily commented explaining each section.

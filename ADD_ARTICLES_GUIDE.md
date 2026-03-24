# 📖 Complete Guide: Adding Articles to Subcategories

**Full reference with detailed steps, editing, troubleshooting, and tips**

---

## Table of Contents

1. [Overview](#overview)
2. [Installation & Setup](#installation--setup)
3. [Step-by-Step Walkthrough](#step-by-step-walkthrough)
4. [Editing Your Articles](#editing-your-articles)
5. [Understanding Automatic Updates](#understanding-automatic-updates)
6. [Workflow Scenarios](#workflow-scenarios)
7. [Common Issues & Solutions](#common-issues--solutions)
8. [Advanced Tips](#advanced-tips)
9. [FAQ](#faq)

---

## Overview

The **Quick Article Adder** script simplifies adding articles to existing subcategories. Instead of:
1. Creating markdown files manually
2. Writing YAML front matter
3. Running Hugo build
4. Checking if it worked

You simply:
1. Choose category (buying-guides, gaming, etc.)
2. Choose subcategory (furniture, smartphones, etc.)
3. Enter article count
4. Script handles everything else

**Time saved:** 5-10 minutes of manual work → 2 minutes with script

### Perfect For

- ✅ Adding reviews to existing product categories
- ✅ Creating game guides in existing game folders
- ✅ Expanding tutorials under existing topics
- ✅ Bulk content expansion
- ✅ Daily article additions

---

## Installation & Setup

### 1. Verify Script Exists

```bash
ls -la /Users/ishtiaq/Documents/AITechReviews/scripts/add-articles.sh
# Should show: -rwxr-xr-x ... add-articles.sh
```

### 2. Make Executable (if needed)

```bash
chmod +x /Users/ishtiaq/Documents/AITechReviews/scripts/add-articles.sh
```

### 3. Navigate to Project

```bash
cd /Users/ishtiaq/Documents/AITechReviews
```

### 4. Run It!

```bash
./scripts/add-articles.sh
```

---

## Step-by-Step Walkthrough

### Step 1: Launch Script

```bash
./scripts/add-articles.sh
```

You'll see:
```
========================================
AITechReviews - Quick Article Adder v1.0
========================================

Select parent category:

  1) buying-guides
  2) gaming
  3) tutorials-guides

📁 Enter category name or number:
```

### Step 2: Select Category

**By number (easiest):**
```
📁 Enter category name or number: 1
✅ Selected category: buying-guides
```

**By name:**
```
📁 Enter category name or number: gaming
✅ Selected category: gaming
```

### Step 3: Select Subcategory

```
Select subcategory:

  1) electronics
  2) furniture
  3) smartphones

📂 Enter subcategory name or number: furniture
✅ Selected subcategory: furniture
```

### Step 4: Specify Article Count

```
📝 Number of articles to create (default: 1): 3
```

Options:
- **Just press Enter** → Creates 1 article
- **Type 5** → Creates 5 articles
- **Type 1** → Creates 1 article

### Step 5: Confirm

```
Ready to create:
   Category: buying-guides
   Subcategory: furniture
   New Articles: 3

Proceed with creation? (y/n): y
```

Type `y` and press Enter.

### Step 6: Script Does Everything

```
========================================
Creating Articles
========================================

✅ Created article: article-1-furniture.md
✅ Created article: article-2-furniture.md
✅ Created article: article-3-furniture.md

========================================
Validating Creation
========================================

✅ 3 articles found in subcategory
✅ Validation passed!

========================================
Summary Report
========================================

📊 Article Addition Summary:
   Category: buying-guides
   Subcategory: furniture
   Total Articles in Subcategory: 3
   Location: /Users/ishtiaq/Documents/AITechReviews/content/buying-guides/furniture

📍 View in browser:
   Category: http://localhost:1313/buying-guides/
   Subcategory: http://localhost:1313/buying-guides/furniture/
   New Articles: Check the subcategory page

========================================
Building Site
========================================

ℹ️  Running Hugo build to regenerate site...
✅ Hugo build completed successfully

✅ Articles added successfully! 🎉
```

**Done!** Articles are created and live.

---

## Editing Your Articles

### View Created Files

```bash
ls -la content/buying-guides/furniture/article-*.md
```

Output:
```
-rw-r--r-- ... article-1-furniture.md
-rw-r--r-- ... article-2-furniture.md
-rw-r--r-- ... article-3-furniture.md
```

### Open in Editor

Open one article:
```bash
code content/buying-guides/furniture/article-1-furniture.md
```

Or open the whole folder:
```bash
code content/buying-guides/furniture/
```

### Edit Content Structure

Each article has:

```markdown
---
[YAML front matter - don't change unless needed]
---

## Introduction
[Your intro text]

## Key Features
- [Feature 1]
- [Feature 2]

## Main Sections
### Section 1
[Your content]

## Comparison Table
[Product comparisons]

## Pros and Cons
### Pros ✅
- [Benefits]

### Cons ❌
- [Limitations]

## Conclusion
[Your conclusion]

## FAQ
[Q&A section]
```

### Minimal Edit Guide

**To publish quickly:**

1. Change title (line 2 in front matter):
   ```yaml
   title: "Best Office Chairs for Remote Workers"
   ```

2. Change description (line 3):
   ```yaml
   description: "Our in-depth review of the top office chairs..."
   ```

3. Replace Introduction section with real content

4. Replace Key Features (2-4 bullet points)

5. Add 1-2 main sections

6. Save and it's live!

**To add media:**

```yaml
youtube_url: "https://youtube.com/watch?v=ABC123XYZ"
instagram_url: "https://instagram.com/username"
```

### View Changes Live

In another terminal:
```bash
hugo server
```

Visit: `http://localhost:1313/buying-guides/furniture/article-1-furniture/`

Changes save automatically as you type!

---

## Understanding Automatic Updates

### What Happens When You Create

1. **Files Created**
   ```
   content/buying-guides/furniture/
   ├── article-1-furniture.md
   ├── article-2-furniture.md
   └── article-3-furniture.md
   ```

2. **Subcategory Page Updates**
   - The `/furniture/` page automatically lists new articles
   - Hugo regenerates `furniture/index.html`
   - Articles appear as clickable links

3. **Category Page Updates**
   - The `/buying-guides/` page shows updated article count
   - Recent articles from all subcategories shown
   - Everything updates automatically

4. **Search Index Updates**
   - New articles added to searchable index
   - Search immediately finds new content
   - Type article title to find it

5. **CSS & Templates Applied**
   - Uses existing `static/css/style.css`
   - Applies `layouts/_default/single.html` for articles
   - Category designs apply automatically

### Timeline

```
User runs script
       ↓
Articles created in content/
       ↓
Hugo scans files (instant)
       ↓
Generates HTML pages (1-2 seconds)
       ↓
Updates search index
       ↓
Articles live on website!
```

---

## Workflow Scenarios

### Scenario 1: Add Single Article

```bash
./scripts/add-articles.sh
# Select: buying-guides
# Select: furniture
# Count: Press Enter (default 1)
# Confirm: y

# Result: 1 new article added to furniture
```

### Scenario 2: Batch Add Articles

```bash
./scripts/add-articles.sh
# Select: buying-guides
# Select: furniture
# Count: 5

# Result: 5 articles added, all ready to edit
```

### Scenario 3: Add to Multiple Subcategories

```bash
# Add to furniture
./scripts/add-articles.sh
# buying-guides → furniture → 3 articles

# Add to electronics
./scripts/add-articles.sh
# buying-guides → electronics → 2 articles

# Add to gaming category
./scripts/add-articles.sh
# gaming → action-games → 4 articles
```

### Scenario 4: Stagger Release

```bash
# Day 1: Add 3 articles, edit/publish 1
./scripts/add-articles.sh
# Create 3, edit article-1-furniture.md, publish

# Day 2: Edit article 2
# Edit article-2-furniture.md, publish

# Day 3: Edit article 3
# Edit article-3-furniture.md, publish
```

---

## Common Issues & Solutions

### Issue 1: "Category not found"

**Problem:** Typed category name doesn't exist

**Solution:**
```bash
# Check available categories
ls content/

# Should see: archives/ authors/ buying-guides/ gaming/ tutorials-guides/

# Use one of those names or numbers
./scripts/add-articles.sh
# Type: buying-guides (or 1 for first)
```

### Issue 2: "Subcategory not found"

**Problem:** Subcategory doesn't exist in category

**Solution:**
```bash
# List subcategories
ls content/buying-guides/

# Should show: electronics/ furniture/ smartphones/ ...

# Use exact name from list
```

### Issue 3: Script says "Already exists"

**Problem:** Article file already exists

**Solution:**
Either:
1. Delete the old article:
   ```bash
   rm content/buying-guides/furniture/article-1-furniture.md
   ```

2. Run script again with different article count

3. Edit the existing file instead

### Issue 4: Articles don't appear on website

**Solution:**

```bash
# 1. Check file exists
ls -la content/buying-guides/furniture/article-1-furniture.md

# 2. Verify front matter (first 10 lines)
head -20 content/buying-guides/furniture/article-1-furniture.md

# 3. Check draft status (should be false)
grep draft: content/buying-guides/furniture/article-1-furniture.md

# 4. Check date isn't in future
grep "date:" content/buying-guides/furniture/article-1-furniture.md

# 5. Rebuild Hugo
hugo

# 6. Check public folder
ls -la public/buying-guides/furniture/article-1-furniture/
```

### Issue 5: Hugo build failed

**Solution:**
```bash
# Check Hugo installation
hugo version

# Try manual build
cd /Users/ishtiaq/Documents/AITechReviews
hugo

# If errors shown, articles usually still created
# Just rebuild manually
```

### Issue 6: Can't find the script

**Solution:**
```bash
# Make sure you're in project directory
cd /Users/ishtiaq/Documents/AITechReviews

# Verify script exists
ls scripts/add-articles.sh

# Make executable
chmod +x scripts/add-articles.sh

# Run it
./scripts/add-articles.sh
```

### Issue 7: Script hangs on input

**Problem:** Script seems frozen after prompt

**Solution:**
- Press Ctrl+C to stop
- Make sure you press Enter after typing
- Try running again

```bash
# Stop current run
Ctrl+C

# Run again
./scripts/add-articles.sh
```

---

## Advanced Tips

### Tip 1: Create Articles Faster with Batch Operations

Instead of running script multiple times:

```bash
# Create 5 articles at once
./scripts/add-articles.sh
# buying-guides → furniture → 5

# Edit all 5 when ready
code content/buying-guides/furniture/
```

Then edit each in tabs in VS Code.

### Tip 2: Use Hugo Server for Instant Previews

Terminal 1:
```bash
hugo server
# Leaves server running
```

Terminal 2:
```bash
./scripts/add-articles.sh
# Create articles
# They immediately appear in browser!
```

Browser auto-refreshes as you save edits.

### Tip 3: Organize Your Editing

Create articles in batches, then edit systematically:

```bash
# Morning: Create 5 articles
./scripts/add-articles.sh

# Afternoon: Edit articles 1-2
code content/buying-guides/furniture/article-1-furniture.md
code content/buying-guides/furniture/article-2-furniture.md

# Next morning: Edit articles 3-5
code content/buying-guides/furniture/article-3-furniture.md
```

### Tip 4: Template Updates

If you want different article content structure, edit the script and modify the template section (around line 200):

```bash
cat > "$article_file" << EOF
---
# Front matter
---

# Your custom sections here
EOF
```

Then new articles use your template.

### Tip 5: Verify Numbering

Articles auto-number sequentially:

```bash
ls content/buying-guides/furniture/article-*.md
# article-1-furniture.md
# article-2-furniture.md
# article-3-furniture.md
# (If you add more)
# article-4-furniture.md  ← Automatic!
```

Script finds the highest number and continues.

---

## FAQ

### Q: How many articles can I add at once?

A: As many as you want! 1, 5, 50, 100… The script handles it.

### Q: Do I need to create the subcategory first?

A: Yes! Use `create-article.sh` script if you need to create a new subcategory first.

### Q: Can I add articles to a category that has no subcategories?

A: No, subcategories are required. Either:
1. Create a subcategory first with `create-article.sh`
2. Add articles to an existing subcategory with this script

### Q: What if I add articles but don't edit them?

A: They publish with template content. Site works fine, but content is generic. Best to edit before publishing.

### Q: Do the articles auto-publish?

A: Yes! They're `draft: false` by default, so they're immediately live.

### Q: Can I make articles draft first, then publish later?

A: Yes! Edit the front matter:
```yaml
draft: true  # Save as draft
```

Then change to `false` when ready.

### Q: Can I delete articles?

A: Yes, just delete the file:
```bash
rm content/buying-guides/furniture/article-3-furniture.md
hugo  # Rebuild
```

### Q: Do I need to update menus manually?

A: No! Hugo automatically lists all articles on subcategory pages.

### Q: Can I reorder articles?

A: Articles display by date (newest first). To change order, edit the `date:` field in front matter:
```yaml
date: 2026-03-22T12:00:00Z  # Change this
```

### Q: Can I copy articles?

A: Sure! 
```bash
cp content/buying-guides/furniture/article-1-furniture.md article-1-copy.md
```

Then edit the new file.

### Q: What if I make mistakes editing?

A: Just re-edit the file! No need to recreate it.

### Q: Do article files have special naming requirements?

A: Keep the format `article-NUMBER-slug.md`. The script handles this automatically.

### Q: Can I add articles without using the script?

A: Yes, manually:
```bash
touch content/buying-guides/furniture/my-article.md
# Then add YAML front matter and content
```

But the script is faster!

---

## Next Steps

1. **Run the script:** `./scripts/add-articles.sh`
2. **Select category and subcategory** from prompts
3. **Specify article count** (start with 1-2)
4. **Review created files:** `ls content/[category]/[subcategory]/`
5. **Edit your articles** with real content
6. **Preview locally:** `hugo server`
7. **Check your subcategory page** to verify
8. **Publish and repeat!**

---

**Questions?** Check [QUICK_START_ADD_ARTICLES.md](QUICK_START_ADD_ARTICLES.md) for quick reference or review the script—it's well-commented explaining each section.

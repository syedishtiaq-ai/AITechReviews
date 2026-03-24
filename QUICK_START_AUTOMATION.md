# AITechReviews - Content Creation Script

**Quick Start Guide for Automated Category & Article Creation**

---

## 🚀 Quick Start (5 Minutes)

### Step 1: Navigate to Project Directory

```bash
cd /Users/ishtiaq/Documents/AITechReviews
```

### Step 2: Run the Script

```bash
./scripts/create-category.sh
```

### Step 3: Follow the Prompts

**Example Input:**
```
📁 Category name: Office Supplies
📂 Subcategories: Desks, Chairs, Storage, Lighting
📝 Articles per subcategory: 2
Proceed? y
```

### Step 4: Test in Browser

```bash
hugo server
```

Visit: `http://localhost:1313/office-supplies/`

---

## 📋 What Gets Created

For input "Office Supplies" with subcategories "Desks, Chairs":

```
content/office-supplies/
├── _index.md                    ← Category index
├── desks/
│   ├── _index.md                ← Subcategory index
│   ├── article-1-desks.md       ← Sample articles
│   └── article-2-desks.md
└── chairs/
    ├── _index.md
    ├── article-1-chairs.md
    └── article-2-chairs.md

layouts/office-supplies/
└── list.html                    ← Category list template
```

**Total: 1 category + 2 subcategories + 4 articles + templates**

---

## ✨ What the Script Automates

✅ **Creates Folder Structure** - All directories and files  
✅ **Generates Article Templates** - With complete front matter  
✅ **Creates Index Pages** - For category and subcategories  
✅ **Generates List Templates** - HTML page templates  
✅ **Updates Search Index** - Runs Hugo build automatically  
✅ **Validates Everything** - Checks all files exist  
✅ **No Manual Hugo Setup** - Script handles all configuration  

---

## 📝 Article Template Generated

Every article includes:

```markdown
---
title: "[Subcategory] - Guide Article [N]"
description: "Comprehensive guide..."
date: 2026-03-22T15:30:00Z
draft: false
tags: ["subcategory", "guide", "review"]
categories: ["main-category"]
author: "James Mitchell"
youtube_url: ""
instagram_url: ""
---

## Introduction
## Key Features
## Detailed Analysis
## Comparison Table
## Pros and Cons
## Conclusion
## FAQ
```

---

## 🧪 Test Run Example

Let's create a test category:

### Run the Script

```bash
./scripts/create-category.sh
```

### Provide Test Input

```
📁 Category name: Tech Accessories
📂 Subcategories: Cables, Chargers, Cases
📝 Articles per subcategory: 2
Proceed with creation? y
```

### Verify Creation

```bash
# Check structures created
ls -la content/tech-accessories/
ls -la layouts/tech-accessories/

# Check article count
find content/tech-accessories -name "*.md" | wc -l
# Should show: 7 (1 category index + 3 subcategory indexes + 3*2 articles)
```

### Test in Browser

```bash
hugo server
# Visit: http://localhost:1313/tech-accessories/
# Visit: http://localhost:1313/tech-accessories/cables/article-1-cables/
```

---

## 🔧 Manual Post-Creation Steps

After running the script:

### 1. Edit Articles

```bash
# Open article and update content
code content/tech-accessories/cables/article-1-cables.md

# Update:
# - title: "Best USB-C Cables 2026"
# - description: Real description
# - content: Replace Lorem ipsum with real content
# - youtube_url: "https://youtube.com/..." (if applicable)
```

### 2. Add to Menu (Optional)

Edit `hugo.toml`:

```toml
[[menu.main]]
name = "Tech Accessories"
url = "/tech-accessories/"
weight = 40
```

### 3. Rebuild

```bash
hugo
```

---

## 📊 Automation Features Explained

### 1. **Automatic Structure Creation**
Instead of manually creating folders, the script:
- Creates `/content/category-name/`
- Creates `/content/category-name/subcategory1/`
- Creates `/content/category-name/subcategory2/`
- Logs each step with ✅

### 2. **Template Generation**
Instead of copying and modifying:
- Generates `_index.md` for category
- Generates `_index.md` for each subcategory
- Generates complete article markdown files
- All with correct front matter

### 3. **List Template Creation**
Instead of manually creating HTML templates:
- Creates `/layouts/category-name/list.html`
- Filters articles by section
- Uses consistent styling

### 4. **Automatic Hugo Build**
Instead of manual `hugo` command:
- Runs Hugo build automatically
- Updates search index (search.json)
- Creates public HTML files
- Generates menu structures

### 5. **Validation & Testing**
Instead of manual verification:
- Checks directory exists
- Checks index files exist
- Counts subcategories
- Verifies file structure
- Provides success report

---

## 💡 Pro Tips

### Create Zero Articles (Structure Only)

Answer `0` for article count. Useful when you have content elsewhere.

### Batch Create Multiple Categories

```bash
./scripts/create-category.sh  # Category 1
./scripts/create-category.sh  # Category 2
./scripts/create-category.sh  # Category 3
```

### Delete & Recreate If Mistake

```bash
rm -rf content/office-supplies/
./scripts/create-category.sh  # Run again
```

### Customize Article Template

Edit the script's article template section (~line 180):

```bash
nano scripts/create-category.sh
# Find the "cat > article_file" section
# Customize the markdown template
```

---

## ⚠️ Common Issues & Solutions

| Issue | Solution |
|-------|----------|
| "Permission denied" | Run: `chmod +x scripts/create-category.sh` |
| "Path not found" | Make sure you're in project root: `cd /Users/ishtiaq/Documents/AITechReviews` |
| Categories don't show in search | Run: `hugo --cleanDestinationDir && hugo` |
| Articles not displaying | Check `layouts/category-name/list.html` exists |
| YAML syntax error | Dates must be: `YYYY-MM-DDTHH:MM:SSZ` |

---

## 📚 Documentation

- **Detailed Guide:** [CONTENT_CREATION_GUIDE.md](CONTENT_CREATION_GUIDE.md)
- **Troubleshooting:** Section in main guide
- **Examples:** Multiple scenarios included

---

## 🎯 What's Automated vs Manual

### Automated by Script ✅
- Folder structure creation
- Index file generation
- Article template creation
- List template generation
- Hugo build and search index update
- File validation

### Manual Post-Creation 📝
- Article content editing
- Adding real titles and descriptions
- Adding YouTube/Instagram URLs
- Menu configuration (optional)
- Custom styling (optional)

---

## 📈 What This Enables

**Before Script:**
- Manually create folders (5 min)
- Manually create files (10 min)
- Manually write front matter (15 min)
- Manually run Hugo (2 min)
- Manual testing (10 min)
- **Total: ~45 minutes per category**

**With Script:**
- Run script (2 min)
- Review output (1 min)
- Edit articles (variable)
- Hugo auto-runs (included)
- **Total: ~5 minutes setup + content time**

**Savings: 40 minutes per category!** ⏰

---

## 🚀 Next - Advanced Enhancements

Future improvements could add:
- AI-generated article outlines
- Auto-generated featured images
- Bulk article creation from CSV
- Automatic SEO meta tags
- Social media preview generators
- Automated content publishing schedule

---

## 📞 Getting Help

### Script Not Working?

1. Check this Quick Start guide
2. Read [CONTENT_CREATION_GUIDE.md](CONTENT_CREATION_GUIDE.md)
3. Check Troubleshooting section
4. Review script output messages (they indicate exact issues)

### Need to Modify Script?

The script is fully commented (650+ lines) and uses standard bash. Edit around:
- Line 55: Input prompts
- Line 180: Article template
- Line 210: Category index template

---

## ✅ Ready to Test?

```bash
cd /Users/ishtiaq/Documents/AITechReviews
./scripts/create-category.sh
```

**Follow the interactive prompts and test creation in ~5 minutes!**

---

**Version:** 1.0  
**Last Updated:** March 22, 2026  
**Status:** Ready for Production Use

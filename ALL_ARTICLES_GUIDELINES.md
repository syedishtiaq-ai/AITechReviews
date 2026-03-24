---
title: "All Articles Page - Future Category Guidelines"
---

## Overview

The "All Articles" page has been created with **dynamic category detection**. This means it will automatically include new article categories you add in the future!

---

## How It Works Now

### Category Tab Generation (Dynamic)
- **Location:** `layouts/articles/list.html` (line ~25-40)
- **Logic:** Automatically scans all articles and extracts unique categories from front matter
- **Result:** Category tabs are generated dynamically from actual article data

### Article Query (Dynamic)
- **Location:** `layouts/articles/list.html` (line ~60-66)
- **Logic:** Queries ALL regular pages, then excludes non-article sections (archives, authors, search)
- **Benefit:** Any new article section automatically appears

### Tag Cloud (Dynamic)
- **Location:** `layouts/partials/articles/filters-sidebar.html` (line ~14-38)
- **Logic:** Scans all articles across all sections and displays up to 15 unique tags
- **Benefit:** New tags automatically appear as articles are added

---

## What This Means For Your Scripts

### ✅ Good News
You **DO NOT need to update your existing scripts** (`create-article.sh`, `add-articles.sh`, `create-category.sh`, `manage-articles.sh`) for the "All Articles" page to work!

### How to Add New Categories in the Future

**Option A: Organize as Subcategories** (Recommended - Current Pattern)
- Add under existing categories: `/content/buying-guides/new-subcategory/`
- Example: `/content/buying-guides/smart-home/` (subcategory under Buying Guides)
- These articles will automatically appear on the All Articles page
- Already works with your current scripts

**Option B: Create New Top-Level Category** (New Structure)
- Create new section: `/content/new-category/`
- Add articles: `/content/new-category/article-name.md`
- These will automatically appear on All Articles page

#### Important: If You Add New Top-Level Categories

If you create a **new top-level category** section (e.g., `/content/electronics/`, `/content/software/`):

1. **Scripts still work** - They'll create articles fine
2. **All Articles page updates automatically** - New category appears immediately
3. **HomePage might need updating** - To showcase the new category in the carousel
4. **Navigation might need updating** - To add a menu item for the new category

---

## Files Modified This Session

### Content
- ✅ `content/articles/_index.md` - New page for all articles

### Layouts
- ✅ `layouts/articles/list.html` - Dynamic category tabs and article query
- ✅ `layouts/partials/articles/filters-sidebar.html` - Dynamic tag cloud

### Styles
- ✅ `static/css/articles.css` - Added comprehensive sidebar and category tab styling

---

## Features That Now Work Automatically

| Feature | Auto-Detects | Status |
|---------|---------|--------|
| Category Tabs | ✅ Yes | Updates when articles are added |
| Tag Cloud | ✅ Yes | Updates based on article tags |
| Article Count | ✅ Yes | Shows all articles from all sections |
| Search | ✅ Yes | Works across all sections |
| Sorting | ✅ Yes | Works on any number of articles |

---

## When You DO Need Manual Updates

| Scenario | What to Update |
|----------|---------|
| Add new top-level category | Update homepage carousel (if desired) |
| Add new top-level category | Update main navigation menu |
| Change section name | Update Hugo config & file paths |
| Remove a section | Remove from navigation manually |

---

## Testing Future Additions

After adding new articles or categories:
1. Run: `hugo --cleanDestinationDir`
2. Check `public/articles/` - New categories will appear in tabs
3. New tags appear automatically in the sidebar
4. Article count updates automatically

---

## Key Takeaway

**Your scripts don't need changes!** The All Articles page is now fully dynamic and will adapt to any new articles or categories you add. Just create new articles with the existing scripts, and they'll automatically appear on the All Articles page. 🎉

# Quick Reference - Folder Structure & Cleanup

## Files Created Today

| File | Purpose | When to Use |
|------|---------|------------|
| `.gitignore` | Blocks old structure re-addition | Always active |
| `cleanup-structure.sh` | Automated cleanup script | Monthly or when needed |
| `FOLDER_STRUCTURE_GUIDE.md` | Complete prevention rules | Reference guide |
| `CLEANUP_COMPLETE.md` | What was fixed today | Understand the issue |

## Common Tasks

### Add a New Article
```bash
# 1. Create markdown file in section root
cp my-article.md content/buying-guides/

# 2. Edit YAML (minimum):
# ---
# title: "My Article"
# category: "Buying Guides"
# date: 2026-03-24
# ---

# 3. Build
hugo --cleanDestinationDir
```

### Verify Structure is Clean
```bash
bash cleanup-structure.sh
```

### Check if Something is Ignored
```bash
git check-ignore -v content/product-reviews/
git check-ignore -v content/buying-guides/electronics/posts.json
```

### Emergency: Restore Clean Structure
```bash
bash cleanup-structure.sh
# OR
git checkout content/
hugo --cleanDestinationDir
```

## Structure Rules (Cheat Sheet)

### ✅ Correct
```
content/buying-guides/
├── _index.md
├── article1.md
├── article2.md
├── subcategory/
│   └── _index.md (only this!)
```

### ❌ Wrong
```
content/buying-guides/
├── subcategory/
│   ├── _index.md
│   └── article.md      ← WRONG! Article in subfolder
├── posts.json          ← WRONG! Old format
└── all/                ← WRONG! Should not exist
```

## Front Matter Template

```yaml
---
title: "Article Title Here"
description: "Short description for meta tags"
featured_image: "/images/articles/image.jpg"
excerpt: "Short teaser text"
author: "Author Name"
category: "Buying Guides"        # Required
subcategory: "Electronics"       # Optional but recommended
tags:
  - Technology
  - Review
  - Featured
date: 2026-03-24T10:00:00Z
draft: false
---
```

## Git Key Commands

```bash
# Check current changes
git status

# See what's being ignored
cat .gitignore

# Verify nothing from old structure exists in git
git ls-tree -r HEAD content/product-reviews/

# Push to remote
git add .
git commit -m "Your message"
git push origin main
```

## Folder Depth Rules

| Level | Usage | Max Items |
|-------|-------|-----------|
| Level 0 | Root | 1 |
| Level 1 | Sections (buying-guides, gaming, etc.) | Unlimited |
| Level 2 | Subcategories (achievements, electronics) | Unlimited |
| Level 3+ | ❌ NOT ALLOWED | N/A |

## Directory Structure Map

```
content/                       ← Root
├── buying-guides/             ← Section 1
│   ├── _index.md              ← Section page
│   ├── article1.md            ← Flat articles
│   ├── article2.md
│   └── electronics/           ← Subcategory (Level 2)
│       └── _index.md          ← Category page only
├── gaming/                     ← Section 2
│   ├── _index.md
│   ├── achievement1.md
│   └── achievements/          ← Subcategory
│       └── _index.md
└── tutorials-guides/          ← Section 3
    └── ...
```

## What .gitignore Protects Against

```
❌ Blocked Patterns:
- content/product-reviews/     (Old main section)
- content/*/*/posts.json       (Old JSON files)
- content/*/all/               (Old all-articles folder)
- public/                      (Hugo build output)
- .DS_Store                    (Mac files)
```

## Monthly Maintenance

Run once a month to ensure structure integrity:

```bash
# Run the automated checker
bash cleanup-structure.sh

# Should show:
# ✓ No old structure patterns found - CLEAN!
# ✓ Hugo build completed
```

## Troubleshooting

### Q: I see old folders back in the editor
**A:** Run `bash cleanup-structure.sh` to delete them

### Q: Articles not showing up
**A:** Verify:
1. Article is in section root, not subfolder
2. YAML has required fields (title, date, category)
3. `draft: false` is set
4. Run `hugo --cleanDestinationDir`

### Q: Can't delete a folder
**A:** Use the cleanup script instead: `bash cleanup-structure.sh`

### Q: Accidentally committed old structure
**A:** Git will block it now with `.gitignore`

## Contact/Reference

- **Structure Guide**: See `FOLDER_STRUCTURE_GUIDE.md`
- **Cleanup Details**: See `CLEANUP_COMPLETE.md`
- **Automation**: See `cleanup-structure.sh`
- **Protection**: See `.gitignore`

---

**Last Updated**: March 24, 2026  
**Status**: ✅ All systems protected and clean

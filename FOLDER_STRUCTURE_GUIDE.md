# AITechReviews - Folder Structure Guide & Prevention

## Current Clean Structure ✅

Your website now uses a **flat article structure** instead of nested subfolders:

```
content/
├── buying-guides/              ← Main section
│   ├── _index.md               ← Category page
│   ├── electronics.md          ← Article (flat)
│   ├── best-laptops.md         ← Article (flat)
│   ├── wireless-headphones.md  ← Article (flat)
│   └── home-appliances/        ← Subcategory folder (ONLY for _index.md)
│       └── _index.md           ← Subcategory description only
├── gaming/
│   ├── _index.md
│   ├── achievements/           ← Subcategory folder
│   │   ├── _index.md           ← Only this goes here
│   │   ├── bg3-trophies.md
│   │   └── ac-valhalla.md
└── tutorials-guides/
    ├── _index.md
    └── ...
```

## Rules to Follow (CRITICAL) 🚨

### ✅ DO:
1. **Place articles directly in section folder**: `content/buying-guides/*.md`
2. **Use subcategory folders only for taxonomy**: `content/gaming/achievements/_index.md`
3. **Flat structure = one level only**: No deep nesting
4. **Use front matter for metadata**: Category in YAML, not folder structure

### ❌ DON'T:
1. **Don't create nested category folders**: ❌ `content/buying-guides/electronics/accessories/`
2. **Don't put articles inside subfolders**: ❌ `content/buying-guides/electronics/best-laptops.md`
3. **Don't create `posts.json` files**: Legacy structure, replaced by markdown
4. **Don't create `/all/` directories**: Old structure, not needed
5. **Don't mix old and new structure**: Pick one, stick with it

## Folder Purpose Reference

### Section Folders (Top-level)
- `content/buying-guides/` - All buying guide articles (flat)
- `content/gaming/` - All gaming articles (flat or organized by achievement type)
- `content/tutorials-guides/` - All tutorial articles (flat or by topic)

### Subcategory Folders (Exception - taxonomy only)
- **Purpose**: Organize articles for display in Hugo's taxonomy
- **Content**: ONLY `_index.md` (no articles!)
- **Example**: `content/gaming/achievements/_index.md` describes the achievement category
- **Articles**: Still placed in parent folder

### Special Folders
- `content/authors/` - Author profiles
- `content/archives/` - (if used) archived articles
- `content/search/` - Search functionality

## Example: Adding New Articles

### Wrong ❌
```bash
# DON'T DO THIS
mkdir content/buying-guides/electronics/phones
cp smartphone-review.md content/buying-guides/electronics/phones/
```

### Correct ✅
```bash
# DO THIS
cp smartphone-review.md content/buying-guides/
# Edit YAML front matter:
# category: "Buying Guides"
# subcategory: "Mobile Gadgets"
```

## Front Matter Reference

Every article should have proper YAML metadata:

```yaml
---
title: "Best Budget Laptops 2026"
description: "Top 5 affordable laptops for work and study"
category: "Buying Guides"          # ← Category metadata (NOT folder)
subcategory: "Electronics"         # ← Optional subcategory
tags:
  - Laptops
  - Budget
  - Technology
author: "Tech Reviewer"
date: 2026-03-24
---
```

## .gitignore Protection

The `.gitignore` file now protects against:

```
# Old structure - DO NOT RESTORE
content/product-reviews/         ← Old main section
content/*/*/posts.json           ← Old JSON format
content/*/all/                   ← Old all-posts folder
```

These patterns will prevent accidental re-addition of old structure.

## Prevention Checklist 📋

Before creating any new article or folder:

- [ ] Am I creating files in the section root? (`/buying-guides/*.md`)
- [ ] Did I check for existing nested folders to avoid?
- [ ] Do I have proper YAML front matter with category/subcategory?
- [ ] Is my folder structure at most 2 levels deep?
- [ ] Am I avoiding `posts.json` or `all/` directories?
- [ ] Does my article use the flat structure pattern?

## Common Mistakes & How to Avoid Them

### Mistake 1: Creating nested categories
```bash
# ❌ WRONG - Creates buying-guides/electronics/laptops/
mkdir -p content/buying-guides/electronics/laptops
```

**Fix**: Use flat structure
```bash
# ✅ RIGHT - Stays in buying-guides/
# Content: best-gaming-laptops.md with subcategory: "Electronics"
```

### Mistake 2: Using old posts.json format
```bash
# ❌ OLD - Don't do this
content/buying-guides/electronics/posts.json
```

**Fix**: Use markdown files directly
```bash
# ✅ NEW - All articles as .md files
content/buying-guides/best-laptops.md
content/buying-guides/wireless-headphones.md
```

### Mistake 3: Deep nesting for organization
```bash
# ❌ Overcomplicated
content/buying-guides/electronics/computers/gaming/asus-rog.md
```

**Fix**: Use flat with metadata
```bash
# ✅ Simple
content/buying-guides/asus-rog-review.md
category: "Buying Guides"
subcategory: "Gaming Computers"
tags: ["Gaming", "ASUS", "Laptops"]
```

## How This Works with Hugo

Hugo processes your structure as follows:

1. **Section Detection**: Folder name = section (`buying-guides`, `gaming`)
2. **Content Files**: All `*.md` files at section root are articles
3. **Taxonomy**: Subcategory folders + `_index.md` create taxonomy pages
4. **Flat is Fast**: Fewer nested folders = faster builds + simpler management

## Disaster Recovery

If you accidentally create old structure again:

```bash
# Run the cleanup script
bash cleanup-structure.sh

# OR manually delete
rm -rf content/buying-guides/electronics/
# (Keep only: _index.md, best-laptops.md, wireless-headphones.md)

# Rebuild
hugo --cleanDestinationDir
```

## Summary

| Aspect | Old Structure ❌ | New Structure ✅ |
|--------|-----------------|-----------------|
| Articles | Nested folders | Flat files |
| Format | `posts.json` | Markdown `.md` |
| Metadata | Folder structure | YAML front matter |
| Depth | 3+ levels | Max 2 levels |
| Maintenance | Complex | Simple |
| Build speed | Slower | Faster |
| Scalability | Limited | Unlimited |

---

**Last Updated**: March 24, 2026  
**Cleanup Script**: `cleanup-structure.sh`  
**Protection File**: `.gitignore`

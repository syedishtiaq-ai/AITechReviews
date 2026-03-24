# AITechReviews Scripts Directory

## Overview

This directory contains utility scripts for managing articles and content in the AITechReviews website.

⚠️ **IMPORTANT**: These scripts have been updated to work with the **FLAT ARTICLE STRUCTURE** (new as of March 24, 2026). See below for details.

---

## Flat Structure Scripts (RECOMMENDED) ✅

### create-article-flat.sh
**Purpose**: Create a single new article with interactive prompts  
**Usage**: 
```bash
./scripts/create-article-flat.sh
```

**Features**:
- Prompts for title, description, author, subcategory
- Generates article ID automatically
- Creates proper YAML front matter
- Places article directly in section root (flat structure)

**Output**: `content/{section}/{slug}.md`

**Example**:
```bash
./scripts/create-article-flat.sh
# Select: buying-guides
# Category: Electronics
# Title: Best Budget Laptops 2026
# → Creates: content/buying-guides/best-budget-laptops-2026.md
```

---

### add-articles-flat.sh
**Purpose**: Quickly create multiple article templates in a section  
**Usage**:
```bash
./scripts/add-articles-flat.sh
```

**Features**:
- Create 1+ articles at once
- Interactive input for each article
- Bulk template generation
- Subcategory optional but recommended

**Output**: `content/{section}/{slug}.md` (multiple files)

**Example**:
```bash
./scripts/add-articles-flat.sh
# Select: gaming
# Number of articles: 3
# → Creates 3 article templates in content/gaming/
```

---

### assign-article-ids-flat.sh
**Purpose**: Assign or update unique article IDs across all sections  
**Usage**:
```bash
./scripts/assign-article-ids-flat.sh
```

**Features**:
- Scans all sections for articles
- Generates unique IDs based on: 
  - Section code (BG, GM, TG)
  - Subcategory code (EL, HA, AC, etc.)
  - Date created (YYMMDD)
  - Sequential number (001, 002, etc.)
- Updates existing article_id fields
- Skips articles with invalid subcategories

**ID Format**: `BG-EL-260324-001` (Section-Subcategory-Date-Number)

**Example**:
```bash
./scripts/assign-article-ids-flat.sh
# Article ID Assignment (Flat Structure)
# Processing section: buying-guides
# ✅ Updated laptop-review.md - ID: BG-EL-260324-001
# ✅ Added headphones.md - ID: BG-EL-260324-002
```

---

## Old (Nested Structure) Scripts ⛔ DEPRECATED

The following scripts are **NOT compatible** with the new flat structure:
- `create-article.sh` - ❌ Creates nested subfolders
- `create-category.sh` - ❌ Creates category + subfolder structure
- `add-articles.sh` - ❌ Expects nested folders
- `assign-article-ids.sh` - ❌ Looks for articles in subfolders
- `assign-article-ids-v2.sh` - ❌ Same issue as above

**DO NOT USE THESE** - they will create the nested folder structure we've eliminated.

---

## Always Use These Scripts

### manage-articles.sh
**Purpose**: Delete, archive, or restore articles  
**Status**: ✅ Works with flat structure

**Usage**:
```bash
# Delete article
./scripts/manage-articles.sh delete BG-EL-260324-001

# Archive article
./scripts/manage-articles.sh archive BG-EL-260324-001

# Auto-archive old articles
./scripts/manage-articles.sh auto-archive

# List archived articles
./scripts/manage-articles.sh list-archives

# Restore article
./scripts/manage-articles.sh restore BG-EL-260324-001
```

**Note**: Uses article IDs (not filenames), works with flat structure ✅

---

## Article Subcategory Codes

When creating articles, select one of these subcategories:

### Buying Guides
| Subcategory | Code |
|-------------|------|
| Electronics | EL |
| Home Appliances | HA |
| Mobile Gadgets | MG |

### Gaming
| Subcategory | Code |
|-------------|------|
| Achievements | AC |
| Guides | GD |
| Walkthroughs | WK |

### Tutorials & Guides
| Subcategory | Code |
|-------------|------|
| Equipment | EQ |
| Repair Guides | RG |
| Software | SW |

---

## Workflow Examples

### Create 1 Article
```bash
./scripts/create-article-flat.sh
```
Result: Interactive form, creates single article with auto-generated ID

### Create 5 Articles at Once
```bash
./scripts/add-articles-flat.sh
```
Result: Interactive prompts for each, creates 5 templates

### Fix All Article IDs
```bash
./scripts/assign-article-ids-flat.sh
```
Result: Scans all articles, assigns IDs based on subcategory

### Manage Articles
```bash
# Archive an article
./scripts/manage-articles.sh archive BG-EL-260324-001

# Restore it later
./scripts/manage-articles.sh restore BG-EL-260324-001
```

---

## Folder Structure (Flat)

```
content/
├── buying-guides/           ← Section
│   ├── _index.md            ← Section index (required)
│   ├── best-laptops.md      ← Article (flat)
│   ├── wireless-headphones.md ← Article (flat)
│   ├── electronics/         ← Taxonomy folder
│   │   └── _index.md        ← Category description only
│   └── home-appliances/     ← Taxonomy folder
│       └── _index.md        ← Category description only
├── gaming/
│   ├── _index.md
│   ├── zelda-guide.md
│   └── achievements/
│       └── _index.md
└── tutorials-guides/
    ├── _index.md
    └── ...
```

**Key Rules**:
✅ Articles directly in section root: `content/{section}/*.md`
✅ Subcategory folders only for `_index.md`
✅ Maximum 2 directory levels
✅ Use YAML front matter for categories

---

## Verify Your Setup

Run this monthly to ensure structure is correct:

```bash
bash cleanup-structure.sh
```

This will:
- Delete any accidental nested folders
- Verify .gitignore protection
- Check all articles are in correct locations
- Rebuild Hugo
- Show status report

---

## Troubleshooting

### Issue: Script says "no code mapping for section"
**Solution**: Check that category name matches one of:
- `buying-guides` (not `buying_guides`)
- `gaming` (not `Gaming`)
- `tutorials-guides` (not `tutorials_guides`)

### Issue: Article ID not assigned
**Solution**: Make sure article has a valid `subcategory:` field matching the table above.

### Issue: Article disappeared after running script
**Solution**: Check git and .gitignore:
```bash
git status
cat .gitignore
```

### Issue: Old scripts keep creating nested folders
**Solution**: DELETE the old scripts or move them to archive:
```bash
rm scripts/create-article.sh
rm scripts/create-category.sh
rm scripts/add-articles.sh
```

---

## File Manifest

| File | Purpose | Status |
|------|---------|--------|
| `create-article-flat.sh` | Create single article interactive | ✅ New |
| `add-articles-flat.sh` | Create multiple articles interactive | ✅ New |
| `assign-article-ids-flat.sh` | Assign/update article IDs | ✅ New |
| `manage-articles.sh` | Archive/delete/restore articles | ✅ Works |
| `create-article.sh` | Create article (nested) | ⛔ Old |
| `create-category.sh` | Create category (nested) | ⛔ Old |
| `add-articles.sh` | Add articles (nested) | ⛔ Old |
| `assign-article-ids.sh` | Assign IDs (nested) | ⛔ Old |
| `assign-article-ids-v2.sh` | Assign IDs (nested v2) | ⛔ Old |
| `article-archival-config.txt` | Config for archive script | ✅ Works |

---

## Next Steps

1. **Use the new scripts**: `create-article-flat.sh`, `add-articles-flat.sh`
2. **Archive old scripts**: Remove or move to old-scripts/ folder
3. **Monthly maintenance**: Run `bash cleanup-structure.sh`
4. **Reference guide**: See `FOLDER_STRUCTURE_GUIDE.md`

---

**Last Updated**: March 24, 2026  
**Flat Structure Introduced**: March 24, 2026  
**Status**: All systems ready ✅

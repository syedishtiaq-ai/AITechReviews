# Article ID Quick Reference Card

## ID Format Cheat Sheet

```
{CATEGORY-CODE}-{DATE}-{NUMBER}
 └─ 2 letters   └─ YYMMDD      └─ 001-999
```

**Example:** `BG-EL-260316-001`
- `BG` = Buying Guides
- `EL` = Electronics
- `260316` = March 16, 2026
- `001` = First article that day

---

## Category Codes

### Main Categories (1st letter pair)
| Code | Meaning |
|------|---------|
| **BG** | Buying Guides |
| **GM** | Gaming |
| **TG** | Tutorials & Guides |

### Subcategories (2nd letter pair)

**Buying Guides (BG-)**
| Code | Subcategory |
|------|-------------|
| EL | Electronics |
| HA | Home Appliances |
| MG | Mobile Gadgets |

**Gaming (GM-)**
| Code | Subcategory |
|------|-------------|
| AC | Achievements |
| GD | Guides |
| WK | Walkthroughs |

**Tutorials & Guides (TG-)**
| Code | Subcategory |
|------|-------------|
| EQ | Equipment |
| RG | Repair Guides |
| SW | Software |

---

## Current Status

✅ **26 articles** have unique IDs
- Buying Guides: 7 articles
- Gaming: 8 articles  
- Tutorials & Guides: 11 articles

**Total:** 26 articles identifiable by unique ID

---

## How to Find an Article by ID

### Search by exact ID
```bash
grep -r "article_id: \"BG-EL-260316-001\"" content/
# Result: content/buying-guides/electronics/best-laptops.md
```

### Search by category
```bash
grep -r "article_id: \"BG-" content/buying-guides/
# Returns all Buying Guide articles with their IDs
```

### Search by date
```bash
grep -r "article_id: \".*-260316-" content/
# Returns all articles published on March 16, 2026
```

---

## Common ID Examples

| ID | Article | Category |
|----|---------|----------|
| BG-EL-260316-001 | Best Laptops for 2026 | Buying Guides / Electronics |
| BG-MG-260220-001 | Smartphone Review 1 | Buying Guides / Mobile Gadgets |
| GM-AC-260315-001 | Elden Ring Achievements | Gaming / Achievements |
| GM-GD-260317-001 | Advanced Gaming Tactics | Gaming / Guides |
| TG-RG-260223-001 | Laptop Screen Repair | Tutorials / Repair Guides |
| TG-SW-260220-001 | Windows Optimization | Tutorials / Software |

---

## Creating New Articles

All scripts automatically generate IDs:

```bash
# Add articles to existing category
./scripts/add-articles.sh
# ✅ New articles get auto-generated IDs like: BG-EL-260324-002

# Create new category with articles
./scripts/create-category.sh
# ✅ New articles get auto-generated IDs like: BG-HA-260325-001

# Create single article
./scripts/create-article.sh
# ✅ New article gets auto-generated ID like: GM-WK-260326-001
```

---

## ID Field in Article (YAML)

```yaml
---
article_id: "BG-EL-260316-001"
title: "Best Laptops for 2026"
featured_image: "/images/articles/best-laptops.svg"
description: "Comprehensive laptop reviews and buying guide"
# ... rest of metadata
---
```

**Position:** Always immediately after opening `---` line

---

## Reference by ID

### In Markdown
```markdown
See article [BG-EL-260316-001](../buying-guides/electronics/best-laptops.md) 
for laptop recommendations.
```

### In Hugo Templates
```html
<!-- Article ID: {{ .Params.article_id }} -->
<!-- Example output: Article ID: BG-EL-260316-001 -->
```

### In Documentation
"For more details, refer to article BG-RG-260223-001 (Laptop Screen Repair Guide)."

---

## Quick Commands

```bash
# List all article IDs
grep -r "article_id:" content/ | cut -d: -f3 | sort

# Count articles with IDs
grep -r "article_id:" content/ | wc -l

# Find articles by date
grep -r "article_id:.*-260316-" content/

# Show article ID and title
grep -A 1 "article_id:" content/**/*.md | grep -E 'article_id|title'

# Assign IDs to new articles (if needed)
bash scripts/assign-article-ids-v2.sh
```

---

## Date Format Reference

The date part of ID is **YYMMDD**:

| Format | Example | Meaning |
|--------|---------|---------|
| Individual | 260316 | March 16, 2026 |
| By Year | 26**** | Any 2026 article |
| By Month | *0316 | Any March 16th |
| Regex | `26031[0-9]` | March 10-19, 2026 |

---

## Limitations & Limits

- **Max per day/category:** 999 articles
- **Sequential format:** Always 001-999 (zero-padded)
- **Date format:** Only works until year 99 (2099)
- **Category codes:** 9 combinations available (3×3 matrix)

---

## Tips & Best Practices

✅ **Always reference articles by ID** in documentation  
✅ **Share IDs** instead of filenames when discussing articles  
✅ **Sort articles** by ID for chronological organization  
✅ **Archive articles** with their ID for future reference  
✅ **Never duplicate** IDs - scripts prevent this  
✅ **Keep article_id field** as first metadata field for consistency  

---

## Need Help?

- **Full documentation:** See `ARTICLE_ID_SYSTEM.md`
- **Implementation details:** See `ARTICLE_ID_IMPLEMENTATION.md`
- **Scripts help:** Run `./scripts/add-articles.sh --help`

---

**🎯 Quick Lookup:** All article IDs are human-readable, permanent, and never duplicate across your entire website.

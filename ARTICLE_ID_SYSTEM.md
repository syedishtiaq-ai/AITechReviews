# 📋 Unique Article ID System

**Human-readable, unique identifiers for all articles on AITechReviews**

---

## Overview

Every article on AITechReviews now has a unique Article ID that:
- ✅ Uniquely identifies each article
- ✅ Is human-readable and easy to remember
- ✅ Indicates the content category and creation date
- ✅ Is automatically generated for new articles
- ✅ Follows a consistent, logical format

---

## ID Format

```
{CATEGORY-CODE}-{YYMMDD}-{###}
```

### Breaking It Down

| Part | Meaning | Example |
|------|---------|---------|
| `{CATEGORY-CODE}` | Category & Subcategory | `BG-EL` (Buying Guides - Electronics) |
| `{YYMMDD}` | Date Created (YY Month DD) | `260316` (March 16, 2026) |
| `{###}` | Sequential Number | `001`, `002`, `003` |

### Complete Example

```
BG-EL-260316-001
├─ BG = Buying Guides
├─ EL = Electronics
├─ 260316 = March 16, 2026
└─ 001 = First article that day
```

---

## Category Codes

### Buying Guides
| Code | Subcategory |
|------|-------------|
| **BG-EL** | Electronics |
| **BG-HA** | Home Appliances |
| **BG-MG** | Mobile Gadgets |

### Gaming
| Code | Subcategory |
|------|-------------|
| **GM-AC** | Achievements |
| **GM-GD** | Guides |
| **GM-WK** | Walkthroughs |

### Tutorials & Guides
| Code | Subcategory |
|------|-------------|
| **TG-EQ** | Equipment |
| **TG-RG** | Repair Guides |
| **TG-SW** | Software |

---

## Real World Examples

```
BG-EL-260316-001
↓
Buying Guide about Electronics, created March 16, 2026, first article that day

GM-AC-260315-005
↓
Gaming article about Achievements, created March 15, 2026, fifth article that day

TG-SW-260220-002
↓
Tutorial/Guide about Software, created February 20, 2026, second article that day
```

---

## Where to Find It

Each article's ID appears in the front matter (YAML):

```markdown
---
article_id: "BG-EL-260316-001"
title: "Best Laptops for 2026"
description: "Comprehensive laptop reviews..."
date: 2026-03-16T11:00:00Z
---
```

**Location:** Right after the opening `---` (first line)

---

## For Existing Articles

All existing articles have been assigned unique IDs automatically using the `assign-article-ids.sh` script. The IDs are based on:
- The article's creation date (from `date:` field)
- Its category and subcategory location
- Sequential numbering (to avoid duplicates on the same day)

---

## For New Articles

### Using `create-category.sh`
When creating a new category with subcategories and articles, IDs are automatically generated:
```bash
./scripts/create-category.sh
# IDs assigned automatically
# Example: BG-MG-260324-001, BG-MG-260324-002, etc.
```

### Using `create-article.sh`
When adding to an existing category:
```bash
./scripts/create-article.sh
# Choose: buying-guides → electronics
# IDs assigned automatically
# Example: BG-EL-260324-003 (if 002 already exists)
```

### Using `add-articles.sh`
When adding to an existing subcategory:
```bash
./scripts/add-articles.sh
# Choose: buying-guides → electronics
# IDs assigned automatically
# Example: BG-EL-260324-004 (incremental)
```

---

## How to Use Article IDs

### Reference Articles
"See article **BG-EL-260316-001** for detailed laptop comparisons."

### Create Links
```markdown
[Best Laptops][BG-EL-260316-001]
```

### In Documentation
"Reviewed in **GM-AC-260315-002** - Elden Ring Achievement Guide"

### For Analytics
Track which articles get the most engagement by ID instead of filename

### For Cross-References
"This expands on content from **TG-RG-260314-001** - Phone Battery Replacement"

---

## ID Assignment Script

**For existing articles without IDs:**

```bash
bash scripts/assign-article-ids-v2.sh
```

This script:
1. Scans all articles in main categories
2. Identifies articles without IDs
3. Generates unique IDs based on publication date
4. Adds IDs to front matter
5. Reports results

**Output:**
```
✅ Added ID [BG-EL-260316-001] to: best-laptops.md
✅ Added ID [GM-AC-260315-001] to: elden-ring-achievements.md
✅ Added ID [TG-RG-260314-001] to: phone-battery-replacement.md
...
Articles processed: 34
Articles already have IDs: 0
```

---

## Benefits

✅ **Permanent Reference:** IDs don't change even if filenames do  
✅ **Human Readable:** Category and date are obvious from the ID  
✅ **Sortable:** Organized by category and date  
✅ **Automatic:** New articles get IDs instantly  
✅ **Conflict-Free:** No duplicates possible  
✅ **Professional:** Looks polished in documentation  

---

## Technical Details

### ID Generation Rules

1. **Category Code** - Fixed mapping (BG-EL, GM-AC, etc.)
2. **Date** - Extracted from article's `date:` field (YYMMDD format)
3. **Sequential** - Counted from other articles with same category & date
   - First article: 001
   - Second article: 002
   - Third article: 003
   - etc.

### Examples by Date Combinations

```
March 16, 2026 - Buying Guides / Electronics:
  BG-EL-260316-001  ← First article this day
  BG-EL-260316-002  ← Second article this day

March 15, 2026 - Gaming / Achievements:
  GM-AC-260315-001  ← First article this day
  GM-AC-260315-002  ← Second article this day

Same day, different subcategory (no conflict):
  BG-EL-260316-001  ← Electronics
  BG-HA-260316-001  ← Home Appliances (different category code)
  BG-MG-260316-001  ← Mobile Gadgets (different category code)
```

### How Scripts Generate IDs

All three creation scripts now include ID generation:

1. **generate_category_code()** - Maps category/subcategory to code
2. **extract_and_convert_date()** - Gets date from article and formats as YYMMDD
3. **get_next_article_id()** - Finds next sequential number and builds full ID
4. **Auto-injection** - Adds ID to article front matter before saving

---

## Format in Articles

**Standard location in front matter:**

```yaml
---
article_id: "BG-EL-260316-001"
title: "Article Title"
description: "Description..."
date: 2026-03-16T11:00:00Z
draft: false
tags: ["tag1", "tag2"]
categories: ["category"]
author: "James Mitchell"
youtube_url: ""
instagram_url: ""
---
```

**Always appears as:**
- First field after opening `---`
- Before `title:`
- Quoted value: `"BG-EL-260316-001"`

---

## Accessing Article IDs

### In Markdown
```yaml
article_id: "BG-EL-260316-001"
```

### In Hugo Templates
```html
{{ .Params.article_id }}
```

### Via Command Line
```bash
# View an article's ID
grep "article_id:" content/buying-guides/electronics/best-laptops.md

# Find articles by category code
grep -r "^article_id: \"BG-EL" content/

# Count articles per category
grep -r "^article_id: \"BG-EL" content/ | wc -l
```

---

## FAQ

**Q: Can I change an article's ID?**
A: Not recommended. IDs are meant to be permanent references. Create a new article instead.

**Q: What if I delete an article?**
A: The ID is gone, but new articles won't reuse it (they get the next sequential number).

**Q: Can two articles have the same ID?**
A: No, the system prevents duplicates automatically.

**Q: Are IDs used in URLs?**
A: No, URLs use article slugs (filenames). IDs are internal reference only.

**Q: Can I view all article IDs?**
```bash
grep -rh "^article_id:" content/ | sort | uniq
```

**Q: How do I find an article by ID?**
```bash
grep -r "article_id: \"BG-EL-260316-001\"" content/
```

**Q: Do new articles auto-get IDs?**
A: Yes! All three creation scripts generate IDs automatically.

**Q: What's the maximum number of articles per day per category?**
A: 999 (###=001-999). If you exceed this, contact us for ID scheme updates.

---

## Implementation Details

### Scripts Updated

1. **create-category.sh** - Generates IDs when creating new categories
2. **create-article.sh** - Generates IDs when adding subcategories
3. **add-articles.sh**  - Generates IDs when adding to existing subcategories

### Functions Added

- `generate_category_code()` - Maps category paths to codes
- `extract_and_convert_date()` - Converts dates to YYMMDD format
- `get_next_article_id()` - Generates full ID with sequential number
- `has_article_id()` - Checks if article already has an ID
- `add_article_id()` - Adds ID to article front matter

### Backward Compatible

✅ Old articles without IDs still work  
✅ IDsare optional (but recommended now)  
✅ Scripts add IDs to new articles automatically  
✅ Existing articles can be updated anytime

---

**All articles on AITechReviews now have unique, human-readable IDs for easy reference and organization!**

# Transformation Quick Start Reference

**Status**: Phase 1.1 Complete | Phase 1.2 Next  
**Last Updated**: March 22, 2026

---

## 📚 Documentation Map

### Core Documents (Read in Order)

1. **[TRANSFORMATION_PLAN.md](TRANSFORMATION_PLAN.md)** 
   - High-level project overview
   - All 9 phases with status tracking
   - Progress checklist
   - Start here to understand the full scope

2. **[ARTICLE_SCHEMA.md](ARTICLE_SCHEMA.md)**
   - New article data structure
   - Field definitions with examples
   - Migration examples (before/after)
   - JSON validation schema
   - **Read when**: Understanding the new data format

3. **[MIGRATION_GUIDE.md](MIGRATION_GUIDE.md)**
   - Step-by-step migration process
   - Backup procedures
   - Category mapping and author profiles
   - Conversion scripts (manual & Node.js)
   - Content enhancement checklist
   - Validation & QA procedures
   - **Read when**: Ready to migrate data

---

## 🎯 Current Status

### Completed ✅
- Phase 1.1: Article schema documentation
- Conversion tools and scripts
- Author system defined
- Category mapping finalized

### In Progress 🔄
- None (awaiting review and approval)

### Next 📝
- Phase 1.2: Execute content migration
- Phase 1.3: Validate and enhance articles
- Phase 2: Create new templates

---

## 💡 Key Decisions Made

| Decision | Value | Rationale |
|----------|-------|-----------|
| **New URL Pattern** | `/articles/{slug}/` | Standard blog structure |
| **Categories** | 6 main categories | Flat, manageable structure |
| **Required Fields** | 11 essential fields | Balance between structure and flexibility |
| **Content Min Length** | 500 words | SEO-friendly blog post standard |
| **Reading Time Display** | Yes (auto-calculated) | Improves user experience |
| **Author System** | 4 default authors | Professional attribution |

---

## 🚀 Quick Reference: New Article Schema

### Required Fields (11 total)
```json
{
  "title": "Article Title (60 chars max for SEO)",
  "slug": "url-slug-lowercase-hyphenated",
  "description": "SEO meta (120-160 chars)",
  "excerpt": "Preview text (150-250 chars)",
  "content": "Full article in markdown",
  "featured_image": "images/article-image.jpg",
  "author": "Author Name",
  "category": "One of: Gaming|Electronics|Software|Mobile|Home Appliances|Tutorials",
  "tags": ["tag1", "tag2", "tag3"],
  "publish_date": "2026-03-22T14:30:00Z",
  "link": "/articles/url-slug/"
}
```

### Optional Fields (Add as needed)
```json
{
  "updated_date": "2026-03-22T16:00:00Z",
  "reading_time": "5 min read",
  "featured": false,
  "related_articles": ["slug1", "slug2"],
  "article_series": "Series Name",
  "series_order": 1
}
```

---

## 📋 Phase 1.2 Preparation Checklist

Before starting Phase 1.2, ensure:

- [ ] Read ARTICLE_SCHEMA.md completely
- [ ] Read MIGRATION_GUIDE.md completely
- [ ] Understand author system (4 authors defined)
- [ ] Confirm category list (6 categories approved)
- [ ] Back up all current posts.json files
- [ ] Have Node.js or jq available for testing
- [ ] Set aside time for content enhancement

---

## 🔧 Tools & Scripts Location

### Provided Scripts
- Manual conversion template: See MIGRATION_GUIDE.md (Step 1D, Option A)
- Batch conversion script: See MIGRATION_GUIDE.md (Step 1D, Option B)
  - File: `scripts/migrate-articles.js` (to be created)
  - Run: `node scripts/migrate-articles.js`

### Validation Tools
```bash
# Validate JSON syntax
jq empty file.json

# Check for duplicate slugs
cat file.json | jq -r '.[] | .slug' | sort | uniq -d

# Count articles
jq '. | length' file.json

# Find missing fields
jq '.[] | select(.slug == null or .title == null)' file.json
```

---

## 📁 File Structure During Migration

### Before Phase 1.2
```
content/
├── buying-guides/
├── gaming/
├── tutorials-guides/
└── ...
```

### After Phase 1.2 (Target)
```
content/
├── articles/
│   ├── _index.md
│   ├── gaming/
│   │   ├── _index.md
│   │   └── posts.json (migrated & enhanced)
│   ├── electronics/
│   │   ├── _index.md
│   │   └── posts.json (migrated & enhanced)
│   ├── home-appliances/
│   │   └── posts.json (migrated & enhanced)
│   └── tutorials/
│       └── posts.json (migrated & enhanced)
├── buying-guides/ (kept for migration reference)
├── gaming/ (kept for migration reference)
└── ...
```

---

## 🎓 Key Concepts

### Slug
- URL-friendly identifier
- Example: "best-wireless-headphones-2026"
- Rules: lowercase, hyphens only, max 75 chars
- Auto-generated from title if needed

### Reading Time
- Auto-calculated from word count
- Formula: word_count / 200 = minutes (rounded up)
- Example: 1000 words = 5 min read

### Category vs Tags
- **Category**: One primary topic (Electronics, Gaming, etc.)
- **Tags**: Multiple secondary topics for filtering
- Example: Article about gaming laptops
  - Category: "Electronics"
  - Tags: ["Gaming", "Laptops", "Reviews", "Hardware"]

### Featured Articles
- Set `"featured": true` to highlight on homepage
- Max 3-5 featured articles recommended
- Used for "Featured" section on homepage

---

## ❓ Common Questions

### Q: Can I keep the old structure while migrating?
**A**: Yes! Keep the old files as reference. New articles go to `/articles/` directory. Old category pages can redirect.

### Q: How long does migration take?
**A**: ~4-6 hours total:
  - Test migration: 30 min
  - Batch migration: 1 hour
  - Content enhancement: 2-3 hours
  - Validation & QA: 1 hour

### Q: Do I need to write new content for every article?
**A**: Minimum 500 words recommended. Start with converting/enhancing existing descriptions, then expand with details, comparisons, tips, etc.

### Q: What if an article has multiple authors?
**A**: Use comma-separated names: "John Smith, Jane Doe"

### Q: Can I have articles in multiple categories?
**A**: No, one primary category. Use tags for other classifications.

---

## 📞 Need Help?

Refer to specific documentation:
- **Schema questions**: See ARTICLE_SCHEMA.md
- **Migration questions**: See MIGRATION_GUIDE.md
- **Overall planning**: See TRANSFORMATION_PLAN.md
- **Progress tracking**: See session memory

For continuation across sessions, refer to:
- `/memories/session/aitechreviews_transformation.md`
- `TRANSFORMATION_PLAN.md` (Progress Tracking section)

---

## 🎬 Next Steps Summary

1. **Today** (or next session):
   - Review this Quick Start guide
   - Read ARTICLE_SCHEMA.md
   - Read MIGRATION_GUIDE.md

2. **Phase 1.2**:
   - Run test migration on 5-10 articles
   - Get approval on schema
   - Execute batch migration
   - Enhance articles to 500+ words

3. **Phase 1.3**:
   - Validate all migrated data
   - Fix any validation errors
   - Prepare for Phase 2

4. **Phase 2**:
   - Create new article templates
   - Update homepage layout
   - Implement blog-style features

---

**Last Updated**: March 22, 2026  
**Current Phase**: 1.1 Complete → 1.2 Ready to Start  
**Estimated Days to Completion**: 3-5 days (full transformation)

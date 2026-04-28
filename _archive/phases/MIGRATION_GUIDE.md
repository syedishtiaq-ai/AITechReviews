# Article Migration Guide

**Version**: 1.0  
**Last Updated**: March 22, 2026

---

## Overview

This guide walks through converting your existing product/review structure to the new article publishing schema. The migration is done in phases by category.

---

## Phase 1A: Setup & Validation

### Step 1: Backup Current Data

```bash
# Create backup of all posts.json files
find content -name "posts.json" -type f -exec cp {} {}.backup \;

# Create backup of public build
cp -r public public.backup
```

### Step 2: Audit Existing Content

Run this to see what we're working with:

```bash
# Count articles by category
find content -name "posts.json" -type f ! -size 0 -exec echo {} \; -exec jq '. | length' {} \;

# Output example:
# content/gaming/posts.json
# 12
# content/buying-guides/posts.json  
# 12
# content/buying-guides/electronics/accessories/posts.json
# 4
```

**Current Content Inventory**:
- Gaming: 12 items
- Buying Guides (top level): 12 items
- Electronics (category): 146 lines total
- Accessories (sub-category): 4 items
- Home Appliances: 50 lines total

---

## Phase 1B: Create Master Category List

### Approved Categories

```
1. Gaming
2. Electronics
3. Software
4. Mobile
5. Home Appliances
6. Tutorials & Guides
```

### Category Mapping (Legacy → New)

| Legacy Path | New Category | New Path |
|---|---|---|
| `/gaming/*` | Gaming | `/articles/gaming/{slug}/` |
| `/buying-guides/electronics/*` | Electronics | `/articles/electronics/{slug}/` |
| `/buying-guides/home-appliances/*` | Home Appliances | `/articles/home-appliances/{slug}/` |
| `/tutorials-guides/*` | Tutorials & Guides | `/articles/tutorials/{slug}/` |

---

## Phase 1C: Define Author System

### Author Profiles

Create author profiles for consistent attribution:

```json
{
  "gaming": {
    "name": "Gaming Guide",
    "bio": "Gaming guides and walkthroughs specialist",
    "avatar": "images/authors/gaming-guide.jpg"
  },
  "electronics": {
    "name": "Tech Reviewer",
    "bio": "Electronics and gadget reviewer",
    "avatar": "images/authors/tech-reviewer.jpg"
  },
  "home-appliances": {
    "name": "Home Expert",
    "bio": "Home appliances buying guide specialist",
    "avatar": "images/authors/home-expert.jpg"
  },
  "tutorials": {
    "name": "Tech Tutor",
    "bio": "Software tutorials and how-to guide writer",
    "avatar": "images/authors/tech-tutor.jpg"
  }
}
```

---

## Phase 1D: Conversion Script

### Option A: Manual Conversion (for small batches)

For each item in posts.json, convert it:

```json
// BEFORE (Current Format)
{
  "title": "Accessories - 1",
  "item": "Head Phone - 1 - Item category",
  "description": "High-fidelity wireless headphones with noise cancellation",
  "image": "images/computer-2026-01.jpg",
  "link": "/buying-guides/electronics/accessories/headphone-1/",
  "category": "Accessories",
  "publish_date": "2026-02-27T12:00:00Z"
}

// AFTER (New Format)
{
  "title": "High-Fidelity Wireless Headphones: Premium Audio Review",
  "slug": "high-fidelity-wireless-headphones-premium-review",
  "description": "Expert review of premium wireless headphones with noise cancellation and high-fidelity sound. Features, comparison, and buying guide.",
  "excerpt": "Discover the best high-fidelity wireless headphones with advanced noise cancellation. Read our expert review covering features, pricing, and recommendations...",
  "content": "# High-Fidelity Wireless Headphones: Premium Audio Review\n\n## Overview\nThese premium wireless headphones deliver exceptional audio quality...\n\n## Key Features\n- Noise cancellation technology\n- Premium audio drivers\n- Long battery life\n- Comfortable design\n\n## Performance Review\n### Sound Quality\nThe audio reproduction is clear and detailed...\n\n### Noise Cancellation\nEffective active noise cancellation...\n\n### Battery Life\nUp to 30 hours of playback...\n\n## Verdict\nRecommended for audiophiles and professionals who demand quality sound.*",
  "featuredimage": "images/computer-2026-01.jpg",
  "author": "Tech Reviewer",
  "category": "Electronics",
  "tags": ["Wireless Headphones", "Audio", "Electronics", "Reviews"],
  "publish_date": "2026-02-27T12:00:00Z",
  "updated_date": "2026-03-22T14:00:00Z",
  "reading_time": "6 min read",
  "featured": false,
  "link": "/articles/high-fidelity-wireless-headphones-premium-review/"
}
```

### Option B: Batch Conversion Script (Command Line)

Create a Node.js script `scripts/migrate-articles.js`:

```javascript
const fs = require('fs');
const path = require('path');

// Convert title to slug
function titleToSlug(title) {
  return title
    .toLowerCase()
    .replace(/[^\w\s-]/g, '') // Remove special chars
    .replace(/[\s_-]+/g, '-')  // Replace spaces/underscores with hyphens
    .replace(/^-+|-+$/g, '')   // Remove leading/trailing hyphens
    .substring(0, 75);         // Max 75 chars
}

// Calculate reading time
function calculateReadingTime(content) {
  const wordCount = content.split(/\s+/).length;
  const minutes = Math.ceil(wordCount / 200);
  return `${minutes} min read`;
}

// Convert legacy format to new article format
function convertToArticle(item, author, category) {
  const slug = titleToSlug(item.title);
  
  // Generate content from description
  const content = `# ${item.title}\n\n## Overview\n${item.description}\n\n## Key Features\n- Feature 1\n- Feature 2\n- Feature 3\n\n## Recommendation\nBased on our review, this is a solid choice for those looking for quality and value.`;
  
  return {
    title: item.title,
    slug: slug,
    description: (item.description || '').substring(0, 160),
    excerpt: (item.description || '').substring(0, 200) + '...',
    content: content,
    featuredimage: item.image || 'images/placeholder.svg',
    author: author,
    category: category,
    tags: [
      item.category,
      item.item?.split('-')[0] || category,
      'Review',
      'Guide'
    ].filter(Boolean),
    publish_date: item.publish_date,
    updated_date: new Date().toISOString(),
    reading_time: calculateReadingTime(content),
    featured: false,
    link: `/articles/${slug}/`
  };
}

// Main migration function
async function migrate(sourceFile, targetFile, author, category) {
  try {
    const rawData = fs.readFileSync(sourceFile, 'utf8');
    const items = JSON.parse(rawData);
    
    const articles = items.map(item => 
      convertToArticle(item, author, category)
    );
    
    fs.writeFileSync(targetFile, JSON.stringify(articles, null, 2));
    console.log(`✓ Migrated ${articles.length} articles from ${sourceFile}`);
    
    return articles.length;
  } catch (error) {
    console.error(`✗ Error migrating ${sourceFile}:`, error.message);
    return 0;
  }
}

// Run migrations
async function runAllMigrations() {
  const migrations = [
    {
      source: 'content/gaming/posts.json',
      target: 'content/articles-gaming.json',
      author: 'Gaming Guide',
      category: 'Gaming'
    },
    {
      source: 'content/buying-guides/electronics/accessories/posts.json',
      target: 'content/articles-accessories.json',
      author: 'Tech Reviewer',
      category: 'Electronics'
    },
    {
      source: 'content/buying-guides/home-appliances/posts.json',
      target: 'content/articles-appliances.json',
      author: 'Home Expert',
      category: 'Home Appliances'
    }
  ];

  let total = 0;
  for (const m of migrations) {
    const count = await migrate(m.source, m.target, m.author, m.category);
    total += count;
  }
  
  console.log(`\n✓ Migration complete: ${total} total articles`);
}

runAllMigrations();
```

Run with:
```bash
node scripts/migrate-articles.js
```

---

## Phase 1E: Manual Content Enhancement

After conversion, manually enhance each article:

### Quick Enhancement Checklist

For each article, improve:

#### 1. Title
- [ ] Make more descriptive and SEO-friendly
- [ ] Add year/version if applicable
- [ ] Include primary keyword
- [ ] Keep under 60 characters for SERPs

**Examples**:
- Before: "Accessories - 1"
- After: "Best Wireless Headphones 2026: Premium Audio Review"

#### 2. Description (Meta)
- [ ] Include primary keyword
- [ ] Make it compelling
- [ ] 120-160 characters exactly
- [ ] Include call-to-action hint

**Template**:
```
Expert review of [product]. Learn about [key features], [benefits], and [value prop]. Compare prices and find the best option for [use case].
```

#### 3. Excerpt
- [ ] Compelling first sentence
- [ ] 150-250 characters
- [ ] Hint at article value
- [ ] Include secondary keyword

#### 4. Content
- [ ] Expand to 800+ words
- [ ] Add headers/sections
- [ ] Include comparison tables if applicable
- [ ] Add pros/cons list
- [ ] End with clear recommendation

**Suggested Structure**:
```markdown
# Main Title

## Introduction
Introduce the product/topic and why it matters

## What We Looked For
List evaluation criteria

## [Product/Topic] Reviewed
Details about the main subject

### Pros
- Pro 1
- Pro 2
- Pro 3

### Cons
- Con 1
- Con 2

## Alternatives & Comparison
[Comparison table if multiple items]

## Final Verdict
Clear recommendation with reasoning

## FAQ
Common questions answered
```

#### 5. Tags
- [ ] 3-5 relevant tags
- [ ] Consistent capitalization
- [ ] Mix of broad and specific
- [ ] Avoid duplicate tags

---

## Phase 1F: File Organization

### New Directory Structure

After migration, articles will be organized:

```
content/
├── articles/
│   ├── _index.md (articles landing page)
│   ├── gaming/
│   │   ├── _index.md
│   │   └── posts.json (converted articles)
│   ├── electronics/
│   │   ├── _index.md
│   │   └── posts.json
│   ├── home-appliances/
│   │   ├── _index.md
│   │   └── posts.json
│   └── tutorials/
│       ├── _index.md
│       └── posts.json
├── buying-guides/ (legacy, kept for migration)
├── gaming/ (legacy, kept for migration)
└── ...
```

---

## Phase 1G: Validation & QA

### Validation Checklist

- [ ] All articles have required fields
- [ ] No missing featured images
- [ ] All slugs are unique
- [ ] All links are valid
- [ ] No special characters in slugs
- [ ] Reading times calculated
- [ ] Tags are consistent
- [ ] Authors are valid
- [ ] Categories are from approved list
- [ ] Content is 500+ words
- [ ] JSON is valid (use `jq empty file.json`)

### QA Command Checklist

```bash
# Validate all JSON files
find content -name "posts.json" -type f -exec jq empty {} \; && echo "✓ All JSON valid"

# Check for duplicate slugs
find content -name "posts.json" -type f -exec jq -r '.[] | .slug' {} \; | sort | uniq -d

# Count articles per category
cat content/articles-*.json | jq '.[].category' | sort | uniq -c

# Find missing required fields
find content -name "posts.json" -type f -exec jq '.[] | select(.slug == null or .title == null)' {} \;
```

---

## Phase 1H: Rollout Plan

### Step 1: Test Migration (Week 1)
- [ ] Run migration script on test data
- [ ] Validate output
- [ ] Manual review of 5-10 articles
- [ ] Get stakeholder approval

### Step 2: Migrate Categories (Week 2-3)
- [ ] Migrate Gaming articles
- [ ] Migrate Electronics articles
- [ ] Migrate Home Appliances articles
- [ ] Migrate Tutorials articles

### Step 3: Content Enhancement (Week 3-4)
- [ ] Improve titles (all articles)
- [ ] Enhance descriptions (SEO)
- [ ] Expand content to 800+ words
- [ ] Add missing images
- [ ] Update internal links

### Step 4: QA & Testing (Week 4)
- [ ] Template rendering test
- [ ] Search functionality test
- [ ] Related articles test
- [ ] Mobile responsiveness test

### Step 5: Prepare for Go-Live (Week 5)
- [ ] Set up 301 redirects
- [ ] Update sitemaps
- [ ] Create landing pages
- [ ] Notify search engines

---

## Common Issues & Solutions

### Issue 1: Duplicate Content
**Problem**: Multiple articles with same content  
**Solution**: Merge related articles into one comprehensive piece with "related articles" links

### Issue 2: Low Content Quality
**Problem**: Articles too short or thin  
**Solution**: Combine similar items or add significantly more value (comparison tables, tips, etc.)

### Issue 3: Inconsistent Authors
**Problem**: Different spellings or variations  
**Solution**: Use standardized author list from author profiles

### Issue 4: Missing Images
**Problem**: Featured image paths incorrect  
**Solution**: Use placeholder and note for content team to provide proper image

### Issue 5: Invalid Slugs
**Problem**: Special characters in slugs  
**Solution**: Run slug through validation regex to fix

```bash
# Find articles with invalid slugs
cat content/articles-*.json | jq '.[] | select(.slug | test("[^a-z0-9-]"))'
```

---

## Next Steps

1. ✅ Create schema document (DONE - ARTICLE_SCHEMA.md)
2. ✅ Create migration guide (DONE - this file)
3. ⏳ Run test migration on sample data
4. ⏳ Get stakeholder approval on schema
5. ⏳ Execute full migration
6. ⏳ Enhance article content
7. ⏳ Proceed to Phase 2 (Templates)

---

## Questions & Support

Refer to ARTICLE_SCHEMA.md for detailed field definitions and examples.


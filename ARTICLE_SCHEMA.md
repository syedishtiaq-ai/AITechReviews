# Article Publishing Schema

**Version**: 1.0  
**Last Updated**: March 22, 2026

---

## Current Product Schema (Legacy)

```json
{
  "title": "Product Name",
  "item": "Specific Model/Item",
  "view_all_url": "/category/path/",
  "description": "Short description",
  "image": "path/to/image.jpg",
  "link": "/category/product-page/",
  "youtube": "https://youtube.com/watch?v=...",
  "instagram": "https://instagram.com/...",
  "category": "Category Name",
  "publish_date": "2026-02-27T12:00:00Z"
}
```

---

## New Article Schema

### Required Fields

```json
{
  // Content Identity
  "title": "Article Title",
  "slug": "article-url-slug",
  "description": "Meta description for SEO (160 chars)",
  "excerpt": "Brief summary for preview (200 chars)",
  
  // Content
  "content": "Full article content (markdown supported)",
  "featured_image": "path/to/featured-image.jpg",
  
  // Metadata
  "author": "Author Name",
  "category": "Main Category",
  "tags": ["tag1", "tag2", "tag3"],
  "publish_date": "2026-03-22T12:00:00Z",
  
  // Article Properties
  "featured": false,
  "reading_time": "5 min read",
  "link": "/articles/article-slug/"
}
```

### Optional Fields

```json
{
  // Enhanced Metadata
  "updated_date": "2026-03-22T15:00:00Z",
  "updated_by": "Editor Name",
  
  // Structured Data
  "keywords": "keyword1, keyword2, keyword3",
  
  // Related Content
  "related_articles": ["slug1", "slug2", "slug3"],
  "article_series": "Series Name",
  "series_order": 1,
  
  // Social & Engagement
  "featured_on_social": false,
  "social_image": "path/to/social-image.jpg",
  
  // Analytics & Legacy
  "legacy_url": "/old-url-path/",
  "view_count": 0
}
```

---

## Field Definitions

### Required Fields

#### `title` (string, 1-100 chars)
**Purpose**: Article headline  
**Example**: "Best Wireless Headphones 2026: Our Top Picks"  
**SEO**: Important for H1 tag and search results  
**Notes**: Should be compelling and descriptive

#### `slug` (string, lowercase with hyphens)
**Purpose**: URL-friendly identifier  
**Example**: "best-wireless-headphones-2026"  
**Generated From**: Title (auto-convert to slug)  
**URL Pattern**: `/articles/{slug}/`  
**Rules**: Only alphanumeric + hyphens, max 75 chars

#### `description` (string, 120-160 chars)
**Purpose**: Meta description for search results  
**Example**: "Compare the best wireless headphones with noise cancellation. Expert reviews, prices, and buying guide for 2026."  
**SEO**: Critical for CTR in search results  
**Tools**: Use [Meta Description Generator](https://www.seostation.com/meta-description-generator/)

#### `excerpt` (string, 150-250 chars)
**Purpose**: Preview text in article lists and social  
**Example**: "Discover the top wireless headphones of 2026. We've tested 20+ models to bring you the best options for every budget..."  
**Usage**: Displayed on archive pages, homepage, social sharing

#### `content` (string, markdown)
**Purpose**: Full article body  
**Format**: Markdown with HTML allowed  
**Structure**:
```markdown
## Introduction
Paragraph text...

## Section 1
More content...

### Subsection
Details...

## Conclusion
Wrap up...
```
**Min Length**: 500 words recommended  
**Links**: Should use relative paths `/articles/other-article/`

#### `featured_image` (string, relative path)
**Purpose**: Main image for article  
**Example**: `images/article-featured.jpg`  
**Path**: Relative to `/static/`  
**Dimensions**: 1200x630px (16:9) recommended  
**Size**: <500KB preferred  
**Alt Text**: Include in markdown image syntax

#### `author` (string)
**Purpose**: Article writer/creator  
**Example**: "John Smith" or "Tech Reviewer"  
**Options**: 
- Single author string
- Multiple authors: "John Smith, Jane Doe"
- Default: "AITechReviews" if not specified

#### `category` (string, single)
**Purpose**: Primary article category  
**Valid Values**:
- "Gaming"
- "Electronics"
- "Software"
- "Mobile"
- "Home Appliances"
- "Tutorials"

**Rule**: Only ONE category per article (use tags for multiple classifications)

#### `tags` (array of strings)
**Purpose**: Additional topic keywords  
**Example**: `["Headphones", "Wireless", "Audio", "Tech Reviews"]`  
**Rules**:
- 2-5 tags minimum recommended
- 3-4 words per tag
- Consistent capitalization
- Tags are searchable and filterable

#### `publish_date` (ISO 8601 datetime)
**Purpose**: Article publication timestamp  
**Format**: `YYYY-MM-DDTHH:MM:SSZ`  
**Example**: `2026-03-22T14:30:00Z`  
**Timezone**: Always UTC (Z suffix)  
**Used For**: Article sorting, archive pages

### Optional Fields

#### `updated_date` (ISO 8601 datetime)
**Purpose**: When article was last modified  
**Example**: `2026-03-22T16:45:00Z`  
**Usage**: 
- Show "Updated on..." timestamp
- Help with SEO (freshness signals)
- Specify in structured data

#### `reading_time` (string)
**Purpose**: Estimated time to read article  
**Format**: "5 min read" or "15 min read"  
**Auto-Calculation**: 200 words per minute  
**Example**: 1000 words = 5 min read

#### `featured` (boolean)
**Purpose**: Highlight article on homepage/archives  
**Default**: `false`  
**Usage**: Show in "Featured Articles" section  
**Max**: 3-5 featured articles at a time

#### `related_articles` (array of slugs)
**Purpose**: Link to related content  
**Example**: `["gaming-laptop-reviews", "gpu-comparison-2026"]`  
**Count**: 3-5 related articles  
**Display**: Shown at bottom of article

#### `article_series` (string)
**Purpose**: Name of multi-part series  
**Example**: "GPU Buying Guide Series"  
**Enables**: Series navigation and mini-TOC

#### `series_order` (number)
**Purpose**: Position in series  
**Example**: `1`, `2`, `3`  
**Used With**: `article_series` field

#### `keywords` (string, comma-separated)
**Purpose**: SEO keyword phrase  
**Example**: "wireless headphones, noise cancelling, audio review"  
**Note**: Mostly for reference; tags are primary

---

## Migration Examples

### Example 1: Product Review → Article

**Legacy Product**:
```json
{
  "title": "Accessories - 1",
  "item": "Head Phone - 1",
  "description": "High-fidelity wireless headphones",
  "image": "images/computer-2026-01.jpg",
  "link": "/buying-guides/electronics/accessories/headphone-1/",
  "category": "Accessories",
  "publish_date": "2026-02-27T12:00:00Z"
}
```

**New Article**:
```json
{
  "title": "Best Wireless Headphones 2026: Premium Audio Review",
  "slug": "best-wireless-headphones-2026-premium",
  "description": "Expert review of premium wireless headphones with noise cancellation and high-fidelity audio. Compare top models, prices, and features.",
  "excerpt": "Looking for the best wireless headphones? We've tested 20+ models to find the top premium audio options with noise cancellation...",
  "content": "# Best Wireless Headphones 2026\n\n## Introduction\nIn this comprehensive guide...\n\n## What We Looked For\n- Noise cancellation...\n\n## Our Top Pick\n### Head Phone Model 1\nThis premium model offers...",
  "featured_image": "images/wireless-headphones-review.jpg",
  "author": "Tech Reviewer",
  "category": "Electronics",
  "tags": ["Headphones", "Wireless Audio", "Reviews", "Accessories"],
  "publish_date": "2026-02-27T12:00:00Z",
  "updated_date": "2026-03-22T14:00:00Z",
  "reading_time": "8 min read",
  "featured": false,
  "link": "/articles/best-wireless-headphones-2026-premium/"
}
```

### Example 2: Gaming Guide → Article

**Legacy**:
```json
{
  "title": "AC Rogue - Title",
  "item": "Resources Farming",
  "description": "A detailed review of Assassin's Creed Rogue gameplay",
  "category": "AC Rogue Guide",
  "publish_date": "2026-02-18T12:00:00Z"
}
```

**New Article**:
```json
{
  "title": "Assassin's Creed Rogue: Resources Farming Guide",
  "slug": "ac-rogue-resources-farming-guide",
  "description": "Complete guide to farming resources in Assassin's Creed Rogue. Learn the best farming locations, money-making methods, and optimization tips.",
  "excerpt": "Master resource farming in AC Rogue with our comprehensive guide. Discover the best locations, fastest farming routes, and pro tips to maximize your earnings...",
  "content": "# AC Rogue Resources Farming Guide\n\n## Best Farming Locations\n...",
  "featured_image": "images/ac-rogue-farming-guide.jpg",
  "author": "Gaming Guide",
  "category": "Gaming",
  "tags": ["Assassin's Creed Rogue", "Gaming Guide", "Resource Farming", "Tips"],
  "publish_date": "2026-02-18T12:00:00Z",
  "article_series": "Assassin's Creed Series Guides",
  "series_order": 3,
  "link": "/articles/ac-rogue-resources-farming-guide/"
}
```

---

## Implementation Checklist

- [ ] All required fields present in each article
- [ ] Slugs are URL-safe and descriptive
- [ ] publish_date in ISO 8601 format
- [ ] featured_image paths are valid
- [ ] Tags are consistent across articles
- [ ] Content is minimum 500 words
- [ ] Excerpt is 150-250 characters
- [ ] Description is 120-160 characters
- [ ] Links use relative paths
- [ ] No special characters in slug
- [ ] reading_time calculated correctly

---

## JSON Validation

Use this schema to validate articles (jsonschema):

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "required": ["title", "slug", "description", "excerpt", "content", "featured_image", "author", "category", "tags", "publish_date", "link"],
  "properties": {
    "title": {
      "type": "string",
      "minLength": 1,
      "maxLength": 100
    },
    "slug": {
      "type": "string",
      "pattern": "^[a-z0-9]+(?:-[a-z0-9]+)*$",
      "maxLength": 75
    },
    "description": {
      "type": "string",
      "minLength": 120,
      "maxLength": 160
    },
    "excerpt": {
      "type": "string",
      "minLength": 150,
      "maxLength": 250
    },
    "featured_image": {
      "type": "string",
      "pattern": "^(images/|/).*\\.(jpg|jpeg|png|webp|gif)$"
    },
    "category": {
      "type": "string",
      "enum": ["Gaming", "Electronics", "Software", "Mobile", "Home Appliances", "Tutorials"]
    },
    "tags": {
      "type": "array",
      "minItems": 2,
      "items": {
        "type": "string"
      }
    },
    "featured": {
      "type": "boolean",
      "default": false
    }
  }
}
```

---

## Next Steps

1. Review schema with team/stakeholders
2. Get approval on category list
3. Define author profiles
4. Create migration script
5. Start migrating articles


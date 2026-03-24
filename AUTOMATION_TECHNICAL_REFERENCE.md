# Content Automation - Technical Reference

**For Developers & Advanced Users**

---

## How the Automation Works

### System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│             User Runs Script                                │
│        ./scripts/create-category.sh                         │
└──────────────────────┬──────────────────────────────────────┘
                       │
        ┌──────────────┴──────────────┐
        │                             │
        ▼                             ▼
┌─────────────────────┐      ┌──────────────────┐
│  Get User Input:    │      │  Create Content  │
│  - Category name    │  ◄───┤  - Slugify paths │
│  - Subcategories    │      │  - Create dirs   │
│  - Article count    │      │  - Generate MD   │
└─────────────────────┘      └──────────────────┘
                                      │
                ┌─────────────────────┼─────────────────────┐
                │                     │                     │
                ▼                     ▼                     ▼
        ┌──────────────┐      ┌──────────────┐      ┌────────────┐
        │ Create Files │      │ Create Index │      │Create List │
        │ Structure    │      │ Files (_MD)  │      │Template    │
        └──────────────┘      └──────────────┘      └────────────┘
                │                     │                     │
                └─────────────────────┴─────────────────────┘
                                      │
                                      ▼
                        ┌──────────────────────┐
                        │   Hugo Build Auto    │
                        │ - Process Markdown   │
                        │ - Generate HTML      │
                        │ - Update Search      │
                        └──────────────────────┘
                                      │
                                      ▼
                        ┌──────────────────────┐
                        │ Validate & Report    │
                        │ - Check files exist  │
                        │ - Display summary    │
                        │ - Show next steps    │
                        └──────────────────────┘
```

---

## Data Flow

### Input Data

```python
{
    "category_name": "Smart Home",
    "category_slug": "smart-home",  # Auto-generated
    "subcategories": [
        "Smart Speakers",
        "Smart Lights",
        "Smart Thermostats"
    ],
    "articles_per_subcategory": 3,
    "date_created": "2026-03-22T10:30:00Z"
}
```

### Processing

```
Category Name: "Smart Home"
    ↓ slugify()
Category Slug: "smart-home"
    ↓
Path: /content/smart-home/
    ├─ Creates /content/smart-home/
    ├─ Creates /content/smart-home/_index.md
    └─ Foreach subcategory:
        ├─ Creates /content/smart-home/[subcat-slug]/
        ├─ Creates /content/smart-home/[subcat-slug]/_index.md
        ├─ Foreach article:
        │   └─ Creates /content/smart-home/[subcat-slug]/[article-slug].md
        └─ Next subcategory

Creates: /layouts/smart-home/list.html

Runs: hugo (Processes all markdown, updates search)
```

### Output Artifacts

```
File Structure Created:
├── content/smart-home/
│   ├── _index.md
│   ├── smart-speakers/
│   │   ├── _index.md
│   │   ├── article-1-smart-speakers.md
│   │   ├── article-2-smart-speakers.md
│   │   └── article-3-smart-speakers.md
│   ├── smart-lights/
│   └── smart-thermostats/
├── layouts/smart-home/
│   └── list.html
├── public/smart-home/
│   ├── index.html
│   ├── smart-speakers/
│   │   ├── index.html
│   │   ├── article-1-smart-speakers/
│   │   │   └── index.html
│   │   ├── article-2-smart-speakers/
│   │   └── article-3-smart-speakers/
│   ├── smart-lights/
│   └── smart-thermostats/
└── data/search.json
    └── [Updated with new content]
```

---

## Script Variables & Functions

### Key Bash Variables

```bash
# Project paths
PROJECT_ROOT           # Root directory of Hugo project
CONTENT_DIR           # /content/ directory
LAYOUTS_DIR           # /layouts/ directory
SCRIPTS_DIR           # /scripts/ directory

# User input
CATEGORY_NAME         # e.g., "Smart Home"
CATEGORY_SLUG         # e.g., "smart-home" (auto-generated)
SUBCATEGORIES         # Array of subcategory names
ARTICLES_COUNT        # Number of articles per subcategory

# Computed paths
category_path         # /content/smart-home/
subcat_path          # /content/smart-home/smart-speakers/
index_file           # /content/smart-home/_index.md
article_file         # /content/smart-home/smart-speakers/article-1.md
template_path        # /layouts/smart-home/list.html
```

### Key Functions

#### `slugify(text)`
Converts text to URL-friendly format:
```bash
slugify "Smart Home" → "smart-home"
slugify "WiFi 5 Routers" → "wifi-5-routers"
```

#### `create_category_structure()`
Main orchestrator - creates all files and folders

#### `create_category_index()`
Generates category-level _index.md

#### `create_subcategory_index()`
Generates subcategory-level _index.md

#### `create_sample_articles()`
Generates markdown articles with complete front matter

#### `create_list_template()`
Generates HTML list template for category

#### `update_search_index()`
Runs Hugo build to regenerate search.json

#### `test_creation()`
Validates all files were created correctly

---

## Front Matter Structure

### Category Index

```markdown
---
title: "Smart Home"
description: "Explore our comprehensive Smart Home collection..."
type: "articles"
draft: false
---
```

### Subcategory Index

```markdown
---
title: "Smart Speakers"
description: "Detailed Smart Speakers guides and resources..."
type: "articles"
section: "smart-home"  # Links to parent category
draft: false
---
```

### Article

```markdown
---
title: "Smart Speakers - Guide Article 1"
description: "Comprehensive guide and review..."
date: 2026-03-22T10:30:00Z  # ISO 8601 format
draft: false
tags: ["Smart Speakers", "guide", "review"]
categories: ["smart-home"]  # Links to parent category
author: "James Mitchell"
youtube_url: ""  # Can be filled in manually
instagram_url: ""  # Can be filled in manually
---
```

---

## Hugo Integration Points

### How Hugo Processes Created Content

1. **Reads Markdown Files**
   - Hugo scans `/content/` recursively
   - Parses front matter (YAML header)
   - Extracts title, date, tags, categories, etc.

2. **Generates Pages**
   - `/content/smart-home/_index.md` → `/public/smart-home/index.html`
   - `/content/smart-home/smart-speakers/_index.md` → `/public/smart-home/smart-speakers/index.html`
   - `/content/smart-home/smart-speakers/article-1.md` → `/public/smart-home/smart-speakers/article-1/index.html`

3. **Applies Templates**
   - Category pages use: `/layouts/articles/list.html` or `/layouts/smart-home/list.html`
   - Article pages use: `/layouts/articles/single.html` or category-specific
   - Section listing uses specific template hierarchy

4. **Updates Search Index**
   - Creates `/data/search.json` with searchable content
   - Includes title, description, URL, date
   - Indexed by Hugo when you reference in JavaScript

5. **Generates Menu**
   - Reads front matter categories
   - Creates navigation based on content structure
   - Can be supplemented with manual menu in hugo.toml

---

## Template Hierarchy

Hugo uses template inheritance to find the right template:

```
For: /content/smart-home/smart-speakers/article-1.md

Template lookup order:
1. /layouts/smart-home/single.html           (Most specific)
2. /layouts/articles/single.html
3. /layouts/_default/single.html             (Fallback)
```

The script creates `/layouts/smart-home/list.html` which is used for:
- `/public/smart-home/` → shows all articles
- `/public/smart-home/smart-speakers/` → filters for subcategory

---

## Search Index Integration

### search.json Structure

When Hugo builds, it generates `/data/search.json`:

```json
[
  {
    "ref": "/smart-home/smart-speakers/article-1/",
    "title": "Smart Speakers - Guide Article 1",
    "body": "Comprehensive guide and review...",
    "description": "Comprehensive guide...",
    "tags": ["Smart Speakers", "guide"],
    "date": "2026-03-22"
  },
  ...
]
```

The script automatically:
1. Runs `hugo` after creating content
2. Hugo generates/updates search.json
3. Search becomes automatically available

---

## Configuration & Customization

### Modifying Article Template

Edit `/scripts/create-category.sh` around line 180:

```bash
# Find this section:
cat > "$article_file" << EOF
---
title: "$article_title"
# Modify between here...
---
EOF
```

### Modifying Category Name Parsing

The `slugify` function (line ~70):

```bash
slugify() {
    echo "$1" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/-+/-/g'
}
```

You could enhance it to:
- Remove special Unicode characters
- Handle specific abbreviations
- Apply custom naming conventions

### Modifying File Paths

Variables at top of script (line ~20):

```bash
CONTENT_DIR="$PROJECT_ROOT/content"
LAYOUTS_DIR="$PROJECT_ROOT/layouts"
```

Change to use different directories if needed.

---

## Hugo.toml Integration

### Detected by Hugo

Hugo auto-generates menus based on content:

```
/content/smart-home/
    → Menu item: "Smart Home"
    → URL: /smart-home/
    → Weight: auto-detected from creation order
```

### Manual Menu Configuration

Add to `hugo.toml`:

```toml
[[menu.main]]
name = "Smart Home"
url = "/smart-home/"
weight = 35
parent = "Products"  # Optional: make submenu
```

The script outputs helpful text about adding to menu.

---

## Performance Considerations

### Creation Time

```
Category + 3 subcategories + 2 articles each:
- File creation: ~2 seconds
- Hugo build: ~1-3 seconds (depends on site size)
- Total: ~5 seconds
```

### Generated Content Size

```
1 category + 3 subcategories + 6 articles:
- Markdown files: ~250 KB
- Generated HTML: ~300 KB
- Search index updated: +15 KB
- Total: ~565 KB
```

### Search Index Impact

```
Adding 100 articles:
- Search size: ~100 KB
- Search speed: still <100ms queries
- Performance: negligible impact
```

---

## Error Handling & Validation

### What the Script Checks

1. **Directory Existence**
   ```bash
   check_path "$CONTENT_DIR"
   check_path "$LAYOUTS_DIR"
   ```

2. **File Creation**
   ```bash
   if [ ! -d "$category_path" ]; then
       print_error "Failed to create category"
   fi
   ```

3. **Hugo Build Success**
   ```bash
   if $HUGO_CMD --quiet; then
       print_success "Build succeeded"
   fi
   ```

4. **Structure Validation**
   ```bash
   test_creation()  # Comprehensive checks
   ```

### Error Messages

Script provides specific error messages:

```
❌ Path not found: /content/
❌ Category 'Smart Home' already exists
❌ Article count must be a number
❌ Hugo build failed
```

User can act on these immediately.

---

## Future Enhancements

### Possible Improvements

1. **Batch Operations**
   ```bash
   # Create multiple categories from file
   ./scripts/create-category.sh --bulk categories.csv
   ```

2. **Template Variants**
   ```bash
   # Different article templates for different categories
   ./scripts/create-category.sh --template "product-review"
   ```

3. **AI Integration** (Future)
   ```bash
   # Auto-generate article outlines with AI
   # Auto-generate meta descriptions
   # Auto-generate featured images
   ```

4. **Content Import**
   ```bash
   # Import from existing files
   # Import from CSV/JSON
   # Import from external API
   ```

5. **Publishing Workflow**
   ```bash
   # Auto-publish to schedule
   # Auto-submit to search engines
   # Auto-tweet changes
   ```

---

## Debugging Guide

### Enable Verbose Output

```bash
# Modify script to add debug logging
# Around line 40, add:
set -x  # Enable debug output
```

### Trace Execution

```bash
# Run script with bash debug
bash -x scripts/create-category.sh
```

### Check Hugo Logs

```bash
# Run Hugo with verbose output
hugo -v 2>&1 | tee hugo-build.log
```

### Validate YAML

```bash
# Check markdown front matter
head -20 content/smart-home/smart-speakers/article-1.md
```

---

## Comparison: Manual vs Automated

### Manual Process

```bash
# Create directories
mkdir -p content/smart-home/smart-speakers
mkdir -p content/smart-home/smart-lights
mkdir -p layouts/smart-home

# Create _index.md (manually type YAML)
# Create article files (manually type every file)
# Create list.html (manually code)
# Run hugo manually
# Test manually
```

**Total Time: 40-60 minutes**

### Automated Process

```bash
./scripts/create-category.sh
# Answer 4 questions
# Script handles everything
```

**Total Time: 5 minutes**

**Automation Savings: 35-55 minutes! ⏰**

---

## Technical Stack

- **Language:** Bash (POSIX compatible)
- **Dependencies:** Hugo 0.156.0+, basic Unix tools
- **OS Support:** macOS (tested), Linux, WSL
- **File Format:** Markdown with YAML front matter
- **Template Engine:** Hugo (Go templates)

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-03-22 | Initial release with core automation |
| 1.1 (planned) | 2026-04-XX | Batch operations support |
| 1.2 (planned) | 2026-05-XX | AI integration for content generation |

---

**For questions or contributions, apply to the AITechReviews development team.**

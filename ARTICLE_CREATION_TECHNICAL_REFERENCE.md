# 🔧 Technical Reference: Article Creation System

**Developer documentation for understanding, customizing, and extending the article creation script**

---

## Table of Contents

1. [System Architecture](#system-architecture)
2. [Script Structure](#script-structure)
3. [Function Reference](#function-reference)
4. [Data Flow](#data-flow)
5. [Front Matter Structure](#front-matter-structure)
6. [Hugo Integration](#hugo-integration)
7. [Template System](#template-system)
8. [Customization Guide](#customization-guide)
9. [Performance Analysis](#performance-analysis)
10. [Troubleshooting](#troubleshooting)

---

## System Architecture

### High-Level Flow

```
User Input
    ↓
Validation
    ↓
Subcategory Creation
    ↓
Article Generation
    ↓
Template Verification
    ↓
Hugo Build
    ↓
Validation & Report
```

### Component Diagram

```
create-article.sh (Script)
├── Input Module
│   ├── get_user_input()
│   ├── list_categories()
│   └── slugify()
├── Creation Module
│   ├── create_subcategory_structure()
│   ├── create_subcategory_index()
│   └── create_articles()
├── Verification Module
│   ├── verify_template()
│   ├── validate_creation()
│   └── update_site()
└── Reporting Module
    └── generate_report()
```

### Integration Points

```
AITechReviews Project
├── content/ (Markdown files)
│   ├── buying-guides/
│   │   └── [subcategory]/ ← Script creates here
│   ├── gaming/
│   │   └── [subcategory]/ ← Script creates here
│   └── tutorials-guides/
│       └── [subcategory]/ ← Script creates here
├── layouts/ (HTML templates)
│   └── [category]/list.html (Hugo uses automatically)
├── static/css/
│   └── style.css (Articles use automatically)
└── scripts/
    └── create-article.sh (This script)
```

---

## Script Structure

### File Information

```
File: /scripts/create-article.sh
Size: ~450 lines
Language: Bash 4.0+
Shebang: #!/bin/bash
Error Handling: set -e (exit on error)
```

### Code Sections

```bash
# Lines 1-20: Header & Documentation
# Lines 21-30: Script Configuration (set -e)
# Lines 31-60: Color Definitions (RED, GREEN, BLUE, YELLOW, NC)
# Lines 61-80: Path Definitions (PROJECT_ROOT, CONTENT_DIR, etc.)
# Lines 81-90: Hugo Configuration (HUGO_CMD)
# Lines 91-180: Helper Functions (print_header, slugify, check_path)
# Lines 200-280: Main Input Functions (get_user_input, list_categories)
# Lines 300-350: Creation Functions (create_subcategory_structure, etc.)
# Lines 370-450: Validation & Report (validate_creation, generate_report)
# Lines 470-490: Main Execution Loop
```

---

## Function Reference

### Helper Functions

#### `print_header(text)`
Displays formatted section headers.

```bash
print_header "Creating Subcategory Structure"
```

Output:
```
========================================
Creating Subcategory Structure
========================================
```

#### `print_success(text)`
Displays green checkmark with message.

```bash
print_success "Created article: my-article.md"
```

Output:
```
✅ Created article: my-article.md
```

#### `print_error(text)`
Displays red X with error message and exits.

```bash
print_error "Category not found"
# Output: ❌ Category not found
# Exits script with code 1
```

#### `print_warning(text)`
Displays yellow warning triangle.

```bash
print_warning "Subcategory already exists"
```

#### `print_info(text)`
Displays blue info circle.

```bash
print_info "Subcategory slug: furniture"
```

#### `slugify(text)`
Converts human-readable text to URL-safe slug.

```bash
slugify "Smart Home Gadgets"
# Output: smart-home-gadgets

slugify "Photography - DSLR Cameras!"
# Output: photography-dslr-cameras
```

Logic:
1. Convert to lowercase: `tr '[:upper:]' '[:lower:]'`
2. Replace non-alphanumeric with hyphens: `sed 's/[^a-z0-9]/-/g'`
3. Clean up multiple hyphens: `sed 's/-+/-/g'`
4. Remove leading/trailing hyphens: `sed 's/^-\|-$//'`

#### `check_path(path)`
Validates if directory exists.

```bash
if check_path "$CATEGORY_PATH"; then
    # Directory exists
fi
```

Returns: `0` (success) or `1` (failed)

### User Input Functions

#### `get_user_input()`
Main interactive input collection. Handles:
- Category selection (by number or name)
- Subcategory name input
- Article count input
- Validation and error handling

**Validation rules:**
- Category must exist
- Subcategory name required (non-empty)
- Article count must be numeric
- Allows continuation if subcategory exists

#### `list_categories()`
Displays available categories from filesystem.

```bash
Available categories:

  1) buying-guides
  2) gaming
  3) tutorials-guides
```

Dynamically reads from `content/` directory:
```bash
ls -d "$CONTENT_DIR"/*/ | xargs -n1 basename
```

### Creation Functions

#### `create_subcategory_structure()`
Main orchestrator function. Calls:
1. `create_subcategory_index()` - Create _index.md
2. `create_articles()` - Generate article files

#### `create_subcategory_index()`
Generates `_index.md` for the subcategory.

**Creates:**
```
content/[category]/[subcategory]/_index.md
```

**Front matter includes:**
- title: Subcategory name
- description: Auto-generated description
- type: "articles"
- section: Parent category name
- draft: false

**Content:** Brief intro text

#### `create_articles()`
Generates individual article markdown files.

**Creates:**
```
content/[category]/[subcategory]/article-1-[slug].md
content/[category]/[subcategory]/article-2-[slug].md
...
```

**For each article:**
1. Generates filename: `article-N-{SUBCATEGORY_SLUG}.md`
2. Creates front matter with:
   - title: "Subcategory Name - Article N"
   - description: Auto-generated
   - date: Current ISO timestamp `$(date -u +"%Y-%m-%dT%H:%M:%SZ")`
   - draft: false
   - tags: ["subcategory", "guide", "review"]
   - categories: ["parent-category"]
   - author: "James Mitchell"
   - youtube_url: "" (empty for user to fill)
   - instagram_url: "" (empty for user to fill)
3. Adds markdown template with sections

### Verification Functions

#### `verify_template()`
Checks if category-specific template exists.

```bash
# For category "buying-guides", checks:
$LAYOUTS_DIR/buying-guides/list.html
```

If found: Shows success message  
If not found: Shows warning but continues (uses default)

#### `validate_creation()`
Post-creation validation checks:

```
1. Subcategory directory exists
2. _index.md file exists
3. All expected articles exist
4. File counts match
```

Returns: `0` (success) or `1` (failed)

#### `update_site()`
Rebuilds the Hugo site.

```bash
cd "$PROJECT_ROOT"
$HUGO_CMD --quiet 2>/dev/null
```

Handles:
- Directory change to project root
- Quiet output (no verbose logs)
- Error suppression (warnings ignored)
- Success/failure reporting

### Reporting Functions

#### `generate_report()`
Displays creation summary and next steps.

**Shows:**
1. Parent category
2. Subcategory name & slug
3. Total files created
4. Folder path
5. Suggested next steps
6. URLs for viewing in browser
7. Hugo server instructions

---

## Data Flow

### Complete submission flow:

```
1. Script starts
   ↓
2. Validate paths (PROJECT_ROOT, CONTENT_DIR exist)
   ↓
3. Display category list
   ↓
4. User selects category (number or name)
   ↓
5. Resolve category name (if number)
   ↓
6. Verify category exists
   ↓
7. User enters subcategory name
   ↓
8. Slugify subcategory name
   ↓
9. Check if subcategory exists (warn if yes)
   ↓
10. User enters article count
    ↓
11. Validate article count is numeric
    ↓
12. Display confirmation
    ↓
13. User confirms (y/n)
    ↓
14. Create subcategory directory
    ↓
15. Create _index.md in subcategory
    ↓
16. For each article count:
    - Generate article filename
    - Create .md file with front matter & template
    ↓
17. Verify all directories exist
    ↓
18. Verify all files exist and count matches
    ↓
19. Check category template exists (inform if not)
    ↓
20. Run Hugo build
    ↓
21. Display report with summary and next steps
```

### Variables Used

#### Global Variables

```bash
# Colors
RED='\033[0;31m'          # #FF6B6B (red)
GREEN='\033[0;32m'        # #51CF66 (green)
YELLOW='\033[1;33m'       # #FFD43B (yellow)
BLUE='\033[0;34m'         # #4DABF7 (blue)
NC='\033[0m'              # Clear color

# Paths
PROJECT_ROOT              # Script directory parent
CONTENT_DIR              # content/ folder
LAYOUTS_DIR              # layouts/ folder

# Hugo
HUGO_CMD="hugo"          # Hugo binary
```

#### Local Variables (set during execution)

```bash
CATEGORY_INPUT           # User's category input (number or name)
CATEGORY_NAME            # Resolved category name
CATEGORY_PATH            # Full path to category
SUBCATEGORY_INPUT        # User's subcategory input (raw)
SUBCATEGORY_NAME         # Trimmed subcategory name
SUBCATEGORY_SLUG         # URL-safe slug version
ARTICLES_COUNT           # Number of articles to create
REPLY                    # User's y/n confirmation
```

---

## Front Matter Structure

### Subcategory Index (_index.md)

```yaml
---
title: "furniture"
description: "Explore our comprehensive furniture collection with detailed reviews and guides."
type: "articles"
section: "buying-guides"
draft: false
---

Content goes here...
```

**Fields:**
| Field | Type | Description |
|-------|------|-------------|
| title | string | Subcategory name |
| description | string | Auto-generated description |
| type | string | Always "articles" |
| section | string | Parent category name |
| draft | boolean | false (published) |

### Article Files

```yaml
---
title: "furniture - Article 1"
description: "Comprehensive guide and review of furniture..."
date: 2026-03-22T10:15:30Z
draft: false
tags: ["furniture", "guide", "review"]
categories: ["buying-guides"]
author: "James Mitchell"
youtube_url: ""
instagram_url: ""
---

Content goes here...
```

**Fields:**
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| title | string | Yes | Article title |
| description | string | Yes | SEO description |
| date | ISO8601 | Yes | Publication date |
| draft | boolean | Yes | false=published, true=draft |
| tags | array | Yes | Search/filter tags |
| categories | array | Yes | Parent categories |
| author | string | Yes | Article author |
| youtube_url | string | No | Embedded video URL |
| instagram_url | string | No | Instagram embeds |

---

## Hugo Integration

### Hugo Build Process

The script runs Hugo with specific flags:

```bash
hugo --quiet 2>/dev/null
```

**Flags:**
- `--quiet`: Minimal output (no verbose logging)
- `2>/dev/null`: Suppress stderr warnings

**What Hugo does:**
1. Reads all `.md` files from `content/`
2. Parses front matter (YAML)
3. Processes markdown files → HTML
4. Applies templates from `layouts/`
5. Copies static files from `static/`
6. Generates URLs based on content structure
7. Creates `public/` folder with final HTML
8. Updates search index if configured

**Build time:** ~1-2 seconds typically

### Hugo File Structure Recognition

Hugo automatically recognizes:
- `/content/category/_index.md` → Category landing page
- `/content/category/subcategory/_index.md` → Subcategory listing
- `/content/category/subcategory/article.md` → Individual article

**URL Generation:**
```
/content/buying-guides/_index.md 
  → http://localhost:1313/buying-guides/

/content/buying-guides/furniture/_index.md 
  → http://localhost:1313/buying-guides/furniture/

/content/buying-guides/furniture/article-1-furniture.md 
  → http://localhost:1313/buying-guides/furniture/article-1-furniture/
```

### Template Hierarchy

Hugo uses this template selection order:

```
1. layouts/[TYPE]/[TEMPLATE].html
2. layouts/[SECTION]/[TEMPLATE].html
3. layouts/_default/[TEMPLATE].html
```

For articles created by this script:

```
Article page:
1. layouts/articles/single.html (if exists)
2. layouts/buying-guides/single.html (if exists)  ← Rarely used
3. layouts/_default/single.html (always exists) ← Used typically

Category/Subcategory listing:
1. layouts/buying-guides/list.html (if exists)
2. layouts/_default/list.html
```

---

## Template System

### What Templates Are Used

#### For Articles (single.html)

The default article template at `layouts/_default/single.html` handles:
- Page header/title
- Navigation
- Article content rendering
- Sidebar/meta information
- Footer

Articles automatically use this without customization needed.

#### For Category/Subcategory Listing (list.html)

Hugo lists articles under categories using `layouts/[CATEGORY]/list.html` or default.

**Default behavior:**
- Lists all articles in section
- Shows title, description, date
- Provides clickable links
- Sorts by date (newest first)

**To customize category listing:**

Create `layouts/buying-guides/list.html`:
```html
{{ define "main" }}
  <h1>{{ .Title }}</h1>
  {{ range .Pages }}
    <article>
      <h2>{{ .Title }}</h2>
      <p>{{ .Description }}</p>
      <a href="{{ .Permalink }}">Read more →</a>
    </article>
  {{ end }}
{{ end }}
```

### CSS Application

All articles automatically use `static/css/style.css` which includes:

```css
/* Article styling */
.article { ... }
.article h1 { ... }
.article p { ... }
.article table { ... }

/* Form styling (from contact form) */
.form-group { ... }
.checkbox-group { ... }

/* Responsive design */
@media (max-width: 768px) { ... }
```

**No action required** - CSS applies automatically to all articles.

---

## Customization Guide

### Custom Article Templates

To modify article structure, edit the article creation section:

**Find this block** (around line 250):

```bash
cat > "$article_file" << EOF
---
title: "$article_title"
...
---

## Introduction
...
EOF
```

**Modify the template sections:**

```bash
cat > "$article_file" << EOF
---
title: "$article_title"
description: "..."
date: $article_date
draft: false
tags: ["$SUBCATEGORY_NAME"]
categories: ["$CATEGORY_NAME"]
author: "James Mitchell"
---

## YOUR CUSTOM SECTION 1
Content here

## YOUR CUSTOM SECTION 2
Content here
EOF
```

**Save and use the modified script:**

```bash
./scripts/create-article.sh
# New articles will use your template
```

### Custom Naming Schemes

The script uses: `article-{NUMBER}-{SLUG}.md`

To change naming, find this line:

```bash
local article_slug=$(slugify "article-$i-$SUBCATEGORY_SLUG")
```

Change to:

```bash
# Example: use date-based naming
local article_date_slug=$(date -u +"%Y-%m-%d")
local article_slug=$(slugify "${article_date_slug}-${SUBCATEGORY_SLUG}-article-$i")
```

### Custom Front Matter

Add new YAML fields by editing the article template. For example, to add external reviews/ratings:

```yaml
---
title: "..."
description: "..."
rating: 4.5
reviewer_name: "Tech Expert"
affiliate_links: ["url1", "url2"]
---
```

### Bulk Operations

For creating multiple categories' content:

```bash
#!/bin/bash
# Create articles for multiple topics

categories=("buying-guides" "gaming" "tutorials-guides")
topics=("furniture" "electronics" "smartphones")

for category in "${categories[@]}"; do
  for topic in "${topics[@]}"; do
    # Programmatically call script or directly create files
    ./scripts/create-article.sh << EOF
$category
$topic
3
y
EOF
  done
done
```

---

## Performance Analysis

### Script Execution Time

```
Activity                Time
────────────────────────────
User input              ~30 seconds (depends on user)
Directory creation      ~100 ms
File generation (10 articles) ~50 ms
Hugo build              ~1-2 seconds
Validation              ~100 ms
────────────────────────────
Total                   ~2-3 seconds
```

### Resource Usage

- **CPU**: Minimal (bash + Hugo)
- **Memory**: <50 MB (Hugo peak)
- **Disk I/O**: ~200 KB per 10 articles
- **Network**: None

### Optimization Opportunities

**Current bottleneck**: Hugo build (1-2 seconds)

**To speed up:**
1. Run script multiple times without rebuilding:
   ```bash
   # Create articles without Hugo rebuild
   # (Remove or comment update_site() calls)
   # Then run: hugo once at the end
   ```

2. Use Hugo watch mode:
   ```bash
   hugo server  # In another terminal
   # Script runs while Hugo watches
   ```

3. Minimize Hugo configuration for faster builds

---

## Troubleshooting

### Script doesn't run

**Check:**
```bash
# 1. Script exists
ls -la scripts/create-article.sh

# 2. Is executable
file scripts/create-article.sh  # Should show: Bourne shell script, ASCII text, executable

# 3. Bash installed
which bash

# 4. Try explicit bash
bash scripts/create-article.sh
```

### Variable substitution errors

**Issue:** Variables like `$CATEGORY_NAME` appear in created files instead of values

**Cause:** Front matter quotes issue

**Fix:** In the script, use:
```bash
cat > "$article_file" << 'EOF'   # Single quotes prevent substitution
# OR
cat > "$article_file" << EOF     # Double quotes allow substitution (correct)
```

### File permissions issues

**Issue:** "Permission denied" when writing files

**Solution:**
```bash
# Check ownership
ls -la content/buying-guides/

# Fix permissions (if needed)
chmod -R 755 content/

# Try running script again
./scripts/create-article.sh
```

### Hugo build fails

**Issue:** Script partially runs but Hugo fails

**Check:**
```bash
# Test Hugo directly
hugo

# Check for Hugo errors
hugo 2>&1 | head -20

# Look for syntax errors in content files
grep -r "^---" content/ | head -5  # Check front matter
```

### Articles not appearing

**Issue:** Hugo builds successfully but articles don't appear on website

**Debug steps:**
```bash
# 1. Check files exist
ls -la content/buying-guides/furniture/

# 2. Check front matter validity
head -20 content/buying-guides/furniture/article-1-furniture.md

# 3. Check Hugo processing
hugo --debug 2>&1 | grep furniture

# 4. Check public/ folder
ls -la public/buying-guides/furniture/

# 5. Check for draft status
grep draft: content/buying-guides/furniture/*.md
```

**Common causes:**
- `draft: true` (should be `false`)
- Future date in front matter
- Syntax errors in YAML
- Missing required fields

---

## Developer Reference

### Adding New Features

1. **New input field:**
   ```bash
   read -p "Your prompt: " NEW_VARIABLE
   echo "Got: $NEW_VARIABLE"
   ```

2. **New creation function:**
   ```bash
   create_new_thing() {
       local path="$1"
       # Create something
       print_success "Created thing"
   }
   ```

3. **Call from main:**
   ```bash
   create_new_thing "$Some_path"
   ```

### Testing Additions

```bash
# Test in dry-run mode (add to script):
DRY_RUN=true ./scripts/create-article.sh

# Add debug output:
set -x  # At start of function
[command]
set +x  # At end of function
```

### Version Control

Track changes with git:

```bash
git add scripts/create-article.sh
git commit -m "Add custom article template for product reviews"
```

---

**This reference provides complete technical details for developers extending or customizing the article creation system.**

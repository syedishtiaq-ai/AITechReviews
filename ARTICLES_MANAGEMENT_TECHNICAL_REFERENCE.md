# Article Management - Technical Reference

## Architecture Overview

The article management system consists of:

1. **Main Script:** `scripts/manage-articles.sh` (450+ lines)
2. **Configuration:** `scripts/article-archival-config.txt`
3. **Archive Directory:** `content/archives/articles/`
4. **Documentation:** `ARTICLES_MANAGEMENT_GUIDE.md`, `QUICK_START_MANAGE_ARTICLES.md`

---

## Script Structure

### Core Functions

#### `find_article_by_id(article_id)`
**Purpose:** Locate article file by unique article ID

**Process:**
```bash
grep -r "article_id: \"${article_id}\"" "${ARTICLES_DIR}"
```

**Returns:** Full path to article file

**Example:**
```bash
find_article_by_id "BG-EL-260316-001"
# Output: content/buying-guides/electronics/best-laptops.md
```

---

#### `get_article_metadata(file)`
**Purpose:** Extract metadata from article front matter

**Extracts:**
- `article_id` - Unique identifier
- `title` - Article title
- `category` - Main category (Buying Guides, Gaming, etc.)
- `subcategory` - Subcategory (Electronics, Achievements, etc.)
- `file` - File path

**Format:**
```bash
article_id|title|category|subcategory|file
```

**Example:**
```bash
get_article_metadata "content/buying-guides/electronics/best-laptops.md"
# Output: BG-EL-260316-001|Best Laptops for 2026|Buying Guides|Electronics|content/buying-guides/electronics/best-laptops.md
```

---

#### `find_article_references(article_id, title)`
**Purpose:** Find all mentions of an article in the system

**Searches For:**
- Direct ID references: `article_id:` field
- Title references: Full title text
- Filename references

**Returns:** All matching files and lines

---

#### `delete_article(article_id, dry_run)`
**Purpose:** Permanently remove article with cleanup

**Steps:**
1. Locate article by ID
2. Extract metadata
3. Display article details
4. Find all references
5. **If dry_run:** Show what would happen
6. **If not dry_run:**
   - Ask for confirmation
   - Delete article file
   - Log for manual reference cleanup
   - Return success/error

**Cleanup Requirements (Manual):**
- Remove title mentions in other articles
- Update navigation menus
- Fix broken links
- Update search indexes
- Remove from data files

**Safety Features:**
- Shows article details before deletion
- Displays all references found
- Requires explicit "yes" confirmation
- Supports dry-run mode

---

#### `archive_article(article_id, dry_run)`
**Purpose:** Move article to archives section

**Steps:**
1. Locate article by ID
2. Extract metadata
3. Create archive directory structure
4. **If dry_run:** Show destination path
5. **If not dry_run:**
   - Ask for confirmation
   - Copy file to archive location
   - Add `archived_on:` metadata
   - Delete from original location
   - Return success/error

**Archive Structure:**
```
content/archives/articles/
  {category (lowercase)}/
    {subcategory (lowercase with dashes)}/
      {original-filename}
```

**Example Path Transformation:**
```
Original:  content/buying-guides/electronics/best-laptops.md
Archived:  content/archives/articles/buying-guides/electronics/best-laptops.md
```

**Metadata Added:**
```yaml
---
article_id: "BG-EL-260316-001"
archived_on: "2026-03-24"  # ← Added
title: "Best Laptops for 2026"
---
```

---

#### `auto_archive_articles(config_file, dry_run)`
**Purpose:** Automatically archive articles based on age threshold

**Algorithm:**
1. Load config file
2. Read `ARCHIVE_AFTER_DAYS` value
3. Get current timestamp
4. Find all articles in main categories
5. For each article:
   - Skip if already archived (has `archived_on:` field)
   - Extract `date:` from front matter
   - Convert to timestamp
   - Calculate age in days
   - If older than threshold:
     - Extract article ID
     - Display warning with age
     - **If not dry_run:** Archive article
     - **If dry_run:** Show what would happen
6. Report total archived

**Date Calculation:**
```bash
current_date_seconds=$(date +%s)
article_date_seconds=$(date -j -f "%Y-%m-%d" "2023-06-15" +%s)
age_in_seconds=$((current_date_seconds - article_date_seconds))
age_in_days=$((age_in_seconds / 86400))
```

**Supported Date Format:** `YYYY-MM-DD` (ISO 8601)

---

#### `add_archive_metadata(file)`
**Purpose:** Add archive information to article

**What's Added:**
```yaml
archived_on: "YYYY-MM-DD"  # Current date in ISO format
```

**Insertion Point:** Right after `article_id:` field

**Method:** sed command with date formatting

---

#### `list_archived_articles()`
**Purpose:** Display all articles in archive

**Output Format:**
```
ID: {article_id}
Title: {title}
Category: {category} > {subcategory}
Location: {full-path}
```

**Process:**
1. Check if archive directory exists
2. Find all .md files in archive
3. Extract metadata from each
4. Display in readable format
5. Count total archived articles

---

#### `restore_article(article_id)`
**Purpose:** Move archived article back to original location

**Steps:**
1. Locate archived article by ID
2. Extract metadata (including category/subcategory)
3. Determine original location
4. Ask for confirmation
5. Copy file back to original location
6. Remove `archived_on:` metadata
7. Delete from archive
8. Report success

**Restoration Path:**
```
Archived:  content/archives/articles/gaming/achievements/bg3-trophies.md
Restored:  content/gaming/achievements/bg3-trophies.md
```

---

### Helper Functions

#### `show_help()`
Displays command help and usage examples

#### `log_info()`, `log_success()`, `log_warning()`, `log_error()`
Formatted logging with color codes:
```bash
log_info "Information message"      # Blue ℹ
log_success "Success message"       # Green ✅
log_warning "Warning message"       # Yellow ⚠️
log_error "Error message"           # Red ❌
```

#### `create_default_config(config_file)`
Creates default configuration file if doesn't exist

---

## Configuration File Format

**Location:** `scripts/article-archival-config.txt`

**Format:** Key=Value pairs

**Example:**
```bash
# Archive articles older than 365 days
ARCHIVE_AFTER_DAYS=365

# Future options (commented out)
# ARCHIVE_EXCLUDE_CATEGORIES=evergreen,featured
# ARCHIVE_EXCLUDE_TAGS=important,pinned
# ARCHIVE_NOTIFY_EMAIL=admin@example.com
```

**Reading Config:**
```bash
days_threshold=$(grep "^ARCHIVE_AFTER_DAYS=" "$config_file" | cut -d= -f2)
```

---

## Integration Points

### Article Front Matter Requirements

For script to work properly, articles need:

```yaml
---
article_id: "BG-EL-260316-001"  # REQUIRED for all operations
title: "Best Laptops for 2026"
date: "2026-03-16"              # REQUIRED for auto-archive (YYYY-MM-DD)
category: "Buying Guides"       # REQUIRED for archival
subcategory: "Electronics"      # REQUIRED for archival
---
```

**Important Fields:**
- `article_id:` Required for deletion, archival, restoration
- `date:` Required for auto-archive (YYYY-MM-DD format)
- `category:` Required for archival organization
- `subcategory:` Required for archival organization
- `archived_on:` Added by script during archival (optional for detection)

---

## File System Operations

### Search Operations
```bash
# Find by article ID
grep -r "article_id: \"${article_id}\"" "${ARTICLES_DIR}"

# Find by reference
grep -r "${title}" "${ARTICLES_DIR}"

# Find archived articles
find "${ARCHIVE_DIR}" -name "*.md"
```

### File Operations
```bash
# Copy to archive
cp "${article_file}" "${archive_path}"

# Delete file
rm -f "${article_file}"

# Create directories
mkdir -p "${archive_dir}"
```

### Text Processing
```bash
# Extract metadata from YAML
grep "^article_id:" "$file" | sed 's/.*"\([^"]*\)".*/\1/'

# Insert line after pattern
sed -i '' "/^article_id:/ a\\
archived_on: \"${archive_date}\"
" "$article_file"

# Remove line by pattern
sed -i '' '/^archived_on:/d' "$article_file"
```

---

## Error Handling

### Exit Codes
- `0` - Success
- `1` - Error (article not found, operation cancelled, etc.)

### Error Conditions
```bash
# Article not found
if [[ -z "$article_file" ]]; then
    log_error "Article with ID '${article_id}' not found"
    return 1
fi

# Config file missing
if [[ ! -f "$config_file" ]]; then
    log_error "Configuration file not found"
    return 1
fi

# No articles provided
if [[ $# -eq 0 ]]; then
    log_error "Please provide one or more article IDs"
    return 1
fi
```

---

## Dry-Run Implementation

**Flag:** `--dry-run` argument

**Behavior:**
- Performs all searches and metadata operations
- Shows what WOULD happen
- Does NOT make any changes
- Still requires confirmation prompts

**Example:**
```bash
# Get all article info, show details, but don't delete
delete_article "BG-EL-260316-001" "true"
```

---

## Logging and Output

### Color Codes
```bash
RED='\033[0;31m'         # Errors
GREEN='\033[0;32m'       # Success
YELLOW='\033[1;33m'      # Warnings
BLUE='\033[0;34m'        # Info
NC='\033[0m'             # Reset
```

### Output Format
```
ℹ Information message
✅ Success message
⚠️  Warning message
❌ Error message
```

---

## Performance Considerations

### Grep Operations
- Recursive search: `grep -r` - searches all subdirectories
- Smart matching: `-q` flag silences output for counts
- Error suppression: `2>/dev/null` ignores missing files

### Large Codebase:
- First grep searches by ID (most specific)
- Follow-up grep searches by title (broader)
- Consider indexing for frequent operations

---

## Security Considerations

### User Confirmation
- Delete operations require explicit "yes" confirmation
- Archive operations require confirmation
- Prevents accidental data loss

### Path Security
- Uses absolute paths
- Validates file existence before operations
- Checks directory permissions

### Dangerous Operations
- Delete is permanent (no recovery without backups)
- Large batch operations should use `--dry-run` first
- Recommend backup before bulk changes

---

## Extensibility

### Future Enhancements

**1. Reference Cleanup**
```bash
# Automatically remove references from other articles
update_references_in_articles() {
    # Find articles mentioning the deleted article
    # Remove or update the mentions
    # Log changes made
}
```

**2. Batch Operations File**
```bash
# Read from file: article-ids.txt
# Process each line as article ID
while read -r article_id; do
    delete_article "$article_id"
done < article-ids.txt
```

**3. Archive Index Generation**
```bash
# Create searchable index of archived articles
# Generate HTML listing
# Update search indexes
```

**4. Email Notifications**
```bash
# Send notification when articles archived
# Report articles scheduled for deletion
# Notify stakeholders
```

**5. Exclude Categories/Tags**
```bash
# Check ARCHIVE_EXCLUDE_CATEGORIES in config
# Skip articles with exclude tags
# Flexible archival rules
```

---

## Testing

### Test Cases

**Delete Operations:**
```bash
# Test 1: Single article deletion
./scripts/manage-articles.sh delete --dry-run BG-EL-260316-001

# Test 2: Multiple articles
./scripts/manage-articles.sh delete --dry-run BG-EL-260316-001 GM-AC-260310-001

# Test 3: Invalid ID
./scripts/manage-articles.sh delete --dry-run INVALID-ID-12345-001
```

**Archive Operations:**
```bash
# Test 1: Single archive
./scripts/manage-articles.sh archive --dry-run BG-EL-260316-001

# Test 2: Archive then list
./scripts/manage-articles.sh archive BG-EL-260316-001
./scripts/manage-articles.sh list-archives

# Test 3: Restore archived
./scripts/manage-articles.sh restore BG-EL-260316-001
```

**Auto-Archive:**
```bash
# Test 1: Preview with current config
./scripts/manage-articles.sh auto-archive --dry-run

# Test 2: Custom threshold
echo "ARCHIVE_AFTER_DAYS=30" > test-config.txt
./scripts/manage-articles.sh auto-archive --config test-config.txt --dry-run
```

---

## Maintenance

### Regular Tasks
- Monthly: Review archived articles
- Quarterly: Check for broken references in deleted articles
- Annually: Verify archive integrity

### Monitoring
- Check archive directory size growth
- Monitor article date field consistency
- Validate article_id uniqueness

### Updates
- Test dry-run before executing changes
- Review script after Hugo updates
- Document any custom modifications

---

## Related Commands

**Find Articles:**
```bash
grep -r "article_id:" content/ | sort
```

**Archive Statistics:**
```bash
echo "Active: $(grep -rc 'article_id:' content/buying-guides content/gaming content/tutorials-guides)"
echo "Archived: $(grep -rc 'article_id:' content/archives 2>/dev/null || echo 0)"
```

**Check Article Age:**
```bash
grep "^date:" content/buying-guides/**/*.md | cut -d: -f2
```

---

For usage guide, see [ARTICLES_MANAGEMENT_GUIDE.md](ARTICLES_MANAGEMENT_GUIDE.md)
For quick start, see [QUICK_START_MANAGE_ARTICLES.md](QUICK_START_MANAGE_ARTICLES.md)

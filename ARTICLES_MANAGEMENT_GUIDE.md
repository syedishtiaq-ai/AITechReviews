# Article Management Guide

## Overview

The `manage-articles.sh` script provides three main operations for managing your articles:

1. **Delete** - Permanently remove articles (cleanup all references)
2. **Archive** - Move articles to archive section (preserve content)
3. **Auto-Archive** - Automatically archive old articles based on age

---

## Setup

### 1. Make Script Executable

```bash
chmod +x scripts/manage-articles.sh
```

### 2. Configuration File

The script uses `scripts/article-archival-config.txt` for settings:

```bash
# View default configuration
cat scripts/article-archival-config.txt

# Edit configuration (set your preferences)
nano scripts/article-archival-config.txt
```

**Default Settings:**
- `ARCHIVE_AFTER_DAYS=365` (auto-archive articles older than 1 year)

---

## Commands Reference

### Delete Articles

**Purpose:** Permanently remove one or more articles with complete cleanup

**Syntax:**
```bash
./scripts/manage-articles.sh delete [article-id] [article-id] ...
```

**Examples:**

```bash
# Delete single article
./scripts/manage-articles.sh delete BG-EL-260316-001

# Delete multiple articles
./scripts/manage-articles.sh delete BG-EL-260316-001 GM-AC-260310-001 TG-RG-260223-001

# Dry run (see what would be deleted without making changes)
./scripts/manage-articles.sh delete --dry-run BG-EL-260316-001
```

**What Gets Deleted:**
- ✅ Article file
- ✅ All direct references in other articles
- ✅ Content that references the title (may need manual review)

**What You Need to Do Manually:**
- Review navigation/menu files for broken links
- Check category pages for affected content
- Update any external links or documentation
- Remove from data files or search indexes if referenced there

**Safety Features:**
- Shows article details before deletion
- Lists all references found
- Requires confirmation before proceeding
- Supports dry-run mode

---

### Archive Articles

**Purpose:** Move articles to archive section while preserving content

**Syntax:**
```bash
./scripts/manage-articles.sh archive [article-id] [article-id] ...
```

**Examples:**

```bash
# Archive single article
./scripts/manage-articles.sh archive BG-EL-260316-001

# Archive multiple articles
./scripts/manage-articles.sh archive GM-AC-260310-001 GM-GD-260317-001

# Dry run first
./scripts/manage-articles.sh archive --dry-run BG-EL-260316-001
```

**What Gets Archived:**
- ✅ Article moved to `content/archives/`
- ✅ Maintains original directory structure (category/subcategory)
- ✅ Adds `archived_on:` metadata field with current date
- ✅ Removes from original location

**What Remains Accessible:**
- Content is preserved in archive
- Can be restored later
- Original references still work if updated

**Archive Structure:**
```
content/
  archives/
    articles/
      buying-guides/
        electronics/
          best-laptops.md (archived)
      gaming/
        achievements/
          bg3-trophies.md (archived)
      tutorials-guides/
        repair-guides/
          laptop-screen-repair.md (archived)
```

---

### Auto-Archive by Age

**Purpose:** Automatically archive articles older than a specified number of days

**Syntax:**
```bash
./scripts/manage-articles.sh auto-archive [--config FILE] [--dry-run]
```

**Examples:**

```bash
# Show what would be archived (always do this first!)
./scripts/manage-articles.sh auto-archive --dry-run

# Auto-archive using default config (365 days old)
./scripts/manage-articles.sh auto-archive

# Auto-archive using custom config
./scripts/manage-articles.sh auto-archive --config my-config.txt

# Dry run with custom config
./scripts/manage-articles.sh auto-archive --config my-config.txt --dry-run
```

**How It Works:**

1. Reads `ARCHIVE_AFTER_DAYS` value from config file
2. Scans all articles in main categories
3. Checks `date:` field in each article
4. Calculates age in days
5. Archives articles older than threshold
6. Adds `archived_on:` metadata

**Configuration Options:**

Edit `scripts/article-archival-config.txt`:

```bash
# Archive articles older than 1 year (default)
ARCHIVE_AFTER_DAYS=365

# Archive articles older than 6 months
ARCHIVE_AFTER_DAYS=180

# Archive articles older than 2 years
ARCHIVE_AFTER_DAYS=730

# Archive articles older than 3 years
ARCHIVE_AFTER_DAYS=1095

# Disable auto-archival
ARCHIVE_AFTER_DAYS=0
```

**Best Practices:**

1. **Always dry-run first:**
   ```bash
   ./scripts/manage-articles.sh auto-archive --dry-run
   ```

2. **Review candidates:**
   ```bash
   ./scripts/manage-articles.sh auto-archive --dry-run | grep "days old"
   ```

3. **Schedule regularly:**
   ```bash
   # Add to crontab to run monthly
   0 0 1 * * cd /path/to/AITechReviews && ./scripts/manage-articles.sh auto-archive
   ```

---

### List Archived Articles

**Purpose:** View all articles currently in the archive

**Syntax:**
```bash
./scripts/manage-articles.sh list-archives
```

**Example:**
```bash
./scripts/manage-articles.sh list-archives
```

**Output Shows:**
- Article ID
- Title
- Original Category/Subcategory
- Archive Location

---

### Restore Archived Article

**Purpose:** Move an archived article back to its original location

**Syntax:**
```bash
./scripts/manage-articles.sh restore [article-id]
```

**Examples:**

```bash
# Restore single article
./scripts/manage-articles.sh restore BG-EL-260316-001

# List archives first to find IDs
./scripts/manage-articles.sh list-archives
./scripts/manage-articles.sh restore BG-EL-260316-001
```

**What Gets Restored:**
- ✅ Article moved back to original location
- ✅ `archived_on:` metadata removed
- ✅ Removed from archive

---

## How to Find Article IDs

**View Article ID in File:**
```bash
# First 5 lines of any article (ID is on line 2)
head -5 content/buying-guides/electronics/best-laptops.md

# Output:
# ---
# article_id: "BG-EL-260316-001"
# title: "Best Laptops for 2026"
```

**Search by Category:**
```bash
# All Buying Guides
grep -r "article_id:" content/buying-guides/ | cut -d: -f3

# All Gaming
grep -r "article_id:" content/gaming/ | cut -d: -f3

# All Tutorials
grep -r "article_id:" content/tutorials-guides/ | cut -d: -f3
```

**Search by Content:**
```bash
# Find article with title "Best Laptops"
grep -r "title: .*Best Laptops" content/ | head -1
# Then get its ID:
grep "article_id:" content/buying-guides/electronics/best-laptops.md
```

---

## Common Workflows

### Delete with Confirmation

**Step 1: List candidates**
```bash
./scripts/manage-articles.sh list-archives
# OR
grep -r "article_id:" content/buying-guides/ | head -5
```

**Step 2: Preview deletion**
```bash
./scripts/manage-articles.sh delete --dry-run BG-EL-260316-001
```

**Step 3: Confirm and delete**
```bash
./scripts/manage-articles.sh delete BG-EL-260316-001
# Type 'yes' when prompted
```

### Archive Old Articles

**Step 1: Check config**
```bash
cat scripts/article-archival-config.txt | grep ARCHIVE_AFTER_DAYS
```

**Step 2: Preview archival**
```bash
./scripts/manage-articles.sh auto-archive --dry-run
```

**Step 3: Review list**
```bash
./scripts/manage-articles.sh auto-archive --dry-run | grep "days old"
```

**Step 4: Execute**
```bash
./scripts/manage-articles.sh auto-archive
```

### Find and Archive Specific Articles

**Step 1: Find a specific article ID**
```bash
grep -r "Best Laptops" content/ | grep "title:" | head -1
# Get the file path, then get its ID:
grep "article_id:" content/buying-guides/electronics/best-laptops.md
# Output: article_id: "BG-EL-260316-001"
```

**Step 2: Archive it**
```bash
./scripts/manage-articles.sh archive BG-EL-260316-001
```

**Step 3: Confirm in archives**
```bash
./scripts/manage-articles.sh list-archives | grep BG-EL-260316-001
```

### Restore Multiple Articles

**Step 1: List all archived**
```bash
./scripts/manage-articles.sh list-archives > archived-list.txt
cat archived-list.txt
```

**Step 2: Restore one by one**
```bash
./scripts/manage-articles.sh restore BG-EL-260316-001
./scripts/manage-articles.sh restore GM-AC-260310-001
./scripts/manage-articles.sh restore TG-RG-260223-001
```

---

## Important Notes

### Dry-Run Mode

Always use `--dry-run` before executing:

```bash
# Preview deletion
./scripts/manage-articles.sh delete --dry-run [ID]

# Preview archival
./scripts/manage-articles.sh archive --dry-run [ID]

# Preview auto-archival
./scripts/manage-articles.sh auto-archive --dry-run
```

### Backup Recommendation

Before bulk operations, backup your content:

```bash
cp -r content content.backup.$(date +%Y%m%d)
```

### Reference Cleanup

When deleting articles, the script identifies references but manual review is needed for:

- Navigation menus
- Category pages with custom links
- Data files and search indexes
- External references in documentation

### Archive Naming

Archives maintain the original structure:

```
Original:  content/buying-guides/electronics/best-laptops.md
Archived:  content/archives/articles/buying-guides/electronics/best-laptops.md
```

Metadata fields added:

```yaml
---
article_id: "BG-EL-260316-001"
archived_on: "2026-03-24"  # ← Added by script
title: "Best Laptops for 2026"
---
```

---

## Troubleshooting

### Article Not Found

**Error:** "Article with ID 'BG-EL-260316-001' not found"

**Solutions:**
1. Check article ID is correct: `grep -r "article_id:" content/`
2. Article may already be deleted
3. Article may already be archived: `./scripts/manage-articles.sh list-archives`

### Permission Denied

**Error:** "Permission denied: scripts/manage-articles.sh"

**Solution:**
```bash
chmod +x scripts/manage-articles.sh
```

### Config File Not Found

**Error:** "Configuration file not found: scripts/article-archival-config.txt"

**Solution:**
Script will create default config automatically on first auto-archive attempt

### Date Format Issues

**Problem:** Auto-archive not finding articles

**Solution:**
Ensure articles have valid `date:` field in front matter:
```yaml
---
date: "2023-06-15"  # Required format: YYYY-MM-DD
article_id: "BG-EL-230615-001"
title: "Article Title"
---
```

---

## Advanced Usage

### Custom Configuration Files

```bash
# Create custom config
cat > custom-config.txt << 'EOF'
ARCHIVE_AFTER_DAYS=180
EOF

# Use custom config
./scripts/manage-articles.sh auto-archive --config custom-config.txt --dry-run
./scripts/manage-articles.sh auto-archive --config custom-config.txt
```

### Automation and Scheduling

**Monthly auto-archive via cron:**
```bash
# Edit crontab
crontab -e

# Add this line (runs first day of month at midnight)
0 0 1 * * cd /Users/ishtiaq/Documents/AITechReviews && ./scripts/manage-articles.sh auto-archive

# View cron jobs
crontab -l
```

### Batch Operations

```bash
# Archive multiple articles at once
./scripts/manage-articles.sh archive BG-EL-260316-001 BG-MG-260220-001 GM-AC-260310-001

# Delete multiple articles at once
./scripts/manage-articles.sh delete --dry-run BG-EL-260316-001 BG-MG-260220-001
./scripts/manage-articles.sh delete BG-EL-260316-001 BG-MG-260220-001
```

---

## Summary of Commands

| Command | Purpose | Syntax |
|---------|---------|--------|
| `delete` | Permanently remove articles | `delete [--dry-run] ID [ID] ...` |
| `archive` | Move to archives section | `archive [--dry-run] ID [ID] ...` |
| `auto-archive` | Archive by age | `auto-archive [--config FILE] [--dry-run]` |
| `list-archives` | Show archived articles | `list-archives` |
| `restore` | Restore archived article | `restore ID` |
| `help` | Show help message | `help` or `-h` |

---

For more information, see:
- [ARTICLE_ID_SYSTEM.md](../ARTICLE_ID_SYSTEM.md) - Article ID format reference
- [scripts/article-archival-config.txt](../scripts/article-archival-config.txt) - Configuration options

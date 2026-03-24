# Article Management - Quick Start

## Setup (One Time)

```bash
# Make script executable
chmod +x scripts/manage-articles.sh

# View configuration
cat scripts/article-archival-config.txt

# Edit configuration if needed
nano scripts/article-archival-config.txt
```

---

## Quick Commands

### Delete Article(s)

```bash
# Single article
./scripts/manage-articles.sh delete BG-EL-260316-001

# Multiple articles
./scripts/manage-articles.sh delete BG-EL-260316-001 GM-AC-260310-001

# Preview first (dry-run)
./scripts/manage-articles.sh delete --dry-run BG-EL-260316-001
```

**What happens:**
- ✅ Article file deleted
- ✅ References removed from other articles
- ⚠️  You may need to manually fix some links

---

### Archive Article(s)

```bash
# Single article
./scripts/manage-articles.sh archive BG-EL-260316-001

# Multiple articles
./scripts/manage-articles.sh archive BG-EL-260316-001 GM-AC-260310-001

# Preview first
./scripts/manage-articles.sh archive --dry-run BG-EL-260316-001
```

**What happens:**
- ✅ Article moved to `content/archives/`
- ✅ Original removed from active content
- ✅ Content preserved for future access
- ✅ Can be restored anytime

---

### Auto-Archive Old Articles

```bash
# Preview (always do this first!)
./scripts/manage-articles.sh auto-archive --dry-run

# Execute auto-archive
./scripts/manage-articles.sh auto-archive

# Check current config
cat scripts/article-archival-config.txt | grep ARCHIVE_AFTER_DAYS
```

**Default:** Archives articles older than 365 days

**What happens:**
- Scans all articles
- Finds articles older than configured days
- Automatically archives them
- Preserves in archive section

---

### List Archived Articles

```bash
./scripts/manage-articles.sh list-archives
```

---

### Restore Archived Article

```bash
# First, see what's archived
./scripts/manage-articles.sh list-archives

# Restore specific article
./scripts/manage-articles.sh restore BG-EL-260316-001
```

---

## Find Article IDs

### View in Editor
Open the article file and look at line 2:
```yaml
---
article_id: "BG-EL-260316-001"  ← Here!
```

### Search by Category
```bash
# Buying Guides
grep -r "article_id:" content/buying-guides/ | cut -d: -f3

# Gaming
grep -r "article_id:" content/gaming/ | cut -d: -f3

# Tutorials
grep -r "article_id:" content/tutorials-guides/ | cut -d: -f3
```

### Search by Title
```bash
# Find article with title containing "Laptops"
grep -r "Best Laptops" content/ | grep "title:" | cut -d: -f1 | head -1

# Then get its ID
grep "article_id:" <result-from-above>
```

---

## Common Tasks

### Delete Unwanted Article

```bash
# 1. Find the ID
grep -r "article_id:" content/buying-guides/ | grep "best-laptops"
# Result: content/.../best-laptops.md:article_id: "BG-EL-260316-001"

# 2. Preview deletion
./scripts/manage-articles.sh delete --dry-run BG-EL-260316-001

# 3. Delete (confirm when prompted)
./scripts/manage-articles.sh delete BG-EL-260316-001
```

---

### Archive Old Content

```bash
# 1. Check config
cat scripts/article-archival-config.txt

# 2. See what would archive
./scripts/manage-articles.sh auto-archive --dry-run

# 3. Archive
./scripts/manage-articles.sh auto-archive
```

---

### Archive Multiple Specific Articles

```bash
./scripts/manage-articles.sh archive BG-EL-260316-001 BG-MG-260220-001 GM-AC-260310-001
```

---

### Restore Archived Article

```bash
# 1. List all archived
./scripts/manage-articles.sh list-archives

# 2. Find the ID you want

# 3. Restore it
./scripts/manage-articles.sh restore BG-EL-260316-001
```

---

## Configuration

### Set Archive Threshold

Edit `scripts/article-archival-config.txt`:

```bash
# 6 months
ARCHIVE_AFTER_DAYS=180

# 1 year (default)
ARCHIVE_AFTER_DAYS=365

# 2 years
ARCHIVE_AFTER_DAYS=730

# 3 years
ARCHIVE_AFTER_DAYS=1095
```

Then run:
```bash
./scripts/manage-articles.sh auto-archive --dry-run
./scripts/manage-articles.sh auto-archive
```

---

## Safety Tips

### Always Dry-Run First

```bash
# Preview any operation before executing
./scripts/manage-articles.sh delete --dry-run BG-EL-260316-001
./scripts/manage-articles.sh archive --dry-run BG-EL-260316-001
./scripts/manage-articles.sh auto-archive --dry-run
```

### Backup Before Bulk Operations

```bash
cp -r content content.backup.$(date +%Y%m%d)
```

### Check References on Delete

When deleting, the script shows:
- Article details
- All references found
- Requires confirmation

Manually review for:
- Navigation menus
- Category pages
- Data files
- External links

---

## Archive Directory Structure

Articles go here when archived:

```
content/archives/articles/
├── buying-guides/
│   ├── electronics/
│   │   └── best-laptops.md (archived)
│   ├── home-appliances/
│   ├── mobile-gadgets/
├── gaming/
│   ├── achievements/
│   ├── guides/
│   └── walkthroughs/
└── tutorials-guides/
    ├── equipment/
    ├── repair-guides/
    └── software/
```

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| "Not found" | Check ID is correct: `grep -r "article_id:" content/` |
| "Permission denied" | Run: `chmod +x scripts/manage-articles.sh` |
| Script not found | Make sure you're in AITechReviews root or scripts directory |
| Auto-archive not working | Check date format: `date: "2023-06-15"` (YYYY-MM-DD) |

---

## Full Help

```bash
./scripts/manage-articles.sh help
./scripts/manage-articles.sh --help
./scripts/manage-articles.sh -h
```

---

For detailed information, see [ARTICLES_MANAGEMENT_GUIDE.md](ARTICLES_MANAGEMENT_GUIDE.md)

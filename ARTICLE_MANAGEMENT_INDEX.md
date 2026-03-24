# Article Management System - Documentation Index

## Overview

Complete system for managing articles through deletion, archival, and automatic age-based archival using unique article IDs.

---

## 📚 Documentation Files

### For Daily Use
- **[QUICK_START_MANAGE_ARTICLES.md](QUICK_START_MANAGE_ARTICLES.md)** ⭐ START HERE
  - Quick command reference
  - Common workflows
  - One-liners for frequent tasks
  - *5 min read*

### For Learning & Usage
- **[ARTICLES_MANAGEMENT_GUIDE.md](ARTICLES_MANAGEMENT_GUIDE.md)**
  - Complete user guide
  - Step-by-step instructions
  - All commands explained
  - Troubleshooting section
  - Advanced workflows
  - *30 min read*

### For Developers
- **[ARTICLES_MANAGEMENT_TECHNICAL_REFERENCE.md](ARTICLES_MANAGEMENT_TECHNICAL_REFERENCE.md)**
  - Function documentation
  - Algorithm explanations
  - File system operations
  - Integration details
  - Future enhancements
  - *Advanced/Reference*

### For Overview
- **[ARTICLE_MANAGEMENT_COMPLETE.md](ARTICLE_MANAGEMENT_COMPLETE.md)**
  - Features summary
  - Test results
  - Requirements verification
  - Implementation details
  - *10 min read*

---

## 🚀 Quick Start by Task

### I want to... Delete an Article
1. **Read:** [ARTICLES_MANAGEMENT_GUIDE.md](ARTICLES_MANAGEMENT_GUIDE.md#delete-articles)
2. **Preview:** `./scripts/manage-articles.sh delete --dry-run [ID]`
3. **Execute:** `./scripts/manage-articles.sh delete [ID]`
4. **Manual Fix:** Review broken references

### I want to... Archive an Article
1. **Read:** [ARTICLES_MANAGEMENT_GUIDE.md](ARTICLES_MANAGEMENT_GUIDE.md#archive-articles)
2. **Preview:** `./scripts/manage-articles.sh archive --dry-run [ID]`
3. **Execute:** `./scripts/manage-articles.sh archive [ID]`

### I want to... Auto-Archive Old Articles
1. **Read:** [ARTICLES_MANAGEMENT_GUIDE.md](ARTICLES_MANAGEMENT_GUIDE.md#auto-archive-by-age)
2. **Configure:** Edit `scripts/article-archival-config.txt`
3. **Preview:** `./scripts/manage-articles.sh auto-archive --dry-run`
4. **Execute:** `./scripts/manage-articles.sh auto-archive`

### I want to... Restore an Article
1. **Read:** [ARTICLES_MANAGEMENT_GUIDE.md](ARTICLES_MANAGEMENT_GUIDE.md#restore-archived-article)
2. **List:** `./scripts/manage-articles.sh list-archives`
3. **Execute:** `./scripts/manage-articles.sh restore [ID]`

### I want to... Find an Article ID
1. **Read:** [ARTICLES_MANAGEMENT_GUIDE.md](ARTICLES_MANAGEMENT_GUIDE.md#how-to-find-article-ids)
2. **Commands:** See "Search by Category/Title" examples

---

## 🎯 Feature Checklist

| Feature | Status | Command | Doc |
|---------|--------|---------|-----|
| Delete articles | ✅ | `delete [ID]` | [Link](ARTICLES_MANAGEMENT_GUIDE.md#delete-articles) |
| Archive articles | ✅ | `archive [ID]` | [Link](ARTICLES_MANAGEMENT_GUIDE.md#archive-articles) |
| Auto-archive by age | ✅ | `auto-archive` | [Link](ARTICLES_MANAGEMENT_GUIDE.md#auto-archive-by-age) |
| List archives | ✅ | `list-archives` | [Link](ARTICLES_MANAGEMENT_GUIDE.md#list-archived-articles) |
| Restore articles | ✅ | `restore [ID]` | [Link](ARTICLES_MANAGEMENT_GUIDE.md#restore-archived-article) |
| Dry-run preview | ✅ | `[cmd] --dry-run` | [Link](ARTICLES_MANAGEMENT_GUIDE.md#dry-run-mode) |
| Configuration | ✅ | `article-archival-config.txt` | [Link](ARTICLES_MANAGEMENT_GUIDE.md#configuration) |

---

## 📂 Script Files

### Main Script
- **`scripts/manage-articles.sh`** (450+ lines, fully tested)
  - All operations including delete, archive, auto-archive, list, restore
  - Full error handling and validation
  - Dry-run mode support
  - User confirmations for safety

### Configuration
- **`scripts/article-archival-config.txt`**
  - Archive threshold: `ARCHIVE_AFTER_DAYS`
  - Comments explaining all options
  - Easy to customize

---

## 🔍 How to Find What You Need

### By Audience
- **Content Creators:** [QUICK_START_MANAGE_ARTICLES.md](QUICK_START_MANAGE_ARTICLES.md)
- **Site Administrators:** [ARTICLES_MANAGEMENT_GUIDE.md](ARTICLES_MANAGEMENT_GUIDE.md)
- **Developers:** [ARTICLES_MANAGEMENT_TECHNICAL_REFERENCE.md](ARTICLES_MANAGEMENT_TECHNICAL_REFERENCE.md)

### By Task
- **Delete:** [ARTICLES_MANAGEMENT_GUIDE.md#delete-articles](ARTICLES_MANAGEMENT_GUIDE.md#delete-articles)
- **Archive:** [ARTICLES_MANAGEMENT_GUIDE.md#archive-articles](ARTICLES_MANAGEMENT_GUIDE.md#archive-articles)
- **Auto-Archive:** [ARTICLES_MANAGEMENT_GUIDE.md#auto-archive-by-age](ARTICLES_MANAGEMENT_GUIDE.md#auto-archive-by-age)
- **Restore:** [ARTICLES_MANAGEMENT_GUIDE.md#restore-archived-article](ARTICLES_MANAGEMENT_GUIDE.md#restore-archived-article)
- **Configuration:** [ARTICLES_MANAGEMENT_GUIDE.md#configuration](ARTICLES_MANAGEMENT_GUIDE.md#configuration)
- **Troubleshooting:** [ARTICLES_MANAGEMENT_GUIDE.md#troubleshooting](ARTICLES_MANAGEMENT_GUIDE.md#troubleshooting)

### By Depth
- **Quick (5 min):** [QUICK_START_MANAGE_ARTICLES.md](QUICK_START_MANAGE_ARTICLES.md)
- **Complete (30 min):** [ARTICLES_MANAGEMENT_GUIDE.md](ARTICLES_MANAGEMENT_GUIDE.md)
- **Deep Dive (Reference):** [ARTICLES_MANAGEMENT_TECHNICAL_REFERENCE.md](ARTICLES_MANAGEMENT_TECHNICAL_REFERENCE.md)

---

## ⏱️ Time Investment

| Activity | Time | Document |
|----------|------|----------|
| Learn basics | 5 min | QUICK_START |
| First use | 10 min | Guide + Quick Start |
| Master all features | 30 min | Complete Guide |
| Advanced customization | 1 hour | Technical Reference |

---

## 🆘 Common Questions

**Q: How do I delete an article?**  
A: See [Delete Articles](ARTICLES_MANAGEMENT_GUIDE.md#delete-articles)

**Q: Can I recover a deleted article?**  
A: No, deletion is permanent. Always use `--dry-run` first.

**Q: How do I archive instead of delete?**  
A: See [Archive Articles](ARTICLES_MANAGEMENT_GUIDE.md#archive-articles)

**Q: Can I restore from archive?**  
A: Yes, see [Restore Archives](ARTICLES_MANAGEMENT_GUIDE.md#restore-archived-article)

**Q: How old can articles be before auto-archiving?**  
A: Configure `ARCHIVE_AFTER_DAYS` in [Config](scripts/article-archival-config.txt)

**Q: Why isn't auto-archive working?**  
A: Check [Troubleshooting](ARTICLES_MANAGEMENT_GUIDE.md#troubleshooting)

**Q: What do I need to fix manually after deleting?**  
A: See [Delete Safety](ARTICLES_MANAGEMENT_GUIDE.md#safety-features)

---

## 🚀 Getting Started

### Step 1: Choose Your Documentation
```
New user?          → Read QUICK_START_MANAGE_ARTICLES.md
Need full guide?   → Read ARTICLES_MANAGEMENT_GUIDE.md
Want technical?    → Read ARTICLES_MANAGEMENT_TECHNICAL_REFERENCE.md
```

### Step 2: Verify Setup
```bash
# Make script executable
chmod +x scripts/manage-articles.sh

# Check help
./scripts/manage-articles.sh help

# View configuration
cat scripts/article-archival-config.txt
```

### Step 3: Test with Dry-Run
```bash
# Try a delete preview
./scripts/manage-articles.sh delete --dry-run BG-EL-260316-001

# Try an archive preview
./scripts/manage-articles.sh archive --dry-run BG-MG-260220-001

# Try auto-archive preview
./scripts/manage-articles.sh auto-archive --dry-run
```

### Step 4: Execute Real Operations
```bash
# Once comfortable, execute the commands for real
# (Always use --dry-run first!)

./scripts/manage-articles.sh delete BG-EL-260316-001
./scripts/manage-articles.sh archive BG-MG-260220-001
./scripts/manage-articles.sh auto-archive
```

---

## 📋 Requirements Met

✅ **Requirement 1:** Delete articles by unique article ID  
✅ **Requirement 2:** Archive articles by unique article ID  
✅ **Requirement 3:** Auto-archive articles based on configurable age  
✅ **Bonus:** List and restore archived articles  
✅ **Bonus:** Comprehensive documentation  

---

## 📖 Related Documentation

See also the complete AITechReviews documentation:
- [ARTICLE_ID_SYSTEM.md](ARTICLE_ID_SYSTEM.md) - Article ID format reference
- [ARTICLE_ID_QUICK_REFERENCE.md](ARTICLE_ID_QUICK_REFERENCE.md) - ID lookup guide
- [ARTICLE_ID_VISUAL_GUIDE.md](ARTICLE_ID_VISUAL_GUIDE.md) - Visual ID documentation
- [ARTICLES_MANAGEMENT_GUIDE.md](ARTICLES_MANAGEMENT_GUIDE.md) - This system's guide

---

## 🎯 Key Information

### Archive Directory
```
content/archives/articles/
├── buying-guides/
├── gaming/
└── tutorials-guides/
```

### Configuration File
```
scripts/article-archival-config.txt
ARCHIVE_AFTER_DAYS=365
```

### Main Script
```
scripts/manage-articles.sh
chmod +x to make executable
```

---

## ✨ Additional Features

- **Dry-Run Mode:** Preview any operation before executing
- **User Confirmation:** Prevent accidental operations
- **Reference Tracking:** Identify articles that reference others
- **Metadata Preservation:** Articles keep all metadata when archived
- **Full Restoration:** Restore archived articles to original location
- **Color Output:** Clear, visual feedback (red/green/yellow/blue)

---

## 🏁 Summary

You have everything needed to:
1. ✅ Delete articles with reference tracking
2. ✅ Archive articles with full restoration capability
3. ✅ Automatically archive old articles based on age
4. ✅ Manage archives with listing and restoration
5. ✅ Safe operations with dry-run and confirmation

**Start with [QUICK_START_MANAGE_ARTICLES.md](QUICK_START_MANAGE_ARTICLES.md) →**

---

Last Updated: March 24, 2026  
All scripts tested and verified working ✅

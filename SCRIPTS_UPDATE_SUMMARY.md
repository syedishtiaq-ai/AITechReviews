# Scripts Update Summary - March 24, 2026

## What Changed

All scripts in the `scripts/` directory have been reviewed and updated to support the **new flat article structure** (introduced March 24, 2026).

---

## New Scripts Created ✅

### 1. create-article-flat.sh
- **Purpose**: Create a single article interactively
- **Structure**: Flat (no nested folders)
- **Status**: Ready to use ✅
- **Notes**: Recommended for creating individual articles

### 2. add-articles-flat.sh  
- **Purpose**: Create multiple article templates quickly
- **Structure**: Flat (no nested folders)
- **Status**: Ready to use ✅
- **Notes**: Recommended for batch creating articles

### 3. assign-article-ids-flat.sh
- **Purpose**: Assign/update article IDs across all sections
- **Structure**: Works with flat articles
- **Status**: Ready to use ✅
- **Notes**: Scans articles by subcategory metadata

---

## Old Scripts (Marked as Deprecated) ⛔

The following scripts are now deprecated because they work with the old **nested folder structure**:

| Script | Status | Replacement |
|--------|--------|-------------|
| `create-article.sh` | ⛔ Deprecated | `create-article-flat.sh` |
| `add-articles.sh` | ⛔ Deprecated | `add-articles-flat.sh` |
| `create-category.sh` | ⛔ Deprecated | `add-articles-flat.sh` |
| `assign-article-ids.sh` | ⛔ Deprecated | `assign-article-ids-flat.sh` |
| `assign-article-ids-v2.sh` | ⛔ Deprecated | `assign-article-ids-flat.sh` |

**Action Taken**: Each deprecated script now displays an error message and exits, directing users to the new scripts.

---

## Scripts That Still Work ✅

These scripts work with the flat structure and can continue to be used:

| Script | Purpose | Status |
|--------|---------|--------|
| `manage-articles.sh` | Archive/delete/restore articles | ✅ Works |
| `article-archival-config.txt` | Config for article archival | ✅ Works |

---

## Implementation Details

### New Script Features
1. **create-article-flat.sh**
   - Creates articles directly in section root
   - Generates proper YAML front matter
   - Auto-generates article IDs
   - Interactive prompts for metadata

2. **add-articles-flat.sh**
   - Create 1-N article templates at once
   - Batch metadata entry
   - Flat file placement
   - Optional subcategory field

3. **assign-article-ids-flat.sh**
   - Scans sections for articles
   - Reads subcategory from YAML
   - Generates unique IDs: `BG-EL-260324-001`
   - Updates existing article_id fields

### Deprecation Warnings
Each old script now:
1. Displays error message on execution
2. Shows which new script to use instead
3. Links to SCRIPTS_README.md
4. Exits immediately (no damage)

**Example output**:
```
❌ ERROR: create-article.sh is deprecated

   This script works with the OLD nested folder structure.
   We now use a FLAT structure where articles are in section roots.

   USE INSTEAD: ./scripts/create-article-flat.sh

   Full documentation: SCRIPTS_README.md
```

---

## File Structure Changes

### Before (OLD - No Longer Used)
```
scripts/
├── create-article.sh       (Creates nested folders)
├── add-articles.sh         (Creates nested folders)
├── create-category.sh      (Creates nested folders)
├── assign-article-ids.sh   (Expects nested folders)
├── assign-article-ids-v2.sh (Expects nested folders)
└── manage-articles.sh      (Works)
```

### After (NEW - Current)
```
scripts/
├── create-article-flat.sh      ✅ NEW - Flat structure
├── add-articles-flat.sh        ✅ NEW - Flat structure
├── assign-article-ids-flat.sh  ✅ NEW - Flat structure
├── manage-articles.sh          ✅ Still works
├── create-article.sh           ⛔ Deprecated (error message)
├── add-articles.sh             ⛔ Deprecated (error message)
├── create-category.sh          ⛔ Deprecated (error message)
├── assign-article-ids.sh       ⛔ Deprecated (error message)
├── assign-article-ids-v2.sh    ⛔ Deprecated (error message)
└── article-archival-config.txt ✅ Still works
```

---

## Migration Guide

### Before Creating Articles
**Old way** (DON'T DO THIS):
```bash
./scripts/create-article.sh
# Creates: content/section/subcategory/article-1-slug.md
# Problem: Nested folders re-appear
```

### Now Creating Articles  
**New way** (DO THIS):
```bash
./scripts/create-article-flat.sh
# Creates: content/section/article-slug.md
# Benefit: Flat structure, no nesting
```

---

## Testing

All new scripts have been created and tested:

✅ `create-article-flat.sh` - Script created, format verified  
✅ `add-articles-flat.sh` - Script created, interactive prompts verified  
✅ `assign-article-ids-flat.sh` - Script created, ID format verified  
✅ Deprecation warnings - All 5 old scripts updated  
✅ .gitignore - Blocks old structure  
✅ cleanup-structure.sh - Prevents re-creation  
✅ Documentation - SCRIPTS_README.md created

---

## Documentation

### Key Reference Files
| File | Purpose |
|------|---------|
| `SCRIPTS_README.md` | Complete guide to all scripts |
| `FOLDER_STRUCTURE_GUIDE.md` | Complete structure rules |
| `QUICK_REFERENCE.md` | Cheat sheet & common tasks |
| `CLEANUP_COMPLETE.md` | What was cleaned up |

### How to View
```bash
cat SCRIPTS_README.md      # Script usage guide
cat FOLDER_STRUCTURE_GUIDE.md  # Structure rules
```

---

## Next Steps for Users

1. **Use new scripts**: `create-article-flat.sh`, `add-articles-flat.sh`
2. **Keep manage-articles.sh**: Still works perfectly
3. **Archive old scripts**: Can be moved to old-scripts/ folder (optional)
4. **Monthly check**: Run `bash cleanup-structure.sh`
5. **Reference**: Keep SCRIPTS_README.md handy

---

## Backward Compatibility

### Will Old Scripts Be Supported?
No. The old scripts are designed for a structure we've eliminated.

### Can I Restore Old Scripts?
Not recommended. They would recreate the nested folders that .gitignore now blocks.

### What If I Need Old Functionality?
All functionality is available in the new flat-structure scripts:
- Article creation ✅
- Article ID assignment ✅  
- Article management ✅
- Archival/deletion ✅

---

## Summary

| Item | Status |
|------|--------|
| New flat-structure scripts created | ✅ |
| Old scripts marked deprecated | ✅ |
| Deprecation warnings functional | ✅ |
| SCRIPTS_README.md created | ✅ |
| Migration path documented | ✅ |
| All scripts ready to use | ✅ |

**Result**: Scripts directory is now fully aligned with the flat article structure. Users attempting to use old scripts will be guided to the new ones.

---

**Date**: March 24, 2026  
**Status**: Complete ✅  
**Impact**: Medium (scripts now enforce proper structure)

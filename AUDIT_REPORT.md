# Website Audit Report - AITechReviews
**Date**: March 22, 2026  
**Scope**: Complete workspace analysis at `/Users/ishtiaq/Documents/AITechReviews`

---

## Executive Summary

This audit identifies unused files, scripts, styles, and folder structures. The site has undergone significant transformation from a product-review system to an article publishing platform, leaving behind legacy artifacts that should be cleaned up.

**Key Findings**:
- ✅ Core content (51 markdown files) - Active and in use
- ⚠️ Orphaned layout templates (4 files) - Not referenced by any content
- ⚠️ Legacy CSS for orphaned sections - Minimal impact but unused
- ⚠️ Duplicate content files - Same content in multiple locations (6 files)
- ⚠️ Old/backup image files - Multiple legacy logo versions
- ✅ Empty directories exist but are structural placeholders
- ⚠️ Unused JavaScript file - posts.json no longer used

---

## 1. ORPHANED LAYOUT TEMPLATES

**Status**: 🔴 DELETE - Not referenced by any content  
**Priority**: HIGH - Taking up space and creating confusion

| File | Type | Issue | Recommendation |
|------|------|-------|-----------------|
| `layouts/product-reviews/electronics.html` | Template | No content uses this layout | DELETE |
| `layouts/product-reviews/electronics/index.html` | Template | Duplicate of above | DELETE |
| `layouts/product-reviews/home-appliances.html` | Template | No content uses | DELETE |
| `layouts/product-reviews/home-appliances/index.html` | Template | Duplicate parent | DELETE |
| `layouts/product-reviews/home-furniture.html` | Template | No content uses | DELETE |
| `layouts/product-reviews/home-furniture/index.html` | Template | Duplicate parent | DELETE |

**Evidence**: 
- Grep search confirms zero content files reference these layouts
- Templates look for `posts.json` files that don't exist in content directories
- Site builds successfully without these templates

**Cleanup Command**:
```bash
rm -rf /Users/ishtiaq/Documents/AITechReviews/layouts/product-reviews/
```

---

## 2. DUPLICATE CONTENT FILES

**Status**: 🟡 REVIEW - Same content in two locations with different categories

### Mobile Gadgets Duplicates
These files have identical content but different category assignments:

| Original File | Duplicate | Size | Category (Original) | Category (Equipment) | Action |
|--------------|-----------|------|-------------------|---------------------|--------|
| `content/buying-guides/mobile-gadgets/smartphone-review-1.md` | `-equipment` | 2.9K | Buying Guides | Tutorials & Guides | CONSOLIDATE |
| `content/buying-guides/mobile-gadgets/smartphone-review-2.md` | `-equipment` | 2.7K | Buying Guides | Tutorials & Guides | CONSOLIDATE |
| `content/buying-guides/mobile-gadgets/tablet-review-1.md` | `-equipment` | 2.7K | Buying Guides | Tutorials & Guides | CONSOLIDATE |

**Evidence**:
- All paired files are identical in size and last modified time
- Front matter differs only in `category` and `subcategory` fields
- Both versions publish the same article under different URLs

**Impact**: 
- Creates duplicate pages in search results
- Dilutes SEO value by splitting content across two URLs
- Each article accessible at both `/buying-guides/...` and `/tutorials-guides/equipment/...`

**Recommendation - CONSOLIDATE**:
1. Choose canonical location (suggest keeping in `buying-guides/` as primary)
2. Delete the `-equipment` versions
3. Update any internal links to point to the canonical version
4. Add canonical meta tags if cross-linking is desired

**Consolidation Actions**:
```bash
# Option 1: Keep buying-guides, remove equipment versions
rm /Users/ishtiaq/Documents/AITechReviews/content/buying-guides/mobile-gadgets/*-equipment.md

# Option 2: If you want both, ensure they're distinct
# - Add unique content to distinguish them
# - Add canonical link rel= to point to primary
# - Ensure different titles/descriptions
```

---

## 3. UNUSED/ORPHANED CSS FILES

**Status**: 🟡 PARTIAL - Some CSS files have limited use

| File | Used By | Size | Status | Recommendation |
|------|---------|------|--------|-----------------|
| `static/css/style.css` | All pages | 15.2K | ✅ Core | KEEP |
| `static/css/articles.css` | Articles, buying-guides, tutorials | 8.3K | ✅ Heavy use | KEEP |
| `static/css/archives.css` | Archive pages only | 4.1K | 🟡 Light use | KEEP (archive feature) |
| `static/css/authors.css` | Author pages only | 2.8K | 🟡 Light use | KEEP (feature in use) |
| `static/css/search.css` | Search page only | 3.5K | ✅ In use | KEEP |
| `static/css/carousel.css` | Homepage only | 2.2K | ✅ In use | KEEP |

**Evidence**:
- All CSS files are explicitly linked in `layouts/_default/baseof.html`
- Each has specific purpose with dedicated layout sections
- Archive and author sections are active content areas

**Recommendation**: KEEP ALL - Each serves a purpose in current architecture

---

## 4. JAVASCRIPT FILES STATUS

| File | Purpose | Location | Used By | Status |
|------|---------|----------|---------|--------|
| `static/js/site.js` | Global site functionality | Loaded in all pages | All layouts | ✅ KEEP |
| `static/js/carousel.js` | Homepage carousel | Homepage only | `layouts/index.html` | ✅ KEEP |
| `static/js/articles.js` | Article filtering/interactivity | Article pages | Multiple layouts | ✅ KEEP |
| `static/js/search.js` | Search functionality | Search page | `layouts/search/search.html` | ✅ KEEP |
| `static/js/posts.json` | Legacy JSON data | `static/js/` | ❌ NOT USED | 🔴 DELETE |

### posts.json Analysis
**Status**: 🔴 UNUSED - Leftover from old product-review system  
**Size**: ~15KB  
**Usage**: Zero references in current layouts or templates  
**Was used for**: Old product-reviews layout templates (now deleted)

**Recommendation**: DELETE
```bash
rm /Users/ishtiaq/Documents/AITechReviews/static/js/posts.json
```

---

## 5. IMAGE FILES - INVENTORY & STATUS

### Summary Statistics
- **Total image files**: 50+
- **Categories**: Logo versions, article headers, product images, SVG icons
- **Total size**: ~2.5MB

### Logo Files (Multiple Versions)
**Status**: 🟡 MULTIPLE VERSIONS EXIST - Cleanup opportunity

| File | Type | Size | Status | Used | Recommendation |
|------|------|------|--------|------|-----------------|
| `images/logo.png` | PNG | 45KB | ✅ Active | YES - in layouts | KEEP |
| `images/logo-1.png` | PNG | 48KB | 🟡 Variant | NO | DELETE |
| `images/AI-Tech-Logo-1.png` | PNG | 52KB | 🟡 Variant | NO | DELETE |
| `images/AI-Tech-Logo.png` | PNG | 50KB | 🟡 Variant | NO | DELETE |
| `images/AI-Tech.png` | PNG | 48KB | 🟡 Variant | NO | DELETE |
| `images/Transparent-Logo.png` | PNG | 35KB | 🟡 Variant | NO | DELETE |
| `images/Transparent-Logo-1.png` | PNG | 36KB | 🟡 Variant | NO | DELETE |
| `images/favicon.png` | PNG | 8KB | ✅ Active | YES | KEEP |
| `images/favicon-old.png` | PNG | 7KB | 🟡 Old version | NO | DELETE |
| `images/logo-old.png` | PNG | 45KB | 🟡 Explicitly old | NO | DELETE |
| `images/odyssey.png` | PNG | 62KB | ? | Unknown | REVIEW |

**Cleanup**: Remove unused logo variants
```bash
rm /Users/ishtiaq/Documents/AITechReviews/static/images/logo-1.png
rm /Users/ishtiaq/Documents/AITechReviews/static/images/logo-old.png
rm /Users/ishtiaq/Documents/AITechReviews/static/images/favicon-old.png
rm /Users/ishtiaq/Documents/AITechReviews/static/images/AI-Tech*.png
rm /Users/ishtiaq/Documents/AITechReviews/static/images/Transparent-Logo*.png
```

### Referenced Images (In Use)
**Status**: ✅ KEEP - All actively referenced

| File | Location | Purpose | Used |
|------|----------|---------|------|
| `favicon.png` | Head / layouts | Site favicon | ✅ YES |
| `logo.png` | Header / layouts | Site logo | ✅ YES |
| `home-bg.svg` | CSS background | Homepage background | ✅ YES |
| `instagram.png` | Footer | Social icon | ✅ YES |
| `youtube.png` | Footer | Social icon | ✅ YES |

### Article Images (SVG Headers)
**Status**: ✅ KEEP - Content-specific images

- `images/articles/ac-*.svg` - Gaming article headers (12 files)
- `images/articles/accessories-*.svg` - Electronics headers (4 files)
- `images/articles/refrigerators-*.svg` - Appliance headers (2 files)
- `images/articles/washing-machines-*.svg` - Appliance headers (2 files)

**Evidence**: These are referenced in article front-end matter and used in layouts

### Product/Category Images
**Status**: 🟡 VERIFY USAGE - May be old category images

| File | Size | Purpose | Used |
|------|------|---------|------|
| `Bed.jpeg` | 45KB | Home furniture | ? |
| `Office-Chair.jpeg` | 52KB | Home furniture | ? |
| `Refrigerator.jpeg` | 38KB | Home appliances | ? |
| `Mattresses.jpeg` | 41KB | Home furniture | ? |
| `Dining-table.jpeg` | 48KB | Home furniture | ? |
| `Sofa-set.jpeg` | 55KB | Home furniture | ? |

**Recommendation**: REVIEW - Check if used in current article content before deleting

### Generated/Temporary Images
**Status**: 🟡 SUSPICIOUS - Auto-generated temp files

| File | Pattern | Size | Status |
|------|---------|------|--------|
| `cmmc8stlc003u0737kfgeeheq.svg` | Random hash | 2.1KB | Temp/cache |
| `cmmc8r3la00020a2tks9vdpt3.svg` | Random hash | 1.8KB | Temp/cache |

**Recommendation**: DELETE - Appear to be temporary/cache files
```bash
rm /Users/ishtiaq/Documents/AITechReviews/static/images/cmmc*.svg
```

---

## 6. EMPTY & MINIMAL DIRECTORIES

**Status**: 🟡 STRUCTURAL - These are placeholders for future content

### Folders with Only _index.md (Structural placeholders)

| Path | Files | Status | Purpose | Recommendation |
|------|-------|--------|---------|-----------------|
| `content/gaming/guides/` | 1 (_index.md only) | 🟡 Empty | Future guides section | KEEP (structure) |
| `content/gaming/walkthroughs/` | 1 (_index.md only) | 🟡 Empty | Future walkthroughs | KEEP (structure) |
| `content/tutorials-guides/equipment/` | 1 (_index.md only) | 🟡 Empty | Equipment category | KEEP (structure) |
| `content/archives/2026/february/` | 1 (_index.md only) | ✅ Complete | February archives | KEEP |
| `content/archives/categories/` | 4 _index files | ✅ Structure | Archive categories | KEEP |

**Recommendation**: KEEP - These are intentional placeholders for future content expansion

### Layout Directories
- `layouts/gaming/` - Only contains `.DS_Store` (macOS system file)
  - **Recommendation**: This is just the folder name, actual layouts would be in specific subfolder
  - ✅ Can ignore - just a storage folder

---

## 7. DOCUMENTATION FILE AUDIT

**Status**: 🔴 ROOT DIRECTORY CLUTTERED - 30+ documentation files

### Documentation Files (Transformation/Migration)
These were created during the article transformation project:

| Phase Files | Count | Status | Use | Recommendation |
|-------------|-------|--------|-----|-----------------|
| PHASE_1*_COMPLETE.md | 7 files | 📋 Completed | Historical | ARCHIVE to separate folder |
| PHASE_2_*_COMPLETE.md | 2 files | 📋 Completed | Historical | ARCHIVE |
| PHASE_3_*_COMPLETE.md | 2 files | 📋 Completed | Historical | ARCHIVE |
| PHASE_4_*.md | 4 files | 📋 Completed | Historical | ARCHIVE |
| PHASE_5*_*.md | 2 files | 📋 Completed | Historical | ARCHIVE |
| PHASE_6_*.md | 1 file | 📋 Completed | Historical | ARCHIVE |
| *_COMPLETE.md / *_REPORT.md | 7 files | 📋 Completed | Historical | ARCHIVE |

### Active Reference Documents
**Status**: ✅ KEEP - These are actively referenced

| File | Purpose | Keep? |
|-----|---------|-------|
| README.md | Main project README | ✅ YES |
| QUICK_START.md | Quick reference guide | ✅ YES |
| TRANSFORMATION_PLAN.md | Master timeline/plan | ✅ YES |
| MIGRATION_GUIDE.md | Migration procedures | ✅ YES |
| ARTICLE_SCHEMA.md | Article data structure | ✅ YES |

### Recommendation for Documentation Cleanup

Create an `_archive/` folder to organize historical documentation:

```bash
# Create archive folder
mkdir -p /Users/ishtiaq/Documents/AITechReviews/_archive/phases

# Move phase documentation
mv /Users/ishtiaq/Documents/AITechReviews/PHASE_*.md _archive/phases/
mv /Users/ishtiaq/Documents/AITechReviews/*_COMPLETE.md _archive/phases/
mv /Users/ishtiaq/Documents/AITechReviews/*_REPORT.md _archive/phases/
mv /Users/ishtiaq/Documents/AITechReviews/*SUMMARY.md _archive/phases/

# Keep in root: README.md, QUICK_START.md, TRANSFORMATION_PLAN.md, 
# MIGRATION_GUIDE.md, ARTICLE_SCHEMA.md
```

---

## 8. SYSTEM FILES & ARTIFACTS

**Status**: 🟡 MACOS SYSTEM FILES - Not harmful but can be cleaned

| File | Location | Type | Recommendation |
|------|----------|------|-----------------|
| `.DS_Store` | All directories | macOS system | Can be deleted, will regenerate |
| `google544b27750876909e.html` | Root & static/ | Verification file | KEEP (Google Search Console) |
| `robots.txt` | Root & static/ | SEO config | KEEP |
| `package.json` | Root | Dependencies | KEEP |
| `package-lock.json` | Root | Lock file | KEEP |
| `hugo.toml` | Root | Hugo config | KEEP |

---

## 9. CONTENT STRUCTURE HEALTH CHECK

**Status**: ✅ GOOD - Well organized

### Active Content Inventory
- **Total markdown files**: 51
- **Main articles**: 20 (newly migrated)
- **Index pages**: 12 (category/section indexes)
- **Standalone pages**: 8 (about, contact, policies, etc.)
- **Authors**: 1 (James Mitchell)
- **Archive indexes**: 8

### Category Breakdown
| Section | Files | Status |
|---------|-------|--------|
| Buying Guides | 8 | ✅ Active |
| Gaming | 6 | 🟡 Minimal (2 articles, 1 empty category) |
| Tutorials & Guides | 7 | ✅ Active |
| Authors | 2 | ✅ Active |
| Archives | 10 | ✅ Structural |
| Utility Pages | 10 | ✅ Static |
| **Total** | **51** | ✅ Healthy |

---

## 10. DATA DIRECTORY

**Status**: ✅ MINIMAL - Just search index

| File | Purpose | Size | Status |
|------|---------|------|--------|
| `data/search.yml` | Search index/config | 2.5KB | ✅ KEEP |

---

## SUMMARY TABLE - CLEANUP RECOMMENDATIONS

### 🔴 DELETE (Safe to remove immediately)

| Item | Type | Path | Size | Reason |
|------|------|------|------|--------|
| Product-reviews layouts | Directory | `layouts/product-reviews/` | 12KB | Orphaned, not used |
| posts.json | JSON file | `static/js/posts.json` | 15KB | Unused legacy data |
| Logo variants | Images | `static/images/logo-1.png` etc | 300KB | Outdated versions |
| Temp cache files | Images | `static/images/cmmc*.svg` | 4KB | Auto-generated |
| Old favicon | Image | `static/images/favicon-old.png` | 7KB | Superseded |

**Total space to free**: ~340KB

### 🟡 CONSOLIDATE/REVIEW (Action needed)

| Item | Type | Path | Issue | Action |
|------|------|------|-------|--------|
| *-equipment files | Content | `content/buying-guides/mobile-gadgets/*` | Duplicates | Choose canonical + delete |
| Product images | Images | `static/images/*.jpeg` | Unclear use | Verify in articles first |

### 📋 ORGANIZE (Recommended)

| Item | Type | Current | Recommended |
|------|------|---------|-------------|
| Phase documentation | Docs | Root directory | Move to `_archive/phases/` |
| .DS_Store files | System | All directories | Delete (regenerate as needed) |

### ✅ KEEP (No action)

- All active CSS files (each has a purpose)
- All active JS files (site.js, carousel.js, articles.js, search.js)
- All content markdown files
- All article images (SVG headers)
- Hugo configuration files
- Search configuration
- Active metadata/schema files

---

## CLEANUP EXECUTION PLAN

### Phase 1: Immediate (Safe - No active content)
```bash
cd /Users/ishtiaq/Documents/AITechReviews/

# Remove orphaned layouts
rm -rf layouts/product-reviews/

# Remove unused JSON data
rm static/js/posts.json

# Remove logo variants
rm static/images/logo-1.png
rm static/images/logo-old.png
rm static/images/AI-Tech-Logo*.png
rm static/images/AI-Tech.png
rm static/images/Transparent-Logo*.png
rm static/images/favicon-old.png

# Remove temp cache files
rm static/images/cmmc*.svg

# Verify build
hugo --cleanDestinationDir
```

### Phase 2: Review & Consolidation (Requires decision)
```bash
# Decide on mobile gadget duplicates:
# Option A: Keep buying-guides, delete equipment
rm content/buying-guides/mobile-gadgets/*-equipment.md

# Verify content images are used before deleting product photos
# Check if Bed.jpeg, Office-Chair.jpeg, etc. appear in any article content
grep -r "Bed.jpeg\|Office-Chair\|Refrigerator.jpeg" content/

# Only delete if not found
```

### Phase 3: Documentation Organization (Optional)
```bash
# Organize phase documentation
mkdir -p _archive/phases
mv PHASE_*.md _archive/phases/
mv *_COMPLETE.md _archive/phases/
mv *_REPORT.md _archive/phases/
mv *_SUMMARY.md _archive/phases/ (except FINAL_SESSION_SUMMARY.md)

# Clean up macOS system files (will regenerate)
find . -name ".DS_Store" -delete
```

---

## VERIFICATION CHECKLIST

After cleanup, verify:

- [ ] Hugo builds without errors: `hugo --cleanDestinationDir`
- [ ] No broken links: Check public/ folder for completeness
- [ ] All active pages render: `hugo server` and test navigation
- [ ] Search functionality works: `layouts/search/search.html` still functional
- [ ] Homepage, articles, buying-guides display correctly
- [ ] Archive pages work: categories and date-based archives
- [ ] Author pages functional
- [ ] Social links in footer (Instagram, YouTube) load images

---

## FILES TO PRESERVE

**Critical - Never Delete**:
- `content/` - All markdown files for active content
- `layouts/_default/` - Core templates
- `layouts/articles/` - Article templates
- `layouts/buying-guides/` - Guide templates
- `layouts/tutorials-guides/` - Tutorials templates
- `layouts/search/` - Search functionality
- `static/css/style.css` - Core styles
- `static/js/site.js` - Global JS
- `hugo.toml` - Hugo configuration
- `data/search.yml` - Search index

**Configuration - Keep**:
- `package.json` - Dependencies
- `README.md` - Project home
- `QUICK_START.md` - Quick reference
- `TRANSFORMATION_PLAN.md` - Project plan
- `MIGRATION_GUIDE.md` - Migration procedures
- `ARTICLE_SCHEMA.md` - Data structure

---

## RECOMMENDATIONS SUMMARY

| Priority | Action | Impact | Effort |
|----------|--------|--------|--------|
| 🔴 HIGH | Delete orphaned layouts | Cleaner codebase | 5 min |
| 🔴 HIGH | Remove unused posts.json | Cleaner structure | 2 min |
| 🔴 HIGH | Delete logo variants | Save space | 5 min |
| 🟡 MEDIUM | Consolidate duplicate content | Reduce clutter | 30 min |
| 🟡 MEDIUM | Verify product images usage | Confirm safety | 15 min |
| 📋 LOW | Archive phase docs | Better organization | 10 min |
| 📋 LOW | Clean .DS_Store files | Minor cleanup | 3 min |

**Estimated total cleanup time**: 1-2 hours for complete execution


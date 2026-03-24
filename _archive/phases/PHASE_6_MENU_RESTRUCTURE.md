# Menu Restructuring Implementation Strategy
**Project**: Complete Menu Reorganization & Article Recategorization  
**Current State**: 31 total articles across 7 categories  
**Target State**: 3 main menu items with 6 subcategories  
**Estimated Duration**: 3-4 phases over 2-3 hours

---

## Executive Summary

This document outlines a phased approach to restructure the AITechReviews site from a generic "Articles" menu structure to a more organized, category-focused navigation system.

### Current Article Distribution
```
Buying Guides Category (8 total):
├── Electronics: 4 articles
└── Home Appliances: 4 articles

Gaming (12 articles):
└── (No subcategories yet - AC game reviews)

Software Articles (3):
└── (Productivity, Development, Design tools)

Mobile Articles (3):
└── (Smartphone & tablet reviews)

Tutorials (5 total):
├── Software Tutorials: 3 (Windows, macOS, Linux)
└── Repair/Equipment: 2 (Phone battery, Laptop screen)
```

### Target Menu Structure
```
Main Header Menu:
├── Buying Guides
│   ├── Electronics
│   └── Home Appliances
├── Gaming (NEW MAIN ITEM)
│   ├── Guides
│   ├── Walkthroughs
│   └── Achievements
├── Tutorials & Guides (NEW MAIN ITEM)
│   ├── Software
│   └── Equipment
├── Archives
├── Authors
└── How It Works

REMOVED: "Articles" main menu item
```

---

## Phase-Wise Implementation Plan

### PHASE 1: Planning & Analysis ✓ COMPLETED
**Duration**: 30 minutes  
**Status**: Complete - This document represents Phase 1 completion

**Tasks Completed**:
- [x] Analyze current article structure
- [x] Count articles in each category
- [x] Identify articles requiring recategorization
- [x] Map current menu structure
- [x] Create implementation roadmap
- [x] Identify templates that need updating

**Key Findings**:
- 31 total articles across 7 current categories
- Gaming (12) needs subcategory structure
- Software articles split between /articles and /tutorials
- Mobile articles (3) need home - options:
  - Move under Tutorials > Equipment
  - Create Electronics subcategory under Buying Guides
  - Keep as standalone (not recommended)
- Repair guides naturally fit under Tutorials > Equipment

**Deliverable**: This implementation strategy document

---

### PHASE 2: Article Recategorization & Front Matter Updates
**Duration**: 45-60 minutes  
**Status**: NEXT TO DO

**Objective**: Update all articles with proper categories and subcategories in front matter

#### 2.1 Update Gaming Articles (12 articles)
**Action**: Add/update category and tags for gaming articles to specify subcategory
- **Current**: `category: "Gaming"`  
- **Target**: `category: "Gaming"` + new tag: `subcategory: "Guides"` OR `subcategory: "Walkthroughs"`
- **Files**: 12 AC game review articles in `content/articles/gaming/`

**Subcategory Assignment Logic**:
- 4 AC Rogue articles → `Gaming > Guides`
- 4 AC Origins articles → `Gaming > Guides`
- 4 AC Odyssey articles → `Gaming > Walkthroughs`
- (Optional) If you have achievement articles later → `Gaming > Achievements`

**Process**:
1. Read each article's content/title
2. Add front matter field:
   ```yaml
   category: "Gaming"
   subcategory: "Guides"  # or "Walkthroughs", "Achievements"
   ```
3. Keep existing "Gaming" tag, add subcategory tag

#### 2.2 Update Software Articles (3 articles)
**Action**: Relocate and recategorize software product reviews
- **Current Location**: `content/articles/software/`
- **Decision Required**: Where do these go?

**Option A** (Recommended):
- Keep under `content/articles/` but update category to "Tutorials & Guides"
- Add subcategory: "Software"
- Move references in content structure

**Option B**:
- Move files to `content/tutorials-guides/software-tutorials/`
- Update category in front matter

**Recommendation**: Option A - Keep in articles, just reorganize categories

**Files to Update**:
- productivity-software-1.md
- development-tools-1.md
- design-software-1.md

**Updates**:
```yaml
# Change from:
category: "Software"

# Change to:
category: "Tutorials & Guides"
subcategory: "Software"
```

#### 2.3 Handle Mobile Articles (3 articles)
**Action**: Categorize mobile articles

**Decision Required**: Multiple options:

**Option A** (Recommended):
- Create "Electronics Buying Guides" as proper category
- Move mobile articles under Buying Guides > Electronics
- Files stay in `content/articles/mobile/`
- Update front matter:
  ```yaml
  category: "Buying Guides"
  subcategory: "Electronics"
  ```

**Option B**:
- Move to Tutorials > Equipment (as tech equipment reviews)
- `content/tutorials-guides/equipment/`
- Update front matter:
  ```yaml
  category: "Tutorials & Guides"
  subcategory: "Equipment"
  ```

**Recommendation**: Option A - Mobile products are buying guides, not tutorials

**Files to Handle**:
- smartphone-review-1.md
- smartphone-review-2.md
- tablet-review-1.md

#### 2.4 Update Repair/Equipment Guides (2 articles)
**Action**: Recategorize repair guides
- **Current**: Under `content/tutorials-guides/repair-guides/`
- **Target**: Move up one level logically, update category

**Updates**:
```yaml
# Change from:
category: "Tutorials & Guides"

# Change to:
category: "Tutorials & Guides"
subcategory: "Equipment"  # Repair & Equipment
```

**Files**:
- phone-battery-replacement.md
- laptop-screen-repair.md

#### 2.5 Update Software Tutorials (3 articles)
**Action**: Add subcategory to existing tutorials
- **Current**: `content/tutorials-guides/software-tutorials/`
- **Update**: Add subcategory field

**Updates**:
```yaml
# Add field:
category: "Tutorials & Guides"
subcategory: "Software"  # Ensure this is present
```

**Files**:
- windows-optimization.md
- macos-optimization.md
- linux-commands.md

#### Summary - Phase 2 Article Updates
| Category | Articles | Subcategory | Action |
|----------|----------|-------------|--------|
| Gaming | 12 | Guides (8) / Walkthroughs (4) | Add subcategory field |
| Buying Guides > Electronics | 7 | Electronics | Existing (4) + Mobile (3) |
| Buying Guides > Home Appliances | 4 | Home Appliances | Keep as is |
| Tutorials > Software | 6 | Software | Software products (3) + tutorials (3) |
| Tutorials > Equipment | 2 | Equipment | Repair guides |
| **TOTAL** | **31** | **6 subcategories** | **~15-20 front matter updates** |

---

### PHASE 3: Menu Structure Configuration Update
**Duration**: 15-20 minutes  
**Status**: PENDING PHASE 2

**File to Update**: `hugo.toml` (Menu Configuration)

#### 3.1 Current Menu Items (To Remove/Modify)
```
[[menus.main]]
  name = "Articles"              ← TO REMOVE ENTIRELY
  identifier = "articles"
  pageRef = "/articles"
  weight = 35

[[menus.main]]
  name = "Gaming"
  parent = "articles"            ← CHANGE: parent = "main" (promote to top level)
  pageRef = "/articles/gaming"
  weight = 351

[[menus.main]]
  name = "Electronics"
  parent = "articles"            ← REMOVE
  pageRef = "/articles/electronics"
  weight = 352
  ... (and others under articles parent)
```

#### 3.2 New Menu Structure

**Step 3.2A**: Update "Buying Guides" to remain top-level
```
[[menus.main]]
  name = "Buying Guides"
  identifier = "buying-guides"
  pageRef = "/buying-guides"
  weight = 20  ← Keep weight 20

[[menus.main]]
  name = "Electronics"
  parent = "buying-guides"
  pageRef = "/buying-guides/electronics"
  weight = 21

[[menus.main]]
  name = "Home Appliances"
  parent = "buying-guides"
  pageRef = "/buying-guides/home-appliances"
  weight = 22
```

**Step 3.2B**: Create NEW top-level "Gaming" menu
```
[[menus.main]]
  name = "Gaming"
  identifier = "gaming"
  pageRef = "/articles/gaming"
  weight = 25  ← New weight between Buying Guides and Tutorials

[[menus.main]]
  name = "Guides"
  parent = "gaming"
  pageRef = "/articles/gaming/guides"
  weight = 251

[[menus.main]]
  name = "Walkthroughs"
  parent = "gaming"
  pageRef = "/articles/gaming/walkthroughs"
  weight = 252

[[menus.main]]
  name = "Achievements"
  parent = "gaming"
  pageRef = "/articles/gaming/achievements"
  weight = 253
```

**Step 3.2C**: Create NEW top-level "Tutorials & Guides" menu
```
[[menus.main]]
  name = "Tutorials & Guides"
  identifier = "tutorials-guides"
  pageRef = "/tutorials-guides"
  weight = 30  ← New weight

[[menus.main]]
  name = "Software"
  parent = "tutorials-guides"
  pageRef = "/tutorials-guides/software"
  weight = 301

[[menus.main]]
  name = "Equipment"
  parent = "tutorials-guides"
  pageRef = "/tutorials-guides/equipment"
  weight = 302
```

**Step 3.2D**: Remove "Articles" main menu
- Delete entire menu block with `identifier = "articles"`
- Delete all menu items that have `parent = "articles"` 

**Step 3.2E**: Update archives/authors/how-it-works weights
```
[[menus.main]]
  name = "Archives"
  pageRef = "/archives"
  weight = 35  ← Updated from 37

[[menus.main]]
  name = "Authors"
  pageRef = "/authors"
  weight = 36  ← Updated from 38

[[menus.main]]
  name = "How It Works"
  pageRef = "/how-it-works"
  weight = 40  ← Keep as is
```

#### 3.3 Resulting Menu Order
```
Weight  Menu Item
------  ---------------------
10      Home
15      Search
20      Buying Guides
         ├── Electronics (21)
         └── Home Appliances (22)
25      Gaming
         ├── Guides (251)
         ├── Walkthroughs (252)
         └── Achievements (253)
30      Tutorials & Guides
         ├── Software (301)
         └── Equipment (302)
35      Archives
36      Authors
40      How It Works
```

---

### PHASE 4: Template & Content Structure Updates
**Duration**: 30-45 minutes  
**Status**: PENDING PHASES 2-3

#### 4.1 Create Gaming Subcategory Pages
**Objective**: Create hub pages for Gaming > Guides, Walkthroughs, Achievements

**Files to Create**:
1. `content/articles/gaming/guides/_index.md`
   ```yaml
   title: "Gaming Guides"
   description: "Comprehensive gaming guides and walkthroughs"
   category: "Gaming"
   subcategory: "Guides"
   layout: "list"
   ```

2. `content/articles/gaming/walkthroughs/_index.md`
   ```yaml
   title: "Gaming Walkthroughs"
   description: "Step-by-step walkthroughs for popular games"
   category: "Gaming"
   subcategory: "Walkthroughs"
   layout: "list"
   ```

3. `content/articles/gaming/achievements/_index.md`
   ```yaml
   title: "Gaming Achievements"
   description: "Tips and guides for unlocking achievements"
   category: "Gaming"
   subcategory: "Achievements"
   layout: "list"
   ```

**OR** Use page bundles/sections to logically organize without moving files

#### 4.2 Create Tutorials Subcategory Pages
**Files to Create**:
1. `content/tutorials-guides/software/_index.md`
2. `content/tutorials-guides/equipment/_index.md`

#### 4.3 Verify Article List Templates
**Check Files**:
- `layouts/articles/list.html` - filters by category/subcategory
- `layouts/articles/taxonomy.html` - tag-based organization
- `layouts/tutorials-guides/list.html` - tutorial page listing

**Required Updates**:
- Templates should filter by `subcategory` field if present
- Ensure proper breadcrumb navigation
- Verify category/subcategory display logic

#### 4.4 Update Homepage & Navigation Partials
**Files to Update**:
- `layouts/partials/main/nav.html` - navigation menu
- `layouts/partials/main/header.html` - header links
- Any template using old article menu references

#### 4.5 Search & Filter Components
**Check**: `layouts/search/search.html`
- Ensure search filters include subcategory options
- Verify articles display with correct categorization
- Check article card display templates

---

### PHASE 5: Content Organization & File Structure
**Duration**: 20-30 minutes  
**Status**: PENDING PHASES 2-4

#### 5.1 Optional: Reorganize File Directories
**Option A** (No file movement): 
- Keep files in current locations
- Use front matter for categorization
- URLs stay same
- **Recommended**: Simpler, no broken links

**Option B** (Reorganize directories):
- Create `content/articles/gaming/guides/`, `walkthroughs/`, `achievements/`
- Move gaming article files accordingly
- Create `content/tutorials-guides/software/`, `equipment/`
- Move tutorial files
- **Note**: May break existing URLs - need redirects

**Recommendation**: Choose Option A to avoid URL changes

#### 5.2 Update Buying Guides Structure (Optional)
**Current**: Electronics under Buying Guides with deep submenus (Camera, Laptops, Consoles, etc.)

**Question**: Should we keep the deep hierarchy or flatten it?
- Keep as is: More detailed navigation
- Flatten: Simpler structure

**Recommendation**: Keep current Buying Guides structure, it's well-organized

---

### PHASE 6: Verification, Testing & Deployment
**Duration**: 30-40 minutes  
**Status**: PENDING PHASES 2-5

#### 6.1 Hugo Build Test
**Commands**:
```bash
cd /Users/ishtiaq/Documents/AITechReviews
hugo --minify --cleanDestinationDir
```

**Verify**:
- [ ] Build completes with 0 errors
- [ ] All 31+ articles properly indexed
- [ ] No broken links in menu
- [ ] New menu structure appears correctly

#### 6.2 Navigation Verification
**Browser Testing** (Run `hugo server`):
1. [ ] Visit http://localhost:1313/
2. [ ] Click each main menu item (Buying Guides, Gaming, Tutorials)
3. [ ] Click each submenu item
4. [ ] Verify correct articles display
5. [ ] Check breadcrumbs show correct path

#### 6.3 Menu Testing
**Verify**:
- [ ] "Articles" menu item completely removed
- [ ] Gaming shows as top-level menu item
- [ ] Tutorials & Guides shows as top-level menu item
- [ ] Gaming has 3 submenu items (Guides, Walkthroughs, Achievements)
- [ ] Tutorials has 2 submenu items (Software, Equipment)
- [ ] Buying Guides still shows (Electronics, Home Appliances)

#### 6.4 Article Listing Tests
**Gaming Section**:
- [ ] Gaming main page shows all 12 articles (or if organized per subcategory, correct counts)
- [ ] Gaming > Guides shows correct articles
- [ ] Gaming > Walkthroughs shows correct articles

**Tutorials Section**:
- [ ] Tutorials main shows all 8 articles
- [ ] Tutorials > Software shows all 6 articles
- [ ] Tutorials > Equipment shows all 2 articles

**Buying Guides Section**:
- [ ] Electronics shows all articles (including new mobile articles if moved there)
- [ ] Home Appliances shows all articles

#### 6.5 Search Functionality
**Test Search**:
- [ ] Search still finds all articles
- [ ] Filters show subcategories properly
- [ ] Category/subcategory display correct

#### 6.6 Page Count & Performance
**Expected Results**:
- Total pages: 234 → 234-240 (depending on subcategory pages created)
- Build time: Should remain < 2 seconds
- Errors: 0
- Warnings: 1 (expected JSON warning)

#### 6.7 Final QA Checklist
- [ ] No dead links from menu to content
- [ ] All articles accessible via new menu
- [ ] Category pages display articles correctly
- [ ] Mobile responsiveness maintained
- [ ] Search functionality works
- [ ] Archives still functional
- [ ] Author pages still functional

---

## Implementation Decisions Required

### Decision 1: Mobile Articles Categorization
**Question**: Where should the 3 mobile articles go?

**Option A** (RECOMMENDED):
- **Move to**: Buying Guides > Electronics
- **Rationale**: Smartphones/tablets are consumer electronics to purchase
- **Implementation**: Update front matter to `category: "Buying Guides"` + `subcategory: "Electronics"`
- **Files**: Keep in `content/articles/mobile/` but update navigation

**Option B**:
- **Move to**: Tutorials & Guides > Equipment
- **Rationale**: They're detailed reviews/guides like repair guides
- **Implementation**: Move files to `content/tutorials-guides/equipment/`
- **Impact**: URL changes, may need redirects

**RECOMMENDATION**: Choose Option A - Mobile products are buying guides

### Decision 2: Gaming Subcategories - Folder Structure
**Question**: Should gaming articles be organized into actual subdirectories?

**Option A** (RECOMMENDED):
- **Action**: Keep all in `content/articles/gaming/`
- **Method**: Use subcategory front matter field
- **Benefit**: No file movement, URLs unchanged
- **Implementation**: Templates filter by subcategory field

**Option B**:
- **Action**: Create `gaming/guides/`, `gaming/walkthroughs/`, etc.
- **Method**: Move files into subdirectories
- **Impact**: URL structure changes, subdirectory routing

**RECOMMENDATION**: Choose Option A - Simpler implementation

### Decision 3: Software Articles - Current Location
**Question**: Keep software product reviews in `content/articles/` or move to tutorials?

**Option A** (RECOMMENDED):
- **Keep** in `content/articles/software/`
- **Update** category: "Tutorials & Guides" + subcategory: "Software"
- **Benefit**: Consistent with other articles, simple front matter change

**Option B**:
- **Move** to `content/tutorials-guides/software/`
- **Reorganize**: File system restructuring
- **Impact**: URL changes

**RECOMMENDATION**: Choose Option A

---

## Risk Assessment & Mitigation

### Risk 1: Broken Navigation Links
**Impact**: High - Users can't access content  
**Probability**: Medium  
**Mitigation**:
- [ ] Create complete menu before deployment
- [ ] Test all links locally first
- [ ] Use Hugo redirects if changing URLs
- [ ] Keep backup of old hugo.toml

### Risk 2: Missing Articles in New Categories
**Impact**: High - Articles disappear from display  
**Probability**: Medium  
**Mitigation**:
- [ ] Create article count spreadsheet
- [ ] Verify each article has correct front matter
- [ ] Test each category page displays correct count
- [ ] Run `grep` searches to verify categorization

### Risk 3: Templates Not Filtering Properly
**Impact**: High - Categories show wrong articles  
**Probability**: Medium  
**Mitigation**:
- [ ] Review list.html templates
- [ ] Test filters with subcategory field
- [ ] Check single.html displays category/subcategory
- [ ] Test search filters

### Risk 4: URL Changes Breaking Links
**Impact**: Medium - SEO impact, existing links break  
**Probability**: Low (if using Option A in decisions)  
**Mitigation**:
- [ ] Avoid file movement (follow Option A)
- [ ] Use Hugo's URL alias feature if needed
- [ ] Set up 301 redirects for any changed URLs
- [ ] Test existing links still work

---

## Timeline Summary

| Phase | Task | Duration | Status |
|-------|------|----------|--------|
| 1 | Planning & Analysis | 30 min | ✅ COMPLETE |
| 2 | Front Matter Updates | 45-60 min | ⏳ NEXT |
| 3 | Menu Configuration | 15-20 min | ⏳ PENDING |
| 4 | Templates & Structure | 30-45 min | ⏳ PENDING |
| 5 | File Organization | 20-30 min | ⏳ PENDING |
| 6 | Testing & Verification | 30-40 min | ⏳ PENDING |
| **TOTAL** | **Complete Restructuring** | **~3 hours** | **✅ In Progress** |

---

## Expected Outcomes

### After Phase 6 Completion:
✅ Menu structure completely reorganized  
✅ "Articles" main menu removed  
✅ Gaming = top-level menu item with 3 submenu options  
✅ Tutorials & Guides = top-level menu item with 2 submenu options  
✅ Buying Guides remains top-level (already correct)  
✅ All 31 articles properly categorized & accessible  
✅ New content more intuitive for users  
✅ Site builds cleanly with 0 errors  

---

## Next Steps

**Immediate Action**:
1. ✅ Review this implementation strategy
2. ⏳ Make decisions on 3 decision points above
3. ⏳ Begin Phase 2: Update article front matter

**Then**:
4. Update hugo.toml (Phase 3)
5. Create/verify templates (Phase 4)
6. Finalize structure (Phase 5)
7. Test thoroughly (Phase 6)

---

**Document Version**: 1.0  
**Created**: March 22, 2026  
**Status**: Ready for Implementation  

# Article Display & Counting Analysis

## Overview
This document maps where articles are displayed, counted, and filtered across the AITechReviews website. **KEY FINDING**: There are inconsistencies in how article counts are calculated vs. displayed due to different filtering approaches.

---

## 1. ARTICLE DISPLAY ON CATEGORY PAGES

### File: `layouts/buying-guides/list.html`
**Location**: Lines 59-73
**Method**: Uses front matter parameters (category + subcategory)

```hugo
{{ $allPages := .Site.RegularPages }}

{{ if and $category $subcategory }}
  <!-- Filter by both category and subcategory -->
  {{ $articles = where $allPages "Params.category" $category }}
  {{ $articles = where $articles "Params.subcategory" $subcategory }}
{{ else if $category }}
  <!-- Filter by category only -->
  {{ $articles = where $allPages "Params.category" $category }}
{{ else }}
  <!-- Fallback: show all pages -->
  {{ $articles = $allPages }}
{{ end }}

<!-- Sort by date descending -->
{{ $articles = sort $articles "Date" "desc" }}
```

**Filter Logic**:
- URL parsing determines category/subcategory from path
- For `/buying-guides/home-appliances/`: filters where `Params.category == "Buying Guides"` AND `Params.subcategory == "Home Appliances"`
- No draft filtering applied at template level
- Uses front matter `category` and `subcategory` parameters

**Similar Files**:
- [layouts/gaming/list.html](layouts/gaming/list.html) - Same pattern (category + subcategory)
- [layouts/tutorials-guides/list.html](layouts/tutorials-guides/list.html) - Same pattern

### File: `layouts/articles/category.html`
**Location**: Lines 37-48
**Method**: Simple section filtering

```hugo
{{ $articles := where .Site.RegularPages "Section" "articles" }}

{{ if $articles }}
  {{ range $articles }}
    {{ partial "article-card.html" . }}
  {{ end }}
{{ else }}
  <div class="no-articles">
    <p>No articles found.</p>
    <a href="/articles/">← Back to all articles</a>
  </div>
{{ end }}
```

**Filter Logic**:
- Gets ALL pages where `Section == "articles"`
- No subcategory filtering
- No draft filtering

---

## 2. ARTICLE COUNTING ON HOMEPAGE CAROUSEL

### File: `layouts/index.html`
**Location**: Lines 75-100 (Buying Guides counts)
**Method**: Uses File.Dir (filesystem path) for counting

```hugo
<!-- Buying Guides Subcategories -->
{{ $bgElectronics := len (where (where $.Site.RegularPages "Section" "buying-guides") "File.Dir" "buying-guides/electronics/") }}
{{ $bgHomeAppliances := len (where (where $.Site.RegularPages "Section" "buying-guides") "File.Dir" "buying-guides/home-appliances/") }}
{{ $bgMobileGadgets := len (where (where $.Site.RegularPages "Section" "buying-guides") "File.Dir" "buying-guides/mobile-gadgets/") }}
```

**Display Output**:
```hugo
<p class="category-count">{{ $bgHomeAppliances }} article{{ if ne $bgHomeAppliances 1 }}s{{ end }}</p>
```

**Filter Logic**:
- Counts articles where `File.Dir` matches the directory path
- Example: `"buying-guides/home-appliances/"` counts files physically located in that directory
- Filters by `Section` first, then by `File.Dir` (filesystem-based)
- No draft filtering applied

### Same Pattern for Other Categories:
```hugo
<!-- Gaming Subcategories -->
{{ $gamingGuides := len (where (where $.Site.RegularPages "Section" "gaming") "File.Dir" "gaming/guides/") }}
{{ $gamingWalkthroughs := len (where (where $.Site.RegularPages "Section" "gaming") "File.Dir" "gaming/walkthroughs/") }}
{{ $gamingAchievements := len (where (where $.Site.RegularPages "Section" "gaming") "File.Dir" "gaming/achievements/") }}

<!-- Tutorials & Guides Subcategories -->
{{ $tgSoftware := len (where (where $.Site.RegularPages "Section" "tutorials-guides") "File.Dir" "tutorials-guides/software/") }}
{{ $tgEquipment := len (where (where $.Site.RegularPages "Section" "tutorials-guides") "File.Dir" "tutorials-guides/equipment/") }}
{{ $tgRepairGuides := len (where (where $.Site.RegularPages "Section" "tutorials-guides") "File.Dir" "tutorials-guides/repair-guides/") }}
```

---

## 3. FILTER SIDEBAR - CATEGORY COUNTS

### File: `layouts/partials/articles/filters-sidebar.html`
**Location**: Lines 23
**Method**: Uses Section and Params.category

```hugo
{{ $categories := slice "Gaming" "Electronics" "Software" "Mobile" "Home Appliances" "Tutorials & Guides" }}

{{ range $categories }}
  {{ $catCount := len (where (where $.Site.RegularPages "Section" "articles") "Params.category" .) }}
  <span class="filter-count">({{ $catCount }})</span>
{{ end }}
```

**Filter Logic**:
- Counts where `Section == "articles"` (not "buying-guides", "gaming", "tutorials-guides")
- Then filters by `Params.category` (front matter)
- Appears to be designed for a different content structure than current

---

## 4. RESULTS COUNT - JAVASCRIPT-BASED

### File: `static/js/articles.js`
**Location**: Lines 200-210
**Method**: Client-side filtering

```javascript
updateResultsCount() {
  const countElement = document.getElementById('articles-count');
  if (countElement) {
    const total = this.allArticles.length;
    const showing = this.filteredArticles.length;
    countElement.textContent = `Showing ${showing} of ${total} articles`;
  }
}
```

**Filter Logic**:
- Collects all articles already rendered in DOM (from `[data-article]` attributes)
- Counts based on visible elements
- Applies client-side filters: search, category, tags, sorting
- Updates dynamically as user filters/searches

---

## 5. FEATURED ARTICLES - SPECIAL FILTER

### File: `layouts/index.html`
**Location**: Lines 13-14
**Method**: Uses featured flag in front matter

```hugo
{{ $articles := where .Site.RegularPages "Section" "ne" "archives" }}
{{ $articles = where (where $articles "Section" "ne" "search") "Params.featured" true }}
```

**Filter Logic**:
- Excludes archives and search sections
- Filters where `Params.featured == true` (front matter)
- Displays top 1 result: `{{ range first 1 $articles }}`

---

## 6. LATEST ARTICLES SECTION

### File: `layouts/index.html`
**Location**: Lines 51-52
**Method**: Uses Section IN array

```hugo
{{ $allArticles := where .Site.RegularPages "Section" "in" (slice "buying-guides" "gaming" "tutorials-guides") }}
{{ $allArticles = sort $allArticles "Date" "desc" }}
{{ range first 6 $allArticles }}
  {{ partial "article-card.html" . }}
{{ end }}
```

**Filter Logic**:
- Gets articles where Section is buying-guides, gaming, or tutorials-guides
- Sorts by date descending
- Shows first 6
- No draft filtering

---

## KEY DIFFERENCES & POTENTIAL ISSUES

### ⚠️ ISSUE 1: COUNT vs. DISPLAY MISMATCH
| Aspect | Homepage Carousel Counts | Category Page Display |
|--------|------------------------|----------------------|
| **Filter Method** | `File.Dir` (filesystem) | `Params.category` + `Params.subcategory` (front matter) |
| **Example** | Counts where `File.Dir == "buying-guides/home-appliances/"` | Displays where `category == "Buying Guides"` AND `subcategory == "Home Appliances"` |
| **Risk** | Files in wrong directory won't be counted | Articles with wrong front matter won't display |

**Scenario causing mismatch**:
- Article A: Located in `content/buying-guides/home-appliances/article-a.md` with `category: "Buying Guides"` and `subcategory: "Electronics"`
- Result: Counted in "Home Appliances" (by directory) but displayed in "Electronics" (by front matter)

### ⚠️ ISSUE 2: FILTER SIDEBAR USES DIFFERENT SECTION
- Filter sidebar counts from `Section == "articles"`
- Category pages use `Section` from specific directories (buying-guides, gaming, etc.)
- This suggests sidebar was designed for content that doesn't currently exist in that structure

### ⚠️ ISSUE 3: NO DRAFT FILTERING
- **No templates filter by draft status**
- Articles with `draft: true` will still appear if they have proper category/subcategory
- Only Hugo's internal processing removes drafts from build (unless explicitly overridden)

### ✅ CONSISTENT ELEMENTS
- **Sorting**: All use date descending
- **Pagination**: Applied where >12 articles (buying-guides, gaming, tutorials-guides)
- **No date-based filtering**: Future-dated articles will appear if not marked as draft

---

## ARTICLE CARD DISPLAY

### File: `layouts/partials/article-card.html`
Shows all articles with these data attributes (used by JavaScript):
```html
<article class="article-card"
  data-article="{{ .File.BaseFileName }}"
  data-title="{{ .Title }}"
  data-slug="{{ .Params.slug }}"
  data-category="{{ .Params.category }}"
  data-subcategory="{{ .Params.subcategory }}"
  data-tags="{{ if .Params.tags }}{{ delimit .Params.tags "," }}{{ end }}"
  data-date="{{ .Date.Format "2006-01-02" }}"
  data-excerpt="{{ .Params.excerpt }}">
```

JavaScript uses these attributes for client-side filtering.

---

## RECOMMENDATIONS

### 1. **Standardize Counting Method**
   - Homepage carousel should count using `Params.category` + `Params.subcategory` (same as display)
   - OR ensure file structure perfectly matches front matter

### 2. **Add Draft Filtering** (if needed)
   ```hugo
   {{ $articles = where $articles "Draft" false }}
   ```

### 3. **Reconcile Filter Sidebar**
   - Currently counts from `Section == "articles"` which doesn't exist
   - Should count from actual sections: `"buying-guides"`, `"gaming"`, `"tutorials-guides"`
   - Or change content structure to use `articles` section

### 4. **Document Front Matter Requirements**
   - Ensure all articles have: `category`, `subcategory`, `draft: false`
   - Validate that `Params.category` matches directory structure

---

## Files to Check for Consistency

Before making changes, audit these article front matters:

```bash
# Check for draft: true
find content/ -name "*.md" -type f | xargs grep -l "draft: true"

# Check for missing category/subcategory
find content/ -name "*.md" -type f | xargs grep -L "category:"
find content/ -name "*.md" -type f | xargs grep -L "subcategory:"

# Verify category/subcategory values match expected values
grep -r "category:" content/ | cut -d: -f3 | sort | uniq
grep -r "subcategory:" content/ | cut -d: -f3 | sort | uniq
```

---

## Summary

**Display Method**: Front matter parameters (`Params.category`, `Params.subcategory`)  
**Count Method (Homepage)**: File system path (`File.Dir`)  
**Draft Filtering**: None applied in templates  
**Result**: Potential mismatch between displayed counts and actual articles shown

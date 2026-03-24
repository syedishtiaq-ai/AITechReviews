# 🎯 Quick Start: Add Articles to Subcategory

**Time needed:** 3 minutes  
**Difficulty:** Super simple  
**What you need:** Existing subcategory (e.g., buying-guides/furniture)

---

## One-Command Quick Start

```bash
cd /Users/ishtiaq/Documents/AITechReviews && ./scripts/add-articles.sh
```

## Step-by-Step (3 Steps)

### Step 1: Choose Category
```
Select parent category:

  1) buying-guides
  2) gaming
  3) tutorials-guides

📁 Enter category name or number: buying-guides
✅ Selected category: buying-guides
```

### Step 2: Choose Subcategory
```
Select subcategory:

  1) electronics
  2) furniture
  3) smartphones

📂 Enter subcategory name or number: furniture
✅ Selected subcategory: furniture
```

### Step 3: Enter Article Count
```
📝 Number of articles to create (default: 1): 3
```

## What Gets Created

```
content/buying-guides/furniture/
├── article-1-furniture.md  ← New article 1
├── article-2-furniture.md  ← New article 2
├── article-3-furniture.md  ← New article 3
└── (existing files unchanged)
```

## Automatic Updates

✅ **Site rebuilds** - Hugo regenerates all pages instantly  
✅ **Subcategory page updates** - New articles appear automatically  
✅ **Search updates** - New articles searchable immediately  
✅ **CSS applied** - Uses existing design automatically  
✅ **Templates applied** - Proper layout applied automatically  

## View Your Articles

### Using Hugo Server
```bash
hugo server
# Visit: http://localhost:1313/buying-guides/furniture/
# Click on your new article
```

### Check Files
```bash
# See all articles in subcategory
ls -la content/buying-guides/furniture/article-*.md
```

## Edit Articles

Open any article file and edit:

```bash
code content/buying-guides/furniture/article-1-furniture.md
```

Replace template content with your real reviews and guides.

## Common Questions

**Q: What if I type the wrong subcategory?**
A: The script validates it exists. Try again with correct name/number.

**Q: Can I add just 1 article?**
A: Yes! Default is 1 article. Just press Enter.

**Q: Do articles automatically appear on the website?**
A: Yes! Hugo rebuilds immediately and articles are live.

**Q: Can I add articles later?**
A: Yes! Run the script again for the same subcategory.

**Q: What about YouTube/Instagram links?**
A: Edit the article file front matter:
```yaml
youtube_url: "https://youtube.com/watch?v=..."
instagram_url: "https://instagram.com/..."
```

---

**Full Guide:** See [ADD_ARTICLES_GUIDE.md](ADD_ARTICLES_GUIDE.md) for detailed troubleshooting and advanced usage.

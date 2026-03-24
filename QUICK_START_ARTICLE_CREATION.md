# 🚀 Quick Start: Create Subcategories & Articles

**Time needed:** 5 minutes  
**Difficulty:** Beginner-friendly  
**What you need:** Existing category (e.g., buying-guides, gaming)

---

## One-Command Quick Start

```bash
cd /Users/ishtiaq/Documents/AITechReviews && ./scripts/create-article.sh
```

## What Happens (Step-by-Step)

### 1. **Choose Category**
The script lists all available categories:
```
1) buying-guides
2) gaming
3) tutorials-guides
```

Enter the category name or number:
```
📁 Enter category name or number: buying-guides
```

### 2. **Enter Subcategory Name**
```
📂 Subcategory name (e.g., 'furniture', 'smart-devices'): furniture
```

The script automatically creates the slug: `furniture`

### 3. **Specify Article Count**
```
📝 Number of articles to create (default: 2): 3
```

### 4. **Confirm & Create**
```
Ready to create:
   Category: buying-guides
   Subcategory: furniture (furniture)
   Articles: 3

Proceed with creation? (y/n): y
```

## What Gets Created

```
content/buying-guides/furniture/
├── _index.md              (Subcategory page)
├── article-1-furniture.md (Article 1)
├── article-2-furniture.md (Article 2)
└── article-3-furniture.md (Article 3)
```

Each article includes:
- ✅ Proper front matter (title, date, tags, categories)
- ✅ Sample content structure
- ✅ Markdown formatting ready to use
- ✅ YouTube/Instagram URL fields
- ✅ James Mitchell as author

## Viewing Your Content

### Option 1: Using Hugo Server (Recommended)
```bash
cd /Users/ishtiaq/Documents/AITechReviews && hugo server
```

Then visit:
- **Buying Guide Category:** http://localhost:1313/buying-guides/
- **Your Subcategory:** http://localhost:1313/buying-guides/furniture/
- **Your Article:** http://localhost:1313/buying-guides/furniture/article-1-furniture/

### Option 2: Check Files Directly
```bash
# View the subcategory index
cat content/buying-guides/furniture/_index.md

# View article files
ls -la content/buying-guides/furniture/
```

## Next: Edit Your Articles

Each article is a markdown file. Open in your editor:

```bash
code content/buying-guides/furniture/article-1-furniture.md
```

Replace template content with:
- Real product names/links
- Your reviews and insights
- Comparison tables
- Your personal recommendations

## What Happens Automatically

✅ **Directory structure created** - All folders created automatically  
✅ **Front matter generated** - Proper YAML with dates  
✅ **CSS applied** - Existing styles used automatically  
✅ **Templates applied** - Article displays with category design  
✅ **Site rebuilds** - Hugo regenerates all pages  
✅ **Search updated** - Articles appear in site search  

## Common Questions

**Q: Can I create articles without subcategories?**
A: Use this script for subcategory + articles. For just articles, edit the files manually or create a custom workflow.

**Q: Do I need to edit the HTML or CSS?**
A: No! Everything uses existing templates and CSS automatically.

**Q: Can I create multiple subcategories?**
A: Yes! Run the script multiple times, once per subcategory.

**Q: Where do I add YouTube/Instagram links?**
A: Edit the front matter in each `.md` file:
```yaml
youtube_url: "https://youtube.com/watch?v=..."
instagram_url: "https://instagram.com/..."
```

**Q: When will the articles appear on the site?**
A: The script runs Hugo automatically at the end. Articles appear once Hugo finishes building (usually 1-2 seconds).

---

**Need help?** See [ARTICLE_CREATION_GUIDE.md](ARTICLE_CREATION_GUIDE.md) for detailed troubleshooting and advanced usage.

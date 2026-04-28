# Quick Reference: Article Management Cheat Sheet

## 🚀 Adding a New Article (30 seconds)

### 1. Create File
```bash
# Pick your category and create the file
content/gaming/guides/my-article.md          # Gaming
content/buying-guides/electronics/my-article.md  # Buying Guide  
content/tutorials-guides/software/my-article.md  # Tutorial
```

### 2. Copy-Paste Template
```yaml
---
article_id: "GAM-GD-280426-001"
title: "My Article Title"
featuredimage: "/images/articles/my-image.svg"
description: "SEO description (155-160 chars)"
excerpt: "2-3 sentence preview..."
author: "Your Name"
category: "Gaming"
subcategory: "Guides"
tags:
  - "Tag1"
  - "Tag2"
  - "Tag3"
featuredImage: "images/my-image.jpg"
date: "2026-04-28T10:00:00.000Z"
lastmod: "2026-04-28T10:00:00.000Z"
draft: false
readingTime: "10 min read"
layout: "single"
---

# Your Article Title

## Section 1
Content here...
```

### 3. Write & Save
That's it! Hugo rebuilds automatically.

---

## ✏️ Editing an Article (15 seconds)

### Method 1: Content Only
1. Open the `.md` file
2. Edit markdown content (below front matter)
3. Update `lastmod: "2026-04-28T15:30:00.000Z"`
4. Save

### Method 2: Metadata
1. Open the `.md` file
2. Edit YAML fields (title, tags, description, etc.)
3. Update `lastmod` timestamp
4. Save

### Method 3: Featured Image
```yaml
featuredImage: "images/new-image.jpg"  # Change this
lastmod: "2026-04-28T15:30:00.000Z"    # Update timestamp
```

---

## 🔄 Renaming an Article

### Terminal Method
```bash
cd content/gaming/guides/
mv old-name.md new-name.md
```

### VS Code Method
1. Right-click file → "Rename"
2. Type new name
3. Press Enter

### Update Internal Links
```bash
# Search & replace old-filename with new-filename
# Check internal links pointing to this article
```

### Add Redirect (Optional but Recommended)
Contact your hosting provider (Netlify/Cloudflare) to add:
```
Old URL → New URL
```

---

## 🖼️ Featured Image Setup

### Image Location
```
static/images/articles/my-image.jpg
static/images/articles/my-image.svg
```

### Front Matter Reference
```yaml
featuredimage: "/images/articles/my-image.svg"   # For metadata
featuredImage: "images/my-image.jpg"              # For display
```

### Recommended Dimensions
- Width: 1200px
- Height: 630px
- Format: JPG, PNG, or SVG
- Max size: 500KB

---

## 📚 File Structure Locations

```
Gaming:
  • Guides → content/gaming/guides/
  • Walkthroughs → content/gaming/walkthroughs/
  • Achievements → content/gaming/achievements/

Buying Guides:
  • Electronics → content/buying-guides/electronics/
  • Home Appliances → content/buying-guides/home-appliances/
  • Mobile Gadgets → content/buying-guides/mobile-gadgets/

Tutorials:
  • Software → content/tutorials-guides/software/
  • Equipment → content/tutorials-guides/equipment/
  • Repair → content/tutorials-guides/repair-guides/
```

---

## 📝 Article ID Format

```
Format: [CATEGORY]-[SUBCATEGORY]-[DDMMYY]-[SEQUENCE]

Examples:
BG-EL-280426-001   (Buying Guide, Electronics, 28 April 2026, #1)
GM-GD-280426-002   (Gaming, Guides, 28 April 2026, #2)
TT-SW-280426-001   (Tutorial, Software, 28 April 2026, #1)

Codes:
BG = Buying Guides | TT = Tutorials
GM = Gaming | EL = Electronics | GD = Guides
HA = Home Appliances | SW = Software | WK = Walkthroughs
AC = Achievements | MG = Mobile Gadgets | EQ = Equipment | RP = Repair
```

---

## 🏷️ Recommended Tags

### By Category
**Gaming:** Gaming, Guides, Tips, Walkthrough, RPG, Action, Strategy, Casual
**Buying Guides:** Review, Buying Guide, Electronics, Home, Mobile, Comparison
**Tutorials:** How-to, Tutorial, Step-by-step, Software, Equipment, Repair

### Rules
- 5-7 tags per article (optimal)
- 3 tags minimum
- Use lowercase
- No special characters

---

## ☁️ CloudCannon Quick Start

### Prerequisites
1. GitHub account (free)
2. Push Hugo site to GitHub
3. Create `.cloudcannon.yml` in root ✅ (Already created!)

### Setup Steps
1. Visit [cloudcannon.com](https://cloudcannon.com)
2. Sign up (free tier)
3. Click "Create Site" → Select GitHub
4. Authorize GitHub access
5. Select your AITechReviews repo
6. Choose "main" branch
7. Done! Site is connected

### Create Article in CloudCannon
1. Open CloudCannon dashboard
2. Collections → Gaming (or your category)
3. Click "+ New"
4. Fill form fields
5. Write content (visual editor)
6. Click "Update" to publish
7. Auto-commits to GitHub ✅

### Deploy Site
- **Netlify:** Settings → Hosting → Connect Netlify
- **Cloudflare:** Settings → Hosting → Connect Cloudflare
- Auto-deploys on every change

---

## 🐛 Common Issues & Fixes

| Issue | Solution |
|---|---|
| Article not showing up | Ensure `draft: false` in front matter |
| Featured image broken | Check path in `featuredImage` field |
| Date appears wrong | Use format: `"2026-04-28T10:00:00.000Z"` |
| Filename has spaces | Use hyphens: `my-article.md` (not `my article.md`) |
| URL changed after rename | Set up redirect in hosting provider |
| CloudCannon won't deploy | Check hosting integration in Settings → Build & Output |
| Cannot find article to edit | Use VS Code search (Cmd+F) for filename |

---

## 📋 Pre-Publication Checklist

Before publishing an article:

- [ ] Title is clear and SEO-optimized
- [ ] Description is 155-160 characters
- [ ] Excerpt is 2-3 sentences
- [ ] Featured image is uploaded (1200×630px recommended)
- [ ] `featuredImage` path is correct
- [ ] Tags are 5-7 items
- [ ] Article content is proofread
- [ ] `draft: false` (to publish)
- [ ] `lastmod` timestamp is current
- [ ] Article ID is unique
- [ ] Author name is filled
- [ ] Category and subcategory are correct
- [ ] All links work (test before publishing)
- [ ] Images within article are working

---

## 🔗 Useful Commands

```bash
# Navigate to project
cd /Users/ishtiaq/Documents/AITechReviews

# View Hugo site locally (if Hugo installed)
hugo server

# Build site
hugo

# Search for articles
grep -r "article-title" content/

# Rename file
mv old-name.md new-name.md

# List all articles by category
ls -la content/gaming/guides/
ls -la content/buying-guides/electronics/

# Check git status
git status

# Commit and push (for CloudCannon updates)
git add .
git commit -m "Update article"
git push origin main
```

---

## 📞 Support Resources

- **Hugo Docs:** [gohugo.io](https://gohugo.io)
- **CloudCannon Docs:** [cloudcannon.com/docs](https://cloudcannon.com/documentation)
- **Markdown Guide:** [markdownguide.org](https://www.markdownguide.org)
- **Git Tutorial:** [git-scm.com/doc](https://git-scm.com/doc)

---

**Last Updated:** April 28, 2026  
**For full guide:** See `ARTICLE_WORKFLOW_GUIDE.md`

# Article Management Workflow Guide
**AITechReviews Hugo Site**

---

## Table of Contents
1. [Adding New Articles](#adding-new-articles)
2. [Editing Existing Articles](#editing-existing-articles)
3. [Renaming Articles](#renaming-articles)
4. [CloudCannon Setup Guide](#cloudcannon-setup-guide)

---

## 1. Adding New Articles

### Understanding Your Site Structure

Your articles are organized by **categories** and **subcategories**:

```
content/
├── gaming/
│   ├── guides/
│   ├── walkthroughs/
│   └── achievements/
├── buying-guides/
│   ├── electronics/
│   ├── home-appliances/
│   └── mobile-gadgets/
├── tutorials-guides/
│   ├── equipment/
│   ├── repair-guides/
│   └── software/
└── articles/
```

### Step-by-Step: Creating a New Article

#### Step 1: Choose the Right Category
Determine where your article fits:
- **Gaming** - Gaming guides, walkthroughs, achievements
- **Buying Guides** - Product reviews and buying recommendations
- **Tutorials & Guides** - How-to content and software/equipment guides

#### Step 2: Create the Article File

**File Location Pattern:**
```
content/[category]/[subcategory]/[article-slug].md
```

**Example Locations:**
- Gaming article: `content/gaming/guides/my-gaming-guide.md`
- Buying guide: `content/buying-guides/electronics/best-headphones.md`
- Tutorial: `content/tutorials-guides/software/setup-guide.md`

**File Naming Rules:**
- Use lowercase letters and hyphens only (no spaces, no underscores)
- Use descriptive, SEO-friendly names
- Example: `best-budget-gaming-laptops.md` ✓
- Bad example: `Best_Gaming_Laptops.md` ✗

#### Step 3: Add Front Matter

Every article must start with **YAML front matter** (between `---`). Here's the complete template:

```yaml
---
article_id: "CAT-SUB-DDMMYY-XXX"
title: "Your Article Title Here"
featuredimage: "/images/articles/your-image.svg"
description: "Brief meta description (155-160 characters for SEO)"
excerpt: "Longer description shown in previews (2-3 sentences)..."
author: "Author Name"
category: "Category Name"
subcategory: "Subcategory Name"
tags:
  - "Tag 1"
  - "Tag 2"
  - "Tag 3"
  - "Tag 4"
  - "Tag 5"
featuredImage: "images/your-image.jpg"
date: "2026-04-28T10:00:00.000Z"
lastmod: "2026-04-28T10:00:00.000Z"
draft: false
readingTime: "12 min read"
layout: "single"
---
```

**Front Matter Field Reference:**

| Field | Purpose | Example |
|-------|---------|---------|
| `article_id` | Unique ID for tracking | `BG-EL-260428-001` |
| `title` | Article title | "Best Laptops for 2026" |
| `description` | SEO meta description | 155-160 characters |
| `excerpt` | Preview text | 2-3 sentences |
| `author` | Author name | "Tech Expert" |
| `category` | Main category | "Buying Guides" |
| `subcategory` | Sub-category | "Electronics" |
| `tags` | Article tags (5-7 optimal) | List of keywords |
| `featuredImage` | Header image path | "images/filename.jpg" |
| `date` | Publication date/time | ISO 8601 format |
| `lastmod` | Last modification time | ISO 8601 format |
| `draft` | Publishing status | `false` = published |
| `readingTime` | Estimated reading time | "12 min read" |

**Generating Article ID:**
- Format: `[CATEGORY]-[SUBCATEGORY]-[DDMMYY]-[SEQUENCE]`
- Example: `BG-EL-260428-001` (Buying Guide, Electronics, 28 April 2026, 001)

#### Step 4: Write Your Content

After the front matter, write your article in Markdown:

```markdown
# Article Heading

## Section 1
Your content here...

### Subsection 1.1
More content...

## Section 2
More content...
```

**Markdown Syntax Tips:**
- Use `#` for main heading, `##` for sections, `###` for subsections
- Use `**text**` for bold, `*text*` for italics
- Use `- item` for bullet lists, `1. item` for numbered lists
- Use `[link text](url)` for links
- Use `` `code` `` for inline code
- Use triple backticks for code blocks

#### Step 5: Save and Publish

1. Save the file with your changes
2. Ensure `draft: false` in front matter
3. Hugo automatically processes the file when you build

### Quick Example: Adding a New Article

**File:** `content/gaming/guides/elden-ring-beginners-tips.md`

```yaml
---
article_id: "GM-GD-260428-002"
title: "Elden Ring Beginner's Tips - Master the Basics"
featuredimage: "/images/articles/elden-ring-tips.svg"
description: "Essential tips for Elden Ring beginners - combat, character building, and exploration strategies"
excerpt: "New to Elden Ring? Learn essential tips for character creation, combat fundamentals, and exploration..."
author: "Gaming Expert"
category: "Gaming"
subcategory: "Guides"
tags:
  - "Elden Ring"
  - "Gaming"
  - "Beginner Tips"
  - "Walkthrough"
  - "RPG"
featuredImage: "images/elden-ring-tips.jpg"
date: "2026-04-28T14:30:00.000Z"
lastmod: "2026-04-28T14:30:00.000Z"
draft: false
readingTime: "10 min read"
layout: "single"
---

# Elden Ring Beginner's Tips - Master the Basics

## Character Creation Essentials
...content here...

## Combat Fundamentals
...content here...
```

---

## 2. Editing Existing Articles

### Finding an Article to Edit

Use Hugo's search or file explorer to locate the article:

**Known Locations:**
- Gaming articles: `content/gaming/[subcategory]/`
- Buying guides: `content/buying-guides/[subcategory]/`
- Tutorials: `content/tutorials-guides/[subcategory]/`

**File Search Pattern:**
Search for the article slug or keyword in the filename.

### Making Edits

#### Edit 1: Update Content Only

1. Open the `.md` file
2. Modify the markdown content (everything after front matter)
3. Update `lastmod` field to current date/time: `"2026-04-28T15:45:00.000Z"`
4. Save the file

**Example:**
```yaml
lastmod: "2026-04-28T15:45:00.000Z"  # Updated timestamp
```

#### Edit 2: Update Front Matter

1. Open the `.md` file
2. Modify the YAML front matter fields (date, time, tags, description, etc.)
3. Update `lastmod` to current timestamp
4. Save the file

**Common Front Matter Updates:**
- Update `title` for SEO improvements
- Modify `tags` to add/remove keywords
- Update `description` for better SEO
- Change `author` if needed
- Add `draft: true` to unpublish temporarily

#### Edit 3: Update Featured Image

1. Open the article file
2. Modify the `featuredImage` field:
   ```yaml
   featuredImage: "images/new-image-name.jpg"
   ```
3. Ensure the image file exists in `static/images/`
4. Update `lastmod` timestamp
5. Save

### Editing Workflow

```
1. Locate article file
    ↓
2. Open in VS Code (or CloudCannon)
    ↓
3. Make content/metadata changes
    ↓
4. Update lastmod timestamp
    ↓
5. Save file
    ↓
6. Hugo rebuilds automatically (or on next build)
```

---

## 3. Renaming Articles

### Why Rename?
- Better SEO slug
- Clearer article title
- Consolidating duplicate articles
- URL structure changes

### Important: URLs in Hugo

In Hugo, the **filename** determines the article URL:
- File: `best-laptops.md` → URL: `yourdomain.com/buying-guides/electronics/best-laptops/`
- File: `gaming-tips.md` → URL: `yourdomain.com/gaming/guides/gaming-tips/`

**Renaming the file changes the URL permanently** (which can affect SEO and existing links).

### Step-by-Step: Rename an Article

#### Step 1: Backup the Original
Before renaming, create a backup or note the old filename and URL.

#### Step 2: Rename the File
1. Open VS Code terminal or file explorer
2. Navigate to the article folder
3. Rename the file:

**Using Terminal:**
```bash
cd /Users/ishtiaq/Documents/AITechReviews/content/gaming/guides/
mv old-article-name.md new-article-name.md
```

**Using VS Code:**
1. Right-click the file
2. Select "Rename"
3. Type the new name
4. Press Enter

#### Step 3: Update Internal Links
If other articles link to this article:
1. Search your codebase for the old filename
2. Update any references to the new filename

**Example:**
- Old link: `[Read more](../best-gaming-laptops/)`
- New link: `[Read more](../gaming-laptops-2026/)`

#### Step 4: Handle Redirects (Important for SEO!)
To avoid 404 errors and preserve SEO rankings:

1. Add to your `hugo.toml`:
```toml
[[outputs.page]]
  name = "Redirect"
  baseName = ""
  mediaType = "text/html"
  isHTML = true
```

2. Create a redirect shortcode in `layouts/shortcodes/redirect.html`:
```html
{{ if .Get "from" }}
<meta http-equiv="refresh" content="0; url={{ .Get "to" }}" />
{{ end }}
```

3. Or use Netlify/Cloudflare redirects in your hosting provider

#### Step 5: Rebuild
After renaming and updating links:
1. Save all changes
2. Hugo rebuilds with the new filename
3. The site now uses the new URL

### Example: Renaming Workflow

**Original file:**
```
content/gaming/guides/beginners-guide-to-gaming.md
URL: yourdomain.com/gaming/guides/beginners-guide-to-gaming/
```

**Rename to:**
```
content/gaming/guides/beginner-gaming-essentials-2026.md
New URL: yourdomain.com/gaming/guides/beginner-gaming-essentials-2026/
```

**Terminal command:**
```bash
mv content/gaming/guides/beginners-guide-to-gaming.md \
   content/gaming/guides/beginner-gaming-essentials-2026.md
```

**Steps after rename:**
1. Update any internal links
2. Add redirect (if needed)
3. Update navigation menus (if applicable)
4. Rebuild Hugo site

---

## 4. CloudCannon Setup Guide

### What is CloudCannon?

CloudCannon is a Git-based CMS for static sites (like Hugo). Benefits:
- ✅ Visual editor for markdown content
- ✅ No need to edit markdown syntax directly
- ✅ Automatic Git commits when publishing
- ✅ Preview changes before publishing
- ✅ User-friendly interface for non-technical writers
- ✅ Scheduled publishing
- ✅ Version history and rollback

### Prerequisites

Before starting, you need:
1. **GitHub account** (free) - for storing your Hugo site
2. **GitHub repository** with your Hugo site (public or private)
3. **CloudCannon account** (free tier available)

### Step 1: Prepare Your Hugo Repository on GitHub

#### 1a. Create/Push Hugo Site to GitHub

If not already on GitHub:

1. Initialize Git in your project:
```bash
cd /Users/ishtiaq/Documents/AITechReviews
git init
```

2. Add remote:
```bash
git remote add origin https://github.com/YOUR_USERNAME/AITechReviews.git
```

3. Commit and push:
```bash
git add .
git commit -m "Initial Hugo site commit"
git branch -M main
git push -u origin main
```

#### 1b. Create `.cloudcannon.yml` Configuration

This file tells CloudCannon how to handle your site. Create it in your root directory:

**File:** `/Users/ishtiaq/Documents/AITechReviews/.cloudcannon.yml`

```yaml
# CloudCannon Configuration

# Source directory for content
source: content

# Build command
build:
  command: hugo

# Preview command
preview:
  command: hugo server --disableFastRender --cleanDestinationDir

# Collections (how content is organized)
collections_config:
  articles:
    path: content/gaming
    _inputs:
      title:
        type: text
      description:
        type: textarea
      excerpt:
        type: textarea
      tags:
        type: array
      author:
        type: text
      draft:
        type: checkbox
      readingTime:
        type: text
  buying_guides:
    path: content/buying-guides
    _inputs:
      title:
        type: text
      description:
        type: textarea
      excerpt:
        type: textarea
      tags:
        type: array
      author:
        type: text
      draft:
        type: checkbox
      readingTime:
        type: text
  tutorials:
    path: content/tutorials-guides
    _inputs:
      title:
        type: text
      description:
        type: textarea
      excerpt:
        type: textarea
      tags:
        type: array
      author:
        type: text
      draft:
        type: checkbox
      readingTime:
        type: text

# Media settings
media:
  path: static/images

# Markdown editor settings
_editor:
  default_path: /
  preview:
    text: Live preview
  styles: /css/main.css

# Timezone for scheduling
timezone: UTC
```

Commit this file:
```bash
git add .cloudcannon.yml
git commit -m "Add CloudCannon configuration"
git push
```

### Step 2: Sign Up for CloudCannon

1. Visit [cloudcannon.com](https://cloudcannon.com)
2. Click **"Sign Up"** (free tier available)
3. Create account (or use GitHub login)
4. Verify email

### Step 3: Connect Your GitHub Repository

1. After signing in, click **"Create Site"** or **"Add Organization"**
2. Select **"GitHub"** as the source
3. Authorize CloudCannon to access GitHub
4. Select your `AITechReviews` repository
5. Choose the **main** branch
6. Click **"Create Site"**

### Step 4: Configure Build Settings

1. Go to **Settings** → **Build & Output**
2. Set the following:
   - **Build command:** `hugo`
   - **Output directory:** `public`
   - **Hugo version:** `0.128.0` (or latest)
3. Click **Save**

### Step 5: Configure Collections

1. Go to **Settings** → **Collections**
2. CloudCannon auto-detects your content folders
3. For each collection, configure:
   - **Path:** (auto-filled)
   - **Icon:** Choose appropriate icon
   - **Add new item template:** Set defaults for new articles

### Step 6: Set Up Your First Editor

1. Go to **Collections** → **Articles** (or your first collection)
2. Click on an existing article to open the editor
3. Explore the features:
   - **Visual editor:** Edit without markdown syntax
   - **Source editor:** Edit raw markdown
   - **Preview:** See live preview
   - **Metadata:** Edit front matter fields

### Step 7: Create an Article via CloudCannon

1. Open CloudCannon dashboard
2. Go to **Collections** → **Gaming** (or your collection)
3. Click **"Add Article"** or **"New"**
4. Fill in the form:
   - Title
   - Description
   - Author
   - Tags (click to add multiple)
   - Upload featured image
   - Write content in the editor
5. Click **"Set Draft"** if not ready, or **"Save"** to publish
6. CloudCannon automatically:
   - Commits to GitHub
   - Triggers build
   - Deploys to your site

### Step 8: Deploy Your Site

CloudCannon can automatically deploy builds to various services:

#### Option A: Deploy to Netlify

1. Go to **Settings** → **Build & Output** → **Hosting**
2. Select **Netlify**
3. Connect your Netlify account
4. Select your Netlify site
5. CloudCannon will auto-deploy on every change

#### Option B: Deploy to Cloudflare

1. Go to **Settings** → **Build & Output** → **Hosting**
2. Select **Cloudflare Pages**
3. Connect your Cloudflare account
4. CloudCannon auto-deploys on commits

#### Option C: Manual Deployment

1. CloudCannon builds to the `public` folder
2. You manually deploy the `public` folder to your host
3. Or use GitHub Actions for auto-deploy

### Using CloudCannon: Editor Workflow

#### Creating a New Article

1. **Open Collections:** Click the collection (e.g., "Gaming")
2. **Add New:** Click "+ New" button
3. **Fill Form:**
   - Title
   - Featured image
   - Author
   - Tags
   - Description
   - Content (visual editor)
4. **Save Draft:** Click "Set Draft" to save without publishing
5. **Publish:** Click "Update" or "Save" to publish immediately
6. **Git Commit:** CloudCannon automatically commits to GitHub

#### Editing an Existing Article

1. **Open Collections:** Navigate to article collection
2. **Select Article:** Click the article title
3. **Edit Content:**
   - Use visual editor (no markdown syntax needed)
   - Or switch to source editor for markdown
4. **Edit Metadata:**
   - Title, author, tags, etc. in the sidebar
5. **Preview:** Click "Live Preview" to see changes
6. **Save:** Click "Update" when done
7. **Auto-Commit:** CloudCannon saves to GitHub

#### Scheduling Publication

1. Open the article
2. Click **"Status"** dropdown
3. Select **"Scheduled"**
4. Choose date and time
5. Click **"Schedule"**
6. CloudCannon publishes automatically at scheduled time

### CloudCannon Advantages Over Manual Editing

| Feature | Manual (Git/VS Code) | CloudCannon |
|---------|---------------------|------------|
| Markdown knowledge | Required | Not needed |
| Visual editing | No | Yes |
| Git commits | Manual | Automatic |
| Preview | Command line | Built-in |
| Media management | Manual | Drag & drop |
| Scheduling | External tools | Built-in |
| Version history | Git only | Built-in UI |
| User permissions | N/A | Team management |

### CloudCannon Advanced Features

#### Adding Team Members

1. Go to **Settings** → **Team**
2. Click **"Add Team Member"**
3. Enter email address
4. Assign role:
   - **Admin:** Full access
   - **Editor:** Can edit content
   - **Viewer:** Read-only access
5. Send invite

#### Setting Up Permissions

1. Go to **Settings** → **Permissions**
2. Configure who can:
   - Edit content
   - Delete content
   - Publish
   - Access settings

#### Customizing the Editor Interface

1. Go to **Settings** → **Editing**
2. Customize form fields and layout
3. Add custom styles
4. Set editor toolbar options

#### API Integration

CloudCannon provides API for:
- Fetching site content
- Creating/updating articles programmatically
- Automated workflows

[See CloudCannon API docs](https://cloudcannon.com/documentation/articles/introduce-self-serve-migrations/)

### Troubleshooting CloudCannon

#### Issue: "Build Failed"
- Check **Logs** → **Build Logs**
- Ensure Hugo version is compatible
- Check for syntax errors in `.cloudcannon.yml`
- Verify file paths are correct

#### Issue: "Site Not Deploying"
- Ensure hosting (Netlify/Cloudflare) is connected
- Check deployment logs in hosting provider
- Verify build command is correct

#### Issue: "Media Not Uploading"
- Check `media` path in `.cloudcannon.yml`
- Ensure `static/images/` folder exists
- Check folder permissions

#### Issue: "Collections Not Showing"
- Verify paths in `.cloudcannon.yml` match actual folders
- Ensure `.cloudcannon.yml` is in root directory
- Try syncing from **Settings** → **Sync**

### CloudCannon Cost

- **Free tier:** Limited to 1 site, 5,000 requests/month
- **Paid plans:** Start at $45/month for unlimited sites
- **Team plans:** Pricing available for teams

---

## Quick Reference: File Locations

| Content Type | Location |
|---|---|
| Gaming Guides | `content/gaming/guides/` |
| Gaming Walkthroughs | `content/gaming/walkthroughs/` |
| Gaming Achievements | `content/gaming/achievements/` |
| Buying Guides - Electronics | `content/buying-guides/electronics/` |
| Buying Guides - Home Appliances | `content/buying-guides/home-appliances/` |
| Buying Guides - Mobile Gadgets | `content/buying-guides/mobile-gadgets/` |
| Tutorials - Software | `content/tutorials-guides/software/` |
| Tutorials - Equipment | `content/tutorials-guides/equipment/` |
| Tutorials - Repair Guides | `content/tutorials-guides/repair-guides/` |

---

## Quick Reference: Front Matter Template

```yaml
---
article_id: "CAT-SUB-DDMMYY-001"
title: "Article Title"
featuredimage: "/images/articles/image.svg"
description: "Meta description (155-160 chars)"
excerpt: "Preview text (2-3 sentences)"
author: "Author Name"
category: "Category"
subcategory: "Subcategory"
tags:
  - "Tag1"
  - "Tag2"
  - "Tag3"
featuredImage: "images/image.jpg"
date: "2026-04-28T10:00:00.000Z"
lastmod: "2026-04-28T10:00:00.000Z"
draft: false
readingTime: "12 min read"
layout: "single"
---
```

---

## Next Steps

1. **For CloudCannon:** Follow Step 1 (prepare GitHub) → Step 2 (sign up) → Step 3 (connect)
2. **For manual editing:** Use Sections 1-3 of this guide to add/edit/rename articles
3. **For teams:** Use CloudCannon with team members for collaborative editing

---

**Last Updated:** April 28, 2026
**Author:** AI Assistant
**Hugo Version:** 0.128.0+

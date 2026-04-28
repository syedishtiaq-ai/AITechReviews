# Image Management Guide - Complete Reference
**AITechReviews Hugo Site**

---

## Table of Contents
1. [Folder Structure Overview](#folder-structure-overview)
2. [Image Types & Placement](#image-types--placement)
3. [Naming Conventions](#naming-conventions)
4. [Image Specifications](#image-specifications)
5. [Step-by-Step: Adding Images](#step-by-step-adding-images)
6. [Shared vs. Article-Specific Images](#shared-vs-article-specific-images)
7. [CloudCannon Workflow](#cloudcannon-workflow)
8. [Common Scenarios](#common-scenarios)
9. [Best Practices](#best-practices)
10. [Quick Reference](#quick-reference)

---

## 1. Folder Structure Overview

Your organized image structure:

```
static/images/
│
├── articles/           ← Featured images for articles ONLY
│   ├── ac-odyssey-title.svg
│   ├── ac-origins-title.svg
│   ├── best-laptops.svg
│   ├── best-washing-machines.svg
│   └── ... (one image per article)
│
├── logos/              ← Shared across entire site
│   ├── logo.png        ← Used in header, footer, metadata
│   ├── logo-old.png
│   ├── AI-Tech-Logo.png
│   └── ... (all logo variations)
│
├── ui/                 ← Shared UI elements & icons
│   ├── favicon.png     ← Browser tab icon
│   ├── youtube.png     ← Social media icon (shared)
│   ├── instagram.png   ← Social media icon (shared)
│   ├── placeholder.svg ← Fallback for broken images
│   └── ... (UI elements used throughout site)
│
├── categories/         ← Shared across multiple category pages
│   ├── computer-2026.jpg       ← Used on multiple pages
│   ├── laptops-2026.jpg
│   ├── smartphones-2026.jpg
│   └── ... (images for category sections)
│
├── products/           ← Shared for product comparisons
│   ├── Bed.jpeg        ← Used in buying guides
│   ├── Refrigerator.jpeg
│   ├── Office-Chair.jpeg
│   └── ... (product reference images)
│
└── backgrounds/        ← Shared background images
    ├── home-bg.svg     ← Homepage hero section background
    └── ... (page backgrounds)
```

---

## 2. Image Types & Placement

### 📄 **Type 1: Article Featured Images (UNIQUE per article)**

**Location:** `static/images/articles/`

**Used for:** The main image that appears at the top of each article

**When to use:** Every article needs exactly one featured image

**Sharing:** ❌ NOT shared - Each article has its own unique image

**Examples:**
- `elden-ring-achievements.svg` → Used only for "Elden Ring Achievements" article
- `best-laptops.svg` → Used only for "Best Laptops" article
- `wireless-headphones.svg` → Used only for "Wireless Headphones" article

**File reference in article:**
```yaml
---
featuredimage: "/images/articles/best-laptops.svg"
featuredImage: "images/articles/best-laptops.svg"
---
```

---

### 🏠 **Type 2: Category Images (SHARED across multiple pages/articles)**

**Location:** `static/images/categories/`

**Used for:** Images that represent categories or are used on multiple pages

**When to use:** When an image is referenced in multiple places (homepage, category pages, etc.)

**Sharing:** ✅ SHARED - Can be used across multiple articles/pages

**Examples:**
- `computer-2026.jpg` → Used in "Gaming" category, "Buying Guides" section, homepage carousel
- `laptops-2026.jpg` → Used in "Electronics" category page
- `smartphones-2026.jpg` → Used in "Mobile Gadgets" category page

**When to place in categories:**
```
Use this folder for images that:
• Appear on multiple pages
• Represent entire categories (not single products)
• Are generic category visuals
• Can be reused across different sections
```

---

### 🛒 **Type 3: Product Images (SHARED reference images)**

**Location:** `static/images/products/`

**Used for:** Specific product images used in buying guides and comparisons

**When to use:** Product photos, furniture images, appliance images

**Sharing:** ✅ SHARED - Can be referenced in multiple buying guide articles

**Examples:**
- `Refrigerator.jpeg` → Referenced in "Best Refrigerators" article
- `Bed.jpeg` → Referenced in "Best Beds" buying guide
- `Office-Chair.jpeg` → Referenced in "Office Furniture" article

**Scenario:** If 3 articles mention "washing machine reviews," use one shared image:
```yaml
# Article 1: Best Washing Machines 2026
featuredImage: "images/articles/best-washing-machines.svg"

# Article 2: Washing Machine Buyer's Guide  
featuredImage: "images/articles/washing-machine-buyers-guide.svg"

# But in article body, reference the shared product image:
# ![Washing Machine Review](../../../images/products/washing-machine-lg.jpeg)
```

---

### 🎨 **Type 4: Logo & Branding Images (SHARED everywhere)**

**Location:** `static/images/logos/`

**Used for:** Logo, branding elements used across entire site

**When to use:** Site header, footer, metadata, social media preview

**Sharing:** ✅ SHARED (EVERYWHERE) - Same logo on all pages

**Examples:**
- `logo.png` → Main logo (used in header on EVERY page)
- `Transparent-Logo.png` → Alternative logo format
- `AI-Tech-Logo.png` → Alternative branding

**These are automatically referenced in:**
- Header/navigation (every page)
- Footer
- Social media cards
- Search results preview

---

### 🎯 **Type 5: UI & Icon Images (SHARED elements)**

**Location:** `static/images/ui/`

**Used for:** Icons, favicons, social buttons, UI elements

**When to use:** Decorative elements, buttons, icons used across site

**Sharing:** ✅ SHARED - Same icons/elements on all pages

**Examples:**
- `favicon.png` → Browser tab icon (on EVERY page)
- `youtube.png` → YouTube social icon (appears in footer)
- `instagram.png` → Instagram social icon (appears in footer)
- `placeholder.svg` → Fallback image for broken links

---

### 🌅 **Type 6: Background Images (SHARED)**

**Location:** `static/images/backgrounds/`

**Used for:** Background images for sections, hero, pages

**When to use:** Hero section background, page backgrounds

**Sharing:** ✅ SHARED - Reused across site

**Examples:**
- `home-bg.svg` → Homepage hero section background (SHARED)
- `gaming-bg.jpg` → Gaming section background (if created)

---

## 3. Naming Conventions

### ✅ **DO: Follow these naming rules**

#### For Article-Specific Images:
```
Format: [topic]-[type].svg or [article-slug].svg

Examples:
✓ elden-ring-achievements.svg
✓ best-laptops.svg
✓ wireless-headphones.svg
✓ gaming-tips-2026.svg
✓ productivity-software.svg
```

#### For Shared Category Images:
```
Format: [category]-[year or identifier].jpg

Examples:
✓ computer-2026.jpg
✓ laptops-2026.jpg
✓ smartphones-2026.jpg
✓ electronics-buyers-guide.jpg
```

#### For Product Images:
```
Format: [product-type]-[brand or descriptor].jpeg

Examples:
✓ refrigerator-lg.jpeg
✓ washing-machine-samsung.jpeg
✓ office-chair-ergonomic.jpeg
✓ sofa-set-modern.jpeg
```

#### For UI/Icon Images:
```
Format: [element-name].[extension]

Examples:
✓ youtube.png
✓ instagram.png
✓ favicon.png
✓ placeholder.svg
```

---

### ❌ **DON'T: Avoid these naming mistakes**

```
✗ Best Laptops.svg              (spaces - use hyphens)
✗ BEST-LAPTOPS.SVG              (ALL CAPS - use lowercase)
✗ best_laptops.svg              (underscores - use hyphens)
✗ bestlaptops.svg               (no separators - use hyphens)
✗ image1.svg                    (generic - be descriptive)
✗ bestlaptops2026v2final.svg   (too long - keep concise)
```

---

## 4. Image Specifications

### 📐 **Dimensions**

| Image Type | Width | Height | Aspect Ratio | Notes |
|---|---|---|---|---|
| **Article Featured** | 1200px | 630px | 16:9 | Best for SEO preview cards |
| **Category Images** | 1200px | 800px | 3:2 | For category sections |
| **Product Images** | 600px | 400px | 3:2 | For product cards |
| **Logo** | 200px | 60px | 3:1 | Adjust for your logo shape |
| **Favicon** | 32px | 32px | 1:1 | Must be square |
| **Background** | 1920px | 1080px | 16:9 | For hero sections |

### 📦 **File Sizes**

| Image Type | Max Size | Format | Recommendation |
|---|---|---|---|
| **Article Featured** | 500KB | SVG or JPG | Use SVG for vectors, JPG for photos |
| **Category Images** | 400KB | JPG | Optimize for web |
| **Product Images** | 300KB | JPEG | Compress for faster loading |
| **Logo** | 100KB | PNG | Small file size |
| **Favicon** | 50KB | PNG | Optimize aggressive |
| **Background** | 200KB | SVG or JPG | SVG preferred for crisp look |

### 🎨 **File Format Guide**

| Format | When to Use | Example |
|---|---|---|
| **SVG** | Graphics, logos, illustrations, icons | `elden-ring-achievements.svg` |
| **JPG** | Photos, complex images, category visuals | `computer-2026.jpg` |
| **JPEG** | Product photos, detailed images | `refrigerator.jpeg` |
| **PNG** | Logos, icons, images with transparency | `favicon.png` |

---

## 5. Step-by-Step: Adding Images

### **Scenario A: Create Article with NEW Featured Image**

#### Step 1: Create Featured Image
1. Design/create your image (1200×630px recommended)
2. Export as SVG (for graphics) or JPG (for photos)
3. Name it: `article-slug.svg` or `article-slug.jpg`
   - Example: `elden-ring-achievements.svg`

#### Step 2: Upload via CloudCannon

**In CloudCannon:**
1. Click **Collections** → Select your article category (Gaming, Buying Guides, etc.)
2. Click **"+ New"** or **"Add Article"**
3. Go to **Featured Image** field
4. Click **"Upload Image"**
5. CloudCannon automatically saves to: `static/images/articles/`

**File will be saved as:** `static/images/articles/elden-ring-achievements.svg`

#### Step 3: Reference in Article

The front matter will auto-populate:
```yaml
---
featuredimage: "/images/articles/elden-ring-achievements.svg"
featuredImage: "images/articles/elden-ring-achievements.svg"
---
```

#### Step 4: Done!
- Image is stored in correct folder ✓
- References are correct ✓
- Automatically syncs to GitHub ✓

---

### **Scenario B: Use SHARED Product Image in Multiple Articles**

#### Step 1: Upload Product Image (Do Once)

1. Create/find product image
2. Name it: `product-description.jpeg`
   - Example: `refrigerator-lg.jpeg`
3. **Manually place in:** `static/images/products/`
   - Via VS Code: Drag & drop into folder
   - Or via Git: Add file and commit

#### Step 2: First Article Uses This Image

**Article 1: "Best Refrigerators 2026"**

Featured image: `best-refrigerators.svg` (unique to this article)

```yaml
---
featuredimage: "/images/articles/best-refrigerators.svg"
---
```

In article content (if needed to reference the product image):
```markdown
![LG Refrigerator Review](../../../images/products/refrigerator-lg.jpeg)
```

#### Step 3: Second Article Uses SAME Product Image

**Article 2: "Top Home Appliances 2026"**

Featured image: `top-home-appliances.svg` (unique to this article)

```yaml
---
featuredimage: "/images/articles/top-home-appliances.svg"
---
```

In article content (reference the SAME shared image):
```markdown
![LG Refrigerator Review](../../../images/products/refrigerator-lg.jpeg)
```

**Result:** ✓ Both articles share the same product image (`refrigerator-lg.jpeg`)

---

### **Scenario C: Use SHARED Category Image**

#### Step 1: Identify Shared Image Needed

"I need a 'computer' image for:"
- Homepage carousel
- Electronics buying guide page
- Multiple tech articles

#### Step 2: Create/Upload Category Image Once

1. Design image: `computer-2026.jpg`
2. Place in: `static/images/categories/`
3. Reference as: `images/categories/computer-2026.jpg`

#### Step 3: Reference in Multiple Places

**In posts.json (for carousel):**
```json
{
  "image": "images/categories/computer-2026.jpg"
}
```

**In articles that need it:**
```markdown
![Category Image](../../../images/categories/computer-2026.jpg)
```

**In layouts (if needed):**
```html
<img src="/images/categories/computer-2026.jpg" alt="Computer Category">
```

**Result:** ✓ Same image used in multiple places

---

## 6. Shared vs. Article-Specific Images

### 📊 **Quick Decision Tree**

```
Is this image used in multiple articles or pages?
│
├─ YES → SHARED IMAGE
│  ├─ Is it a product image?
│  │  └─ YES → static/images/products/[product-name].jpeg
│  │
│  ├─ Is it a category/section visual?
│  │  └─ YES → static/images/categories/[category-name]-[year].jpg
│  │
│  └─ Is it a logo/icon/UI element?
│     └─ YES → static/images/logos/ or static/images/ui/
│
└─ NO → ARTICLE-SPECIFIC
   └─ static/images/articles/[article-slug].svg
```

---

### **Article-Specific Images (NOT Shared)**

These images are unique to ONE article only:

| Article | Image Location | Filename | Used in Other Articles? |
|---|---|---|---|
| "Elden Ring Achievements" | `articles/` | `elden-ring-achievements.svg` | ❌ No |
| "Best Laptops 2026" | `articles/` | `best-laptops.svg` | ❌ No |
| "Beginner Gaming Guide" | `articles/` | `beginner-gaming-guide.svg` | ❌ No |
| "Wireless Headphones Review" | `articles/` | `wireless-headphones.svg` | ❌ No |

**When to use:**
- ✅ Each article gets a unique featured image
- ✅ Image represents that specific article's topic
- ✅ No other article needs this exact image
- ❌ NOT reused elsewhere

---

### **Shared Images (Reused)**

These images are used in MULTIPLE articles or pages:

| Image Name | Location | Used in | Count |
|---|---|---|---|
| `computer-2026.jpg` | `categories/` | Homepage, Electronics buying guide, 3 tech articles | 5+ places |
| `refrigerator-lg.jpeg` | `products/` | "Best Refrigerators" & "Home Appliances Guide" | 2 articles |
| `youtube.png` | `ui/` | Footer on ALL pages | ∞ (everywhere) |
| `logo.png` | `logos/` | Header on ALL pages | ∞ (everywhere) |
| `placeholder.svg` | `ui/` | Fallback for broken images | Throughout |

**When to use:**
- ✅ Image used across multiple articles
- ✅ Image represents a category/product (not specific article)
- ✅ Same image file needed in multiple places
- ❌ Not unique to a single article

---

### **Decision Matrix**

```
Question: Can I use the same image in another article?

IF YES:
├─ Is it a product? → products/ folder
├─ Is it a category visual? → categories/ folder
├─ Is it a logo/icon? → logos/ or ui/ folder
└─ Is it a background? → backgrounds/ folder

IF NO:
└─ It's article-specific → articles/ folder
```

---

## 7. CloudCannon Workflow

### **Adding Images via CloudCannon (Recommended for Non-Technical Users)**

#### For Article Featured Images:

1. **Login to CloudCannon**
   - Visit: https://cloudcannon.com
   - Select your AITechReviews site

2. **Navigate to Collection**
   - Click **Collections** (left sidebar)
   - Select category: Gaming, Buying Guides, Tutorials, etc.

3. **Create New Article**
   - Click **"+ New"** button
   - Select **"Add Gaming Achievement"** (or your category)

4. **Upload Featured Image**
   - Scroll to **"Featured Image"** field
   - Click **"Upload Image"** or **"Choose From Media"**
   - Select your image (1200×630px recommended)
   - CloudCannon auto-saves to: `static/images/articles/`

5. **Fill Form & Save**
   - Complete article form
   - Click **"Update"** to publish
   - Image path auto-generates in front matter

✅ **Result:** Image automatically in correct folder with correct reference

---

#### For Shared Images (Manual Process):

Since shared images might be used before being created, add them manually:

1. **Create/Design Image**
   - Make your shared image (e.g., `computer-2026.jpg`)

2. **Upload via VS Code**
   - Open VS Code file explorer
   - Navigate to `static/images/[appropriate-folder]/`
   - Drag & drop your image into the folder

3. **Commit & Push**
   - Stage file: `git add static/images/[folder]/[image-name].jpg`
   - Commit: `git commit -m "Add [image-name] image"`
   - Push: `git push origin main`

4. **Reference in Articles**
   - When creating article on CloudCannon, reference the image in content
   - Or add to posts.json/layout files as needed

---

## 8. Common Scenarios

### **Scenario 1: I Created Multiple Articles About "Elden Ring"**

**Articles:**
- Article 1: "Elden Ring Achievements Guide"
- Article 2: "Elden Ring Boss Battles Tips"
- Article 3: "Elden Ring Builds Guide"

**Image Strategy:**

```
Each article needs a UNIQUE featured image:

Article 1 Featured: elden-ring-achievements.svg
Article 2 Featured: elden-ring-boss-battles.svg
Article 3 Featured: elden-ring-builds.svg

Location: static/images/articles/
```

❌ **DON'T:** Use same `elden-ring.svg` for all three articles  
✅ **DO:** Create unique variations for each article

**Why:** Each article has different topic, needs its own visual identity

---

### **Scenario 2: Multiple Articles Share a Product Review**

**Articles:**
- "Best Laptops 2026"
- "Gaming Laptops Comparison"
- "Work Laptops Review"

**Shared Product Images:**

```
If articles mention same laptops, share the product images:

static/images/products/
├── laptop-dell-xps.jpeg      ← Shared by Article 1 & 3
├── laptop-asus-rog.jpeg      ← Shared by Article 2 & 3
├── laptop-macbook-pro.jpeg   ← Shared by All 3 articles
└── laptop-hp-pavilion.jpeg   ← Shared by Article 1 & 2

In Article 1 content:
[Dell XPS Laptop](../../../images/products/laptop-dell-xps.jpeg)

In Article 3 content:
[Dell XPS Laptop](../../../images/products/laptop-dell-xps.jpeg)
← SAME image referenced in both
```

✅ **RESULT:** Memory saved, images updated once affect all articles

---

### **Scenario 3: Homepage Uses Multiple Category Images**

**Homepage needs:**
- Gaming section image
- Buying Guides section image
- Tutorials section image

**Image Strategy:**

```
static/images/categories/
├── gaming-2026.jpg       ← On gaming section of homepage + gaming articles
├── electronics-2026.jpg  ← On buying guides section + electronics articles
└── tutorials-2026.jpg    ← On tutorials section + tutorial articles

Referenced in:
• posts.json (homepage carousel)
• Article content (if article discusses category)
• Layout files (category section visuals)
```

✅ **RESULT:** One image, used in multiple places

---

### **Scenario 4: New Product Type, Create New Subfolder**

**Situation:** You now have lots of product images

**New structure (optional):**

```
static/images/products/
├── laptops/
│   ├── dell-xps.jpeg
│   ├── asus-rog.jpeg
│   └── macbook-pro.jpeg
├── furniture/
│   ├── office-chair.jpeg
│   ├── bed.jpeg
│   └── sofa.jpeg
└── appliances/
    ├── refrigerator.jpeg
    └── washing-machine.jpeg
```

**Reference in articles:**
```markdown
![Dell XPS Laptop](../../../images/products/laptops/dell-xps.jpeg)
```

✅ **Benefits:** Better organization for lots of products

---

## 9. Best Practices

### ✅ **DO:**

1. **Create Featured Images for Every Article**
   - Each article needs unique featured image
   - Improves SEO (social media cards)
   - Better user experience

2. **Use Shared Images When Possible**
   - Saves storage space
   - Easier to maintain
   - Consistent branding

3. **Follow Naming Convention**
   - Use lowercase hyphens
   - Be descriptive
   - Keep names concise (30 chars max)

4. **Optimize Before Upload**
   - SVG for graphics/logos (small file size)
   - JPG for photos (smaller than PNG for photos)
   - Compress images before uploading
   - Use recommended dimensions

5. **Organize by Type**
   - Articles → articles/
   - Products → products/
   - Categories → categories/
   - Logos → logos/
   - UI → ui/
   - Backgrounds → backgrounds/

6. **Document Image Usage**
   - Add comments if images appear in multiple places
   - Note which images are shared vs. unique
   - Keep a local list of shared images

---

### ❌ **DON'T:**

1. **Don't Use Same Image for Different Articles**
   - Each article featured image should be unique
   - Exception: Product images (can be shared in content)

2. **Don't Store All Images in Root**
   - Keep folders organized
   - Avoids cluttering static/images/

3. **Don't Use Wrong Format**
   - Don't use PNG for large photos (file size too big)
   - Don't use JPG for logos (use PNG or SVG)
   - Don't use wrong dimensions

4. **Don't Mix Naming Styles**
   - Don't use spaces or underscores
   - Don't use UPPERCASE
   - Don't use vague names (image1.jpg)

5. **Don't Forget to Commit**
   - Always commit image changes to Git
   - Push to GitHub regularly
   - Sync with CloudCannon

6. **Don't Duplicate Shared Images**
   - Don't upload same image multiple times
   - Use the single shared copy everywhere
   - Reference the same file

---

## 10. Quick Reference

### **Image Folder Quick Guide**

```
ARTICLES folder (static/images/articles/)
  Purpose: Featured images (ONE per article)
  Naming: article-topic-slug.svg or .jpg
  Sharing: ❌ Unique per article
  Size: 1200×630px
  Examples: elden-ring-achievements.svg, best-laptops.svg
  Reference: /images/articles/article-name.svg

LOGOS folder (static/images/logos/)
  Purpose: Logo variations
  Naming: logo-variant.png
  Sharing: ✅ Used everywhere
  Size: 200×60px (adjust to your logo)
  Examples: logo.png, logo-dark.png
  Reference: /images/logos/logo.png

UI folder (static/images/ui/)
  Purpose: Icons, favicons, UI elements
  Naming: element-name.png or .svg
  Sharing: ✅ Used throughout site
  Size: Varies (favicon 32×32px)
  Examples: youtube.png, favicon.png, placeholder.svg
  Reference: /images/ui/favicon.png

CATEGORIES folder (static/images/categories/)
  Purpose: Category visuals, section images
  Naming: category-name-year.jpg
  Sharing: ✅ Used in multiple places
  Size: 1200×800px
  Examples: computer-2026.jpg, electronics-2026.jpg
  Reference: images/categories/computer-2026.jpg

PRODUCTS folder (static/images/products/)
  Purpose: Product photos for buying guides
  Naming: product-brand.jpeg or product-type.jpeg
  Sharing: ✅ Can be in multiple articles
  Size: 600×400px
  Examples: refrigerator-lg.jpeg, office-chair.jpeg
  Reference: ../../../images/products/refrigerator-lg.jpeg

BACKGROUNDS folder (static/images/backgrounds/)
  Purpose: Background images for sections
  Naming: section-name-bg.svg or .jpg
  Sharing: ✅ Reused for similar sections
  Size: 1920×1080px
  Examples: home-bg.svg, hero-bg.jpg
  Reference: /images/backgrounds/home-bg.svg
```

---

### **Decision Checklist**

Before adding an image, ask:

```
□ Is this a featured image for an article?
  └─ YES → static/images/articles/ (use unique filename)

□ Is this used in multiple articles?
  ├─ YES & it's a product → static/images/products/
  ├─ YES & it's a category visual → static/images/categories/
  └─ YES & it's UI/icon → static/images/ui/ or logos/

□ What format should I use?
  ├─ Graphic/icon → SVG
  ├─ Photo → JPG
  └─ Logo/icon with transparency → PNG

□ What size should it be?
  ├─ Article featured → 1200×630px
  ├─ Category image → 1200×800px
  ├─ Product image → 600×400px
  ├─ Favicon → 32×32px
  └─ Background → 1920×1080px

□ What should I name it?
  ├─ Article: article-topic.svg
  ├─ Product: product-brand.jpeg
  ├─ Category: category-year.jpg
  └─ UI: element-name.png

□ Where do I upload?
  ├─ CloudCannon (for article featured images)
  ├─ VS Code (for other images, then Git commit)
  └─ Manually via file manager
```

---

### **File Path Reference**

**In Articles (Markdown):**
```yaml
# Article featured image
featuredImage: "images/articles/article-slug.svg"

# Product image in article content
![Product Review](../../../images/products/product-name.jpeg)

# Category image in article
![Category](../../../images/categories/category-name.jpg)
```

**In Layout Files (HTML/Templates):**
```html
<!-- Logo in header -->
<img src="{{ "/images/logos/logo.png" | relURL }}" alt="Logo">

<!-- Category image -->
<img src="/images/categories/computer-2026.jpg" alt="Category">

<!-- Social icon -->
<img src="/images/ui/youtube.png" alt="YouTube">

<!-- Favicon in head -->
<link rel="icon" href="{{ "/images/ui/favicon.png" | relURL }}">
```

**In JavaScript:**
```javascript
// Fallback placeholder
const placeholder = "/images/ui/placeholder.svg";

// Social icon
const youtubeIcon = "/images/ui/youtube.png";

// Category image
const categoryImage = "/images/categories/computer-2026.jpg";
```

---

### **Common Image Sizes**

```
Article Featured Image:      1200×630px (16:9 ratio)
Category Section Image:      1200×800px (3:2 ratio)
Product Image:               600×400px  (3:2 ratio)
Logo:                        200×60px   (3:1 ratio)
Favicon:                     32×32px    (1:1 ratio)
Background Hero:             1920×1080px (16:9 ratio)
Social Media Icon:           100×100px  (1:1 ratio)
Placeholder:                 600×400px  (3:2 ratio)
```

---

## Implementation Checklist

When adding new images to your site:

```
□ Create/design image
□ Optimize image (compress, correct size)
□ Choose correct format (SVG, JPG, PNG)
□ Determine if article-specific or shared
□ Choose correct folder location
□ Use proper naming convention
□ Upload via CloudCannon (for featured images)
  OR manually via VS Code (for shared images)
□ Update reference in article/layout/config
□ Test that image displays correctly
□ Commit changes to Git
□ Push to GitHub
□ Verify on live site
```

---

## Examples by Category

### **Gaming Articles**

```
Gaming/Guides:
- elden-ring-tips.svg → articles/
- dark-souls-beginner.svg → articles/
- generic gaming-tips-2026.jpg → categories/ (if shared)

Gaming/Achievements:
- elden-ring-achievements.svg → articles/
- elden-ring-bosses.svg → articles/ (unique per article)
```

### **Buying Guides**

```
Electronics:
- best-laptops.svg → articles/ (featured image)
- laptop-dell.jpeg → products/ (shared product image)

Home Appliances:
- best-washing-machines.svg → articles/
- washing-machine-samsung.jpeg → products/ (shared)
- appliances-2026.jpg → categories/ (shared category image)
```

### **Tutorials**

```
Software:
- windows-optimization.svg → articles/
- linux-commands.svg → articles/
- productivity-software.svg → articles/
- generic software-tools-2026.jpg → categories/
```

---

## Support & Troubleshooting

### Image Not Showing?

1. **Check image path in article:**
   ```yaml
   # ✓ Correct
   featuredImage: "images/articles/best-laptops.svg"
   
   # ✗ Wrong
   featuredImage: "static/images/articles/best-laptops.svg"
   ```

2. **Verify file exists in folder:**
   - Open VS Code
   - Navigate to `static/images/articles/`
   - Confirm file is there

3. **Check file name spelling:**
   - File names are case-sensitive on Linux servers
   - Use lowercase with hyphens
   - No spaces or special characters

4. **Clear browser cache:**
   - Hard refresh: Cmd+Shift+R (Mac) or Ctrl+Shift+R (Windows)

---

## Summary

✅ **Article Featured Images:** `static/images/articles/` (UNIQUE per article)  
✅ **Shared Product Images:** `static/images/products/` (Used in multiple articles)  
✅ **Category/Section Images:** `static/images/categories/` (Reused across site)  
✅ **Logo & Branding:** `static/images/logos/` (Site-wide branding)  
✅ **UI Elements:** `static/images/ui/` (Icons, favicons, UI)  
✅ **Backgrounds:** `static/images/backgrounds/` (Background images)  

**Golden Rule:** One unique featured image per article. Reuse shared images across multiple places.

---

**Last Updated:** 28 April 2026  
**Version:** 1.0  
**For:** AITechReviews Hugo Site

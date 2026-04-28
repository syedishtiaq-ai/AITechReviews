# Image Placement - Quick Visual Guide

> **Quick Reference for Image Management - AITechReviews**

---

## 🎯 The Golden Rule

```
ARTICLE-SPECIFIC IMAGE          SHARED IMAGE
     (UNIQUE)                    (REUSED)
        |                           |
        v                           v
   articles/                   logos/, ui/, 
 folder ONLY                 categories/, products/,
        |                       backgrounds/
        |                           |
   One per               Can be used in
   article              multiple places
```

---

## 📁 Where to Put Images?

### Decision Matrix

```
START HERE: "Do I need this image for multiple articles?"
              
    NO ──────────────────────┐
                             v
                   ❌ Don't share it
                   ✅ Use for ONE article
                   📁 → articles/ folder
                   
    YES ─────────────┐
                     v
          "What type of image?"
                     |
        ┌────────────┼────────────┬──────────────┐
        v            v            v              v
    Product?     Category?     Logo/Icon?    Background?
        |            |            |             |
        v            v            v             v
    products/   categories/   logos/ or    backgrounds/
                                ui/
```

---

## 🗂️ Quick Folder Guide

| Folder | Purpose | File Example | Shared? | Size |
|--------|---------|--------------|---------|------|
| **articles/** | Featured image per article | `best-laptops.svg` | ❌ No | 1200×630 |
| **logos/** | Logo variations | `logo.png` | ✅ Yes | 200×60 |
| **ui/** | Icons, favicon | `youtube.png` | ✅ Yes | Varies |
| **categories/** | Section visuals | `computer-2026.jpg` | ✅ Yes | 1200×800 |
| **products/** | Product photos | `refrigerator.jpeg` | ✅ Yes | 600×400 |
| **backgrounds/** | Background images | `home-bg.svg` | ✅ Yes | 1920×1080 |

---

## 📝 Naming Examples

### ✅ **CORRECT**
```
articles/elden-ring-achievements.svg
categories/electronics-2026.jpg
products/refrigerator-lg.jpeg
logos/logo.png
ui/youtube.png
```

### ❌ **INCORRECT**
```
articles/Elden Ring.svg           (spaces)
categories/COMPUTER.jpg           (UPPERCASE)
products/image_1.jpeg             (underscore)
logos/Main_Logo_2026_v2.png      (too complex)
ui/btn_social_icon.svg            (underscores)
```

---

## 🎬 Scenarios at a Glance

### Scenario 1️⃣: I'm Creating One Article

```
Article: "Best Laptops 2026"

Step 1: Create image → best-laptops.svg
Step 2: Upload via CloudCannon
Step 3: Auto-saves to → articles/
Step 4: Reference auto-generated ✓
```

---

### Scenario 2️⃣: Multiple Articles Share a Product Image

```
Article 1: "Best Refrigerators"
Article 2: "Home Appliances Guide"
Article 3: "Top Kitchen Products"

Shared Product Image: refrigerator-lg.jpeg
Location: static/images/products/

All 3 articles reference:
../../../images/products/refrigerator-lg.jpeg
✓ SAME file in all articles (saves space)
```

---

### Scenario 3️⃣: Homepage Uses Category Image

```
Homepage needs: Computer category image

Create once: computer-2026.jpg
Place in: static/images/categories/

Used in:
• Homepage carousel → posts.json
• Articles about computers → referenced in content
• Category page → layout file
✓ ONE file, MULTIPLE places
```

---

## 📐 Image Dimensions Quick Ref

```
Article Featured:  1200 × 630   (Instagram post size)
Category:          1200 × 800   (wider format)
Product:           600 × 400    (smaller)
Logo:              200 × 60     (horizontal)
Favicon:           32 × 32      (square)
Background:        1920 × 1080  (full HD)
```

---

## 🔄 CloudCannon Workflow (3 Steps)

```
Step 1: Open CloudCannon
        └─ Collections → Select category

Step 2: Click "+ New" Article
        └─ Featured Image field → Upload

Step 3: Save
        └─ Auto-saves to articles/
        └─ Reference auto-generated
```

✅ Done! Image is in correct folder with correct reference.

---

## 💡 Pro Tips

### ✅ DO THIS:
- Create unique featured image for each article
- Reuse product images across articles
- Use consistent naming (lowercase-hyphens)
- Optimize images before upload (compress)
- Use CloudCannon for featured images (easiest)

### ❌ DON'T DO THIS:
- Use same featured image for different articles
- Put all images in root static/images/
- Mix naming styles (CamelCase, snake_case, etc.)
- Upload full-resolution photos (too large)
- Forget to commit changes to Git

---

## 🚀 Checklist Before Uploading

```
□ Image created/designed
□ Image optimized (compressed)
□ Correct dimensions?
□ Correct format (SVG/JPG/PNG)?
□ Correct naming (lowercase-hyphens)?
□ Correct folder chosen?
□ Reference path correct?
```

---

## 📚 When to Read Full Guide

| Need Help With... | See Section... |
|---|---|
| Unsure where image goes | "Common Scenarios" |
| Need naming convention | "Naming Conventions" |
| Want CloudCannon steps | "CloudCannon Workflow" |
| Troubleshooting image | "Troubleshooting" |
| Multiple product images | "Shared vs Article-Specific" |
| File size/format | "Image Specifications" |

**👉 Full guide:** See `IMAGE_PLACEMENT_GUIDE.md`

---

## 🔗 File Paths Quick Ref

```yaml
# In article front matter:
featuredImage: "images/articles/article-name.svg"

# In article content (product image):
![Product](../../../images/products/product-name.jpeg)

# In HTML templates:
src="/images/logos/logo.png"
src="/images/ui/youtube.png"
src="/images/categories/computer-2026.jpg"
```

---

## ⚡ Super Quick Start

1. **Creating article with CloudCannon?**
   ```
   → Click Featured Image → Upload → Done ✓
   (Auto-saves to articles/ folder)
   ```

2. **Creating shared product image?**
   ```
   → Design image
   → Save as: product-name.jpeg
   → Drag to: static/images/products/
   → Commit to Git
   ```

3. **Creating shared category image?**
   ```
   → Design image
   → Save as: category-2026.jpg
   → Drag to: static/images/categories/
   → Reference in posts.json or layouts
   ```

---

**Last Updated:** 28 April 2026  
**Format:** Quick Visual Reference  
**Full Guide:** [IMAGE_PLACEMENT_GUIDE.md](IMAGE_PLACEMENT_GUIDE.md)

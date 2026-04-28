# Maintenance Page - Quick Start

## ✅ What You Have

**File:** `maintenance.html`
- Professional design matching your AITechReviews branding
- Bright blue colors, clean layout
- Responsive (works on desktop, tablet, phone)
- Your logo included
- Animated countdown timer

---

## 🚀 Fastest Way to Deploy (5 min)

### Step 1: Upload to Cloudflare R2

```
1. Go to: https://dash.cloudflare.com
2. Login with your credentials
3. Left sidebar → "R2"
4. Click "Create bucket" → Name: "maintenance"
5. Open bucket → Click "Upload"
6. Select & drag these files:
   ✓ maintenance.html
   ✓ static/images/logo.png
```

### Step 2: Make Files Public

```
1. Right-click "maintenance.html"
2. Select "Make public"
3. Copy the public URL (save it)
4. Open folder "static/images/"
5. Right-click "logo.png" → "Make public"
```

### Step 3: Create Forwarding Rule

```
1. Cloudflare Dashboard
2. Select your domain: aitechreviews.com
3. Left sidebar → "Rules" → "Page Rules"
4. Click "Create Page Rule"
5. Pattern: *aitechreviews.com/*
6. Add setting: "Forwarding URL"
7. Type: "Permanent Redirect (301)"
8. Url: https://your-bucket-url-from-step-2/maintenance.html
9. Click "Save and Deploy"
```

### Step 4: Test

```
Open: https://aitechreviews.com
Should see: Your maintenance page with logo
Works on: Desktop, tablet, phone ✓
```

---

## 📋 Files You're Uploading

| File | Size | Purpose |
|------|------|---------|
| maintenance.html | ~8 KB | Main page with styling |
| logo.png | ~50 KB | Your AITechReviews logo |

---

## ⏱️ Timeline

| Action | Time |
|--------|------|
| Upload files | 1 min |
| Create rule | 2 min |
| Wait for DNS | 1 min |
| Test | 1 min |
| **Total** | **~5 minutes** |

---

## 🔄 Going Back Live

When development is done:

```
1. Cloudflare Dashboard
2. Domain: aitechreviews.com
3. Rules → Page Rules
4. Find maintenance rule
5. Click "Edit" → "Delete"
6. Confirm deletion
7. Done! Your site is live again
```

---

## ✨ Page Features

✅ Professional design  
✅ Matches your branding (blue colors)  
✅ Your logo displayed  
✅ Mobile responsive  
✅ Animated effects  
✅ Status information  
✅ Contact info section  
✅ Social media links  
✅ Maintenance message  

---

## 🆘 Troubleshooting

**Logo not showing?**
- Check file is marked "public"
- Check path in rule is correct
- Clear browser cache: Ctrl+Shift+Delete

**Old website still showing?**
- Hard refresh: Ctrl+F5 (Windows) or Cmd+Shift+R (Mac)
- Check rule is enabled
- Wait 60 seconds for propagation

**Styling broken?**
- Try different browser
- Clear cache completely
- Check file uploaded correctly

---

## 📚 Full Details

For step-by-step detailed instructions, see:
→ **CLOUDFLARE_MAINTENANCE_GUIDE.md**

---

## 💾 File Locations

```
Your Laptop:
  /Users/ishtiaq/Documents/AITechReviews/
    ├── maintenance.html ← Upload this
    └── static/images/
        └── logo.png ← Upload this too
```

---

## 🎯 Next Steps

1. Read "Fastest Way to Deploy" above
2. Upload files to Cloudflare R2
3. Create forwarding rule
4. Test in browser
5. Done!

---

**Need detailed help? → See CLOUDFLARE_MAINTENANCE_GUIDE.md**

**Ready to deploy? → Follow "Fastest Way" above (5 minutes)**

# Upload Maintenance Page to Cloudflare - Step-by-Step Guide

## Overview

Your `maintenance.html` file is ready to deploy. This guide shows you how to upload it to Cloudflare to display during development.

---

## Prerequisites

✅ Cloudflare account (should already be set up)  
✅ Domain added to Cloudflare  
✅ `maintenance.html` file created (✓ Done!)

---

## Step 1: Prepare Your Files

### Option A: With Logo (Recommended)

You need to upload both the HTML file AND the logo image.

```
Files to upload:
  ❶ maintenance.html
  ❷ static/images/logo.png (your logo)
```

**Structure on Cloudflare:**
```
/
  ├── maintenance.html
  └── static/
      └── images/
          └── logo.png
```

### Option B: Without Logo (Simple)

If you only want to upload the HTML:

Edit `maintenance.html` and change this line:
```html
<img src="static/images/logo.png" alt="AITechReviews Logo">
```

To just show text instead:
```html
<h2 style="color: #2563eb; font-size: 1.5rem; margin-bottom: 20px;">AITechReviews</h2>
```

---

## Step 2: Upload to Cloudflare - Method 1 (Web Dashboard - Easiest)

### 2.1 Log Into Cloudflare

1. Go to [cloudflare.com](https://cloudflare.com)
2. Click **"Log in"** (top right)
3. Enter your email and password
4. Click **"Sign in"**

### 2.2 Select Your Domain

1. In the dashboard, click on your domain (e.g., **aitechreviews.com**)
2. You should see your domain overview

### 2.3 Access Workers/Pages

**Option A: Using Cloudflare Pages** (Recommended for static files)

1. In left sidebar, click **"Workers & Pages"**
2. Click **"Pages"** tab
3. Click **"Upload assets"** or create a new project
4. Upload your `maintenance.html` and logo folder

**Option B: Using Cloudflare Workers** (More advanced)

1. In left sidebar, click **"Workers & Pages"**
2. Click **"Workers"** tab
3. Click **"Create Worker"**
4. Name it: `maintenance`
5. Paste this code (replaces HTML with your file):
```javascript
export default {
  async fetch(request) {
    const maintenancePage = await fetch('maintenance.html');
    return new Response(maintenancePage, {
      headers: {
        'Content-Type': 'text/html',
      },
    });
  },
};
```

---

## Step 3: Upload to Cloudflare - Method 2 (Drag & Drop)

**This is the EASIEST method:**

### 3.1 Open R2 (Object Storage)

1. Log into Cloudflare dashboard
2. Left sidebar → **"R2"**
3. Click **"Create bucket"**
4. Name it: `maintenance`
5. Click **"Create bucket"**

### 3.2 Upload Files

1. Inside the `maintenance` bucket, click **"Upload"**
2. Drag and drop your files:
   - `maintenance.html`
   - Create folder `static/images/`
   - Upload `logo.png` into that folder

**Your R2 structure:**
```
maintenance/ (bucket)
  ├── maintenance.html
  └── static/
      └── images/
          └── logo.png
```

### 3.3 Make Files Public

1. Select `maintenance.html`
2. Click **"Configure"** or **"Make public"**
3. Copy the public URL
4. Do the same for all files in the folder

---

## Step 4: Upload to Cloudflare - Method 3 (Using Wrangler CLI)

**For advanced users with command line:**

### 4.1 Install Wrangler

```bash
npm install -g wrangler
```

### 4.2 Authenticate

```bash
wrangler login
```

### 4.3 Create Project

```bash
mkdir maintenance-site
cd maintenance-site
wrangler init
```

### 4.4 Add Files to Project

```bash
# Copy your files
cp /path/to/maintenance.html .
cp -r /path/to/static ./

# Create wrangler.toml config
cat > wrangler.toml << 'EOF'
name = "maintenance"
type = "javascript"
account_id = "YOUR_ACCOUNT_ID"
EOF
```

### 4.5 Deploy

```bash
wrangler deploy
```

---

## Step 5: Set Cloudflare Page Rule (Redirect All Traffic)

Once uploaded, redirect all traffic to maintenance page:

### 5.1 Navigate to Page Rules

1. Cloudflare Dashboard
2. Domain: **aitechreviews.com**
3. Left sidebar → **"Rules"** → **"Page Rules"**

### 5.2 Create Rule

1. Click **"Create Page Rule"**
2. **If URL matches:** `*aitechreviews.com/*`
3. Click **"Add a setting"** → **"Forwarding URL"**
4. **Forwarding Type:** `Permanent Redirect (301)`
5. **Forwarding URL:** `https://maintenance-bucket.r2.amazonaws.com/maintenance.html` 
   OR your Cloudflare Pages URL
6. Click **"Save and Deploy"**

---

## Step 6: Set Cloudflare Workers Route (Advanced - Recommended)

**Better than Page Rules - applies to everything automatically:**

### 6.1 Create Worker

1. Cloudflare Dashboard → **"Workers & Pages"**
2. Click **"Create Worker"**
3. Name: `maintenance-redirect`

### 6.2 Add Worker Code

```javascript
export default {
  async fetch(request) {
    // Return maintenance page for all requests
    return new Response(maintenanceHTML, {
      status: 200,
      headers: {
        'Content-Type': 'text/html; charset=utf-8',
      },
    });
  },
};

const maintenanceHTML = `
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Maintenance - AITechReviews</title>
  <!-- Your HTML from maintenance.html -->
</head>
<body>
  <!-- Your body content -->
</body>
</html>
`;
```

Paste your complete maintenance.html content inside the backticks.

### 6.3 Deploy Worker

1. Click **"Deploy"**
2. You'll get a URL like: `https://maintenance-redirect.yourname.workers.dev`

### 6.4 Route to Your Domain

1. Click **"Triggers"**
2. Click **"Add route"**
3. **Route:** `*aitechreviews.com/*`
4. **Worker:** Select your `maintenance-redirect` worker
5. Click **"Save"**

---

## Step 7: Test Your Maintenance Page

### 7.1 In Browser

```
Visit: https://aitechreviews.com
Expected: See your maintenance page with logo
```

### 7.2 Test Different Paths

```
https://aitechreviews.com/
https://aitechreviews.com/articles/
https://aitechreviews.com/anything/
Expected: All show maintenance page
```

### 7.3 Test Mobile

Open on phone/tablet:
```
https://aitechreviews.com
Expected: Responsive maintenance page
```

---

## Step 8: Go Back Live (Remove Maintenance)

When ready to go live:

### 8.1 Disable Page Rule

1. Cloudflare Dashboard → **"Rules"** → **"Page Rules"**
2. Find your maintenance rule
3. Click **"Edit"** → **"Delete"**

OR

### 8.2 Disable Worker

1. Cloudflare Dashboard → **"Workers & Pages"**
2. Find `maintenance-redirect` worker
3. Click **"Triggers"**
4. Remove the route
5. Or delete the entire worker

---

## Quick Reference - Simplest Path

If you're in a hurry, here's the FASTEST way:

### Quick Method: Direct Upload to R2

1. **Cloudflare Dashboard** → **R2** → **Create bucket** "maintenance"
2. **Upload:**
   - maintenance.html
   - static/images/logo.png (in folder)
3. **Make public** (right-click files)
4. **Copy public URL**
5. **Add Page Rule:**
   - URL: `*aitechreviews.com/*`
   - Forwarding: 301 to your R2 URL
6. **Test:** Visit your domain

**Total time: 5-10 minutes**

---

## Troubleshooting

### Logo Not Showing

**Problem:** Maintenance page loads but logo is broken

**Solution:**
1. Check logo file was uploaded to correct path
2. Verify file is public (not private)
3. Check path in HTML matches uploaded path
4. Update path if needed:
   ```html
   <img src="https://your-bucket.r2.amazonaws.com/static/images/logo.png">
   ```

### Page Not Changing

**Problem:** Old website still shows instead of maintenance

**Solution:**
1. **Clear browser cache:**
   ```
   Ctrl+Shift+Delete (Windows)
   Cmd+Shift+Delete (Mac)
   ```
2. **Hard refresh:**
   ```
   Ctrl+F5 (Windows)
   Cmd+Shift+R (Mac)
   ```
3. **Check Page Rule is enabled:**
   - Cloudflare → Page Rules → Verify rule exists and is on
4. **Check Worker is deployed:**
   - Workers & Pages → Verify route is added

### Styling Looks Wrong

**Problem:** Colors or layout appear broken

**Solution:**
1. Check browser console for CSS errors (F12 → Console)
2. Verify HTML file is valid
3. Try different browser to rule out cache
4. Check file encoding is UTF-8

### High Traffic Delays

**Problem:** Maintenance page is slow

**Solution:**
1. Use Cloudflare Cache rules to cache HTML:
   - Dashboard → **Caching** → **Cache Rules**
   - Create rule caching HTML with TTL 1 hour
2. Enable gzip compression in Cloudflare settings

---

## Advanced Features

### Add SSL/TLS

Already included with Cloudflare free plan ✅

### Add DDoS Protection

1. Cloudflare Dashboard → **Security** → **DDoS Protection**
2. Enable all protections (default: on)

### Add WAF (Web Application Firewall)

1. Cloudflare Dashboard → **Security** → **WAF**
2. Enable recommended rules

### Monitor Traffic

1. Cloudflare Dashboard → **Analytics**
2. View who's visiting your maintenance page

---

## Files Reference

| File | Location | Purpose |
|------|----------|---------|
| maintenance.html | `/Users/ishtiaq/Documents/AITechReviews/maintenance.html` | Main page to upload |
| logo.png | `/Users/ishtiaq/Documents/AITechReviews/static/images/logo.png` | Your logo to upload |

---

## Summary

```
1. ✅ maintenance.html created with your branding
2. 📤 Upload to Cloudflare (R2, Pages, or Workers)
3. 🔗 Set Page Rule or Worker route
4. 🧪 Test in browser
5. ✨ Site shows maintenance message
6. 🔄 Git commit your changes (optional)
7. ⏹️ Remove rule when ready to go live
```

---

## Need Help?

- **Cloudflare Support:** https://support.cloudflare.com
- **Contact:** Your email at support@aitechreviews.com
- **GitHub:** Version control your maintenance page

---

**Your maintenance page is professional, branded, and ready to deploy! 🚀**

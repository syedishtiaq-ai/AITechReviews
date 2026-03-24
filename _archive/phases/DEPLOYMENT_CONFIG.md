# Deployment Configuration Guide

## Current Status: DEVELOPMENT MODE
**⚠️ Site is currently in LOCAL DEVELOPMENT mode - NOT uploading to production**

---

## Development Build (Current Configuration)

### Active Configuration
- **baseURL**: `http://localhost:1313/`
- **Analytics**: Enabled (no data sent during dev)
- **Build Target**: Local testing only
- **Cloudflare**: ❌ NOT syncing (safe for testing)

### To Build & Preview Locally

```bash
# Start local development server
hugo server

# Or create static build without serving
hugo --cleanDestinationDir
```

The site will be available at `http://localhost:1313/` and all internal links will work correctly.

---

## Production Deployment (When Ready)

### ⚠️ BEFORE DEPLOYING TO CLOUDFLARE:

1. **Update baseURL** in `hugo.toml`:
   ```toml
   baseURL = "https://aitechreviews.co.in/"
   ```

2. **Verify all templates** reference relative URLs using Hugo `relURL` filter:
   ```html
   {{ relURL "/articles/" }}
   ```

3. **Build production version**:
   ```bash
   # Update baseURL to production first
   hugo --cleanDestinationDir
   ```

4. **Test against public/ directory** to ensure all links point to `aitechreviews.co.in`

5. **Deploy to Cloudflare** (via your existing workflow):
   - Push changes to repository
   - Cloudflare Pages detects new push
   - Automatically deploys from `public/` directory

---

## File Safety Notes

### Directories NOT being synced to live site:
- ✅ `/content/` - Local content editing only
- ✅ `/layouts/` - Template development
- ✅ `/static/` - Static assets (edits applied on next build)
- ✅ `/scripts/` - Migration scripts only

### Safe to edit without pushing:
- `hugo.toml` - Only baseURL matters for live changes
- Template files - Need rebuild to take effect
- Content files - Only published when built and deployed

---

## Current Phase: 2.3 (Frontend Features)

All development work is happening locally before final deployment.

**Phase Completion Checklist:**
- ✅ Phase 1.2: Content Migration (20 articles)
- ✅ Phase 2.1: Article Templates
- ✅ Phase 2.2: Navigation Components  
- 🔄 Phase 2.3: Frontend Features (IN PROGRESS)
- ⏳ Phase 3-9: Additional features

**Deploy only after ALL phases are complete and tested.**

---

## Quick Reference

| Action | Command | Environment |
|--------|---------|-------------|
| Local Preview | `hugo server` | Development (localhost) |
| Local Build | `hugo --cleanDestinationDir` | Development (localhost) |
| Check Build Status | Look in `/public` directory | Development (localhost) |
| Deploy to Live | Update baseURL → Build → Commit → Push | Production only |

---

## Notes for Future Deployments

When all phases are complete and site is ready for production:

1. Change `baseURL` from `http://localhost:1313/` to `https://aitechreviews.co.in/`
2. Run full build: `hugo --cleanDestinationDir`
3. Verify `/public/` directory has all HTML files with correct URLs
4. Commit and push to trigger Cloudflare Pages deployment
5. Monitor Cloudflare build logs for any errors
6. Test live site at aitechreviews.co.in

---

**Last Updated**: March 22, 2026  
**Development Cycle**: Phase 2.3 (Frontend Features)  
**Production Status**: 🔴 NOT READY - In active development

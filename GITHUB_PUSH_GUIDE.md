# Push to GitHub - Complete Guide

## Overview
When your website is ready, use the `push-to-github.sh` script to safely push your entire AITechReviews website to GitHub.

## Prerequisites

Before pushing to GitHub, ensure you have:

### 1. Git Installed
```bash
git --version
```
Should display: `git version X.X.X` or higher

[Install Git](https://git-scm.com/downloads) if needed

### 2. GitHub Account
- Create account at [github.com](https://github.com)
- Verify your email address
- Complete your profile

### 3. Authentication Setup

#### Option A: HTTPS (Recommended for Beginners)
Your GitHub account needs personal access tokens:

**Generate Token:**
1. Go to: Settings → Developer settings → Personal access tokens
2. Click "Generate new token"
3. Select scopes:
   - ✅ `repo` (Full control of private repositories)
   - ✅ `admin:repo_hook` (Access to hooks and services)
4. Click "Generate token"
5. **Copy the token immediately** (you won't see it again)
6. Save it securely

When pushing, use:
- **Username:** Your GitHub username
- **Password:** Your personal access token (not your GitHub password)

#### Option B: SSH (More Secure, Recommended)
1. Generate SSH key:
```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
```
Press Enter for each prompt (or set custom passphrase)

2. Add key to SSH agent:
```bash
ssh-add ~/.ssh/id_ed25519
```

3. Add public key to GitHub:
   - Go to Settings → SSH and GPG keys
   - Click "New SSH key"
   - Paste contents of `~/.ssh/id_ed25519.pub`
   - Click "Add SSH key"

4. Test connection:
```bash
ssh -T git@github.com
```
Should display: `Hi username! You've successfully authenticated...`

## Step-by-Step Guide

### Step 1: Create GitHub Repository

1. **Go to [github.com/new](https://github.com/new)**

2. **Fill in repository details:**
   - Repository name: `AITechReviews`
   - Description: `Expert Tech Reviews, Gaming Guides, and Tutorials`
   - Visibility: Choose `Public` (if you want everyone to see) or `Private` (restricted access)
   - **Do NOT** initialize with README, .gitignore, or license (your local repo already has these)

3. **Click "Create repository"**

You'll see a page with your repository URL. Copy it for the next step.

### Step 2: Prepare Your Local Repository

Before pushing, ensure everything is ready:

```bash
# Go to your project directory
cd /Users/ishtiaq/Documents/AITechReviews

# Check repository status
git status

# View recent commits
git log --oneline -5

# Ensure all changes are committed
git add -A
git commit -m "Final updates before GitHub push"
```

### Step 3: Run the Push Script

When you're ready to push:

```bash
bash scripts/push-to-github.sh
```

**The script will:**
1. ✅ Verify Git is installed
2. ✅ Check repository status
3. ✅ Ask about uncommitted changes
4. ✅ Request GitHub repository URL
5. ✅ Configure the remote
6. ✅ Push code to GitHub
7. ✅ Verify the push was successful

### Step 4: Follow Script Prompts

**When asked:**

```
Run pre-flight checks... ✓

GitHub Configuration
Enter GitHub repository URL: 
```

Paste your GitHub URL in one of these formats:

**HTTPS:**
```
https://github.com/yourusername/AITechReviews.git
```

**SSH:**
```
git@github.com:yourusername/AITechReviews.git
```

**The script will ask:**
```
Do you want to commit these changes first? (y/n):
Proceed with push? (y/n):
```

Answer `y` to proceed.

### Step 5: Authentication

**If using HTTPS:**
```
Username: your-github-username
Password: [paste your personal access token]
```

**If using SSH:**
The script will use your SSH key automatically (you may be prompted for your key passphrase if you set one)

### Step 6: Verify Success

The script will show:
```
✅ Successfully pushed to GitHub!

Repository information:
  URL: https://github.com/yourusername/AITechReviews.git
  Branch: main

✅ Local and remote branches are in sync
```

## After Pushing

### 1. Visit Your Repository
```
https://github.com/yourusername/AITechReviews
```

You should see:
- All your files and folders
- Commit history
- Branch information

### 2. Set Up GitHub Pages (Optional)

If you want GitHub to host your website:

1. Go to repository Settings
2. Scroll to "GitHub Pages"
3. Select branch: `main`
4. Select folder: `/ (root)` or `/public` (if you commit Hugo output)
5. Your site will be available at: `https://yourusername.github.io/AITechReviews`

### 3. Configure Repository Settings (Optional)

**Recommended Settings:**

1. **General Settings:**
   - Add description
   - Add website URL (when live)
   - Add topics: `hugo`, `blog`, `website`

2. **Branches:**
   - Set `main` as default branch
   - Add branch protection rules

3. **Secrets & Vars (for CI/CD):**
   - Store sensitive data securely

## Manual Commands (If Not Using Script)

If you prefer to push manually:

```bash
# Navigate to project
cd /Users/ishtiaq/Documents/AITechReviews

# Add remote
git remote add origin https://github.com/yourusername/AITechReviews.git

# Rename branch if needed (main is standard)
git branch -M main

# Push to GitHub
git push -u origin main

# Verify
git remote -v
```

## Troubleshooting

### "Repository already exists"
The remote is already configured. Either:
- Use the existing remote (script will ask)
- Update it: `git remote set-url origin NEW_URL`

### "Authentication failed"
**For HTTPS:**
- Verify personal access token is correct
- Token may have expired (create new one)
- Check your GitHub username

**For SSH:**
```bash
# Test SSH connection
ssh -T git@github.com

# If that fails, check your SSH key
ls -la ~/.ssh/id_ed25519
ssh-add ~/.ssh/id_ed25519
```

### "Permission denied (publickey)"
Your SSH key isn't recognized:
```bash
# Generate new SSH key
ssh-keygen -t ed25519 -C "your_email@example.com"

# Add to agent
ssh-add ~/.ssh/id_ed25519

# Copy public key and add to GitHub Settings → SSH Keys
cat ~/.ssh/id_ed25519.pub
```

### "fatal: not a git repository"
You're not in the correct directory:
```bash
cd /Users/ishtiaq/Documents/AITechReviews
git status
```

### "Your branch and origin/main have diverged"
Your local and remote have conflicting changes:
```bash
# Check status
git log --oneline origin/main..main

# If remote is correct, reset to it
git reset --hard origin/main
```

## Best Practices

### Before First Push
- ✅ Review all changes: `git log --oneline -10`
- ✅ Check `.gitignore` excludes sensitive files
- ✅ Verify no credentials are in code
- ✅ Remove `public/` folder if not needed (regenerate during build)

### Sensitive Information
**Never commit:**
- API keys or tokens
- Database passwords
- Private configuration files
- Personal information

Use `.gitignore` to exclude these files.

### Repository Size
If your public folder is large:

1. Option 1: Don't commit `public/` folder (regenerate during deployment)
```bash
echo "public/" >> .gitignore
git rm -r --cached public/
```

2. Option 2: Use Git LFS for large files:
```bash
brew install git-lfs
git lfs install
git lfs track "*.jpg" "*.png"
git add .gitattributes
```

### Regular Updates
After initial push, commit and push regularly:

```bash
# After making changes
git add -A
git commit -m "Descriptive commit message"
git push
```

## Security Checklist

- ✅ GitHub account is secure (2FA enabled)
- ✅ SSH key or token is stored securely
- ✅ No sensitive data in repository
- ✅ `.gitignore` is properly configured
- ✅ Repository is set to Private (if needed)

## What Gets Pushed

The script pushes everything in your git repository:

**Included:**
- ✅ All content files (markdown articles)
- ✅ Layouts and templates
- ✅ Configuration files
- ✅ Scripts
- ✅ Static files (CSS, JS, images)
- ✅ Git commit history

**Excluded (by .gitignore):**
- ❌ `public/` folder (rebuilt during deploy)
- ❌ `node_modules/` (if present)
- ❌ `.DS_Store` files
- ❌ Environment-specific files

## Example Workflow

### When You're Ready to Push

```bash
# 1. Final checks
cd /Users/ishtiaq/Documents/AITechReviews
git status
git log --oneline -1

# 2. Make final commit (if needed)
git add -A
git commit -m "Final updates before GitHub publication"

# 3. Run push script
bash scripts/push-to-github.sh

# 4. Follow prompts and verify
# Script handles everything else!
```

### Ongoing Updates

```bash
# Make changes to content
nano content/buying-guides/electronics/new-article.md

# Commit changes
git add content/buying-guides/electronics/new-article.md
git commit -m "Add new article: Best Gaming Monitors 2026"

# Push to GitHub
git push
```

## Need Help?

### Git Documentation
```bash
git help push
git help remote
git help credentials
```

### GitHub Help
- [GitHub Documentation](https://docs.github.com)
- [Setting up Git](https://docs.github.com/en/get-started/quickstart/set-up-git)
- [Connecting over HTTPS](https://docs.github.com/en/get-started/getting-started-with-git/about-remote-repositories)
- [SSH Keys](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)

## Summary

1. **Create GitHub repository** at github.com/new
2. **Set up authentication** (HTTPS token or SSH key)
3. **Run script** when ready: `bash scripts/push-to-github.sh`
4. **Verify** your code is on GitHub
5. **Enjoy!** Your website code is now backed up and shareable

Your website will be available at:
```
https://github.com/yourusername/AITechReviews
```

And optionally hosted at:
```
https://yourusername.github.io/AITechReviews (via GitHub Pages)
```

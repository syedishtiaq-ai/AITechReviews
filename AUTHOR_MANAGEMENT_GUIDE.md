# Author Management Script

## Overview
The `manage-authors.sh` script provides an interactive way to manage authors on your website. It automates author creation and automatically updates article references.

## Quick Start

```bash
bash scripts/manage-authors.sh
```

## Features

### 1. Add New Author
Creates a new author profile with automatic:
- Unique author ID generation (format: `AU-AU-YYMMDD-###`)
- Markdown file creation with metadata
- Search for articles mentioning the author
- Auto-update article author fields

**Information Required:**
- Author name (e.g., "John Smith")
- Author role (e.g., "Senior Tech Writer")
- Author bio (multi-line text)
- Author image path (optional, e.g., `/images/authors/john-smith.jpg`)
- Twitter handle (optional)
- Website URL (optional)

**Example Flow:**
```
Select option: 1
👤 Author name: Sarah Johnson
📝 Author role/title: Gaming Reviews Editor
📄 Author bio: Experienced gaming journalist with 10+ years in the industry
🖼️ Author image path: /images/authors/sarah-johnson.jpg
🔗 Twitter handle: sarahjohnson
🌐 Website URL: https://sarahjohnson.com
```

**Result:**
- Creates: `content/authors/sarah-johnson.md`
- Generates ID: `AU-AU-260325-001`
- Updates all articles mentioning "Sarah Johnson"
- Adds `author: "Sarah Johnson"` field to relevant articles

### 2. List Authors
Displays all existing authors with:
- Author name
- Author role
- Author ID
- File location

### 3. Author File Structure

When an author is created, the following file is generated:

```markdown
---
article_id: "AU-AU-260325-001"
title: "Sarah Johnson"
slug: "sarah-johnson"
authorRole: "Gaming Reviews Editor"
authorBio: "Experienced gaming journalist with 10+ years in the industry"
authorImage: "/images/authors/sarah-johnson.jpg"
authorLinks:
  twitter: "sarahjohnson"
  website: "https://sarahjohnson.com"
---

Experienced gaming journalist with 10+ years in the industry
```

## Author ID Format

```
AU-AU-YYMMDD-###
│  │  │      └─ Sequence number (001, 002, etc.)
│  │  └─ Date created (YYMMDD)
│  └─ Author abbreviation
└─ Author section
```

Example: `AU-AU-260325-001`
- AU-AU: Author section
- 260325: March 25, 2026
- 001: First author created on that date

## Workflow: Adding an Author

### Step 1: Run the Script
```bash
bash scripts/manage-authors.sh
```

### Step 2: Select "Add new author" (Option 1)

### Step 3: Provide Author Information
Follow the prompts to enter:
- Name
- Role
- Bio
- Image path
- Social media links

### Step 4: Script Automatically
- ✅ Creates author markdown file
- ✅ Searches for articles mentioning the author
- ✅ Updates article author fields if needed
- ✅ Generates unique author ID

### Step 5: Verify and Commit
```bash
# Review the created author file
cat content/authors/sarah-johnson.md

# Check updated articles
grep -l "author:" content/**/*.md

# Build and test
hugo --cleanDestinationDir
hugo server

# Commit changes
git add content/authors/ content/**/*.md
git commit -m "Add author: Sarah Johnson"
```

## Auto-Update Article References

When you add an author, the script:

1. **Searches** all article files for the author's name
2. **Finds** articles that mention the author
3. **Updates** those articles by adding: `author: "Author Name"`
4. **Reports** how many articles were updated

Example:
```
ℹ️ Searching for articles that mention 'Sarah Johnson'...
✅ Updated article reference: gaming-console-review.md
✅ Found 1 articles mentioning this author
✅ Updated 1 article references
```

## Article Author Field

After an author is added, relevant articles get this field:

```yaml
---
title: "Article Title"
author: "Sarah Johnson"
category: "Gaming"
...
---
```

## Important Notes

- Author names are case-sensitive when searching articles
- The script will not overwrite existing author fields
- Author files are stored in `content/authors/`
- Author IDs follow the format: `AU-AU-YYMMDD-###`
- Each author gets a unique slug based on their name (e.g., "sarah-johnson")

## Example Use Cases

### Adding a New Guest Writer
```bash
bash scripts/manage-authors.sh
# Add: Guest Writer
# Role: Contributing Writer
# Bio: [Provide bio]
```

### Adding a Technical Editor
```bash
bash scripts/manage-authors.sh
# Add: Tech Editor Name
# Role: Senior Technical Editor
# Bio: [Provide bio]
```

### Adding an Freelancer
```bash
bash scripts/manage-authors.sh
# Add: Freelancer Name
# Role: Contributing Editor
# Bio: [Provide bio]
# Social: [Add Twitter/Website]
```

## Troubleshooting

**Script doesn't find articles mentioning the author:**
- Manually update articles: Add `author: "Author Name"` to YAML front matter
- Re-run `hugo --cleanDestinationDir` to rebuild site

**Author file not created:**
- Check that `content/authors/` directory exists
- Ensure write permissions to the directory

**Author ID errors:**
- Delete the partially created author file
- Re-run the script and try again

## Next Steps

1. Run the script: `bash scripts/manage-authors.sh`
2. Select option 1 to add a new author
3. Provide the required information
4. Review the created author file
5. Check updated articles for author field
6. Build and test: `hugo --cleanDestinationDir && hugo server`
7. Commit changes to git

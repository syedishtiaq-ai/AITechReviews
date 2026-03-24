# Script Update: Subcategory Folder Structure

## Summary
All three article management scripts have been updated to work with articles organized in subcategory folders rather than at the section root level.

## Changes Made

### 1. Folder Structure
Articles are now organized as:
```
content/
  buying-guides/
    electronics/
      article1.md
      article2.md
    home-appliances/
      article3.md
  gaming/
    achievements/
    guides/
    walkthroughs/
  tutorials-guides/
    equipment/
      building-home-media-server.md
    repair-guides/
      best-laptop-repair-tips.md
    software/
```

### 2. Updated Scripts

#### `create-article-flat.sh`
- **Change**: Now creates articles in subcategory folders
- **Feature**: Automatically creates subcategory folders if they don't exist
- **Example**: Creates `content/tutorials-guides/equipment/article.md` instead of `content/tutorials-guides/article.md`
- **Function Added**: `get_subcategory_slug()` - converts subcategory names to folder slugs

#### `add-articles-flat.sh`
- **Change**: Creates files in subcategory folders
- **Feature**: Requires subcategory input (will skip articles without subcategory)
- **Auto-create**: Creates subcategory folders automatically
- **Function Added**: `get_subcategory_slug()` - same as above

#### `assign-article-ids-flat.sh`
- **Change**: Searches for articles in subcategory folders
- **Processing**: Iterates through section → subcategory → articles
- **Mapping**: Converts folder slugs back to subcategory names for ID generation
- **Function Added**: `get_subcategory_from_slug()` - maps "equipment" → "Equipment", "repair-guides" → "Repair Guides", etc.

### 3. Article ID Format
The article ID format remains the same:
```
{SECTION}-{SUBCATEGORY}-{DATE}-{SEQUENCE}
Example: TG-EQ-260324-001
  TG = tutorials-guides section
  EQ = Equipment subcategory  
  260324 = March 24, 2026
  001 = First article for this combination
```

## Subcategory Mappings

### Buying Guides (BG)
- Electronics (EL)
- Home Appliances (HA)
- Mobile Gadgets (MG)

### Gaming (GM)
- Achievements (AC)
- Guides (GD)
- Walkthroughs (WK)

### Tutorials & Guides (TG)
- Equipment (EQ)
- Repair Guides (RG)
- Software (SW)

## Testing Results

✅ **create-article-flat.sh**
- Creates files in correct subcategory folders
- Generates proper article IDs
- Auto-creates folders as needed

✅ **add-articles-flat.sh**
- Creates multiple articles in subcategory folders
- Requires subcategory input
- Properly organizes files

✅ **assign-article-ids-flat.sh**
- Finds articles in all subcategory folders
- Assigns proper IDs with correct format
- Processed 30 articles successfully

## Files Moved
- `content/tutorials-guides/building-home-media-server.md` → `content/tutorials-guides/equipment/building-home-media-server.md`
- `content/tutorials-guides/best-laptop-repair-tips.md` → `content/tutorials-guides/repair-guides/best-laptop-repair-tips.md`

## Git Commits
1. "Update scripts to use subcategory folder structure"
2. "Move articles to correct subcategory folders"

## Usage Example

### Creating a new article:
```bash
./scripts/create-article-flat.sh
# Select: buying-guides → Electronics
# Follows prompts and creates:
# content/buying-guides/electronics/article-name.md
```

### Adding multiple articles:
```bash
./scripts/add-articles-flat.sh
# Select: tutorials-guides
# Enter: 1 article
# Subcategory: Equipment
# Creates: content/tutorials-guides/equipment/article.md
```

### Assigning IDs:
```bash
./scripts/assign-article-ids-flat.sh
# Automatically finds all articles in subcategory folders
# Assigns IDs in format: TG-EQ-260324-001
```

## Notes
- All scripts maintain backward compatibility with existing .gitignore
- Subcategory folders are auto-created when needed
- Article IDs are based on file date and subcategory
- Folder naming uses kebab-case (repair-guides, not Repair Guides)

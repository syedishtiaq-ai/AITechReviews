# Phase 1B: Create Master Category List

**Status**: ACTIVE - Complete this phase now  
**Estimated Time**: 15 minutes  
**Deliverable**: Category mapping document

---

## 🎯 Objective

Map all your current legacy categories to the new 6-category system.

---

## 📋 Current Categories (From Your Posts.json Files)

### Gaming Categories
```
AC Rogue Guide
AC Origins Guide
AC Odyssey Guide
(and other gaming-related categories)
```

### Electronics/Accessories Categories
```
Accessories
Camera-photo
Consoles
Desktop-Computers
Home Audio
Laptops
Power Banks
TVs
Home Appliances
```

---

## 🆕 New Approved Categories (6 Total)

```
1. GAMING
   └─ For game guides, reviews, walkthroughs, achievements

2. ELECTRONICS
   └─ For tech reviews, gadgets, accessories, audio equipment

3. SOFTWARE
   └─ For software reviews, tools, tutorials

4. MOBILE
   └─ For phone reviews, mobile apps

5. HOME APPLIANCES
   └─ For appliance reviews and buying guides

6. TUTORIALS & GUIDES
   └─ For how-to articles, software tutorials, repair guides
```

---

## 🔀 Category Mapping

### Mapping Exercise: Your Categories → New Categories

**YOUR LEGACY CATEGORIES** → **NEW CATEGORIES**

| Legacy Category | New Category | Notes |
|---|---|---|
| AC Rogue Guide | GAMING | Gaming guides |
| AC Origins Guide | GAMING | Gaming guides |
| AC Odyssey Guide | GAMING | Gaming guides |
| Accessories | ELECTRONICS | Phone accessories, headphones, tech accessories |
| Camera-photo | ELECTRONICS | Photography equipment |
| Consoles | ELECTRONICS | Gaming consoles |
| Desktop-Computers | ELECTRONICS | Computer hardware |
| Home Audio | ELECTRONICS | Audio equipment |
| Laptops | ELECTRONICS | Computing devices |
| Power Banks | ELECTRONICS | Tech accessories |
| TVs | ELECTRONICS | Home entertainment |
| Refrigerators | HOME APPLIANCES | Kitchen appliances |
| Washing Machines | HOME APPLIANCES | Home appliances |

---

## ✅ Your Approved Category Mapping

Based on your content, here's the final mapping:

```
GAMING (6 sub-sections currently)
  ├─ Guides
  ├─ Walkthroughs
  ├─ Game Reviews
  ├─ Game Achievements
  ├─ All
  └─ Multiple sub-posts.json files
  
ELECTRONICS (8 main items + sub-categories)
  ├─ Accessories (4 items)
  ├─ Camera & Photo
  ├─ Consoles
  ├─ Desktop Computers
  ├─ Home Audio
  ├─ Laptops
  ├─ Power Banks
  └─ TVs
  
HOME APPLIANCES (2+ items)
  ├─ Refrigerators
  └─ Washing Machines
```

---

## 📧 Author Assignment

For each category, articles will be assigned to:

```
GAMING → Author: "Gaming Guide"
ELECTRONICS → Author: "Tech Reviewer"
HOME APPLIANCES → Author: "Home Expert"
TUTORIALS & GUIDES → Author: "Tech Tutor"
SOFTWARE → Author: "Software Expert"
MOBILE → Author: "Mobile Specialist"
```

---

## 🎯 Decision Points

### Question 1: Should we keep the sub-categories (guides, walkthroughs, reviews)?
**Answer**: No, flatten them. All will be articles tagged with their type.

**New Structure**:
- Instead of: `/gaming/guides/ac-rogue-guide/`
- Use: `/articles/gaming/ac-rogue-resources-farming-guide/` (tagged as "Guide")

### Question 2: How will we organize by game series?
**Answer**: Use tags and article series feature.

**Example**:
- **Series**: "Assassin's Creed Guides"
- **Series Order**: 1, 2, 3... for AC Rogue, AC Origins, AC Odyssey

### Question 3: What about sub-categories like "Accessories"?
**Answer**: Use tags.

**Example**:
- **Category**: Electronics
- **Tags**: ["Accessories", "Headphones", "Wireless", "Audio"]

---

## 📝 Phase 1B Checklist

- [x] Review current categories
- [x] Understand new 6-category system
- [x] See mapping (Legacy → New)
- [ ] **CONFIRM**: Does this mapping work for you?
- [ ] Any changes needed?

---

## ⚠️ Important Decisions

### Decision 1: Sub-category Flattening
**Current**: `/gaming/guides/` sub-folder with posts  
**New**: All under `/articles/gaming/` with "Guide" tag

**Impact**: Cleaner URLs, easier to manage, tags provide filtering

**Confirm**: ✅ OK to proceed? (Y/N)

### Decision 2: Multi-part Series Organization
**Current**: Multiple items for same game with different topics  
**New**: Each gets own article, linked via "series" feature and tags

**Impact**: Better SEO, easier to find specific articles, cross-linking

**Confirm**: ✅ OK to proceed? (Y/N)

### Decision 3: Author Assignment
**Current**: No author attribution  
**New**: Each article gets author name (Gaming Guide, Tech Reviewer, etc.)

**Impact**: Professional credibility, consistent voice, easier future updates

**Confirm**: ✅ OK to proceed? (Y/N)

---

## 🚀 Next Step

Once you confirm the above decisions:
1. **Phase 1C**: Define detailed author profiles
2. **Phase 1D**: Create conversion script
3. **Phase 1E**: Run test migration

---

## 📋 Your Approval Required

Please confirm:

1. **Category Mapping** - Does the Legacy → New mapping look good?
2. **Author Assignments** - Are the 4-6 authors acceptable?
3. **Series Organization** - Is using tags + series feature OK?
4. **Date Handling** - Keep publish dates as-is?

---

**Status**: Awaiting your confirmation to proceed to Phase 1C

Reply with:**
- ✅ All looks good, proceed to Phase 1C
- Or specify any changes needed


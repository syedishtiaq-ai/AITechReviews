# Phase 1C: Define Author Profiles

**Status**: ACTIVE - Define profiles now  
**Estimated Time**: 20 minutes  
**Deliverable**: Author configuration system

---

## 🎯 Objective

Create detailed author profiles for each category. These will be assigned to articles during migration, providing professional attribution and consistent voice.

---

## 👥 Author Profiles (6 Total)

### 1. 🎮 Gaming Guide

**Slug**: `gaming-guide`  
**Display Name**: Gaming Guide  
**Categories**: Gaming  
**Primary Focus**: Video game guides, walkthroughs, achievements, game reviews

**Bio**:
> Expert in gaming guides, walkthroughs, and gaming tips. Specializes in detailed game strategies and achievement farming guides.

**Specialization**:
- Game walkthroughs
- Achievement guides
- Resource farming guides
- Game reviews
- Gaming tips & tricks

**Tags This Author Covers**:
- Assassin's Creed Series
- Gaming Guides
- Walkthroughs
- Achievements
- RPG Games

**Default Assignment**: Any article with category="Gaming"

---

### 2. 🔧 Tech Reviewer

**Slug**: `tech-reviewer`  
**Display Name**: Tech Reviewer  
**Categories**: Electronics, Tutorials & Guides (technical)  
**Primary Focus**: Tech gadgets, electronics reviews, accessories, audio equipment

**Bio**:
> Professional technology reviewer with expertise in electronics, gadgets, and consumer tech. Provides in-depth reviews and buying guides for tech products.

**Specialization**:
- Electronics reviews
- Gadget comparisons
- Tech accessories
- Audio equipment reviews
- Laptop & desktop reviews
- Camera equipment

**Tags This Author Covers**:
- Electronics
- Tech Reviews
- Gadgets
- Audio Equipment
- Accessories
- Laptops
- Computers

**Default Assignment**: Any article with category="Electronics"

---

### 3. 🏠 Home Expert

**Slug**: `home-expert`  
**Display Name**: Home Expert  
**Categories**: Home Appliances  
**Primary Focus**: Home appliances, buying guides, appliance reviews

**Bio**:
> Home appliance specialist with expertise in selecting and reviewing household electronics. Provides comprehensive buying guides and product comparisons for modern homes.

**Specialization**:
- Appliance reviews
- Buying guides for home equipment
- Refrigerator comparisons
- Washing machine guides
- Home comfort equipment
- Energy efficiency guides

**Tags This Author Covers**:
- Home Appliances
- Kitchen Equipment
- Laundry Appliances
- Buying Guide
- Product Reviews

**Default Assignment**: Any article with category="Home Appliances"

---

### 4. 📚 Tech Tutor

**Slug**: `tech-tutor`  
**Display Name**: Tech Tutor  
**Categories**: Tutorials & Guides, Software  
**Primary Focus**: How-to guides, software tutorials, repair guides, learning resources

**Bio**:
> Technology educator and tutorial specialist. Creates comprehensive guides for software, DIY repairs, and tech learning resources.

**Specialization**:
- Software tutorials
- How-to guides
- Repair guides
- Video editing tutorials
- Software comparisons
- Technology education

**Tags This Author Covers**:
- Tutorials
- How-To
- Software Guides
- Repair Guides
- Learning
- Video Editing

**Default Assignment**: Any article with category="Tutorials & Guides" or category="Software"

---

### 5. 💻 Software Expert

**Slug**: `software-expert`  
**Display Name**: Software Expert  
**Categories**: Software  
**Primary Focus**: Software reviews, app comparisons, digital tools

**Bio**:
> Software developer and technology analyst. Reviews and compares software applications, productivity tools, and digital solutions.

**Specialization**:
- Software reviews
- App comparisons
- Productivity tools
- Development software
- Digital services
- Software recommendations

**Tags This Author Covers**:
- Software
- Applications
- Tools
- Digital Services
- Productivity

**Default Assignment**: Any article with category="Software"

---

### 6. 📱 Mobile Specialist

**Slug**: `mobile-specialist`  
**Display Name**: Mobile Specialist  
**Categories**: Mobile  
**Primary Focus**: Mobile phone reviews, app guides, mobile technology

**Bio**:
> Mobile technology expert specializing in smartphones, applications, and mobile devices. Provides detailed reviews and guides for mobile users.

**Specialization**:
- Phone reviews
- Mobile app guides
- Mobile accessory reviews
- Mobile OS comparisons
- Mobile phone buying guides
- Mobile photography

**Tags This Author Covers**:
- Mobile Phones
- Apps
- Mobile Devices
- Smartphones
- Mobile Technology

**Default Assignment**: Any article with category="Mobile"

---

## 📋 Author Assignment Rules

### Rule 1: Primary Category Assignment
Each article gets ONE primary author based on its category:

```
Article Category → Default Author

Gaming → Gaming Guide
Electronics → Tech Reviewer
Home Appliances → Home Expert
Software → Software Expert OR Tech Tutor
Tutorials & Guides → Tech Tutor
Mobile → Mobile Specialist
```

### Rule 2: Author Override (Optional)
For specific articles, you can override the default author if needed (leave blank for now, can be added later).

### Rule 3: Multi-authored Articles (Future)
If an article has multiple authors, use comma-separated names:
```json
"author": "Tech Reviewer, Home Expert"
```

---

## 📊 Author Configuration (JSON Format)

This is how authors will be stored in your system:

```json
{
  "authors": [
    {
      "slug": "gaming-guide",
      "name": "Gaming Guide",
      "bio": "Expert in gaming guides, walkthroughs, and gaming tips...",
      "categories": ["Gaming"],
      "specialties": ["Walkthroughs", "Achievements", "Game Reviews"],
      "avatar": "images/authors/gaming-guide.svg"
    },
    {
      "slug": "tech-reviewer",
      "name": "Tech Reviewer",
      "bio": "Professional technology reviewer with expertise in electronics...",
      "categories": ["Electronics"],
      "specialties": ["Tech Reviews", "Gadgets", "Audio Equipment"],
      "avatar": "images/authors/tech-reviewer.svg"
    },
    {
      "slug": "home-expert",
      "name": "Home Expert",
      "bio": "Home appliance specialist with expertise in selecting...",
      "categories": ["Home Appliances"],
      "specialties": ["Appliance Reviews", "Buying Guides"],
      "avatar": "images/authors/home-expert.svg"
    },
    {
      "slug": "tech-tutor",
      "name": "Tech Tutor",
      "bio": "Technology educator and tutorial specialist...",
      "categories": ["Tutorials & Guides", "Software"],
      "specialties": ["How-to Guides", "Software Tutorials", "Repair Guides"],
      "avatar": "images/authors/tech-tutor.svg"
    },
    {
      "slug": "software-expert",
      "name": "Software Expert",
      "bio": "Software developer and technology analyst...",
      "categories": ["Software"],
      "specialties": ["Software Reviews", "App Comparisons"],
      "avatar": "images/authors/software-expert.svg"
    },
    {
      "slug": "mobile-specialist",
      "name": "Mobile Specialist",
      "bio": "Mobile technology expert specializing in smartphones...",
      "categories": ["Mobile"],
      "specialties": ["Phone Reviews", "Mobile Apps"],
      "avatar": "images/authors/mobile-specialist.svg"
    }
  ]
}
```

---

## 🎯 Avatar Placeholders

For now, use these placeholder paths:

```
images/authors/gaming-guide.svg
images/authors/tech-reviewer.svg
images/authors/home-expert.svg
images/authors/tech-tutor.svg
images/authors/software-expert.svg
images/authors/mobile-specialist.svg
```

(You can replace with actual images later)

---

## ✅ Phase 1C Checklist

- [x] Reviewed 6 author profiles
- [x] Understood author assignment rules
- [x] Saw JSON configuration format
- [ ] **CONFIRM**: Are all 6 authors acceptable?
- [ ] Any changes to author names, bios, or specialties?
- [ ] Ready to proceed to Phase 1D?

---

## 🎯 Decision Points

### Decision 1: Author Names
**Current**: Gaming Guide, Tech Reviewer, Home Expert, Tech Tutor, Software Expert, Mobile Specialist

**Alternatives**: (You can suggest different names if preferred)

**Confirm**: ✅ These names work?

### Decision 2: Author Bios
**Current**: Generic but descriptive bios for each author

**Confirm**: ✅ Should we customize these bios further?

### Decision 3: Default Avatar Path
**Current**: `images/authors/{slug}.svg`

**Confirm**: ✅ OK to use this path structure?

---

## 📝 Author Assignment During Migration

During Phase 1D, the conversion script will automatically assign:

```javascript
// Example: Article about AC Rogue guide
{
  "title": "Assassin's Creed Rogue: Resources Farming Guide",
  "category": "Gaming",
  "author": "Gaming Guide"  // ← Auto-assigned
}

// Example: Article about wireless headphones
{
  "title": "Best Wireless Headphones 2026",
  "category": "Electronics", 
  "author": "Tech Reviewer"  // ← Auto-assigned
}
```

---

## 🏁 Ready for Phase 1D?

Once you confirm all decisions, we proceed to:

**Phase 1D: Run Test Migration**
- Create conversion script
- Test on 5-10 sample articles
- Validate the conversion
- Show you the results

---

## 📋 Your Approval Required

Please confirm:

1. **6 author profiles** - All acceptable?
2. **Assignment rules** - Auto-assign by category? 
3. **Avatar paths** - Use `images/authors/{slug}.svg`?
4. **Ready for Phase 1D** - Proceed with test migration?

---

**Status**: Awaiting confirmation to proceed to Phase 1D

Reply with:**
- ✅ "All looks good, proceed to Phase 1D"
- Or specify any author changes needed


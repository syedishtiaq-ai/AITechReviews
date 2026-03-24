# Article ID System - Visual Guide

## How the ID System Works

```
ARTICLE ID = Category Code + Date + Sequence Number

┌─────────────────────────────────────────────────────────┐
│                 Article ID Example                      │
│            BG-EL-260316-001                            │
│            ││ ││  │ │ │  │││                           │
│            ││ ││  │ │ │  └─┴─┴─ Sequential Number      │
│            ││ ││  │ └─└────────── Year: 26 (2026)      │
│            ││ ││  └──────────────── Month: 03 (March)  │
│            ││ └─┴─ Subcategory: EL (Electronics)       │
│            └┴─ Main Category: BG (Buying Guides)       │
└─────────────────────────────────────────────────────────┘
```

---

## Category Matrix

```
                  BUYING GUIDES       GAMING          TUTORIALS
                  ─────────────       ──────          ─────────
                  
Electronics       BG-EL              (none)           (none)
Achievements      (none)             GM-AC            (none)
Repair Guides     (none)             (none)           TG-RG

Home Appliances   BG-HA              (none)           (none)
Guides            (none)             GM-GD            (none)
Software          (none)             (none)           TG-SW

Mobile Gadgets    BG-MG              (none)           (none)
Walkthroughs      (none)             GM-WK            (none)
Equipment         (none)             (none)           TG-EQ


TOTALS:           3 codes            3 codes          3 codes
                  = 9 Total Possible Code Combinations
```

---

## ID Generation Process

```
                        New Article Created
                               │
                               ▼
                    ┌───────────────────────┐
                    │  Get Article Details  │
                    │  - Filename           │
                    │  - Category Path      │
                    │  - Publication Date   │
                    └───────────┬───────────┘
                                │
                    ┌───────────▼───────────┐
                    │ Step 1: Get Category  │
                    │ Code                  │
                    │                       │
                    │ "buying-guides" +     │
                    │ "electronics"         │
                    │ = "BG-EL"            │
                    └───────────┬───────────┘
                                │
                    ┌───────────▼───────────┐
                    │ Step 2: Format Date   │
                    │                       │
                    │ "2026-03-16"          │
                    │ = "260316"           │
                    │ (YYMMDD format)      │
                    └───────────┬───────────┘
                                │
                    ┌───────────▼───────────┐
                    │ Step 3: Get Next #    │
                    │                       │
                    │ Find last BG-EL       │
                    │ article on 260316:    │
                    │ "BG-EL-260316-001"    │
                    │ Next = 002           │
                    └───────────┬───────────┘
                                │
                    ┌───────────▼───────────┐
                    │ Generate Final ID     │
                    │                       │
                    │ BG + "-" + EL + "-" + │
                    │ 260316 + "-" + 002   │
                    │                       │
                    │ = BG-EL-260316-002   │
                    └───────────┬───────────┘
                                │
                                ▼
                        ✅ ID Added to Article
                        (First field in YAML)
```

---

## Complete Category Code Matrix

```
╔════════════════════════════════════════════════════════════════╗
║                   FIRST CODE PAIR (Main)                       ║
╠════════════════════════════════════════════════════════════════╣
║ BG = Buying Guides                                             ║
║ GM = Gaming                                                    ║
║ TG = Tutorials & Guides                                        ║
╠════════════════════════════════════════════════════════════════╣
║            SECOND CODE PAIR (Subcategory)                      ║
╠════════════════════════════════════════════════════════════════╣
║                                                                ║
║ BUYING GUIDES (BG-)           L GAMING (GM-)    TUTORIALS (TG-)║
║ ┌──────────────────┐         ┌──────────────┐   ┌────────────┐║
║ │ EL Electronics   │         │ AC Achievements│  │ EQ Equipment││
║ │ HA Home Appl.    │         │ GD Guides    │   │ RG Repairs  ││
║ │ MG Mobile Gadgets│         │ WK Walkthroughs│  │ SW Software ││
║ └──────────────────┘         └──────────────┘   └────────────┘║
║                                                                ║
╚════════════════════════════════════════════════════════════════╝
```

---

## Real Examples with Breakdown

```
Example 1: Article created March 16, 2026
┌────────────────────────────────────────┐
│ Category: Buying Guides → Electronics  │
│ Date: 2026-03-16                       │
│ This is the 1st article that day       │
│                                        │
│           BG-EL-260316-001            │
│           ││ ││  │ │ │ │││            │
│           Buying Guides                │
│              Electronics                │
│                   Yr│Month│Day         │
│                      Mar 16, 2026      │
│                        1st Article     │
└────────────────────────────────────────┘

Example 2: Article created February 20, 2026
┌────────────────────────────────────────┐
│ Category: Buying Guides → Mobile       │
│ Date: 2026-02-20                       │
│ This is the 1st article that day       │
│                                        │
│           BG-MG-260220-001            │
│           ││ ││  │ │ │ │││            │
│           Buying Guides                │
│              Mobile Gadgets             │
│                   Yr│Month│Day         │
│                      Feb 20, 2026      │
│                        1st Article     │
└────────────────────────────────────────┘

Example 3: Article created March 15, 2026
┌────────────────────────────────────────┐
│ Category: Gaming → Achievements        │
│ Date: 2026-03-15                       │
│ This is the 1st article that day       │
│                                        │
│           GM-AC-260315-001            │
│           ││ ││  │ │ │ │││            │
│           Gaming                       │
│              Achievements               │
│                   Yr│Month│Day         │
│                      Mar 15, 2026      │
│                        1st Article     │
└────────────────────────────────────────┘
```

---

## Date Format Visualization

```
               YYMMDD
                │││││└─ Day (01-31)
                ││││└─── Month (01-12)
                │││└───── Year (00-99, 2000-2099)
                    
Example Conversions:
┌──────────────────────────────────┐
│ 2026-03-16  →  260316           │
│ 2026-02-20  →  260220           │
│ 2024-12-25  →  241225           │
│ 2025-01-01  →  250101           │
└──────────────────────────────────┘
```

---

## Current Database Structure

```
📂 AITechReviews/
├── 📂 content/
│   ├── 📂 buying-guides/
│   │   ├── 📂 electronics/           [BG-EL-YYMMDD-###]
│   │   │   ├── 📄 best-laptops.md    ✅ BG-EL-260316-001
│   │   │   └── 📄 wireless-headphones.md ✅ BG-EL-260318-001
│   │   ├── 📂 home-appliances/       [BG-HA-YYMMDD-###]
│   │   │   ├── 📄 best-refrigerators.md ✅ BG-HA-260317-001
│   │   │   └── 📄 best-washing-machines.md ✅ BG-HA-260314-001
│   │   └── 📂 mobile-gadgets/        [BG-MG-YYMMDD-###]
│   │       ├── 📄 smartphone-review-1.md ✅ BG-MG-260220-001
│   │       ├── 📄 smartphone-review-2.md ✅ BG-MG-260222-001
│   │       └── 📄 tablet-review-1.md ✅ BG-MG-260224-001
│   │
│   ├── 📂 gaming/
│   │   ├── 📂 achievements/          [GM-AC-YYMMDD-###]
│   │   │   ├── 📄 bg3-trophies.md    ✅ GM-AC-260310-001
│   │   │   ├── 📄 elden-ring-achievements.md ✅ GM-AC-260315-001
│   │   │   ├── 📄 hidden-achievements-guide.md ✅ GM-AC-260318-001
│   │   │   └── 📄 master-level-achievements.md ✅ GM-AC-260320-001
│   │   ├── 📂 guides/                [GM-GD-YYMMDD-###]
│   │   │   ├── 📄 advanced-gaming-tactics.md ✅ GM-GD-260317-001
│   │   │   └── 📄 beginners-guide-to-gaming.md ✅ GM-GD-260319-001
│   │   └── 📂 walkthroughs/          [GM-WK-YYMMDD-###]
│   │       ├── 📄 dungeon-crawler-speedrun-guide.md ✅ GM-WK-260315-001
│   │       └── 📄 adventure-quest-complete-walkthrough.md ✅ GM-WK-260316-001
│   │
│   └── 📂 tutorials-guides/
│       ├── 📂 equipment/             [TG-EQ-YYMMDD-###]
│       │   └── 📄 equipment-setup-guide.md ✅ TG-EQ-260217-001
│       ├── 📂 repair-guides/         [TG-RG-YYMMDD-###]
│       │   ├── 📄 laptop-repair-guide.md ✅ TG-RG-260319-001
│       │   ├── 📄 laptop-screen-repair.md ✅ TG-RG-260223-001
│       │   ├── 📄 phone-battery-replacement.md ✅ TG-RG-260222-001
│       │   ├── 📄 gaming-console-repair.md ✅ TG-RG-260318-001
│       │   └── 📄 smartphone-repair-guide.md ✅ TG-RG-260320-001
│       └── 📂 software/              [TG-SW-YYMMDD-###]
│           ├── 📄 windows-optimization.md ✅ TG-SW-260219-001
│           ├── 📄 macos-optimization.md ✅ TG-SW-260220-001
│           ├── 📄 productivity-software-1.md ✅ TG-SW-260221-001
│           ├── 📄 linux-commands.md ✅ TG-SW-260221-002
│           ├── 📄 development-tools-1.md ✅ TG-SW-260223-001
│           └── 📄 design-software-1.md ✅ TG-SW-260225-001
│
└── ✅ 26 Articles with Unique IDs
```

---

## ID Lifecycle

```
Article Creation → ID Generation → YAML Injection → Storage
      │                 │               │              │
      └──────────────────┬───────────────┴──────────────┘
                         │
                    [Permanent ID]
                    Never changes
                    Never duplicates
                         │
                         ▼
    References | Analytics | Lookup | Archive
```

---

## Search Patterns

```
Find by exact ID:
  grep "article_id: \"BG-EL-260316-001\"" content/**/*.md
  
Find by category:
  grep "article_id: \"BG-" content/buying-guides/**/*.md
  
Find by subcategory:
  grep "article_id: \".*-EL-" content/**/*.md
  
Find by date:
  grep "article_id: \".*-260316-" content/**/*.md
  
Find by sequence:
  grep "article_id: \".*-001$" content/**/*.md
```

---

## Benefits at a Glance

```
┌──────────────────────────────────────────────────────────┐
│                     BENEFITS                             │
├──────────────────────────────────────────────────────────┤
│ 📌 Permanent   - Never changes or duplicates             │
│ 🎯 Unique      - Each article has exactly one ID         │
│ 📖 Readable    - Humans understand what it means         │
│ 📅 Dated       - When article was created is embedded    │
│ 🏷️  Categorized - Category is part of the ID             │
│ 🔍 Searchable  - Easy to find articles by ID             │
│ 🤖 Automated   - Scripts generate IDs automatically     │
│ 🔄 Scalable    - Handles 999 articles per category/day   │
│ 📊 Traceable   - Can track by category, date, sequence  │
│ 🔗 Referenceable - Citations use ID instead of filename │
└──────────────────────────────────────────────────────────┘
```

---

**🎨 Visual Understanding:** The ID is a story told in codes and dates. Category codes identify what it is, subcategory codes specify where it belongs, the date shows when it was born, and the number counts how many siblings it has that same day.**

For detailed documentation, see:
- `ARTICLE_ID_SYSTEM.md` - Complete reference
- `ARTICLE_ID_QUICK_REFERENCE.md` - Lookup guide

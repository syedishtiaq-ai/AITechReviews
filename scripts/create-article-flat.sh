#!/bin/bash

################################################################################
# AITechReviews - Article Creator (Subcategory Structure)
# Creates new articles in subcategory folders
# Usage: ./scripts/create-article-flat.sh
################################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Project paths
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONTENT_DIR="$PROJECT_ROOT/content"

# Category and subcategory mappings for article IDs
# Using functions instead of associative arrays for zsh/bash compatibility

# Convert subcategory name to folder slug
# E.g., "Electronics" -> "electronics", "Repair Guides" -> "repair-guides"
get_subcategory_slug() {
    echo "$1" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/-+/-/g' | sed 's/^-\|-$//'
}

get_category_code() {
    case "$1" in
        "buying-guides") echo "BG" ;;
        "gaming") echo "GM" ;;
        "tutorials-guides") echo "TG" ;;
        *) echo "" ;;
    esac
}

# Get valid subcategories for a specific section
get_valid_subcategories() {
    local section="$1"
    case "$section" in
        "buying-guides")
            echo "Electronics"
            echo "Home Appliances"
            echo "Mobile Gadgets"
            ;;
        "gaming")
            echo "Achievements"
            echo "Guides"
            echo "Walkthroughs"
            ;;
        "tutorials-guides")
            echo "Equipment"
            echo "Repair Guides"
            echo "Software"
            ;;
        *)
            echo ""
            ;;
    esac
}

# Check if subcategory is valid for section
is_valid_subcategory() {
    local section="$1"
    local subcategory="$2"
    
    case "$section" in
        "buying-guides")
            [[ "$subcategory" =~ ^(Electronics|Home Appliances|Mobile Gadgets)$ ]] && return 0
            ;;
        "gaming")
            [[ "$subcategory" =~ ^(Achievements|Guides|Walkthroughs)$ ]] && return 0
            ;;
        "tutorials-guides")
            [[ "$subcategory" =~ ^(Equipment|Repair Guides|Software)$ ]] && return 0
            ;;
    esac
    return 1
}

get_subcategory_code() {
    case "$1" in
        "Electronics") echo "EL" ;;
        "Home Appliances") echo "HA" ;;
        "Mobile Gadgets") echo "MG" ;;
        "Achievements") echo "AC" ;;
        "Guides") echo "GD" ;;
        "Walkthroughs") echo "WK" ;;
        "Equipment") echo "EQ" ;;
        "Repair Guides") echo "RG" ;;
        "Software") echo "SW" ;;
        *) echo "" ;;
    esac
}

################################################################################
# Helper Functions
################################################################################

print_header() {
    echo -e "\n${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}\n"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Slugify function
slugify() {
    echo "$1" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/-+/-/g' | sed 's/^-\|-$//'
}

# Check if directory exists
check_path() {
    if [ ! -d "$1" ]; then
        return 1
    fi
    return 0
}

# List available categories
list_categories() {
    local count=1
    for category in $(ls -d "$CONTENT_DIR"/*/ 2>/dev/null | xargs -n1 basename | grep -v archives | sort); do
        echo "  $count) $category"
        ((count++))
    done
}

# Generate next article ID
get_next_article_id() {
    local cat_code="$1"
    local subcat_code="$2"
    local date_part="$3"
    local content_path="$4"
    
    local counter=1
    # Find highest existing number for this date/category/subcategory
    for file in "$content_path"/*.md; do
        if [ -f "$file" ]; then
            local existing_id=$(grep -m1 "^article_id:" "$file" 2>/dev/null | sed "s/.*$cat_code-$subcat_code-$date_part-0*\([0-9]*\).*/\1/")
            if [ ! -z "$existing_id" ] && [[ $existing_id =~ ^[0-9]+$ ]]; then
                if [ $existing_id -ge $counter ]; then
                    counter=$((existing_id + 1))
                fi
            fi
        fi
    done
    
    # Format as 3-digit number
    local seq=$(printf "%03d" "$counter")
    echo "$cat_code-$subcat_code-$date_part-$seq"
}

################################################################################
# Main Script
################################################################################

print_header "AITechReviews - Article Creator (Flat Structure)"

# Validate content directory
if ! check_path "$CONTENT_DIR"; then
    print_error "Content directory not found: $CONTENT_DIR"
    exit 1
fi

# Select category
echo "Available categories:"
echo ""
list_categories
echo ""

read -p "📁 Select category (by number or name): " CATEGORY_INPUT

if [ -z "$CATEGORY_INPUT" ]; then
    print_error "Category required"
    exit 1
fi

# Convert number to category name if needed
if [[ "$CATEGORY_INPUT" =~ ^[0-9]+$ ]]; then
    CATEGORY=$(ls -d "$CONTENT_DIR"/*/ 2>/dev/null | grep -v archives | sed -n "${CATEGORY_INPUT}p" | xargs -n1 basename)
    if [ -z "$CATEGORY" ]; then
        print_error "Invalid category number"
        exit 1
    fi
else
    CATEGORY="$CATEGORY_INPUT"
fi

if [ ! -d "$CONTENT_DIR/$CATEGORY" ]; then
    print_error "Category not found: $CATEGORY"
    exit 1
fi

print_success "Selected category: $CATEGORY"
echo ""

# Select subcategory - show only valid ones for selected category
echo "Available subcategories for $CATEGORY:"
echo ""

# Build list based on category
case "$CATEGORY" in
    "buying-guides")
        echo "  1) Electronics"
        echo "  2) Home Appliances"
        echo "  3) Mobile Gadgets"
        valid_count=3
        ;;
    "gaming")
        echo "  1) Achievements"
        echo "  2) Guides"
        echo "  3) Walkthroughs"
        valid_count=3
        ;;
    "tutorials-guides")
        echo "  1) Equipment"
        echo "  2) Repair Guides"
        echo "  3) Software"
        valid_count=3
        ;;
    *)
        print_error "No subcategories available for: $CATEGORY"
        exit 1
        ;;
esac
echo ""

read -p "📂 Select subcategory: " SUBCAT_INPUT

# Map selection to subcategory based on category
case "$CATEGORY" in
    "buying-guides")
        case "$SUBCAT_INPUT" in
            1) SUBCATEGORY="Electronics" ;;
            2) SUBCATEGORY="Home Appliances" ;;
            3) SUBCATEGORY="Mobile Gadgets" ;;
            *)
                print_error "Invalid subcategory selection"
                exit 1
                ;;
        esac
        ;;
    "gaming")
        case "$SUBCAT_INPUT" in
            1) SUBCATEGORY="Achievements" ;;
            2) SUBCATEGORY="Guides" ;;
            3) SUBCATEGORY="Walkthroughs" ;;
            *)
                print_error "Invalid subcategory selection"
                exit 1
                ;;
        esac
        ;;
    "tutorials-guides")
        case "$SUBCAT_INPUT" in
            1) SUBCATEGORY="Equipment" ;;
            2) SUBCATEGORY="Repair Guides" ;;
            3) SUBCATEGORY="Software" ;;
            *)
                print_error "Invalid subcategory selection"
                exit 1
                ;;
        esac
        ;;
esac

print_success "Selected subcategory: $SUBCATEGORY"
echo ""

# Get article title
read -p "📝 Article title: " ARTICLE_TITLE
if [ -z "$ARTICLE_TITLE" ]; then
    print_error "Title cannot be empty"
    exit 1
fi

# Get article description
read -p "📄 Article description (one line): " ARTICLE_DESC

# Get author
read -p "👤 Author (or press Enter for default): " AUTHOR
AUTHOR=${AUTHOR:-"Tech Writer"}

# Generate slug
SLUG=$(slugify "$ARTICLE_TITLE")

# Generate article ID
DATE_PART=$(date +%y%m%d)
CAT_CODE=$(get_category_code "$CATEGORY")
SUBCAT_CODE=$(get_subcategory_code "$SUBCATEGORY")

if [ -z "$CAT_CODE" ] || [ -z "$SUBCAT_CODE" ]; then
    print_error "Subcategory not configured for: $CATEGORY > $SUBCATEGORY"
    exit 1
fi

# Create subcategory folder structure
SUBCAT_SLUG=$(get_subcategory_slug "$SUBCATEGORY")
SUBCAT_DIR="$CONTENT_DIR/$CATEGORY/$SUBCAT_SLUG"
mkdir -p "$SUBCAT_DIR"

# Generate filename
FILENAME="${SLUG}.md"
FILEPATH="$SUBCAT_DIR/$FILENAME"

# Check if file already exists
if [ -f "$FILEPATH" ]; then
    print_error "File already exists: $FILENAME"
    exit 1
fi

# Generate article ID (look in subcategory folder)
ARTICLE_ID=$(get_next_article_id "$CAT_CODE" "$SUBCAT_CODE" "$DATE_PART" "$SUBCAT_DIR")

# Create article with YAML front matter
cat > "$FILEPATH" << EOF
---
article_id: "$ARTICLE_ID"
title: "$ARTICLE_TITLE"
description: "$ARTICLE_DESC"
author: "$AUTHOR"
category: "$(echo $CATEGORY | sed 's/-/ /g' | sed 's/\b\(.\)/\u\1/g')"
subcategory: "$SUBCATEGORY"
tags:
  - "Uncategorized"
date: $(date -u +"%Y-%m-%dT%H:%M:%S.000Z")
draft: false
---

# $ARTICLE_TITLE

## Overview

Add your article content here.

## Key Points

- Point 1
- Point 2
- Point 3

## Conclusion

Add your conclusion here.
EOF

print_success "Article created: $FILENAME"
print_info "Article ID: $ARTICLE_ID"
print_info "Location: content/$CATEGORY/$SUBCAT_SLUG/$FILENAME"
echo ""
print_info "Next steps:"
echo "  1. Edit the article: content/$CATEGORY/$SUBCAT_SLUG/$FILENAME"
echo "  2. Add tags, dates, and content as needed"
echo "  3. Run: hugo --cleanDestinationDir"
echo ""

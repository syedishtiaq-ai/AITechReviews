#!/bin/bash

################################################################################
# AITechReviews - Article Creator (Flat Structure)
# Creates new articles in section root (flat structure)
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
declare -A CATEGORY_CODES=(
    ["buying-guides"]="BG"
    ["gaming"]="GM"
    ["tutorials-guides"]="TG"
)

declare -A SUBCATEGORY_CODES=(
    # Buying Guides
    ["Electronics"]="EL"
    ["Home Appliances"]="HA"
    ["Mobile Gadgets"]="MG"
    # Gaming
    ["Achievements"]="AC"
    ["Guides"]="GD"
    ["Walkthroughs"]="WK"
    # Tutorials & Guides
    ["Equipment"]="EQ"
    ["Repair Guides"]="RG"
    ["Software"]="SW"
)

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

# Select subcategory
echo "Available subcategories:"
echo "  1) Electronics"
echo "  2) Home Appliances"
echo "  3) Mobile Gadgets"
echo "  4) Achievements"
echo "  5) Guides"
echo "  6) Walkthroughs"
echo "  7) Equipment"
echo "  8) Repair Guides"
echo "  9) Software"
echo ""

read -p "📂 Select subcategory: " SUBCAT_INPUT

case "$SUBCAT_INPUT" in
    1) SUBCATEGORY="Electronics" ;;
    2) SUBCATEGORY="Home Appliances" ;;
    3) SUBCATEGORY="Mobile Gadgets" ;;
    4) SUBCATEGORY="Achievements" ;;
    5) SUBCATEGORY="Guides" ;;
    6) SUBCATEGORY="Walkthroughs" ;;
    7) SUBCATEGORY="Equipment" ;;
    8) SUBCATEGORY="Repair Guides" ;;
    9) SUBCATEGORY="Software" ;;
    *)
        print_error "Invalid subcategory selection"
        exit 1
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

# Get category codes
CAT_CODE="${CATEGORY_CODES[$CATEGORY]}"
SUBCAT_CODE="${SUBCATEGORY_CODES[$SUBCATEGORY]}"

if [ -z "$CAT_CODE" ] || [ -z "$SUBCAT_CODE" ]; then
    print_error "Subcategory not configured for: $CATEGORY > $SUBCATEGORY"
    exit 1
fi

# Generate article ID
DATE_PART=$(date +%y%m%d)
ARTICLE_ID=$(get_next_article_id "$CAT_CODE" "$SUBCAT_CODE" "$DATE_PART" "$CONTENT_DIR/$CATEGORY")

# Generate filename
FILENAME="${SLUG}.md"
FILEPATH="$CONTENT_DIR/$CATEGORY/$FILENAME"

# Check if file already exists
if [ -f "$FILEPATH" ]; then
    print_error "File already exists: $FILENAME"
    exit 1
fi

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
print_info "Location: content/$CATEGORY/$FILENAME"
echo ""
print_info "Next steps:"
echo "  1. Edit the article: content/$CATEGORY/$FILENAME"
echo "  2. Add tags, dates, and content as needed"
echo "  3. Run: hugo --cleanDestinationDir"
echo ""

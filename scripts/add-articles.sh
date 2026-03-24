#!/bin/bash

################################################################################
# ⛔ DEPRECATED - DO NOT USE
# AITechReviews - Quick Article Adder (NESTED STRUCTURE)
# 
# THIS SCRIPT IS OUTDATED
# It expects the nested folder structure which we've stopped using.
# 
# USE INSTEAD: ./scripts/add-articles-flat.sh
# 
# See: SCRIPTS_README.md for details
################################################################################

echo "❌ ERROR: This script is deprecated and works with the old nested structure."
echo ""
echo "   USE INSTEAD: ./scripts/add-articles-flat.sh"
echo ""
echo "   For full documentation, see: SCRIPTS_README.md"
echo ""
exit 1

################################################################################
# ORIGINAL: Quick Article Adder (NESTED STRUCTURE - DO NOT USE)
# Adds new articles to existing subcategories
# Usage: ./scripts/add-articles.sh
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
LAYOUTS_DIR="$PROJECT_ROOT/layouts"

# Hugo settings
HUGO_CMD="hugo"

# Category and subcategory code mappings for unique article IDs
declare -A SUBCATEGORY_CODES=(
    # Buying Guides
    ["buying-guides-electronics"]="BG-EL"
    ["buying-guides-home-appliances"]="BG-HA"
    ["buying-guides-mobile-gadgets"]="BG-MG"
    # Gaming
    ["gaming-achievements"]="GM-AC"
    ["gaming-guides"]="GM-GD"
    ["gaming-walkthroughs"]="GM-WK"
    # Tutorials & Guides
    ["tutorials-guides-equipment"]="TG-EQ"
    ["tutorials-guides-repair-guides"]="TG-RG"
    ["tutorials-guides-software"]="TG-SW"
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
    for category in $(ls -d "$CONTENT_DIR"/*/ 2>/dev/null | xargs -n1 basename | sort); do
        echo "  $count) $category"
        ((count++))
    done
}

# List subcategories in category
list_subcategories() {
    local category="$1"
    local category_path="$CONTENT_DIR/$category"
    local count=1
    for subcat in $(ls -d "$category_path"/*/ 2>/dev/null | xargs -n1 basename | sort); do
        echo "  $count) $subcat"
        ((count++))
    done
}

# Get category-subcategory code
get_category_code() {
    local category="$1"
    local subcategory="$2"
    local key="${category}-${subcategory}"
    echo "${SUBCATEGORY_CODES[$key]}"
}

# Generate next article ID for given date and category
get_next_article_id() {
    local cat_code="$1"
    local date_part="$2"
    local subcat_path="$3"
    
    local counter=1
    # Find highest existing number for this date/category
    for file in "$subcat_path"/article-*.md; do
        if [ -f "$file" ]; then
            local existing_id=$(grep "^article_id:" "$file" | grep "$cat_code-$date_part" | head -1 | sed "s/.*-0*\([0-9]*\).*/\1/")
            if [ ! -z "$existing_id" ] && [[ $existing_id =~ ^[0-9]+$ ]]; then
                if [ $existing_id -ge $counter ]; then
                    counter=$((existing_id + 1))
                fi
            fi
        fi
    done
    
    # Format as 3-digit number and return full ID
    local seq=$(printf "%03d" "$counter")
    echo "$cat_code-$date_part-$seq"
}

################################################################################
# Main Functions
################################################################################

get_user_input() {
    print_header "AITechReviews - Quick Article Adder"
    
    # Validate content directory
    if ! check_path "$CONTENT_DIR"; then
        print_error "Content directory not found: $CONTENT_DIR"
        exit 1
    fi
    
    # Select category
    echo "Select parent category:"
    echo ""
    list_categories
    echo ""
    
    read -p "📁 Enter category name or number: " CATEGORY_INPUT
    
    if [ -z "$CATEGORY_INPUT" ]; then
        print_error "Category cannot be empty"
        exit 1
    fi
    
    # Convert number to category name if needed
    if [[ "$CATEGORY_INPUT" =~ ^[0-9]+$ ]]; then
        CATEGORY_NAME=$(ls -d "$CONTENT_DIR"/*/ 2>/dev/null | sed -n "${CATEGORY_INPUT}p" | xargs -n1 basename)
        if [ -z "$CATEGORY_NAME" ]; then
            print_error "Invalid category number"
            exit 1
        fi
    else
        CATEGORY_NAME="$CATEGORY_INPUT"
    fi
    
    CATEGORY_PATH="$CONTENT_DIR/$CATEGORY_NAME"
    
    # Verify category exists
    if [ ! -d "$CATEGORY_PATH" ]; then
        print_error "Category not found: $CATEGORY_NAME"
        exit 1
    fi
    
    print_success "Selected category: $CATEGORY_NAME"
    echo ""
    
    # Select subcategory
    echo "Select subcategory:"
    echo ""
    list_subcategories "$CATEGORY_NAME"
    echo ""
    
    read -p "📂 Enter subcategory name or number: " SUBCATEGORY_INPUT
    
    if [ -z "$SUBCATEGORY_INPUT" ]; then
        print_error "Subcategory cannot be empty"
        exit 1
    fi
    
    # Convert number to subcategory name if needed
    if [[ "$SUBCATEGORY_INPUT" =~ ^[0-9]+$ ]]; then
        SUBCATEGORY_NAME=$(ls -d "$CATEGORY_PATH"/*/ 2>/dev/null | sed -n "${SUBCATEGORY_INPUT}p" | xargs -n1 basename)
        if [ -z "$SUBCATEGORY_NAME" ]; then
            print_error "Invalid subcategory number"
            exit 1
        fi
    else
        SUBCATEGORY_NAME="$SUBCATEGORY_INPUT"
    fi
    
    SUBCATEGORY_PATH="$CATEGORY_PATH/$SUBCATEGORY_NAME"
    
    # Verify subcategory exists
    if [ ! -d "$SUBCATEGORY_PATH" ]; then
        print_error "Subcategory not found: $SUBCATEGORY_NAME"
        exit 1
    fi
    
    print_success "Selected subcategory: $SUBCATEGORY_NAME"
    echo ""
    
    # Get article count
    read -p "📝 Number of articles to create (default: 1): " ARTICLES_COUNT
    ARTICLES_COUNT=${ARTICLES_COUNT:-1}
    
    if ! [[ "$ARTICLES_COUNT" =~ ^[0-9]+$ ]]; then
        print_error "Article count must be a number"
        exit 1
    fi
    
    if [ "$ARTICLES_COUNT" -lt 1 ]; then
        print_error "Article count must be at least 1"
        exit 1
    fi
    
    echo ""
}

# Get next available article number
get_next_article_number() {
    local subcat_path="$1"
    local max_num=0
    
    for file in "$subcat_path"/article-*.md; do
        if [ -f "$file" ]; then
            # Extract number from filename (article-N-slug.md)
            local num=$(basename "$file" | sed 's/article-\([0-9]*\)-.*/\1/')
            if [[ "$num" =~ ^[0-9]+$ ]] && [ "$num" -gt "$max_num" ]; then
                max_num="$num"
            fi
        fi
    done
    
    echo $((max_num + 1))
}

# Create articles
create_articles() {
    print_header "Creating Articles"
    
    local start_num=$(get_next_article_number "$SUBCATEGORY_PATH")
    local slug=$(slugify "$SUBCATEGORY_NAME")
    
    # Get category code and date for article IDs
    local cat_code=$(get_category_code "$CATEGORY_NAME" "$SUBCATEGORY_NAME")
    local date_part=$(date -u +"%y%m%d")
    
    for ((i=0; i<ARTICLES_COUNT; i++)); do
        local article_num=$((start_num + i))
        local article_title="$SUBCATEGORY_NAME - Article $article_num"
        local article_slug=$(slugify "article-$article_num-$slug")
        local article_file="$SUBCATEGORY_PATH/$article_slug.md"
        
        # Check if already exists
        if [ -f "$article_file" ]; then
            print_warning "Article already exists: $article_slug.md (skipping)"
            continue
        fi
        
        local article_date=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
        local article_id=$(get_next_article_id "$cat_code" "$date_part" "$SUBCATEGORY_PATH")
        
        cat > "$article_file" << EOF
---
article_id: "$article_id"
title: "$article_title"
description: "Comprehensive guide and review of $SUBCATEGORY_NAME. Learn everything you need to know."
date: $article_date
draft: false
tags: ["$SUBCATEGORY_NAME", "guide", "review"]
categories: ["$CATEGORY_NAME"]
author: "James Mitchell"
youtube_url: ""
instagram_url: ""
---

## Introduction

Welcome to our comprehensive guide on $SUBCATEGORY_NAME. This article covers everything you need to know.

## Key Features

- Point 1
- Point 2
- Point 3
- Point 4

## Main Sections

### Section 1
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.

### Section 2
Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.

## Comparison Table

| Feature | Option A | Option B |
|---------|----------|----------|
| Price | \$\$ | \$\$\$ |
| Quality | High | Very High |
| Durability | Good | Excellent |

## Pros and Cons

### Pros ✅
- Benefit 1
- Benefit 2
- Benefit 3

### Cons ❌
- Limitation 1
- Limitation 2

## Conclusion

In conclusion, $SUBCATEGORY_NAME offers great value. Choose based on your specific needs and preferences.

## FAQ

**Q: Is this suitable for beginners?**

A: Yes, absolutely! This is perfect for all skill levels.

**Q: What's included?**

A: Everything you need to get started and succeed.
EOF

        print_success "Created article: $article_slug.md"
    done
}

# Update site
update_site() {
    print_header "Building Site"
    
    print_info "Running Hugo build to regenerate site..."
    
    cd "$PROJECT_ROOT"
    if $HUGO_CMD --quiet 2>/dev/null; then
        print_success "Hugo build completed successfully"
    else
        print_warning "Hugo build may have had issues, but continuing..."
    fi
}

# Validate creation
validate_creation() {
    print_header "Validating Creation"
    
    local article_count=$(find "$SUBCATEGORY_PATH" -name "article-*.md" | wc -l)
    
    if [ "$article_count" -gt 0 ]; then
        print_success "$article_count articles found in subcategory"
    else
        print_warning "No articles found (unexpected)"
    fi
    
    print_success "Validation passed!"
}

# Generate report
generate_report() {
    print_header "Summary Report"
    
    local article_count=$(find "$SUBCATEGORY_PATH" -name "article-*.md" | wc -l)
    
    echo "📊 Article Addition Summary:"
    echo "   Category: $CATEGORY_NAME"
    echo "   Subcategory: $SUBCATEGORY_NAME"
    echo "   Total Articles in Subcategory: $article_count"
    echo "   Location: $SUBCATEGORY_PATH"
    echo ""
    
    print_info "Next steps:"
    echo "   1. Edit articles in: $SUBCATEGORY_PATH"
    echo "   2. Replace template content with real reviews"
    echo "   3. Add YouTube/Instagram URLs (optional)"
    echo "   4. Run 'hugo server' to test locally"
    echo "   5. Check your category page to verify"
    echo ""
    
    echo "📍 View in browser:"
    echo "   Category: http://localhost:1313/$CATEGORY_NAME/"
    echo "   Subcategory: http://localhost:1313/$CATEGORY_NAME/$SUBCATEGORY_NAME/"
    echo "   New Articles: Check the subcategory page"
    echo ""
}

################################################################################
# Main Execution
################################################################################

main() {
    clear
    print_header "AITechReviews - Quick Article Adder v1.0"
    
    # Validate paths
    if ! check_path "$CONTENT_DIR"; then
        print_error "Content directory not found: $CONTENT_DIR"
        exit 1
    fi
    
    # Get user input
    get_user_input
    
    echo ""
    echo "Ready to create:"
    echo "   Category: $CATEGORY_NAME"
    echo "   Subcategory: $SUBCATEGORY_NAME"
    echo "   New Articles: $ARTICLES_COUNT"
    echo ""
    read -p "Proceed with creation? (y/n): " -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "Cancelled."
        exit 0
    fi
    
    # Execute creation
    create_articles
    validate_creation
    generate_report
    update_site
    
    print_success "Articles added successfully! 🎉"
    echo ""
}

# Run main function
main "$@"

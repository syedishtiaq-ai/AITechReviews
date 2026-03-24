#!/bin/bash

################################################################################
# ⛔ DEPRECATED - DO NOT USE
# AITechReviews - Subcategory & Article Creator (NESTED STRUCTURE)
# 
# THIS SCRIPT IS OUTDATED
# It creates the nested folder structure which we've stopped using.
# 
# USE INSTEAD: ./scripts/create-article-flat.sh
# 
# See: SCRIPTS_README.md for details
################################################################################

echo "❌ ERROR: This script is deprecated and creates the old nested structure."
echo ""
echo "   USE INSTEAD: ./scripts/create-article-flat.sh"
echo ""
echo "   For full documentation, see: SCRIPTS_README.md"
echo ""
exit 1

################################################################################
# ORIGINAL: Subcategory & Article Creator (NESTED STRUCTURE - DO NOT USE)
# Creates new subcategories and articles under existing categories
# Usage: ./scripts/create-article.sh
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

# List available categories
list_categories() {
    echo "Available categories:"
    echo ""
    local count=1
    for category in $(ls -d "$CONTENT_DIR"/*/ 2>/dev/null | xargs -n1 basename); do
        echo "  $count) $category"
        ((count++))
    done
}

################################################################################
# Main Functions
################################################################################

get_user_input() {
    print_header "AITechReviews - Subcategory & Article Creator"
    
    # List categories
    if ! check_path "$CONTENT_DIR"; then
        print_error "Content directory not found: $CONTENT_DIR"
        exit 1
    fi
    
    echo "Select parent category:"
    echo ""
    list_categories
    echo ""
    
    read -p "📁 Enter category name or number (e.g., 'buying-guides' or '1'): " CATEGORY_INPUT
    
    if [ -z "$CATEGORY_INPUT" ]; then
        print_error "Category cannot be empty"
        exit 1
    fi
    
    # If number input, convert to category name
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
    
    if [ ! -d "$CATEGORY_PATH" ]; then
        print_error "Category not found: $CATEGORY_NAME"
        exit 1
    fi
    
    print_success "Selected category: $CATEGORY_NAME"
    echo ""
    
    # Get subcategory name
    read -p "📂 Subcategory name (e.g., 'furniture', 'smart-devices'): " SUBCATEGORY_INPUT
    if [ -z "$SUBCATEGORY_INPUT" ]; then
        print_error "Subcategory name cannot be empty"
        exit 1
    fi
    
    SUBCATEGORY_NAME=$(echo "$SUBCATEGORY_INPUT" | xargs) # Trim whitespace
    SUBCATEGORY_SLUG=$(slugify "$SUBCATEGORY_NAME")
    
    print_info "Subcategory slug: $SUBCATEGORY_SLUG"
    
    # Check if subcategory already exists
    if [ -d "$CATEGORY_PATH/$SUBCATEGORY_SLUG" ]; then
        print_warning "Subcategory '$SUBCATEGORY_NAME' already exists!"
        read -p "Continue anyway? (y/n): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_info "Cancelled."
            exit 0
        fi
    fi
    
    echo ""
    read -p "📝 Number of articles to create (default: 2): " ARTICLES_COUNT
    ARTICLES_COUNT=${ARTICLES_COUNT:-2}
    
    if ! [[ "$ARTICLES_COUNT" =~ ^[0-9]+$ ]]; then
        print_error "Article count must be a number"
        exit 1
    fi
    
    echo ""
}

# Create subcategory structure
create_subcategory_structure() {
    print_header "Creating Subcategory Structure"
    
    local subcat_path="$CATEGORY_PATH/$SUBCATEGORY_SLUG"
    
    # Create subcategory directory
    if [ ! -d "$subcat_path" ]; then
        mkdir -p "$subcat_path"
        print_success "Created subcategory directory: $SUBCATEGORY_SLUG"
    fi
    
    # Create subcategory index
    create_subcategory_index "$subcat_path"
    
    # Create articles
    create_articles "$subcat_path"
}

# Create subcategory index file
create_subcategory_index() {
    local subcat_path="$1"
    local index_file="$subcat_path/_index.md"
    
    if [ -f "$index_file" ]; then
        print_warning "Subcategory index already exists"
        return
    fi
    
    cat > "$index_file" << EOF
---
title: "$SUBCATEGORY_NAME"
description: "Explore our comprehensive $SUBCATEGORY_NAME collection with detailed reviews and guides."
type: "articles"
section: "$CATEGORY_NAME"
draft: false
---

Browse our $SUBCATEGORY_NAME resources and guides.
EOF

    print_success "Created subcategory index: _index.md"
}

# Create articles
create_articles() {
    local subcat_path="$1"
    
    # Get category code for this subcategory
    local cat_code=$(get_category_code "$CATEGORY_NAME" "$SUBCATEGORY_SLUG")
    local date_part=$(date -u +"%y%m%d")
    
    for ((i=1; i<=ARTICLES_COUNT; i++)); do
        local article_title="$SUBCATEGORY_NAME - Article $i"
        local article_slug=$(slugify "article-$i-$SUBCATEGORY_SLUG")
        local article_file="$subcat_path/$article_slug.md"
        
        if [ -f "$article_file" ]; then
            print_warning "Article already exists: $article_slug.md"
            continue
        fi
        
        local article_date=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
        local article_id=$(get_next_article_id "$cat_code" "$date_part" "$subcat_path")
        
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

# Verify category has list template
verify_template() {
    print_header "Verifying Templates"
    
    local template_path="$LAYOUTS_DIR/$CATEGORY_NAME/list.html"
    
    if [ -f "$template_path" ]; then
        print_success "Category template exists: $CATEGORY_NAME/list.html"
    else
        print_warning "Category-specific template not found"
        print_info "Using default template - articles will display correctly"
        print_info "To create custom template, see documentation"
    fi
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
    
    local subcat_path="$CATEGORY_PATH/$SUBCATEGORY_SLUG"
    
    if [ ! -d "$subcat_path" ]; then
        print_error "Subcategory directory was not created!"
        return 1
    fi
    
    print_success "Subcategory directory exists"
    
    if [ ! -f "$subcat_path/_index.md" ]; then
        print_error "Subcategory index file was not created!"
        return 1
    fi
    
    print_success "Subcategory index file exists"
    
    local article_count=$(find "$subcat_path" -name "article-*.md" | wc -l)
    if [ "$article_count" -eq "$ARTICLES_COUNT" ]; then
        print_success "All $article_count articles created"
    else
        print_warning "Expected $ARTICLES_COUNT articles but found $article_count"
    fi
    
    print_success "Validation passed!"
}

# Generate report
generate_report() {
    print_header "Summary Report"
    
    local subcat_path="$CATEGORY_PATH/$SUBCATEGORY_SLUG"
    local article_count=$(find "$subcat_path" -name "*.md" | wc -l)
    
    echo "📊 Article Creation Summary:"
    echo "   Parent Category: $CATEGORY_NAME"
    echo "   Subcategory: $SUBCATEGORY_NAME ($SUBCATEGORY_SLUG)"
    echo "   Total Files Created: $article_count"
    echo "   Location: $subcat_path"
    echo ""
    
    print_info "Next steps:"
    echo "   1. Review articles in: $subcat_path"
    echo "   2. Edit articles to add real content"
    echo "   3. Add YouTube/Instagram URLs in front matter"
    echo "   4. Run 'hugo server' to test locally"
    echo "   5. Check your category page to verify"
    echo ""
    
    echo "📍 View in browser:"
    echo "   Category: http://localhost:1313/$CATEGORY_NAME/"
    echo "   Subcategory: http://localhost:1313/$CATEGORY_NAME/$SUBCATEGORY_SLUG/"
    echo "   Article: http://localhost:1313/$CATEGORY_NAME/$SUBCATEGORY_SLUG/article-1-${SUBCATEGORY_SLUG}/"
    echo ""
}

################################################################################
# Main Execution
################################################################################

main() {
    clear
    print_header "AITechReviews - Subcategory & Article Creator v1.0"
    
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
    echo "   Subcategory: $SUBCATEGORY_NAME ($SUBCATEGORY_SLUG)"
    echo "   Articles: $ARTICLES_COUNT"
    echo ""
    read -p "Proceed with creation? (y/n): " -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "Cancelled."
        exit 0
    fi
    
    # Execute creation
    create_subcategory_structure
    verify_template
    validate_creation
    generate_report
    update_site
    
    print_success "Subcategory and articles created successfully! 🎉"
    echo ""
}

# Run main function
main "$@"

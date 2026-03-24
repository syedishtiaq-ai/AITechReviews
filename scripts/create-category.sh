#!/bin/bash

################################################################################
# ⛔ DEPRECATED - DO NOT USE
# AITechReviews - Automated Category & Article Creator (NESTED STRUCTURE)
# 
# THIS SCRIPT IS OUTDATED
# It creates the nested folder structure which we've stopped using.
# 
# USE INSTEAD: ./scripts/create-article-flat.sh OR ./scripts/add-articles-flat.sh
# 
# See: SCRIPTS_README.md for details
################################################################################

echo "❌ ERROR: This script is deprecated and creates the old nested structure."
echo ""
echo "   USE INSTEAD: ./scripts/add-articles-flat.sh"
echo ""
echo "   For full documentation, see: SCRIPTS_README.md"
echo ""
exit 1

################################################################################
# ORIGINAL: Automated Category & Article Creator (NESTED STRUCTURE - DO NOT USE)
# This script creates new categories with subcategories and articles
# Usage: ./scripts/create-category.sh
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
SCRIPTS_DIR="$PROJECT_ROOT/scripts"
TEMPLATES_DIR="$SCRIPTS_DIR/templates"

# Hugo settings
HUGO_CMD="hugo"

# Category and subcategory code mappings for unique article IDs
get_category_code() {
    echo "${1## #}" | sed 's/[^a-zA-Z0-9]//g' | cut -c1-2 | tr '[:lower:]' '[:upper:]'
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

# Slugify function - convert text to URL-friendly format
slugify() {
    echo "$1" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/-+/-/g' | sed 's/^-\|-$//'
}

# Check if directory exists
check_path() {
    if [ ! -d "$1" ]; then
        print_error "Path not found: $1"
        return 1
    fi
    return 0
}

################################################################################
# Main Functions
################################################################################

# Get user input
get_user_input() {
    print_header "AITechReviews - New Category Creator"
    
    echo "Enter category details:"
    echo ""
    
    # Category name
    read -p "📁 Category name (e.g., 'Home & Garden'): " CATEGORY_NAME
    if [ -z "$CATEGORY_NAME" ]; then
        print_error "Category name cannot be empty"
        exit 1
    fi
    
    CATEGORY_SLUG=$(slugify "$CATEGORY_NAME")
    print_info "Category slug: $CATEGORY_SLUG"
    
    # Check if category already exists
    if [ -d "$CONTENT_DIR/$CATEGORY_SLUG" ]; then
        print_warning "Category '$CATEGORY_NAME' already exists!"
        read -p "Continue anyway? (y/n): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_info "Cancelled."
            exit 0
        fi
    fi
    
    echo ""
    echo "📂 Subcategories (comma-separated, e.g., 'Furniture, Decor, Garden Tools')"
    read -p "Subcategories: " SUBCATEGORIES_INPUT
    
    if [ -z "$SUBCATEGORIES_INPUT" ]; then
        print_error "At least one subcategory is required"
        exit 1
    fi
    
    # Convert comma-separated to array
    IFS=',' read -ra SUBCATEGORIES <<< "$SUBCATEGORIES_INPUT"
    
    echo ""
    print_info "Subcategories to create:"
    for subcat in "${SUBCATEGORIES[@]}"; do
        subcat_slug=$(slugify "$subcat")
        echo "   - $subcat ($subcat_slug)"
    done
    
    echo ""
    read -p "📝 Number of sample articles per subcategory (default: 2): " ARTICLES_COUNT
    ARTICLES_COUNT=${ARTICLES_COUNT:-2}
    
    if ! [[ "$ARTICLES_COUNT" =~ ^[0-9]+$ ]]; then
        print_error "Article count must be a number"
        exit 1
    fi
}

# Create category structure
create_category_structure() {
    print_header "Creating Category Structure"
    
    local category_path="$CONTENT_DIR/$CATEGORY_SLUG"
    
    # Create main category directory
    if [ ! -d "$category_path" ]; then
        mkdir -p "$category_path"
        print_success "Created directory: $category_path"
    fi
    
    # Create _index.md for category
    create_category_index "$category_path" "$CATEGORY_NAME"
    
    # Create subcategories
    for subcat in "${SUBCATEGORIES[@]}"; do
        local subcat_name=$(echo "$subcat" | xargs) # Trim whitespace
        local subcat_slug=$(slugify "$subcat_name")
        local subcat_path="$category_path/$subcat_slug"
        
        # Create subcategory directory
        if [ ! -d "$subcat_path" ]; then
            mkdir -p "$subcat_path"
            print_success "Created subcategory: $subcat_slug"
        fi
        
        # Create subcategory _index.md
        create_subcategory_index "$subcat_path" "$subcat_name" "$CATEGORY_SLUG" "$subcat_slug"
        
        # Create sample articles
        create_sample_articles "$subcat_path" "$subcat_name" "$CATEGORY_SLUG" "$subcat_slug"
    done
}

# Create category index file
create_category_index() {
    local category_path="$1"
    local category_name="$2"
    local index_file="$category_path/_index.md"
    
    if [ -f "$index_file" ]; then
        print_warning "Category index already exists: $index_file"
        return
    fi
    
    cat > "$index_file" << 'EOF'
---
title: "{{CATEGORY_NAME}}"
description: "Explore our comprehensive {{CATEGORY_NAME}} collection with detailed reviews, guides, and comparisons."
type: "articles"
draft: false
---

Browse our extensive collection of {{CATEGORY_NAME_LOWER}} resources and guides.
EOF

    sed -i "s/{{CATEGORY_NAME}}/$CATEGORY_NAME/g" "$index_file"
    sed -i "s/{{CATEGORY_NAME_LOWER}}/$(echo $CATEGORY_NAME | tr '[:upper:]' '[:lower:]')/g" "$index_file"
    
    print_success "Created category index: _index.md"
}

# Create subcategory index file
create_subcategory_index() {
    local subcat_path="$1"
    local subcat_name="$2"
    local category_slug="$3"
    local subcat_slug="$4"
    local index_file="$subcat_path/_index.md"
    
    if [ -f "$index_file" ]; then
        print_warning "Subcategory index already exists: $index_file"
        return
    fi
    
    cat > "$index_file" << EOF
---
title: "$subcat_name"
description: "Detailed $subcat_name guides and resources for AITechReviews."
type: "articles"
section: "$category_slug"
draft: false
---

Explore our $subcat_name collection.
EOF

    print_success "Created subcategory index: $subcat_slug/_index.md"
}

# Create sample articles
create_sample_articles() {
    local subcat_path="$1"
    local subcat_name="$2"
    local category_slug="$3"
    local subcat_slug="$4"
    
    # Generate category-subcategory code and date for IDs
    local cat_code="${category_slug:0:2}-${subcat_slug:0:2}" | tr '[:lower:]' '[:upper:]'
    local date_part=$(date -u +"%y%m%d")
    
    for ((i=1; i<=ARTICLES_COUNT; i++)); do
        local article_title="$subcat_name - Guide Article $i"
        local article_slug=$(slugify "article-$i-$subcat_slug")
        local article_file="$subcat_path/$article_slug.md"
        
        if [ -f "$article_file" ]; then
            print_warning "Article already exists: $article_file"
            continue
        fi
        
        local article_date=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
        local article_id=$(get_next_article_id "$cat_code" "$date_part" "$subcat_path")
        
        cat > "$article_file" << EOF
---
article_id: "$article_id"
title: "$article_title"
description: "Comprehensive guide and review of $subcat_name. Learn everything you need to know."
date: $article_date
draft: false
tags: ["$subcat_name", "guide", "review"]
categories: ["$category_slug"]
author: "James Mitchell"
youtube_url: ""
instagram_url: ""
---

## Introduction

Welcome to our comprehensive guide on $subcat_name. This article covers everything you need to know about $subcat_name.

## Key Features

- Point 1
- Point 2
- Point 3
- Point 4

## Detailed Analysis

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
- Affordable
- Easy to use
- Great support

### Cons ❌
- Limited features
- Requires setup

## Conclusion

In conclusion, $subcat_name offers great value for users. Choose based on your specific needs and budget.

## FAQ

**Q: Is this suitable for beginners?**

A: Yes, absolutely! This is perfect for beginners and experts alike.

**Q: What's the warranty?**

A: Most options come with a 1-year warranty.
EOF

        print_success "Created article: $article_slug.md"
    done
}

# Create or update list template
create_list_template() {
    print_header "Creating Template Files"
    
    local template_path="$LAYOUTS_DIR/$CATEGORY_SLUG/list.html"
    
    # Create category layouts directory if it doesn't exist
    mkdir -p "$LAYOUTS_DIR/$CATEGORY_SLUG"
    
    if [ -f "$template_path" ]; then
        print_warning "Template already exists: $template_path"
        return
    fi
    
    cat > "$template_path" << 'EOF'
{{ define "main" }}
<section class="articles-container">
  <div class="articles-grid">
    {{ $section := .Section }}
    {{ $parent := .File.Dir }}
    
    {{ range where .Site.RegularPages "Section" "=" $section }}
      {{ if or (eq .Parent.File.Dir $parent) (eq .File.Dir $parent) }}
        <article class="article-card">
          <div class="article-header">
            <h3><a href="{{ .Permalink }}">{{ .Title }}</a></h3>
            <span class="article-date">{{ .Date.Format "Jan 2, 2006" }}</span>
          </div>
          <p class="article-description">{{ .Summary }}</p>
          <div class="article-meta">
            {{ if .Params.author }}<span class="author">By {{ .Params.author }}</span>{{ end }}
            <a href="{{ .Permalink }}" class="read-more">Read More →</a>
          </div>
        </article>
      {{ end }}
    {{ end }}
  </div>
</section>
{{ end }}
EOF

    print_success "Created template: $template_path"
}

# Update search index
update_search_index() {
    print_header "Updating Search Index"
    
    print_info "Running Hugo build to regenerate search index..."
    
    cd "$PROJECT_ROOT"
    if $HUGO_CMD --quiet; then
        print_success "Hugo build completed"
    else
        print_warning "Hugo build may have had issues, but continuing..."
    fi
}

# Create new article shortcut
add_navigation_menu() {
    print_header "Navigation Menu Update"
    
    print_info "The new category '$CATEGORY_NAME' needs to be added to your navigation menu."
    print_info "Edit your Hugo config file (hugo.toml) and add the following:"
    echo ""
    echo -e "${YELLOW}[[menu.main]]"
    echo "name = \"$CATEGORY_NAME\""
    echo "url = \"/$CATEGORY_SLUG/\""
    echo "weight = 40${NC}"
    echo ""
    print_info "Or the category will appear automatically in your section menus."
}

# Generate summary report
generate_report() {
    print_header "Summary Report"
    
    local category_path="$CONTENT_DIR/$CATEGORY_SLUG"
    local article_count=0
    
    # Count articles
    for subcat in "${SUBCATEGORIES[@]}"; do
        local subcat_slug=$(slugify "$(echo $subcat | xargs)")
        local subcat_path="$category_path/$subcat_slug"
        article_count=$((article_count + $(find "$subcat_path" -name "*.md" | wc -l)))
    done
    
    echo "📊 Creation Summary:"
    echo "   Category: $CATEGORY_NAME ($CATEGORY_SLUG)"
    echo "   Subcategories: ${#SUBCATEGORIES[@]}"
    echo "   Total Articles Created: $article_count"
    echo "   Location: $category_path"
    echo ""
    
    print_info "Next steps:"
    echo "   1. Review created files in: $category_path"
    echo "   2. Edit articles to add real content"
    echo "   3. Update navigation menu (if needed)"
    echo "   4. Run 'hugo server' to test"
    echo "   5. Check homepage and search to verify"
    echo ""
}

# Test the creation
test_creation() {
    print_header "Testing Creation"
    
    local category_path="$CONTENT_DIR/$CATEGORY_SLUG"
    
    if [ ! -d "$category_path" ]; then
        print_error "Category directory was not created!"
        return 1
    fi
    
    print_success "Category directory exists"
    
    if [ ! -f "$category_path/_index.md" ]; then
        print_error "Category index file was not created!"
        return 1
    fi
    
    print_success "Category index file exists"
    
    # Count subcategories
    local subcat_count=$(find "$category_path" -maxdepth 1 -type d | tail -n +2 | wc -l)
    local expected_subcat=${#SUBCATEGORIES[@]}
    
    if [ "$subcat_count" -eq "$expected_subcat" ]; then
        print_success "All $subcat_count subcategories created"
    else
        print_warning "Expected $expected_subcat subcategories but found $subcat_count"
    fi
    
    print_success "Structure validation passed!"
}

################################################################################
# Main Execution
################################################################################

main() {
    clear
    print_header "AITechReviews Content Creator v1.0"
    
    # Validate paths
    if ! check_path "$CONTENT_DIR"; then
        exit 1
    fi
    
    if ! check_path "$LAYOUTS_DIR"; then
        exit 1
    fi
    
    # Get user input
    get_user_input
    
    echo ""
    echo "Ready to create the following:"
    echo "   Category: $CATEGORY_NAME ($CATEGORY_SLUG)"
    echo "   Subcategories: ${#SUBCATEGORIES[@]}"
    echo "   Articles per subcategory: $ARTICLES_COUNT"
    echo ""
    read -p "Proceed with creation? (y/n): " -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "Cancelled."
        exit 0
    fi
    
    # Execute creation
    create_category_structure
    create_list_template
    test_creation
    generate_report
    update_search_index
    add_navigation_menu
    
    print_success "Category creation completed! 🎉"
    echo ""
}

# Run main function
main "$@"

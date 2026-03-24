#!/bin/bash

################################################################################
# AITechReviews - Author Management Script
# Add new authors and update article references
# Usage: ./scripts/manage-authors.sh
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
AUTHORS_DIR="$CONTENT_DIR/authors"

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

# Generate next author ID
get_next_author_id() {
    local counter=1
    for file in "$AUTHORS_DIR"/*.md; do
        if [ -f "$file" ] && [ "$(basename "$file")" != "_index.md" ]; then
            local existing_id=$(grep -m1 "^article_id:" "$file" 2>/dev/null | sed -E "s/.*article_id: \"?([^\"]*).*/\1/")
            if [ ! -z "$existing_id" ]; then
                local num=$(echo "$existing_id" | awk -F'-' '{print $NF}')
                num=$((10#$num))  # Remove leading zeros
                if [ $num -ge $counter ]; then
                    counter=$((num + 1))
                fi
            fi
        fi
    done
    
    printf "%03d" "$counter"
}

# Update article references to mention this author
update_article_references() {
    local author_name="$1"
    local author_slug="$2"
    
    print_info "Searching for articles that mention '$author_name'..."
    
    local updated_count=0
    local found_count=0
    
    # Find all article files that contain the author name
    for article_file in $(find "$CONTENT_DIR" -name "*.md" -type f ! -path "*authors*" ! -name "_index.md" ! -path "*archives*"); do
        if grep -qi "$author_name" "$article_file" 2>/dev/null; then
            ((found_count++))
            
            # Check if article already has proper author metadata
            if grep -q "^author:" "$article_file"; then
                print_warning "  Article already has author field: $(basename "$article_file")"
            else
                # Add author field after title
                if grep -q "^title:" "$article_file"; then
                    awk -v author="author: \"$author_name\"" '
                    /^title:/ {
                        print
                        if (!inserted) {
                            print author
                            inserted=1
                        }
                        next
                    }
                    { print }
                    ' "$article_file" > "${article_file}.tmp" && mv "${article_file}.tmp" "$article_file"
                    
                    print_success "  Updated article reference: $(basename "$article_file")"
                    ((updated_count++))
                fi
            fi
        fi
    done
    
    if [ $found_count -gt 0 ]; then
        print_info "Found $found_count articles mentioning this author"
        print_success "Updated $updated_count article references"
    else
        print_warning "No articles found mentioning this author yet"
    fi
    
    echo ""
}

# Display existing authors
list_authors() {
    echo "Existing Authors:"
    echo ""
    local count=1
    for author_file in $(ls -1 "$AUTHORS_DIR"/*.md 2>/dev/null | grep -v "_index.md" | sort); do
        local title=$(grep "^title:" "$author_file" | sed 's/^title: "\?\([^"]*\).*/\1/')
        local role=$(grep "^authorRole:" "$author_file" | sed 's/^authorRole: "\?\([^"]*\).*/\1/')
        local author_id=$(grep "^article_id:" "$author_file" | sed -E 's/.*article_id: "?([^"]*).*/\1/')
        
        echo "  $count) $title"
        if [ ! -z "$role" ]; then
            echo "     Role: $role"
        fi
        if [ ! -z "$author_id" ]; then
            echo "     ID: $author_id"
        fi
        echo ""
        ((count++))
    done
}

################################################################################
# Main Menu
################################################################################

print_header "AITechReviews - Author Management"

echo "Options:"
echo "  1) Add new author"
echo "  2) List all authors"
echo "  3) Exit"
echo ""

read -p "Select option: " OPTION

case "$OPTION" in
    1)
        print_header "Add New Author"
        
        # Get author details
        read -p "👤 Author name: " AUTHOR_NAME
        if [ -z "$AUTHOR_NAME" ]; then
            print_error "Author name required"
            exit 1
        fi
        
        # Generate slug
        AUTHOR_SLUG=$(slugify "$AUTHOR_NAME")
        
        # Check if author already exists
        if [ -f "$AUTHORS_DIR/${AUTHOR_SLUG}.md" ]; then
            print_error "Author already exists: $AUTHOR_SLUG"
            exit 1
        fi
        
        read -p "📝 Author role/title: " AUTHOR_ROLE
        
        read -p "📄 Author bio (one or more lines, press Ctrl+D when done):" AUTHOR_BIO
        # Read multi-line bio
        AUTHOR_BIO=$(cat)
        
        read -p "🖼️  Author image path (optional, e.g. /images/authors/john-doe.jpg): " AUTHOR_IMAGE
        
        read -p "🔗 Twitter handle (optional, without @): " AUTHOR_TWITTER
        
        read -p "🌐 Website URL (optional): " AUTHOR_WEBSITE
        
        # Generate author ID
        AUTHOR_ID_NUM=$(get_next_author_id)
        AUTHOR_ID="AU-AU-$(date +%y%m%d)-${AUTHOR_ID_NUM}"
        
        # Create author file
        cat > "$AUTHORS_DIR/${AUTHOR_SLUG}.md" << EOF
---
article_id: "$AUTHOR_ID"
title: "$AUTHOR_NAME"
slug: "$AUTHOR_SLUG"
authorRole: "$AUTHOR_ROLE"
authorBio: "$AUTHOR_BIO"
EOF
        
        # Add optional fields
        if [ ! -z "$AUTHOR_IMAGE" ]; then
            echo "authorImage: \"$AUTHOR_IMAGE\"" >> "$AUTHORS_DIR/${AUTHOR_SLUG}.md"
        fi
        
        if [ ! -z "$AUTHOR_TWITTER" ] || [ ! -z "$AUTHOR_WEBSITE" ]; then
            echo "authorLinks:" >> "$AUTHORS_DIR/${AUTHOR_SLUG}.md"
            if [ ! -z "$AUTHOR_TWITTER" ]; then
                echo "  twitter: \"$AUTHOR_TWITTER\"" >> "$AUTHORS_DIR/${AUTHOR_SLUG}.md"
            fi
            if [ ! -z "$AUTHOR_WEBSITE" ]; then
                echo "  website: \"$AUTHOR_WEBSITE\"" >> "$AUTHORS_DIR/${AUTHOR_SLUG}.md"
            fi
        fi
        
        echo "---" >> "$AUTHORS_DIR/${AUTHOR_SLUG}.md"
        echo "" >> "$AUTHORS_DIR/${AUTHOR_SLUG}.md"
        echo "$AUTHOR_BIO" >> "$AUTHORS_DIR/${AUTHOR_SLUG}.md"
        
        print_success "Author created: $AUTHOR_NAME"
        print_info "Author ID: $AUTHOR_ID"
        print_info "File location: content/authors/${AUTHOR_SLUG}.md"
        echo ""
        
        # Update article references
        update_article_references "$AUTHOR_NAME" "$AUTHOR_SLUG"
        
        print_info "Next steps:"
        echo "  1. Review the author file: content/authors/${AUTHOR_SLUG}.md"
        echo "  2. Check article updates for proper author field"
        echo "  3. Run: hugo --cleanDestinationDir"
        echo "  4. Commit changes: git add -A && git commit -m 'Add author: $AUTHOR_NAME'"
        echo ""
        ;;
        
    2)
        list_authors
        ;;
        
    3)
        print_info "Exiting..."
        exit 0
        ;;
        
    *)
        print_error "Invalid option"
        exit 1
        ;;
esac

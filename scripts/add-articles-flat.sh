#!/bin/bash

################################################################################
# AITechReviews - Quick Article Adder (Flat Structure)
# Quickly add new articles to existing sections
# Usage: ./scripts/add-articles-flat.sh
# 
# NOTE: This script works with the flat article structure where articles
# are placed directly in section roots (e.g., content/buying-guides/*.md)
# NOT in subcategory subfolders.
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

# Category and subcategory code mappings
declare -A CATEGORY_CODES=(
    ["buying-guides"]="BG"
    ["gaming"]="GM"
    ["tutorials-guides"]="TG"
)

declare -A SUBCATEGORY_CODES=(
    ["Electronics"]="EL"
    ["Home Appliances"]="HA"
    ["Mobile Gadgets"]="MG"
    ["Achievements"]="AC"
    ["Guides"]="GD"
    ["Walkthroughs"]="WK"
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

# List available sections
list_sections() {
    local count=1
    for section in $(ls -d "$CONTENT_DIR"/*/ 2>/dev/null | xargs -n1 basename | grep -v "authors\|archives\|search" | sort); do
        if [ -d "$CONTENT_DIR/$section/_index.md" ] || [ -f "$CONTENT_DIR/$section/_index.md" ]; then
            echo "  $count) $section"
            ((count++))
        fi
    done
}

# Generate article filename
generate_filename() {
    local title="$1"
    local date="$2"
    local slug=$(slugify "$title")
    echo "${slug}.md"
}

# Count existing articles in section
count_articles() {
    local section="$1"
    find "$CONTENT_DIR/$section" -maxdepth 1 -name "*.md" -type f ! -name "_index.md" | wc -l
}

################################################################################
# Main Script
################################################################################

print_header "AITechReviews - Quick Article Adder (Flat Structure)"

if [ ! -d "$CONTENT_DIR" ]; then
    print_error "Content directory not found: $CONTENT_DIR"
    exit 1
fi

# Select section
echo "Available sections:"
echo ""
list_sections
echo ""

read -p "📁 Select section (by number): " SECTION_NUM

if [ -z "$SECTION_NUM" ] || ! [[ "$SECTION_NUM" =~ ^[0-9]+$ ]]; then
    print_error "Invalid selection"
    exit 1
fi

SECTION=$(ls -d "$CONTENT_DIR"/*/ 2>/dev/null | grep -v "authors\|archives\|search" | sed -n "${SECTION_NUM}p" | xargs -n1 basename)

if [ -z "$SECTION" ]; then
    print_error "Invalid section number"
    exit 1
fi

print_success "Selected section: $SECTION"
echo ""

# How many articles to create
read -p "📝 Number of articles to create: " NUM_ARTICLES

if ! [[ "$NUM_ARTICLES" =~ ^[0-9]+$ ]] || [ "$NUM_ARTICLES" -lt 1 ]; then
    print_error "Must enter a number >= 1"
    exit 1
fi

print_info "Creating $NUM_ARTICLES article templates..."
echo ""

SECTION_CODE="${CATEGORY_CODES[$SECTION]}"

if [ -z "$SECTION_CODE" ]; then
    print_error "Section code not configured"
    exit 1
fi

# Create articles
for i in $(seq 1 $NUM_ARTICLES); do
    read -p "[$i/$NUM_ARTICLES] Article title: " TITLE
    
    if [ -z "$TITLE" ]; then
        print_warning "Skipping empty title"
        continue
    fi
    
    read -p "         Description (optional): " DESC
    
    read -p "         Subcategory (optional): " SUBCAT
    
    read -p "         Author (optional): " AUTHOR
    AUTHOR=${AUTHOR:-"Tech Writer"}
    
    # Generate filename and slug
    FILENAME=$(generate_filename "$TITLE")
    FILEPATH="$CONTENT_DIR/$SECTION/$FILENAME"
    
    # Check if file exists
    if [ -f "$FILEPATH" ]; then
        print_warning "File already exists: $FILENAME (skipping)"
        continue
    fi
    
    # Get subcategory code if provided
    SUBCAT_CODE=""
    if [ ! -z "$SUBCAT" ]; then
        SUBCAT_CODE="${SUBCATEGORY_CODES[$SUBCAT]}"
    fi
    
    # Create article
    cat > "$FILEPATH" << EOF
---
title: "$TITLE"
description: "$DESC"
author: "$AUTHOR"
category: "$(echo $SECTION | sed 's/-/ /g' | sed 's/\b\(.\)/\u\1/g')"
subcategory: "$SUBCAT"
tags:
  - Uncategorized
date: $(date -u +"%Y-%m-%dT%H:%M:%S.000Z")
draft: false
---

# $TITLE

## Overview

Add your article content here.

## Key Points

- Point 1
- Point 2
- Point 3

## Conclusion

Add your conclusion here.
EOF
    
    print_success "Created: $FILENAME"
done

echo ""
print_header "Articles Created"
ARTICLE_COUNT=$(count_articles "$SECTION")
print_info "Total articles in $SECTION: $ARTICLE_COUNT"
echo ""
print_info "Next steps:"
echo "  1. Edit articles in: content/$SECTION/"
echo "  2. Fill in content and metadata"
echo "  3. Assign article IDs: ./scripts/assign-article-ids-flat.sh"
echo "  4. Rebuild Hugo: hugo --cleanDestinationDir"
echo ""

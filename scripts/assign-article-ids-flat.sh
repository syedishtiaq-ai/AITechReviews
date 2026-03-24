#!/bin/bash

################################################################################
# AITechReviews - Assign Article IDs (Flat Structure)
# Adds/updates unique article IDs to all articles in flat structure
# Usage: ./scripts/assign-article-ids-flat.sh
################################################################################

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONTENT_DIR="$PROJECT_ROOT/content"

# Category and subcategory code mappings
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

print_header() {
    echo -e "\n${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}\n"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Extract date from front matter (date: YYYY-MM-DDTHH:MM:SSZ format)
# Convert to YYMMDD format (e.g., 260316 for March 16, 2026)
extract_and_convert_date() {
    local file="$1"
    local date_line=$(grep -m1 "^date:" "$file" | head -1)
    
    if [ -z "$date_line" ]; then
        date +"%y%m%d"
        return
    fi
    
    # Extract date part (YYYY-MM-DD)
    local date_str=$(echo "$date_line" | sed 's/date: "\?\([0-9-]*\).*/\1/')
    
    if [ -z "$date_str" ]; then
        date +"%y%m%d"
        return
    fi
    
    # Convert YYYY-MM-DD to YYMMDD
    echo "$date_str" | sed 's/20\([0-9][0-9]\)-\([0-9][0-9]\)-\([0-9][0-9]\)/\1\2\3/'
}

# Extract subcategory from front matter
get_subcategory_from_file() {
    local file="$1"
    local subcat=$(grep -m1 "^subcategory:" "$file" | sed 's/subcategory: "\?\([^"]*\).*/\1/')
    echo "$subcat"
}

# Get next ID for a category/subcategory/date combo
get_next_id_number() {
    local cat_code="$1"
    local subcat_code="$2"
    local date_part="$3"
    local section="$4"
    
    local counter=1
    for file in "$CONTENT_DIR/$section"/*.md; do
        if [ -f "$file" ] && [ "$(basename "$file")" != "_index.md" ]; then
            # Extract article ID from file
            local existing_id=$(grep -m1 "^article_id:" "$file" 2>/dev/null | sed "s/.*article_id: \"\?\([^\"]*\).*/\1/")
            
            if [[ "$existing_id" =~ ^${cat_code}-${subcat_code}-${date_part}-([0-9]+)$ ]]; then
                local num="${BASH_REMATCH[1]}"
                num=$((10#$num))  # Remove leading zeros
                if [ $num -ge $counter ]; then
                    counter=$((num + 1))
                fi
            fi
        fi
    done
    
    printf "%03d" "$counter"
}

################################################################################
# Main Script
################################################################################

print_header "Article ID Assignment (Flat Structure)"

if [ ! -d "$CONTENT_DIR" ]; then
    print_error "Content directory not found: $CONTENT_DIR"
    exit 1
fi

TOTAL_ARTICLES=0
UPDATED_ARTICLES=0
SKIPPED_ARTICLES=0

# Process each section
for section_path in "$CONTENT_DIR"/*; do
    if [ ! -d "$section_path" ]; then
        continue
    fi
    
    section=$(basename "$section_path")
    
    # Skip non-article directories
    if [[ "$section" =~ ^(authors|archives|search)$ ]]; then
        continue
    fi
    
    section_code="${CATEGORY_CODES[$section]}"
    
    if [ -z "$section_code" ]; then
        print_warning "No code mapping for section: $section"
        continue
    fi
    
    print_info "Processing section: $section"
    
    # Process all markdown files in section root (flat structure)
    for article_file in "$section_path"/*.md; do
        if [ ! -f "$article_file" ] || [ "$(basename "$article_file")" = "_index.md" ]; then
            continue
        fi
        
        ((TOTAL_ARTICLES++))
        
        # Get subcategory from YAML
        subcategory=$(get_subcategory_from_file "$article_file")
        
        # Get subcategory code
        subcat_code="${SUBCATEGORY_CODES[$subcategory]}"
        
        if [ -z "$subcat_code" ]; then
            print_warning "  No code for subcategory '$subcategory' in $(basename "$article_file")"
            ((SKIPPED_ARTICLES++))
            continue
        fi
        
        # Check if article_id already exists
        existing_id=$(grep -m1 "^article_id:" "$article_file" 2>/dev/null | sed "s/.*article_id: \"\?\([^\"]*\).*/\1/")
        
        if [ ! -z "$existing_id" ] && [[ "$existing_id" =~ ^[A-Z]+-[A-Z]+-[0-9]+-[0-9]+$ ]]; then
            # Already has proper ID
            print_info "  ✓ $(basename "$article_file") - ID: $existing_id"
            continue
        fi
        
        # Extract date from article
        date_part=$(extract_and_convert_date "$article_file")
        
        # Generate new article ID
        id_number=$(get_next_id_number "$section_code" "$subcat_code" "$date_part" "$section")
        new_article_id="$section_code-$subcat_code-$date_part-$id_number"
        
        # Update or add article_id in front matter
        if grep -q "^article_id:" "$article_file"; then
            # Replace existing article_id
            sed -i '' "s/^article_id:.*/article_id: \"$new_article_id\"/" "$article_file"
            print_success "  Updated $(basename "$article_file") - ID: $new_article_id"
        else
            # Add article_id after first line (after opening ---)
            sed -i '' "1a\\
article_id: \"$new_article_id\"" "$article_file"
            print_success "  Added $(basename "$article_file") - ID: $new_article_id"
        fi
        
        ((UPDATED_ARTICLES++))
    done
    
    echo ""
done

################################################################################
# Summary
################################################################################

print_header "Assignment Complete"
echo "📊 Summary:"
echo "  Total articles processed: $TOTAL_ARTICLES"
echo "  Articles updated/added IDs: $UPDATED_ARTICLES"
echo "  Articles skipped: $SKIPPED_ARTICLES"
echo ""

if [ $SKIPPED_ARTICLES -gt 0 ]; then
    print_warning "Some articles were skipped. Check subcategory field."
fi

print_info "Next steps:"
echo "  1. Verify article IDs: grep -r 'article_id:' $CONTENT_DIR/"
echo "  2. Rebuild Hugo: hugo --cleanDestinationDir"
echo "  3. Test article links and filtering"
echo ""

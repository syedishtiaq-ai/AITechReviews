#!/bin/bash

################################################################################
# ⛔ DEPRECATED - DO NOT USE
# AITechReviews - Assign Unique Article IDs v2 (NESTED STRUCTURE)
# 
# THIS SCRIPT IS OUTDATED
# It looks for articles in the nested folder structure we've stopped using.
# 
# USE INSTEAD: ./scripts/assign-article-ids-flat.sh
# 
# See: SCRIPTS_README.md for details
################################################################################

echo "❌ ERROR: This script is deprecated and works with the old nested structure."
echo ""
echo "   USE INSTEAD: ./scripts/assign-article-ids-flat.sh"
echo ""
echo "   For full documentation, see: SCRIPTS_README.md"
echo ""
exit 1

################################################################################
# ORIGINAL: Assign Unique Article IDs v2 (NESTED STRUCTURE - DO NOT USE)
# Adds unique, human-readable article IDs to all existing articles
# Usage: ./scripts/assign-article-ids-v2.sh
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

print_header() {
    echo ""
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""
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

# Generate category code from category and subcategory names
generate_category_code() {
    local category="$1"
    local subcategory="$2"
    
    # Map known categories and subcategories
    case "$category-$subcategory" in
        "buying-guides-electronics") echo "BG-EL" ;;
        "buying-guides-home-appliances") echo "BG-HA" ;;
        "buying-guides-mobile-gadgets") echo "BG-MG" ;;
        "gaming-achievements") echo "GM-AC" ;;
        "gaming-guides") echo "GM-GD" ;;
        "gaming-walkthroughs") echo "GM-WK" ;;
        "tutorials-guides-equipment") echo "TG-EQ" ;;
        "tutorials-guides-repair-guides") echo "TG-RG" ;;
        "tutorials-guides-software") echo "TG-SW" ;;
        *)
            # Fallback: use first 2 chars of each
            local cat_code="${category:0:2}-${subcategory:0:2}"
            echo "$(echo "$cat_code" | tr '[:lower:]' '[:upper:]')"
            ;;
    esac
}

# Extract date from front matter and convert to YYMMDD
extract_and_convert_date() {
    local file="$1"
    local date_line=$(grep "^date:" "$file" | head -1)
    
    if [ -z "$date_line" ]; then
        date +"%y%m%d"
        return
    fi
    
    # Extract date part (YYYY-MM-DD)
    local date_str=$(echo "$date_line" | sed 's/date: "\([0-9-]*\).*/\1/')
    
    if [ -z "$date_str" ]; then
        date +"%y%m%d"
        return
    fi
    
    # Convert YYYY-MM-DD to YYMMDD
    local year=$(echo "$date_str" | cut -d'-' -f1 | tail -c 3)
    local month=$(echo "$date_str" | cut -d'-' -f2)
    local day=$(echo "$date_str" | cut -d'-' -f3)
    
    echo "${year}${month}${day}"
}

# Generate unique article ID
generate_article_id() {
    local file="$1"
    local category_path=$(dirname "$file" | sed "s|$CONTENT_DIR/||")
    local date_part=$(extract_and_convert_date "$file")
    
    # Parse category and subcategory from path
    local category=$(echo "$category_path" | cut -d'/' -f1)
    local subcategory=$(echo "$category_path" | cut -d'/' -f2)
    
    # Get category-subcategory code
    local cat_code=$(generate_category_code "$category" "$subcategory")
    
    if [ -z "$cat_code" ]; then
        print_warning "Unknown category path: $category_path"
        return 1
    fi
    
    # Find the highest number for this date/category
    local counter=1
    local existing_ids=$(grep -h "article_id:" "$CONTENT_DIR"/*/*/*.md 2>/dev/null | grep "$cat_code-$date_part" | sed 's/.*-0*\([0-9]*\).*/\1/' | sort -n)
    
    if [ ! -z "$existing_ids" ]; then
        local max_num=$(echo "$existing_ids" | tail -1)
        counter=$((max_num + 1))
    fi
    
    # Format as 3-digit number
    local seq=$(printf "%03d" "$counter")
    
    echo "$cat_code-$date_part-$seq"
}

# Check if article already has an ID
has_article_id() {
    local file="$1"
    grep -q "^article_id:" "$file"
}

# Add article ID to file
add_article_id() {
    local file="$1"
    
    if has_article_id "$file"; then
        print_warning "Article already has ID: $(basename "$file")"
        return 0
    fi
    
    local article_id=$(generate_article_id "$file")
    
    if [ -z "$article_id" ]; then
        print_warning "Failed to generate ID for: $file"
        return 1
    fi
    
    # Insert article_id after the opening --- line
    local temp_file="${file}.tmp"
    { head -1 "$file"; echo "article_id: \"$article_id\""; tail -n +2 "$file"; } > "$temp_file"
    mv "$temp_file" "$file"
    
    print_success "Added ID [$article_id] to: $(basename "$file")"
}

# Main execution
main() {
    print_header "AITechReviews - Assign Unique Article IDs"
    
    print_info "Scanning for articles without IDs..."
    echo ""
    
    local count=0
    local skipped=0
    
    # Find all article files
    for file in $(find "$CONTENT_DIR" -maxdepth 3 -name "*.md" -type f ! -name "_index.md"); do
        if ! has_article_id "$file"; then
            add_article_id "$file"
            ((count++))
        else
            ((skipped++))
        fi
    done
    
    echo ""
    print_header "Summary"
    echo "Articles processed: $count"
    echo "Articles already have IDs: $skipped"
    echo ""
    echo "ID Format: {CATEGORY-CODE}-{YYMMDD}-{###}"
    echo ""
    echo "Example IDs:"
    echo "  BG-EL-260316-001 = Buying Guide, Electronics, March 16, 2026, #1"
    echo "  GM-AC-260315-002 = Gaming, Achievements, March 15, 2026, #2"
    echo "  TG-RG-260314-001 = Tutorial, Repair Guide, March 14, 2026, #1"
    echo ""
    print_success "Article ID assignment complete! ✨"
}

main "$@"

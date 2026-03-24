#!/bin/bash

################################################################################
# ⛔ DEPRECATED - DO NOT USE
# AITechReviews - Assign Unique Article IDs (NESTED STRUCTURE)
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
# ORIGINAL: Assign Unique Article IDs (NESTED STRUCTURE - DO NOT USE)
# Adds unique, human-readable article IDs to all existing articles
# Usage: ./scripts/assign-article-ids.sh
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
    ["buying-guides/electronics"]="BG-EL"
    ["buying-guides/home-appliances"]="BG-HA"
    ["buying-guides/mobile-gadgets"]="BG-MG"
    # Gaming
    ["gaming/achievements"]="GM-AC"
    ["gaming/guides"]="GM-GD"
    ["gaming/walkthroughs"]="GM-WK"
    # Tutorials & Guides
    ["tutorials-guides/equipment"]="TG-EQ"
    ["tutorials-guides/repair-guides"]="TG-RG"
    ["tutorials-guides/software"]="TG-SW"
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

# Extract date from front matter (date: YYYY-MM-DDTHH:MM:SSZ format)
# Convert to YYMMDD format (e.g., 260316 for March 16, 2026)
extract_and_convert_date() {
    local file="$1"
    local date_line=$(grep -m1 "^date:" "$file" | head -1)
    
    if [ -z "$date_line" ]; then
        # If no date, use today's date
        date +"%y%m%d"
        return
    fi
    
    # Extract date part (YYYY-MM-DD from something like "2026-03-16T11:00:00.000Z")
    local date_str=$(echo "$date_line" | sed 's/date: "\?\([0-9-]*\).*/\1/')
    
    if [ -z "$date_str" ]; then
        date +"%y%m%d"
        return
    fi
    
    # Convert YYYY-MM-DD to YYMMDD
    local year=$(echo "$date_str" | cut -d'-' -f1)
    local month=$(echo "$date_str" | cut -d'-' -f2)
    local day=$(echo "$date_str" | cut -d'-' -f3)
    
    # Get last 2 digits of year
    year=${year: -2}
    
    echo "${year}${month}${day}"
}

# Generate unique article ID
generate_article_id() {
    local file="$1"
    local category_path=$(dirname "$file" | sed "s|$CONTENT_DIR/||")
    local date_part=$(extract_and_convert_date "$file")
    
    # Get category-subcategory code
    local cat_code="${SUBCATEGORY_CODES[$category_path]}"
    
    if [ -z "$cat_code" ]; then
        print_warning "Unknown category path: $category_path"
        return 1
    fi
    
    # Find the highest number for this date/category
    local counter=1
    local existing_ids=$(grep -h "article_id:" "$CONTENT_DIR"/*/*.md "$CONTENT_DIR"/*/*/*.md 2>/dev/null | grep "$cat_code-$date_part" | sed "s/.*-0*\([0-9]*\).*/\1/" | sort -n)
    
    if [ ! -z "$existing_ids" ]; then
        max_num=$(echo "$existing_ids" | tail -1)
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
        print_warning "Article already has ID: $file"
        return 0
    fi
    
    local article_id=$(generate_article_id "$file")
    
    if [ -z "$article_id" ]; then
        print_warning "Failed to generate ID for: $file"
        return 1
    fi
    
    # Add article_id after the opening --- line
    # Find the line number of the first ---
    local line_num=$(head -1 "$file" | grep -n "^---" | cut -d: -f1)
    
    if [ $line_num -eq 1 ]; then
        # Insert after first line (which is ---) - macOS compatible version
        local temp_file=\"${file}.tmp\"
        { head -1 \"$file\"; echo \"article_id: \\\"$article_id\\\"\"; tail -n +2 \"$file\"; } > \"$temp_file\"
        mv \"$temp_file\" \"$file\"
        print_success \"Added ID [$article_id] to: $(basename \"$file\")\"
    fi
}

# Main execution
main() {
    print_header "AITechReviews - Assign Unique Article IDs"
    
    print_info "Scanning for articles without IDs..."
    echo ""
    
    local count=0
    local skipped=0
    
    # Find all article files
    while IFS= read -r file; do
        if ! has_article_id "$file"; then
            add_article_id "$file"
            ((count++))
        else
            ((skipped++))
        fi
    done < <(find "$CONTENT_DIR" -maxdepth 3 -name "*.md" -type f ! -name "_index.md")
    
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

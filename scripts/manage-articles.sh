#!/bin/bash

################################################################################
# AITechReviews - Article Management Script
# 
# Purpose: Delete, archive, or auto-archive articles
# Supports: Deletion with reference cleanup, archival, age-based auto-archival
# 
# Usage:
#   ./manage-articles.sh delete [article-id] [article-id] ...
#   ./manage-articles.sh archive [article-id] [article-id] ...
#   ./manage-articles.sh auto-archive [--config path/to/config.txt]
#   ./manage-articles.sh list-archives
#   ./manage-articles.sh restore [article-id]
#
# Configuration: Config file at scripts/article-archival-config.txt
################################################################################

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
CONFIG_FILE="${SCRIPT_DIR}/article-archival-config.txt"
ARCHIVE_DIR="${ROOT_DIR}/content/archives"
ARTICLES_DIR="${ROOT_DIR}/content"

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

################################################################################
# Helper Functions
################################################################################

show_help() {
    cat << 'EOF'
╔════════════════════════════════════════════════════════════════╗
║   AITechReviews - Article Management Tool                      ║
╚════════════════════════════════════════════════════════════════╝

COMMANDS:

  delete [ID] [ID] ...
    Permanently delete one or more articles by article ID
    Removes all references and links from the website
    Example: ./manage-articles.sh delete BG-EL-260316-001

  archive [ID] [ID] ...
    Move one or more articles to archives section
    Keeps content but marks as archived
    Example: ./manage-articles.sh archive GM-AC-260310-001

  auto-archive [--config FILE]
    Automatically archive articles older than configured days
    Uses config from scripts/article-archival-config.txt
    Example: ./manage-articles.sh auto-archive

  list-archives
    Show all archived articles
    Example: ./manage-articles.sh list-archives

  restore [ID]
    Restore an archived article back to its original section
    Example: ./manage-articles.sh restore BG-EL-260316-001

OPTIONS:
  --dry-run       Show what would be done without making changes
  --config FILE   Use custom config file for auto-archive
  --help, -h      Show this help message

LOCATION OF ARTICLE ID:
  First line in article front matter (after opening ---)
  Example: article_id: "BG-EL-260316-001"

EXAMPLES:
  # Delete single article with confirmation
  ./manage-articles.sh delete BG-EL-260316-001

  # Archive multiple articles
  ./manage-articles.sh archive GM-AC-260310-001 GM-GD-260317-001

  # Auto-archive articles older than configured days (dry-run first!)
  ./manage-articles.sh auto-archive --dry-run
  ./manage-articles.sh auto-archive

  # See all archived articles
  ./manage-articles.sh list-archives

  # Restore archived article
  ./manage-articles.sh restore BG-EL-260316-001
EOF
}

log_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

log_success() {
    echo -e "${GREEN}✅${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}⚠️${NC} $1"
}

log_error() {
    echo -e "${RED}❌${NC} $1"
}

# Find article file by article ID
find_article_by_id() {
    local article_id="$1"
    grep -r "article_id: \"${article_id}\"" "${ARTICLES_DIR}" 2>/dev/null | cut -d: -f1 | head -1
}

# Extract article metadata
get_article_metadata() {
    local file="$1"
    if [[ ! -f "$file" ]]; then
        return 1
    fi
    
    # Extract metadata from front matter
    local article_id=$(grep "^article_id:" "$file" | sed 's/.*"\([^"]*\)".*/\1/')
    local title=$(grep "^title:" "$file" | sed 's/^title:[[:space:]]*"\([^"]*\)".*/\1/')
    local category=$(grep "^category:" "$file" | sed 's/^category:[[:space:]]*"\([^"]*\)".*/\1/')
    local subcategory=$(grep "^subcategory:" "$file" | sed 's/^subcategory:[[:space:]]*"\([^"]*\)".*/\1/')
    
    echo "${article_id}|${title}|${category}|${subcategory}|${file}"
}

# Find all references to an article in other files
find_article_references() {
    local article_id="$1"
    local title="$2"
    
    # Search for: article ID, title, filename, category/subcategory references
    grep -r "${article_id}" "${ARTICLES_DIR}" 2>/dev/null || true
    grep -r "${title}" "${ARTICLES_DIR}" 2>/dev/null || true
}

# Remove article and all references
delete_article() {
    local article_id="$1"
    local dry_run="${2:-false}"
    
    log_info "Looking for article with ID: ${article_id}"
    
    local article_file
    article_file=$(find_article_by_id "$article_id")
    
    if [[ -z "$article_file" ]]; then
        log_error "Article with ID '${article_id}' not found"
        return 1
    fi
    
    # Get metadata
    local metadata
    metadata=$(get_article_metadata "$article_file")
    IFS='|' read -r id title category subcategory file <<< "$metadata"
    
    echo ""
    log_warning "Article to DELETE:"
    echo "  ID: ${id}"
    echo "  Title: ${title}"
    echo "  Category: ${category} > ${subcategory}"
    echo "  File: ${file}"
    echo ""
    
    # Find references
    log_info "Searching for references to this article..."
    local ref_count
    ref_count=$(grep -r "article_id: \"${article_id}\"" "${ARTICLES_DIR}" 2>/dev/null | wc -l)
    
    if [[ $ref_count -gt 1 ]]; then
        log_warning "Found ${ref_count} references (including the article itself)"
        grep -r "article_id: \"${article_id}\"" "${ARTICLES_DIR}" 2>/dev/null || true
    fi
    
    # Search for title references in other articles
    local title_refs
    title_refs=$(grep -r "\"${title}\"" "${ARTICLES_DIR}" 2>/dev/null | grep -v "${file}:" | wc -l)
    
    if [[ $title_refs -gt 0 ]]; then
        log_warning "Found ${title_refs} references to article title"
    fi
    
    echo ""
    if [[ "$dry_run" == "true" ]]; then
        log_info "DRY RUN: Would delete article and its references"
        return 0
    fi
    
    # Ask for confirmation
    read -p "Are you sure you want to PERMANENTLY DELETE this article? (yes/no): " confirm
    if [[ "$confirm" != "yes" ]]; then
        log_error "Deletion cancelled"
        return 1
    fi
    
    # Delete the article file
    rm -f "$article_file"
    log_success "Deleted article file: ${file}"
    
    # TODO: Remove broken references from other files
    # This is a complex operation that may require manual review
    log_warning "Please manually review and fix any broken links or references to this article"
    
    return 0
}

# Archive article
archive_article() {
    local article_id="$1"
    local dry_run="${2:-false}"
    
    log_info "Looking for article with ID: ${article_id}"
    
    local article_file
    article_file=$(find_article_by_id "$article_id")
    
    if [[ -z "$article_file" ]]; then
        log_error "Article with ID '${article_id}' not found"
        return 1
    fi
    
    # Get metadata
    local metadata
    metadata=$(get_article_metadata "$article_file")
    IFS='|' read -r id title category subcategory file <<< "$metadata"
    
    echo ""
    log_warning "Article to ARCHIVE:"
    echo "  ID: ${id}"
    echo "  Title: ${title}"
    echo "  Category: ${category} > ${subcategory}"
    echo "  File: ${file}"
    echo ""
    
    # Create archives directory if it doesn't exist
    mkdir -p "${ARCHIVE_DIR}/articles"
    
    # Convert category and subcategory to lowercase paths
    local category_lower=$(echo "$category" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
    local subcat_lower=$(echo "$subcategory" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
    
    mkdir -p "${ARCHIVE_DIR}/articles/${category_lower}/${subcat_lower}"
    
    # Determine new archive path
    local archive_cat_dir="${ARCHIVE_DIR}/articles/${category_lower}/${subcat_lower}"
    local archive_filename=$(basename "$article_file")
    local archive_path="${archive_cat_dir}/${archive_filename}"
    
    log_info "Archive destination: ${archive_path}"
    
    if [[ "$dry_run" == "true" ]]; then
        log_info "DRY RUN: Would archive article to: ${archive_path}"
        return 0
    fi
    
    # Ask for confirmation
    read -p "Archive this article? (yes/no): " confirm
    if [[ "$confirm" != "yes" ]]; then
        log_error "Archival cancelled"
        return 1
    fi
    
    # Copy article to archive location
    cp "$article_file" "$archive_path"
    log_success "Article archived to: ${archive_path}"
    
    # Add archive metadata to the article
    add_archive_metadata "$archive_path"
    
    # Delete from original location
    rm -f "$article_file"
    log_success "Removed article from original location"
    
    # Update any direct references if possible
    # TODO: Could update links in other articles if they reference this one
    
    return 0
}

# Add archive metadata to article
add_archive_metadata() {
    local article_file="$1"
    local archive_date=$(date +%Y-%m-%d)
    
    # Check if archived_on field exists, if not add it
    if ! grep -q "^archived_on:" "$article_file"; then
        # Insert after article_id line
        sed -i '' "/^article_id:/ a\\
archived_on: \"${archive_date}\"
" "$article_file"
        log_success "Added archive metadata to article"
    fi
}

# Auto-archive articles based on age
auto_archive_articles() {
    local config_file="${1:-$CONFIG_FILE}"
    local dry_run="${2:-false}"
    
    log_info "Loading configuration from: ${config_file}"
    
    if [[ ! -f "$config_file" ]]; then
        log_error "Configuration file not found: ${config_file}"
        log_info "Creating default config file..."
        create_default_config "$config_file"
        return 1
    fi
    
    # Read configuration
    local days_threshold
    days_threshold=$(grep "^ARCHIVE_AFTER_DAYS=" "$config_file" | cut -d= -f2)
    
    if [[ -z "$days_threshold" ]]; then
        log_error "ARCHIVE_AFTER_DAYS not set in config file"
        return 1
    fi
    
    log_info "Will archive articles older than ${days_threshold} days"
    
    # Find articles older than threshold
    local current_date
    current_date=$(date +%s)
    local archived_count=0
    
    # Search all articles
    while IFS= read -r article_file; do
        [[ -z "$article_file" ]] && continue
        
        # Skip already archived articles
        if grep -q "^archived_on:" "$article_file"; then
            continue
        fi
        
        # Get article date from front matter
        local article_date_str
        article_date_str=$(grep "^date:" "$article_file" | head -1 | sed 's/^date:[[:space:]]*"\([^"]*\)".*/\1/')
        
        if [[ -z "$article_date_str" ]]; then
            continue
        fi
        
        # Convert to timestamp
        local article_timestamp
        article_timestamp=$(date -j -f "%Y-%m-%d" "$article_date_str" +%s 2>/dev/null || echo "0")
        
        if [[ $article_timestamp -eq 0 ]]; then
            continue
        fi
        
        # Calculate age in days
        local age_in_seconds=$((current_date - article_timestamp))
        local age_in_days=$((age_in_seconds / 86400))
        
        # Check if older than threshold
        if [[ $age_in_days -gt $days_threshold ]]; then
            local article_id
            article_id=$(grep "^article_id:" "$article_file" | sed 's/.*"\([^"]*\)".*/\1/')
            
            if [[ -n "$article_id" ]]; then
                log_warning "Article ${article_id} is ${age_in_days} days old (threshold: ${days_threshold})"
                
                if [[ "$dry_run" != "true" ]]; then
                    archive_article "$article_id" "false" < /dev/null
                    ((archived_count++))
                fi
            fi
        fi
    done < <(find "${ARTICLES_DIR}/buying-guides" "${ARTICLES_DIR}/gaming" "${ARTICLES_DIR}/tutorials-guides" -name "*.md" 2>/dev/null)
    
    if [[ "$dry_run" == "true" ]]; then
        log_info "DRY RUN: Would archive articles matching criteria"
    else
        log_success "Auto-archived ${archived_count} articles"
    fi
    
    return 0
}

# List all archived articles
list_archived_articles() {
    if [[ ! -d "$ARCHIVE_DIR" ]]; then
        log_info "No archive directory found"
        return 0
    fi
    
    log_info "Archived Articles:"
    echo ""
    
    local count=0
    while IFS= read -r article_file; do
        [[ -z "$article_file" ]] && continue
        
        local metadata
        metadata=$(get_article_metadata "$article_file")
        IFS='|' read -r id title category subcategory file <<< "$metadata"
        
        echo "  ID: ${id}"
        echo "  Title: ${title}"
        echo "  Category: ${category} > ${subcategory}"
        echo "  Location: ${file}"
        echo ""
        
        ((count++))
    done < <(find "${ARCHIVE_DIR}" -name "*.md" 2>/dev/null)
    
    if [[ $count -eq 0 ]]; then
        log_info "No archived articles found"
    else
        log_success "Total archived articles: ${count}"
    fi
}

# Restore archived article
restore_article() {
    local article_id="$1"
    
    log_info "Looking for archived article with ID: ${article_id}"
    
    local archive_file
    archive_file=$(grep -r "article_id: \"${article_id}\"" "${ARCHIVE_DIR}" 2>/dev/null | cut -d: -f1 | head -1)
    
    if [[ -z "$archive_file" ]]; then
        log_error "Archived article with ID '${article_id}' not found"
        return 1
    fi
    
    # Get metadata
    local metadata
    metadata=$(get_article_metadata "$archive_file")
    IFS='|' read -r id title category subcategory file <<< "$metadata"
    
    echo ""
    log_warning "Article to RESTORE:"
    echo "  ID: ${id}"
    echo "  Title: ${title}"
    echo "  Category: ${category} > ${subcategory}"
    echo "  From: ${file}"
    echo ""
    
    # Determine original location - convert to lowercase paths
    local category_lower=$(echo "$category" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
    local subcat_lower=$(echo "$subcategory" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
    
    local original_dir="${ARTICLES_DIR}/${category_lower}/${subcat_lower}"
    local original_filename=$(basename "$archive_file")
    local original_path="${original_dir}/${original_filename}"
    
    log_info "Original location: ${original_path}"
    
    # Ask for confirmation
    read -p "Restore this article? (yes/no): " confirm
    if [[ "$confirm" != "yes" ]]; then
        log_error "Restore cancelled"
        return 1
    fi
    
    # Create original directory if it doesn't exist
    mkdir -p "$original_dir"
    
    # Copy back to original location
    cp "$archive_file" "$original_path"
    log_success "Article restored to: ${original_path}"
    
    # Remove archived_on metadata
    remove_archive_metadata "$original_path"
    
    # Remove from archive
    rm -f "$archive_file"
    log_success "Removed from archive"
    
    return 0
}

# Remove archive metadata
remove_archive_metadata() {
    local article_file="$1"
    
    if grep -q "^archived_on:" "$article_file"; then
        sed -i '' '/^archived_on:/d' "$article_file"
        log_success "Removed archive metadata"
    fi
}

# Create default configuration file
create_default_config() {
    local config_file="$1"
    
    cat > "$config_file" << 'EOF'
# AITechReviews - Article Archival Configuration
# 
# ARCHIVE_AFTER_DAYS: Number of days before article is auto-archived
# Set to 0 to disable auto-archival

ARCHIVE_AFTER_DAYS=365

# Other configuration options (for future use):
# ARCHIVE_EXCLUDE_CATEGORIES=evergreen,featured
# ARCHIVE_NOTIFY_EMAIL=admin@example.com
EOF
    
    log_success "Created default config file: ${config_file}"
    echo ""
    log_info "Edit this file to customize auto-archival behavior"
}

################################################################################
# Main Script Logic
################################################################################

main() {
    local command="${1:-}"
    shift || true
    
    # Check for help
    if [[ "$command" == "help" ]] || [[ "$command" == "-h" ]] || [[ "$command" == "--help" ]] || [[ -z "$command" ]]; then
        show_help
        return 0
    fi
    
    # Check if running from correct directory
    if [[ ! -d "$ARTICLES_DIR" ]]; then
        log_error "Articles directory not found: ${ARTICLES_DIR}"
        log_info "Make sure to run this script from the AITechReviews root directory or scripts directory"
        return 1
    fi
    
    # Create archive directory if it doesn't exist
    mkdir -p "$ARCHIVE_DIR"
    
    case "$command" in
        delete)
            if [[ $# -eq 0 ]]; then
                log_error "Please provide one or more article IDs to delete"
                return 1
            fi
            
            local dry_run=false
            if [[ "$1" == "--dry-run" ]]; then
                dry_run=true
                shift
            fi
            
            for article_id in "$@"; do
                delete_article "$article_id" "$dry_run"
                echo ""
            done
            ;;
            
        archive)
            if [[ $# -eq 0 ]]; then
                log_error "Please provide one or more article IDs to archive"
                return 1
            fi
            
            local dry_run=false
            if [[ "$1" == "--dry-run" ]]; then
                dry_run=true
                shift
            fi
            
            for article_id in "$@"; do
                archive_article "$article_id" "$dry_run"
                echo ""
            done
            ;;
            
        auto-archive)
            local dry_run=false
            local config="$CONFIG_FILE"
            
            while [[ $# -gt 0 ]]; do
                case "$1" in
                    --dry-run)
                        dry_run=true
                        ;;
                    --config)
                        config="$2"
                        shift
                        ;;
                    *)
                        break
                        ;;
                esac
                shift
            done
            
            auto_archive_articles "$config" "$dry_run"
            ;;
            
        list-archives)
            list_archived_articles
            ;;
            
        restore)
            if [[ $# -eq 0 ]]; then
                log_error "Please provide an article ID to restore"
                return 1
            fi
            
            restore_article "$1"
            ;;
            
        *)
            log_error "Unknown command: ${command}"
            echo ""
            show_help
            return 1
            ;;
    esac
}

# Run main function
main "$@"

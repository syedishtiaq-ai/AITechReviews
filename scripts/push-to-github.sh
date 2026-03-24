#!/bin/bash

################################################################################
# AITechReviews - Push to GitHub Script
# Safely push your website to GitHub repository
# Usage: bash scripts/push-to-github.sh
################################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

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

################################################################################
# Pre-flight Checks
################################################################################

print_header "AITechReviews - GitHub Push"

print_info "Running pre-flight checks..."
echo ""

# Check git is installed
if ! command -v git &> /dev/null; then
    print_error "Git is not installed. Please install Git first."
    exit 1
fi
print_success "Git is installed"

# Check we're in a git repository
if [ ! -d "$PROJECT_ROOT/.git" ]; then
    print_error "This directory is not a git repository"
    exit 1
fi
print_success "Git repository found"

# Check for uncommitted changes
if [ -n "$(git -C "$PROJECT_ROOT" status --porcelain)" ]; then
    print_warning "You have uncommitted changes"
    echo ""
    echo "Changes:"
    git -C "$PROJECT_ROOT" status --short
    echo ""
    read -p "Do you want to commit these changes first? (y/n): " COMMIT_CHOICE
    
    if [[ "$COMMIT_CHOICE" =~ ^[Yy]$ ]]; then
        read -p "Commit message: " COMMIT_MSG
        git -C "$PROJECT_ROOT" add -A
        git -C "$PROJECT_ROOT" commit -m "$COMMIT_MSG"
        print_success "Changes committed"
    else
        print_warning "Skipping commit. Uncommitted changes will not be pushed."
    fi
fi
print_success "Repository is clean"

echo ""
print_info "Current repository status:"
git -C "$PROJECT_ROOT" log --oneline -1
echo ""

################################################################################
# GitHub Configuration
################################################################################

print_header "GitHub Configuration"

# Check if remote is already configured
if git -C "$PROJECT_ROOT" remote get-url origin &> /dev/null; then
    EXISTING_REMOTE=$(git -C "$PROJECT_ROOT" remote get-url origin)
    print_info "Remote 'origin' already configured:"
    echo "  $EXISTING_REMOTE"
    echo ""
    read -p "Use this remote? (y/n): " USE_EXISTING
    
    if [[ "$USE_EXISTING" =~ ^[Yy]$ ]]; then
        GITHUB_REPO=$EXISTING_REMOTE
    else
        read -p "Enter GitHub repository URL (e.g., https://github.com/username/AITechReviews.git): " GITHUB_REPO
    fi
else
    read -p "Enter GitHub repository URL (e.g., https://github.com/username/AITechReviews.git): " GITHUB_REPO
fi

if [ -z "$GITHUB_REPO" ]; then
    print_error "GitHub repository URL is required"
    exit 1
fi

# Validate URL format
if [[ ! "$GITHUB_REPO" =~ ^https://github\.com/.*\.git$ ]] && [[ ! "$GITHUB_REPO" =~ ^git@github\.com:.*\.git$ ]]; then
    print_warning "URL format may be incorrect. Expected: https://github.com/username/repo.git or git@github.com:username/repo.git"
    read -p "Continue anyway? (y/n): " CONTINUE_CHOICE
    
    if [[ ! "$CONTINUE_CHOICE" =~ ^[Yy]$ ]]; then
        print_error "Aborted"
        exit 1
    fi
fi

# Add or update remote
if git -C "$PROJECT_ROOT" remote get-url origin &> /dev/null; then
    git -C "$PROJECT_ROOT" remote set-url origin "$GITHUB_REPO"
    print_success "Updated remote 'origin'"
else
    git -C "$PROJECT_ROOT" remote add origin "$GITHUB_REPO"
    print_success "Added remote 'origin'"
fi

echo ""

################################################################################
# Push to GitHub
################################################################################

print_header "Pushing to GitHub"

# Get the current branch
CURRENT_BRANCH=$(git -C "$PROJECT_ROOT" rev-parse --abbrev-ref HEAD)
print_info "Current branch: $CURRENT_BRANCH"
echo ""

print_info "About to push:"
echo "  Remote: $GITHUB_REPO"
echo "  Branch: $CURRENT_BRANCH"
echo ""

read -p "Proceed with push? (y/n): " PROCEED

if [[ ! "$PROCEED" =~ ^[Yy]$ ]]; then
    print_warning "Push cancelled by user"
    exit 0
fi

echo ""
print_info "Pushing to GitHub..."
echo ""

# Push to GitHub
if git -C "$PROJECT_ROOT" push -u origin "$CURRENT_BRANCH"; then
    print_success "Successfully pushed to GitHub!"
    echo ""
    print_info "Repository information:"
    echo "  URL: $GITHUB_REPO"
    echo "  Branch: $CURRENT_BRANCH"
    echo ""
    print_info "Next steps:"
    echo "  1. Visit: ${GITHUB_REPO%.git}"
    echo "  2. Configure repository settings on GitHub (if needed)"
    echo "  3. Set up GitHub Pages (if desired)"
    echo "  4. Enable CI/CD workflows (if needed)"
    echo ""
else
    print_error "Failed to push to GitHub"
    print_warning "Check your:"
    echo "  - GitHub credentials"
    echo "  - Repository URL"
    echo "  - Network connection"
    echo "  - SSH key configuration (if using SSH)"
    exit 1
fi

################################################################################
# Verify Push
################################################################################

print_header "Verification"

print_info "Verifying push..."
echo ""

# Check remote tracking branch
if git -C "$PROJECT_ROOT" rev-parse --verify "$CURRENT_BRANCH@{u}" &> /dev/null; then
    LOCAL_COMMIT=$(git -C "$PROJECT_ROOT" rev-parse HEAD)
    REMOTE_COMMIT=$(git -C "$PROJECT_ROOT" rev-parse origin/"$CURRENT_BRANCH")
    
    if [ "$LOCAL_COMMIT" = "$REMOTE_COMMIT" ]; then
        print_success "Local and remote branches are in sync"
        echo ""
        print_success "✨ Your website is now available on GitHub!"
        echo ""
        print_info "Repository details:"
        git -C "$PROJECT_ROOT" remote -v
    else
        print_warning "Local and remote branches differ"
    fi
else
    print_warning "Could not verify tracking branch"
fi

echo ""
print_info "Done!"

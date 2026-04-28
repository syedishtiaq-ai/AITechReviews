/**
 * Article Search, Filter, and Sort Functionality
 * Phase 2.3: Frontend Features
 */

class ArticleManager {
  constructor() {
    this.allArticles = [];
    this.filteredArticles = [];
    this.currentFilters = {
      search: '',
      categories: [],
      tags: [],
      sortBy: 'date-desc'
    };
    
    this.init();
  }

  /**
   * Initialize article manager
   */
  init() {
    this.collectArticles();
    this.setupEventListeners();
    this.applyDefaultSort();
  }

  /**
   * Collect all article data from DOM
   */
  collectArticles() {
    const articles = document.querySelectorAll('[data-article]');
    this.allArticles = Array.from(articles).map(article => ({
      element: article,
      id: article.getAttribute('data-article'),
      title: article.getAttribute('data-title') || '',
      slug: article.getAttribute('data-slug') || '',
      category: article.getAttribute('data-category') || '',
      tags: (article.getAttribute('data-tags') || '').split(',').filter(t => t.trim()),
      date: article.getAttribute('data-date') || '',
      excerpt: article.getAttribute('data-excerpt') || '',
      content: article.textContent.toLowerCase(),
      dateObj: new Date(article.getAttribute('data-date'))
    }));
    
    this.filteredArticles = [...this.allArticles];
  }

  /**
   * Setup event listeners for filters and search
   */
  setupEventListeners() {
    // Search input
    const searchInput = document.getElementById('article-search-input');
    if (searchInput) {
      searchInput.addEventListener('input', (e) => {
        this.currentFilters.search = e.target.value.toLowerCase();
        this.applyFilters();
      });
    }

    // Tag filters
    const tagFilters = document.querySelectorAll('[data-filter-tag]');
    tagFilters.forEach(filter => {
      filter.addEventListener('click', (e) => {
        e.preventDefault();
        const tag = filter.getAttribute('data-filter-tag');
        
        if (this.currentFilters.tags.includes(tag)) {
          this.currentFilters.tags = this.currentFilters.tags.filter(t => t !== tag);
          filter.classList.remove('active');
        } else {
          this.currentFilters.tags.push(tag);
          filter.classList.add('active');
        }
        this.applyFilters();
      });
    });

    // Sort dropdown
    const sortSelect = document.getElementById('sort-select');
    if (sortSelect) {
      sortSelect.addEventListener('change', (e) => {
        this.currentFilters.sortBy = e.target.value;
        this.applySort();
      });
    }

    // Clear filters button
    const clearBtn = document.getElementById('clear-filters-btn');
    if (clearBtn) {
      clearBtn.addEventListener('click', () => {
        this.clearAllFilters();
      });
    }
  }

  /**
   * Apply all active filters
   */
  applyFilters() {
    this.filteredArticles = this.allArticles.filter(article => {
      // Search filter
      if (this.currentFilters.search) {
        const searchTerm = this.currentFilters.search;
        const matchesSearch = 
          article.title.toLowerCase().includes(searchTerm) ||
          article.excerpt.toLowerCase().includes(searchTerm) ||
          article.content.includes(searchTerm);
        
        if (!matchesSearch) return false;
      }

      // Tag filter
      if (this.currentFilters.tags.length > 0) {
        const hasTags = this.currentFilters.tags.some(tag => article.tags.includes(tag));
        if (!hasTags) return false;
      }

      return true;
    });

    this.applySort();
    this.updateDisplay();
  }

  /**
   * Apply sorting to filtered articles
   */
  applySort() {
    const sortBy = this.currentFilters.sortBy;
    
    switch(sortBy) {
      case 'date-asc':
        this.filteredArticles.sort((a, b) => a.dateObj - b.dateObj);
        break;
      case 'title-asc':
        this.filteredArticles.sort((a, b) => a.title.localeCompare(b.title));
        break;
      case 'date-desc':
      default:
        this.filteredArticles.sort((a, b) => b.dateObj - a.dateObj);
        break;
    }
  }

  /**
   * Update article display (show/hide)
   */
  updateDisplay() {
    const articlesGrid = document.querySelector('.articles-grid');
    if (!articlesGrid) return;

    // Hide all articles
    this.allArticles.forEach(article => {
      article.element.style.display = 'none';
    });

    // Show filtered articles
    this.filteredArticles.forEach(article => {
      article.element.style.display = '';
    });

    // Update results count
    this.updateResultsCount();

    // Show "no results" message if needed
    this.updateNoResultsMessage();
  }

  /**
   * Update results count display
   */
  updateResultsCount() {
    const countElement = document.getElementById('articles-count');
    if (countElement) {
      const total = this.allArticles.length;
      const showing = this.filteredArticles.length;
      countElement.textContent = `Showing ${showing} of ${total} articles`;
    }
  }

  /**
   * Show/hide "no results" message
   */
  updateNoResultsMessage() {
    const articlesGrid = document.querySelector('.articles-grid');
    let noResultsDiv = document.getElementById('no-articles-message');

    if (this.filteredArticles.length === 0) {
      if (!noResultsDiv) {
        noResultsDiv = document.createElement('div');
        noResultsDiv.id = 'no-articles-message';
        noResultsDiv.className = 'no-articles';
        noResultsDiv.innerHTML = `
          <p><strong>No articles found</strong></p>
          <p>Try adjusting your filters or search terms.</p>
        `;
        articlesGrid.appendChild(noResultsDiv);
      }
      noResultsDiv.style.display = 'block';
    } else if (noResultsDiv) {
      noResultsDiv.style.display = 'none';
    }
  }

  /**
   * Clear all filters
   */
  clearAllFilters() {
    this.currentFilters = {
      search: '',
      categories: [],
      tags: [],
      sortBy: 'date-desc'
    };

    // Clear UI
    const searchInput = document.getElementById('article-search-input');
    if (searchInput) searchInput.value = '';

    document.querySelectorAll('[data-filter-tag].active').forEach(el => {
      el.classList.remove('active');
    });

    const sortSelect = document.getElementById('sort-select');
    if (sortSelect) sortSelect.value = 'date-desc';

    this.applyFilters();
  }

  /**
   * Apply default sort on page load
   */
  applyDefaultSort() {
    this.applySort();
    this.updateDisplay();
  }

  /**
   * Search by text (for programmatic use)
   */
  searchArticles(query) {
    this.currentFilters.search = query.toLowerCase();
    this.applyFilters();
  }

  /**
   * Filter by tag (for programmatic use)
   */
  filterByTag(tag) {
    if (this.currentFilters.tags.includes(tag)) {
      this.currentFilters.tags = this.currentFilters.tags.filter(t => t !== tag);
    } else {
      this.currentFilters.tags.push(tag);
    }
    this.applyFilters();
  }

  /**
   * Get current filter state
   */
  getFilterState() {
    return {
      ...this.currentFilters,
      resultCount: this.filteredArticles.length,
      totalCount: this.allArticles.length
    };
  }
}

/**
 * Initialize ArticleManager when DOM is ready
 */
document.addEventListener('DOMContentLoaded', () => {
  const articlesGrid = document.querySelector('.articles-grid');
  if (articlesGrid) {
    window.articleManager = new ArticleManager();
  }
});

/**
 * Related Articles Enhancement
 * Calculate and display related articles based on tags and category
 */
class RelatedArticles {
  constructor() {
    this.init();
  }

  init() {
    const relatedSection = document.getElementById('related-articles');
    if (!relatedSection) return;

    const currentArticle = this.getCurrentArticleData();
    if (!currentArticle) return;

    const related = this.findRelated(currentArticle);
    this.displayRelated(related, relatedSection);
  }

  /**
   * Get current article data from page
   */
  getCurrentArticleData() {
    const article = document.querySelector('[data-current-article]');
    if (!article) return null;

    return {
      id: article.getAttribute('data-current-article'),
      category: article.getAttribute('data-article-category') || '',
      tags: (article.getAttribute('data-article-tags') || '').split(',').filter(t => t.trim()),
      slug: article.getAttribute('data-article-slug') || ''
    };
  }

  /**
   * Find articles related to current one
   */
  findRelated(currentArticle) {
    const articles = document.querySelectorAll('[data-article]');
    const related = [];

    articles.forEach(article => {
      const id = article.getAttribute('data-article');
      if (id === currentArticle.id) return; // Skip current article

      const category = article.getAttribute('data-category');
      const tags = (article.getAttribute('data-tags') || '').split(',').filter(t => t.trim());

      // Score based on shared tags and category
      let score = 0;

      // Same category = 2 points
      if (category === currentArticle.category) score += 2;

      // Each shared tag = 1 point
      const sharedTags = tags.filter(tag => currentArticle.tags.includes(tag));
      score += sharedTags.length;

      if (score > 0) {
        related.push({
          element: article,
          score: score
        });
      }
    });

    // Sort by score and return top 3
    return related.sort((a, b) => b.score - a.score).slice(0, 3);
  }

  /**
   * Display related articles
   */
  displayRelated(related, container) {
    const list = container.querySelector('.related-articles-list');
    if (!list) return;

    // Clear existing items
    list.innerHTML = '';

    if (related.length === 0) {
      list.innerHTML = '<li class="no-related">No related articles found</li>';
      return;
    }

    related.forEach(item => {
      const title = item.element.getAttribute('data-title');
      const slug = item.element.getAttribute('data-slug');
      const category = item.element.getAttribute('data-category');
      const url = `/articles/${category.toLowerCase()}/${slug}/`;

      const li = document.createElement('li');
      li.className = 'related-article-item';
      li.innerHTML = `<a href="${url}">${title}</a>`;
      list.appendChild(li);
    });
  }
}

/**
 * Initialize RelatedArticles on page load
 */
document.addEventListener('DOMContentLoaded', () => {
  if (document.getElementById('related-articles')) {
    window.relatedArticles = new RelatedArticles();
  }
});

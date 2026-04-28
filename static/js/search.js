/**
 * Advanced Article Search with Filters
 * Provides client-side search with category, author, date, and tag filters
 */

class ArticleSearch {
  constructor() {
    this.articles = [];
    this.allArticles = [];
    this.filters = {
      query: '',
      categories: [],
      authors: [],
      tags: [],
      dateRange: { start: null, end: null }
    };
    
    this.init();
  }

  init() {
    try {
      // Use embedded search index from global variable
      if (typeof window.ARTICLE_INDEX !== 'undefined' && Array.isArray(window.ARTICLE_INDEX)) {
        this.allArticles = window.ARTICLE_INDEX;
        this.articles = [...this.allArticles];
        
        this.setupEventListeners();
        this.displayResults();
      } else {
        console.error('Search index not available');
        this.displayError('Search index not found');
      }
    } catch (error) {
      console.error('Search initialization failed:', error);
      this.displayError('Search functionality is unavailable');
    }
  }

  setupEventListeners() {
    // Search input
    const searchInput = document.getElementById('searchQuery');
    if (searchInput) {
      searchInput.addEventListener('input', (e) => {
        this.filters.query = e.target.value.toLowerCase();
        this.performSearch();
      });
    }

    // Category filters
    const categoryCheckboxes = document.querySelectorAll('.filter-category');
    categoryCheckboxes.forEach(checkbox => {
      checkbox.addEventListener('change', () => {
        this.filters.categories = Array.from(categoryCheckboxes)
          .filter(cb => cb.checked)
          .map(cb => cb.value);
        this.performSearch();
      });
    });

    // Author filters
    const authorCheckboxes = document.querySelectorAll('.filter-author');
    authorCheckboxes.forEach(checkbox => {
      checkbox.addEventListener('change', () => {
        this.filters.authors = Array.from(authorCheckboxes)
          .filter(cb => cb.checked)
          .map(cb => cb.value);
        this.performSearch();
      });
    });

    // Tag filters
    const tagCheckboxes = document.querySelectorAll('.filter-tag');
    tagCheckboxes.forEach(checkbox => {
      checkbox.addEventListener('change', () => {
        this.filters.tags = Array.from(tagCheckboxes)
          .filter(cb => cb.checked)
          .map(cb => cb.value);
        this.performSearch();
      });
    });

    // Date filters
    const startDateInput = document.getElementById('filterStartDate');
    const endDateInput = document.getElementById('filterEndDate');
    
    if (startDateInput) {
      startDateInput.addEventListener('change', (e) => {
        this.filters.dateRange.start = e.target.value;
        this.performSearch();
      });
    }

    if (endDateInput) {
      endDateInput.addEventListener('change', (e) => {
        this.filters.dateRange.end = e.target.value;
        this.performSearch();
      });
    }

    // Clear filters button
    const clearButton = document.getElementById('clearFilters');
    if (clearButton) {
      clearButton.addEventListener('click', () => this.clearFilters());
    }

    // Sort options
    const sortSelect = document.getElementById('sortResults');
    if (sortSelect) {
      sortSelect.addEventListener('change', (e) => {
        this.sortResults(e.target.value);
        this.displayResults();
      });
    }
  }

  performSearch() {
    this.articles = this.allArticles.filter(article => 
      this.matchesAllFilters(article)
    );
    this.displayResults();
    this.updateFilterCounts();
  }

  matchesAllFilters(article) {
    // Query match (title or excerpt)
    if (this.filters.query) {
      const query = this.filters.query;
      const matchesQuery = 
        article.title.toLowerCase().includes(query) ||
        article.excerpt.toLowerCase().includes(query) ||
        (article.tags && article.tags.some(tag => tag.toLowerCase().includes(query)));
      
      if (!matchesQuery) return false;
    }

    // Category match (using section field instead of category)
    if (this.filters.categories.length > 0) {
      if (!this.filters.categories.includes(article.section)) return false;
    }

    // Author match
    if (this.filters.authors.length > 0) {
      if (!this.filters.authors.includes(article.author)) return false;
    }

    // Tag match (any tag)
    if (this.filters.tags.length > 0) {
      if (!article.tags || !article.tags.some(tag => 
        this.filters.tags.includes(tag)
      )) return false;
    }

    // Date range match
    if (this.filters.dateRange.start || this.filters.dateRange.end) {
      const articleDate = new Date(article.date);
      
      if (this.filters.dateRange.start) {
        const startDate = new Date(this.filters.dateRange.start);
        if (articleDate < startDate) return false;
      }
      
      if (this.filters.dateRange.end) {
        const endDate = new Date(this.filters.dateRange.end);
        endDate.setHours(23, 59, 59, 999); // End of day
        if (articleDate > endDate) return false;
      }
    }

    return true;
  }

  sortResults(sortBy) {
    switch (sortBy) {
      case 'relevance':
        // Keep original order or sort by query match length
        if (this.filters.query) {
          this.articles.sort((a, b) => {
            const aRelevance = (a.title + ' ' + a.excerpt).toLowerCase().indexOf(this.filters.query);
            const bRelevance = (b.title + ' ' + b.excerpt).toLowerCase().indexOf(this.filters.query);
            return aRelevance - bRelevance;
          });
        }
        break;
      case 'newest':
        this.articles.sort((a, b) => new Date(b.date) - new Date(a.date));
        break;
      case 'oldest':
        this.articles.sort((a, b) => new Date(a.date) - new Date(b.date));
        break;
      case 'title-asc':
        this.articles.sort((a, b) => a.title.localeCompare(b.title));
        break;
      case 'title-desc':
        this.articles.sort((a, b) => b.title.localeCompare(a.title));
        break;
    }
  }

  displayResults() {
    const resultsContainer = document.getElementById('searchResults');
    if (!resultsContainer) return;

    const resultCount = document.getElementById('resultCount');
    if (resultCount) {
      resultCount.textContent = `${this.articles.length} result${this.articles.length !== 1 ? 's' : ''}`;
    }

    if (this.articles.length === 0) {
      resultsContainer.innerHTML = `
        <div class="search-no-results">
          <p>No articles found matching your criteria.</p>
          <p>Try adjusting your filters or search terms.</p>
        </div>
      `;
      return;
    }

    resultsContainer.innerHTML = this.articles.map(article => `
      <article class="search-result-item">
        <div class="result-header">
          <h3 class="result-title">
            <a href="${article.slug}">${this.highlightQuery(article.title)}</a>
          </h3>
          <span class="result-category">${article.category}</span>
        </div>
        
        <p class="result-excerpt">${this.highlightQuery(article.excerpt)}</p>
        
        <div class="result-meta">
          <span class="result-author">
            <strong>By:</strong> ${article.author}
          </span>
          <span class="result-date">
            ${new Date(article.date).toLocaleDateString('en-US', { 
              year: 'numeric', 
              month: 'long', 
              day: 'numeric' 
            })}
          </span>
          ${article.readingTime ? `<span class="result-reading-time">${article.readingTime}</span>` : ''}
        </div>

        ${article.tags && article.tags.length > 0 ? `
          <div class="result-tags">
            ${article.tags.map(tag => `<span class="tag">${tag}</span>`).join('')}
          </div>
        ` : ''}

        <a href="${article.slug}" class="result-link">Read More →</a>
      </article>
    `).join('');
  }

  highlightQuery(text) {
    if (!this.filters.query) return text;
    
    const regex = new RegExp(`(${this.escapeRegex(this.filters.query)})`, 'gi');
    return text.replace(regex, '<mark>$1</mark>');
  }

  escapeRegex(str) {
    return str.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  }

  updateFilterCounts() {
    // Update checkboxes to show counts
    document.querySelectorAll('.filter-category').forEach(checkbox => {
      const count = this.allArticles.filter(a => a.category === checkbox.value).length;
      const label = checkbox.nextElementSibling;
      if (label) {
        label.textContent = `${checkbox.value} (${count})`;
      }
    });

    document.querySelectorAll('.filter-author').forEach(checkbox => {
      const count = this.allArticles.filter(a => a.author === checkbox.value).length;
      const label = checkbox.nextElementSibling;
      if (label) {
        label.textContent = `${checkbox.value} (${count})`;
      }
    });
  }

  clearFilters() {
    this.filters = {
      query: '',
      categories: [],
      authors: [],
      tags: [],
      dateRange: { start: null, end: null }
    };

    // Reset checkboxes
    document.querySelectorAll('.filter-checkbox').forEach(checkbox => {
      checkbox.checked = false;
    });

    // Reset inputs
    const searchInput = document.getElementById('searchQuery');
    if (searchInput) searchInput.value = '';

    const startDateInput = document.getElementById('filterStartDate');
    if (startDateInput) startDateInput.value = '';

    const endDateInput = document.getElementById('filterEndDate');
    if (endDateInput) endDateInput.value = '';

    const sortSelect = document.getElementById('sortResults');
    if (sortSelect) sortSelect.value = 'relevance';

    this.articles = [...this.allArticles];
    this.displayResults();
    this.updateFilterCounts();
  }

  displayError(message) {
    const resultsContainer = document.getElementById('searchResults');
    if (resultsContainer) {
      resultsContainer.innerHTML = `<div class="search-no-results"><p>${message}</p></div>`;
    }
  }
}

// Initialize when DOM is ready
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', () => {
    new ArticleSearch();
  });
} else {
  new ArticleSearch();
}

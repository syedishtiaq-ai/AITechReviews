(() => {
  // Config: change this value to control how many posts are fetched per category
  // on the homepage carousels. We only want the top 5 articles and show 4
  // at a time so the 5th sits off-screen until the user clicks the right arrow.
  const TOP_N = 5;

  // simple debounce helper used by search input
  const debounce = (fn, delay = 300) => {
    let timeout;
    return (...args) => {
      clearTimeout(timeout);
      timeout = setTimeout(() => fn(...args), delay);
    };
  };

  
  /**
   * Fetch all pages from the search index (search-index.json)
   * This is used by the site-wide search popup and returns all searchable content.
   */
  const fetchAllPosts = async () => {
    try {
      const response = await fetch("/search/search-index.json");
      if (!response.ok) {
        console.warn("Could not fetch search index");
        return [];
      }
      const posts = await response.json();
      // Map search index fields to expected format for search handlers
      return posts.map(p => ({
        title: p.title,
        link: p.slug,
        content: p.excerpt,
        description: p.excerpt,
        section: p.section,
        author: p.author,
        date: p.date
      }));
    } catch (error) {
      console.error("Error fetching search index:", error);
      return [];
    }
  };

  /**
   * initialize the popup search box once we have the list of posts
   */
  const initSiteSearch = (posts) => {
    const searchInput = document.getElementById("searchInput");
    const siteSearchPopup = document.getElementById("siteSearchPopup");
    const clearSiteSearch = document.getElementById("clearSiteSearch");
    if (!searchInput || !siteSearchPopup) return;

    const renderResults = (items, term) => {
      // clear previous
      siteSearchPopup.innerHTML = "";
      if (!items.length) {
        const div = document.createElement("div");
        div.className = "no-results";
        div.textContent = "No results found";
        siteSearchPopup.appendChild(div);
        siteSearchPopup.style.display = "block";
        return;
      }
      const ul = document.createElement("ul");
      items.forEach((p) => {
        const li = document.createElement("li");
        const a = document.createElement("a");
        a.href = p.link || "#";
        a.textContent = p.title || p.item || "(no title)";
        li.appendChild(a);
        ul.appendChild(li);
      });
      siteSearchPopup.appendChild(ul);
      siteSearchPopup.style.display = "block";
    };

    const handleSiteSearch = ({ target }) => {
      const term = (target.value || "").trim().toLowerCase();
      if (!term) {
        siteSearchPopup.style.display = "none";
        return;
      }
      const results = posts.filter((p) => {
        const a = String(p.title || "").toLowerCase();
        const b = String(p.item || "").toLowerCase();
        const c = String(p.content || p.description || "").toLowerCase();
        return a.includes(term) || b.includes(term) || c.includes(term);
      });
      renderResults(results.slice(0, 20), term);
    };

    searchInput.addEventListener("input", debounce(handleSiteSearch, 250));

    if (clearSiteSearch) {
      clearSiteSearch.addEventListener("click", () => {
        searchInput.value = "";
        siteSearchPopup.style.display = "none";
      });
    }

    document.addEventListener("click", (e) => {
      if (!siteSearchPopup.contains(e.target) && e.target !== searchInput) {
        siteSearchPopup.style.display = "none";
      }
    });
  };

  /**
   * initialize the mobile search box once we have the list of posts
   */
  const initMobileSearch = (posts) => {
    const searchToggle = document.querySelector(".mobile-search-toggle");
    const searchBox = document.querySelector(".mobile-search-box");
    const mobileSearchInput = document.getElementById("mobileSearchInput");
    const mobileSearchPopup = document.getElementById("mobileSearchPopup");
    const mobileClearSearch = document.getElementById("mobileClearSearch");
    const mobileHeaderActions = document.querySelector(".mobile-header-actions");
    
    if (!searchToggle || !searchBox || !mobileSearchInput || !mobileSearchPopup) {
      console.warn("Mobile search elements not found");
      return;
    }

    const toggleSearchBox = (show) => {
      if (show) {
        searchBox.classList.add("active");
        searchBox.removeAttribute("hidden");
        mobileHeaderActions.classList.add("search-active");
        mobileSearchInput.focus();
        searchToggle.setAttribute("aria-expanded", "true");
      } else {
        searchBox.classList.remove("active");
        searchBox.setAttribute("hidden", "");
        mobileHeaderActions.classList.remove("search-active");
        mobileSearchPopup.setAttribute("hidden", "");
        mobileSearchPopup.style.display = "none";
        searchToggle.setAttribute("aria-expanded", "false");
      }
    };

    // Handle clicks on button and SVG
    searchToggle.addEventListener("click", (e) => {
      e.preventDefault();
      e.stopPropagation();
      const isOpen = searchBox.classList.contains("active");
      toggleSearchBox(!isOpen);
    });

    const renderResults = (items, term) => {
      // clear previous
      mobileSearchPopup.innerHTML = "";
      if (!items.length) {
        const div = document.createElement("div");
        div.className = "no-results";
        div.textContent = "No results found";
        mobileSearchPopup.appendChild(div);
        mobileSearchPopup.removeAttribute("hidden");
        mobileSearchPopup.style.display = "block";
        return;
      }
      const ul = document.createElement("ul");
      items.forEach((p) => {
        const li = document.createElement("li");
        const a = document.createElement("a");
        a.href = p.link || "#";
        a.textContent = p.title || p.item || "(no title)";
        li.appendChild(a);
        ul.appendChild(li);
      });
      mobileSearchPopup.appendChild(ul);
      mobileSearchPopup.removeAttribute("hidden");
      mobileSearchPopup.style.display = "block";
    };

    const handleMobileSearch = ({ target }) => {
      const term = (target.value || "").trim().toLowerCase();
      if (!term) {
        mobileSearchPopup.style.display = "none";
        mobileSearchPopup.setAttribute("hidden", "");
        return;
      }
      const results = posts.filter((p) => {
        const a = String(p.title || "").toLowerCase();
        const b = String(p.item || "").toLowerCase();
        const c = String(p.content || p.description || "").toLowerCase();
        return a.includes(term) || b.includes(term) || c.includes(term);
      });
      renderResults(results.slice(0, 20), term);
    };

    mobileSearchInput.addEventListener("input", debounce(handleMobileSearch, 250));

    if (mobileClearSearch) {
      mobileClearSearch.addEventListener("click", (e) => {
        e.preventDefault();
        e.stopPropagation();
        mobileSearchInput.value = "";
        mobileSearchPopup.style.display = "none";
        mobileSearchPopup.setAttribute("hidden", "");
        toggleSearchBox(false);
      });
    }

    // Close search when clicking outside (but not on toggle button)
    document.addEventListener("click", (e) => {
      const isClickOnToggle = e.target === searchToggle || searchToggle.contains(e.target);
      const isClickInSearchBox = searchBox.contains(e.target);
      
      if (!isClickInSearchBox && !isClickOnToggle) {
        toggleSearchBox(false);
      }
    });
  };


  const escapeHtml = (value) => {
    const text = String(value ?? "");
    return text
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;")
      .replace(/'/g, "&#39;");
  };

  const highlightHtml = (text, term) => {
    if (!term) return escapeHtml(text);
    const safe = escapeHtml(text);
    const escapedTerm = term.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
    const regex = new RegExp(`(${escapedTerm})`, "gi");
    return safe.replace(regex, "<mark>$1</mark>");
  };

  const makeLinkCell = (href, label) => {
    if (!href) return "";
    const safeHref = escapeHtml(href);
    const safeLabel = escapeHtml(label);
    return `<a href="${safeHref}" target="_self" rel="noopener">${safeLabel}</a>`;
  };

  const normalizeUrl = (value) => {
    const raw = String(value ?? "").trim();
    if (!raw) return "";
    if (/^https?:\/\//i.test(raw)) return raw;
    return `https://${raw}`;
  };

  const makeIconLinkCell = (href, kind) => {
    const url = normalizeUrl(href);
    if (!url) return "";

    const safeHref = escapeHtml(url);
    const iconSrc = kind === "youtube" ? "/images/ui/youtube.png" : "/images/ui/instagram.png";
    const alt = kind === "youtube" ? "YouTube" : "Instagram";
    return `
      <a class="global-table-iconlink" href="${safeHref}" target="_blank" rel="noopener noreferrer" aria-label="Open ${alt}">
        <img class="global-table-icon" src="${iconSrc}" alt="${alt}">
      </a>
    `.trim();
  };

  const renderRow = (post, term) => {
    const title = post?.title ?? "";
    const item = post?.item ?? "";
    const content = post?.content ?? post?.description ?? "";

    const readMore = post?.link ? `<a class="global-table-readmore" href="${escapeHtml(post.link)}">View All</a>` : "";

    const youtube = makeIconLinkCell(post?.youtube, "youtube");
    const insta = makeIconLinkCell(post?.insta ?? post?.instagram, "instagram");

    const titleCell = post?.link 
      ? `<a href="${escapeHtml(post.link)}">${highlightHtml(title, term)}</a>`
      : highlightHtml(title, term);

    return `
      <tr>
        <td class="js-cell" data-col="0">${titleCell}</td>
        <td class="js-cell" data-col="1">${highlightHtml(item, term)}</td>
        <td class="js-cell" data-col="2">${highlightHtml(content, term)}</td>
        <td>${readMore}</td>
        <td class="global-table-iconcell">${youtube}</td>
        <td class="global-table-iconcell">${insta}</td>
      </tr>
    `;
  };

  const createTableHTML = (pageTitle) => {
    const placeholderText = `Search ${pageTitle}...`;
    const selectId = `rows-per-page-${pageTitle.toLowerCase().replace(/[^a-z0-9]+/g, '-')}`;
    return `
<section class="global-table-container" data-articles-table>
  <div class="global-table-controls">
    <div class="global-table-search-wrapper">
      <input type="search" class="js-articles-table-search" placeholder="${escapeHtml(placeholderText)}">
      <button class="js-articles-table-clear" aria-label="Clear search">✕</button>
    </div>
    <div class="global-table-pagination-wrapper">
      <div class="global-table-rows-control">
        <label for="${selectId}">Rows:</label>
        <select class="js-articles-table-rows" id="${selectId}">
          <option value="10">10</option>
          <option value="25">25</option>
          <option value="50">50</option>
          <option value="100">100</option>
        </select>
      </div>
      <div class="global-table-nav-control">
        <button class="js-articles-table-prev" disabled>&larr; Prev</button>
        <span class="js-articles-table-pageinfo">Page 1 of 1</span>
        <button class="js-articles-table-next" disabled>Next &rarr;</button>
      </div>
    </div>
  </div>
  <div class="global-table-wrapper">
    <table class="global-table">
      <thead>
        <tr>
          <th class="is-sortable" data-sort-index="0">Title <span class="sort-indicator"></span></th>
          <th class="is-sortable" data-sort-index="1">Item <span class="sort-indicator"></span></th>
          <th class="is-sortable" data-sort-index="2">Description <span class="sort-indicator"></span></th>
          <th>Link</th>
          <th class="global-table-iconcell-header">YouTube</th>
          <th class="global-table-iconcell-header">Instagram</th>
        </tr>
      </thead>
      <tbody class="js-articles-table-body"></tbody>
    </table>
  </div>
  <div class="js-articles-table-no-results" hidden>
    <p>No results found.</p>
  </div>
</section>
  `;
  };

  const initArticlesTable = (section) => {
    let dataUrl = section.getAttribute("data-url") || "";

    const searchInput = section.querySelector(".js-articles-table-search");
    const clearBtn = section.querySelector(".js-articles-table-clear");
    const rowsSelect = section.querySelector(".js-articles-table-rows");
    const prevBtn = section.querySelector(".js-articles-table-prev");
    const nextBtn = section.querySelector(".js-articles-table-next");
    const pageInfo = section.querySelector(".js-articles-table-pageinfo");
    const noResults = section.querySelector(".js-articles-table-no-results");
    const tbody = section.querySelector(".js-articles-table-body");

    if (!tbody || !rowsSelect || !prevBtn || !nextBtn || !pageInfo) return;
    // Clear any existing content to prevent duplication on re-init
    tbody.innerHTML = "";

    let allPosts = [];
    let currentPage = 1;
    let rowsPerPage = parseInt(rowsSelect.value, 10) || 10;

    // Default sort: newest first (publish_date) so latest posts show on top.
    // Users can still click the table headers to sort by Title/Item/Description.
    let currentSortColumn = "date";
    let sortAscending = false;

    const getTerm = () => (searchInput?.value || "").trim().toLowerCase();

    const applySorting = (posts) => {
      const col = currentSortColumn;
      const dir = sortAscending ? 1 : -1;

      const parsePublishDateMs = (post) => {
        const raw = post?.publish_date ?? post?.publishDate ?? post?.date ?? "";
        const ms = Date.parse(String(raw));
        return Number.isFinite(ms) ? ms : 0;
      };

      const key = (post) => {
        if (col === "date") return parsePublishDateMs(post);
        if (col === 0) return String(post?.title ?? "").toLowerCase();
        if (col === 1) return String(post?.item ?? "").toLowerCase();
        if (col === 2) return String(post?.content ?? post?.description ?? "").toLowerCase();
        return "";
      };

      return posts.slice().sort((a, b) => {
        const av = key(a);
        const bv = key(b);

        // Numeric compare for dates.
        if (col === "date") {
          if (av < bv) return -1 * dir;
          if (av > bv) return 1 * dir;

          // Tie-breaker for consistent ordering.
          const at = String(a?.title ?? "").toLowerCase();
          const bt = String(b?.title ?? "").toLowerCase();
          if (at < bt) return -1;
          if (at > bt) return 1;
          return 0;
        }

        if (av < bv) return -1 * dir;
        if (av > bv) return 1 * dir;
        return 0;
      });
    };

    const applyFiltering = (posts) => {
      const term = getTerm();
      if (!term) return posts;

      return posts.filter((p) => {
        const a = String(p?.title ?? "").toLowerCase();
        const b = String(p?.item ?? "").toLowerCase();
        const c = String(p?.content ?? p?.description ?? "").toLowerCase();
        return a.includes(term) || b.includes(term) || c.includes(term);
      });
    };

    const updateSortIndicators = () => {
      section.querySelectorAll("th.is-sortable").forEach((th) => {
        const indicator = th.querySelector(".sort-indicator");
        if (indicator) indicator.textContent = "";
        th.removeAttribute("aria-sort");
      });

      if (typeof currentSortColumn !== "number") return;

      const active = section.querySelector(`th.is-sortable[data-sort-index="${currentSortColumn}"]`);
      if (!active) return;

      const indicator = active.querySelector(".sort-indicator");
      if (indicator) indicator.textContent = sortAscending ? "▲ A→Z" : "▼ Z→A";
      active.setAttribute("aria-sort", sortAscending ? "ascending" : "descending");
    };

    const renderEmptyRow = (message) => {
      tbody.innerHTML = `
        <tr class="global-table-empty">
          <td colspan="6" class="global-table-empty-cell">${escapeHtml(message)}</td>
        </tr>
      `;

      if (noResults) noResults.hidden = true;
      pageInfo.textContent = "Page 1 of 1";
      prevBtn.disabled = true;
      nextBtn.disabled = true;
      updateSortIndicators();
    };

    const render = () => {
      const term = getTerm();
      const filtered = applyFiltering(allPosts);
      const sorted = applySorting(filtered);

      const totalRows = sorted.length;
      if (totalRows === 0) {
        renderEmptyRow("No results found");
        return;
      }


      const totalPages = Math.max(1, Math.ceil(totalRows / rowsPerPage));
      currentPage = Math.min(currentPage, totalPages);

      const start = (currentPage - 1) * rowsPerPage;
      const pageRows = sorted.slice(start, start + rowsPerPage);

      tbody.innerHTML = pageRows.map((p) => renderRow(p, term)).join("");

      pageInfo.textContent = `Page ${currentPage} of ${totalPages}`;
      prevBtn.disabled = currentPage <= 1 || totalRows === 0;
      nextBtn.disabled = currentPage >= totalPages || totalRows === 0;

      if (noResults) noResults.hidden = true;

      updateSortIndicators();
    };

    const attachSorting = () => {
      section.querySelectorAll("th.is-sortable").forEach((th) => {
        th.addEventListener("click", () => {
          const idx = parseInt(th.getAttribute("data-sort-index") || "0", 10);
          sortAscending = currentSortColumn === idx ? !sortAscending : true;
          currentSortColumn = idx;
          currentPage = 1;
          render();
        });
      });
    };

    const attachControls = () => {
      if (searchInput) {
        searchInput.addEventListener("input", () => {
          currentPage = 1;
          render();
        });
      }

      if (clearBtn && searchInput) {
        clearBtn.addEventListener("click", () => {
          searchInput.value = "";
          currentPage = 1;
          render();
        });
      }

      rowsSelect.addEventListener("change", () => {
        rowsPerPage = parseInt(rowsSelect.value, 10) || 10;
        currentPage = 1;
        render();
      });

      prevBtn.addEventListener("click", () => {
        if (currentPage > 1) {
          currentPage -= 1;
          render();
        }
      });

      nextBtn.addEventListener("click", () => {
        currentPage += 1;
        render();
      });
    };

    const load = async () => {
      try {
        const cleanPath = window.location.pathname.replace(/(\/index)?\.html$/, "").replace(/\/+$/, "").toLowerCase();
        let urls = [];
        if (cleanPath.endsWith("/buying-guides") || cleanPath.endsWith("/tutorials-guides")) {
          const navLinks = document.querySelectorAll(".nav-links a");
          const seen = new Set();
          navLinks.forEach((link) => {
            const href = (link.getAttribute("href") || "").toLowerCase().replace(/\/+$/, "");
            if ((href.includes("/buying-guides/") || href.includes("/tutorials-guides/")) && !href.endsWith("/buying-guides") && !href.endsWith("/tutorials-guides")) {
              seen.add(href + "/posts.json");
            }
          });
          urls = Array.from(seen);
        } else {
          urls = [cleanPath + "/posts.json"];
        }
        if (urls.length === 0 && dataUrl) urls = [dataUrl];
        if (urls.length === 0) {
          allPosts = [];
          renderEmptyRow("No results found");
          return;
        }
        const responses = await Promise.all(urls.map((u) =>
          fetch(u + "?t=" + Date.now(), { cache: "no-store" })
          .then(async (r) => {
            if (r.ok) {
              const text = await r.text();
              // Handle empty or malformed JSON gracefully
              try { return text ? JSON.parse(text) : []; } catch (e) { throw new Error("Invalid JSON"); }
            }
            throw new Error(`${r.status} ${r.statusText}`);
          })
          .catch((err) => { 
            console.error(`Error fetching ${u}:`, err); 
            return { error: err.message, url: u };
          })
        ));

        // Separate valid arrays from error objects
        const validData = responses.filter(r => Array.isArray(r));
        const errors = responses.filter(r => r && r.error);

        if (validData.length === 0 && errors.length > 0) {
           // If all fetches failed, show the error of the first one in the table
           renderEmptyRow(`Error loading data: ${errors[0].error}`);
           return;
        }

        const flat = validData.flat();
        const seenLinks = new Set();
        allPosts = flat.filter((p) => {
          if (!p.link) return false;
          if (seenLinks.has(p.link)) return false;
          seenLinks.add(p.link);
          return true;
        });
      } catch (e) {
        // eslint-disable-next-line no-console
        console.error(e);
        allPosts = [];
      } finally {
        render();
      }
    };

    attachSorting();
    attachControls();
    load();
  };

  document.addEventListener("DOMContentLoaded", () => {
    // Remove "Home Furniture" from navigation menu if present
    const navItems = document.querySelectorAll(".nav-links > li");
    navItems.forEach((li) => {
      const link = li.querySelector("a");
      if (link && (link.href.includes("home-furniture") || /home[- ]furniture/i.test(link.textContent))) {
        li.remove();
      }
      if (link && (link.href.includes("buying-guides") || /product[- ]reviews/i.test(link.textContent))) {
        link.href = link.href.replace("buying-guides", "buying-guides");
        link.textContent = "Buying Guides";
      }
    });

    // Inject "Tutorials & Guides" into the main navigation
    const navList = document.querySelector(".nav-links");
    if (navList && !Array.from(navList.children).some(li => li.textContent.includes("Tutorials"))) {
      const li = document.createElement("li");
      const a = document.createElement("a");
      a.href = "/tutorials-guides/";
      a.textContent = "Tutorials & Guides";
      li.appendChild(a);

      // Add submenu
      const toggle = document.createElement("button");
      toggle.className = "submenu-toggle";
      toggle.setAttribute("aria-expanded", "false");
      toggle.setAttribute("aria-label", "Toggle submenu");
      li.appendChild(toggle);

      const ul = document.createElement("ul");
      ul.className = "dropdown";

      const subItems = [
        { 
          name: "Software Tutorials", 
          url: "/tutorials-guides/software/",
          children: []
        },
        { 
          name: "Repair Guides", 
          url: "/tutorials-guides/repair-guides/",
          children: []
        }
      ];

      subItems.forEach(item => {
        const subLi = document.createElement("li");
        const subA = document.createElement("a");
        subA.href = item.url;
        subA.textContent = item.name;
        subLi.appendChild(subA);

        if (item.children) {
          subLi.classList.add("has-children");

          const subToggle = document.createElement("button");
          subToggle.className = "submenu-toggle";
          subToggle.setAttribute("aria-expanded", "false");
          subToggle.setAttribute("aria-label", "Toggle submenu");
          subLi.appendChild(subToggle);

          const subUl = document.createElement("ul");
          subUl.className = "dropdown";

          item.children.forEach(child => {
            const childLi = document.createElement("li");
            const childA = document.createElement("a");
            childA.href = child.url;
            childA.textContent = child.name;
            childLi.appendChild(childA);
            subUl.appendChild(childLi);
          });
          subLi.appendChild(subUl);
        }

        ul.appendChild(subLi);
      });

      li.appendChild(ul);

      // Place between Gaming and How It Works (insert before How It Works)
      const howItWorks = Array.from(navList.children).find(child => /how[- ]it[- ]works/i.test(child.textContent));
      if (howItWorks) {
        navList.insertBefore(li, howItWorks);
      } else {
        navList.appendChild(li);
      }
    }

    // Broadly rename "Buying Guides" to "Buying Guides" in specific UI areas
    // (Breadcrumbs, Mobile Nav, Page Titles)
    const textReplacements = document.querySelectorAll(".breadcrumbs a, .breadcrumb a, .mobile-nav a, h1");
    textReplacements.forEach((el) => {
      if (/^product[- ]reviews$/i.test(el.textContent.trim())) {
        el.textContent = "Buying Guides";
      }
      if (el.tagName === "A" && el.href.includes("buying-guides")) {
        el.href = el.href.replace("buying-guides", "buying-guides");
      }
    });

    // Inject "Tutorials & Guides" into "What are you looking for?" section on Homepage
    (() => {
       const searchHeading = Array.from(document.querySelectorAll('h2, h3, h4'))
         .find(h => /what are you looking for/i.test(h.textContent));
       
       if (!searchHeading) return;

       const section = searchHeading.closest('section') || searchHeading.parentElement;
       if (!section) return;

       // Find the 'Gaming' card to use as a template
       const allLinks = Array.from(section.querySelectorAll('a'));
       const gamingLink = allLinks.find(a => a.getAttribute('href') && a.getAttribute('href').includes('/gaming'));
       
       if (!gamingLink) return;

       let card = gamingLink;
       let grid = card.parentElement;
       
       // Traverse up to find the grid container
       while (grid && grid !== section && grid.children.length < 2) {
          card = grid;
          grid = grid.parentElement;
       }
       
       if (!grid || !card || grid.textContent.includes("Tutorials")) return;

       const newCard = card.cloneNode(true);
       
       // Update text
       const walker = document.createTreeWalker(newCard, NodeFilter.SHOW_TEXT);
       let node;
       while(node = walker.nextNode()) {
          if (/Gaming/i.test(node.nodeValue)) {
             node.nodeValue = "Tutorials & Guides";
          }
       }
       
       const newLink = newCard.tagName === 'A' ? newCard : newCard.querySelector('a');
       if (newLink) newLink.href = "/tutorials-guides/";
       
       const img = newCard.querySelector('img');
       if (img) {
          img.src = "/images/categories/tutorials.jpg"; 
          img.alt = "Tutorials & Guides";
          delete img.dataset.checked; // allow error handler to run again if image missing
       }

       grid.appendChild(newCard);
    })();

    if (document.getElementById('postContainer')) {
      initHomePage();
    }
    // Table injection disabled - tables are no longer needed on content pages
    // All pages now use proper grid/list layouts instead of dynamic tables

    document
      .querySelectorAll("[data-articles-table]")
      .forEach((section) => initArticlesTable(section));

    // global handler: if any <img> fails to load, swap in the placeholder svg
    // (covers unexpected missing files or faulty URLs anywhere on the page).
    document.addEventListener('error', function(e) {
      const tgt = e.target;
      if (tgt && tgt.tagName === 'IMG' && !tgt.dataset.checked) {
        // avoid infinite loop if placeholder also missing
        tgt.dataset.checked = '1';
        tgt.src = '/images/ui/placeholder.svg';
      }
    }, true);

    // ---------- homepage dynamic sections ----------------
    const initHomePage = () => {
      const postContainer = document.getElementById("postContainer");
      if (!postContainer) return;

      // Read desired homepage order (injected by Hugo into the DOM).
      let desiredOrder = [];
      try {
        const raw = postContainer.dataset.homeOrder || "";
        if (raw) desiredOrder = JSON.parse(raw);
      } catch (e) {
        // fall back to empty order which preserves nav order
        desiredOrder = [];
      }

      // collect main category links from the navbar
      const navLinks = document.querySelectorAll(".nav-links > li > a");
      const categories = [];
      navLinks.forEach((link) => {
        const href = link.getAttribute("href") || "";
        const text = link.textContent.trim();
        // skip obvious non-content links
        if (!href || href === "/" || href === "/index.html") return;
        if (/contact|about|how[- ]it[- ]works|site[- ]map|home[- ]furniture/i.test(text)) return;
        categories.push({ href, text });
      });

      const fetchJson = (url) => fetch(url + "?t=" + Date.now())
        .then((r) => (r.ok ? r.json() : []))
        .then((data) => (Array.isArray(data) ? data : []))
        .catch(() => []);

      const jsonUrlForHref = (href) => {
        let path = href;
        if (!path.endsWith("/")) path += "/";
        return path + "posts.json";
      };

      const wireCarousels = () => {
        postContainer.querySelectorAll(".carousel").forEach((carousel) => {
          const track = carousel.querySelector(".carousel-track");
          if (!track) return;

          const cards = Array.from(track.querySelectorAll('.card'));
          if (!cards.length) return;

          const leftBtn = carousel.querySelector('.carousel-btn.left');
          const rightBtn = carousel.querySelector('.carousel-btn.right');

          // compute number of visible cards based on carousel width
          const computeVisibleCount = () => {
            const w = carousel.clientWidth;
            if (w < 600) return 1;
            if (w < 900) return 2;
            if (w < 1200) return 3;
            return 4;
          };

          const gap = () => parseFloat(getComputedStyle(track).gap) || 16;

          const computeCardWidth = (visibleCount) => {
            const totalGap = Math.max(0, visibleCount - 1) * gap();
            return Math.floor((carousel.clientWidth - totalGap) / visibleCount);
          };

          let visibleCount = computeVisibleCount();
          let cardWidth = computeCardWidth(visibleCount);
          let index = 0; // first visible card index

          const applyCardWidths = () => {
            visibleCount = computeVisibleCount();
            cardWidth = computeCardWidth(visibleCount);
            cards.forEach((c) => {
              c.style.flex = `0 0 ${cardWidth}px`;
              c.style.maxWidth = `${cardWidth}px`;
            });

            const totalWidth = cards.length * (cardWidth + gap()) - gap();
            track.style.width = `${Math.max(totalWidth, carousel.clientWidth)}px`;
          };

          const waitForImages = () => {
            const imgs = Array.from(track.querySelectorAll('img'));
            return Promise.all(
              imgs.map((img) =>
                new Promise((res) => {
                  if (img.complete) return res();
                  img.addEventListener('load', res, { once: true });
                  img.addEventListener('error', res, { once: true });
                })
              )
            );
          };

          const clampIndex = () => {
            const maxIndex = Math.max(0, cards.length - visibleCount);
            if (index < 0) index = 0;
            if (index > maxIndex) index = maxIndex;
          };

          const scrollToIndex = (newIndex, smooth = true) => {
            index = newIndex;
            clampIndex();
            const translate = Math.min(0, -index * (cardWidth + gap()));
            if (smooth) {
              track.style.transition = 'transform 300ms ease';
            } else {
              track.style.transition = 'none';
            }
            track.style.transform = `translateX(${translate}px)`;
            // clear transition after it ends so later instant moves are immediate
            if (smooth) {
              setTimeout(() => {
                track.style.transition = '';
              }, 350);
            }
          };

          const leftHandler = (e) => {
            e && e.preventDefault();
            scrollToIndex(index - visibleCount);
          };

          const rightHandler = (e) => {
            e && e.preventDefault();
            scrollToIndex(index + visibleCount);
          };

          // Note: mouse wheel scrolling inside the carousel is intentionally
          // disabled to satisfy the requirement. The wheel handler was removed
          // so only arrow buttons control carousel movement.

          const replaceWithListener = (el, listener) => {
            if (!el) return;
            try {
              // some buttons may be re-created by other logic; ensure single listener
              el.removeEventListener('click', el._heroListener || (() => {}));
            } catch (err) {}
            el.addEventListener('click', listener);
            el._heroListener = listener;
          };

          // initial sizing after images loaded
          waitForImages().then(() => {
            applyCardWidths();
            scrollToIndex(index, false);
          });

          // attach handlers to buttons (if present)
          if (leftBtn) replaceWithListener(leftBtn, leftHandler);
          if (rightBtn) replaceWithListener(rightBtn, rightHandler);

          // Ensure the track behaves as a non-wrapping flex row so cards never
          // drop to a new row. This keeps the 5th card inline (off-screen)
          // when only 4 are visible.
          track.classList.remove('grid');
          track.style.display = 'flex';
          track.style.flexWrap = 'nowrap';
          track.style.alignItems = 'stretch';

          // on resize, recompute widths and keep index valid
          let resizeTimeout = null;
          const onResize = () => {
            clearTimeout(resizeTimeout);
            resizeTimeout = setTimeout(() => {
              const prevVisible = visibleCount;
              applyCardWidths();
              // if visibleCount changed, keep the current first visible card in view
              if (prevVisible !== visibleCount) {
                // adjust index so the currently visible range still contains the same first card
                clampIndex();
              }
              scrollToIndex(index, false);
            }, 120);
          };
          window.addEventListener('resize', onResize);
        });
      };

      const buildSections = (postsByCategory) => {
        postContainer.innerHTML = Object.keys(postsByCategory)
          .map((category) => {
            const posts = postsByCategory[category];
            if (!posts || !posts.length) return "";
            const cardsHtml = posts
              .map((p) => {
                // use SVG placeholder; if actual image URL 404s we'll replace on error
                const imgPath = p.image ? escapeHtml(p.image) : "/images/ui/placeholder.svg";
                const img = imgPath;
                const title = escapeHtml(p.title || "");
                const link = escapeHtml(p.link || "#");
                const desc = escapeHtml((p.description || p.content || "").slice(0, 120));
                return `
          <div class="card">
            <img src="${img}" alt="${title}" onerror="this.onerror=null;this.src='/images/ui/placeholder.svg';">
            <div class="card-content">
              <h3 class="card-title"><a href="${link}">${title}</a></h3>
              <p class="card-desc">${desc}${(p.description || p.content || "").length > 120 ? "..." : ""}</p>
              <a href="${link}" class="read-more">Read More</a>
            </div>
          </div>`;
              })
              .join("");
            const groupId = `group-${category.replace(/[^a-z0-9]+/gi, "-").replace(/^-+|-+$/g, "").toLowerCase()}`;
            return `
        <section class="category-block post-group" id="${groupId}">
          <div class="post-group-header">
            <h2>${escapeHtml(category)}</h2>
          </div>
          <div class="carousel" data-target="${groupId}">
            <button class="carousel-btn left" data-target="${groupId}" aria-label="Scroll left">&larr;</button>
            <div class="grid carousel-track">
              ${cardsHtml}
            </div>
            <button class="carousel-btn right" data-target="${groupId}" aria-label="Scroll right">&rarr;</button>
          </div>
        </section>`;
          })
          .join("");

        // Enable scrolling via arrows and wheel.
        wireCarousels();
      };

      Promise.all(
        categories.map((cat) =>
          fetchJson(jsonUrlForHref(cat.href)).then((posts) => {
            // sort newest first
            const sorted = (posts || []).slice().sort((a, b) => {
              const da = new Date(a.publish_date || 0).getTime();
              const db = new Date(b.publish_date || 0).getTime();
              return db - da;
            });
            return { category: cat.text, posts: sorted.slice(0, TOP_N) };
          })
        )
      ).then((arr) => {
        const map = {};
        arr.forEach(({ category, posts }) => {
          map[category] = posts;
        });

        // If a desired order is provided, build an ordered map where
        // specified names appear first, then any remaining categories.
        const orderedMap = {};
        const included = new Set();
        if (Array.isArray(desiredOrder) && desiredOrder.length) {
          desiredOrder.forEach((name) => {
            if (map[name]) {
              orderedMap[name] = map[name];
              included.add(name);
            }
          });
        }

        Object.keys(map).forEach((name) => {
          if (!included.has(name)) orderedMap[name] = map[name];
        });

        buildSections(orderedMap);
      })
      .catch((err) => {
        console.error(err);
        if (postContainer) postContainer.innerHTML = "";
      });
    };

    if (document.getElementById('postContainer')) {
      initHomePage();
    }

    // prepare site-wide search once we know the DOM is available
    fetchAllPosts()
      .then((posts) => {
        initSiteSearch(posts);
        initMobileSearch(posts);
      })
      .catch((err) => {
        console.error("Error in site search setup:", err);
      });

    // Mobile menu toggle + dropdown behavior with accessibility and submenu panels
    (function initMobileMenu() {
      const toggle = document.querySelector('.mobile-menu-toggle');
      const mobileNav = document.querySelector('.mobile-nav');
      if (!toggle || !mobileNav) return;

      const panelClose = mobileNav.querySelector('.panel-close');
      const panelBack = mobileNav.querySelector('.panel-back');
      const panelTitle = mobileNav.querySelector('.panel-title');
      const panelRoot = mobileNav.querySelector('.panel-root');
      const panelSub = mobileNav.querySelector('.panel-sub');

      let lastFocused = null;
      let keydownHandler = null;
      let subStack = [];

      const focusableSelector = 'a[href], button:not([disabled]), [tabindex]:not([tabindex="-1"])';

      const trapFocus = (enable) => {
        if (!enable) {
          if (keydownHandler) document.removeEventListener('keydown', keydownHandler);
          keydownHandler = null;
          return;
        }

        keydownHandler = (e) => {
          if (e.key === 'Escape') {
            closeMenu();
            return;
          }
          if (e.key !== 'Tab') return;
          const focusable = Array.from(mobileNav.querySelectorAll(focusableSelector)).filter((el) => el.offsetParent !== null);
          if (!focusable.length) return;
          const first = focusable[0];
          const last = focusable[focusable.length - 1];
          if (e.shiftKey) {
            if (document.activeElement === first) {
              e.preventDefault();
              last.focus();
            }
          } else {
            if (document.activeElement === last) {
              e.preventDefault();
              first.focus();
            }
          }
        };

        document.addEventListener('keydown', keydownHandler);
      };

      const openMenu = () => {
        subStack = [];
        lastFocused = document.activeElement;
        toggle.setAttribute('aria-expanded', 'true');
        mobileNav.classList.add('open');
        mobileNav.setAttribute('aria-hidden', 'false');
        document.body.style.overflow = 'hidden';
        trapFocus(true);
        // focus first link
        const first = mobileNav.querySelector(focusableSelector);
        if (first) first.focus();
      };

      const closeMenu = () => {
        toggle.setAttribute('aria-expanded', 'false');
        mobileNav.classList.remove('open');
        mobileNav.setAttribute('aria-hidden', 'true');
        document.body.style.overflow = '';
        trapFocus(false);
        // close any open submenu panel
        panelRoot.classList.remove('shift-left');
        panelRoot.classList.remove('hidden');
        panelSub.classList.remove('open');
        panelSub.innerHTML = '';
        panelTitle.textContent = 'Menu';
        if (lastFocused) lastFocused.focus();
        subStack = [];
      };

      toggle.addEventListener('click', (e) => {
        e.preventDefault();
        const isOpen = toggle.getAttribute('aria-expanded') === 'true';
        if (isOpen) closeMenu(); else openMenu();
      });

      if (panelClose) panelClose.addEventListener('click', (e) => { e.preventDefault(); closeMenu(); });

      // header-level back button: returns from submenu to root menu
      if (panelBack) {
        panelBack.addEventListener('click', (e) => {
          e.preventDefault();
          // slide root back into place and hide submenu
          panelRoot.classList.remove('shift-left');
          panelRoot.classList.remove('hidden');
          panelSub.classList.remove('open');
          panelSub.setAttribute('aria-hidden', 'true');
          panelSub.innerHTML = '';
          panelTitle.textContent = 'Menu';
          try { panelBack.setAttribute('hidden', ''); panelBack.setAttribute('aria-hidden', 'true'); } catch (err) {}
          // reset any expanded chevrons
          try { const srcBtn = mobileNav.querySelector('.submenu-toggle[aria-expanded="true"]'); if (srcBtn) srcBtn.setAttribute('aria-expanded', 'false'); } catch (err) {}
          const firstRoot = panelRoot.querySelector(focusableSelector);
          if (firstRoot) firstRoot.focus();
        });
      }

      // close mobile menu when clicking outside
      document.addEventListener('click', (e) => {
        if (!mobileNav.contains(e.target) && !toggle.contains(e.target)) {
          closeMenu();
        }
      });

      // Handle first-level menu items only (root panel)
      panelRoot.addEventListener('click', (e) => {
        const btn = e.target.closest('.submenu-toggle');
        if (!btn) return;
        e.preventDefault();
        e.stopPropagation();
        const li = btn.closest('li');
        if (!li) return;
        const anchor = li.querySelector('a');
        
        // Find dropdown
        let submenu = li.querySelector('.dropdown');
        if (!submenu) return;

        const cloned = submenu.cloneNode(true);
        cloned.classList.remove('dropdown');
        cloned.classList.add('nav-links');
        
        // Remove inline display: none style from cloned element
        cloned.style.display = '';
        
        // Hide only nested ULs that are grandchildren or deeper (nested under LI items)
        cloned.querySelectorAll && cloned.querySelectorAll('li > ul').forEach((n) => {
          n.style.display = 'none';
        });

        let submenuHtml = '<div class="subheader"><button class="sub-back" aria-label="Back">←</button><h3 class="sub-title">' + (anchor ? anchor.textContent.trim() : 'Submenu') + '</h3></div>';

        if (panelSub.classList.contains('open')) {
          subStack.push(panelSub.innerHTML);
        }

        panelSub.innerHTML = submenuHtml + cloned.outerHTML;
        
        // Hide root panel and show submenu panel
        panelRoot.classList.add('shift-left');
        panelRoot.classList.add('hidden');
        panelSub.classList.add('open');
        panelSub.setAttribute('aria-hidden', 'false');
        
        // show header back button
        try { panelBack.removeAttribute('hidden'); panelBack.removeAttribute('aria-hidden'); } catch (e) {}

        // wire up sub-back button
        const subBack = panelSub.querySelector('.sub-back');
        if (subBack) {
          subBack.addEventListener('click', (ev) => {
            ev.preventDefault();
            if (subStack.length > 0) {
              panelSub.innerHTML = subStack.pop();
              // focus first in restored panel
              const first = panelSub.querySelector(focusableSelector);
              if (first) first.focus();
            } else {
              // Return to main menu
              panelRoot.classList.remove('shift-left');
              panelRoot.classList.remove('hidden');
              panelSub.classList.remove('open');
              panelSub.setAttribute('aria-hidden', 'true');
              panelSub.innerHTML = '';
              panelTitle.textContent = 'Menu';
              subStack = [];
              // reset expanded state on the originating button(s)
              try {
                const srcBtn = mobileNav.querySelector('.submenu-toggle[aria-expanded="true"]');
                if (srcBtn) srcBtn.setAttribute('aria-expanded', 'false');
              } catch (err) {}
              // hide header back button
              try { panelBack.setAttribute('hidden', ''); panelBack.setAttribute('aria-hidden', 'true'); } catch (e) {}
              const firstRoot = panelRoot.querySelector(focusableSelector);
              if (firstRoot) firstRoot.focus();
            }
          });
        }

        // Re-attach submenu toggle listeners for newly created elements
        attachSubmenuToggles();
        
        // focus first link in submenu
        const first = panelSub.querySelector(focusableSelector);
        if (first) first.focus();
      });
      
      // Function to attach toggle listeners to submenu items
      const attachSubmenuToggles = () => {
        panelSub.querySelectorAll('.submenu-toggle').forEach((btn) => {
          btn.removeEventListener('click', handleToggleClick);
          btn.addEventListener('click', handleToggleClick);
        });
      };
      
      const handleToggleClick = (e) => {
        e.preventDefault();
        e.stopPropagation();
        const btn = e.target.closest('.submenu-toggle');
        if (!btn) return;
        const li = btn.closest('li');
        if (!li) return;
        const submenu = li.querySelector('ul');
        if (!submenu) {
          console.warn('No submenu found for:', li);
          return;
        }
        
        const anchor = li.querySelector('a');
        const cloned = submenu.cloneNode(true);
        cloned.classList.remove('dropdown');
        cloned.classList.add('nav-links');
        
        // Remove inline display: none style from cloned element
        cloned.style.display = '';
        
        // Hide only nested ULs that are grandchildren or deeper (nested under LI items)
        cloned.querySelectorAll && cloned.querySelectorAll('li > ul').forEach((n) => {
          n.style.display = 'none';
        });
        
        let submenuHtml = '<div class="subheader"><button class="sub-back" aria-label="Back">←</button><h3 class="sub-title">' + (anchor ? anchor.textContent.trim() : 'Submenu') + '</h3></div>';
        
        if (panelSub.classList.contains('open')) {
          subStack.push(panelSub.innerHTML);
        }
        
        panelSub.innerHTML = submenuHtml + cloned.outerHTML;
        
        const subBack = panelSub.querySelector('.sub-back');
        if (subBack) {
          subBack.addEventListener('click', (ev) => {
            ev.preventDefault();
            if (subStack.length > 0) {
              panelSub.innerHTML = subStack.pop();
              attachSubmenuToggles();
              const f = panelSub.querySelector(focusableSelector);
              if (f) f.focus();
            }
          });
        }
        
        attachSubmenuToggles();
      };

    })();
  });

  /* ================================================================
     READING PROGRESS BAR
     ================================================================
     Displays reading progress as user scrolls through articles
     ================================================================ */
  
  (function initReadingProgress() {
    const progressBar = document.getElementById('readingProgress');
    
    if (!progressBar) return; // Progress bar not on this page
    
    window.addEventListener('scroll', () => {
      // Calculate scroll progress
      const windowHeight = document.documentElement.scrollHeight - window.innerHeight;
      const scrolled = window.scrollY;
      const progress = windowHeight > 0 ? (scrolled / windowHeight) * 100 : 0;
      
      // Update progress bar width
      progressBar.style.width = Math.min(progress, 100) + '%';
    }, { passive: true });
  })();

  /* ================================================================
     SCROLL-TO-TOP BUTTON
     ================================================================
     Shows button when user scrolls down, smooth scroll to top on click
     ================================================================ */
  
  (function initScrollToTop() {
    const scrollTopBtn = document.getElementById('scrollTop');
    
    if (!scrollTopBtn) return; // Button not on this page
    
    // Show/hide button based on scroll position
    window.addEventListener('scroll', () => {
      if (window.scrollY > 300) {
        scrollTopBtn.classList.add('show');
      } else {
        scrollTopBtn.classList.remove('show');
      }
    }, { passive: true });
    
    // Smooth scroll to top on click
    scrollTopBtn.addEventListener('click', () => {
      window.scrollTo({
        top: 0,
        behavior: 'smooth'
      });
    });
  })();

    // ===== TABLE OF CONTENTS ACTIVE LINK TRACKING =====
    const initTocTracking = () => {
      const toc = document.querySelector('.article-toc');
      if (!toc) return; // TOC not on this page

      // Get all heading IDs from the document
      const headings = document.querySelectorAll('.article-content h1, .article-content h2, .article-content h3');
      if (headings.length === 0) return;

      // Get all TOC links
      const tocLinks = toc.querySelectorAll('a');
      
      // Create map of heading IDs to their positions
      const headingMap = new Map();
      headings.forEach(heading => {
        if (heading.id) {
          headingMap.set(heading.id, heading);
        }
      });

      // Update active link on scroll
      const updateActiveLink = () => {
        let activeId = null;
        let minDistance = Infinity;

        // Find which heading is closest to top of viewport
        headingMap.forEach((element, id) => {
          const rect = element.getBoundingClientRect();
          const distance = Math.abs(rect.top - 100); // 100px offset from top

          if (rect.top < window.innerHeight && distance < minDistance) {
            minDistance = distance;
            activeId = id;
          }
        });

        // Update TOC link styling
        tocLinks.forEach(link => {
          link.classList.remove('active');
          const href = link.getAttribute('href');
          if (href && activeId && href === '#' + activeId) {
            link.classList.add('active');
          }
        });
      };

      // Listen for scroll events with passive listener for performance
      window.addEventListener('scroll', updateActiveLink, { passive: true });
      
      // Update on page load
      updateActiveLink();

      // Add smooth scroll behavior for TOC links
      tocLinks.forEach(link => {
        link.addEventListener('click', (e) => {
          const href = link.getAttribute('href');
          if (href && href.startsWith('#')) {
            e.preventDefault();
            const targetId = href.substring(1);
            const target = document.getElementById(targetId);
            if (target) {
              target.scrollIntoView({ behavior: 'smooth', block: 'start' });
              window.history.pushState(null, '', href);
            }
          }
        });
      });
    };

    // Initialize TOC tracking when DOM is ready
    initTocTracking();

    // ============ Core Web Vitals Tracking ============
    // Send additional metrics to Google Analytics for monitoring
    const trackPerformanceMetrics = () => {
      if (window.performance && window.performance.timing) {
        const timing = window.performance.timing;
        const navigation = window.performance.navigation;
        
        // Calculate key performance metrics
        const pageLoadTime = timing.loadEventEnd - timing.navigationStart;
        const connectTime = timing.responseEnd - timing.requestStart;
        const renderTime = timing.domComplete - timing.domLoading;
        
        if (window.gtag) {
          window.gtag('event', 'page_performance', {
            'page_load_time': pageLoadTime,
            'connect_time': connectTime,
            'render_time': renderTime,
            'navigation_type': navigation.type
          });
        }
        
        console.log('Performance Metrics:', {
          pageLoadTime,
          connectTime,
          renderTime,
          navigationType: navigation.type
        });
      }
    };
    
    // Track metrics after page load
    if (document.readyState === 'complete') {
      trackPerformanceMetrics();
    } else {
      window.addEventListener('load', trackPerformanceMetrics, { once: true });
    }

    // ============ ARTICLES PAGE PAGINATION ============
    // Implements pagination for article lists with 50 items per page
    const initArticlesPagination = () => {
      const articlesContainer = document.getElementById('articles-container');
      const prevBtn = document.getElementById('prev-page');
      const nextBtn = document.getElementById('next-page');
      const currentPageSpan = document.getElementById('current-page');
      const totalPagesSpan = document.getElementById('total-pages');
      const itemsSelect = document.getElementById('items-select');

      if (!articlesContainer || !prevBtn || !nextBtn) return; // Pagination not on this page

      // Pagination state
      let allArticles = [];
      let currentPage = 1;
      let itemsPerPage = 50;

      // Get all article cards from the container
      const loadArticles = () => {
        allArticles = Array.from(articlesContainer.querySelectorAll('.article-card'));
        return allArticles;
      };

      // Calculate total pages
      const calculateTotalPages = () => {
        return Math.max(1, Math.ceil(allArticles.length / itemsPerPage));
      };

      // Get articles for current page
      const getPaginatedItems = () => {
        const startIndex = (currentPage - 1) * itemsPerPage;
        const endIndex = startIndex + itemsPerPage;
        return allArticles.slice(startIndex, endIndex);
      };

      // Display articles for current page
      const displayPage = () => {
        const totalPages = calculateTotalPages();
        const paginatedArticles = getPaginatedItems();

        // Hide all articles
        allArticles.forEach(article => {
          article.style.display = 'none';
          article.classList.remove('fade-in');
        });

        // Show articles for current page
        paginatedArticles.forEach(article => {
          article.style.display = '';
          article.classList.add('fade-in');
        });

        // Update pagination info
        if (currentPageSpan) currentPageSpan.textContent = currentPage;
        if (totalPagesSpan) totalPagesSpan.textContent = totalPages;

        // Update button states
        prevBtn.disabled = currentPage <= 1;
        nextBtn.disabled = currentPage >= totalPages;

        // Scroll to top of articles container
        articlesContainer.scrollIntoView({ behavior: 'smooth', block: 'start' });
      };

      // Go to next page
      const nextPage = () => {
        const totalPages = calculateTotalPages();
        if (currentPage < totalPages) {
          currentPage += 1;
          displayPage();
        }
      };

      // Go to previous page
      const previousPage = () => {
        if (currentPage > 1) {
          currentPage -= 1;
          displayPage();
        }
      };

      // Change items per page
      const changeItemsPerPage = (newItemsPerPage) => {
        itemsPerPage = newItemsPerPage;
        currentPage = 1; // Reset to first page
        displayPage();
      };

      // Event listeners
      prevBtn.addEventListener('click', previousPage);
      nextBtn.addEventListener('click', nextPage);

      if (itemsSelect) {
        itemsSelect.addEventListener('change', (e) => {
          const newValue = parseInt(e.target.value, 10);
          changeItemsPerPage(newValue);
        });
      }

      // Initialize pagination
      loadArticles();
      displayPage();
    };

    // Initialize pagination when DOM is ready
    document.addEventListener('DOMContentLoaded', initArticlesPagination, { once: true });
    // Also try to initialize immediately if DOM is already loaded
    if (document.readyState === 'loading') {
      document.addEventListener('DOMContentLoaded', initArticlesPagination, { once: true });
    } else {
      initArticlesPagination();
    }

    // ============ ARTICLE CARDS LAZY LOADING ============
    // Lazy load article cards using Intersection Observer API
    const initArticlesLazyLoading = () => {
      const articlesContainer = document.getElementById('articles-container');
      if (!articlesContainer) return; // Not on articles page

      // Intersection Observer configuration
      const observerOptions = {
        root: null,
        rootMargin: '50px', // Start loading 50px before card appears
        threshold: 0.01
      };

      // Create observer callback
      const observerCallback = (entries) => {
        entries.forEach(entry => {
          if (entry.isIntersecting) {
            const card = entry.target;
            // Add loaded class to trigger fade-in animation
            card.classList.add('loaded');
            // Stop observing this card
            observer.unobserve(card);
          }
        });
      };

      // Create observer
      const observer = new IntersectionObserver(observerCallback, observerOptions);

      // Observe all article cards
      const articleCards = articlesContainer.querySelectorAll('.article-card');
      articleCards.forEach(card => {
        // Set initial opacity to 0
        card.classList.add('lazy-load');
        // Start observing
        observer.observe(card);
      });
    };

    // Initialize lazy loading when DOM is ready
    document.addEventListener('DOMContentLoaded', initArticlesLazyLoading, { once: true });
    // Also try to initialize immediately if DOM is already loaded
    if (document.readyState === 'loading') {
      document.addEventListener('DOMContentLoaded', initArticlesLazyLoading, { once: true });
    } else {
      initArticlesLazyLoading();
    }

})();

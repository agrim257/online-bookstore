<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bookstore.model.Book, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BookStore - Explore Premium Books & Literary Treasures</title>
</head>
<body>
<jsp:include page="header.jsp" />

<div class="container">
    <!-- Hero Banner Section -->
    <section class="hero-section">
        <div class="hero-glow-orb"></div>
        <div class="hero-glow-orb-2"></div>
        
        <div class="hero-grid">
            <div class="hero-content">
                <span class="hero-badge">
                    <i class="fas fa-sparkles"></i> Curated Literary Collection
                </span>
                <h1 class="hero-title">Expand Your Horizons.<br>One Book At A Time.</h1>
                <p class="hero-subtitle">
                    Explore an extraordinary selection of software engineering masterclasses, timeless literary masterpieces, and thought-provoking histories in authentic Indian editions.
                </p>
                
                <div class="hero-stats-row">
                    <div class="stat-item">
                        <span class="stat-number">10,000+</span>
                        <span class="stat-label">Happy Readers</span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-number">100%</span>
                        <span class="stat-label">Authentic Editions</span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-number">24 Hours</span>
                        <span class="stat-label">Express Dispatch</span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-number">4.9 ★</span>
                        <span class="stat-label">Customer Rating</span>
                    </div>
                </div>
            </div>

            <!-- 3D Hero Companion Book Showcase -->
            <div class="hero-book-showcase">
                <div class="hero-book-3d" id="heroInteractiveBook" title="Click to Experience 3D Opening Book">
                    <div class="hero-book-cover">
                        <div style="font-size: 2.2rem; color: #fbbf24; margin-bottom: 0.6rem;">
                            <i class="fas fa-book-bookmark"></i>
                        </div>
                        <div style="font-family: 'Cinzel', serif; font-size: 1.15rem; font-weight: 800; color: #fef3c7; letter-spacing: 0.05em;">
                            BookStore
                        </div>
                        <div style="font-family: 'Cinzel', serif; font-size: 0.65rem; color: #d4af37; letter-spacing: 0.2em; text-transform: uppercase; margin-top: 0.25rem;">
                            Grand Edition
                        </div>
                        <div style="margin-top: 1.5rem; font-size: 0.75rem; color: #fbbf24; display: flex; align-items: center; gap: 0.35rem; background: rgba(0,0,0,0.3); padding: 0.3rem 0.7rem; border-radius: 20px; border: 1px solid rgba(251, 191, 36, 0.4);">
                            <i class="fas fa-sparkles"></i> Click to Open
                        </div>
                    </div>
                    <div class="hero-book-pages-stack"></div>
                </div>
                <div class="hero-book-hint">
                    <i class="fas fa-hand-pointer" style="color: var(--accent-primary);"></i> Click book to open grand experience
                </div>
            </div>
        </div>
    </section>

    <!-- Interactive Search & Category Toolbar -->
    <div class="catalog-toolbar">
        <%
            String kw = request.getParameter("keyword");
            String selCat = request.getParameter("category");
            List<String> categories = (List<String>) request.getAttribute("categories");
            List<Book> books = (List<Book>) request.getAttribute("books");
            int totalBooks = (books != null) ? books.size() : 0;
        %>
        
        <!-- Live Instant Search & Server Form -->
        <form action="<%= request.getContextPath() %>/books" method="get" class="search-filter-row">
            <div class="search-input-wrapper">
                <i class="fas fa-magnifying-glass"></i>
                <input type="text" id="liveSearchInput" name="keyword" placeholder="Search instantly by title, author, or keyword..." value="<%= kw != null ? kw : "" %>" autocomplete="off">
            </div>
            
            <div style="display: flex; gap: 0.5rem;">
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-filter"></i> Search
                </button>
                <a href="<%= request.getContextPath() %>/books" class="btn btn-secondary">
                    <i class="fas fa-rotate-left"></i> Reset
                </a>
            </div>
        </form>

        <!-- Category Chips -->
        <div class="category-chips-row">
            <a href="#" class="category-chip <%= (selCat == null || selCat.isEmpty()) ? "active" : "" %>" data-cat="all">
                <i class="fas fa-layer-group"></i> All Categories
            </a>
            <% if (categories != null) {
                for (String cat : categories) { %>
                    <a href="#" class="category-chip <%= (selCat != null && selCat.equalsIgnoreCase(cat)) ? "active" : "" %>" data-cat="<%= cat %>">
                        <%= cat %>
                    </a>
            <%  }
               } %>
        </div>
    </div>

    <!-- Catalog Header -->
    <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 1.5rem; margin-bottom: 0.5rem;">
        <div>
            <h2>Explore Titles</h2>
            <p style="color: var(--text-muted); font-size: 0.9rem;">Browse our handpicked inventory</p>
        </div>
        <div>
            <span class="badge badge-cat" id="liveFilteredCount"><%= totalBooks %> title<%= totalBooks == 1 ? "" : "s" %></span>
        </div>
    </div>

    <!-- Books Dynamic Grid -->
    <div class="books-grid" id="booksCatalogGrid">
        <%
            if (books != null && !books.isEmpty()) {
                for (Book b : books) {
                    String cleanDesc = b.getDescription() != null ? b.getDescription().replace("\"", "&quot;") : "No description available.";
        %>
            <div class="book-card book-card-item" 
                 data-title="<%= b.getTitle() %>" 
                 data-author="<%= b.getAuthor() %>" 
                 data-category="<%= b.getCategory() %>"
                 data-id="<%= b.getId() %>">
                 
                <!-- Procedural Styled Book Cover -->
                <div class="procedural-book-cover" 
                     data-title="<%= b.getTitle() %>" 
                     data-author="<%= b.getAuthor() %>" 
                     data-category="<%= b.getCategory() %>">
                    <div class="cover-bookmark"></div>
                    <div class="cover-meta">
                        <span class="cover-category-badge"><%= b.getCategory() %></span>
                        <div class="cover-title"><%= b.getTitle() %></div>
                        <div class="cover-author">By <%= b.getAuthor() %></div>
                    </div>
                </div>

                <!-- Book Body -->
                <div class="book-card-body">
                    <div>
                        <div class="book-rating-row">
                            <div class="rating-stars">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star-half-stroke"></i>
                            </div>
                            <% if (b.getStock() > 0) { %>
                                <span class="badge badge-in">
                                    <i class="fas fa-check"></i> In Stock (<%= b.getStock() %>)
                                </span>
                            <% } else { %>
                                <span class="badge badge-out">
                                    <i class="fas fa-xmark"></i> Out of Stock
                                </span>
                            <% } %>
                        </div>

                        <div class="book-price-row">
                            <div>
                                <span class="price-currency">₹</span>
                                <span class="price-tag"><%= String.format("%.2f", b.getPrice()) %></span>
                            </div>
                            <span style="font-size: 0.8rem; color: var(--text-muted);">Hardcover</span>
                        </div>
                    </div>

                    <!-- Action Buttons -->
                    <div class="book-actions-row">
                        <button type="button" class="btn btn-secondary btn-sm btn-quick-view" 
                                title="Quick Preview"
                                data-id="<%= b.getId() %>"
                                data-title="<%= b.getTitle() %>"
                                data-author="<%= b.getAuthor() %>"
                                data-category="<%= b.getCategory() %>"
                                data-price="<%= b.getPrice() %>"
                                data-stock="<%= b.getStock() %>"
                                data-description="<%= cleanDesc %>">
                            <i class="fas fa-eye"></i>
                        </button>

                        <a href="<%= request.getContextPath() %>/book-detail?id=<%= b.getId() %>" class="btn btn-secondary btn-sm" style="flex: 1;">
                            Details
                        </a>

                        <% if (b.getStock() > 0) { %>
                            <form action="<%= request.getContextPath() %>/cart" method="post" style="flex: 1;">
                                <input type="hidden" name="action" value="add">
                                <input type="hidden" name="bookId" value="<%= b.getId() %>">
                                <input type="hidden" name="quantity" value="1">
                                <button type="submit" class="btn btn-success btn-sm" style="width: 100%;">
                                    <i class="fas fa-cart-plus"></i> Add
                                </button>
                            </form>
                        <% } %>
                    </div>
                </div>
            </div>
        <%
                }
            }
        %>
    </div>

    <!-- Empty State Notices -->
    <div id="noLiveResultsNotice" class="card" style="display: none; text-align: center; padding: 3rem; margin-top: 2rem;">
        <i class="fas fa-book-skull" style="font-size: 3rem; color: var(--text-muted); margin-bottom: 1rem;"></i>
        <h3>No matching books found</h3>
        <p style="color: var(--text-secondary); margin-top: 0.5rem;">Try adjusting your search query or selecting a different category.</p>
    </div>

    <% if (books == null || books.isEmpty()) { %>
        <div class="card" style="text-align: center; padding: 3.5rem; margin-top: 2rem;">
            <i class="fas fa-book-open-reader" style="font-size: 3.5rem; color: var(--accent-primary); margin-bottom: 1rem;"></i>
            <h3>No books found in this category</h3>
            <p style="color: var(--text-secondary); margin-top: 0.5rem;">Check back soon as we continuously expand our catalog.</p>
            <a href="<%= request.getContextPath() %>/books" class="btn btn-primary" style="margin-top: 1.5rem;">
                Browse All Books
            </a>
        </div>
    <% } %>
</div>

<!-- Quick View Modal -->
<div class="modal-backdrop" id="bookQuickViewModal">
    <div class="modal-dialog">
        <button class="modal-close-btn" onclick="closeQuickViewModal()" aria-label="Close modal">&times;</button>
        <div class="modal-body-grid">
            <div class="modal-book-cover">
                <div class="cover-bookmark"></div>
                <div class="cover-meta">
                    <span class="cover-category-badge modal-book-category">General</span>
                    <h3 class="cover-title modal-cover-title">Title</h3>
                    <p class="cover-author modal-cover-author">Author</p>
                </div>
            </div>
            <div class="modal-book-info">
                <div>
                    <span class="badge badge-cat modal-book-category" style="margin-bottom: 0.6rem;">General</span>
                    <h2 class="modal-book-title" style="margin-bottom: 0.3rem;">Book Title</h2>
                    <p class="modal-book-author" style="color: var(--text-secondary); font-size: 0.95rem; margin-bottom: 1rem;">By Author</p>
                    
                    <div style="display: flex; align-items: baseline; gap: 0.8rem; margin-bottom: 1rem;">
                        <span class="price-tag modal-book-price" style="font-size: 1.8rem; color: var(--accent-primary);">₹0.00</span>
                        <span class="modal-book-stock badge badge-in"><i class="fas fa-check"></i> In Stock</span>
                    </div>

                    <p class="modal-book-desc" style="color: var(--text-secondary); font-size: 0.92rem; line-height: 1.6; max-height: 120px; overflow-y: auto;">
                        Description text
                    </p>
                </div>

                <div style="margin-top: 1.5rem; display: flex; gap: 0.75rem; align-items: center;">
                    <form action="<%= request.getContextPath() %>/cart" method="post" class="modal-cart-form" style="display: flex; gap: 0.75rem; flex: 1;">
                        <input type="hidden" name="action" value="add">
                        <input type="hidden" name="bookId" value="">
                        <div class="qty-stepper">
                            <button type="button" class="qty-btn minus"><i class="fas fa-minus"></i></button>
                            <input type="number" name="quantity" value="1" min="1" max="50">
                            <button type="button" class="qty-btn plus"><i class="fas fa-plus"></i></button>
                        </div>
                        <button type="submit" class="btn btn-success" style="flex: 1;">
                            <i class="fas fa-cart-plus"></i> Add to Cart
                        </button>
                    </form>
                    <a href="#" class="btn btn-secondary modal-detail-link" data-base="<%= request.getContextPath() %>/book-detail">
                        Full Details
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>

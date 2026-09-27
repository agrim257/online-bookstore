<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bookstore.model.Book" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Details - BookStore</title>
</head>
<body>
<jsp:include page="header.jsp" />

<div class="container" style="max-width: 1080px;">
    <%
        Book book = (Book) request.getAttribute("book");
        if (book != null) {
            double msrp = book.getPrice() * 1.2;
    %>
        <!-- Breadcrumbs -->
        <nav style="margin-bottom: 1.5rem; font-size: 0.9rem; color: var(--text-muted); display: flex; align-items: center; gap: 0.5rem;">
            <a href="<%= request.getContextPath() %>/books" style="color: var(--text-secondary);">Home</a>
            <i class="fas fa-chevron-right" style="font-size: 0.7rem;"></i>
            <a href="<%= request.getContextPath() %>/books?category=<%= book.getCategory() %>" style="color: var(--text-secondary);"><%= book.getCategory() %></a>
            <i class="fas fa-chevron-right" style="font-size: 0.7rem;"></i>
            <span style="color: var(--text-primary); font-weight: 600;"><%= book.getTitle() %></span>
        </nav>

        <div class="card book-detail-card">
            <div class="book-detail-grid">
                
                <!-- Left: 3D Hardcover Book Mockup Display -->
                <div style="position: relative;">
                    <div class="procedural-book-cover" 
                         style="height: 440px; border-radius: var(--radius-md); box-shadow: var(--shadow-lg); border: 1px solid var(--border-color);"
                         data-title="<%= book.getTitle() %>" 
                         data-author="<%= book.getAuthor() %>" 
                         data-category="<%= book.getCategory() %>">
                        <div class="cover-bookmark" style="width: 24px; height: 50px;"></div>
                        <div class="cover-meta" style="padding-bottom: 1.5rem;">
                            <span class="cover-category-badge" style="font-size: 0.85rem; padding: 0.3rem 0.8rem;"><%= book.getCategory() %></span>
                            <div class="cover-title" style="font-size: 1.85rem; margin-top: 0.5rem;"><%= book.getTitle() %></div>
                            <div class="cover-author" style="font-size: 1.05rem; margin-top: 0.25rem;">By <%= book.getAuthor() %></div>
                        </div>
                    </div>
                    
                    <!-- Decorative Pages Edge Mockup -->
                    <div style="margin-top: 1rem; display: flex; justify-content: space-around; background: var(--bg-surface-elevated); padding: 0.85rem; border-radius: var(--radius-sm); border: 1px solid var(--border-color); font-size: 0.85rem; color: var(--text-muted);">
                        <span><i class="fas fa-book-open"></i> Hardcover Edition</span>
                        <span><i class="fas fa-globe"></i> English</span>
                        <span><i class="fas fa-award"></i> Collector Grade</span>
                    </div>
                </div>

                <!-- Right: Book Details & Actions -->
                <div>
                    <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 0.75rem;">
                        <span class="badge badge-cat" style="font-size: 0.85rem;"><%= book.getCategory() %></span>
                        <% if (book.getStock() > 0) { %>
                            <span class="badge badge-in">
                                <i class="fas fa-check-circle"></i> In Stock (<%= book.getStock() %> available)
                            </span>
                        <% } else { %>
                            <span class="badge badge-out">
                                <i class="fas fa-circle-xmark"></i> Currently Out of Stock
                            </span>
                        <% } %>
                    </div>

                    <h1 style="font-size: 2.3rem; margin-bottom: 0.5rem; letter-spacing: -0.02em;"><%= book.getTitle() %></h1>
                    <p style="color: var(--text-secondary); font-size: 1.15rem; margin-bottom: 1.25rem;">
                        By <strong style="color: var(--text-primary);"><%= book.getAuthor() %></strong>
                    </p>

                    <!-- Rating & Reviews -->
                    <div style="display: flex; align-items: center; gap: 0.75rem; margin-bottom: 1.5rem; padding-bottom: 1.25rem; border-bottom: 1px solid var(--border-color);">
                        <div class="rating-stars" style="font-size: 1.1rem;">
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star-half-stroke"></i>
                        </div>
                        <span style="font-weight: 700;">4.9 / 5.0</span>
                        <span style="color: var(--text-muted); font-size: 0.9rem;">(128 verified ratings)</span>
                    </div>

                    <!-- Pricing Showcase -->
                    <div style="background: var(--bg-surface-elevated); padding: 1.25rem 1.5rem; border-radius: var(--radius-md); border: 1px solid var(--border-color); margin-bottom: 1.5rem; display: flex; align-items: baseline; justify-content: space-between;">
                        <div>
                            <div style="font-size: 0.85rem; color: var(--text-muted); text-decoration: line-through;">
                                List Price: ₹<%= String.format("%.2f", msrp) %>
                            </div>
                            <div style="display: flex; align-items: baseline; gap: 0.4rem;">
                                <span class="price-currency" style="font-size: 1.3rem;">₹</span>
                                <span class="price-tag" style="font-size: 2.2rem; color: var(--text-primary);"><%= String.format("%.2f", book.getPrice()) %></span>
                                <span class="badge badge-in" style="font-size: 0.75rem; margin-left: 0.5rem;">Save 17%</span>
                            </div>
                        </div>
                        <div style="text-align: right; font-size: 0.85rem; color: var(--accent-success);">
                            <i class="fas fa-bolt"></i> Ready to dispatch
                        </div>
                    </div>

                    <!-- Synopsis -->
                    <div style="margin-bottom: 2rem;">
                        <h3 style="font-size: 1.15rem; margin-bottom: 0.6rem;">Book Overview</h3>
                        <p style="color: var(--text-secondary); line-height: 1.7; font-size: 0.98rem;">
                            <%= book.getDescription() != null && !book.getDescription().trim().isEmpty() 
                                ? book.getDescription() 
                                : "A distinguished title in the " + book.getCategory() + " collection, offering invaluable perspectives and engaging writing crafted for discerning readers." %>
                        </p>
                    </div>

                    <!-- Purchase Form -->
                    <% if (book.getStock() > 0) { %>
                        <form action="<%= request.getContextPath() %>/cart" method="post" style="display: flex; gap: 1rem; align-items: center; margin-bottom: 2rem; flex-wrap: wrap;">
                            <input type="hidden" name="action" value="add">
                            <input type="hidden" name="bookId" value="<%= book.getId() %>">
                            
                            <div style="display: flex; align-items: center; gap: 0.75rem;">
                                <label style="font-weight: 600; font-size: 0.95rem;">Qty:</label>
                                <div class="qty-stepper">
                                    <button type="button" class="qty-btn minus"><i class="fas fa-minus"></i></button>
                                    <input type="number" id="qty" name="quantity" value="1" min="1" max="<%= book.getStock() %>">
                                    <button type="button" class="qty-btn plus"><i class="fas fa-plus"></i></button>
                                </div>
                            </div>

                            <button type="submit" class="btn btn-success btn-lg" style="flex: 1; min-width: 220px;">
                                <i class="fas fa-bag-shopping"></i> Add to Shopping Cart
                            </button>
                        </form>
                    <% } else { %>
                        <div class="alert" style="background: rgba(244, 63, 94, 0.1); border: 1px solid rgba(244, 63, 94, 0.25); color: #fb7185; padding: 1rem; border-radius: var(--radius-sm); margin-bottom: 2rem;">
                            <i class="fas fa-triangle-exclamation"></i> This title is currently out of stock. Please check back later or explore alternative recommendations.
                        </div>
                    <% } %>

                    <!-- Trust & Buyer Protection Grid -->
                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); gap: 1rem; padding-top: 1.5rem; border-top: 1px solid var(--border-color); font-size: 0.88rem; color: var(--text-secondary);">
                        <div style="display: flex; align-items: center; gap: 0.6rem;">
                            <i class="fas fa-shield-halved" style="color: var(--accent-primary); font-size: 1.2rem;"></i>
                            <span>Secure SSL Encrypted Checkout</span>
                        </div>
                        <div style="display: flex; align-items: center; gap: 0.6rem;">
                            <i class="fas fa-truck-fast" style="color: var(--accent-secondary); font-size: 1.2rem;"></i>
                            <span>Tracked Delivery in 24-48 Hours</span>
                        </div>
                        <div style="display: flex; align-items: center; gap: 0.6rem;">
                            <i class="fas fa-rotate-left" style="color: var(--accent-success); font-size: 1.2rem;"></i>
                            <span>30-Day Hassle-Free Returns</span>
                        </div>
                    </div>

                    <div style="margin-top: 2rem;">
                        <a href="<%= request.getContextPath() %>/books" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> Back to Catalog
                        </a>
                    </div>
                </div>

            </div>
        </div>
    <% } else { %>
        <div class="card" style="text-align: center; padding: 3rem;">
            <i class="fas fa-book-circle-exclamation" style="font-size: 3rem; color: var(--text-muted); margin-bottom: 1rem;"></i>
            <h2>Book Not Found</h2>
            <p style="color: var(--text-secondary); margin-top: 0.5rem;">The requested book title does not exist in our catalog or has been archived.</p>
            <a href="<%= request.getContextPath() %>/books" class="btn btn-primary" style="margin-top: 1.5rem;">
                Return to Books Catalog
            </a>
        </div>
    <% } %>
</div>
</body>
</html>

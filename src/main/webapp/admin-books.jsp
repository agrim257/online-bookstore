<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bookstore.model.Book, java.util.List, java.util.HashSet, java.util.Set" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - Book Inventory Management</title>
</head>
<body>
<jsp:include page="header.jsp" />

<div class="container">
    <%
        List<Book> books = (List<Book>) request.getAttribute("books");
        int totalBooks = books != null ? books.size() : 0;
        int lowStockCount = 0;
        int outOfStockCount = 0;
        Set<String> catSet = new HashSet<String>();
        if (books != null) {
            for (Book b : books) {
                if (b.getCategory() != null) catSet.add(b.getCategory());
                if (b.getStock() == 0) outOfStockCount++;
                else if (b.getStock() <= 5) lowStockCount++;
            }
        }
    %>

    <!-- Header & Actions -->
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; flex-wrap: wrap; gap: 1rem;">
        <div>
            <h2>Book Catalog & Inventory</h2>
            <p style="color: var(--text-muted); font-size: 0.95rem;">Administrative control over titles, prices, and stock allocation</p>
        </div>
        <a href="<%= request.getContextPath() %>/admin/book-form" class="btn btn-success btn-lg">
            <i class="fas fa-plus"></i> Add New Book
        </a>
    </div>

    <!-- Admin KPI Summary Cards -->
    <div class="kpi-grid">
        <div class="kpi-card">
            <div class="kpi-icon-box kpi-icon-indigo">
                <i class="fas fa-book"></i>
            </div>
            <div class="kpi-info">
                <h4><%= totalBooks %></h4>
                <span>Total Catalog Titles</span>
            </div>
        </div>

        <div class="kpi-card">
            <div class="kpi-icon-box kpi-icon-cyan">
                <i class="fas fa-tags"></i>
            </div>
            <div class="kpi-info">
                <h4><%= catSet.size() %></h4>
                <span>Active Categories</span>
            </div>
        </div>

        <div class="kpi-card">
            <div class="kpi-icon-box kpi-icon-amber">
                <i class="fas fa-triangle-exclamation"></i>
            </div>
            <div class="kpi-info">
                <h4><%= lowStockCount %></h4>
                <span>Low Stock Items (≤ 5)</span>
            </div>
        </div>

        <div class="kpi-card">
            <div class="kpi-icon-box" style="background: linear-gradient(135deg, #f43f5e, #be123c);">
                <i class="fas fa-box-archive"></i>
            </div>
            <div class="kpi-info">
                <h4><%= outOfStockCount %></h4>
                <span>Out of Stock</span>
            </div>
        </div>
    </div>

    <!-- Toolbar & Instant Table Filter -->
    <div class="catalog-toolbar" style="margin-bottom: 1.5rem; padding: 1rem 1.25rem;">
        <div class="search-input-wrapper">
            <i class="fas fa-magnifying-glass"></i>
            <input type="text" id="adminTableSearch" placeholder="Type to filter books by ID, title, author, or category...">
        </div>
    </div>

    <!-- Inventory Data Table -->
    <div class="card" style="padding: 0; overflow: hidden;">
        <div class="table-responsive" style="border: none;">
            <table class="data-table">
                <thead>
                    <tr>
                        <th style="width: 70px;">ID</th>
                        <th>Book Information</th>
                        <th>Category</th>
                        <th>Unit Price</th>
                        <th>Inventory Level</th>
                        <th style="text-align: right; width: 180px;">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        if (books != null && !books.isEmpty()) {
                            for (Book b : books) {
                    %>
                        <tr>
                            <td>
                                <span style="font-family: monospace; font-weight: 700; color: var(--text-muted);">#<%= b.getId() %></span>
                            </td>
                            <td>
                                <div style="display: flex; align-items: center; gap: 0.85rem;">
                                    <div class="procedural-book-cover" 
                                         data-title="<%= b.getTitle() %>"
                                         data-author="<%= b.getAuthor() %>"
                                         data-category="<%= b.getCategory() %>"
                                         style="width: 36px; height: 48px; border-radius: 4px; padding: 0.2rem; flex-shrink: 0;">
                                    </div>
                                    <div>
                                        <div style="font-weight: 700; color: var(--text-primary);"><%= b.getTitle() %></div>
                                        <div style="font-size: 0.82rem; color: var(--text-muted);">By <%= b.getAuthor() %></div>
                                    </div>
                                </div>
                            </td>
                            <td>
                                <span class="badge badge-cat"><%= b.getCategory() %></span>
                            </td>
                            <td>
                                <strong style="font-size: 1.05rem;">₹<%= String.format("%.2f", b.getPrice()) %></strong>
                            </td>
                            <td>
                                <% if (b.getStock() > 5) { %>
                                    <span class="badge badge-in">
                                        <i class="fas fa-circle-check"></i> <%= b.getStock() %> in stock
                                    </span>
                                <% } else if (b.getStock() > 0) { %>
                                    <span class="badge badge-warning">
                                        <i class="fas fa-triangle-exclamation"></i> Low stock (<%= b.getStock() %>)
                                    </span>
                                <% } else { %>
                                    <span class="badge badge-out">
                                        <i class="fas fa-circle-xmark"></i> Out of stock (0)
                                    </span>
                                <% } %>
                            </td>
                            <td style="text-align: right;">
                                <div style="display: inline-flex; gap: 0.5rem;">
                                    <a href="<%= request.getContextPath() %>/admin/book-form?id=<%= b.getId() %>" class="btn btn-secondary btn-sm" title="Edit book details">
                                        <i class="fas fa-pen-to-square"></i> Edit
                                    </a>
                                    <a href="<%= request.getContextPath() %>/admin/book-delete?id=<%= b.getId() %>" class="btn btn-danger btn-sm" title="Delete book" onclick="return confirm('Are you sure you want to permanently delete this book from the catalog?');">
                                        <i class="fas fa-trash-can"></i>
                                    </a>
                                </div>
                            </td>
                        </tr>
                    <%
                            }
                        } else {
                    %>
                        <tr>
                            <td colspan="6" style="text-align: center; padding: 3rem;">
                                <p style="color: var(--text-muted);">No books found in the database catalog.</p>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>

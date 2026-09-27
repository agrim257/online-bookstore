<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bookstore.model.Book" %>
<%
    Book book = (Book) request.getAttribute("book");
    boolean isEdit = (book != null);
    String titleVal = isEdit ? book.getTitle() : "";
    String authorVal = isEdit ? book.getAuthor() : "";
    String catVal = isEdit ? book.getCategory() : "Technology";
    double priceVal = isEdit ? book.getPrice() : 29.99;
    int stockVal = isEdit ? book.getStock() : 10;
    String descVal = isEdit && book.getDescription() != null ? book.getDescription() : "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= isEdit ? "Edit Book" : "Add New Book" %> - Admin</title>
</head>
<body>
<jsp:include page="header.jsp" />

<div class="container" style="max-width: 1040px;">
    <!-- Breadcrumb -->
    <div style="margin-bottom: 1.5rem;">
        <a href="<%= request.getContextPath() %>/admin/books" class="btn btn-secondary btn-sm">
            <i class="fas fa-arrow-left"></i> Back to Inventory
        </a>
    </div>

    <div class="admin-form-grid">
        
        <!-- Form Column -->
        <div class="card" style="padding: 2.25rem;">
            <div style="display: flex; align-items: center; gap: 0.75rem; margin-bottom: 1.75rem;">
                <div style="width: 44px; height: 44px; border-radius: var(--radius-sm); background: linear-gradient(135deg, var(--accent-primary), #4f46e5); color: #fff; display: flex; align-items: center; justify-content: center; font-size: 1.2rem;">
                    <i class="fas <%= isEdit ? "fa-pen-to-square" : "fa-plus" %>"></i>
                </div>
                <div>
                    <h2><%= isEdit ? "Edit Book Details" : "Create New Book Entry" %></h2>
                    <p style="color: var(--text-muted); font-size: 0.88rem;">Fill in the catalog details and pricing specs</p>
                </div>
            </div>

            <form action="<%= request.getContextPath() %>/admin/book-save" method="post">
                <% if (isEdit) { %>
                    <input type="hidden" name="id" value="<%= book.getId() %>">
                <% } %>

                <div class="form-group">
                    <label><i class="fas fa-heading"></i> Book Title *</label>
                    <input type="text" id="adminBookTitle" name="title" required value="<%= titleVal %>" placeholder="e.g. Design Patterns in Practice" class="form-control">
                </div>

                <div class="form-group">
                    <label><i class="fas fa-user-pen"></i> Author *</label>
                    <input type="text" id="adminBookAuthor" name="author" required value="<%= authorVal %>" placeholder="e.g. Martin Fowler" class="form-control">
                </div>

                <div class="form-group">
                    <label><i class="fas fa-tag"></i> Category *</label>
                    <input type="text" id="adminBookCat" name="category" required value="<%= catVal %>" placeholder="e.g. Technology, Fiction, History, Science" class="form-control">
                </div>

                <div class="admin-form-row">
                    <div class="form-group">
                        <label><i class="fas fa-indian-rupee-sign"></i> Price (₹) *</label>
                        <input type="number" id="adminBookPrice" step="0.01" min="0" name="price" required value="<%= isEdit ? String.format("%.2f", priceVal) : "499.00" %>" class="form-control">
                    </div>

                    <div class="form-group">
                        <label><i class="fas fa-boxes-stacked"></i> Stock Inventory *</label>
                        <input type="number" min="0" name="stock" required value="<%= stockVal %>" class="form-control">
                    </div>
                </div>

                <div class="form-group">
                    <label><i class="fas fa-align-left"></i> Book Description / Synopsis</label>
                    <textarea name="description" rows="4" placeholder="Brief summary of the contents, key themes, and takeaways..." class="form-control"><%= descVal %></textarea>
                </div>

                <div style="display: flex; gap: 1rem; margin-top: 2rem;">
                    <button type="submit" class="btn btn-primary btn-lg" style="flex: 1;">
                        <i class="fas fa-floppy-disk"></i> <%= isEdit ? "Update Catalog Entry" : "Publish to Catalog" %>
                    </button>
                    <a href="<%= request.getContextPath() %>/admin/books" class="btn btn-secondary btn-lg">
                        Cancel
                    </a>
                </div>
            </form>
        </div>

        <!-- Live Visual Preview Column -->
        <div style="position: sticky; top: 90px;">
            <div style="font-size: 0.85rem; font-weight: 700; text-transform: uppercase; color: var(--text-muted); letter-spacing: 0.05em; margin-bottom: 0.75rem; display: flex; align-items: center; gap: 0.4rem;">
                <i class="fas fa-eye" style="color: var(--accent-primary);"></i> Live Catalog Card Preview
            </div>

            <div class="book-card" style="box-shadow: var(--shadow-lg);">
                <div class="procedural-book-cover" id="previewBookCover" data-title="<%= titleVal %>" data-author="<%= authorVal %>">
                    <div class="cover-bookmark"></div>
                    <div class="cover-meta">
                        <span class="cover-category-badge" id="previewCardCategory"><%= catVal %></span>
                        <div class="cover-title" id="previewCoverTitle"><%= titleVal.isEmpty() ? "Book Title Preview" : titleVal %></div>
                        <div class="cover-author" id="previewCoverAuthor">By <%= authorVal.isEmpty() ? "Author Name" : authorVal %></div>
                    </div>
                </div>

                <div class="book-card-body">
                    <div class="book-rating-row">
                        <div class="rating-stars">
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star-half-stroke"></i>
                        </div>
                        <span class="badge badge-in">
                            <i class="fas fa-check"></i> In Stock
                        </span>
                    </div>

                    <div class="book-price-row">
                        <div>
                            <span class="price-currency">₹</span>
                            <span class="price-tag" id="previewCardPrice"><%= String.format("%.2f", priceVal) %></span>
                        </div>
                        <span style="font-size: 0.8rem; color: var(--text-muted);">Hardcover</span>
                    </div>

                    <div class="book-actions-row">
                        <button type="button" class="btn btn-secondary btn-sm" style="flex: 1;" disabled>Details</button>
                        <button type="button" class="btn btn-success btn-sm" style="flex: 1;" disabled>Add to Cart</button>
                    </div>
                </div>
            </div>
        </div>

    </div>
</div>
</body>
</html>

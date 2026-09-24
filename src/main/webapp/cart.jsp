<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bookstore.model.CartItem, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shopping Cart - BookStore</title>
</head>
<body>
<jsp:include page="header.jsp" />

<div class="container">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem;">
        <div>
            <h2>Your Shopping Cart</h2>
            <p style="color: var(--text-muted); font-size: 0.95rem;">Review items and proceed to secure checkout</p>
        </div>
    </div>

    <% if ("stock_error".equals(request.getParameter("error"))) { %>
        <div class="alert" style="background: rgba(244, 63, 94, 0.12); border: 1px solid rgba(244, 63, 94, 0.25); color: #fb7185; padding: 1rem 1.25rem; border-radius: var(--radius-sm); margin-bottom: 1.5rem; display: flex; align-items: center; gap: 0.75rem;">
            <i class="fas fa-triangle-exclamation" style="font-size: 1.2rem;"></i>
            <span><strong>Checkout Failed:</strong> One or more selected books exceed current available stock. Please adjust item quantities.</span>
        </div>
    <% } %>

    <%
        @SuppressWarnings("unchecked")
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart != null && !cart.isEmpty()) {
            double grandTotal = 0;
            for (CartItem ci : cart) {
                grandTotal += ci.getSubtotal();
            }
            double targetFreeShipping = 500.0;
            double progressPercent = Math.min(100, Math.round((grandTotal / targetFreeShipping) * 100));
            double amountLeft = Math.max(0, targetFreeShipping - grandTotal);
    %>
        <!-- Free Shipping Progress Bar -->
        <div class="card" style="margin-bottom: 1.75rem; padding: 1.25rem 1.5rem;">
            <div id="freeShippingText" style="font-size: 0.95rem; margin-bottom: 0.6rem; color: var(--text-primary); display: flex; align-items: center; gap: 0.5rem;">
                <% if (amountLeft == 0) { %>
                    <i class="fas fa-truck-fast" style="color: var(--accent-success);"></i> 
                    <strong>Congratulations!</strong> You unlocked <strong>FREE Express Shipping</strong>!
                <% } else { %>
                    <i class="fas fa-truck" style="color: var(--accent-primary);"></i> 
                    Add <strong>₹<%= String.format("%.2f", amountLeft) %></strong> more to qualify for <strong>FREE Express Shipping</strong>!
                <% } %>
            </div>
            <div style="width: 100%; height: 8px; background: var(--bg-surface-elevated); border-radius: var(--radius-full); overflow: hidden;">
                <div id="freeShippingProgress" style="width: <%= progressPercent %>%; height: 100%; background: linear-gradient(90deg, var(--accent-primary), var(--accent-secondary)); transition: width 0.6s ease-in-out;"></div>
            </div>
        </div>

        <!-- 2-Column Cart Layout -->
        <div style="display: grid; grid-template-columns: 1fr 360px; gap: 2rem; align-items: start;">
            
            <!-- Items Table -->
            <div class="card" style="padding: 0; overflow: hidden;">
                <div class="table-responsive" style="border: none;">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Book Item</th>
                                <th>Price</th>
                                <th>Quantity</th>
                                <th>Subtotal</th>
                                <th style="text-align: right;">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                for (CartItem item : cart) {
                            %>
                                <tr>
                                    <td>
                                        <div style="display: flex; align-items: center; gap: 1rem;">
                                            <!-- Mini cover square -->
                                            <div class="procedural-book-cover" 
                                                 data-title="<%= item.getBook().getTitle() %>"
                                                 data-author="<%= item.getBook().getAuthor() %>"
                                                 data-category="<%= item.getBook().getCategory() %>"
                                                 style="width: 44px; height: 60px; border-radius: 4px; padding: 0.2rem; flex-shrink: 0; box-shadow: 0 2px 6px rgba(0,0,0,0.3);">
                                            </div>
                                            <div>
                                                <a href="<%= request.getContextPath() %>/book-detail?id=<%= item.getBook().getId() %>" style="font-weight: 700; color: var(--text-primary);">
                                                    <%= item.getBook().getTitle() %>
                                                </a>
                                                <div style="font-size: 0.85rem; color: var(--text-muted);">
                                                    By <%= item.getBook().getAuthor() %>
                                                </div>
                                                <span class="badge badge-cat" style="font-size: 0.68rem; margin-top: 0.2rem; padding: 0.15rem 0.4rem;">
                                                    <%= item.getBook().getCategory() %>
                                                </span>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <span style="font-weight: 600;">₹<%= String.format("%.2f", item.getBook().getPrice()) %></span>
                                    </td>
                                    <td>
                                        <form action="<%= request.getContextPath() %>/cart" method="post" style="display: flex; align-items: center; gap: 0.5rem;">
                                            <input type="hidden" name="action" value="update">
                                            <input type="hidden" name="bookId" value="<%= item.getBook().getId() %>">
                                            <div class="qty-stepper">
                                                <button type="button" class="qty-btn minus"><i class="fas fa-minus"></i></button>
                                                <input type="number" name="quantity" value="<%= item.getQuantity() %>" min="1" max="<%= item.getBook().getStock() %>" onchange="this.form.submit()">
                                                <button type="button" class="qty-btn plus"><i class="fas fa-plus"></i></button>
                                            </div>
                                            <button type="submit" class="btn btn-secondary btn-sm" title="Refresh quantity" style="padding: 0.4rem 0.6rem;">
                                                <i class="fas fa-arrows-rotate"></i>
                                            </button>
                                        </form>
                                    </td>
                                    <td>
                                        <strong style="color: var(--accent-primary); font-size: 1.05rem;">
                                            ₹<%= String.format("%.2f", item.getSubtotal()) %>
                                        </strong>
                                    </td>
                                    <td style="text-align: right;">
                                        <form action="<%= request.getContextPath() %>/cart" method="post" style="display: inline-block;">
                                            <input type="hidden" name="action" value="remove">
                                            <input type="hidden" name="bookId" value="<%= item.getBook().getId() %>">
                                            <button type="submit" class="btn btn-danger btn-sm" title="Remove Item" style="padding: 0.4rem 0.75rem;">
                                                <i class="fas fa-trash-can"></i>
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>

                <div style="padding: 1.25rem 1.5rem; background: var(--bg-surface-elevated); border-top: 1px solid var(--border-color); display: flex; justify-content: space-between; align-items: center;">
                    <a href="<%= request.getContextPath() %>/books" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Continue Shopping
                    </a>
                    <span style="font-size: 0.9rem; color: var(--text-muted);">
                        <%= cart.size() %> unique item<%= cart.size() == 1 ? "" : "s" %> in cart
                    </span>
                </div>
            </div>

            <!-- Order Summary Sidebar -->
            <div class="card" style="padding: 1.75rem;">
                <h3 style="font-size: 1.25rem; margin-bottom: 1.25rem; border-bottom: 1px solid var(--border-color); padding-bottom: 0.75rem;">
                    Order Summary
                </h3>

                <div style="display: flex; flex-direction: column; gap: 0.9rem; font-size: 0.95rem;">
                    <div style="display: flex; justify-content: space-between; color: var(--text-secondary);">
                        <span>Subtotal</span>
                        <span style="font-weight: 600; color: var(--text-primary);">₹<%= String.format("%.2f", grandTotal) %></span>
                    </div>

                    <div style="display: flex; justify-content: space-between; color: var(--text-secondary);">
                        <span>Estimated Shipping</span>
                        <span style="font-weight: 600; color: <%= amountLeft == 0 ? "var(--accent-success)" : "var(--text-primary)" %>;">
                            <%= amountLeft == 0 ? "FREE" : "₹49.00" %>
                        </span>
                    </div>

                    <div style="display: flex; justify-content: space-between; color: var(--text-secondary);">
                        <span>Estimated Tax</span>
                        <span style="font-weight: 600; color: var(--text-primary);">₹0.00</span>
                    </div>

                    <!-- Promo Coupon Box -->
                    <div style="margin: 0.5rem 0; padding-top: 0.75rem; border-top: 1px dashed var(--border-color);">
                        <form id="couponForm" style="display: flex; gap: 0.5rem;">
                            <input type="text" name="couponCode" placeholder="Promo code (e.g. SAVE10)" class="form-control" style="padding: 0.45rem 0.75rem; font-size: 0.85rem;">
                            <button type="submit" class="btn btn-secondary btn-sm" style="padding: 0.45rem 0.9rem;">Apply</button>
                        </form>
                        <div id="couponNotice" style="display: none; font-size: 0.82rem; color: var(--accent-success); margin-top: 0.4rem;"></div>
                    </div>

                    <div style="display: flex; justify-content: space-between; align-items: baseline; border-top: 1px solid var(--border-color); padding-top: 1rem; margin-top: 0.5rem;">
                        <span style="font-size: 1.15rem; font-weight: 700;">Total</span>
                        <div>
                            <span class="price-currency" style="font-size: 1.1rem;">₹</span>
                            <span class="price-tag" id="cartGrandTotal" data-total="<%= grandTotal %>" style="font-size: 1.8rem; color: var(--accent-primary);">
                                <%= String.format("%.2f", grandTotal) %>
                            </span>
                        </div>
                    </div>
                </div>

                <form action="<%= request.getContextPath() %>/checkout" method="post" style="margin-top: 1.5rem;">
                    <button type="submit" class="btn btn-success btn-lg" style="width: 100%; font-size: 1.1rem; padding: 0.9rem;">
                        <i class="fas fa-lock"></i> Proceed to Checkout
                    </button>
                </form>

                <div style="text-align: center; margin-top: 1.25rem; font-size: 0.82rem; color: var(--text-muted); display: flex; align-items: center; justify-content: center; gap: 0.5rem;">
                    <i class="fas fa-shield-halved" style="color: var(--accent-success);"></i> 256-Bit Encrypted Secure Checkout
                </div>
            </div>

        </div>
    <% } else { %>
        <!-- Empty Cart State -->
        <div class="card" style="text-align: center; padding: 4.5rem 2rem; max-width: 600px; margin: 2rem auto;">
            <div style="width: 84px; height: 84px; border-radius: 50%; background: var(--bg-surface-elevated); border: 1px solid var(--border-color); display: flex; align-items: center; justify-content: center; margin: 0 auto 1.5rem; color: var(--accent-primary); font-size: 2.5rem;">
                <i class="fas fa-cart-shopping"></i>
            </div>
            <h2>Your Shopping Cart is Empty</h2>
            <p style="color: var(--text-secondary); margin: 0.75rem auto 2rem; max-width: 420px; line-height: 1.6;">
                Looks like you haven't added any books to your cart yet. Discover bestselling titles and timeless stories in our collection!
            </p>
            <a href="<%= request.getContextPath() %>/books" class="btn btn-primary btn-lg">
                <i class="fas fa-compass"></i> Explore Catalog
            </a>
        </div>
    <% } %>
</div>

</body>
</html>

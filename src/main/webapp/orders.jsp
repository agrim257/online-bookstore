<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bookstore.model.Order, com.bookstore.model.OrderItem, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Orders - BookStore</title>
</head>
<body>
<jsp:include page="header.jsp" />

<div class="container" style="max-width: 960px;">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem;">
        <div>
            <h2>Order History</h2>
            <p style="color: var(--text-muted); font-size: 0.95rem;">Track your package shipments and purchase invoices</p>
        </div>
        <a href="<%= request.getContextPath() %>/books" class="btn btn-secondary btn-sm">
            <i class="fas fa-plus"></i> Order More Books
        </a>
    </div>

    <% if ("success".equals(request.getParameter("msg"))) { %>
        <div class="alert" style="background: rgba(16, 185, 129, 0.12); border: 1px solid rgba(16, 185, 129, 0.25); color: #34d399; padding: 1.25rem; border-radius: var(--radius-md); margin-bottom: 2rem; display: flex; align-items: center; gap: 1rem;">
            <div style="width: 44px; height: 44px; border-radius: 50%; background: var(--accent-success); color: #fff; display: flex; align-items: center; justify-content: center; font-size: 1.3rem; flex-shrink: 0;">
                <i class="fas fa-check"></i>
            </div>
            <div>
                <h4 style="color: #34d399; font-size: 1.1rem; margin-bottom: 0.2rem;">Order Confirmed!</h4>
                <p style="font-size: 0.92rem; color: var(--text-secondary);">Thank you for your purchase. We are preparing your literary selections for shipment.</p>
            </div>
        </div>
    <% } %>

    <%
        List<Order> orders = (List<Order>) request.getAttribute("orders");
        if (orders != null && !orders.isEmpty()) {
            for (Order o : orders) {
                String st = o.getStatus() != null ? o.getStatus().toUpperCase() : "PENDING";
                String pillClass = "status-pending";
                if ("SHIPPED".equals(st)) pillClass = "status-shipped";
                else if ("DELIVERED".equals(st)) pillClass = "status-delivered";
                else if ("CANCELLED".equals(st)) pillClass = "status-cancelled";
    %>
        <div class="card" style="margin-bottom: 2rem; padding: 0; overflow: hidden;">
            <!-- Order Header Bar -->
            <div style="padding: 1.25rem 1.75rem; background: var(--bg-surface-elevated); border-bottom: 1px solid var(--border-color); display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 1rem;">
                <div style="display: flex; align-items: center; gap: 1.25rem;">
                    <div>
                        <span style="font-size: 0.8rem; text-transform: uppercase; color: var(--text-muted); letter-spacing: 0.05em;">Order Reference</span>
                        <div style="font-family: var(--font-heading); font-size: 1.2rem; font-weight: 800; color: var(--text-primary);">
                            #<%= o.getId() %>
                        </div>
                    </div>
                    <div style="border-left: 1px solid var(--border-color); padding-left: 1.25rem;">
                        <span style="font-size: 0.8rem; text-transform: uppercase; color: var(--text-muted); letter-spacing: 0.05em;">Placed On</span>
                        <div style="font-size: 0.95rem; font-weight: 500; color: var(--text-secondary);">
                            <%= o.getOrderDate() %>
                        </div>
                    </div>
                </div>

                <div style="display: flex; align-items: center; gap: 1rem;">
                    <span class="status-pill <%= pillClass %>">
                        <span class="status-dot"></span>
                        <%= st %>
                    </span>
                    <button type="button" onclick="window.print()" class="btn btn-secondary btn-sm" title="Print receipt">
                        <i class="fas fa-print"></i>
                    </button>
                </div>
            </div>

            <!-- Items Table -->
            <div class="table-responsive" style="border: none;">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Purchased Book</th>
                            <th>Unit Price</th>
                            <th>Quantity</th>
                            <th style="text-align: right;">Total</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (OrderItem item : o.getItems()) { %>
                            <tr>
                                <td>
                                    <div style="display: flex; align-items: center; gap: 0.75rem;">
                                        <i class="fas fa-book" style="color: var(--accent-primary);"></i>
                                        <strong style="color: var(--text-primary);"><%= item.getBookTitle() %></strong>
                                    </div>
                                </td>
                                <td>₹<%= String.format("%.2f", item.getPrice()) %></td>
                                <td>
                                    <span class="badge badge-cat" style="font-size: 0.8rem;">Qty: <%= item.getQuantity() %></span>
                                </td>
                                <td style="text-align: right; font-weight: 700; color: var(--accent-primary);">
                                    ₹<%= String.format("%.2f", item.getSubtotal()) %>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>

            <!-- Order Footer -->
            <div style="padding: 1.25rem 1.75rem; background: var(--bg-surface); border-top: 1px solid var(--border-color); display: flex; justify-content: space-between; align-items: center;">
                <span style="font-size: 0.9rem; color: var(--text-muted);">
                    <i class="fas fa-truck-fast"></i> Express Delivery Tracking Active
                </span>
                <div style="display: flex; align-items: baseline; gap: 0.5rem;">
                    <span style="color: var(--text-secondary); font-size: 0.95rem;">Total Paid:</span>
                    <span class="price-tag" style="font-size: 1.5rem; color: var(--text-primary);">₹<%= String.format("%.2f", o.getTotalAmount()) %></span>
                </div>
            </div>
        </div>
    <%
            }
        } else {
    %>
        <div class="card" style="text-align: center; padding: 4.5rem 2rem; margin-top: 1.5rem;">
            <div style="width: 80px; height: 80px; border-radius: 50%; background: var(--bg-surface-elevated); border: 1px solid var(--border-color); display: flex; align-items: center; justify-content: center; margin: 0 auto 1.5rem; color: var(--accent-primary); font-size: 2.2rem;">
                <i class="fas fa-box-open"></i>
            </div>
            <h3>No Orders Placed Yet</h3>
            <p style="color: var(--text-secondary); max-width: 420px; margin: 0.5rem auto 1.75rem;">
                You haven't purchased any books yet. Explore our curated collections to start building your personal library!
            </p>
            <a href="<%= request.getContextPath() %>/books" class="btn btn-primary btn-lg">
                <i class="fas fa-compass"></i> Start Exploring
            </a>
        </div>
    <% } %>
</div>
</body>
</html>

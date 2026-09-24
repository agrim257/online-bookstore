<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bookstore.model.Order, com.bookstore.model.OrderItem, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - Customer Order Management</title>
</head>
<body>
<jsp:include page="header.jsp" />

<div class="container">
    <%
        List<Order> orders = (List<Order>) request.getAttribute("orders");
        int totalOrders = orders != null ? orders.size() : 0;
        int pendingCount = 0;
        int shippedCount = 0;
        int deliveredCount = 0;
        double totalRevenue = 0;

        if (orders != null) {
            for (Order o : orders) {
                totalRevenue += o.getTotalAmount();
                String st = o.getStatus() != null ? o.getStatus().toUpperCase() : "PENDING";
                if ("PENDING".equals(st)) pendingCount++;
                else if ("SHIPPED".equals(st)) shippedCount++;
                else if ("DELIVERED".equals(st)) deliveredCount++;
            }
        }
    %>

    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem;">
        <div>
            <h2>Customer Orders Management</h2>
            <p style="color: var(--text-muted); font-size: 0.95rem;">Review order fulfillments, update logistics status, and verify totals</p>
        </div>
    </div>

    <!-- KPI Summary Cards -->
    <div class="kpi-grid">
        <div class="kpi-card">
            <div class="kpi-icon-box kpi-icon-indigo">
                <i class="fas fa-boxes-packing"></i>
            </div>
            <div class="kpi-info">
                <h4><%= totalOrders %></h4>
                <span>Total Orders Placed</span>
            </div>
        </div>

        <div class="kpi-card">
            <div class="kpi-icon-box kpi-icon-amber">
                <i class="fas fa-clock"></i>
            </div>
            <div class="kpi-info">
                <h4><%= pendingCount %></h4>
                <span>Pending Fulfillment</span>
            </div>
        </div>

        <div class="kpi-card">
            <div class="kpi-icon-box kpi-icon-cyan">
                <i class="fas fa-truck-fast"></i>
            </div>
            <div class="kpi-info">
                <h4><%= shippedCount %></h4>
                <span>In Transit (Shipped)</span>
            </div>
        </div>

        <div class="kpi-card">
            <div class="kpi-icon-box kpi-icon-emerald">
                <i class="fas fa-indian-rupee-sign"></i>
            </div>
            <div class="kpi-info">
                <h4>₹<%= String.format("%.2f", totalRevenue) %></h4>
                <span>Gross Order Revenue</span>
            </div>
        </div>
    </div>

    <!-- Orders List -->
    <%
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
            <div style="padding: 1.25rem 1.75rem; background: var(--bg-surface-elevated); border-bottom: 1px solid var(--border-color); display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 1.25rem;">
                <div style="display: flex; align-items: center; gap: 1.5rem; flex-wrap: wrap;">
                    <div>
                        <span style="font-size: 0.78rem; text-transform: uppercase; color: var(--text-muted); letter-spacing: 0.05em;">Order Reference</span>
                        <div style="font-family: var(--font-heading); font-size: 1.2rem; font-weight: 800; color: var(--text-primary);">
                            #<%= o.getId() %>
                        </div>
                    </div>
                    <div style="border-left: 1px solid var(--border-color); padding-left: 1.5rem;">
                        <span style="font-size: 0.78rem; text-transform: uppercase; color: var(--text-muted); letter-spacing: 0.05em;">Customer ID</span>
                        <div style="font-size: 0.95rem; font-weight: 600; color: var(--text-secondary);">
                            User #<%= o.getUserId() %>
                        </div>
                    </div>
                    <div style="border-left: 1px solid var(--border-color); padding-left: 1.5rem;">
                        <span style="font-size: 0.78rem; text-transform: uppercase; color: var(--text-muted); letter-spacing: 0.05em;">Timestamp</span>
                        <div style="font-size: 0.95rem; font-weight: 500; color: var(--text-muted);">
                            <%= o.getOrderDate() %>
                        </div>
                    </div>
                </div>

                <!-- Status Update Control -->
                <div style="display: flex; align-items: center; gap: 1rem;">
                    <span class="status-pill <%= pillClass %>">
                        <span class="status-dot"></span>
                        <%= st %>
                    </span>

                    <form action="<%= request.getContextPath() %>/admin/order-status" method="post" style="display: flex; gap: 0.5rem; align-items: center;">
                        <input type="hidden" name="orderId" value="<%= o.getId() %>">
                        <select name="status" class="form-control" style="padding: 0.45rem 0.75rem; font-size: 0.88rem; width: auto;">
                            <option value="PENDING" <%= "PENDING".equals(st) ? "selected" : "" %>>PENDING</option>
                            <option value="SHIPPED" <%= "SHIPPED".equals(st) ? "selected" : "" %>>SHIPPED</option>
                            <option value="DELIVERED" <%= "DELIVERED".equals(st) ? "selected" : "" %>>DELIVERED</option>
                            <option value="CANCELLED" <%= "CANCELLED".equals(st) ? "selected" : "" %>>CANCELLED</option>
                        </select>
                        <button type="submit" class="btn btn-primary btn-sm">
                            <i class="fas fa-check"></i> Update
                        </button>
                    </form>
                </div>
            </div>

            <!-- Items Table -->
            <div class="table-responsive" style="border: none;">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Book Title</th>
                            <th>Unit Price</th>
                            <th>Ordered Quantity</th>
                            <th style="text-align: right;">Line Total</th>
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
                                    <span class="badge badge-cat">Qty: <%= item.getQuantity() %></span>
                                </td>
                                <td style="text-align: right; font-weight: 700; color: var(--accent-primary);">
                                    ₹<%= String.format("%.2f", item.getSubtotal()) %>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>

            <!-- Total Amount Bar -->
            <div style="padding: 1.25rem 1.75rem; background: var(--bg-surface); border-top: 1px solid var(--border-color); display: flex; justify-content: space-between; align-items: center;">
                <span style="font-size: 0.9rem; color: var(--text-muted);">
                    <i class="fas fa-receipt"></i> Billed and logged in transaction registry
                </span>
                <div style="display: flex; align-items: baseline; gap: 0.5rem;">
                    <span style="color: var(--text-secondary); font-size: 0.95rem;">Gross Total:</span>
                    <span class="price-tag" style="font-size: 1.5rem; color: var(--text-primary);">₹<%= String.format("%.2f", o.getTotalAmount()) %></span>
                </div>
            </div>
        </div>
    <%
            }
        } else {
    %>
        <div class="card" style="text-align: center; padding: 4.5rem 2rem; margin-top: 1.5rem;">
            <i class="fas fa-box-archive" style="font-size: 3rem; color: var(--text-muted); margin-bottom: 1rem;"></i>
            <h3>No Customer Orders Yet</h3>
            <p style="color: var(--text-secondary); margin-top: 0.5rem;">As customers place orders, they will appear in this administrative management queue.</p>
        </div>
    <% } %>
</div>
</body>
</html>

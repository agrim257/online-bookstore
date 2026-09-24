<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bookstore.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Profile - BookStore</title>
</head>
<body>
<jsp:include page="header.jsp" />

<div class="container" style="max-width: 640px; margin-top: 2rem;">
    <%
        User user = (User) request.getAttribute("user");
        String initial = (user != null && user.getName() != null && !user.getName().isEmpty())
                ? user.getName().substring(0, 1).toUpperCase() : "U";
    %>

    <!-- Profile Header Card -->
    <div class="card" style="padding: 2rem; margin-bottom: 1.5rem; display: flex; align-items: center; gap: 1.5rem;">
        <div style="width: 72px; height: 72px; border-radius: 50%; background: linear-gradient(135deg, #f59e0b, #ef4444); color: #fff; display: flex; align-items: center; justify-content: center; font-size: 2rem; font-weight: 800; box-shadow: 0 4px 15px rgba(239, 68, 68, 0.3);">
            <%= initial %>
        </div>
        <div>
            <h2 style="font-size: 1.6rem; margin-bottom: 0.2rem;"><%= user != null ? user.getName() : "Customer" %></h2>
            <div style="display: flex; align-items: center; gap: 0.6rem;">
                <span style="color: var(--text-secondary); font-size: 0.9rem;"><%= user != null ? user.getEmail() : "" %></span>
                <span class="badge badge-cat" style="font-size: 0.7rem;"><%= user != null ? user.getRole() : "CUSTOMER" %></span>
            </div>
        </div>
    </div>

    <!-- Account Details Form -->
    <div class="card" style="padding: 2.25rem;">
        <h3 style="font-size: 1.25rem; margin-bottom: 1.5rem; border-bottom: 1px solid var(--border-color); padding-bottom: 0.75rem;">
            <i class="fas fa-id-card"></i> Personal Information
        </h3>

        <% if (request.getAttribute("error") != null) { %>
            <div class="alert" style="background: rgba(244, 63, 94, 0.12); border: 1px solid rgba(244, 63, 94, 0.25); color: #fb7185; padding: 0.85rem 1rem; border-radius: var(--radius-sm); margin-bottom: 1.5rem; display: flex; align-items: center; gap: 0.6rem;">
                <i class="fas fa-circle-exclamation"></i>
                <span><%= request.getAttribute("error") %></span>
            </div>
        <% } %>

        <% if ("updated".equals(request.getParameter("msg"))) { %>
            <div class="alert" style="background: rgba(16, 185, 129, 0.12); border: 1px solid rgba(16, 185, 129, 0.25); color: #34d399; padding: 0.85rem 1rem; border-radius: var(--radius-sm); margin-bottom: 1.5rem; display: flex; align-items: center; gap: 0.6rem;">
                <i class="fas fa-circle-check"></i>
                <span>Profile details updated successfully!</span>
            </div>
        <% } %>

        <% if (user != null) { %>
            <form action="<%= request.getContextPath() %>/profile" method="post">
                <div class="form-group">
                    <label><i class="fas fa-envelope"></i> Email (Registered Identifier)</label>
                    <input type="email" value="<%= user.getEmail() %>" disabled class="form-control" style="opacity: 0.7; cursor: not-allowed; background: var(--bg-surface-elevated);">
                </div>

                <div class="form-group">
                    <label><i class="fas fa-user"></i> Full Name *</label>
                    <input type="text" name="name" value="<%= user.getName() %>" required class="form-control">
                </div>

                <div class="form-group">
                    <label><i class="fas fa-phone"></i> Phone Number</label>
                    <input type="text" name="phone" value="<%= user.getPhone() != null ? user.getPhone() : "" %>" placeholder="+1 (555) 000-0000" class="form-control">
                </div>

                <div class="form-group">
                    <label><i class="fas fa-location-dot"></i> Default Shipping Address</label>
                    <textarea name="address" rows="3" placeholder="Enter delivery address" class="form-control"><%= user.getAddress() != null ? user.getAddress() : "" %></textarea>
                </div>

                <div style="margin-top: 1.75rem; padding-top: 1.25rem; border-top: 1px solid var(--border-color);">
                    <h4 style="font-size: 1.05rem; margin-bottom: 1rem; color: var(--text-primary);">
                        <i class="fas fa-shield-key"></i> Security & Password
                    </h4>
                    <div class="form-group">
                        <label>New Password (leave blank to keep existing password)</label>
                        <div class="input-with-icon">
                            <i class="fas fa-lock"></i>
                            <input type="password" id="profilePassword" name="password" placeholder="••••••••" class="form-control">
                            <button type="button" class="password-toggle-btn" data-target="profilePassword" aria-label="Toggle password visibility">
                                <i class="fas fa-eye"></i>
                            </button>
                        </div>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary btn-lg" style="width: 100%; margin-top: 1rem;">
                    <i class="fas fa-floppy-disk"></i> Save Profile Changes
                </button>
            </form>
        <% } %>
    </div>
</div>
</body>
</html>

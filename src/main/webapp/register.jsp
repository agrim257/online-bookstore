<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Registration - BookStore</title>
</head>
<body>
<jsp:include page="header.jsp" />

<div class="container" style="max-width: 540px; margin-top: 2rem;">
    <div class="card auth-card" style="padding: 2.5rem; position: relative; overflow: hidden;">
        <!-- Accent line -->
        <div style="position: absolute; top: 0; left: 0; right: 0; height: 4px; background: linear-gradient(90deg, var(--accent-success), var(--accent-primary));"></div>

        <div style="text-align: center; margin-bottom: 2rem;">
            <div style="width: 56px; height: 56px; border-radius: var(--radius-md); background: linear-gradient(135deg, var(--accent-success), #059669); display: inline-flex; align-items: center; justify-content: center; color: #fff; font-size: 1.6rem; margin-bottom: 1rem; box-shadow: 0 4px 15px rgba(16, 185, 129, 0.3);">
                <i class="fas fa-user-plus"></i>
            </div>
            <h2 style="font-size: 1.85rem; letter-spacing: -0.02em;">Create Your Account</h2>
            <p style="color: var(--text-muted); font-size: 0.95rem; margin-top: 0.35rem;">Join our community of book lovers and collectors</p>
        </div>

        <% if (request.getAttribute("error") != null) { %>
            <div class="alert" style="background: rgba(244, 63, 94, 0.12); border: 1px solid rgba(244, 63, 94, 0.25); color: #fb7185; padding: 0.85rem 1rem; border-radius: var(--radius-sm); margin-bottom: 1.5rem; display: flex; align-items: center; gap: 0.6rem; font-size: 0.92rem;">
                <i class="fas fa-circle-exclamation"></i>
                <span><%= request.getAttribute("error") %></span>
            </div>
        <% } %>

        <form action="<%= request.getContextPath() %>/register" method="post">
            <div class="form-group">
                <label><i class="fas fa-user"></i> Full Name *</label>
                <div class="input-with-icon">
                    <i class="fas fa-id-badge"></i>
                    <input type="text" name="name" required placeholder="John Doe" class="form-control">
                </div>
            </div>

            <div class="form-group">
                <label><i class="fas fa-envelope"></i> Email Address *</label>
                <div class="input-with-icon">
                    <i class="fas fa-at"></i>
                    <input type="email" name="email" required placeholder="john@example.com" class="form-control">
                </div>
            </div>

            <div class="form-group">
                <label><i class="fas fa-key"></i> Password *</label>
                <div class="input-with-icon">
                    <i class="fas fa-lock"></i>
                    <input type="password" id="registerPassword" name="password" required placeholder="At least 6 characters" class="form-control">
                    <button type="button" class="password-toggle-btn" data-target="registerPassword" aria-label="Toggle password visibility">
                        <i class="fas fa-eye"></i>
                    </button>
                </div>
            </div>

            <div class="form-group">
                <label><i class="fas fa-phone"></i> Phone Number</label>
                <div class="input-with-icon">
                    <i class="fas fa-phone-volume"></i>
                    <input type="text" name="phone" placeholder="+1 (555) 019-2834" class="form-control">
                </div>
            </div>

            <div class="form-group">
                <label><i class="fas fa-location-dot"></i> Shipping Address</label>
                <textarea name="address" rows="3" placeholder="Enter your full street address, city, and zip code" class="form-control"></textarea>
            </div>

            <button type="submit" class="btn btn-success btn-lg" style="width: 100%; margin-top: 1rem;">
                <i class="fas fa-check-circle"></i> Complete Registration
            </button>
        </form>

        <p style="margin-top: 1.75rem; text-align: center; font-size: 0.92rem; color: var(--text-secondary);">
            Already have an account? 
            <a href="<%= request.getContextPath() %>/login" style="color: var(--accent-primary); font-weight: 700;">
                Sign In Instead <i class="fas fa-arrow-right" style="font-size: 0.75rem;"></i>
            </a>
        </p>
    </div>
</div>
</body>
</html>

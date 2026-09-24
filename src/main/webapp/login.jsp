<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In - BookStore</title>
</head>
<body>
<jsp:include page="header.jsp" />

<div class="container" style="max-width: 480px; margin-top: 3.5rem;">
    <div class="card" style="padding: 2.5rem; position: relative; overflow: hidden;">
        <!-- Glowing accent edge -->
        <div style="position: absolute; top: 0; left: 0; right: 0; height: 4px; background: linear-gradient(90deg, var(--accent-primary), var(--accent-secondary));"></div>

        <div style="text-align: center; margin-bottom: 2rem;">
            <div style="width: 56px; height: 56px; border-radius: var(--radius-md); background: linear-gradient(135deg, var(--accent-primary), var(--accent-secondary)); display: inline-flex; align-items: center; justify-content: center; color: #fff; font-size: 1.6rem; margin-bottom: 1rem; box-shadow: 0 4px 15px var(--accent-primary-glow);">
                <i class="fas fa-book-open"></i>
            </div>
            <h2 style="font-size: 1.85rem; letter-spacing: -0.02em;">Welcome Back</h2>
            <p style="color: var(--text-muted); font-size: 0.95rem; margin-top: 0.35rem;">Enter your credentials to access your account</p>
        </div>

        <% if (request.getAttribute("error") != null) { %>
            <div class="alert" style="background: rgba(244, 63, 94, 0.12); border: 1px solid rgba(244, 63, 94, 0.25); color: #fb7185; padding: 0.85rem 1rem; border-radius: var(--radius-sm); margin-bottom: 1.5rem; display: flex; align-items: center; gap: 0.6rem; font-size: 0.92rem;">
                <i class="fas fa-circle-exclamation"></i>
                <span><%= request.getAttribute("error") %></span>
            </div>
        <% } %>
        
        <% if ("registered".equals(request.getParameter("msg"))) { %>
            <div class="alert" style="background: rgba(16, 185, 129, 0.12); border: 1px solid rgba(16, 185, 129, 0.25); color: #34d399; padding: 0.85rem 1rem; border-radius: var(--radius-sm); margin-bottom: 1.5rem; display: flex; align-items: center; gap: 0.6rem; font-size: 0.92rem;">
                <i class="fas fa-circle-check"></i>
                <span>Account created successfully! Please sign in.</span>
            </div>
        <% } else if ("logged_out".equals(request.getParameter("msg"))) { %>
            <div class="alert" style="background: rgba(99, 102, 241, 0.12); border: 1px solid rgba(99, 102, 241, 0.25); color: #818cf8; padding: 0.85rem 1rem; border-radius: var(--radius-sm); margin-bottom: 1.5rem; display: flex; align-items: center; gap: 0.6rem; font-size: 0.92rem;">
                <i class="fas fa-circle-info"></i>
                <span>You have been logged out securely.</span>
            </div>
        <% } else if ("login_required".equals(request.getParameter("msg"))) { %>
            <div class="alert" style="background: rgba(245, 158, 11, 0.12); border: 1px solid rgba(245, 158, 11, 0.25); color: #fbbf24; padding: 0.85rem 1rem; border-radius: var(--radius-sm); margin-bottom: 1.5rem; display: flex; align-items: center; gap: 0.6rem; font-size: 0.92rem;">
                <i class="fas fa-lock"></i>
                <span>Please log in to continue with checkout.</span>
            </div>
        <% } %>

        <form action="<%= request.getContextPath() %>/login" method="post">
            <div class="form-group">
                <label><i class="fas fa-envelope"></i> Email Address</label>
                <div class="input-with-icon">
                    <i class="fas fa-at"></i>
                    <input type="email" name="email" required placeholder="name@example.com" class="form-control" autocomplete="email">
                </div>
            </div>

            <div class="form-group">
                <label><i class="fas fa-key"></i> Password</label>
                <div class="input-with-icon">
                    <i class="fas fa-lock"></i>
                    <input type="password" id="loginPassword" name="password" required placeholder="••••••••" class="form-control" autocomplete="current-password">
                    <button type="button" class="password-toggle-btn" data-target="loginPassword" aria-label="Toggle password visibility">
                        <i class="fas fa-eye"></i>
                    </button>
                </div>
            </div>

            <button type="submit" class="btn btn-primary btn-lg" style="width: 100%; margin-top: 1rem;">
                <i class="fas fa-arrow-right-to-bracket"></i> Sign In to Account
            </button>
        </form>

        <!-- One-Click Demo Credentials Quick Autofill -->
        <div style="margin-top: 2rem; padding: 1.2rem; border-radius: var(--radius-sm); background: var(--bg-surface-elevated); border: 1px solid var(--border-color);">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.75rem;">
                <span style="font-size: 0.82rem; text-transform: uppercase; letter-spacing: 0.05em; font-weight: 700; color: var(--text-muted);">
                    <i class="fas fa-flask"></i> Fast Demo Autofill
                </span>
            </div>
            <div style="display: flex; gap: 0.6rem;">
                <button type="button" id="btnDemoAdmin" class="btn btn-secondary btn-sm" style="flex: 1;">
                    <i class="fas fa-shield-halved"></i> Demo Admin
                </button>
                <button type="button" id="btnDemoCustomer" class="btn btn-secondary btn-sm" style="flex: 1;">
                    <i class="fas fa-user"></i> Demo Customer
                </button>
            </div>
        </div>

        <p style="margin-top: 1.75rem; text-align: center; font-size: 0.92rem; color: var(--text-secondary);">
            Don't have an account yet? 
            <a href="<%= request.getContextPath() %>/register" style="color: var(--accent-primary); font-weight: 700;">
                Create Account <i class="fas fa-arrow-right" style="font-size: 0.75rem;"></i>
            </a>
        </p>
    </div>
</div>
</body>
</html>

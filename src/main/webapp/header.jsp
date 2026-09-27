<%@ page import="com.bookstore.model.User, com.bookstore.model.CartItem, java.util.List" %>
<%
    User currentUser = (User) session.getAttribute("user");
    List<CartItem> sessionCart = (List<CartItem>) session.getAttribute("cart");
    int cartCount = 0;
    if (sessionCart != null) {
        for (CartItem ci : sessionCart) {
            cartCount += ci.getQuantity();
        }
    }
    String userInitial = (currentUser != null && currentUser.getName() != null && !currentUser.getName().isEmpty())
            ? currentUser.getName().substring(0, 1).toUpperCase() : "U";
%>
<!-- Global Head Assets & Meta -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@600;700;800&family=Outfit:wght@400;500;600;700;800&family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">

<nav class="navbar">
    <div class="nav-container">
        <!-- Logo -->
        <a href="<%= request.getContextPath() %>/books" class="logo">
            <div class="logo-icon-wrapper">
                <i class="fas fa-book-bookmark"></i>
            </div>
            <span class="logo-text">BookStore</span>
        </a>

        <!-- Desktop Navigation Links -->
        <div class="nav-links">
            <a href="<%= request.getContextPath() %>/books" class="nav-item">
                <i class="fas fa-compass"></i> Explore
            </a>

            <% if (currentUser != null && "ADMIN".equalsIgnoreCase(currentUser.getRole())) { %>
                <a href="<%= request.getContextPath() %>/admin/books" class="nav-item">
                    <i class="fas fa-boxes-stacked"></i> Manage Books
                </a>
                <a href="<%= request.getContextPath() %>/admin/orders" class="nav-item">
                    <i class="fas fa-clipboard-list"></i> Manage Orders
                </a>
            <% } else { %>
                <a href="<%= request.getContextPath() %>/cart" class="cart-pill">
                    <i class="fas fa-shopping-bag"></i> Cart
                    <span class="cart-count-badge <%= cartCount > 0 ? "has-items" : "" %>" id="navCartCount"><%= cartCount %></span>
                </a>
                <% if (currentUser != null) { %>
                    <a href="<%= request.getContextPath() %>/orders" class="nav-item">
                        <i class="fas fa-clock-rotate-left"></i> My Orders
                    </a>
                    <a href="<%= request.getContextPath() %>/profile" class="nav-item">
                        <i class="fas fa-user"></i> Profile
                    </a>
                <% } %>
            <% } %>

            <!-- Theme Toggle Button -->
            <button class="theme-toggle-btn" type="button" aria-label="Toggle Theme">
                <i class="fas fa-sun"></i>
            </button>

            <!-- User Auth Controls -->
            <% if (currentUser != null) { %>
                <div class="user-pill">
                    <span class="user-avatar-initials"><%= userInitial %></span>
                    <span><%= currentUser.getName() %></span>
                    <% if ("ADMIN".equalsIgnoreCase(currentUser.getRole())) { %>
                        <span class="badge badge-cat" style="font-size:0.65rem; padding: 0.15rem 0.4rem;">Admin</span>
                    <% } %>
                </div>
                <a href="<%= request.getContextPath() %>/logout" class="btn btn-danger btn-sm">
                    <i class="fas fa-arrow-right-from-bracket"></i> Logout
                </a>
            <% } else { %>
                <a href="<%= request.getContextPath() %>/login" class="btn btn-secondary btn-sm">
                    <i class="fas fa-arrow-right-to-bracket"></i> Sign In
                </a>
                <a href="<%= request.getContextPath() %>/register" class="btn btn-primary btn-sm">
                    <i class="fas fa-user-plus"></i> Register
                </a>
            <% } %>
        </div>

        <!-- Mobile Actions (Cart + Menu Toggle) -->
        <div class="mobile-actions">
            <% if (currentUser == null || !"ADMIN".equalsIgnoreCase(currentUser.getRole())) { %>
                <a href="<%= request.getContextPath() %>/cart" class="mobile-cart-btn" aria-label="Shopping Cart">
                    <i class="fas fa-shopping-bag"></i>
                    <span class="cart-count-badge <%= cartCount > 0 ? "has-items" : "" %>" id="mobileCartCount"><%= cartCount %></span>
                </a>
            <% } %>
            <button class="mobile-nav-toggle" id="mobileNavToggle" aria-label="Open Navigation Menu">
                <i class="fas fa-bars"></i>
            </button>
        </div>
    </div>
</nav>

<!-- Mobile Drawer Navigation -->
<div class="mobile-drawer" id="mobileNavDrawer">
    <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid var(--border-color); padding-bottom: 1rem;">
        <span style="font-weight: 700; font-size: 1.1rem;">Menu</span>
        <button class="theme-toggle-btn" type="button" aria-label="Toggle Theme">
            <i class="fas fa-sun"></i>
        </button>
    </div>

    <a href="<%= request.getContextPath() %>/books" class="nav-item">
        <i class="fas fa-compass"></i> Explore Catalog
    </a>

    <% if (currentUser != null && "ADMIN".equalsIgnoreCase(currentUser.getRole())) { %>
        <a href="<%= request.getContextPath() %>/admin/books" class="nav-item">
            <i class="fas fa-boxes-stacked"></i> Manage Books
        </a>
        <a href="<%= request.getContextPath() %>/admin/orders" class="nav-item">
            <i class="fas fa-clipboard-list"></i> Manage Orders
        </a>
    <% } else { %>
        <a href="<%= request.getContextPath() %>/cart" class="nav-item">
            <i class="fas fa-shopping-bag"></i> Cart (<%= cartCount %>)
        </a>
        <% if (currentUser != null) { %>
            <a href="<%= request.getContextPath() %>/orders" class="nav-item">
                <i class="fas fa-clock-rotate-left"></i> My Orders
            </a>
            <a href="<%= request.getContextPath() %>/profile" class="nav-item">
                <i class="fas fa-user"></i> Profile
            </a>
        <% } %>
    <% } %>

    <div style="margin-top: auto; display: flex; flex-direction: column; gap: 0.75rem;">
        <% if (currentUser != null) { %>
            <div style="padding: 0.5rem 0; color: var(--text-secondary); font-size: 0.9rem;">
                Logged in as <strong><%= currentUser.getName() %></strong>
            </div>
            <a href="<%= request.getContextPath() %>/logout" class="btn btn-danger">
                <i class="fas fa-arrow-right-from-bracket"></i> Logout
            </a>
        <% } else { %>
            <a href="<%= request.getContextPath() %>/login" class="btn btn-secondary">
                <i class="fas fa-arrow-right-to-bracket"></i> Sign In
            </a>
            <a href="<%= request.getContextPath() %>/register" class="btn btn-primary">
                <i class="fas fa-user-plus"></i> Register
            </a>
        <% } %>
    </div>
</div>
<div class="mobile-drawer-overlay" id="mobileNavOverlay"></div>

<!-- Seamless 3D Book Opening Motion Graphic Loader -->
<div id="bookIntroSplash" class="book-splash-overlay">
    <div class="book-splash-ambient"></div>
    <div class="book-splash-wrap">
        <div class="book-splash-book" id="splashBook">
            <div class="splash-spine"></div>
            <div class="splash-back-cover"></div>
            <div class="splash-page splash-page-base-left">
                <div class="splash-page-inner">
                    <div class="splash-page-lines"></div>
                </div>
            </div>
            <div class="splash-page splash-leaf splash-leaf-1"></div>
            <div class="splash-page splash-leaf splash-leaf-2"></div>
            <div class="splash-page splash-leaf splash-leaf-3"></div>
            <div class="splash-page splash-page-base-right">
                <div class="splash-page-inner">
                    <div class="splash-page-lines"></div>
                </div>
            </div>
            <div class="splash-cover" id="splashCover">
                <div class="splash-cover-face splash-cover-front">
                    <div class="splash-cover-border">
                        <i class="fas fa-book-bookmark splash-icon"></i>
                        <span class="splash-title">BookStore</span>
                    </div>
                </div>
                <div class="splash-cover-face splash-cover-inside"></div>
            </div>
            <div class="splash-glow-core"></div>
        </div>
        <div class="splash-shadow"></div>
    </div>
</div>

<!-- Include Global Frontend Engine -->
<script src="<%= request.getContextPath() %>/js/main.js"></script>

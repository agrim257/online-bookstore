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

            <!-- 3D Book Experience Button -->
            <button class="nav-item-btn" id="btnReplayIntro" type="button" title="Experience 3D Opening Book" style="background: rgba(245, 158, 11, 0.1); border: 1px solid rgba(245, 158, 11, 0.3); color: #fbbf24; cursor: pointer; display: flex; align-items: center; gap: 0.45rem; font-size: 0.85rem; font-weight: 600; padding: 0.4rem 0.8rem; border-radius: var(--radius-full); transition: var(--transition-fast);">
                <i class="fas fa-book-open"></i>
                <span>Open Book</span>
            </button>

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

        <!-- Mobile Nav Toggle -->
        <button class="mobile-nav-toggle" id="mobileNavToggle" aria-label="Open Navigation Menu">
            <i class="fas fa-bars"></i>
        </button>
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

<!-- 3D Book Opening Welcome Experience Overlay -->
<div id="bookOpeningOverlay" class="book-intro-overlay">
    <div class="book-intro-backdrop-glow"></div>
    
    <div class="book-intro-topbar">
        <span class="intro-tag">
            <i class="fas fa-sparkles"></i> The Grand Literary Experience
        </span>
        <button type="button" class="btn-intro-skip" id="btnSkipIntro">
            Skip to Store <i class="fas fa-arrow-right"></i>
        </button>
    </div>

    <div class="book-stage">
        <div class="book-3d" id="introBook">
            <!-- Spine -->
            <div class="book-spine">
                <span>✦</span>
                <span style="writing-mode: vertical-rl; transform: rotate(180deg); letter-spacing: 0.2em; font-family: 'Cinzel', serif;">BOOKSTORE</span>
                <span>✦</span>
            </div>
            
            <!-- Back Cover -->
            <div class="book-cover-back"></div>
            
            <!-- Left Inside Page (Fixed) -->
            <div class="book-page page-left">
                <div class="page-content">
                    <div>
                        <div class="page-header">
                            <span><i class="fas fa-feather-pointed"></i> Proem</span>
                            <span>Folio I</span>
                        </div>
                        <h3 class="page-quote-heading">The Magic of Reading</h3>
                        <p class="page-dropcap-text">
                            <span class="dropcap">A</span> reader lives a thousand lives before he dies. The man who never reads lives only one.
                        </p>
                        <p class="page-subtext">
                            Within these digital shelves lie thousands of stories, wisdom, and journeys waiting to be discovered.
                        </p>
                    </div>
                    <div class="page-flourish">❦ ✦ ❦</div>
                </div>
            </div>

            <!-- Page 1 (Flipping Leaf) -->
            <div class="book-page page-flip page-1" id="flipPage1">
                <div class="page-face page-front">
                    <div class="page-content">
                        <div>
                            <div class="page-header">
                                <span>Collection</span>
                                <span>Folio II</span>
                            </div>
                            <h4 style="font-family: 'Cinzel', serif; font-size: 1.05rem; color: #1e1b4b; margin-bottom: 0.8rem;">Masterpieces & Guides</h4>
                            <p style="font-size: 0.85rem; line-height: 1.6; color: #475569;">
                                Hand-curated technology manuals, timeless classics, and insightful non-fiction bound for curious readers.
                            </p>
                        </div>
                        <div style="font-family: 'Cinzel', serif; font-size: 0.8rem; color: #b45309; text-align: center;">✦ Curated with Care ✦</div>
                    </div>
                </div>
                <div class="page-face page-back">
                    <div class="page-content">
                        <div class="page-header">
                            <span>Archives</span>
                            <span>Folio III</span>
                        </div>
                        <p style="font-size: 0.85rem; color: #64748b; line-height: 1.6;">
                            Turning pages to unveil your next great read...
                        </p>
                    </div>
                </div>
            </div>

            <!-- Page 2 (Flipping Leaf) -->
            <div class="book-page page-flip page-2" id="flipPage2">
                <div class="page-face page-front">
                    <div class="page-content">
                        <div class="page-header">
                            <span>Catalog</span>
                            <span>Folio IV</span>
                        </div>
                        <p style="font-size: 0.85rem; color: #475569;">
                            Fast Indian delivery, collector hardcover prints, and authentic copies.
                        </p>
                    </div>
                </div>
                <div class="page-face page-back">
                    <div class="page-content">
                        <div class="page-header">
                            <span>Welcome</span>
                            <span>Folio V</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right Inside Page (Fixed Action Page) -->
            <div class="book-page page-right">
                <div class="book-ribbon"></div>
                <div class="page-content">
                    <div>
                        <div class="page-header">
                            <span>Volume 2026</span>
                            <i class="fas fa-bookmark" style="color: #dc2626;"></i>
                        </div>
                        <h2 class="page-welcome-title">Enter The Library</h2>
                        <p class="page-subtext">
                            Discover bestsellers, engineering standards, and timeless classics at real Indian Rupee rates.
                        </p>

                        <div class="book-welcome-badges">
                            <span class="badge"><i class="fas fa-laptop-code"></i> Technology</span>
                            <span class="badge"><i class="fas fa-masks-theater"></i> Fiction</span>
                            <span class="badge"><i class="fas fa-landmark"></i> History</span>
                        </div>
                    </div>

                    <button type="button" class="btn btn-primary btn-enter-store" id="btnEnterStore">
                        <i class="fas fa-compass"></i> Step Inside Store
                    </button>
                </div>
            </div>

            <!-- Front Hardcover -->
            <div class="book-cover-front" id="bookFrontCover" title="Click to Open or Close Book">
                <div class="cover-exterior">
                    <div class="cover-emboss-border">
                        <div class="cover-filigree">❦</div>
                        <div class="cover-icon">
                            <i class="fas fa-book-bookmark"></i>
                        </div>
                        <h1 class="cover-main-title">BookStore</h1>
                        <div class="cover-sub-title">Grand Literary Archive</div>
                        <div class="cover-filigree">❦</div>
                        <div class="cover-year">M M X X V I</div>
                    </div>
                    <div class="cover-clasp"></div>
                </div>
                <div class="cover-interior">
                    <div class="marbled-paper"></div>
                </div>
            </div>
        </div>

        <div class="book-pedestal-shadow"></div>
        <div class="book-light-rays"></div>
    </div>

    <div class="book-intro-controls">
        <button type="button" class="intro-action-btn" id="btnToggleBookState">
            <i class="fas fa-book-open"></i> <span id="toggleBookBtnText">Open Book</span>
        </button>
    </div>
</div>

<!-- Include Global Frontend Engine -->
<script src="<%= request.getContextPath() %>/js/main.js"></script>

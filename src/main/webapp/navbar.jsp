<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tap.model.User" %>
<%@ page import="com.tap.model.Cart" %>
<%
    // Session state retrieval
    User navUser = (User) session.getAttribute("user");
    Cart navCart = (Cart) session.getAttribute("cart");
    int navCartCount = 0;
    if (navCart != null && navCart.getItems() != null) {
        navCartCount = navCart.getItems().size();
    }
%>

<!-- FastX Official Fonts -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Plus+Jakarta+Sans:wght@500;600;700;800;900&display=swap" rel="stylesheet">

<!-- FastX External Navbar Stylesheet -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/navbar.css">

<!-- Self-Contained Modal Styles (Prevents CSS Caching Issues) -->
<style>
    /* Hidden by default with display: none */
    #fastxLogoutModal {
        display: none;
        position: fixed;
        top: 0;
        left: 0;
        width: 100vw;
        height: 100vh;
        background: rgba(0, 51, 42, 0.65);
        backdrop-filter: blur(8px);
        -webkit-backdrop-filter: blur(8px);
        z-index: 999999;
        align-items: center;
        justify-content: center;
        padding: 20px;
        box-sizing: border-box;
    }

    #fastxLogoutModal .fastx-modal-card {
        background: #ffffff;
        border-radius: 20px;
        max-width: 400px;
        width: 100%;
        padding: 32px 28px;
        text-align: center;
        box-shadow: 0 20px 45px rgba(0, 71, 60, 0.3);
        border: 1px solid rgba(0, 71, 60, 0.12);
        animation: fastxModalPop 0.25s cubic-bezier(0.16, 1, 0.3, 1);
    }

    @keyframes fastxModalPop {
        from { transform: scale(0.85); opacity: 0; }
        to { transform: scale(1); opacity: 1; }
    }

    #fastxLogoutModal .fastx-modal-icon-wrap {
        width: 60px;
        height: 60px;
        background: rgba(185, 28, 28, 0.08);
        color: #b91c1c;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 26px;
        margin: 0 auto 16px auto;
        border: 1px solid rgba(185, 28, 28, 0.15);
    }

    #fastxLogoutModal .fastx-modal-title {
        font-family: 'Plus Jakarta Sans', sans-serif;
        font-size: 20px;
        font-weight: 800;
        color: #00473c;
        margin-bottom: 8px;
    }

    #fastxLogoutModal .fastx-modal-desc {
        font-family: 'Inter', sans-serif;
        font-size: 14px;
        color: #5e6d5e;
        line-height: 1.5;
        margin-bottom: 24px;
    }

    #fastxLogoutModal .fastx-modal-actions {
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 12px;
    }

    #fastxLogoutModal .fastx-modal-btn-cancel {
        flex: 1;
        background: #f4f8f3;
        color: #00473c;
        border: 1px solid rgba(0, 71, 60, 0.15);
        font-family: 'Plus Jakarta Sans', sans-serif;
        font-size: 14px;
        font-weight: 700;
        padding: 12px 16px;
        border-radius: 50px;
        cursor: pointer;
        transition: all 0.2s ease;
    }

    #fastxLogoutModal .fastx-modal-btn-cancel:hover {
        background: rgba(0, 71, 60, 0.08);
    }

    #fastxLogoutModal .fastx-modal-btn-confirm {
        flex: 1;
        background: #b91c1c;
        color: #ffffff;
        border: none;
        font-family: 'Plus Jakarta Sans', sans-serif;
        font-size: 14px;
        font-weight: 800;
        padding: 12px 16px;
        border-radius: 50px;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        box-shadow: 0 4px 14px rgba(185, 28, 28, 0.3);
        transition: all 0.2s ease;
    }

    #fastxLogoutModal .fastx-modal-btn-confirm:hover {
        background: #991b1b;
        transform: translateY(-1px);
    }
</style>

<!-- FastX Unified Navbar Component -->
<nav class="fastx-navbar">
    <div class="fastx-nav-container">
        
        <!-- Brand Logo -->
        <a href="${pageContext.request.contextPath}/index.jsp" class="fastx-nav-brand">
            FastX
        </a>

        <!-- Main Navigation Links -->
        <ul class="fastx-nav-menu">
            <li class="fastx-nav-item">
                <a href="${pageContext.request.contextPath}/index.jsp" class="fastx-nav-link">
                    <span>🏠</span> Home
                </a>
            </li>
            <li class="fastx-nav-item">
                <a href="${pageContext.request.contextPath}/restaurant" class="fastx-nav-link">
                    <span>🍽️</span> Restaurants
                </a>
            </li>
            <li class="fastx-nav-item">
                <a href="${pageContext.request.contextPath}/cart.jsp" class="fastx-nav-link fastx-cart-btn">
                    <span>🛒</span> Cart
                    <span class="fastx-cart-badge"><%= navCartCount %></span>
                </a>
            </li>
            <li class="fastx-nav-item">
                <a href="<%= (navUser != null) ? (request.getContextPath() + "/orders") : (request.getContextPath() + "/login.jsp?redirect=" + request.getContextPath() + "/orders") %>" class="fastx-nav-link">
                    <span>📦</span> Orders
                </a>
            </li>
        </ul>

        <!-- Authentication / User State Actions -->
        <div class="fastx-nav-auth">
            <% if (navUser == null) { %>
                <!-- STATE 1: BEFORE LOGIN (Guest) -->
                <a href="${pageContext.request.contextPath}/login.jsp" class="fastx-login-btn">
                    <span>🔐</span> Login
                </a>
                <a href="${pageContext.request.contextPath}/register.jsp" class="fastx-signup-btn">
                    <span>✨</span> Sign Up
                </a>
            <% } else { %>
                <!-- STATE 2: AFTER LOGIN (Customer Profile & Logout Button) -->
                <a href="${pageContext.request.contextPath}/profile.jsp" class="fastx-profile-pill">
                    <span class="fastx-avatar-circle">
                        <%= (navUser.getUsername() != null && !navUser.getUsername().isEmpty()) 
                                ? navUser.getUsername().substring(0, 1).toUpperCase() 
                                : "U" %>
                    </span>
                    <span><%= (navUser.getUsername() != null) ? navUser.getUsername() : "Profile" %></span>
                </a>
                <button type="button" class="fastx-logout-btn" onclick="openLogoutModal(event)" title="Sign Out">
                    <span>🚪</span> Logout
                </button>
            <% } %>
        </div>

    </div>
</nav>

<!-- ==========================================================================
     LOGOUT CONFIRMATION POPUP MODAL (Hidden by default)
     ========================================================================== -->
<div id="fastxLogoutModal" onclick="handleLogoutModalBackdrop(event)">
    <div class="fastx-modal-card" onclick="event.stopPropagation()">
        <div class="fastx-modal-icon-wrap">
            🚪
        </div>
        <h3 class="fastx-modal-title">Sign Out from FastX?</h3>
        <p class="fastx-modal-desc">
            Are you sure you want to log out? You will need to sign back in to view your orders and complete checkout.
        </p>
        <div class="fastx-modal-actions">
            <button type="button" class="fastx-modal-btn-cancel" onclick="closeLogoutModal()">
                Stay Logged In
            </button>
            <a href="${pageContext.request.contextPath}/logout" class="fastx-modal-btn-confirm">
                Yes, Sign Out
            </a>
        </div>
    </div>
</div>

<script>
    function openLogoutModal(event) {
        if (event) event.preventDefault();
        const modal = document.getElementById('fastxLogoutModal');
        if (modal) {
            modal.style.display = 'flex';
            document.body.style.overflow = 'hidden';
        }
    }

    function closeLogoutModal() {
        const modal = document.getElementById('fastxLogoutModal');
        if (modal) {
            modal.style.display = 'none';
            document.body.style.overflow = '';
        }
    }

    function handleLogoutModalBackdrop(event) {
        if (event.target === document.getElementById('fastxLogoutModal')) {
            closeLogoutModal();
        }
    }

    // Close on Escape key press
    document.addEventListener('keydown', function(event) {
        if (event.key === 'Escape') {
            closeLogoutModal();
        }
    });
</script>

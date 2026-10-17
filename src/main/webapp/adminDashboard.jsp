<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tap.model.User" %>
<%@ page import="com.tap.model.Restaurant" %>
<%@ page import="com.tap.model.Menu" %>
<%@ page import="com.tap.model.Order" %>
<%@ page import="java.util.List" %>
<%
    // Ensure admin session
    User adminUser = (User) session.getAttribute("user");
    if (adminUser == null || !"ADMIN".equalsIgnoreCase(adminUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/adminLogin.jsp?error=Admin session required");
        return;
    }

    Double totalRevenueObj = (Double) request.getAttribute("totalRevenue");
    double totalRevenue = (totalRevenueObj != null) ? totalRevenueObj : 0.0;

    Integer totalOrdersObj = (Integer) request.getAttribute("totalOrders");
    int totalOrders = (totalOrdersObj != null) ? totalOrdersObj : 0;

    Integer totalRestaurantsObj = (Integer) request.getAttribute("totalRestaurants");
    int totalRestaurants = (totalRestaurantsObj != null) ? totalRestaurantsObj : 0;

    Integer totalDishesObj = (Integer) request.getAttribute("totalDishes");
    int totalDishes = (totalDishesObj != null) ? totalDishesObj : 0;

    List<Restaurant> restaurantList = (List<Restaurant>) request.getAttribute("restaurantList");
    List<Menu> menuList = (List<Menu>) request.getAttribute("menuList");
    List<Order> orderList = (List<Order>) request.getAttribute("orderList");

    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Executive Admin Dashboard — FastX</title>

  <!-- Google Fonts -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Plus+Jakarta+Sans:wght@600;700;800;900&display=swap" rel="stylesheet">

  <!-- Admin Dashboard External Stylesheet -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/adminDashboard.css">

  <!-- Cache-Busting Executive Button & Modal Styles -->
  <style>
    /* Primary Action Buttons */
    .btn-add-primary {
      background: linear-gradient(135deg, #e6ff55 0%, #b8f024 100%) !important;
      color: #00261f !important;
      font-family: 'Plus Jakarta Sans', sans-serif !important;
      font-size: 13.5px !important;
      font-weight: 800 !important;
      padding: 10px 22px !important;
      border-radius: 9999px !important;
      border: 1px solid rgba(230, 255, 85, 0.4) !important;
      cursor: pointer !important;
      display: inline-flex !important;
      align-items: center !important;
      gap: 8px !important;
      box-shadow: 0 4px 18px rgba(230, 255, 85, 0.35) !important;
      transition: all 0.25s cubic-bezier(0.16, 1, 0.3, 1) !important;
      letter-spacing: 0.2px !important;
    }
    .btn-add-primary:hover {
      transform: translateY(-2px) !important;
      box-shadow: 0 8px 25px rgba(230, 255, 85, 0.55) !important;
      background: linear-gradient(135deg, #f0ff7a 0%, #c4f538 100%) !important;
    }

    .table-actions-cell {
      display: flex !important;
      align-items: center !important;
      gap: 8px !important;
      justify-content: center !important;
    }

    /* Action Buttons in Tables */
    .btn-action-dishes {
      background: rgba(230, 255, 85, 0.12) !important;
      color: #e6ff55 !important;
      border: 1px solid rgba(230, 255, 85, 0.35) !important;
      font-family: 'Plus Jakarta Sans', sans-serif !important;
      font-size: 12px !important;
      font-weight: 800 !important;
      padding: 7px 14px !important;
      border-radius: 8px !important;
      cursor: pointer !important;
      display: inline-flex !important;
      align-items: center !important;
      gap: 5px !important;
      transition: all 0.2s ease !important;
      white-space: nowrap !important;
    }
    .btn-action-dishes:hover {
      background: #e6ff55 !important;
      color: #00261f !important;
      box-shadow: 0 4px 14px rgba(230, 255, 85, 0.35) !important;
      transform: translateY(-1px) !important;
    }

    .btn-action-edit {
      background: rgba(59, 130, 246, 0.14) !important;
      color: #93c5fd !important;
      border: 1px solid rgba(59, 130, 246, 0.35) !important;
      font-family: 'Plus Jakarta Sans', sans-serif !important;
      font-size: 12px !important;
      font-weight: 800 !important;
      padding: 7px 14px !important;
      border-radius: 8px !important;
      cursor: pointer !important;
      display: inline-flex !important;
      align-items: center !important;
      gap: 5px !important;
      transition: all 0.2s ease !important;
      white-space: nowrap !important;
    }
    .btn-action-edit:hover {
      background: #3b82f6 !important;
      color: #ffffff !important;
      box-shadow: 0 4px 14px rgba(59, 130, 246, 0.45) !important;
      transform: translateY(-1px) !important;
    }

    .btn-action-delete {
      background: rgba(239, 68, 68, 0.12) !important;
      color: #fca5a5 !important;
      border: 1px solid rgba(239, 68, 68, 0.35) !important;
      font-family: 'Plus Jakarta Sans', sans-serif !important;
      font-size: 12px !important;
      font-weight: 800 !important;
      padding: 7px 12px !important;
      border-radius: 8px !important;
      cursor: pointer !important;
      text-decoration: none !important;
      display: inline-flex !important;
      align-items: center !important;
      justify-content: center !important;
      transition: all 0.2s ease !important;
    }
    .btn-action-delete:hover {
      background: #ef4444 !important;
      color: #ffffff !important;
      box-shadow: 0 4px 14px rgba(239, 68, 68, 0.45) !important;
      transform: translateY(-1px) !important;
    }

    /* Modal Overlay & Card */
    .modal-overlay {
      position: fixed !important;
      top: 0 !important;
      left: 0 !important;
      width: 100vw !important;
      height: 100vh !important;
      background: rgba(0, 15, 12, 0.85) !important;
      backdrop-filter: blur(10px) !important;
      -webkit-backdrop-filter: blur(10px) !important;
      display: none;
      align-items: center !important;
      justify-content: center !important;
      z-index: 9999 !important;
      padding: 20px !important;
    }
    .modal-overlay.active {
      display: flex !important;
    }

    .modal-card {
      background: #002b23 !important;
      border: 1px solid rgba(230, 255, 85, 0.28) !important;
      border-radius: 24px !important;
      width: 100% !important;
      max-width: 620px !important;
      max-height: 90vh !important;
      overflow-y: auto !important;
      padding: 30px 34px !important;
      box-shadow: 0 25px 70px rgba(0, 0, 0, 0.75), 0 0 40px rgba(230, 255, 85, 0.08) !important;
      position: relative !important;
    }

    .modal-header {
      display: flex !important;
      align-items: center !important;
      justify-content: space-between !important;
      margin-bottom: 24px !important;
      padding-bottom: 16px !important;
      border-bottom: 1px solid rgba(255, 255, 255, 0.08) !important;
    }

    .modal-title-group {
      display: flex !important;
      align-items: center !important;
      gap: 10px !important;
    }

    .modal-icon {
      font-size: 22px !important;
    }

    .modal-title {
      font-family: 'Plus Jakarta Sans', sans-serif !important;
      font-size: 20px !important;
      font-weight: 900 !important;
      color: #ffffff !important;
      letter-spacing: -0.3px !important;
    }

    .modal-close-btn {
      background: transparent !important;
      color: #94a39f !important;
      border: none !important;
      font-size: 28px !important;
      line-height: 1 !important;
      cursor: pointer !important;
      transition: all 0.2s ease !important;
    }
    .modal-close-btn:hover {
      color: #ffffff !important;
      transform: rotate(90deg) !important;
    }

    .modal-form-grid {
      display: grid !important;
      grid-template-columns: 1fr 1fr !important;
      gap: 16px !important;
      margin-bottom: 24px !important;
    }

    .form-group {
      display: flex !important;
      flex-direction: column !important;
      gap: 6px !important;
    }

    .form-group.full-width {
      grid-column: 1 / -1 !important;
    }

    .form-label {
      font-family: 'Plus Jakarta Sans', sans-serif !important;
      font-size: 11.5px !important;
      font-weight: 800 !important;
      color: #94a39f !important;
      letter-spacing: 0.5px !important;
      text-transform: uppercase !important;
    }

    .modal-input {
      background: #001f19 !important;
      border: 1px solid rgba(255, 255, 255, 0.14) !important;
      color: #ffffff !important;
      padding: 13px 16px !important;
      border-radius: 10px !important;
      font-family: 'Inter', sans-serif !important;
      font-size: 14px !important;
      outline: none !important;
      transition: all 0.2s ease !important;
      width: 100% !important;
      box-sizing: border-box !important;
    }
    .modal-input:focus {
      border-color: #e6ff55 !important;
      box-shadow: 0 0 0 3px rgba(230, 255, 85, 0.22) !important;
      background: #00241d !important;
    }
    .modal-input::placeholder {
      color: rgba(255, 255, 255, 0.3) !important;
    }

    .modal-actions-row {
      display: flex !important;
      align-items: center !important;
      justify-content: flex-end !important;
      gap: 12px !important;
      padding-top: 20px !important;
      border-top: 1px solid rgba(255, 255, 255, 0.08) !important;
    }

    .btn-modal-save {
      background: linear-gradient(135deg, #e6ff55 0%, #b8f024 100%) !important;
      color: #00261f !important;
      border: none !important;
      padding: 13px 28px !important;
      border-radius: 9999px !important;
      font-family: 'Plus Jakarta Sans', sans-serif !important;
      font-size: 14px !important;
      font-weight: 800 !important;
      cursor: pointer !important;
      transition: all 0.25s ease !important;
      box-shadow: 0 4px 15px rgba(230, 255, 85, 0.35) !important;
    }
    .btn-modal-save:hover {
      transform: translateY(-2px) !important;
      box-shadow: 0 8px 24px rgba(230, 255, 85, 0.5) !important;
    }

    .btn-modal-cancel {
      background: rgba(255, 255, 255, 0.06) !important;
      color: #94a39f !important;
      border: 1px solid rgba(255, 255, 255, 0.12) !important;
      padding: 13px 22px !important;
      border-radius: 9999px !important;
      font-family: 'Plus Jakarta Sans', sans-serif !important;
      font-size: 14px !important;
      font-weight: 700 !important;
      cursor: pointer !important;
      transition: all 0.2s ease !important;
    }
    .btn-modal-cancel:hover {
      background: rgba(255, 255, 255, 0.12) !important;
      color: #ffffff !important;
    }

    .stock-chip-in {
      background: rgba(16, 185, 129, 0.15) !important;
      color: #6ee7b7 !important;
      padding: 3px 10px !important;
      border-radius: 9999px !important;
      font-size: 12px !important;
      font-weight: 800 !important;
    }

    .stock-chip-out {
      background: rgba(239, 68, 68, 0.15) !important;
      color: #fca5a5 !important;
      padding: 3px 10px !important;
      border-radius: 9999px !important;
      font-size: 12px !important;
      font-weight: 800 !important;
    }
  </style>
</head>
<body>

  <!-- ==========================================================================
       1. TOP EXECUTIVE NAVBAR
       ========================================================================== -->
  <header class="admin-topbar">
    <div class="topbar-inner">
      <div class="brand-group">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="admin-logo">
          Fast<span>X</span> <span class="tag-badge">OPERATIONS</span>
        </a>
      </div>

      <div class="admin-profile-group">
        <div class="admin-user-pill">
          <span class="shield-dot">🛡️</span>
          <span><%= (adminUser.getUsername() != null) ? adminUser.getUsername() : "FastX Admin" %></span>
        </div>
        <a href="${pageContext.request.contextPath}/index.jsp" class="btn-customer-view" title="Visit Consumer Store">
          🌐 Customer Store
        </a>
        <a href="${pageContext.request.contextPath}/logout" class="btn-admin-logout" title="Exit Console">
          Sign Out
        </a>
      </div>
    </div>
  </header>

  <!-- ==========================================================================
       2. MAIN WORKSPACE
       ========================================================================== -->
  <main class="admin-wrapper">
    
    <!-- Hero Header -->
    <div class="console-hero">
      <div>
        <h1 class="console-title">Executive Command Center</h1>
        <p class="console-subtitle">Real-time platform operations, master kitchen directory, food catalog & orders.</p>
      </div>
      <div class="system-status-chip">
        <span class="live-dot"></span> System Live & Operational
      </div>
    </div>

    <!-- Alert / Status Notifications -->
    <% if ("restaurant_added".equalsIgnoreCase(msg)) { %>
      <div class="alert-banner alert-banner-success">
        <span>✅</span> Partner restaurant onboarded successfully to the database!
      </div>
    <% } else if ("restaurant_updated".equalsIgnoreCase(msg)) { %>
      <div class="alert-banner alert-banner-success">
        <span>✅</span> Restaurant details updated successfully!
      </div>
    <% } else if ("restaurant_deleted".equalsIgnoreCase(msg)) { %>
      <div class="alert-banner alert-banner-success">
        <span>✅</span> Restaurant removed successfully from the catalog.
      </div>
    <% } else if ("dish_added".equalsIgnoreCase(msg)) { %>
      <div class="alert-banner alert-banner-success">
        <span>✅</span> Food item added successfully to the kitchen catalog!
      </div>
    <% } else if ("dish_updated".equalsIgnoreCase(msg)) { %>
      <div class="alert-banner alert-banner-success">
        <span>✅</span> Food item updated successfully!
      </div>
    <% } else if ("dish_deleted".equalsIgnoreCase(msg)) { %>
      <div class="alert-banner alert-banner-success">
        <span>✅</span> Dish removed successfully from the menu.
      </div>
    <% } %>

    <!-- 4 High-Level KPI Metric Cards -->
    <div class="kpi-grid">
      
      <!-- Card 1: Total Revenue -->
      <div class="kpi-card">
        <div class="kpi-icon-wrap" style="color: #10b981; background: rgba(16, 185, 129, 0.12);">
          💰
        </div>
        <div class="kpi-content">
          <span class="kpi-label">TOTAL PLATFORM REVENUE</span>
          <div class="kpi-value revenue">₹<%= String.format("%.2f", totalRevenue) %></div>
        </div>
      </div>

      <!-- Card 2: Total Orders -->
      <div class="kpi-card">
        <div class="kpi-icon-wrap" style="color: #3b82f6; background: rgba(59, 130, 246, 0.12);">
          📦
        </div>
        <div class="kpi-content">
          <span class="kpi-label">TOTAL ORDERS PLACED</span>
          <div class="kpi-value"><%= totalOrders %></div>
        </div>
      </div>

      <!-- Card 3: Partner Restaurants -->
      <div class="kpi-card">
        <div class="kpi-icon-wrap" style="color: #f59e0b; background: rgba(245, 158, 11, 0.12);">
          🍽️
        </div>
        <div class="kpi-content">
          <span class="kpi-label">PARTNER KITCHENS</span>
          <div class="kpi-value"><%= totalRestaurants %></div>
        </div>
      </div>

      <!-- Card 4: Total Dishes -->
      <div class="kpi-card">
        <div class="kpi-icon-wrap" style="color: #ec4899; background: rgba(236, 72, 153, 0.12);">
          🥗
        </div>
        <div class="kpi-content">
          <span class="kpi-label">CATALOG DISHES</span>
          <div class="kpi-value"><%= totalDishes %></div>
        </div>
      </div>

    </div>

    <!-- ==========================================================================
         3. INTERACTIVE MANAGEMENT WORKSPACE (Tabs)
         ========================================================================== -->
    <div class="workspace-card">
      
      <!-- Navigation Tabs -->
      <div class="tab-header-row">
        <div class="tab-buttons">
          <button type="button" class="tab-btn active" id="tabBtn-restaurants" onclick="switchTab('restaurants')">
            🍽️ Partner Restaurants (<%= totalRestaurants %>)
          </button>
          <button type="button" class="tab-btn" id="tabBtn-menus" onclick="switchTab('menus')">
            📜 Master Menu Catalog (<%= totalDishes %>)
          </button>
          <button type="button" class="tab-btn" id="tabBtn-orders" onclick="switchTab('orders')">
            📦 Customer Orders (<%= totalOrders %>)
          </button>
        </div>
      </div>

      <!-- TAB 1: RESTAURANTS DIRECTORY -->
      <div class="tab-panel active" id="panel-restaurants">
        <div class="panel-header-actions">
          <div>
            <h3>Active Restaurant Partners</h3>
            <p class="panel-instruction">Click <strong>Dishes</strong> on any kitchen to view and manage its individual menu.</p>
          </div>
          <!-- Clickable, Beautiful Add Restaurant Button -->
          <button type="button" id="btnOpenAddRestaurant" class="btn-add-primary" onclick="openAddRestaurantModal()">
            <span style="font-size: 15px;">➕</span> Onboard New Restaurant
          </button>
        </div>

        <div class="table-responsive">
          <table class="admin-data-table">
            <thead>
              <tr>
                <th>ID</th>
                <th>Kitchen</th>
                <th>Cuisine</th>
                <th>Delivery Time</th>
                <th>Rating</th>
                <th>Location</th>
                <th style="text-align: center;">Actions</th>
              </tr>
            </thead>
            <tbody>
              <% if (restaurantList != null && !restaurantList.isEmpty()) { 
                   for (Restaurant r : restaurantList) { 
                     String safeName = (r.getName() != null) ? r.getName().replace("'", "\\'") : "";
                     String safeCuisine = (r.getCuisineType() != null) ? r.getCuisineType().replace("'", "\\'") : "";
                     String safeAddress = (r.getAddress() != null) ? r.getAddress().replace("'", "\\'") : "";
                     String safeImage = (r.getImagePath() != null) ? r.getImagePath().replace("'", "\\'") : "";
              %>
                <tr>
                  <td><strong>#<%= r.getRestaurantId() %></strong></td>
                  <td>
                    <div class="table-dish-flex">
                      <img src="<%= (r.getImagePath() != null && !r.getImagePath().isEmpty()) ? r.getImagePath() : "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=100" %>" 
                           class="table-thumb" alt="<%= r.getName() %>" onerror="this.src='https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=100';">
                      <span class="kitchen-name"><%= r.getName() %></span>
                    </div>
                  </td>
                  <td><span class="table-chip"><%= r.getCuisineType() %></span></td>
                  <td>⚡ <%= r.getDeliveryTime() %> mins</td>
                  <td>⭐ <%= r.getRating() %></td>
                  <td class="text-muted"><%= r.getAddress() %></td>
                  <td>
                    <div class="table-actions-cell">
                      <!-- 1-Click Dishes Filter Button -->
                      <button type="button" class="btn-action-dishes" title="View <%= r.getName() %> Dishes"
                              onclick="filterDishesByRestaurant('<%= r.getRestaurantId() %>', '<%= safeName %>')">
                        📜 Dishes
                      </button>
                      <!-- Edit Modal Button -->
                      <button type="button" class="btn-action-edit" title="Edit <%= r.getName() %> Details"
                              onclick="openEditRestaurantModal('<%= r.getRestaurantId() %>', '<%= safeName %>', '<%= safeCuisine %>', '<%= r.getDeliveryTime() %>', '<%= safeAddress %>', '<%= r.getRating() %>', '<%= safeImage %>')">
                        ✏️ Edit
                      </button>
                      <!-- Delete Restaurant Button -->
                      <a href="${pageContext.request.contextPath}/admin/restaurant?action=delete&id=<%= r.getRestaurantId() %>" 
                         class="btn-action-delete" title="Delete Restaurant"
                         onclick="return confirm('Are you sure you want to delete <%= safeName %>? This cannot be undone.');">
                        🗑️
                      </a>
                    </div>
                  </td>
                </tr>
              <%   } 
                 } else { %>
                <tr>
                  <td colspan="7" class="text-center py-4">No restaurants currently registered in the database.</td>
                </tr>
              <% } %>
            </tbody>
          </table>
        </div>
      </div>

      <!-- TAB 2: MENU CATALOG (With Add, Edit, Delete Dishes) -->
      <div class="tab-panel" id="panel-menus">
        <div class="panel-header-actions">
          <div>
            <h3>Master Dish Catalog</h3>
            <p class="panel-instruction">Manage menu food items, prices, descriptions & stock status.</p>
          </div>
          <!-- Clickable, Beautiful Add Dish Button -->
          <button type="button" id="btnOpenAddDish" class="btn-add-primary" onclick="openAddDishModal()">
            <span style="font-size: 15px;">➕</span> Add New Dish
          </button>
        </div>

        <!-- Dynamic Filter Notification Banner -->
        <div id="menuFilterBanner" class="menu-filter-banner" style="display: none;">
          <div class="filter-banner-text">
            <span>🔍</span>
            <span>Viewing menu for: <strong id="filterRestaurantName"></strong> (<span id="filterDishCount">0</span> dishes)</span>
          </div>
          <div style="display: flex; gap: 8px;">
            <button type="button" class="btn-add-primary" style="padding: 6px 14px; font-size: 12px;" onclick="openAddDishModal()">
              ➕ Add Dish to <span id="btnFilterKitchenName">Kitchen</span>
            </button>
            <button type="button" class="btn-clear-filter" onclick="clearMenuFilter()">Show All Dishes</button>
          </div>
        </div>

        <div class="table-responsive">
          <table class="admin-data-table">
            <thead>
              <tr>
                <th>Dish ID</th>
                <th>Food Item</th>
                <th>Kitchen</th>
                <th>Category</th>
                <th>Price</th>
                <th>Stock</th>
                <th>Description</th>
                <th style="text-align: center;">Actions</th>
              </tr>
            </thead>
            <tbody id="menuTableBody">
              <% if (menuList != null && !menuList.isEmpty()) { 
                   for (Menu m : menuList) { 
                     String safeItemName = (m.getItemName() != null) ? m.getItemName().replace("'", "\\'") : "";
                     String safeDesc = (m.getDescription() != null) ? m.getDescription().replace("'", "\\'") : "";
                     String safeCategory = (m.getCategory() != null) ? m.getCategory().replace("'", "\\'") : "Main Course";
                     String safeDishImage = (m.getImagePath() != null) ? m.getImagePath().replace("'", "\\'") : "";
              %>
                <tr class="menu-item-row" data-restaurant-id="<%= m.getRestaurantId() %>">
                  <td>#<%= m.getMenuId() %></td>
                  <td>
                    <div class="table-dish-flex">
                      <img src="<%= (!safeDishImage.isEmpty()) ? safeDishImage : "https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=100" %>" 
                           class="table-thumb" alt="<%= m.getItemName() %>" onerror="this.src='https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=100';">
                      <span><strong><%= m.getItemName() %></strong></span>
                    </div>
                  </td>
                  <td><span class="table-chip">Kitchen #<%= m.getRestaurantId() %></span></td>
                  <td><span class="table-chip"><%= safeCategory %></span></td>
                  <td><strong style="color: var(--color-lime-glow); font-size: 14.5px;">₹<%= String.format("%.2f", m.getPrice()) %></strong></td>
                  <td>
                    <% if (m.isAvailable()) { %>
                      <span class="stock-chip-in">In Stock</span>
                    <% } else { %>
                      <span class="stock-chip-out">Out of Stock</span>
                    <% } %>
                  </td>
                  <td class="text-muted" style="max-width: 250px; font-size: 13px;"><%= m.getDescription() %></td>
                  <td>
                    <div class="table-actions-cell">
                      <!-- Edit Dish Button -->
                      <button type="button" class="btn-action-edit" title="Edit <%= m.getItemName() %>"
                              onclick="openEditDishModal('<%= m.getMenuId() %>', '<%= m.getRestaurantId() %>', '<%= safeItemName %>', '<%= safeCategory %>', '<%= m.getPrice() %>', '<%= m.isAvailable() %>', '<%= safeDishImage %>', '<%= safeDesc %>')">
                        ✏️ Edit
                      </button>
                      <!-- Delete Dish Button -->
                      <a href="${pageContext.request.contextPath}/admin/menu?action=delete&id=<%= m.getMenuId() %>" 
                         class="btn-action-delete" title="Delete Dish"
                         onclick="return confirm('Delete dish <%= safeItemName %> from the menu?');">
                        🗑️
                      </a>
                    </div>
                  </td>
                </tr>
              <%   } 
                 } else { %>
                <tr>
                  <td colspan="8" class="text-center py-4">No menu dishes currently found in database.</td>
                </tr>
              <% } %>
            </tbody>
          </table>
        </div>
      </div>

      <!-- TAB 3: CUSTOMER ORDERS STREAM -->
      <div class="tab-panel" id="panel-orders">
        <div class="panel-header-actions">
          <div>
            <h3>Customer Orders & Revenue Stream</h3>
            <p class="panel-instruction">Real-time order feed and transaction fulfillment.</p>
          </div>
          <span class="badge-total"><%= totalOrders %> Total Orders</span>
        </div>

        <div class="table-responsive">
          <table class="admin-data-table">
            <thead>
              <tr>
                <th>Order Ref</th>
                <th>Customer ID</th>
                <th>Kitchen ID</th>
                <th>Delivery Address</th>
                <th>Payment</th>
                <th>Amount Paid</th>
                <th>Status</th>
              </tr>
            </thead>
            <tbody>
              <% if (orderList != null && !orderList.isEmpty()) { 
                   for (Order ord : orderList) { 
                     String status = (ord.getOrderStatus() != null) ? ord.getOrderStatus() : "CONFIRMED";
              %>
                <tr>
                  <td><strong>#ORD-<%= ord.getOrderId() %></strong></td>
                  <td>User #<%= ord.getUserId() %></td>
                  <td>Kitchen #<%= ord.getRestaurantId() %></td>
                  <td class="text-muted" style="max-width: 250px;"><%= ord.getDeliveryAddress() %></td>
                  <td>💳 <%= ord.getPaymentMode() %></td>
                  <td><strong style="font-size: 15px; color: #10b981;">₹<%= String.format("%.2f", ord.getTotalAmount()) %></strong></td>
                  <td><span class="status-chip"><%= status %></span></td>
                </tr>
              <%   } 
                 } else { %>
                <tr>
                  <td colspan="7" class="text-center py-4">No customer orders placed yet.</td>
                </tr>
              <% } %>
            </tbody>
          </table>
        </div>
      </div>

    </div>

  </main>

  <!-- ==========================================================================
       4. MODALS (Add/Edit Restaurant & Add/Edit Menu Dishes)
       ========================================================================== -->

  <!-- MODAL 1: ADD NEW RESTAURANT -->
  <div id="addRestaurantModal" class="modal-overlay" style="display: none;">
    <div class="modal-card">
      <div class="modal-header">
        <div class="modal-title-group">
          <span class="modal-icon">➕</span>
          <h3 class="modal-title">Onboard New Restaurant</h3>
        </div>
        <button type="button" class="modal-close-btn" onclick="closeAddRestaurantModal()">&times;</button>
      </div>

      <form action="${pageContext.request.contextPath}/admin/restaurant" method="POST" class="modal-form">
        <input type="hidden" name="action" value="add">
        
        <div class="modal-form-grid">
          <div class="form-group full-width">
            <label class="form-label" for="addName">Restaurant Name *</label>
            <input type="text" id="addName" name="name" class="modal-input" placeholder="e.g. Nagarjuna Andhra Meal" required>
          </div>

          <div class="form-group">
            <label class="form-label" for="addCuisine">Cuisine Type *</label>
            <input type="text" id="addCuisine" name="cuisineType" class="modal-input" placeholder="e.g. South Indian, Biryani" required>
          </div>

          <div class="form-group">
            <label class="form-label" for="addDeliveryTime">Avg. Delivery Time (Minutes) *</label>
            <input type="number" id="addDeliveryTime" name="deliveryTime" class="modal-input" placeholder="30" min="5" max="180" value="30" required>
          </div>

          <div class="form-group">
            <label class="form-label" for="addRating">Initial Rating (1.0 - 5.0) *</label>
            <input type="number" step="0.1" id="addRating" name="rating" class="modal-input" placeholder="4.5" min="1.0" max="5.0" value="4.5" required>
          </div>

          <div class="form-group">
            <label class="form-label" for="addImagePath">Banner Image URL</label>
            <input type="url" id="addImagePath" name="imagePath" class="modal-input" placeholder="https://images.unsplash.com/...">
          </div>

          <div class="form-group full-width">
            <label class="form-label" for="addAddress">Location / Address *</label>
            <input type="text" id="addAddress" name="address" class="modal-input" placeholder="e.g. Indiranagar, 100ft Road, Bengaluru" required>
          </div>
        </div>

        <div class="modal-actions-row">
          <button type="button" class="btn-modal-cancel" onclick="closeAddRestaurantModal()">Cancel</button>
          <button type="submit" class="btn-modal-save">✓ Save Restaurant</button>
        </div>
      </form>
    </div>
  </div>

  <!-- MODAL 2: EDIT RESTAURANT DETAILS -->
  <div id="editRestaurantModal" class="modal-overlay" style="display: none;">
    <div class="modal-card">
      <div class="modal-header">
        <div class="modal-title-group">
          <span class="modal-icon">✏️</span>
          <h3 class="modal-title">Edit Restaurant Details</h3>
        </div>
        <button type="button" class="modal-close-btn" onclick="closeEditRestaurantModal()">&times;</button>
      </div>

      <form action="${pageContext.request.contextPath}/admin/restaurant" method="POST" class="modal-form">
        <input type="hidden" name="action" value="update">
        <input type="hidden" id="editRestaurantId" name="restaurantId" value="">
        
        <div class="modal-form-grid">
          <div class="form-group full-width">
            <label class="form-label" for="editName">Restaurant Name *</label>
            <input type="text" id="editName" name="name" class="modal-input" required>
          </div>

          <div class="form-group">
            <label class="form-label" for="editCuisine">Cuisine Type *</label>
            <input type="text" id="editCuisine" name="cuisineType" class="modal-input" required>
          </div>

          <div class="form-group">
            <label class="form-label" for="editDeliveryTime">Delivery Time (Mins) *</label>
            <input type="number" id="editDeliveryTime" name="deliveryTime" class="modal-input" min="5" max="180" required>
          </div>

          <div class="form-group">
            <label class="form-label" for="editRating">Rating (1.0 - 5.0) *</label>
            <input type="number" step="0.1" id="editRating" name="rating" class="modal-input" min="1.0" max="5.0" required>
          </div>

          <div class="form-group">
            <label class="form-label" for="editImagePath">Banner Image URL</label>
            <input type="url" id="editImagePath" name="imagePath" class="modal-input">
          </div>

          <div class="form-group full-width">
            <label class="form-label" for="editAddress">Location / Address *</label>
            <input type="text" id="editAddress" name="address" class="modal-input" required>
          </div>
        </div>

        <div class="modal-actions-row">
          <button type="button" class="btn-modal-cancel" onclick="closeEditRestaurantModal()">Cancel</button>
          <button type="submit" class="btn-modal-save">✓ Update Restaurant</button>
        </div>
      </form>
    </div>
  </div>

  <!-- MODAL 3: ADD NEW DISH -->
  <div id="addDishModal" class="modal-overlay" style="display: none;">
    <div class="modal-card">
      <div class="modal-header">
        <div class="modal-title-group">
          <span class="modal-icon">🥗</span>
          <h3 class="modal-title">Add New Dish</h3>
        </div>
        <button type="button" class="modal-close-btn" onclick="closeAddDishModal()">&times;</button>
      </div>

      <form action="${pageContext.request.contextPath}/admin/menu" method="POST" class="modal-form">
        <input type="hidden" name="action" value="add">
        
        <div class="modal-form-grid">
          <div class="form-group full-width">
            <label class="form-label" for="addDishRestaurantId">Kitchen / Restaurant *</label>
            <select id="addDishRestaurantId" name="restaurantId" class="modal-input" required>
              <% if (restaurantList != null) {
                   for (Restaurant r : restaurantList) { %>
                <option value="<%= r.getRestaurantId() %>">#<%= r.getRestaurantId() %> — <%= r.getName() %></option>
              <%   }
                 } %>
            </select>
          </div>

          <div class="form-group">
            <label class="form-label" for="addDishName">Food Item Name *</label>
            <input type="text" id="addDishName" name="itemName" class="modal-input" placeholder="e.g. Butter Chicken Curry" required>
          </div>

          <div class="form-group">
            <label class="form-label" for="addDishPrice">Price (₹) *</label>
            <input type="number" step="0.5" id="addDishPrice" name="price" class="modal-input" placeholder="280.00" min="1" required>
          </div>

          <div class="form-group">
            <label class="form-label" for="addDishCategory">Category *</label>
            <input type="text" id="addDishCategory" name="category" class="modal-input" placeholder="e.g. Main Course, Biryani, Starters" value="Main Course" required>
          </div>

          <div class="form-group">
            <label class="form-label" for="addDishImagePath">Dish Photo URL</label>
            <input type="url" id="addDishImagePath" name="imagePath" class="modal-input" placeholder="https://images.unsplash.com/...">
          </div>

          <div class="form-group full-width">
            <label class="form-label" for="addDishDescription">Description *</label>
            <input type="text" id="addDishDescription" name="description" class="modal-input" placeholder="Brief delicious description of the dish..." required>
          </div>
        </div>

        <div class="modal-actions-row">
          <button type="button" class="btn-modal-cancel" onclick="closeAddDishModal()">Cancel</button>
          <button type="submit" class="btn-modal-save">✓ Save Dish</button>
        </div>
      </form>
    </div>
  </div>

  <!-- MODAL 4: EDIT DISH DETAILS -->
  <div id="editDishModal" class="modal-overlay" style="display: none;">
    <div class="modal-card">
      <div class="modal-header">
        <div class="modal-title-group">
          <span class="modal-icon">✏️</span>
          <h3 class="modal-title">Edit Dish Details</h3>
        </div>
        <button type="button" class="modal-close-btn" onclick="closeEditDishModal()">&times;</button>
      </div>

      <form action="${pageContext.request.contextPath}/admin/menu" method="POST" class="modal-form">
        <input type="hidden" name="action" value="update">
        <input type="hidden" id="editMenuId" name="menuId" value="">
        <input type="hidden" id="editDishRestaurantId" name="restaurantId" value="">
        
        <div class="modal-form-grid">
          <div class="form-group full-width">
            <label class="form-label" for="editDishName">Food Item Name *</label>
            <input type="text" id="editDishName" name="itemName" class="modal-input" required>
          </div>

          <div class="form-group">
            <label class="form-label" for="editDishPrice">Price (₹) *</label>
            <input type="number" step="0.5" id="editDishPrice" name="price" class="modal-input" min="1" required>
          </div>

          <div class="form-group">
            <label class="form-label" for="editDishCategory">Category *</label>
            <input type="text" id="editDishCategory" name="category" class="modal-input" required>
          </div>

          <div class="form-group">
            <label class="form-label" for="editDishStock">Stock Availability *</label>
            <select id="editDishStock" name="isAvailable" class="modal-input">
              <option value="true">In Stock (Available)</option>
              <option value="false">Out of Stock (Unavailable)</option>
            </select>
          </div>

          <div class="form-group">
            <label class="form-label" for="editDishImagePath">Dish Photo URL</label>
            <input type="url" id="editDishImagePath" name="imagePath" class="modal-input">
          </div>

          <div class="form-group full-width">
            <label class="form-label" for="editDishDescription">Description *</label>
            <input type="text" id="editDishDescription" name="description" class="modal-input" required>
          </div>
        </div>

        <div class="modal-actions-row">
          <button type="button" class="btn-modal-cancel" onclick="closeEditDishModal()">Cancel</button>
          <button type="submit" class="btn-modal-save">✓ Update Dish</button>
        </div>
      </form>
    </div>
  </div>

  <!-- ==========================================================================
       5. JAVASCRIPT LOGIC
       ========================================================================== -->
  <script>
    let activeFilterRestaurantId = null;
    let activeFilterRestaurantName = '';

    // Tab Switching
    function switchTab(tabName) {
      document.querySelectorAll('.tab-btn').forEach(btn => btn.classList.remove('active'));
      document.querySelectorAll('.tab-panel').forEach(panel => panel.classList.remove('active'));

      const btn = document.getElementById('tabBtn-' + tabName);
      const panel = document.getElementById('panel-' + tabName);
      if (btn) btn.classList.add('active');
      if (panel) panel.classList.add('active');
    }

    // Modal Control: Add Restaurant
    function openAddRestaurantModal() {
      const modal = document.getElementById('addRestaurantModal');
      if (modal) {
        modal.classList.add('active');
        modal.style.display = 'flex';
        document.body.style.overflow = 'hidden';
        setTimeout(function() {
          const input = document.getElementById('addName');
          if (input) input.focus();
        }, 50);
      }
    }

    function closeAddRestaurantModal() {
      const modal = document.getElementById('addRestaurantModal');
      if (modal) {
        modal.classList.remove('active');
        modal.style.display = 'none';
        document.body.style.overflow = '';
      }
    }

    // Modal Control: Edit Restaurant
    function openEditRestaurantModal(id, name, cuisine, deliveryTime, address, rating, imagePath) {
      document.getElementById('editRestaurantId').value = id;
      document.getElementById('editName').value = name;
      document.getElementById('editCuisine').value = cuisine;
      document.getElementById('editDeliveryTime').value = deliveryTime;
      document.getElementById('editAddress').value = address;
      document.getElementById('editRating').value = rating;
      document.getElementById('editImagePath').value = imagePath || '';

      const modal = document.getElementById('editRestaurantModal');
      if (modal) {
        modal.classList.add('active');
        modal.style.display = 'flex';
        document.body.style.overflow = 'hidden';
      }
    }

    function closeEditRestaurantModal() {
      const modal = document.getElementById('editRestaurantModal');
      if (modal) {
        modal.classList.remove('active');
        modal.style.display = 'none';
        document.body.style.overflow = '';
      }
    }

    // Modal Control: Add Dish
    function openAddDishModal() {
      const select = document.getElementById('addDishRestaurantId');
      if (select && activeFilterRestaurantId) {
        select.value = activeFilterRestaurantId;
      }

      const modal = document.getElementById('addDishModal');
      if (modal) {
        modal.classList.add('active');
        modal.style.display = 'flex';
        document.body.style.overflow = 'hidden';
        setTimeout(function() {
          const input = document.getElementById('addDishName');
          if (input) input.focus();
        }, 50);
      }
    }

    function closeAddDishModal() {
      const modal = document.getElementById('addDishModal');
      if (modal) {
        modal.classList.remove('active');
        modal.style.display = 'none';
        document.body.style.overflow = '';
      }
    }

    // Modal Control: Edit Dish
    function openEditDishModal(menuId, restaurantId, itemName, category, price, isAvailable, imagePath, description) {
      document.getElementById('editMenuId').value = menuId;
      document.getElementById('editDishRestaurantId').value = restaurantId;
      document.getElementById('editDishName').value = itemName;
      document.getElementById('editDishCategory').value = category;
      document.getElementById('editDishPrice').value = price;
      document.getElementById('editDishStock').value = String(isAvailable);
      document.getElementById('editDishImagePath').value = imagePath || '';
      document.getElementById('editDishDescription').value = description;

      const modal = document.getElementById('editDishModal');
      if (modal) {
        modal.classList.add('active');
        modal.style.display = 'flex';
        document.body.style.overflow = 'hidden';
      }
    }

    function closeEditDishModal() {
      const modal = document.getElementById('editDishModal');
      if (modal) {
        modal.classList.remove('active');
        modal.style.display = 'none';
        document.body.style.overflow = '';
      }
    }

    // Close any modal on backdrop click or Escape key
    window.addEventListener('click', function(e) {
      const addModal = document.getElementById('addRestaurantModal');
      const editModal = document.getElementById('editRestaurantModal');
      const addDish = document.getElementById('addDishModal');
      const editDish = document.getElementById('editDishModal');

      if (e.target === addModal) closeAddRestaurantModal();
      if (e.target === editModal) closeEditRestaurantModal();
      if (e.target === addDish) closeAddDishModal();
      if (e.target === editDish) closeEditDishModal();
    });

    document.addEventListener('keydown', function(e) {
      if (e.key === 'Escape') {
        closeAddRestaurantModal();
        closeEditRestaurantModal();
        closeAddDishModal();
        closeEditDishModal();
      }
    });

    // 1-Click Drill-Down Filter: Filter Dishes By Restaurant
    function filterDishesByRestaurant(restaurantId, restaurantName) {
      activeFilterRestaurantId = restaurantId;
      activeFilterRestaurantName = restaurantName;

      switchTab('menus');

      const rows = document.querySelectorAll('.menu-item-row');
      let visibleCount = 0;

      rows.forEach(row => {
        const rowRestaurantId = row.getAttribute('data-restaurant-id');
        if (rowRestaurantId === String(restaurantId)) {
          row.style.display = '';
          visibleCount++;
        } else {
          row.style.display = 'none';
        }
      });

      // Update and show filter banner
      const banner = document.getElementById('menuFilterBanner');
      if (banner) {
        document.getElementById('filterRestaurantName').textContent = restaurantName;
        document.getElementById('filterDishCount').textContent = visibleCount;
        const btnKitchen = document.getElementById('btnFilterKitchenName');
        if (btnKitchen) btnKitchen.textContent = restaurantName;
        banner.style.display = 'flex';
      }

      // Scroll smoothly to workspace
      document.querySelector('.workspace-card').scrollIntoView({ behavior: 'smooth' });
    }

    // Clear Filter
    function clearMenuFilter() {
      activeFilterRestaurantId = null;
      activeFilterRestaurantName = '';

      const rows = document.querySelectorAll('.menu-item-row');
      rows.forEach(row => row.style.display = '');

      const banner = document.getElementById('menuFilterBanner');
      if (banner) banner.style.display = 'none';
    }
  </script>

</body>
</html>

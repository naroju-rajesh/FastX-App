<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tap.model.Order" %>
<%@ page import="com.tap.model.OrderItem" %>
<%@ page import="com.tap.model.Menu" %>
<%@ page import="com.tap.model.User" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%
    // Verify user session
    User user = (session != null) ? (User) session.getAttribute("user") : null;
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?redirect=" + request.getContextPath() + "/orders");
        return;
    }

    List<Order> ordersList = (List<Order>) request.getAttribute("ordersList");
    Map<Integer, List<OrderItem>> orderItemsMap = (Map<Integer, List<OrderItem>>) request.getAttribute("orderItemsMap");
    Map<Integer, Menu> menuDetailsMap = (Map<Integer, Menu>) request.getAttribute("menuDetailsMap");

    int orderCount = (ordersList != null) ? ordersList.size() : 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Orders — FastX</title>
    
    <!-- FastX Official Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Plus+Jakarta+Sans:wght@600;700;800;900&display=swap" rel="stylesheet">
    
    <!-- FastX Order History Stylesheet -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/orderHistory.css">
</head>
<body>

    <!-- ==========================================================================
         CENTRALIZED FASTX NAVBAR (Included from navbar.jsp)
         ========================================================================== -->
    <%@ include file="navbar.jsp" %>

    <!-- ==========================================================================
         MAIN ORDER HISTORY SECTION
         ========================================================================== -->
    <main class="history-wrapper">
        
        <!-- Hero Header -->
        <div class="history-hero">
            <div class="history-hero-left">
                <h1>Past Orders</h1>
                <p>Track live statuses, review your meal receipts, and easily reorder your favorites.</p>
            </div>
            <div class="order-count-chip">
                <span>📦</span> <%= orderCount %> <%= (orderCount == 1) ? "Order Placed" : "Orders Placed" %>
            </div>
        </div>

        <% if (ordersList == null || ordersList.isEmpty()) { %>
            <!-- Empty State -->
            <div class="empty-history-card">
                <div class="empty-icon">🥗</div>
                <h2 class="empty-title">No Orders Yet!</h2>
                <p class="empty-subtitle">
                    Looks like you haven't placed any delicious gourmet orders yet. Discover artisanal kitchens near you!
                </p>
                <a href="${pageContext.request.contextPath}/restaurant" class="btn-explore">
                    <span>🍽️</span> Explore Restaurants &rarr;
                </a>
            </div>
        <% } else { %>
            <!-- Orders List -->
            <div class="orders-list">
                <% for (Order ord : ordersList) { 
                    String status = (ord.getOrderStatus() != null) ? ord.getOrderStatus() : "CONFIRMED";
                    String statusClass = status.toLowerCase().replace(" ", "_");

                    String payMode = ord.getPaymentMode();
                    String payDisplay = "Cash on Delivery (COD)";
                    if ("UPI".equalsIgnoreCase(payMode)) {
                        payDisplay = "UPI / Instant Pay";
                    } else if ("CARD".equalsIgnoreCase(payMode)) {
                        payDisplay = "Credit / Debit Card";
                    }

                    List<OrderItem> items = (orderItemsMap != null) ? orderItemsMap.get(ord.getOrderId()) : null;
                %>
                <div class="order-card">
                    
                    <!-- Top Row: Dish Preview (Image, Name, Qty, Desc, Price) & Status -->
                    <div class="card-top-row">
                        <div class="dishes-container">
                            <% if (items != null && !items.isEmpty()) { %>
                                <% for (OrderItem itm : items) { 
                                    Menu menu = (menuDetailsMap != null) ? menuDetailsMap.get(itm.getMenuId()) : null;
                                    
                                    String dishName = (menu != null && menu.getItemName() != null) ? menu.getItemName() : "Artisanal Dish #" + itm.getMenuId();
                                    String imgPath = (menu != null && menu.getImagePath() != null && !menu.getImagePath().trim().isEmpty()) 
                                                     ? menu.getImagePath() 
                                                     : "https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=200";
                                    
                                    String dishDesc = (menu != null && menu.getDescription() != null && !menu.getDescription().trim().isEmpty())
                                                      ? menu.getDescription()
                                                      : "Freshly crafted using seasonal organic ingredients and herbs.";
                                    
                                    int qty = itm.getQuantity();
                                    double itemPrice = itm.getPrice();
                                %>
                                <div class="dish-card-item">
                                    <img src="<%= imgPath %>" 
                                         alt="<%= dishName %>" 
                                         class="dish-preview-img" 
                                         onerror="this.src='https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=200';">
                                    
                                    <div class="dish-details">
                                        <h3 class="dish-title"><%= dishName %></h3>
                                        <div class="dish-meta-row">
                                            <span class="dish-qty"><%= qty %>x</span>
                                            <span class="dish-price">₹<%= String.format("%.2f", itemPrice) %></span>
                                        </div>
                                        <p class="dish-desc"><%= dishDesc %></p>
                                    </div>
                                </div>
                                <% } %>
                            <% } else { %>
                                <div class="dish-card-item">
                                    <img src="https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=200" 
                                         alt="FastX Meal" 
                                         class="dish-preview-img">
                                    <div class="dish-details">
                                        <h3 class="dish-title">FastX Gourmet Order #ORD-<%= ord.getOrderId() %></h3>
                                        <p class="dish-desc">Delicious meal prepared freshly with natural ingredients.</p>
                                    </div>
                                </div>
                            <% } %>
                        </div>

                        <!-- Status Badge Top Right -->
                        <span class="status-badge <%= statusClass %>">
                            ● <%= status %>
                        </span>
                    </div>

                    <!-- Bottom Row: Address, Payment, Total Bill Paid & Reorder Action -->
                    <div class="card-bottom-row">
                        <div class="bottom-left-info">
                            <div class="info-point">
                                <span>📍</span>
                                <span><strong>Delivery Destination:</strong> <%= (ord.getDeliveryAddress() != null && !ord.getDeliveryAddress().trim().isEmpty()) ? ord.getDeliveryAddress() : "Standard Home Address" %></span>
                            </div>
                            <div class="info-point">
                                <span>💳</span>
                                <span><strong>Paid via:</strong> <%= payDisplay %></span>
                            </div>
                        </div>

                        <div class="bottom-right-actions">
                            <div class="total-bill-box">
                                <span class="total-label">Total Bill Paid</span>
                                <span class="total-amount">₹<%= String.format("%.2f", ord.getTotalAmount()) %></span>
                            </div>
                            <a href="${pageContext.request.contextPath}/menu?restaurantId=<%= ord.getRestaurantId() %>" class="btn-reorder">
                                <span>🔄</span> Reorder Dish &rarr;
                            </a>
                        </div>
                    </div>

                </div>
                <% } %>
            </div>
        <% } %>

    </main>

    <!-- ==========================================================================
         FOOTER
         ========================================================================== -->
    <footer>
        <p>&copy; 2026 Fast<span>X</span> Technologies Inc. Fresh gourmet dining delivered to your doorstep.</p>
    </footer>

</body>
</html>

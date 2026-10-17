<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tap.model.Cart" %>
<%@ page import="com.tap.model.CartItem" %>
<%@ page import="java.util.Map" %>
<%
    Cart cart = (Cart) session.getAttribute("cart");
    boolean isEmpty = (cart == null || cart.isEmpty());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Cart - FastX</title>
    
    <!-- FastX Official Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Plus+Jakarta+Sans:wght@600;700;800;900&display=swap" rel="stylesheet">

    <!-- FastX External Cart Stylesheet -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/cart.css">
</head>
<body>

    <!-- ==========================================================================
         CENTRALIZED FASTX NAVBAR (Included from navbar.jsp)
         ========================================================================== -->
    <%@ include file="navbar.jsp" %>

    <!-- ==========================================================================
         1. SHOPPING CART CONTENT
         ========================================================================== -->
    <main class="cart-wrapper">
        <% if (!isEmpty) { 
            double itemTotal = cart.getTotalAmount();
            double deliveryFee = 40.0;
            double platformFee = 5.0;
            double gst = itemTotal * 0.05;
            double grandTotal = itemTotal + deliveryFee + platformFee + gst;
            int rId = cart.getRestaurantId();
        %>

        <div class="cart-header">
            <h1>Your <span>Order</span> Cart</h1>
            <a href="${pageContext.request.contextPath}/cart?action=clear" class="clear-btn" onclick="return confirm('Clear all items from your cart?');">
                🗑️ Clear Cart
            </a>
        </div>

        <div class="cart-grid">
            <!-- Left Column: Itemized Food List -->
            <div class="items-card">
                <%
                    for (CartItem item : cart.getItems().values()) {
                        int id = item.getItemId();
                        String name = item.getName();
                        double price = item.getPrice();
                        int qty = item.getQuantity();
                        double lineTotal = price * qty;
                        String img = item.getImagePath();
                        if (img == null || img.trim().isEmpty()) {
                            img = "https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=200";
                        }
                %>
                <div class="item-row">
                    <img src="<%= img %>" alt="<%= name %>" onerror="this.onerror=null; this.src='https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=200';">
                    
                    <div class="item-details">
                        <h3><%= name %></h3>
                        <p>₹<%= String.format("%.2f", price) %> each</p>
                    </div>

                    <!-- Quantity Stepper (+ / -) -->
                    <div class="stepper">
                        <a href="${pageContext.request.contextPath}/cart?action=update&itemId=<%= id %>&quantity=<%= qty - 1 %>" title="Decrease">&minus;</a>
                        <span><%= qty %></span>
                        <a href="${pageContext.request.contextPath}/cart?action=update&itemId=<%= id %>&quantity=<%= qty + 1 %>" title="Increase">&plus;</a>
                    </div>

                    <div class="line-price">
                        ₹<%= String.format("%.2f", lineTotal) %>
                    </div>

                    <!-- Remove Item Shortcut -->
                    <a href="${pageContext.request.contextPath}/cart?action=remove&itemId=<%= id %>" class="del-btn" title="Remove Item">🗑️</a>
                </div>
                <% } %>

                <div class="add-more-link-wrap">
                    <a href="${pageContext.request.contextPath}/menu?restaurantId=<%= rId %>" class="add-more-link">
                        &larr; Add more dishes from this restaurant
                    </a>
                </div>
            </div>

            <!-- Right Column: Itemized Bill Summary -->
            <div class="summary-card">
                <div class="summary-title">Bill Summary</div>
                <div class="bill-row"><span>Item Total</span><span>₹<%= String.format("%.2f", itemTotal) %></span></div>
                <div class="bill-row"><span>Delivery Fee</span><span>₹<%= String.format("%.2f", deliveryFee) %></span></div>
                <div class="bill-row"><span>Platform Fee</span><span>₹<%= String.format("%.2f", platformFee) %></span></div>
                <div class="bill-row"><span>GST (5%)</span><span>₹<%= String.format("%.2f", gst) %></span></div>
                <div class="divider"></div>
                <div class="total-row">
                    <span>To Pay</span>
                    <span class="total-amount">₹<%= String.format("%.2f", grandTotal) %></span>
                </div>
                
                <!-- Proceed to Checkout -->
                <a href="${pageContext.request.contextPath}/checkout.jsp" class="checkout-btn">Proceed to Checkout &rarr;</a>
            </div>
        </div>

        <% } else { %>

        <!-- Empty Cart State -->
        <div class="empty-box">
            <div class="empty-box-icon">🛒</div>
            <h2>Your Cart is Empty</h2>
            <p>Looks like you haven't added any delicious meals to your cart yet.</p>
            <a href="${pageContext.request.contextPath}/restaurant" class="explore-btn">Explore Restaurants &rarr;</a>
        </div>

        <% } %>
    </main>

    <!-- ==========================================================================
         2. FOOTER
         ========================================================================== -->
    <footer>
        <p>&copy; 2026 Fast<span>X</span>. Delivering fresh, authentic food to your doorstep.</p>
    </footer>

</body>
</html>

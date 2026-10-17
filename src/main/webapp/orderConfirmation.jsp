<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tap.model.Order" %>
<%@ page import="com.tap.model.CartItem" %>
<%@ page import="java.util.List" %>
<%
    // Safety check: Retrieve order details passed from OrderController
    Order placedOrder = (Order) request.getAttribute("placedOrder");
    List<CartItem> orderedItems = (List<CartItem>) request.getAttribute("orderedItems");
    Double grandTotalObj = (Double) request.getAttribute("grandTotal");

    if (placedOrder == null) {
        response.sendRedirect(request.getContextPath() + "/orders");
        return;
    }

    double grandTotal = (grandTotalObj != null) ? grandTotalObj : placedOrder.getTotalAmount();
    int orderId = placedOrder.getOrderId();
    String address = placedOrder.getDeliveryAddress();
    String paymentMode = placedOrder.getPaymentMode();
    String status = (placedOrder.getOrderStatus() != null) ? placedOrder.getOrderStatus() : "CONFIRMED";

    // Format payment mode text for display
    String paymentDisplay = "Cash on Delivery (COD)";
    if ("UPI".equalsIgnoreCase(paymentMode)) {
        paymentDisplay = "UPI / Instant Online Payment";
    } else if ("CARD".equalsIgnoreCase(paymentMode)) {
        paymentDisplay = "Credit / Debit Card";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Confirmed #ORD-<%= orderId %> — FastX</title>
    
    <!-- FastX Official Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Plus+Jakarta+Sans:wght@600;700;800;900&display=swap" rel="stylesheet">
    
    <!-- FastX External Order Confirmation Stylesheet -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/orderConfirmation.css">
</head>
<body>

    <!-- ==========================================================================
         CENTRALIZED FASTX NAVBAR (Included from navbar.jsp)
         ========================================================================== -->
    <%@ include file="navbar.jsp" %>

    <!-- ==========================================================================
         1. CHECKOUT 3-STEP PROGRESS INDICATOR (Completed)
         ========================================================================== -->
    <div class="checkout-progress-banner">
        <div class="progress-inner">
            <div class="checkout-steps">
                <div class="step-item">
                    <span class="step-badge">✓</span> Cart
                </div>
                <span style="color: var(--color-slate-gray)">➔</span>
                <div class="step-item">
                    <span class="step-badge">✓</span> Checkout
                </div>
                <span style="color: var(--color-slate-gray)">➔</span>
                <div class="step-item active">
                    <span class="step-badge">✓</span> Confirmation
                </div>
            </div>

            <div class="secure-badge">
                🔒 100% Verified Order
            </div>
        </div>
    </div>

    <!-- ==========================================================================
         2. MAIN CONFIRMATION CONTENT
         ========================================================================== -->
    <main class="confirm-wrapper">
        
        <!-- Celebration Header Card -->
        <section class="success-hero-card">
            <div class="success-icon-wrap">
                ✓
            </div>
            <h1 class="success-title">Order Confirmed!</h1>
            <p class="success-subtitle">
                Thank you for ordering with FastX! Your meal has been assigned to our master kitchen and is being freshly prepared with organic ingredients.
            </p>
        </section>

        <!-- Two-Column Details & Itemized Receipt Grid -->
        <div class="confirm-grid">
            
            <!-- Left Column: Delivery & Tracking Details -->
            <section class="card">
                <div class="card-title-row">
                    <div class="card-title-left">
                        <div class="card-icon">📍</div>
                        <h2 class="card-title">Delivery Details</h2>
                    </div>
                    <span class="status-badge">● <%= status %></span>
                </div>

                <div class="info-row">
                    <div class="info-label">Order Reference ID</div>
                    <div class="info-box">
                        <span class="order-id-badge">#ORD-<%= orderId %></span>
                    </div>
                </div>

                <div class="info-row">
                    <div class="info-label">Estimated Delivery Time</div>
                    <div class="info-box eta-highlight">
                        <span>⚡</span>
                        <span>30–35 Minutes (Fast Delivery)</span>
                    </div>
                </div>

                <div class="info-row">
                    <div class="info-label">Selected Payment Method</div>
                    <div class="info-box">
                        <span>💳 <%= paymentDisplay %></span>
                    </div>
                </div>

                <div class="info-row">
                    <div class="info-label">Delivery Destination</div>
                    <div class="info-box" style="line-height: 1.5;">
                        <span><%= (address != null && !address.trim().isEmpty()) ? address : "Standard Home Address" %></span>
                    </div>
                </div>
            </section>

            <!-- Right Column: Itemized Order Receipt with Dish Thumbnails -->
            <section class="card">
                <div class="card-title-row">
                    <div class="card-title-left">
                        <div class="card-icon">🧾</div>
                        <h2 class="card-title">Order Summary</h2>
                    </div>
                    <span style="font-size: 13px; font-weight: 700; color: var(--color-slate-gray);">
                        <%= (orderedItems != null) ? orderedItems.size() : 0 %> Dishes
                    </span>
                </div>

                <!-- Food Items List -->
                <div class="receipt-items-list">
                    <%
                        double itemsSubtotal = 0.0;
                        if (orderedItems != null && !orderedItems.isEmpty()) {
                            for (CartItem item : orderedItems) {
                                int qty = item.getQuantity();
                                double price = item.getPrice();
                                double lineTotal = price * qty;
                                itemsSubtotal += lineTotal;

                                // Fallback image handling
                                String imgPath = item.getImagePath();
                                if (imgPath == null || imgPath.trim().isEmpty()) {
                                    imgPath = "https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=200";
                                }
                    %>
                    <div class="receipt-item-row">
                        <div class="item-left">
                            <img src="<%= imgPath %>" 
                                 alt="<%= item.getName() %>" 
                                 class="receipt-dish-img" 
                                 onerror="this.src='https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=200';">
                            <div class="item-text-info">
                                <span class="item-dish-name"><%= item.getName() %></span>
                                <span class="item-qty-tag"><%= qty %>x</span>
                            </div>
                        </div>
                        <div class="item-price-tag">
                            ₹<%= String.format("%.2f", lineTotal) %>
                        </div>
                    </div>
                    <%
                            }
                        }
                        
                        double deliveryFee = (itemsSubtotal > 500) ? 0.0 : 40.0;
                        double gst = Math.round((itemsSubtotal * 0.05) * 100.0) / 100.0;
                    %>
                </div>

                <!-- Bill Calculations -->
                <div class="bill-divider"></div>

                <div class="bill-row">
                    <span>Items Subtotal</span>
                    <span>₹<%= String.format("%.2f", itemsSubtotal) %></span>
                </div>

                <div class="bill-row">
                    <span>Delivery Partner Fee</span>
                    <span>
                        <% if (deliveryFee == 0.0) { %>
                            <strong style="color: #10b981;">FREE</strong>
                        <% } else { %>
                            ₹<%= String.format("%.2f", deliveryFee) %>
                        <% } %>
                    </span>
                </div>

                <div class="bill-row">
                    <span>Govt Taxes & GST (5%)</span>
                    <span>₹<%= String.format("%.2f", gst) %></span>
                </div>

                <div class="bill-row grand-total">
                    <span>Total Paid</span>
                    <span>₹<%= String.format("%.2f", grandTotal) %></span>
                </div>
            </section>

        </div>

        <!-- Action Buttons -->
        <div class="action-buttons-wrap">
            <a href="${pageContext.request.contextPath}/orders" class="btn-track-order">
                <span>📦</span> View in Order History &rarr;
            </a>
            <a href="${pageContext.request.contextPath}/restaurant" class="btn-order-more">
                <span>🍽️</span> Explore More Restaurants
            </a>
        </div>

    </main>

    <!-- ==========================================================================
         3. FOOTER
         ========================================================================== -->
    <footer>
        <p>&copy; 2026 Fast<span>X</span> Technologies Inc. Fresh gourmet dining delivered to your doorstep.</p>
    </footer>

</body>
</html>

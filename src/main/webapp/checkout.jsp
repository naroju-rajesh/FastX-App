<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map" %>
<%@ page import="com.tap.model.Cart" %>
<%@ page import="com.tap.model.CartItem" %>
<%@ page import="com.tap.model.User" %>
<%
    // Verify user authentication
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp?redirect=checkout");
        return;
    }

    // Verify cart non-empty status (routes through servlet)
    Cart cart = (Cart) session.getAttribute("cart");
    if (cart == null || cart.getItems() == null || cart.getItems().isEmpty()) {
        response.sendRedirect("restaurant");
        return;
    }

    Map<Integer, CartItem> items = cart.getItems();
    double itemTotal = cart.getTotalAmount();
    double deliveryFee = (itemTotal > 500) ? 0.0 : 40.0;
    double tax = Math.round((itemTotal * 0.05) * 100.0) / 100.0; // 5% GST
    double grandTotal = itemTotal + deliveryFee + tax;

    String uName = (user.getUsername() != null && !user.getUsername().isEmpty()) ? user.getUsername() : "Customer";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Secure Checkout — FastX</title>
    
    <!-- FastX Official Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Plus+Jakarta+Sans:wght@600;700;800;900&family=Playfair+Display:ital,wght@0,600;0,700;1,600&display=swap" rel="stylesheet">
    
    <!-- FastX External Checkout Stylesheet -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/checkout.css">
</head>
<body>

    <!-- ==========================================================================
         CENTRALIZED FASTX NAVBAR (Included from navbar.jsp)
         ========================================================================== -->
    <%@ include file="navbar.jsp" %>

    <!-- ==========================================================================
         1. CHECKOUT PROGRESS INDICATOR
         ========================================================================== -->
    <div class="checkout-progress-banner">
        <div class="progress-inner">
            <div class="checkout-steps">
                <div class="step-item">
                    <span class="step-badge">✓</span> Cart
                </div>
                <span style="color: var(--color-slate-gray)">➔</span>
                <div class="step-item active">
                    <span class="step-badge">2</span> Checkout
                </div>
                <span style="color: var(--color-slate-gray)">➔</span>
                <div class="step-item">
                    <span class="step-badge">3</span> Confirmation
                </div>
            </div>

            
        </div>
    </div>

    <!-- ==========================================================================
         2. MAIN CHECKOUT LAYOUT
         ========================================================================== -->
    <main class="checkout-container">
        <div class="page-title-wrap">
            <h1 class="page-title">Finalize Your Order</h1>
            <p class="page-subtitle">Review your delivery details and choose your preferred payment method</p>
        </div>

        <form action="order" method="POST" id="checkoutForm">
            <!-- Hidden total amount field for OrderController -->
            <input type="hidden" name="totalAmount" value="<%= grandTotal %>">

            <div class="checkout-grid">
                
                <!-- LEFT COLUMN: Delivery Information & Payment Modes -->
                <div class="details-column">
                    
                    <!-- 1. Customer & Delivery Address Card -->
                    <div class="luxury-card">
                        <div class="card-header">
                            <div class="card-title">
                                <div class="card-icon">📍</div>
                                Delivery Information
                            </div>
                            <span class="verified-pill">Logged In</span>
                        </div>

                        <!-- User Contact Summary -->
                        <div class="contact-preview">
                            <div class="contact-info">
                                <strong><%= uName %></strong>
                                <span>📞 <%= (user.getPhone() != null && !user.getPhone().isEmpty()) ? user.getPhone() : "Phone not provided" %> &nbsp;•&nbsp; ✉️ <%= user.getEmail() %></span>
                            </div>
                        </div>

                        <!-- Delivery Address Input -->
                        <div class="form-group">
                            <label class="form-label" for="deliveryAddress">Delivery Address *</label>
                            <textarea 
                                name="deliveryAddress" 
                                id="deliveryAddress" 
                                class="form-textarea" 
                                required
                                placeholder="Enter house/flat number, apartment/building name, street, area, and landmark..."
                            ><%= (user.getAddress() != null) ? user.getAddress() : "" %></textarea>
                        </div>
                    </div>

                    <!-- 2. Payment Method Selector Card -->
                    <div class="luxury-card">
                        <div class="card-header">
                            <div class="card-title">
                                <div class="card-icon">💳</div>
                                Select Payment Method
                            </div>
                        </div>

                        <div class="payment-options">
                            
                            <!-- Option 1: Cash On Delivery -->
                            <label class="payment-card-label active" onclick="selectPayment(this)">
                                <div class="payment-left">
                                    <div class="payment-icon-box">💵</div>
                                    <div class="payment-info">
                                        <h4>Cash on Delivery (COD)</h4>
                                        <p>Pay with cash or UPI QR code at your doorstep</p>
                                    </div>
                                </div>
                                <input type="radio" name="paymentMode" value="COD" class="payment-radio" checked>
                            </label>

                            <!-- Option 2: UPI / QR -->
                            <label class="payment-card-label" onclick="selectPayment(this)">
                                <div class="payment-left">
                                    <div class="payment-icon-box">📱</div>
                                    <div class="payment-info">
                                        <h4>UPI / QR Code</h4>
                                        <p>Google Pay, PhonePe, Paytm, or BHIM</p>
                                    </div>
                                </div>
                                <input type="radio" name="paymentMode" value="UPI" class="payment-radio">
                            </label>

                            <!-- Option 3: Credit / Debit Card -->
                            <label class="payment-card-label" onclick="selectPayment(this)">
                                <div class="payment-left">
                                    <div class="payment-icon-box">💳</div>
                                    <div class="payment-info">
                                        <h4>Credit / Debit Card</h4>
                                        <p>Visa, MasterCard, RuPay & American Express</p>
                                    </div>
                                </div>
                                <input type="radio" name="paymentMode" value="CARD" class="payment-radio">
                            </label>

                        </div>
                    </div>

                </div>

                <!-- RIGHT COLUMN: Sticky Order Summary Sidebar -->
                <div class="sidebar-wrap">
                    <div class="summary-card">
                        <div class="restaurant-badge">
                            🍴 FastX Verified Kitchen
                        </div>

                        <h3 class="summary-heading">Order Summary</h3>

                        <!-- Items List -->
                        <div class="items-list">
                            <% for (CartItem item : items.values()) { %>
                                <div class="order-item-row">
                                    <div class="item-name-qty">
                                        <span class="qty-pill"><%= item.getQuantity() %>x</span>
                                        <span><%= item.getName() %></span>
                                    </div>
                                    <div class="item-price">
                                        ₹<%= String.format("%.2f", item.getPrice() * item.getQuantity()) %>
                                    </div>
                                </div>
                            <% } %>
                        </div>

                        <!-- Bill Breakdown -->
                        <div class="bill-divider"></div>
                        <div class="bill-row">
                            <span>Item Total</span>
                            <span>₹<%= String.format("%.2f", itemTotal) %></span>
                        </div>
                        <div class="bill-row">
                            <span>Delivery Partner Fee</span>
                            <span>
                                <% if (deliveryFee == 0.0) { %>
                                    <span class="free-badge">FREE</span>
                                <% } else { %>
                                    ₹<%= String.format("%.2f", deliveryFee) %>
                                <% } %>
                            </span>
                        </div>
                        <div class="bill-row">
                            <span>Govt Taxes & GST (5%)</span>
                            <span>₹<%= String.format("%.2f", tax) %></span>
                        </div>

                        <div class="bill-row grand-total">
                            <span>To Pay</span>
                            <span>₹<%= String.format("%.2f", grandTotal) %></span>
                        </div>

                        <!-- Submit Order Button -->
                        <button type="submit" class="place-order-btn">
                            Confirm & Place Order ➔
                        </button>

                        <div class="trust-info">
                            <div class="trust-item">🛡️ 100% Safe</div>
                            <div class="trust-item">⚡ 30-Min Fast Delivery</div>
                        </div>
                    </div>
                </div>

            </div>
        </form>
    </main>

    <!-- ==========================================================================
         3. FOOTER
         ========================================================================== -->
    <footer>
        <p>&copy; 2026 Fast<span>X</span>. Delivering fresh, authentic food to your doorstep.</p>
    </footer>

    <!-- Interactive Payment Selection Script -->
    <script>
        function selectPayment(selectedLabel) {
            document.querySelectorAll('.payment-card-label').forEach(label => {
                label.classList.remove('active');
            });
            selectedLabel.classList.add('active');
            
            const radio = selectedLabel.querySelector('.payment-radio');
            if (radio) {
                radio.checked = true;
            }
        }
    </script>
</body>
</html>

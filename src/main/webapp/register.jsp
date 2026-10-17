<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Your FastX Account | FastX Gourmet Delivery</title>
    
    <!-- FastX Official Typography -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=Playfair+Display:ital,wght@0,600;0,700;1,400&display=swap" rel="stylesheet">
    
    <!-- External Sign Up Stylesheet -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/register.css">
</head>
<body>

    <div class="auth-split-wrapper">
        
        <!-- LEFT 55%: Cinematic Culinary Visual Showcase -->
        <section class="auth-visual-pane">
            
            <div class="visual-top-brand">
                <a href="${pageContext.request.contextPath}/index.jsp" class="brand-logo-white">
                    FastX<span class="dot">•</span>
                </a>
                <div class="visual-top-badge">
                    <span class="indicator-dot"></span>
                    <span>Fresh & Fine Dining</span>
                </div>
            </div>

            <div class="visual-content-bottom">
                <h1 class="visual-tagline">
                    Crafted with Care.<br>Delivered with <span>Passion.</span>
                </h1>
                <p class="visual-subtext">
                    Join thousands of food lovers enjoying chef-prepared bowls, artisanal wood-fired specialties, and zero-compromise freshness at your table in 30 minutes.
                </p>

                <div class="visual-perks">
                    <div class="perk-pill">
                        <span>🥑</span> 100% Organic Ingredients
                    </div>
                    <div class="perk-pill">
                        <span>⚡</span> Under 30 Min Delivery
                    </div>
                    <div class="perk-pill">
                        <span>⭐</span> 4.9+ Rated Chefs
                    </div>
                </div>
            </div>

        </section>

        <!-- RIGHT 45%: Clean Luxury Registration Pane -->
        <main class="auth-form-pane">
            <div class="auth-form-container">
                
                <div class="form-header">
                    <span class="form-badge">Create Account</span>
                    <h2 class="form-title">Join FastX Today.</h2>
                    <p class="form-subtitle">Experience gourmet food delivered to your doorstep in minutes.</p>
                </div>

                <!-- Backend Error Alert Display -->
                <% 
                    String errorMsg = (String) request.getAttribute("errorMessage");
                    if (errorMsg != null && !errorMsg.isEmpty()) { 
                %>
                    <div class="alert-box">
                        <span>⚠️</span>
                        <span><%= errorMsg %></span>
                    </div>
                <% } %>

                <!-- Registration Form mapped to RegisterController by default -->
                <form action="${pageContext.request.contextPath}/register" method="POST" class="form-grid">
                    
                    <!-- Hidden redirect parameter (preserves checkout flow) -->
                    <input type="hidden" name="redirect" value="<%= request.getParameter("redirect") != null ? request.getParameter("redirect") : "" %>">

                    <!-- 1. Full Name (username in database) -->
                    <div class="input-group">
                        <label class="input-label" for="username">Full Name *</label>
                        <div class="input-wrapper">
                            <input type="text" id="username" name="username" class="input-field" 
                                   placeholder="e.g. Rajesh Kumar" required 
                                   value="<%= request.getAttribute("username") != null ? request.getAttribute("username") : "" %>">
                        </div>
                    </div>

                    <!-- 2. Email Address (email in database) -->
                    <div class="input-group">
                        <label class="input-label" for="email">Email Address *</label>
                        <div class="input-wrapper">
                            <input type="email" id="email" name="email" class="input-field" 
                                   placeholder="rajesh.kumar@example.com" required 
                                   value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>">
                        </div>
                    </div>

                    <!-- 3. Phone Number (phone in database) -->
                    <div class="input-group">
                        <label class="input-label" for="phone">Phone Number</label>
                        <div class="input-wrapper">
                            <input type="tel" id="phone" name="phone" class="input-field" 
                                   placeholder="9876543210" pattern="[0-9]{10}" title="Please enter a 10-digit mobile number"
                                   value="<%= request.getAttribute("phone") != null ? request.getAttribute("phone") : "" %>">
                        </div>
                    </div>

                    <!-- 4. Delivery Address (address in database) -->
                    <div class="input-group">
                        <label class="input-label" for="address">Delivery Address</label>
                        <div class="input-wrapper">
                            <input type="text" id="address" name="address" class="input-field" 
                                   placeholder="e.g. Jayanagar, Bengaluru"
                                   value="<%= request.getAttribute("address") != null ? request.getAttribute("address") : "" %>">
                        </div>
                    </div>

                    <!-- 5. Password (password in database) -->
                    <div class="input-group">
                        <label class="input-label" for="password">Password *</label>
                        <div class="input-wrapper">
                            <input type="password" id="password" name="password" class="input-field" 
                                   placeholder="At least 6 characters" minlength="6" required>
                            <button type="button" class="eye-toggle-btn" onclick="togglePass('password')" aria-label="Toggle password visibility">👁️</button>
                        </div>
                    </div>

                    <!-- 6. Confirm Password -->
                    <div class="input-group">
                        <label class="input-label" for="confirmPassword">Confirm Password *</label>
                        <div class="input-wrapper">
                            <input type="password" id="confirmPassword" name="confirmPassword" class="input-field" 
                                   placeholder="Re-enter password" minlength="6" required>
                            <button type="button" class="eye-toggle-btn" onclick="togglePass('confirmPassword')" aria-label="Toggle confirm password visibility">👁️</button>
                        </div>
                    </div>

                    <!-- Action Buttons: Customer vs Admin -->
                    <div class="actions-row">
                        <button type="submit" class="submit-btn customer-btn" title="Create standard customer account for ordering food">
                            <span>✨</span> Create Account
                        </button>
                        <button type="submit" formaction="${pageContext.request.contextPath}/adminRegister" class="submit-btn admin-btn" title="Create operations administrator account">
                            <span>🛡️</span> Sign Up as Admin
                        </button>
                    </div>
                </form>

                <div class="auth-footer">
                    Already have an account? <a href="${pageContext.request.contextPath}/login.jsp">Log In</a>
                </div>

            </div>
        </main>

    </div>

    <!-- Interactive Password Visibility Toggle Script -->
    <script>
        function togglePass(fieldId) {
            const input = document.getElementById(fieldId);
            if (input) {
                input.type = input.type === 'password' ? 'text' : 'password';
            }
        }
    </script>
</body>
</html>

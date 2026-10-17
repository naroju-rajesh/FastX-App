<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String redirect = request.getParameter("redirect");
    String error = (String) request.getAttribute("error");
    String message = (String) request.getAttribute("message");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Login - FastX Food Delivery</title>

  <!-- Google Fonts: Plus Jakarta Sans for Headers, Inter for Body -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Plus+Jakarta+Sans:wght@600;700;800;900&display=swap" rel="stylesheet">

  <!-- External Login Stylesheet -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css">
</head>
<body>

  <!-- Main Split-Screen Container -->
  <div class="auth-container">

    <!-- 1. LEFT SIDE: RUSTIC GOURMET TABLE FEAST -->
    <div class="auth-visual">
      <!-- Top Logo -->
      <a href="${pageContext.request.contextPath}/index.jsp" class="visual-logo">
        <svg viewBox="0 0 24 24">
          <path d="M13 2L3 14h9l-1 8 10-12h-9l1-8z" />
        </svg>
        Fast<span>X</span>
      </a>

      <!-- Bottom Food Brand Story -->
      <div class="visual-bottom">
        <div class="floating-badge">
          ⚡ 30-Min Fresh Delivery ★ 4.9
        </div>
        <h2>Real Food,<br><span>Delivered Hot.</span></h2>
        <p>
          Experience Bengaluru's finest partner kitchens. Made with authentic ingredients, brought piping hot to your table.
        </p>
      </div>
    </div>

    <!-- 2. RIGHT SIDE: LOGIN FORM -->
    <div class="auth-form-side">
      <div class="form-header">
        <h1 class="form-title">Welcome Back</h1>
        <p class="form-subtitle">
          <% if ("checkout".equalsIgnoreCase(redirect)) { %>
            Log in to complete your fresh food order
          <% } else { %>
            Log in to access your account & orders
          <% } %>
        </p>
      </div>

      <!-- Error Alert Display -->
      <% if (error != null && !error.trim().isEmpty()) { %>
        <div class="alert-error">
          <span>⚠️</span> <%= error %>
        </div>
      <% } %>

      <!-- Success Message Display -->
      <% if (message != null && !message.trim().isEmpty()) { %>
        <div class="alert-success">
          <span>✓</span> <%= message %>
        </div>
      <% } %>

      <!-- Login Form submitting to LoginController -->
      <form action="${pageContext.request.contextPath}/login" method="POST">
        <!-- Hidden redirect tracker -->
        <input type="hidden" name="redirect" value="<%= (redirect != null) ? redirect : "" %>">

        <!-- Email Field -->
        <div class="form-group">
          <label for="email" class="form-label">Email or Username</label>
          <div class="input-wrap">
            <span class="input-icon">
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"></path>
                <polyline points="22,6 12,13 2,6"></polyline>
              </svg>
            </span>
            <input 
              type="text" 
              id="email" 
              name="email" 
              class="form-input" 
              placeholder="Enter your email or username..." 
              required 
              autofocus
            />
          </div>
        </div>

        <!-- Password Field with Show/Hide Toggle -->
        <div class="form-group">
          <label for="password" class="form-label">Password</label>
          <div class="input-wrap">
            <span class="input-icon">
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
              </svg>
            </span>
            <input 
              type="password" 
              id="password" 
              name="password" 
              class="form-input" 
              placeholder="Enter your password..." 
              required
            />
            <button type="button" class="eye-btn" onclick="togglePassword()" title="Show/Hide Password">
              <svg id="eyeIcon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                <circle cx="12" cy="12" r="3"></circle>
              </svg>
            </button>
          </div>
        </div>

        <!-- Remember Me & Forgot Password -->
        <div class="options-row">
          <label class="checkbox-wrap">
            <input type="checkbox" name="remember">
            <span>Remember me</span>
          </label>
          <!-- CONNECTED TO FORGOT PASSWORD PAGE -->
          <a href="${pageContext.request.contextPath}/forgotPassword.jsp" class="forgot-link">Forgot password?</a>
        </div>

        <!-- Submit Button -->
        <button type="submit" class="btn-submit">
          <% if ("checkout".equalsIgnoreCase(redirect)) { %>
            Sign In & Proceed to Checkout &rarr;
          <% } else { %>
            Sign In &rarr;
          <% } %>
        </button>
      </form>

      <!-- Create Account Footer -->
      <div class="card-footer">
        New to FastX? 
        <a href="${pageContext.request.contextPath}/register.jsp<%= ("checkout".equalsIgnoreCase(redirect)) ? "?redirect=checkout" : "" %>">
          Create an account
        </a>
      </div>

      <!-- ========================================================
           ADMIN PORTAL SWITCHER CARD (Dedicated Entry for Admin)
           ======================================================== -->
      <div class="admin-portal-box">
        <div class="admin-portal-text">
          <span class="admin-badge-icon">🛡️</span>
          <span>Are you an Admin or Partner?</span>
        </div>
        <a href="${pageContext.request.contextPath}/adminLogin.jsp" class="admin-portal-link">
          Admin Portal &rarr;
        </a>
      </div>

      <!-- Back Home Link -->
      <div class="back-home-wrap">
        <a href="${pageContext.request.contextPath}/index.jsp" class="back-home-link">
          &larr; Back to FastX Home
        </a>
      </div>
    </div>

  </div>

  <!-- Interactive Password Show/Hide Script -->
  <script>
    function togglePassword() {
      const passInput = document.getElementById('password');
      const eyeIcon = document.getElementById('eyeIcon');

      if (passInput.type === 'password') {
        passInput.type = 'text';
        eyeIcon.innerHTML = `
          <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path>
          <line x1="1" y1="1" x2="23" y2="23"></line>
        `;
      } else {
        passInput.type = 'password';
        eyeIcon.innerHTML = `
          <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
          <circle cx="12" cy="12" r="3"></circle>
        `;
      }
    }
  </script>

</body>
</html>

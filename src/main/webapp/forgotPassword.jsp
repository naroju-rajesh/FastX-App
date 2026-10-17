<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String step = (String) request.getAttribute("step");
    if (step == null || step.trim().isEmpty()) {
        step = request.getParameter("step");
    }
    if (step == null || step.trim().isEmpty()) {
        step = "1"; // Default to Step 1: Email Request
    }

    String error = (String) request.getAttribute("error");
    if (error == null) error = request.getParameter("error");

    String message = (String) request.getAttribute("message");
    if (message == null) message = request.getParameter("message");

    String userEmail = (String) session.getAttribute("resetEmail");
    if (userEmail == null) {
        userEmail = (String) request.getAttribute("email");
    }
    if (userEmail == null) userEmail = "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Reset Password - FastX Food Delivery</title>

  <!-- Google Fonts: Plus Jakarta Sans for Headers, Inter for Body, JetBrains Mono for OTP -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Plus+Jakarta+Sans:wght@600;700;800;900&family=JetBrains+Mono:wght@700;800&display=swap" rel="stylesheet">

  <!-- External Stylesheet (Matches login.css organic luxury theme) -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/forgotPassword.css">
</head>
<body>

  <!-- Main Split-Screen Container -->
  <div class="auth-container">

    <!-- 1. LEFT SIDE: GOURMET BRAND & SECURITY STORY -->
    <div class="auth-visual">
      <!-- Top Logo -->
      <a href="${pageContext.request.contextPath}/index.jsp" class="visual-logo">
        <svg viewBox="0 0 24 24">
          <path d="M13 2L3 14h9l-1 8 10-12h-9l1-8z" />
        </svg>
        Fast<span>X</span>
      </a>

      <!-- Bottom Story -->
      <div class="visual-bottom">
        <div class="floating-badge">
          🛡️ FastX Account Security Protocol
        </div>
        <h2>Recover Your<br><span>Account Access.</span></h2>
        <p>
          We protect your dining profile and order history with end-to-end one-time verification. Regain access to your account in under a minute.
        </p>
      </div>
    </div>

    <!-- 2. RIGHT SIDE: MULTI-STEP RECOVERY FORM -->
    <div class="auth-form-side">

      <!-- 3-Step Visual Progress Bar -->
      <div class="steps-progress">
        <div class="step-node <%= "1".equals(step) ? "active" : ("2".equals(step) || "3".equals(step) ? "completed" : "") %>">
          <div class="step-num">1</div>
          <span class="step-name">Email</span>
        </div>
        <div class="step-node <%= "2".equals(step) ? "active" : ("3".equals(step) ? "completed" : "") %>">
          <div class="step-num">2</div>
          <span class="step-name">Verify OTP</span>
        </div>
        <div class="step-node <%= "3".equals(step) ? "active" : "" %>">
          <div class="step-num">3</div>
          <span class="step-name">New Password</span>
        </div>
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

      <!-- ========================================================
           STEP 1: ENTER REGISTERED EMAIL
           ======================================================== -->
      <% if ("1".equals(step)) { %>
        <div class="form-header">
          <span class="form-tag">Step 1 of 3</span>
          <h1 class="form-title">Forgot Password?</h1>
          <p class="form-subtitle">
            Enter your registered FastX email address. We'll send a 6-digit verification code to reset your password.
          </p>
        </div>

        <form action="${pageContext.request.contextPath}/forgotPassword" method="POST">
          <input type="hidden" name="action" value="sendOtp">

          <div class="form-group">
            <label for="email" class="form-label">Registered Email</label>
            <div class="input-wrap">
              <span class="input-icon">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                  <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"></path>
                  <polyline points="22,6 12,13 2,6"></polyline>
                </svg>
              </span>
              <input 
                type="email" 
                id="email" 
                name="email" 
                class="form-input" 
                placeholder="Enter your registered email..." 
                required 
                autofocus
                value="<%= userEmail %>"
              />
            </div>
          </div>

          <button type="submit" class="btn-submit">
            <span>⚡</span> Send Verification Code
          </button>
        </form>

      <!-- ========================================================
           STEP 2: ENTER 6-DIGIT OTP
           ======================================================== -->
      <% } else if ("2".equals(step)) { %>
        <div class="form-header">
          <span class="form-tag">Step 2 of 3</span>
          <h1 class="form-title">Enter Verification Code</h1>
          <p class="form-subtitle">
            We sent a 6-digit code to <strong><%= userEmail %></strong>. Enter it below (or check your Eclipse console).
          </p>
        </div>

        <form action="${pageContext.request.contextPath}/forgotPassword" method="POST">
          <input type="hidden" name="action" value="verifyOtp">

          <div class="form-group">
            <div class="form-label">
              <span>6-Digit Security OTP</span>
              <span class="form-label-meta">Valid for 10 minutes</span>
            </div>
            <div class="input-wrap">
              <input 
                type="text" 
                id="otp" 
                name="otp" 
                class="form-input otp-input" 
                maxlength="6" 
                pattern="[0-9]{6}" 
                placeholder="••••••" 
                required 
                autofocus
                autocomplete="off"
              />
            </div>
            <div class="resend-row">
              <span>Didn't get the code?</span>
              <button type="submit" formaction="${pageContext.request.contextPath}/forgotPassword?action=sendOtp&email=<%= userEmail %>" class="resend-link-btn">
                Resend Code
              </button>
            </div>
          </div>

          <button type="submit" class="btn-submit">
            <span>🛡️</span> Verify Code & Proceed
          </button>
        </form>

      <!-- ========================================================
           STEP 3: RESET NEW PASSWORD
           ======================================================== -->
      <% } else if ("3".equals(step)) { %>
        <div class="form-header">
          <span class="form-tag">Step 3 of 3</span>
          <h1 class="form-title">Set New Password</h1>
          <p class="form-subtitle">
            Your verification was successful! Choose a strong password of at least 6 characters.
          </p>
        </div>

        <form action="${pageContext.request.contextPath}/forgotPassword" method="POST">
          <input type="hidden" name="action" value="resetPassword">

          <!-- New Password -->
          <div class="form-group">
            <label for="password" class="form-label">New Password</label>
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
                placeholder="Enter new password (min. 6 characters)..." 
                minlength="6"
                required 
                autofocus
              />
              <button type="button" class="eye-btn" onclick="togglePass('password')" title="Show/Hide">
                <svg id="eyeIcon1" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                  <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                  <circle cx="12" cy="12" r="3"></circle>
                </svg>
              </button>
            </div>
          </div>

          <!-- Confirm New Password -->
          <div class="form-group">
            <label for="confirmPassword" class="form-label">Confirm New Password</label>
            <div class="input-wrap">
              <span class="input-icon">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                  <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                  <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                </svg>
              </span>
              <input 
                type="password" 
                id="confirmPassword" 
                name="confirmPassword" 
                class="form-input" 
                placeholder="Re-enter your new password..." 
                minlength="6"
                required
              />
              <button type="button" class="eye-btn" onclick="togglePass('confirmPassword')" title="Show/Hide">
                <svg id="eyeIcon2" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                  <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                  <circle cx="12" cy="12" r="3"></circle>
                </svg>
              </button>
            </div>
          </div>

          <button type="submit" class="btn-submit">
            <span>✨</span> Update Password & Finish
          </button>
        </form>
      <% } %>

      <!-- Back to Login Link -->
      <div class="back-link-wrap">
        <a href="${pageContext.request.contextPath}/login.jsp" class="back-link">
          &larr; Remember your password? Back to Login
        </a>
      </div>

    </div>

  </div>

  <!-- Interactive Password Show/Hide Script -->
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

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
  <title>Admin Password Recovery — FastX Console</title>

  <!-- FastX Official Fonts -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Plus+Jakarta+Sans:wght@600;700;800;900&family=JetBrains+Mono:wght@700;800&display=swap" rel="stylesheet">

  <!-- Admin Login Stylesheet -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/adminLogin.css">
</head>
<body>

  <div class="admin-auth-card">
    
    <!-- Top Security Badge & Logo -->
    <div class="admin-header">
      <div class="security-badge-icon">
        🛡️
      </div>
      <a href="${pageContext.request.contextPath}/index.jsp" class="admin-brand">
        Fast<span>X</span> <span class="console-tag">CONSOLE</span>
      </a>
      <h1 class="admin-title">Password Recovery</h1>
      <p class="admin-subtitle">
        Secure OTP identity verification for operations administrators.
      </p>
    </div>

    <!-- 3-Step Progress Indicator -->
    <div class="admin-steps-progress">
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
         STEP 1: ENTER ADMIN EMAIL
         ======================================================== -->
    <% if ("1".equals(step)) { %>
      <form action="${pageContext.request.contextPath}/forgotPassword" method="POST">
        <input type="hidden" name="action" value="sendOtp">
        <input type="hidden" name="source" value="admin">

        <div class="form-group">
          <label for="adminEmail" class="form-label">Official Administrator Email</label>
          <div class="input-wrap">
            <span class="input-icon">👤</span>
            <input 
              type="email" 
              id="adminEmail" 
              name="email" 
              class="form-input" 
              placeholder="admin@fastx.com" 
              required 
              autofocus
              value="<%= userEmail %>"
            />
          </div>
        </div>

        <button type="submit" class="btn-admin-submit">
          <span>⚡</span> Send Admin Verification OTP &rarr;
        </button>
      </form>

    <!-- ========================================================
         STEP 2: ENTER 6-DIGIT OTP
         ======================================================== -->
    <% } else if ("2".equals(step)) { %>
      <form action="${pageContext.request.contextPath}/forgotPassword" method="POST">
        <input type="hidden" name="action" value="verifyOtp">
        <input type="hidden" name="source" value="admin">

        <div class="form-group">
          <label for="adminOtp" class="form-label">
            <span>6-Digit Security OTP</span>
            <span style="color: var(--admin-amber); font-size: 0.75rem;">10 Min Expiry</span>
          </label>
          <div class="input-wrap">
            <input 
              type="text" 
              id="adminOtp" 
              name="otp" 
              class="form-input otp-input-admin" 
              maxlength="6" 
              pattern="[0-9]{6}" 
              placeholder="••••••" 
              required 
              autofocus
              autocomplete="off"
            />
          </div>
        </div>

        <button type="submit" class="btn-admin-submit">
          <span>🛡️</span> Verify Security Code &rarr;
        </button>
      </form>

    <!-- ========================================================
         STEP 3: RESET TO NEW PASSWORD
         ======================================================== -->
    <% } else if ("3".equals(step)) { %>
      <form action="${pageContext.request.contextPath}/forgotPassword" method="POST">
        <input type="hidden" name="action" value="resetPassword">
        <input type="hidden" name="source" value="admin">

        <div class="form-group">
          <label for="newAdminPass" class="form-label">New Console Password</label>
          <div class="input-wrap">
            <span class="input-icon">🔒</span>
            <input 
              type="password" 
              id="newAdminPass" 
              name="password" 
              class="form-input" 
              placeholder="Min. 6 characters..." 
              minlength="6"
              required 
              autofocus
            />
            <button type="button" class="eye-btn" onclick="togglePass('newAdminPass')" title="Show/Hide">👁️</button>
          </div>
        </div>

        <div class="form-group">
          <label for="confirmAdminPass" class="form-label">Confirm New Password</label>
          <div class="input-wrap">
            <span class="input-icon">🔒</span>
            <input 
              type="password" 
              id="confirmAdminPass" 
              name="confirmPassword" 
              class="form-input" 
              placeholder="Re-enter password..." 
              minlength="6"
              required
            />
            <button type="button" class="eye-btn" onclick="togglePass('confirmAdminPass')" title="Show/Hide">👁️</button>
          </div>
        </div>

        <button type="submit" class="btn-admin-submit">
          <span>✨</span> Update Console Password &rarr;
        </button>
      </form>
    <% } %>

    <!-- Back to Admin Login -->
    <div class="card-footer">
      Remembered your security key? 
      <a href="${pageContext.request.contextPath}/adminLogin.jsp">
        Back to Admin Login &rarr;
      </a>
    </div>

  </div>

  <script>
    function togglePass(id) {
      const el = document.getElementById(id);
      if (el) {
        el.type = (el.type === 'password') ? 'text' : 'password';
      }
    }
  </script>

</body>
</html>

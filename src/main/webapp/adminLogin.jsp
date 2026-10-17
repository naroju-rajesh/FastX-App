<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String error = (String) request.getAttribute("error");
    String message = (String) request.getAttribute("message");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Admin & Partner Console — FastX</title>

  <!-- FastX Official Fonts -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Plus+Jakarta+Sans:wght@600;700;800;900&display=swap" rel="stylesheet">

  <!-- Admin Login External Stylesheet -->
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
      <h1 class="admin-title">Operations Portal</h1>
      <p class="admin-subtitle">
        Restricted management gateway for platform operations & kitchen managers.
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

    <!-- Admin Login Form -->
    <form action="${pageContext.request.contextPath}/adminLogin" method="POST">
      
      <!-- Email / Username -->
      <div class="form-group">
        <label for="adminEmail" class="form-label">Administrator Email / Username</label>
        <div class="input-wrap">
          <span class="input-icon">👤</span>
          <input 
            type="text" 
            id="adminEmail" 
            name="email" 
            class="form-input" 
            placeholder="admin@fastx.com" 
            required 
            autofocus
          />
        </div>
      </div>

      <!-- Password -->
      <div class="form-group">
        <label for="adminPassword" class="form-label">Security Password</label>
        <div class="input-wrap">
          <span class="input-icon">🔒</span>
          <input 
            type="password" 
            id="adminPassword" 
            name="password" 
            class="form-input" 
            placeholder="Enter security key..." 
            required
          />
          <button type="button" class="eye-btn" onclick="togglePassword()" title="Show/Hide Password">
            👁️
          </button>
        </div>
      </div>

      <!-- Forgot Password Shortcut (Points to your working forgotPassword.jsp) -->
      <div class="admin-options-row">
        <a href="${pageContext.request.contextPath}/forgotPassword.jsp" class="admin-forgot-link">
          Forgot password?
        </a>
      </div>

      <!-- Security Notice -->
      <div class="security-notice">
        <span>🔒</span> All sessions and actions are securely logged.
      </div>

      <!-- Submit Button -->
      <button type="submit" class="btn-admin-submit">
        Authenticate & Enter Console &rarr;
      </button>

    </form>

    <!-- Switcher to Customer Login -->
    <div class="card-footer">
      Looking for your food orders? 
      <a href="${pageContext.request.contextPath}/login.jsp">
        Customer Login &rarr;
      </a>
    </div>

  </div>

  <script>
    function togglePassword() {
      const pass = document.getElementById('adminPassword');
      pass.type = (pass.type === 'password') ? 'text' : 'password';
    }
  </script>

</body>
</html>

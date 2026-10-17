<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tap.model.User" %>
<%
    // Ensure user is authenticated
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?redirect=profile.jsp");
        return;
    }

    String username = (user.getUsername() != null && !user.getUsername().trim().isEmpty()) ? user.getUsername() : "Valued Member";
    String email = (user.getEmail() != null && !user.getEmail().trim().isEmpty()) ? user.getEmail() : "Not provided";
    String phone = (user.getPhone() != null && !user.getPhone().trim().isEmpty()) ? user.getPhone() : "";
    String address = (user.getAddress() != null && !user.getAddress().trim().isEmpty()) ? user.getAddress() : "";
    String role = (user.getRole() != null && !user.getRole().trim().isEmpty()) ? user.getRole() : "CUSTOMER";

    String avatarLetter = username.substring(0, 1).toUpperCase();

    String msg = request.getParameter("msg");
    String error = (String) request.getAttribute("error");
    if (error == null) {
        error = request.getParameter("error");
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile & Security — FastX</title>
    
    <!-- FastX Official Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Plus+Jakarta+Sans:wght@600;700;800;900&display=swap" rel="stylesheet">
    
    <!-- FastX External Profile Stylesheet -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/profile.css">
</head>
<body>

    <!-- ==========================================================================
         CENTRALIZED FASTX NAVBAR (Included from navbar.jsp)
         ========================================================================== -->
    <%@ include file="navbar.jsp" %>

    <!-- ==========================================================================
         1. PROFILE MAIN CONTENT
         ========================================================================== -->
    <main class="profile-wrapper">
        
        <!-- Status Feedback Alerts -->
        <% if ("updated".equals(msg)) { %>
            <div class="alert-banner alert-success">
                <span>✓</span> Profile details updated successfully!
            </div>
        <% } %>

        <% if ("pwd_success".equals(msg)) { %>
            <div class="alert-banner alert-success">
                <span>🔒</span> Password changed successfully! Your account credentials have been updated.
            </div>
        <% } %>

        <% if (error != null && !error.trim().isEmpty()) { %>
            <div class="alert-banner alert-error">
                <span>⚠️</span> <%= error %>
            </div>
        <% } %>

        <!-- Client-side Dynamic Error Banner (Initially Hidden) -->
        <div id="clientErrorBanner" class="alert-banner alert-error" style="display: none;">
            <span>⚠️</span> <span id="clientErrorMessage"></span>
        </div>

        <!-- Hero Profile Banner Card -->
        <section class="profile-hero-card">
            <div class="hero-left">
                <div class="profile-avatar-large">
                    <%= avatarLetter %>
                </div>
                <div class="hero-info">
                    <h1><%= username %></h1>
                    <div class="hero-badges-row">
                        <span class="role-badge"><%= role %></span>
                        <span class="verified-badge">✓ Verified Account</span>
                    </div>
                </div>
            </div>

            <div class="hero-actions">
                <button type="button" class="btn-edit-toggle" id="toggleEditBtn" onclick="toggleEditMode()">
                    <span>✏️</span> Edit Profile
                </button>
                <button type="button" class="btn-logout" onclick="openLogoutModal(event)">
                    <span>🚪</span> Sign Out
                </button>
            </div>
        </section>

        <!-- Profile Details and Shortcuts Grid -->
        <div class="profile-grid">
            
            <!-- Left Column Stack: Personal Info Card + Security & Password Card -->
            <div class="profile-left-stack">
                
                <!-- CARD 1: PERSONAL INFORMATION (View & Edit Modes) -->
                <section class="card">
                    <div class="card-title-row">
                        <div class="card-title-left">
                            <div class="card-icon">👤</div>
                            <h2 class="card-title" id="cardHeading">Personal Information</h2>
                        </div>
                    </div>

                    <!-- VIEW MODE -->
                    <div id="viewMode">
                        <div class="detail-group">
                            <div class="detail-label">Full Name / Username</div>
                            <div class="detail-value-box">
                                <span><%= username %></span>
                                <span style="color: var(--color-deep-forest); font-size: 16px;">✓</span>
                            </div>
                        </div>

                        <div class="detail-group">
                            <div class="detail-label">Registered Email Address</div>
                            <div class="detail-value-box">
                                <span><%= email %></span>
                                <span style="color: var(--color-deep-forest); font-size: 16px;">✉️</span>
                            </div>
                        </div>

                        <div class="detail-group">
                            <div class="detail-label">Contact Phone Number</div>
                            <div class="detail-value-box">
                                <span><%= (!phone.isEmpty()) ? phone : "Not provided" %></span>
                                <span style="color: var(--color-deep-forest); font-size: 16px;">📞</span>
                            </div>
                        </div>

                        <div class="detail-group">
                            <div class="detail-label">Default Delivery Address</div>
                            <div class="detail-value-box address-box">
                                <span><%= (!address.isEmpty()) ? address : "No default address saved yet. Click 'Edit Profile' to add one." %></span>
                            </div>
                        </div>
                    </div>

                    <!-- EDIT MODE (Form) -->
                    <form action="${pageContext.request.contextPath}/updateProfile" method="POST" id="editMode" style="display: none;">
                        
                        <div class="detail-group">
                            <label class="detail-label" for="usernameInput">Full Name / Username *</label>
                            <input 
                                type="text" 
                                name="username" 
                                id="usernameInput" 
                                class="edit-input" 
                                required 
                                value="<%= username %>"
                                placeholder="Enter your full name"
                            />
                        </div>

                        <div class="detail-group">
                            <label class="detail-label">Registered Email Address (Read-Only)</label>
                            <div class="detail-value-box" style="background: rgba(0, 71, 60, 0.05); color: var(--color-slate-gray);">
                                <span><%= email %></span>
                                <span style="font-size: 12px; font-weight: 700; color: var(--color-deep-forest);">🔒 Verified</span>
                            </div>
                        </div>

                        <div class="detail-group">
                            <label class="detail-label" for="phoneInput">Contact Phone Number *</label>
                            <input 
                                type="tel" 
                                name="phone" 
                                id="phoneInput" 
                                class="edit-input" 
                                required 
                                pattern="[0-9]{10}"
                                value="<%= phone %>"
                                placeholder="10-digit mobile number"
                            />
                        </div>

                        <div class="detail-group">
                            <label class="detail-label" for="addressInput">Default Delivery Address</label>
                            <textarea 
                                name="address" 
                                id="addressInput" 
                                class="edit-textarea" 
                                placeholder="Enter house/flat number, street, landmark, area..."
                            ><%= address %></textarea>
                        </div>

                        <div class="form-actions-row">
                            <button type="submit" class="btn-save">
                                💾 Save Changes
                            </button>
                            <button type="button" class="btn-cancel" onclick="toggleEditMode()">
                                Cancel
                            </button>
                        </div>

                    </form>

                </section>

                <!-- CARD 2: SECURITY & PASSWORD (Collapsible Button Trigger) -->
                <section class="card">
                    <div class="card-title-row">
                        <div class="card-title-left">
                            <div class="card-icon">🛡️</div>
                            <h2 class="card-title">Security & Password</h2>
                        </div>
                        <!-- Toggle Button: Reveals form on click -->
                        <button type="button" class="btn-edit-toggle" id="togglePasswordBtn" onclick="togglePasswordMode()">
                            <span>🔑</span> Change Password
                        </button>
                    </div>

                    <!-- 1. DEFAULT VIEW (Hidden Password State) -->
                    <div id="passwordViewMode">
                        <div class="detail-group">
                            <div class="detail-label">Password Protection</div>
                            <div class="detail-value-box">
                                <span>••••••••••••</span>
                                <span style="font-size: 12px; font-weight: 800; color: var(--color-deep-forest);">🔒 Protected</span>
                            </div>
                            <p class="field-hint" style="margin-top: 8px;">
                                Secure your account with a strong password. Click <strong>Change Password</strong> above to update your credentials.
                            </p>
                        </div>
                    </div>

                    <!-- 2. EXPANDED EDIT VIEW (Form opens only when user clicks button) -->
                    <form action="${pageContext.request.contextPath}/changePassword" method="POST" id="passwordEditMode" style="display: none;" onsubmit="return validatePasswordForm()">
                        
                        <!-- Old / Current Password -->
                        <div class="detail-group">
                            <label class="detail-label" for="currentPassword">Current Password *</label>
                            <div class="password-input-wrap">
                                <input 
                                    type="password" 
                                    name="currentPassword" 
                                    id="currentPassword" 
                                    class="edit-input" 
                                    required 
                                    placeholder="Enter your current password"
                                />
                                <button type="button" class="btn-toggle-eye" onclick="togglePasswordVisibility('currentPassword', this)" title="Show/Hide Password">
                                    👁️
                                </button>
                            </div>
                        </div>

                        <!-- New Password -->
                        <div class="detail-group">
                            <label class="detail-label" for="newPassword">New Password *</label>
                            <div class="password-input-wrap">
                                <input 
                                    type="password" 
                                    name="newPassword" 
                                    id="newPassword" 
                                    class="edit-input" 
                                    required 
                                    minlength="6"
                                    placeholder="Enter new password (min. 6 characters)"
                                />
                                <button type="button" class="btn-toggle-eye" onclick="togglePasswordVisibility('newPassword', this)" title="Show/Hide Password">
                                    👁️
                                </button>
                            </div>
                            <p class="field-hint">Must contain at least 6 characters.</p>
                        </div>

                        <!-- Confirm New Password -->
                        <div class="detail-group">
                            <label class="detail-label" for="confirmPassword">Confirm New Password *</label>
                            <div class="password-input-wrap">
                                <input 
                                    type="password" 
                                    name="confirmPassword" 
                                    id="confirmPassword" 
                                    class="edit-input" 
                                    required 
                                    minlength="6"
                                    placeholder="Re-enter your new password"
                                />
                                <button type="button" class="btn-toggle-eye" onclick="togglePasswordVisibility('confirmPassword', this)" title="Show/Hide Password">
                                    👁️
                                </button>
                            </div>
                        </div>

                        <!-- Form Actions -->
                        <div class="form-actions-row">
                            <button type="submit" class="btn-save">
                                🔒 Update Password
                            </button>
                            <button type="button" class="btn-cancel" onclick="togglePasswordMode()">
                                Cancel
                            </button>
                        </div>

                    </form>
                </section>

            </div>

            <!-- Right Column: Shortcuts & Benefits -->
            <aside class="sidebar-col">
                <div class="card" style="margin-bottom: 24px;">
                    <div class="card-title-row">
                        <div class="card-title-left">
                            <div class="card-icon">⚡</div>
                            <h2 class="card-title">Quick Actions</h2>
                        </div>
                    </div>

                    <div class="shortcuts-list">
                        <a href="${pageContext.request.contextPath}/orders" class="shortcut-link">
                            <div class="shortcut-left">
                                <span class="shortcut-icon">📦</span>
                                <span>My Order History</span>
                            </div>
                            <span>&rarr;</span>
                        </a>

                        <a href="${pageContext.request.contextPath}/cart.jsp" class="shortcut-link">
                            <div class="shortcut-left">
                                <span class="shortcut-icon">🛒</span>
                                <span>Active Cart</span>
                            </div>
                            <span>&rarr;</span>
                        </a>

                        <a href="${pageContext.request.contextPath}/restaurant" class="shortcut-link">
                            <div class="shortcut-left">
                                <span class="shortcut-icon">🍽️</span>
                                <span>Explore Restaurants</span>
                            </div>
                            <span>&rarr;</span>
                        </a>
                    </div>
                </div>

                <!-- FastX Membership Perks -->
                <div class="perks-card">
                    <h3><span>✨</span> FastX Member Perks</h3>
                    <p>Enjoy lightning-fast delivery within 30 minutes, zero delivery fees on orders above ₹500, and live priority customer support.</p>
                    <a href="${pageContext.request.contextPath}/restaurant" class="perks-btn">Order Food Now &rarr;</a>
                </div>
            </aside>

        </div>
    </main>

    <!-- ==========================================================================
         2. FOOTER
         ========================================================================== -->
    <footer>
        <p>&copy; 2026 Fast<span>X</span> Technologies Inc. Fresh gourmet dining delivered to your doorstep.</p>
    </footer>

    <!-- Interactive Scripts -->
    <script>
        // 1. Profile Info Edit Mode Toggle
        let isEditingProfile = false;

        function toggleEditMode() {
            isEditingProfile = !isEditingProfile;
            const viewMode = document.getElementById('viewMode');
            const editMode = document.getElementById('editMode');
            const toggleBtn = document.getElementById('toggleEditBtn');
            const heading = document.getElementById('cardHeading');

            if (isEditingProfile) {
                viewMode.style.display = 'none';
                editMode.style.display = 'block';
                toggleBtn.innerHTML = '<span>❌</span> Cancel Edit';
                heading.textContent = 'Edit Profile Information';
            } else {
                viewMode.style.display = 'block';
                editMode.style.display = 'none';
                toggleBtn.innerHTML = '<span>✏️</span> Edit Profile';
                heading.textContent = 'Personal Information';
            }
        }

        // 2. Change Password Form Collapsible Toggle (Requested Feature)
        let isEditingPassword = false;

        function togglePasswordMode() {
            isEditingPassword = !isEditingPassword;
            const passViewMode = document.getElementById('passwordViewMode');
            const passEditMode = document.getElementById('passwordEditMode');
            const toggleBtn = document.getElementById('togglePasswordBtn');
            const errorBanner = document.getElementById('clientErrorBanner');

            if (isEditingPassword) {
                passViewMode.style.display = 'none';
                passEditMode.style.display = 'block';
                toggleBtn.innerHTML = '<span>❌</span> Cancel';
                // Focus the current password field automatically
                document.getElementById('currentPassword').focus();
            } else {
                passViewMode.style.display = 'block';
                passEditMode.style.display = 'none';
                toggleBtn.innerHTML = '<span>🔑</span> Change Password';
                // Reset form fields and error banner
                passEditMode.reset();
                if (errorBanner) errorBanner.style.display = 'none';
            }
        }

        // 3. Show/Hide password toggle function
        function togglePasswordVisibility(fieldId, btn) {
            const input = document.getElementById(fieldId);
            if (input.type === 'password') {
                input.type = 'text';
                btn.textContent = '🙈';
            } else {
                input.type = 'password';
                btn.textContent = '👁️';
            }
        }

        // 4. Client-side Password Validation
        function validatePasswordForm() {
            const currentPass = document.getElementById('currentPassword').value.trim();
            const newPass = document.getElementById('newPassword').value.trim();
            const confirmPass = document.getElementById('confirmPassword').value.trim();

            if (newPass.length < 6) {
                showClientError('New password must be at least 6 characters long.');
                return false;
            }

            if (newPass !== confirmPass) {
                showClientError('New password and Confirm password do not match.');
                return false;
            }

            if (newPass === currentPass) {
                showClientError('New password cannot be the same as your current password.');
                return false;
            }

            return true;
        }

        function showClientError(message) {
            const errorBanner = document.getElementById('clientErrorBanner');
            const errorMsg = document.getElementById('clientErrorMessage');
            errorMsg.textContent = message;
            errorBanner.style.display = 'flex';
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }
    </script>
</body>
</html>

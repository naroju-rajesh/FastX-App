<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.tap.model.Menu" %>
<%@ page import="com.tap.model.Cart" %>
<%@ page import="com.tap.model.CartItem" %>
<%
    List<Menu> menuList = (List<Menu>) request.getAttribute("allmenu");
    int totalItems = (menuList != null) ? menuList.size() : 0;

    // Read active session cart to check item quantities on dish cards
    Cart sessionCart = (Cart) session.getAttribute("cart");
    Map<Integer, CartItem> cartItemsMap = (sessionCart != null) ? sessionCart.getItems() : null;
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Restaurant Menu - FastX</title>

  <!-- FastX Official Fonts -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Plus+Jakarta+Sans:wght@600;700;800;900&display=swap" rel="stylesheet">

  <!-- External Menu Stylesheet -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/menu.css">
</head>
<body>

  <!-- ==========================================================================
       CENTRALIZED FASTX NAVBAR (Included from navbar.jsp)
       ========================================================================== -->
  <%@ include file="navbar.jsp" %>

  <!-- ==========================================
       1. RESTAURANT & MENU BANNER
       ========================================== -->
  <header class="menu-header">
    <div class="container">
      <a href="${pageContext.request.contextPath}/restaurant" class="back-btn">
        &larr; Back to Restaurants
      </a>

      <div class="header-details-row">
        <div>
          <h1 class="restaurant-title">Menu & Specialties</h1>
          <p class="restaurant-subtitle">Freshly prepared gourmet dishes and beverages crafted by master chefs.</p>
        </div>
        <span class="items-count-badge">
          Showing <span id="itemCount"><%= totalItems %></span> Dishes
        </span>
      </div>
    </div>
  </header>

  <!-- ==========================================
       2. SEARCH & CATEGORY TOOLBAR
       ========================================== -->
  <section class="filter-section">
    <div class="container">
      <div class="toolbar-box">
        <!-- Live Instant Search -->
        <div class="search-input-box">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <circle cx="11" cy="11" r="8"></circle>
            <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
          </svg>
          <input 
            type="text" 
            id="dishSearch" 
            class="search-input" 
            placeholder="Search dishes by name or ingredients..." 
            oninput="filterDishes()"
          />
        </div>

        <!-- Category Filters -->
        <div class="category-pills" id="categoryPills">
          <button class="pill-btn active" onclick="filterCategory('all', this)">All</button>
          <button class="pill-btn" onclick="filterCategory('starters', this)">Starters</button>
          <button class="pill-btn" onclick="filterCategory('main course', this)">Main Course</button>
          <button class="pill-btn" onclick="filterCategory('tiffin', this)">Tiffin</button>
          <button class="pill-btn" onclick="filterCategory('biryani', this)">Biryani</button>
          <button class="pill-btn" onclick="filterCategory('desserts', this)">Desserts</button>
          <button class="pill-btn" onclick="filterCategory('beverages', this)">Beverages</button>
        </div>
      </div>
    </div>
  </section>

  <!-- ==========================================
       3. MENU DISH CARDS
       ========================================== -->
  <main class="menu-grid-section">
    <div class="container">
      <div class="menu-grid" id="menuGrid">

        <%
            if (menuList != null && !menuList.isEmpty()) {
                for (Menu menu : menuList) {
                    if (menu == null) continue;

                    int mId = menu.getMenuId();
                    int rId = menu.getRestaurantId();
                    String name = (menu.getItemName() != null) ? menu.getItemName() : "Delicious Dish";
                    String desc = (menu.getDescription() != null) ? menu.getDescription() : "Freshly cooked with authentic spices.";
                    double price = menu.getPrice();
                    String category = (menu.getCategory() != null) ? menu.getCategory() : "Food";
                    
                    String imgPath = menu.getImagePath();
                    if (imgPath == null || imgPath.trim().isEmpty()) {
                        imgPath = "https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=600&auto=format&fit=crop&q=80";
                    }

                    // Check quantity in session cart for this dish
                    int currentQty = 0;
                    if (cartItemsMap != null && cartItemsMap.containsKey(mId)) {
                        CartItem cItem = cartItemsMap.get(mId);
                        if (cItem != null) {
                            currentQty = cItem.getQuantity();
                        }
                    }
        %>

        <!-- Dish Card -->
        <article 
          class="dish-card"
          data-name="<%= name.toLowerCase() %>"
          data-desc="<%= desc.toLowerCase() %>"
          data-category="<%= category.toLowerCase() %>"
        >
          <div class="dish-img-wrap">
            <img 
              src="<%= imgPath %>" 
              alt="<%= name %>" 
              loading="lazy"
              onerror="this.onerror=null; this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=600&auto=format&fit=crop&q=80';"
            />
            <span class="category-badge-pill"><%= category %></span>
          </div>

          <div class="dish-body">
            <h2 class="dish-name"><%= name %></h2>
            <p class="dish-desc"><%= desc %></p>

            <div class="dish-footer">
              <div class="dish-price">
                <span>₹</span><%= String.format("%.2f", price) %>
              </div>

              <!-- Interactive Dynamic Action Box (Swaps Add and Stepper seamlessly) -->
              <div id="actionBox_<%= mId %>">
                <% if (currentQty > 0) { %>
                  <div class="stepper-wrap">
                    <div class="menu-stepper">
                      <button type="button" class="menu-step-btn" onclick="updateQtyAsync(<%= mId %>, <%= rId %>, <%= currentQty - 1 %>, '<%= name.replace("'", "\\'") %>')" title="Decrease">&minus;</button>
                      <span class="menu-step-qty" id="qty_<%= mId %>"><%= currentQty %></span>
                      <button type="button" class="menu-step-btn" onclick="updateQtyAsync(<%= mId %>, <%= rId %>, <%= currentQty + 1 %>, '<%= name.replace("'", "\\'") %>')" title="Increase">&plus;</button>
                    </div>
                    <span class="badge-added-tick" title="Added to Cart">✓</span>
                  </div>
                <% } else { %>
                  <button type="button" class="btn-add" onclick="addToCartAsync(<%= mId %>, <%= rId %>, '<%= name.replace("'", "\\'") %>')">
                    <span>+</span> Add
                  </button>
                <% } %>
              </div>

            </div>
          </div>
        </article>

        <%
                }
            } else {
        %>

        <!-- Empty State -->
        <div class="empty-state">
          <div class="empty-state-icon">🍽️</div>
          <h3>No Menu Items Found</h3>
          <p>No dishes are currently available for this restaurant. Please check another restaurant.</p>
          <a href="${pageContext.request.contextPath}/restaurant" class="btn-back-home">&larr; Back to Restaurants</a>
        </div>

        <%
            }
        %>

      </div>
    </div>
  </main>

  <!-- ==========================================
       4. RESTAURANT CONFLICT POP-UP MODAL
       ========================================== -->
  <div class="conflict-modal-overlay" id="conflictModal">
    <div class="conflict-modal-card">
      <div class="conflict-icon">⚠️</div>
      <h3 class="conflict-modal-title">Items from another restaurant!</h3>
      <p class="conflict-modal-desc">
        Your cart contains dishes from another restaurant. You cannot order from multiple restaurants at once. Do you want to discard your previous cart and continue with this restaurant?
      </p>

      <div class="conflict-actions-row">
        <button type="button" class="btn-conflict-cancel" onclick="closeConflictModal()">
          No, Keep Cart
        </button>
        <button type="button" class="btn-conflict-continue" id="conflictConfirmBtn">
          Yes, Continue
        </button>
      </div>
    </div>
  </div>

  <!-- Toast Notification Placeholder -->
  <div id="toastContainer"></div>

  <!-- ==========================================
       5. FOOTER
       ========================================== -->
  <footer>
    <div class="container">
      <p>&copy; 2026 FastX Technologies Inc. All rights reserved. Built with pride in Bengaluru.</p>
    </div>
  </footer>

  <!-- ==========================================
       6. ASYNCHRONOUS CART & FILTER SCRIPTS
       ========================================== -->
  <script>
    let activeCategory = 'all';

    // 1. Instant Asynchronous Add to Cart
    function addToCartAsync(menuId, restaurantId, itemName) {
      fetch('${pageContext.request.contextPath}/cart?ajax=true&action=add&menuId=' + menuId + '&restaurantId=' + restaurantId + '&quantity=1', {
        method: 'POST',
        headers: { 'X-Requested-With': 'XMLHttpRequest' }
      })
      .then(res => res.json())
      .then(data => {
        if (data.status === 'success') {
          // Instantly transform button into Stepper [ - 1 + ] ✓
          const actionBox = document.getElementById('actionBox_' + menuId);
          if (actionBox) {
            actionBox.innerHTML = `
              <div class="stepper-wrap">
                <div class="menu-stepper">
                  <button type="button" class="menu-step-btn" onclick="updateQtyAsync(\${menuId}, \${restaurantId}, 0, '\${escapeQuotes(itemName)}')" title="Decrease">&minus;</button>
                  <span class="menu-step-qty" id="qty_\${menuId}">1</span>
                  <button type="button" class="menu-step-btn" onclick="updateQtyAsync(\${menuId}, \${restaurantId}, 2, '\${escapeQuotes(itemName)}')" title="Increase">&plus;</button>
                </div>
                <span class="badge-added-tick" title="Added to Cart">✓</span>
              </div>
            `;
          }
          // Update live navbar counter
          updateNavbarCartCount(data.cartCount);
          // Show smooth toast notification
          showToast(itemName + ' added to your cart!');
        } else if (data.status === 'conflict') {
          // Open conflict modal seamlessly
          showConflictModal(data.pendingMenuId, data.pendingRestaurantId, itemName);
        }
      })
      .catch(err => console.error('Cart add error:', err));
    }

    // 2. Instant Asynchronous Stepper Update (+ / -)
    function updateQtyAsync(menuId, restaurantId, newQty, itemName) {
      fetch('${pageContext.request.contextPath}/cart?ajax=true&action=update&menuId=' + menuId + '&restaurantId=' + restaurantId + '&quantity=' + newQty, {
        method: 'POST',
        headers: { 'X-Requested-With': 'XMLHttpRequest' }
      })
      .then(res => res.json())
      .then(data => {
        if (data.status === 'success') {
          const actionBox = document.getElementById('actionBox_' + menuId);
          if (newQty <= 0) {
            // Revert back to "+ Add" button
            if (actionBox) {
              actionBox.innerHTML = `
                <button type="button" class="btn-add" onclick="addToCartAsync(\${menuId}, \${restaurantId}, '\${escapeQuotes(itemName)}')">
                  <span>+</span> Add
                </button>
              `;
            }
          } else {
            // Update quantity number inside stepper
            const qtySpan = document.getElementById('qty_' + menuId);
            if (qtySpan) qtySpan.textContent = newQty;
            
            // Update button click handlers with new quantities
            if (actionBox) {
              actionBox.innerHTML = `
                <div class="stepper-wrap">
                  <div class="menu-stepper">
                    <button type="button" class="menu-step-btn" onclick="updateQtyAsync(\${menuId}, \${restaurantId}, \${newQty - 1}, '\${escapeQuotes(itemName)}')" title="Decrease">&minus;</button>
                    <span class="menu-step-qty" id="qty_\${menuId}">\${newQty}</span>
                    <button type="button" class="menu-step-btn" onclick="updateQtyAsync(\${menuId}, \${restaurantId}, \${newQty + 1}, '\${escapeQuotes(itemName)}')" title="Increase">&plus;</button>
                  </div>
                  <span class="badge-added-tick" title="Added to Cart">✓</span>
                </div>
              `;
            }
          }
          // Update navbar cart count
          updateNavbarCartCount(data.cartCount);
        }
      })
      .catch(err => console.error('Quantity update error:', err));
    }

    // 3. Update Navbar Cart Count Badge in Real Time
    function updateNavbarCartCount(count) {
      const badges = document.querySelectorAll('.cart-badge-count, .fastx-cart-badge, .nav-badge');
      badges.forEach(b => {
        b.textContent = count;
        b.style.display = (count > 0) ? 'inline-block' : 'none';
      });
    }

    // 4. Smooth Floating Toast Notification
    function showToast(message) {
      const oldToast = document.getElementById('toastAdded');
      if (oldToast) oldToast.remove();

      const toast = document.createElement('div');
      toast.className = 'toast-added';
      toast.id = 'toastAdded';
      toast.innerHTML = `
        <div class="toast-content">
          <span class="toast-icon">✓</span>
          <span><strong>\${message}</strong></span>
        </div>
        <a href="${pageContext.request.contextPath}/cart.jsp" class="btn-toast-view">View Cart &rarr;</a>
      `;
      document.body.appendChild(toast);

      setTimeout(() => {
        toast.style.transition = 'opacity 0.4s ease, transform 0.4s ease';
        toast.style.opacity = '0';
        toast.style.transform = 'translateY(20px)';
        setTimeout(() => toast.remove(), 400);
      }, 3500);
    }

    // 5. Conflict Modal Handlers
    function showConflictModal(menuId, restaurantId, itemName) {
      const modal = document.getElementById('conflictModal');
      const confirmBtn = document.getElementById('conflictConfirmBtn');
      if (modal && confirmBtn) {
        modal.style.display = 'flex';
        confirmBtn.onclick = function() {
          fetch('${pageContext.request.contextPath}/cart?ajax=true&action=clearAndAdd&menuId=' + menuId + '&restaurantId=' + restaurantId + '&quantity=1', {
            method: 'POST',
            headers: { 'X-Requested-With': 'XMLHttpRequest' }
          })
          .then(res => res.json())
          .then(data => {
            modal.style.display = 'none';
            location.reload(); // Reload to refresh other restaurant items
          });
        };
      }
    }

    function closeConflictModal() {
      const modal = document.getElementById('conflictModal');
      if (modal) modal.style.display = 'none';
    }

    function escapeQuotes(str) {
      return (str || '').replace(/'/g, "\\'");
    }

    // 6. Real-time Search and Category Filter
    function filterDishes() {
      const query = document.getElementById('dishSearch').value.trim().toLowerCase();
      const cards = document.querySelectorAll('.dish-card');
      let visible = 0;

      cards.forEach(card => {
        const name = card.getAttribute('data-name') || '';
        const desc = card.getAttribute('data-desc') || '';
        const category = card.getAttribute('data-category') || '';

        const matchesQuery = !query || name.includes(query) || desc.includes(query);
        const matchesCategory = (activeCategory === 'all') || category.includes(activeCategory);

        if (matchesQuery && matchesCategory) {
          card.style.display = 'flex';
          visible++;
        } else {
          card.style.display = 'none';
        }
      });

      const countEl = document.getElementById('itemCount');
      if (countEl) countEl.textContent = visible;
    }

    function filterCategory(cat, buttonElement) {
      activeCategory = cat.toLowerCase();
      const pills = document.querySelectorAll('#categoryPills .pill-btn');
      pills.forEach(p => p.classList.remove('active'));
      if (buttonElement) buttonElement.classList.add('active');
      filterDishes();
    }
  </script>

</body>
</html>

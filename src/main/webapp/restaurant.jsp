<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.tap.model.Restaurant" %>
<%
    // Safety check: if opened directly without going through RestaurantController, redirect to servlet
    List<Restaurant> restaurants = (List<Restaurant>) request.getAttribute("restaurants");
    if (restaurants == null) {
        response.sendRedirect(request.getContextPath() + "/restaurant");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FastX - Discover Popular Restaurants</title>
    <meta name="description" content="Order delicious food from the best restaurants in Bengaluru on FastX with lightning-fast delivery.">

    <!-- FastX Official Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Plus+Jakarta+Sans:wght@600;700;800;900&display=swap" rel="stylesheet">

    <!-- External Restaurant Stylesheet -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/restaurant.css">
</head>

<body>

    <!-- ==========================================================================
         CENTRALIZED FASTX NAVBAR (Included from navbar.jsp)
         ========================================================================== -->
    <%@ include file="navbar.jsp" %>

    <!-- ==========================================
         1. HERO SECTION
         ========================================== -->
    <section class="hero">
        <div class="hero-badge">
            ✨ Verified Partner Kitchens
        </div>

        <h1>Discover Great <span>Food</span></h1>

        <p>
            Order freshly cooked dishes from Bengaluru's finest partner kitchens with lightning-fast delivery.
        </p>

        <a href="#restaurants" class="explore-btn">
            Explore Kitchens ↓
        </a>
    </section>

    <!-- ==========================================
         2. RESTAURANT SECTION
         ========================================== -->
    <section class="restaurant-section" id="restaurants">

        <div class="section-title">
            <h2>Popular Restaurants</h2>
            <p>
                Explore verified partner kitchens and discover your favourite food
            </p>
        </div>

        <!-- Live Instant Search Bar -->
        <div class="filter-toolbar">
            <div class="search-box">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="11" cy="11" r="8"></circle>
                    <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                </svg>
                <input 
                    type="text" 
                    id="restaurantSearch" 
                    class="search-input" 
                    placeholder="Search by restaurant name, cuisine, or location..."
                    oninput="filterCards()"
                />
            </div>
            <div class="results-badge">
                Showing <strong id="matchCount"><%= (restaurants != null) ? restaurants.size() : 0 %></strong> restaurants
            </div>
        </div>

        <!-- Restaurant Cards Grid -->
        <div class="restaurant-grid" id="restaurantGrid">

            <%
                if (restaurants != null && !restaurants.isEmpty()) {

                    for (Restaurant restaurant : restaurants) {
                        if (restaurant == null) continue;

                        int id = restaurant.getRestaurantId();
                        String name = (restaurant.getName() != null) ? restaurant.getName() : "Restaurant";
                        String cuisine = (restaurant.getCuisineType() != null) ? restaurant.getCuisineType() : "Multi-Cuisine";
                        String address = (restaurant.getAddress() != null) ? restaurant.getAddress() : "Bengaluru";
                        double rating = restaurant.getRating();
                        
                        // Safe delivery time formatting
                        String deliveryTime = String.valueOf(restaurant.getDeliveryTime());
                        if (!deliveryTime.toLowerCase().contains("min")) {
                            deliveryTime += " mins";
                        }

                        // Safe image fallback
                        String imgPath = restaurant.getImagePath();
                        if (imgPath == null || imgPath.trim().isEmpty()) {
                            imgPath = "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=600&auto=format&fit=crop&q=80";
                        }
            %>

            <!-- Restaurant Card -->
            <div 
                class="restaurant-card"
                data-name="<%= name.toLowerCase() %>"
                data-cuisine="<%= cuisine.toLowerCase() %>"
                data-address="<%= address.toLowerCase() %>"
            >
                <div class="card-img-wrapper">
                    <img
                        class="restaurant-image"
                        src="<%= imgPath %>"
                        alt="<%= name %>"
                        loading="lazy"
                        onerror="this.onerror=null; this.src='https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=600&auto=format&fit=crop&q=80';"
                    >

                    <!-- Top Left Delivery Pill -->
                    <span class="badge-delivery">
                        🕒 <%= deliveryTime %>
                    </span>

                    <!-- Top Right Rating Badge -->
                    <span class="badge-rating">
                        ★ <%= String.format("%.1f", rating) %>
                    </span>
                </div>

                <div class="restaurant-content">
                    <div class="restaurant-name">
                        <%= name %>
                    </div>

                    <div class="cuisine">
                        <%= cuisine %>
                    </div>

                    <div class="restaurant-info">
                        <div class="info-row">
                            <span>📍</span>
                            <span><%= address %></span>
                        </div>
                        <div class="info-row">
                            <span>⚡</span>
                            <span style="color: var(--color-deep-forest); font-weight: 700;">Fast Delivery Available</span>
                        </div>
                    </div>

                    <!-- Connects to MenuController with restaurantId -->
                    <a href="${pageContext.request.contextPath}/menu?restaurantId=<%= id %>" class="view-menu">
                        View Menu &rarr;
                    </a>
                </div>
            </div>

            <%
                    }

                } else {
            %>

            <!-- Clean Empty State -->
            <div class="no-restaurants">
                <div class="no-restaurants-icon">🍽️</div>
                <h3>No restaurants available</h3>
                <p>
                    If you opened this JSP directly, please access it via the servlet URL <strong><code>/restaurant</code></strong> so the database can load the restaurants.
                </p>
                <a href="${pageContext.request.contextPath}/restaurant" class="reload-btn">
                    Load via /restaurant Servlet
                </a>
            </div>

            <%
                }
            %>

        </div>

    </section>

    <!-- ==========================================
         3. FASTX FOOTER
         ========================================== -->
    <footer>
        <h3>Fast<span>X</span></h3>
        <p>
            Fast, fresh and delicious food delivered to your doorstep.
        </p>
        <p style="margin-top: 14px; font-size: 13px; color: rgba(255, 255, 255, 0.5);">
            &copy; 2026 FastX Technologies Inc. All Rights Reserved. Built with pride in Bengaluru.
        </p>
    </footer>

    <!-- ==========================================
         4. REAL-TIME SEARCH SCRIPT
         ========================================== -->
    <script>
        function filterCards() {
            const query = document.getElementById('restaurantSearch').value.trim().toLowerCase();
            const cards = document.querySelectorAll('.restaurant-card');
            let count = 0;

            cards.forEach(card => {
                const name = card.getAttribute('data-name') || '';
                const cuisine = card.getAttribute('data-cuisine') || '';
                const address = card.getAttribute('data-address') || '';

                if (!query || name.includes(query) || cuisine.includes(query) || address.includes(query)) {
                    card.style.display = 'flex';
                    count++;
                } else {
                    card.style.display = 'none';
                }
            });

            const countEl = document.getElementById('matchCount');
            if (countEl) {
                countEl.textContent = count;
            }
        }

        // Initialize count on page load
        document.addEventListener('DOMContentLoaded', () => {
            const total = document.querySelectorAll('.restaurant-card').length;
            const countEl = document.getElementById('matchCount');
            if (countEl) {
                countEl.textContent = total;
            }
        });
    </script>

</body>

</html>

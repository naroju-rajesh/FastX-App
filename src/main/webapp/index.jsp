<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>FastX — Real Food, Delivered Fast</title>

  <!-- Google Fonts -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Plus+Jakarta+Sans:wght@700;800;900&display=swap" rel="stylesheet">

  <!-- External Homepage Stylesheet -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/index.css">
</head>

<body>

  <!-- ==========================================================================
       1. FASTX MASTER DYNAMIC SESSION-AWARE NAVBAR
       ========================================================================== -->
  <%@ include file="navbar.jsp" %>

  <!-- ==========================================================================
       2. FULL-BLEED HERO WITH LOOPING BACKGROUND VIDEO
       ========================================================================== -->
  <header class="hero-bleed">
    <video 
      autoplay 
      muted 
      loop 
      playsinline 
      class="hero-video-bg"
      poster="https://images.pexels.com/photos/8479197/pexels-photo-8479197.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"
    >
      <source src="https://videos.pexels.com/video-files/8479197/8479197-hd_1920_1080_25fps.mp4" type="video/mp4">
      <source src="https://videos.pexels.com/video-files/8479197/8479197-sd_640_360_25fps.mp4" type="video/mp4">
    </video>

    <div class="hero-video-overlay"></div>

    <div class="container">
      <div class="hero-overlay-panel">
        <span class="eyebrow-label">Freshly Prepared &bull; Delivered in 30 Mins</span>
        
        <h1 class="hero-headline">
          Real Food,<br>Delivered Fast.
        </h1>

        <p class="hero-subtitle">
          Freshly cooked dishes from Bengaluru's finest partner kitchens. Made with authentic ingredients, brought piping hot to your table.
        </p>

        <!-- Button submitting directly to /restaurant servlet -->
        <form action="${pageContext.request.contextPath}/restaurant" method="GET" style="margin: 0;">
          <button type="submit" class="btn-pill-lime">
            Explore 30+ Kitchens &rarr;
          </button>
        </form>
      </div>
    </div>
  </header>

  <!-- ==========================================================================
       3. MENU CATEGORY HIGHLIGHTS
       ========================================================================== -->
  <section class="category-section">
    <div class="container">
      <span class="section-eyebrow">Explore Our Menu</span>
      
      <div class="category-tabs-row">
        <button class="category-tab-btn active">Specialties</button>
        <button class="category-tab-btn" onclick="window.location.href='${pageContext.request.contextPath}/restaurant'">Biryani</button>
        <button class="category-tab-btn" onclick="window.location.href='${pageContext.request.contextPath}/restaurant'">Starters</button>
        <button class="category-tab-btn" onclick="window.location.href='${pageContext.request.contextPath}/restaurant'">Tiffin</button>
      </div>

      <div class="product-grid">
        <div class="product-card">
          <div class="product-img-wrap">
            <span class="badge-online">Online Only</span>
            <img src="https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=600&auto=format&fit=crop&q=80" alt="Biryani">
          </div>
          <h3 class="product-title">Royal Dum Biryani</h3>
          <p class="product-desc">Fragrant basmati rice slow-cooked with fresh organic spices and tender cuts.</p>
          <a href="${pageContext.request.contextPath}/restaurant" class="ghost-link">Order now &rarr;</a>
        </div>

        <div class="product-card">
          <div class="product-img-wrap">
            <span class="badge-online">Chef Special</span>
            <img src="https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=600&auto=format&fit=crop&q=80" alt="Crispy Paneer">
          </div>
          <h3 class="product-title">Crispy Paneer Pepper</h3>
          <p class="product-desc">Farm-fresh cottage cheese tossed with cracked black pepper and garden herbs.</p>
          <a href="${pageContext.request.contextPath}/restaurant" class="ghost-link">Order now &rarr;</a>
        </div>

        <div class="product-card">
          <div class="product-img-wrap">
            <span class="badge-online">Best Seller</span>
            <img src="https://images.unsplash.com/photo-1589301760014-d929f3979dbc?w=600&auto=format&fit=crop&q=80" alt="Dosa">
          </div>
          <h3 class="product-title">Ghee Roast Dosa</h3>
          <p class="product-desc">Golden crisp crepe roasted in pure organic ghee, served with stone-ground chutneys.</p>
          <a href="${pageContext.request.contextPath}/restaurant" class="ghost-link">Order now &rarr;</a>
        </div>
      </div>
    </div>
  </section>

  <!-- ==========================================================================
       4. SPLIT FEATURE SECTION
       ========================================================================== -->
  <section class="split-section">
    <div class="container">
      <div class="split-grid">
        <div class="split-text">
          <span class="section-eyebrow">Our Kitchen Promise</span>
          <h2>Cooked Fresh.<br>Never Delayed.</h2>
          
          <div class="split-item">
            <h3>Verified Authentic Kitchens</h3>
            <p>Every partner eatery is curated for authentic culinary craft and hygiene.</p>
          </div>

          <div class="split-item">
            <h3>Fast & Direct Dispatch</h3>
            <p>Your food travels straight from the master chef's pan directly to your door.</p>
          </div>
        </div>

        <img src="https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800&auto=format&fit=crop&q=80" alt="Chef Cooking" class="split-img">
      </div>
    </div>
  </section>

  <!-- ==========================================================================
       5. FOOTER
       ========================================================================== -->
  <footer>
    <div class="container">
      <div class="footer-logo">FastX</div>
      <p>&copy; 2026 FastX Technologies Inc. Real food, delivered fast. Built with pride in Bengaluru.</p>
    </div>
  </footer>

</body>
</html>

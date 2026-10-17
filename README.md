# FastX - Gourmet Food Delivery Platform

FastX is a full-featured web-based food delivery and restaurant management application built with Java EE (Servlets & JSP), MySQL, and modern front-end technologies.

---

## 🌟 Key Features

- **User Authentication & Profiles**:
  - Secure Registration & Login with session tracking.
  - Profile management and password reset with 6-digit OTP email verification via Google SMTP.
- **Restaurant & Menu Browsing**:
  - Dynamic restaurant listings filtered by cuisine, rating, and delivery time.
  - Rich menu catalog with add-to-cart functionality.
- **Cart & Seamless Checkout**:
  - Interactive cart with quantity updates and order summary calculations.
  - Multi-payment options (UPI, Cards, Cash on Delivery).
- **Order Management & Tracking**:
  - Instant order confirmation and history tracking.
- **Admin Dashboard**:
  - Centralized management console for orders, restaurants, menus, and users.

---

## 🛠️ Technology Stack

- **Backend**: Java 21, Jakarta Servlets, Jakarta Mail 2.0.1, JDBC
- **Server**: Apache Tomcat 10.1+
- **Database**: MySQL 8.0+
- **Frontend**: JSP, HTML5, Vanilla CSS3, JavaScript (ES6)
- **IDE**: Eclipse IDE for Enterprise Java and Web Developers

---

## 🚀 Getting Started

### 1. Clone the Repository
```bash
git clone https://github.com/naroju-rajesh/FastX-App.git
```

### 2. Configure Database & Credentials
1. Navigate to `src/main/java/` (or project root).
2. Copy `config.properties.example` to `config.properties`:
   ```properties
   db.url=jdbc:mysql://localhost:3306/FastX
   db.user=root
   db.password=YOUR_MYSQL_PASSWORD

   mail.sender.email=YOUR_EMAIL@gmail.com
   mail.sender.password=YOUR_GMAIL_16_DIGIT_APP_PASSWORD
   ```
   *(Note: `config.properties` is git-ignored to keep your passwords secure.)*

### 3. Import into Eclipse
1. Open Eclipse IDE.
2. Select **File** > **Import...** > **General** > **Existing Projects into Workspace**.
3. Select the `FastX` folder as the root directory and click **Finish**.
4. Configure Apache Tomcat 10.1 in the **Servers** tab.
5. Right-click project > **Run As** > **Run on Server**.

---

## 🔒 Security Best Practices
- Sensitive credentials (database passwords, email app passwords) are externalized into `config.properties` and are excluded from version control via `.gitignore`.
- OTP codes for password resets are dynamically generated and expire within 10 minutes.

---

## 📄 License
This project is for educational and portfolio demonstration purposes.

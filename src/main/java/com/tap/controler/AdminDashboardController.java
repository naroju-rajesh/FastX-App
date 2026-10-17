package com.tap.controler;

import java.io.IOException;
import java.util.List;

import com.tap.dao.MenuDao;
import com.tap.dao.OrderDao;
import com.tap.dao.RestaurantDao;
import com.tap.daoimpl.MenuDaoImpl;
import com.tap.daoimpl.OrderDaoImpl;
import com.tap.daoimpl.RestaurantDaoImpl;
import com.tap.model.Menu;
import com.tap.model.Order;
import com.tap.model.Restaurant;
import com.tap.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(urlPatterns = {"/admin/dashboard", "/adminDashboard"})
public class AdminDashboardController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private RestaurantDao restaurantDao;
    private MenuDao menuDao;
    private OrderDao orderDao;

    @Override
    public void init() throws ServletException {
        this.restaurantDao = new RestaurantDaoImpl();
        this.menuDao = new MenuDaoImpl();
        this.orderDao = new OrderDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        // 1. Strict Security Guard: User must be logged in with role == "ADMIN"
        if (user == null || !"ADMIN".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/adminLogin.jsp?error=Admin authentication required");
            return;
        }

        try {
            // 2. Fetch Master Collections from Database
            List<Restaurant> restaurantList = restaurantDao.getAllRestaurants();
            List<Menu> menuList = menuDao.getAllMenus();
            List<Order> orderList = orderDao.getAllOrders();

            // 3. Compute High-Level Platform KPI Metrics
            int totalRestaurants = (restaurantList != null) ? restaurantList.size() : 0;
            int totalDishes = (menuList != null) ? menuList.size() : 0;
            int totalOrders = (orderList != null) ? orderList.size() : 0;

            double totalRevenue = 0.0;
            if (orderList != null) {
                for (Order ord : orderList) {
                    totalRevenue += ord.getTotalAmount();
                }
            }

            // 4. Attach Metrics & Master Lists to Request
            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("totalOrders", totalOrders);
            request.setAttribute("totalRestaurants", totalRestaurants);
            request.setAttribute("totalDishes", totalDishes);

            request.setAttribute("restaurantList", restaurantList);
            request.setAttribute("menuList", menuList);
            request.setAttribute("orderList", orderList);

            // 5. Forward to Admin Dashboard JSP view
            request.getRequestDispatcher("/adminDashboard.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading admin operational data.");
            request.getRequestDispatcher("/adminDashboard.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}

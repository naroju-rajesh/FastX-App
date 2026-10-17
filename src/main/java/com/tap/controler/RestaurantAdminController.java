package com.tap.controler;

import java.io.IOException;

import com.tap.dao.RestaurantDao;
import com.tap.daoimpl.RestaurantDaoImpl;
import com.tap.model.Restaurant;
import com.tap.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/restaurant")
public class RestaurantAdminController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private RestaurantDao restaurantDao;

    @Override
    public void init() throws ServletException {
        this.restaurantDao = new RestaurantDaoImpl();
    }

    // Handles DELETE action: /admin/restaurant?action=delete&id=1
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        // 1. Strict Security Guard: Only ADMIN allowed
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null || !"ADMIN".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/adminLogin.jsp?error=Admin session required");
            return;
        }

        String action = request.getParameter("action");
        if ("delete".equalsIgnoreCase(action)) {
            try {
                int restaurantId = Integer.parseInt(request.getParameter("id"));
                restaurantDao.deleteRestaurant(restaurantId);
                response.sendRedirect(request.getContextPath() + "/admin/dashboard?msg=restaurant_deleted");
                return;
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
    }

    // Handles ADD and UPDATE actions via forms
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        // 1. Strict Security Guard: Only ADMIN allowed
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null || !"ADMIN".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/adminLogin.jsp?error=Admin session required");
            return;
        }

        String action = request.getParameter("action");

        try {
            String name = request.getParameter("name");
            String cuisineType = request.getParameter("cuisineType");
            String address = request.getParameter("address");

            // Parse deliveryTime as int (matching Restaurant.java)
            int deliveryTime = 30;
            try {
                deliveryTime = Integer.parseInt(request.getParameter("deliveryTime"));
            } catch (Exception e) {
                deliveryTime = 30;
            }

            // Parse rating as double (matching Restaurant.java)
            double rating = 4.5;
            try {
                rating = Double.parseDouble(request.getParameter("rating"));
            } catch (Exception e) {
                rating = 4.5;
            }

            String imagePath = request.getParameter("imagePath");
            if (imagePath == null || imagePath.trim().isEmpty()) {
                imagePath = "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=500";
            }

            int adminUserId = user.getUserId();

            // ACTION 1: ADD NEW RESTAURANT
            if ("add".equalsIgnoreCase(action)) {
                Restaurant restaurant = new Restaurant();
                restaurant.setName(name);
                restaurant.setCuisineType(cuisineType);
                restaurant.setDeliveryTime(deliveryTime);
                restaurant.setAddress(address);
                restaurant.setRating(rating);
                restaurant.setActive(true);
                restaurant.setAdminUserId(adminUserId);
                restaurant.setImagePath(imagePath);

                restaurantDao.addRestaurant(restaurant);
                response.sendRedirect(request.getContextPath() + "/admin/dashboard?msg=restaurant_added");
                return;
            }

            // ACTION 2: UPDATE EXISTING RESTAURANT
            else if ("update".equalsIgnoreCase(action)) {
                int restaurantId = Integer.parseInt(request.getParameter("restaurantId"));

                Restaurant restaurant = new Restaurant();
                restaurant.setRestaurantId(restaurantId);
                restaurant.setName(name);
                restaurant.setCuisineType(cuisineType);
                restaurant.setDeliveryTime(deliveryTime);
                restaurant.setAddress(address);
                restaurant.setRating(rating);
                restaurant.setActive(true);
                restaurant.setAdminUserId(adminUserId);
                restaurant.setImagePath(imagePath);

                restaurantDao.updateRestaurant(restaurant);
                response.sendRedirect(request.getContextPath() + "/admin/dashboard?msg=restaurant_updated");
                return;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
    }
}

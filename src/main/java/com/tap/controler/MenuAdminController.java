package com.tap.controler;

import java.io.IOException;

import com.tap.dao.MenuDao;
import com.tap.daoimpl.MenuDaoImpl;
import com.tap.model.Menu;
import com.tap.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/menu")
public class MenuAdminController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private MenuDao menuDao;

    @Override
    public void init() throws ServletException {
        this.menuDao = new MenuDaoImpl();
    }

    // Handles DELETE action: /admin/menu?action=delete&id=10
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
                int menuId = Integer.parseInt(request.getParameter("id"));
                menuDao.deleteMenu(menuId);
                response.sendRedirect(request.getContextPath() + "/admin/dashboard?msg=dish_deleted");
                return;
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
    }

    // Handles ADD and UPDATE actions via POST form
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
            int restaurantId = Integer.parseInt(request.getParameter("restaurantId"));
            String itemName = request.getParameter("itemName");
            String description = request.getParameter("description");
            double price = Double.parseDouble(request.getParameter("price"));
            String category = request.getParameter("category");
            String imagePath = request.getParameter("imagePath");

            if (imagePath == null || imagePath.trim().isEmpty()) {
                imagePath = "https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=400";
            }

            // ACTION 1: ADD NEW DISH
            if ("add".equalsIgnoreCase(action)) {
                Menu menu = new Menu();
                menu.setRestaurantId(restaurantId);
                menu.setItemName(itemName);
                menu.setDescription(description);
                menu.setPrice(price);
                menu.setCategory((category != null && !category.trim().isEmpty()) ? category : "Main Course");
                menu.setAvailable(true);
                menu.setImagePath(imagePath);

                menuDao.addMenu(menu);
                response.sendRedirect(request.getContextPath() + "/admin/dashboard?msg=dish_added");
                return;
            }

            // ACTION 2: UPDATE EXISTING DISH
            else if ("update".equalsIgnoreCase(action)) {
                int menuId = Integer.parseInt(request.getParameter("menuId"));
                String isAvailableStr = request.getParameter("isAvailable");
                boolean isAvailable = ("true".equalsIgnoreCase(isAvailableStr) || "on".equalsIgnoreCase(isAvailableStr) || "1".equals(isAvailableStr));

                Menu menu = new Menu();
                menu.setMenuId(menuId);
                menu.setRestaurantId(restaurantId);
                menu.setItemName(itemName);
                menu.setDescription(description);
                menu.setPrice(price);
                menu.setCategory((category != null && !category.trim().isEmpty()) ? category : "Main Course");
                menu.setAvailable(isAvailable);
                menu.setImagePath(imagePath);

                menuDao.updateMenu(menu);
                response.sendRedirect(request.getContextPath() + "/admin/dashboard?msg=dish_updated");
                return;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
    }
}

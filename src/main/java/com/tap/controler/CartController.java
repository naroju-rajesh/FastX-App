package com.tap.controler;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import com.tap.dao.MenuDao;
import com.tap.daoimpl.MenuDaoImpl;
import com.tap.model.Cart;
import com.tap.model.CartItem;
import com.tap.model.Menu;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/cart")
public class CartController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private MenuDao menuDao;

    @Override
    public void init() {
        menuDao = new MenuDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }

        String action = request.getParameter("action");
        if (action == null || action.trim().isEmpty()) {
            action = "view";
        }

        // Check if request is asynchronous (AJAX / fetch)
        String ajaxParam = request.getParameter("ajax");
        String requestedWith = request.getHeader("X-Requested-With");
        boolean isAjax = "true".equalsIgnoreCase(ajaxParam) || "XMLHttpRequest".equalsIgnoreCase(requestedWith);

        // Check if the request originated from the menu page
        String from = request.getParameter("from");

        try {
            // =========================================================================
            // 1. ADD or CLEAR-AND-ADD ACTION
            // =========================================================================
            if ("add".equalsIgnoreCase(action) || "clearAndAdd".equalsIgnoreCase(action)) {
                
                String itemIdStr = request.getParameter("itemId");
                if (itemIdStr == null) itemIdStr = request.getParameter("menuId");
                int itemId = Integer.parseInt(itemIdStr.trim());

                // Read incoming Restaurant ID
                int incomingRestaurantId = 0;
                String restIdStr = request.getParameter("restaurantId");
                if (restIdStr != null && !restIdStr.trim().isEmpty()) {
                    incomingRestaurantId = Integer.parseInt(restIdStr.trim());
                }

                int quantity = 1;
                String qtyStr = request.getParameter("quantity");
                if (qtyStr != null && !qtyStr.trim().isEmpty()) {
                    quantity = Integer.parseInt(qtyStr.trim());
                }

                // CHECK FOR SINGLE-RESTAURANT CONFLICT (Only when action is "add")
                if ("add".equalsIgnoreCase(action) && !cart.isEmpty() && cart.getRestaurantId() != 0 && incomingRestaurantId != 0 && cart.getRestaurantId() != incomingRestaurantId) {
                    
                    if (isAjax) {
                        // Return JSON conflict notification to display the modal asynchronously
                        response.setContentType("application/json");
                        response.setCharacterEncoding("UTF-8");
                        PrintWriter out = response.getWriter();
                        out.write("{\"status\":\"conflict\",\"pendingMenuId\":" + itemId + ",\"pendingRestaurantId\":" + incomingRestaurantId + "}");
                        out.flush();
                        return;
                    }

                    // Synchronous fallback: redisplay menu.jsp with modal attributes
                    List<Menu> allMenu = menuDao.getMenusByRestaurant(incomingRestaurantId);
                    request.setAttribute("allmenu", allMenu);
                    request.setAttribute("conflict", "true");
                    request.setAttribute("pendingMenuId", String.valueOf(itemId));
                    request.setAttribute("pendingRestaurantId", String.valueOf(incomingRestaurantId));

                    request.getRequestDispatcher("menu.jsp").forward(request, response);
                    return;
                }

                // If user confirmed the popup ("clearAndAdd"), clear the old restaurant's items
                if ("clearAndAdd".equalsIgnoreCase(action)) {
                    cart.clear();
                }

                // Set active restaurant ID on cart
                if (incomingRestaurantId != 0) {
                    cart.setRestaurantId(incomingRestaurantId);
                }

                // Fetch dish details directly from MySQL database
                Menu dbMenu = menuDao.getMenu(itemId);

                if (dbMenu != null) {
                    CartItem item = new CartItem(
                        dbMenu.getMenuId(),
                        dbMenu.getRestaurantId(),
                        dbMenu.getItemName(),
                        dbMenu.getPrice(),
                        quantity,
                        dbMenu.getImagePath()
                    );
                    cart.addItem(item);
                }

                int cartCount = (cart.getItems() != null) ? cart.getItems().size() : 0;
                String dishName = (dbMenu != null) ? dbMenu.getItemName() : "Item";

                // Instant AJAX JSON Response
                if (isAjax) {
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    PrintWriter out = response.getWriter();
                    out.write("{\"status\":\"success\",\"action\":\"add\",\"menuId\":" + itemId + ",\"quantity\":" + quantity + ",\"cartCount\":" + cartCount + ",\"itemName\":\"" + dishName.replace("\"", "\\\"") + "\"}");
                    out.flush();
                    return;
                }

                // Synchronous Redirect Fallback
                response.sendRedirect("menu?restaurantId=" + incomingRestaurantId + "&added=true&itemName=" + java.net.URLEncoder.encode(dishName, "UTF-8"));
                return;

            // =========================================================================
            // 2. UPDATE QUANTITY ACTION (From Menu Stepper or Cart Stepper)
            // =========================================================================
            } else if ("update".equalsIgnoreCase(action)) {
                String uItemIdStr = request.getParameter("itemId");
                if (uItemIdStr == null) uItemIdStr = request.getParameter("menuId");
                int uItemId = Integer.parseInt(uItemIdStr.trim());
                
                int uQuantity = Integer.parseInt(request.getParameter("quantity").trim());

                // Read optional restaurantId if passed from menu
                String restIdStr = request.getParameter("restaurantId");
                int restaurantId = (restIdStr != null && !restIdStr.trim().isEmpty()) ? Integer.parseInt(restIdStr.trim()) : cart.getRestaurantId();

                if (uQuantity <= 0) {
                    cart.removeItem(uItemId);
                } else {
                    cart.updateItem(uItemId, uQuantity);
                }

                int cartCount = (cart.getItems() != null) ? cart.getItems().size() : 0;

                // Instant AJAX JSON Response
                if (isAjax) {
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    PrintWriter out = response.getWriter();
                    out.write("{\"status\":\"success\",\"action\":\"update\",\"menuId\":" + uItemId + ",\"quantity\":" + uQuantity + ",\"cartCount\":" + cartCount + "}");
                    out.flush();
                    return;
                }

                // Synchronous Redirect Fallback
                if ("menu".equalsIgnoreCase(from) && restaurantId > 0) {
                    response.sendRedirect("menu?restaurantId=" + restaurantId);
                } else {
                    response.sendRedirect("cart?action=view");
                }
                return;

            // =========================================================================
            // 3. REMOVE ITEM ACTION
            // =========================================================================
            } else if ("remove".equalsIgnoreCase(action)) {
                String rItemIdStr = request.getParameter("itemId");
                if (rItemIdStr == null) rItemIdStr = request.getParameter("menuId");
                int rItemId = Integer.parseInt(rItemIdStr.trim());
                
                cart.removeItem(rItemId);

                int cartCount = (cart.getItems() != null) ? cart.getItems().size() : 0;

                if (isAjax) {
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    PrintWriter out = response.getWriter();
                    out.write("{\"status\":\"success\",\"action\":\"remove\",\"menuId\":" + rItemId + ",\"cartCount\":" + cartCount + "}");
                    out.flush();
                    return;
                }

                String restIdStr = request.getParameter("restaurantId");
                int restaurantId = (restIdStr != null && !restIdStr.trim().isEmpty()) ? Integer.parseInt(restIdStr.trim()) : 0;

                if ("menu".equalsIgnoreCase(from) && restaurantId > 0) {
                    response.sendRedirect("menu?restaurantId=" + restaurantId);
                } else {
                    response.sendRedirect("cart?action=view");
                }
                return;

            // =========================================================================
            // 4. CLEAR ENTIRE CART ACTION
            // =========================================================================
            } else if ("clear".equalsIgnoreCase(action)) {
                cart.clear();
                if (isAjax) {
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    PrintWriter out = response.getWriter();
                    out.write("{\"status\":\"success\",\"action\":\"clear\",\"cartCount\":0}");
                    out.flush();
                    return;
                }
                response.sendRedirect("cart?action=view");
                return;

            // =========================================================================
            // 5. VIEW CART (Default)
            // =========================================================================
            } else {
                request.getRequestDispatcher("cart.jsp").forward(request, response);
                return;
            }

        } catch (Exception e) {
            e.printStackTrace();
            if (isAjax) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                PrintWriter out = response.getWriter();
                out.write("{\"status\":\"error\",\"message\":\"" + e.getMessage() + "\"}");
                out.flush();
                return;
            }
            request.getRequestDispatcher("cart.jsp").forward(request, response);
        }
    }
}

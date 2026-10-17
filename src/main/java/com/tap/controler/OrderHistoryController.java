package com.tap.controler;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.tap.dao.MenuDao;
import com.tap.dao.OrderDao;
import com.tap.dao.OrderItemDao;
import com.tap.daoimpl.MenuDaoImpl;
import com.tap.daoimpl.OrderDaoImpl;
import com.tap.daoimpl.OrderItemDaoImpl;
import com.tap.model.Menu;
import com.tap.model.Order;
import com.tap.model.OrderItem;
import com.tap.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(urlPatterns = {"/orders", "/orderHistory"})
public class OrderHistoryController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private OrderDao orderDao;
    private OrderItemDao orderItemDao;
    private MenuDao menuDao;

    @Override
    public void init() throws ServletException {
        this.orderDao = new OrderDaoImpl();
        this.orderItemDao = new OrderItemDaoImpl();
        this.menuDao = new MenuDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?redirect=" + request.getContextPath() + "/orders");
            return;
        }

        try {
            // 1. Fetch all orders for this user (sorted newest first)
            List<Order> ordersList = orderDao.getOrdersByUserId(user.getUserId());

            // 2. Map of order items and menu details per order
            Map<Integer, List<OrderItem>> orderItemsMap = new HashMap<>();
            Map<Integer, Menu> menuDetailsMap = new HashMap<>();

            if (ordersList != null) {
                for (Order order : ordersList) {
                    List<OrderItem> items = orderItemDao.getOrderItemsByOrderId(order.getOrderId());
                    if (items != null && !items.isEmpty()) {
                        orderItemsMap.put(order.getOrderId(), items);

                        for (OrderItem itm : items) {
                            int menuId = itm.getMenuId();
                            if (!menuDetailsMap.containsKey(menuId)) {
                                Menu menu = menuDao.getMenu(menuId);
                                if (menu != null) {
                                    menuDetailsMap.put(menuId, menu);
                                }
                            }
                        }
                    }
                }
            }

            request.setAttribute("ordersList", ordersList);
            request.setAttribute("orderItemsMap", orderItemsMap);
            request.setAttribute("menuDetailsMap", menuDetailsMap);

            request.getRequestDispatcher("orderHistory.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Unable to retrieve order history.");
            request.getRequestDispatcher("orderHistory.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}

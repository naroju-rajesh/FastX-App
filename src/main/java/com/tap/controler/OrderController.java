package com.tap.controler;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.tap.dao.OrderDao;
import com.tap.daoimpl.OrderDaoImpl;
import com.tap.dao.OrderItemDao;
import com.tap.daoimpl.OrderItemDaoImpl;
import com.tap.model.Cart;
import com.tap.model.CartItem;
import com.tap.model.Order;
import com.tap.model.OrderItem;
import com.tap.model.User;

/**
 * OrderController Servlet:
 * Handles order checkout submissions, inserts records into both `orders` and `order_item` tables,
 * clears the active shopping cart from the session, and forwards the customer to the Order Confirmation page.
 */
@WebServlet("/order")
public class OrderController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles POST requests submitted from checkout.jsp form.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();

        // 1. Validate User Authentication
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp?redirect=checkout.jsp");
            return;
        }

        // 2. Validate Cart Non-Empty Status
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null || cart.getItems() == null || cart.getItems().isEmpty()) {
            response.sendRedirect("restaurant");
            return;
        }

        // 3. Retrieve Checkout Form Parameters
        String deliveryAddress = request.getParameter("deliveryAddress");
        if (deliveryAddress == null || deliveryAddress.trim().isEmpty()) {
            deliveryAddress = (user.getAddress() != null) ? user.getAddress() : "Standard Delivery Address";
        } else {
            deliveryAddress = deliveryAddress.trim();
        }

        String paymentMode = request.getParameter("paymentMode");
        if (paymentMode == null || paymentMode.trim().isEmpty()) {
            paymentMode = "COD";
        }

        // Calculate grand total (with 5% GST and delivery fee)
        double itemTotal = cart.getTotalAmount();
        double deliveryFee = (itemTotal > 500) ? 0.0 : 40.0;
        double tax = Math.round((itemTotal * 0.05) * 100.0) / 100.0;
        double grandTotal = itemTotal + deliveryFee + tax;

        // Try reading totalAmount passed from form if available
        String totalAmountParam = request.getParameter("totalAmount");
        if (totalAmountParam != null && !totalAmountParam.trim().isEmpty()) {
            try {
                grandTotal = Double.parseDouble(totalAmountParam.trim());
            } catch (NumberFormatException e) {
                // fallback to calculated grandTotal
            }
        }

        // 4. Create and Insert Order into `orders` Table
        Order order = new Order();
        order.setUserId(user.getUserId());
        order.setRestaurantId(cart.getRestaurantId());
        order.setTotalAmount(grandTotal);
        order.setOrderStatus("CONFIRMED");
        order.setPaymentMode(paymentMode);
        order.setDeliveryAddress(deliveryAddress);

        OrderDao orderDao = new OrderDaoImpl();
        int generatedOrderId = orderDao.addOrder(order);

        // 5. If Order was successfully inserted, insert each food item into `order_item` Table
        if (generatedOrderId > 0) {
            order.setOrderId(generatedOrderId);

            OrderItemDao orderItemDao = new OrderItemDaoImpl();
            List<CartItem> orderedItemsList = new ArrayList<>(cart.getItems().values());

            for (CartItem cartItem : orderedItemsList) {
                OrderItem orderItem = new OrderItem();
                orderItem.setOrderId(generatedOrderId);
                orderItem.setMenuId(cartItem.getItemId());
                orderItem.setQuantity(cartItem.getQuantity());
                orderItem.setPrice(cartItem.getPrice());

                orderItemDao.addOrderItem(orderItem);
            }

            // 6. Store Order details in Request scope for confirmation receipt
            request.setAttribute("placedOrder", order);
            request.setAttribute("orderedItems", orderedItemsList);
            request.setAttribute("grandTotal", grandTotal);

            // 7. Clear the session cart (shopping cart is now empty after purchase)
            session.removeAttribute("cart");

            // 8. Forward to Order Confirmation Receipt Page
            request.getRequestDispatcher("orderConfirmation.jsp").forward(request, response);

        } else {
            // Error fallback: If database insert failed
            request.setAttribute("error", "Unable to place your order at this time. Please try again.");
            request.getRequestDispatcher("checkout.jsp").forward(request, response);
        }
    }

    /**
     * Handles direct GET requests to /order by redirecting to checkout or restaurants.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect("restaurant");
    }
}

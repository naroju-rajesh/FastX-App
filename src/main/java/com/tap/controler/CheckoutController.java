package com.tap.controler;

import java.io.IOException;

import com.tap.model.Cart;
import com.tap.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/checkout")
public class CheckoutController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        processRequest(request, response);
    }

    private void processRequest(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // 1. Check Cart Status
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            // Cart is empty, redirect back to restaurants to pick food
            response.sendRedirect("restaurant");
            return;
        }

        // 2. Check User Authentication
        User user = (User) session.getAttribute("user");
        if (user == null) {
            // User is not logged in: redirect to login with a return parameter
            response.sendRedirect("login.jsp?redirect=checkout");
            return;
        }

        // 3. User is logged in and cart is valid -> Proceed to checkout view
        request.getRequestDispatcher("checkout.jsp").forward(request, response);
    }
}

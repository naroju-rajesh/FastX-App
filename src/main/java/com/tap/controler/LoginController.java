package com.tap.controler;

import java.io.IOException;

import com.tap.dao.UserDao;
import com.tap.daoimpl.UserDaoImpl;
import com.tap.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private UserDao userDao;

    @Override
    public void init() {
        userDao = new UserDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // If accessed via GET, display login.jsp
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String redirect = request.getParameter("redirect");

        HttpSession session = request.getSession();

        try {
            if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
                request.setAttribute("error", "Email and Password are required.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            // Fetch user by email from database
            User user = userDao.getUserByEmail(email.trim());

            // Validate password (or fallback for username)
            if (user != null && password.equals(user.getPassword())) {
                // Login Success -> Store user in session
                session.setAttribute("user", user);

                // Check where to send the user next
                if ("checkout".equalsIgnoreCase(redirect)) {
                    response.sendRedirect("checkout");
                } else {
                    response.sendRedirect("restaurant");
                }
                return;

            } else {
                // Login Failed
                request.setAttribute("error", "Invalid email or password. Please try again.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An unexpected error occurred during login. Please try again.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}

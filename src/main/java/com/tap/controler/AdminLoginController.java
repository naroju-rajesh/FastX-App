package com.tap.controler;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.tap.dao.UserDao;
import com.tap.daoimpl.UserDaoImpl;
import com.tap.model.User;

@WebServlet("/adminLogin")
public class AdminLoginController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private UserDao userDao;

    @Override
    public void init() throws ServletException {
        userDao = new UserDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("adminLogin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Email and console password are required!");
            request.getRequestDispatcher("adminLogin.jsp").forward(request, response);
            return;
        }

        try {
            User user = userDao.getUserByEmail(email.trim().toLowerCase());

            // Check if user exists and password matches
            if (user == null || !user.getPassword().equals(password.trim())) {
                request.setAttribute("error", "Invalid admin credentials!");
                request.getRequestDispatcher("adminLogin.jsp").forward(request, response);
                return;
            }

            // Verify the user actually has the ADMIN role
            if (!"ADMIN".equalsIgnoreCase(user.getRole())) {
                request.setAttribute("error", "Access Denied: This account lacks Administrator clearance!");
                request.getRequestDispatcher("adminLogin.jsp").forward(request, response);
                return;
            }

            // Establish authenticated Admin Session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);

            // Redirect to executive dashboard
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Authentication error: " + e.getMessage());
            request.getRequestDispatcher("adminLogin.jsp").forward(request, response);
        }
    }
}

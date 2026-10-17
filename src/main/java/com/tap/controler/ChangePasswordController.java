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

@WebServlet("/changePassword")
public class ChangePasswordController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private UserDao userDao;

    @Override
    public void init() throws ServletException {
        this.userDao = new UserDaoImpl();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        // 1. Session Guard
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?redirect=profile.jsp");
            return;
        }

        // 2. Extract form parameters
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // 3. Security Validations
        if (currentPassword == null || newPassword == null || confirmPassword == null ||
            currentPassword.trim().isEmpty() || newPassword.trim().isEmpty() || confirmPassword.trim().isEmpty()) {
            request.setAttribute("error", "All password fields are required.");
            request.getRequestDispatcher("profile.jsp").forward(request, response);
            return;
        }

        // Verify current password against database/session
        if (!currentPassword.equals(user.getPassword())) {
            request.setAttribute("error", "Current password does not match our records.");
            request.getRequestDispatcher("profile.jsp").forward(request, response);
            return;
        }

        // Verify new passwords match
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "New password and Confirm password do not match.");
            request.getRequestDispatcher("profile.jsp").forward(request, response);
            return;
        }

        // Verify minimum length
        if (newPassword.length() < 6) {
            request.setAttribute("error", "New password must be at least 6 characters long.");
            request.getRequestDispatcher("profile.jsp").forward(request, response);
            return;
        }

        // Verify new password is not identical to current password
        if (newPassword.equals(currentPassword)) {
            request.setAttribute("error", "New password cannot be the same as your current password.");
            request.getRequestDispatcher("profile.jsp").forward(request, response);
            return;
        }

        try {
            // 4. Update password in user object and database
            user.setPassword(newPassword);
            userDao.updateUser(user);

            // 5. Update session object with fresh state
            session.setAttribute("user", user);

            // 6. Redirect with success message
            response.sendRedirect(request.getContextPath() + "/profile.jsp?msg=pwd_success");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while updating your password. Please try again.");
            request.getRequestDispatcher("profile.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Prevent direct GET access; redirect to profile
        response.sendRedirect(request.getContextPath() + "/profile.jsp");
    }
}

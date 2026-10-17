package com.tap.controler;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * FastX Logout Controller:
 * Clears user session and redirects directly to Home Page (index.jsp)
 * in guest state (showing Login & Sign Up buttons).
 */
@WebServlet("/logout")
public class LogoutController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        processLogout(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        processLogout(request, response);
    }

    private void processLogout(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        // 1. Retrieve the existing session
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            // 2. Clear and invalidate the user session completely
            session.invalidate();
        }

        // 3. Clear cache headers so sensitive user pages cannot be viewed via back button
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
        response.setHeader("Pragma", "no-cache"); // HTTP 1.0
        response.setDateHeader("Expires", 0); // Proxies

        // 4. Redirect directly to Home Page (index.jsp)
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }
}

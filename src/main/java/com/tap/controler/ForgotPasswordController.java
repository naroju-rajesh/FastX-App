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
import com.tap.util.EmailService;

@WebServlet("/forgotPassword")
public class ForgotPasswordController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private UserDao userDao;

    @Override
    public void init() throws ServletException {
        userDao = new UserDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String source = request.getParameter("source");
        String target = "admin".equalsIgnoreCase(source) ? "adminForgotPassword.jsp" : "forgotPassword.jsp";
        request.getRequestDispatcher(target).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String action = request.getParameter("action");
        String source = request.getParameter("source");
        HttpSession session = request.getSession();

        if (source != null && !source.trim().isEmpty()) {
            session.setAttribute("resetSource", source);
        } else {
            source = (String) session.getAttribute("resetSource");
        }

        String viewPage = "admin".equalsIgnoreCase(source) ? "adminForgotPassword.jsp" : "forgotPassword.jsp";

        // -------------------------------------------------------------
        // ACTION 1: SEND OTP
        // -------------------------------------------------------------
        if ("sendOtp".equalsIgnoreCase(action)) {
            String email = request.getParameter("email");

            if (email == null || email.trim().isEmpty()) {
                request.setAttribute("error", "Please enter your registered email address!");
                request.setAttribute("step", "1");
                request.getRequestDispatcher(viewPage).forward(request, response);
                return;
            }

            try {
                User user = userDao.getUserByEmail(email.trim().toLowerCase());

                if (user == null) {
                    request.setAttribute("error", "No account found registered with: " + email);
                    request.setAttribute("step", "1");
                    request.getRequestDispatcher(viewPage).forward(request, response);
                    return;
                }

                // If on Admin page, verify user actually has ADMIN role
                if ("admin".equalsIgnoreCase(source) && !"ADMIN".equalsIgnoreCase(user.getRole())) {
                    request.setAttribute("error", "Access Denied: This account does not hold Administrator clearance!");
                    request.setAttribute("step", "1");
                    request.getRequestDispatcher(viewPage).forward(request, response);
                    return;
                }

                String otp = EmailService.generateOtp();
                session.setAttribute("resetEmail", email.trim().toLowerCase());
                session.setAttribute("resetOtp", otp);
                session.setAttribute("otpExpiry", System.currentTimeMillis() + (10 * 60 * 1000));

                EmailService.sendOtpEmail(email, otp);

                request.setAttribute("step", "2");
                request.setAttribute("message", "A 6-digit verification code has been dispatched to " + email);
                request.getRequestDispatcher(viewPage).forward(request, response);

            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "Failed to dispatch verification code: " + e.getMessage());
                request.setAttribute("step", "1");
                request.getRequestDispatcher(viewPage).forward(request, response);
            }

        // -------------------------------------------------------------
        // ACTION 2: VERIFY OTP
        // -------------------------------------------------------------
        } else if ("verifyOtp".equalsIgnoreCase(action)) {
            String userOtp = request.getParameter("otp");
            String sessionOtp = (String) session.getAttribute("resetOtp");
            Long otpExpiry = (Long) session.getAttribute("otpExpiry");

            if (sessionOtp == null || otpExpiry == null) {
                request.setAttribute("error", "Verification session expired. Please request a new code.");
                request.setAttribute("step", "1");
                request.getRequestDispatcher(viewPage).forward(request, response);
                return;
            }

            if (System.currentTimeMillis() > otpExpiry) {
                request.setAttribute("error", "Verification code has expired! Please request a new code.");
                request.setAttribute("step", "1");
                request.getRequestDispatcher(viewPage).forward(request, response);
                return;
            }

            if (userOtp == null || !sessionOtp.equals(userOtp.trim())) {
                request.setAttribute("error", "Invalid verification code! Please check and try again.");
                request.setAttribute("step", "2");
                request.getRequestDispatcher(viewPage).forward(request, response);
                return;
            }

            session.setAttribute("otpVerified", true);
            request.setAttribute("step", "3");
            request.setAttribute("message", "Identity verified! Please set your new password below.");
            request.getRequestDispatcher(viewPage).forward(request, response);

        // -------------------------------------------------------------
        // ACTION 3: RESET PASSWORD
        // -------------------------------------------------------------
        } else if ("resetPassword".equalsIgnoreCase(action)) {
            Boolean verified = (Boolean) session.getAttribute("otpVerified");
            String email = (String) session.getAttribute("resetEmail");

            if (verified == null || !verified || email == null) {
                request.setAttribute("error", "Unauthorized access. Please verify your OTP first.");
                request.setAttribute("step", "1");
                request.getRequestDispatcher(viewPage).forward(request, response);
                return;
            }

            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");

            if (password == null || password.trim().length() < 6) {
                request.setAttribute("error", "New password must be at least 6 characters long!");
                request.setAttribute("step", "3");
                request.getRequestDispatcher(viewPage).forward(request, response);
                return;
            }

            if (!password.equals(confirmPassword)) {
                request.setAttribute("error", "Passwords do not match!");
                request.setAttribute("step", "3");
                request.getRequestDispatcher(viewPage).forward(request, response);
                return;
            }

            try {
                boolean updated = userDao.updatePassword(email, password.trim());

                if (updated) {
                    session.removeAttribute("resetEmail");
                    session.removeAttribute("resetOtp");
                    session.removeAttribute("otpExpiry");
                    session.removeAttribute("otpVerified");
                    session.removeAttribute("resetSource");

                    String redirectTarget = "admin".equalsIgnoreCase(source) ? "/adminLogin.jsp" : "/login.jsp";
                    response.sendRedirect(request.getContextPath() + redirectTarget + "?message=Password reset successfully! Please sign in.");
                } else {
                    request.setAttribute("error", "Failed to update password in database. Please try again.");
                    request.setAttribute("step", "3");
                    request.getRequestDispatcher(viewPage).forward(request, response);
                }

            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "Database error: " + e.getMessage());
                request.setAttribute("step", "3");
                request.getRequestDispatcher(viewPage).forward(request, response);
            }
        }
    }
}

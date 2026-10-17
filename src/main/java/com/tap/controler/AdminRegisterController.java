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

@WebServlet("/adminRegister")
public class AdminRegisterController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private UserDao userDao;

    @Override
    public void init() throws ServletException {
        // Initialize DAO implementation
        userDao = new UserDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // If accessed directly via URL, forward to register.jsp
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // 1. Extract Form Parameters from register.jsp
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // 2. Validate Required Fields
        if (username == null || username.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            
            request.setAttribute("errorMessage", "All required fields must be filled!");
            preserveInputs(request, username, email, phone, address);
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // 3. Check if Passwords Match
        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match!");
            preserveInputs(request, username, email, phone, address);
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        try {
            // 4. Check for Existing Email in Database
            User existingUser = userDao.getUserByEmail(email.trim().toLowerCase());
            if (existingUser != null) {
                request.setAttribute("errorMessage", "An account with this email already exists! Please log in.");
                preserveInputs(request, username, email, phone, address);
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            // 5. Construct New Administrator with role = "ADMIN"
            User newAdmin = new User();
            newAdmin.setUsername(username.trim());
            newAdmin.setEmail(email.trim().toLowerCase());
            newAdmin.setPassword(password.trim());
            newAdmin.setPhone(phone != null ? phone.trim() : "");
            newAdmin.setAddress(address != null && !address.trim().isEmpty() ? address.trim() : "FastX Headquarters");
            newAdmin.setRole("ADMIN"); // Sets role as ADMIN (so adminDashboard.jsp grants full access)

            // 6. Insert Admin into MySQL
            userDao.addUser(newAdmin);

            // 7. Retrieve the newly created user to get generated user_id
            User registeredAdmin = userDao.getUserByEmail(email.trim().toLowerCase());

            // 8. Auto-Login: Store Admin in Session
            HttpSession session = request.getSession();
            session.setAttribute("user", registeredAdmin != null ? registeredAdmin : newAdmin);

            // 9. Redirect directly to the Executive Admin Dashboard
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Admin registration failed: " + e.getMessage());
            preserveInputs(request, username, email, phone, address);
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }

    private void preserveInputs(HttpServletRequest request, String username, String email, String phone, String address) {
        request.setAttribute("username", username);
        request.setAttribute("email", email);
        request.setAttribute("phone", phone);
        request.setAttribute("address", address);
    }
}

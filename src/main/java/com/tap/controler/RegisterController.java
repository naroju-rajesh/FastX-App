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

@WebServlet("/register")
public class RegisterController extends HttpServlet {
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
        // Forward to the registration page on GET
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // 1. Extract Form Parameters
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String redirect = request.getParameter("redirect");

        // 2. Validate Required Fields
        if (username == null || username.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            
            request.setAttribute("errorMessage", "All required fields must be filled!");
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.setAttribute("address", address);
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // 3. Check if Passwords Match
        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match!");
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.setAttribute("address", address);
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        try {
            // 4. Check for Existing Email in Database
            User existingUser = userDao.getUserByEmail(email.trim().toLowerCase());
            if (existingUser != null) {
                request.setAttribute("errorMessage", "An account with this email already exists. Please log in!");
                request.setAttribute("username", username);
                request.setAttribute("phone", phone);
                request.setAttribute("address", address);
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            // 5. Construct New User Object with role = "USER"
            User newUser = new User();
            newUser.setUsername(username.trim());
            newUser.setEmail(email.trim().toLowerCase());
            newUser.setPassword(password.trim());
            newUser.setPhone(phone != null ? phone.trim() : "");
            newUser.setAddress(address != null ? address.trim() : "");
            newUser.setRole("USER"); // Matches your database 'role' column

            // 6. Insert User into MySQL (calling void addUser)
            userDao.addUser(newUser);

            // 7. Retrieve the newly created user to get generated user_id
            User registeredUser = userDao.getUserByEmail(email.trim().toLowerCase());

            // 8. Auto-Login: Store user in Session
            HttpSession session = request.getSession();
            session.setAttribute("user", registeredUser != null ? registeredUser : newUser);

            // 9. Redirect to requested page or restaurant catalog
            if ("checkout".equalsIgnoreCase(redirect)) {
                response.sendRedirect(request.getContextPath() + "/checkout.jsp");
            } else {
                response.sendRedirect(request.getContextPath() + "/restaurant");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Registration failed: " + e.getMessage());
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.setAttribute("address", address);
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}

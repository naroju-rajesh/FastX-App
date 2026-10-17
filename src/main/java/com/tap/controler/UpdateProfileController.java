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

@WebServlet("/updateProfile")
public class UpdateProfileController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String username = request.getParameter("username");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        if (username != null && !username.trim().isEmpty()) {
            currentUser.setUsername(username.trim());
        }
        if (phone != null && !phone.trim().isEmpty()) {
            currentUser.setPhone(phone.trim());
        }
        if (address != null) {
            currentUser.setAddress(address.trim());
        }

        UserDao userDao = new UserDaoImpl();
        userDao.updateUser(currentUser);

        // Update the user inside session so navbar & all pages update immediately
        session.setAttribute("user", currentUser);

        // Redirect back with success message
        response.sendRedirect("profile.jsp?msg=updated");
    }
}

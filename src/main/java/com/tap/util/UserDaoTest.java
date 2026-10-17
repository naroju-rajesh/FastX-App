package com.tap.util;

import com.tap.dao.UserDao;
import com.tap.daoimpl.UserDaoImpl;
import com.tap.model.User;

public class UserDaoTest {

    public static void main(String[] args) {

        UserDao userDao = new UserDaoImpl();

        // Add User
        User user = new User(
                0,
                "Rajesh",
                "12345",
                "rajesh@gmail.com",
                "9876543210",
                "Bengaluru",
                "USER"
        );

        userDao.addUser(user);

        System.out.println("User added successfully!");

        // Get User
        User getUser = userDao.getUser(1);

        System.out.println("User by ID:");
        System.out.println(getUser);

        // Get User by Email
        User userByEmail = userDao.getUserByEmail("rajesh@gmail.com");

        System.out.println("User by Email:");
        System.out.println(userByEmail);

        // Get All Users
        System.out.println("All Users:");

        for (User u : userDao.getAllUsers()) {
            System.out.println(u);
        }
    }
}
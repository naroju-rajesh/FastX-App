package com.tap.util;

import com.tap.dao.RestaurantDao;
import com.tap.daoimpl.RestaurantDaoImpl;
import com.tap.model.Restaurant;

public class RestaurantDaoTest {

    public static void main(String[] args) {

        RestaurantDao restaurantDao = new RestaurantDaoImpl();

        // Add Restaurant
//        Restaurant restaurant = new Restaurant(
//                0,
//                "Food Palace",
//                "Indian",
//                30,
//                "Bengaluru",
//                1,
//                4.5,
//                true,
//                "foodpalace.jpg"
//        );

//        restaurantDao.addRestaurant(restaurant);

//        System.out.println("Restaurant added successfully!");

//        // Get Restaurant
//        Restaurant getRestaurant = restaurantDao.getRestaurant(1);
//
//        System.out.println("Restaurant by ID:");
//        System.out.println(getRestaurant);

        // Get All Restaurants
        System.out.println("All Restaurants:");

        for (Restaurant r : restaurantDao.getAllRestaurants()) {
            System.out.println(r);
        }
    }
}
package com.tap.daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.tap.dao.RestaurantDao;
import com.tap.model.Restaurant;
import com.tap.util.DBConnection;

public class RestaurantDaoImpl implements RestaurantDao {

    private static final String INSERT_RESTAURANT =
            "INSERT INTO restaurant (name, cuisine_type, delivery_time, address, "
            + "admin_user_id, rating, is_active, image_path) "
            + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

    private static final String GET_RESTAURANT =
            "SELECT * FROM restaurant WHERE restaurant_id = ?";

    private static final String UPDATE_RESTAURANT =
            "UPDATE restaurant SET name = ?, cuisine_type = ?, delivery_time = ?, "
            + "address = ?, admin_user_id = ?, rating = ?, is_active = ?, "
            + "image_path = ? WHERE restaurant_id = ?";

    private static final String DELETE_RESTAURANT =
            "DELETE FROM restaurant WHERE restaurant_id = ?";

    private static final String GET_ALL_RESTAURANTS =
            "SELECT * FROM restaurant";

    @Override
    public void addRestaurant(Restaurant restaurant) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(INSERT_RESTAURANT)) {

            statement.setString(1, restaurant.getName());
            statement.setString(2, restaurant.getCuisineType());
            statement.setInt(3, restaurant.getDeliveryTime());
            statement.setString(4, restaurant.getAddress());
            statement.setInt(5, restaurant.getAdminUserId());
            statement.setDouble(6, restaurant.getRating());
            statement.setBoolean(7, restaurant.isActive());
            statement.setString(8, restaurant.getImagePath());

            statement.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public Restaurant getRestaurant(int restaurantId) {

        Restaurant restaurant = null;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(GET_RESTAURANT)) {

            statement.setInt(1, restaurantId);

            try (ResultSet resultSet = statement.executeQuery()) {

                if (resultSet.next()) {

                    restaurant = new Restaurant();

                    restaurant.setRestaurantId(resultSet.getInt("restaurant_id"));
                    restaurant.setName(resultSet.getString("name"));
                    restaurant.setCuisineType(resultSet.getString("cuisine_type"));
                    restaurant.setDeliveryTime(resultSet.getInt("delivery_time"));
                    restaurant.setAddress(resultSet.getString("address"));
                    restaurant.setAdminUserId(resultSet.getInt("admin_user_id"));
                    restaurant.setRating(resultSet.getDouble("rating"));
                    restaurant.setActive(resultSet.getBoolean("is_active"));
                    restaurant.setImagePath(resultSet.getString("image_path"));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return restaurant;
    }

    @Override
    public void updateRestaurant(Restaurant restaurant) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(UPDATE_RESTAURANT)) {

            statement.setString(1, restaurant.getName());
            statement.setString(2, restaurant.getCuisineType());
            statement.setInt(3, restaurant.getDeliveryTime());
            statement.setString(4, restaurant.getAddress());
            statement.setInt(5, restaurant.getAdminUserId());
            statement.setDouble(6, restaurant.getRating());
            statement.setBoolean(7, restaurant.isActive());
            statement.setString(8, restaurant.getImagePath());
            statement.setInt(9, restaurant.getRestaurantId());

            statement.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteRestaurant(int restaurantId) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(DELETE_RESTAURANT)) {

            statement.setInt(1, restaurantId);

            statement.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<Restaurant> getAllRestaurants() {

        List<Restaurant> restaurants = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(GET_ALL_RESTAURANTS);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {

                Restaurant restaurant = new Restaurant();

                restaurant.setRestaurantId(resultSet.getInt("restaurant_id"));
                restaurant.setName(resultSet.getString("name"));
                restaurant.setCuisineType(resultSet.getString("cuisine_type"));
                restaurant.setDeliveryTime(resultSet.getInt("delivery_time"));
                restaurant.setAddress(resultSet.getString("address"));
                restaurant.setAdminUserId(resultSet.getInt("admin_user_id"));
                restaurant.setRating(resultSet.getDouble("rating"));
                restaurant.setActive(resultSet.getBoolean("is_active"));
                restaurant.setImagePath(resultSet.getString("image_path"));

                restaurants.add(restaurant);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return restaurants;
    }
}
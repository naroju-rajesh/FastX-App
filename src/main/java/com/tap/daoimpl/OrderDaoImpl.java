package com.tap.daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.tap.dao.OrderDao;
import com.tap.model.Order;
import com.tap.util.DBConnection;

public class OrderDaoImpl implements OrderDao {

    private static final String INSERT_ORDER =
            "INSERT INTO orders (user_id, restaurant_id, total_amount, "
            + "order_status, payment_mode, delivery_address) "
            + "VALUES (?, ?, ?, ?, ?, ?)";

    private static final String GET_ORDER =
            "SELECT * FROM orders WHERE order_id = ?";

    private static final String UPDATE_ORDER =
            "UPDATE orders SET user_id = ?, restaurant_id = ?, total_amount = ?, "
            + "order_status = ?, payment_mode = ?, order_date = ?, "
            + "delivery_address = ? WHERE order_id = ?";

    private static final String DELETE_ORDER =
            "DELETE FROM orders WHERE order_id = ?";

    private static final String GET_ALL_ORDERS =
            "SELECT * FROM orders ORDER BY order_id DESC";

    private static final String GET_ORDERS_BY_USER_ID =
            "SELECT * FROM orders WHERE user_id = ? ORDER BY order_id DESC";

    private static final String GET_ORDERS_BY_RESTAURANT =
            "SELECT * FROM orders WHERE restaurant_id = ? ORDER BY order_id DESC";

    /**
     * Inserts a new order into the database and returns the generated order_id.
     */
    @Override
    public int addOrder(Order order) {
        int generatedOrderId = 0;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(INSERT_ORDER, Statement.RETURN_GENERATED_KEYS)) {

            statement.setInt(1, order.getUserId());
            statement.setInt(2, order.getRestaurantId());
            statement.setDouble(3, order.getTotalAmount());
            statement.setString(4, order.getOrderStatus());
            statement.setString(5, order.getPaymentMode());
            statement.setString(6, order.getDeliveryAddress());

            int affectedRows = statement.executeUpdate();

            // Retrieve the auto-generated order_id from MySQL
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        generatedOrderId = generatedKeys.getInt(1);
                    }
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return generatedOrderId;
    }

    @Override
    public Order getOrder(int orderId) {
        Order order = null;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(GET_ORDER)) {

            statement.setInt(1, orderId);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    order = new Order();

                    order.setOrderId(resultSet.getInt("order_id"));
                    order.setUserId(resultSet.getInt("user_id"));
                    order.setRestaurantId(resultSet.getInt("restaurant_id"));
                    order.setTotalAmount(resultSet.getDouble("total_amount"));
                    order.setOrderStatus(resultSet.getString("order_status"));
                    order.setPaymentMode(resultSet.getString("payment_mode"));
                    order.setOrderDate(resultSet.getString("order_date"));
                    order.setDeliveryAddress(resultSet.getString("delivery_address"));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return order;
    }

    @Override
    public void updateOrder(Order order) {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(UPDATE_ORDER)) {

            statement.setInt(1, order.getUserId());
            statement.setInt(2, order.getRestaurantId());
            statement.setDouble(3, order.getTotalAmount());
            statement.setString(4, order.getOrderStatus());
            statement.setString(5, order.getPaymentMode());
            statement.setString(6, order.getOrderDate());
            statement.setString(7, order.getDeliveryAddress());
            statement.setInt(8, order.getOrderId());

            statement.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteOrder(int orderId) {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(DELETE_ORDER)) {

            statement.setInt(1, orderId);
            statement.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(GET_ALL_ORDERS);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                Order order = new Order();

                order.setOrderId(resultSet.getInt("order_id"));
                order.setUserId(resultSet.getInt("user_id"));
                order.setRestaurantId(resultSet.getInt("restaurant_id"));
                order.setTotalAmount(resultSet.getDouble("total_amount"));
                order.setOrderStatus(resultSet.getString("order_status"));
                order.setPaymentMode(resultSet.getString("payment_mode"));
                order.setOrderDate(resultSet.getString("order_date"));
                order.setDeliveryAddress(resultSet.getString("delivery_address"));

                orders.add(order);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orders;
    }

    @Override
    public List<Order> getOrdersByUserId(int userId) {
        List<Order> orders = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(GET_ORDERS_BY_USER_ID)) {

            statement.setInt(1, userId);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    Order order = new Order();

                    order.setOrderId(resultSet.getInt("order_id"));
                    order.setUserId(resultSet.getInt("user_id"));
                    order.setRestaurantId(resultSet.getInt("restaurant_id"));
                    order.setTotalAmount(resultSet.getDouble("total_amount"));
                    order.setOrderStatus(resultSet.getString("order_status"));
                    order.setPaymentMode(resultSet.getString("payment_mode"));
                    order.setOrderDate(resultSet.getString("order_date"));
                    order.setDeliveryAddress(resultSet.getString("delivery_address"));

                    orders.add(order);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orders;
    }

    @Override
    public List<Order> getOrdersByRestaurant(int restaurantId) {
        List<Order> orders = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(GET_ORDERS_BY_RESTAURANT)) {

            statement.setInt(1, restaurantId);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    Order order = new Order();

                    order.setOrderId(resultSet.getInt("order_id"));
                    order.setUserId(resultSet.getInt("user_id"));
                    order.setRestaurantId(resultSet.getInt("restaurant_id"));
                    order.setTotalAmount(resultSet.getDouble("total_amount"));
                    order.setOrderStatus(resultSet.getString("order_status"));
                    order.setPaymentMode(resultSet.getString("payment_mode"));
                    order.setOrderDate(resultSet.getString("order_date"));
                    order.setDeliveryAddress(resultSet.getString("delivery_address"));

                    orders.add(order);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orders;
    }
}

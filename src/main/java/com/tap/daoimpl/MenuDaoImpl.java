package com.tap.daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.tap.dao.MenuDao;
import com.tap.model.Menu;
import com.tap.util.DBConnection;

public class MenuDaoImpl implements MenuDao {

    private static final String INSERT_MENU =
            "INSERT INTO menu (restaurant_id, item_name, description, price, "
            + "category, is_available, image_path) "
            + "VALUES (?, ?, ?, ?, ?, ?, ?)";

    private static final String GET_MENU =
            "SELECT * FROM menu WHERE menu_id = ?";

    private static final String UPDATE_MENU =
            "UPDATE menu SET restaurant_id = ?, item_name = ?, description = ?, "
            + "price = ?, category = ?, is_available = ?, image_path = ? "
            + "WHERE menu_id = ?";

    private static final String DELETE_MENU =
            "DELETE FROM menu WHERE menu_id = ?";

    private static final String GET_ALL_MENUS =
            "SELECT * FROM menu";

    private static final String GET_MENUS_BY_RESTAURANT =
            "SELECT * FROM menu WHERE restaurant_id = ?";

    @Override
    public void addMenu(Menu menu) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(INSERT_MENU)) {

            statement.setInt(1, menu.getRestaurantId());
            statement.setString(2, menu.getItemName());
            statement.setString(3, menu.getDescription());
            statement.setDouble(4, menu.getPrice());
            statement.setString(5, menu.getCategory());
            statement.setBoolean(6, menu.isAvailable());
            statement.setString(7, menu.getImagePath());

            statement.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public Menu getMenu(int menuId) {

        Menu menu = null;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(GET_MENU)) {

            statement.setInt(1, menuId);

            try (ResultSet resultSet = statement.executeQuery()) {

                if (resultSet.next()) {

                    menu = new Menu();

                    menu.setMenuId(resultSet.getInt("menu_id"));
                    menu.setRestaurantId(resultSet.getInt("restaurant_id"));
                    menu.setItemName(resultSet.getString("item_name"));
                    menu.setDescription(resultSet.getString("description"));
                    menu.setPrice(resultSet.getDouble("price"));
                    menu.setCategory(resultSet.getString("category"));
                    menu.setAvailable(resultSet.getBoolean("is_available"));
                    menu.setImagePath(resultSet.getString("image_path"));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return menu;
    }

    @Override
    public void updateMenu(Menu menu) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(UPDATE_MENU)) {

            statement.setInt(1, menu.getRestaurantId());
            statement.setString(2, menu.getItemName());
            statement.setString(3, menu.getDescription());
            statement.setDouble(4, menu.getPrice());
            statement.setString(5, menu.getCategory());
            statement.setBoolean(6, menu.isAvailable());
            statement.setString(7, menu.getImagePath());
            statement.setInt(8, menu.getMenuId());

            statement.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteMenu(int menuId) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(DELETE_MENU)) {

            statement.setInt(1, menuId);

            statement.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<Menu> getAllMenus() {

        List<Menu> menus = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(GET_ALL_MENUS);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {

                Menu menu = new Menu();

                menu.setMenuId(resultSet.getInt("menu_id"));
                menu.setRestaurantId(resultSet.getInt("restaurant_id"));
                menu.setItemName(resultSet.getString("item_name"));
                menu.setDescription(resultSet.getString("description"));
                menu.setPrice(resultSet.getDouble("price"));
                menu.setCategory(resultSet.getString("category"));
                menu.setAvailable(resultSet.getBoolean("is_available"));
                menu.setImagePath(resultSet.getString("image_path"));

                menus.add(menu);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return menus;
    }

    @Override
    public List<Menu> getMenusByRestaurant(int restaurantId) {

        List<Menu> menus = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(GET_MENUS_BY_RESTAURANT)) {

            statement.setInt(1, restaurantId);

            try (ResultSet resultSet = statement.executeQuery()) {

                while (resultSet.next()) {

                    Menu menu = new Menu();

                    menu.setMenuId(resultSet.getInt("menu_id"));
                    menu.setRestaurantId(resultSet.getInt("restaurant_id"));
                    menu.setItemName(resultSet.getString("item_name"));
                    menu.setDescription(resultSet.getString("description"));
                    menu.setPrice(resultSet.getDouble("price"));
                    menu.setCategory(resultSet.getString("category"));
                    menu.setAvailable(resultSet.getBoolean("is_available"));
                    menu.setImagePath(resultSet.getString("image_path"));

                    menus.add(menu);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return menus;
    }
}
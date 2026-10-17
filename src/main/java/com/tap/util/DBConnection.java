package com.tap.util;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DBConnection {

    private static String url = "jdbc:mysql://localhost:3306/FastX";
    private static String username = "root";
    private static String password = "";

    static {
        loadConfig();
    }

    private static void loadConfig() {
        Properties props = new Properties();
        try (InputStream in = DBConnection.class.getClassLoader().getResourceAsStream("config.properties")) {
            if (in != null) {
                props.load(in);
                url = props.getProperty("db.url", url);
                username = props.getProperty("db.user", username);
                password = props.getProperty("db.password", password);
            } else {
                // Fallback to Environment Variables if properties file is not present
                if (System.getenv("DB_URL") != null) url = System.getenv("DB_URL");
                if (System.getenv("DB_USER") != null) username = System.getenv("DB_USER");
                if (System.getenv("DB_PASSWORD") != null) password = System.getenv("DB_PASSWORD");
            }
        } catch (Exception e) {
            System.err.println("Notice: Could not load config.properties for DBConnection, using defaults: " + e.getMessage());
        }
    }

    public static Connection getConnection() {
        Connection connection = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            connection = DriverManager.getConnection(
                url,
                username,
                password
            );

        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }

        return connection;
    }
}

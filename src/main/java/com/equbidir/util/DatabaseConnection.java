package com.equbidir.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Simple database connection helper (beginner-friendly).
 * Edit URL/USER/PASSWORD to match your MySQL setup.
 */
public class DatabaseConnection {

    private static final String URL = "jdbc:mysql://localhost:3306/equbidir?useSSL=false&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASSWORD = "";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            // If the driver is missing, MySQL connections will fail.
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}

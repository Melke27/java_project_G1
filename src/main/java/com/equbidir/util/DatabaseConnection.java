package com.equbidir.util;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DatabaseConnection {

    private static final String PROPS_FILE = "/db.properties";

    private static String url;
    private static String username;
    private static String password;

    static {
        try (InputStream is = DatabaseConnection.class.getResourceAsStream(PROPS_FILE)) {
            if (is == null) {
                throw new IllegalStateException("Missing db.properties on classpath at " + PROPS_FILE);
            }
            Properties props = new Properties();
            props.load(is);

            url = props.getProperty("db.url");
            username = props.getProperty("db.username");
            password = props.getProperty("db.password");

            // Ensure driver is loaded (needed on some setups)
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (Exception e) {
            throw new ExceptionInInitializerError(e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(url, username, password);
    }
}

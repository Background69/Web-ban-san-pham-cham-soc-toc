package com.example.nhom49_webbansanphamchamsoctoc.database;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DBProperties {
    private static Properties properties = new Properties();
    Connection connection = null;

    //Load connection
    static {
        try {
            properties.load(DBProperties.class.getClassLoader().getResourceAsStream("db.properties"));
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    //Singleton
    public Connection getConnection() {
        try {
            if (connection == null || connection.isClosed()) {
                createConnection();
            }
            return connection;
        } catch (SQLException e) {
            return null;
        }
    }

    private void createConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection("jdbc:mysql://" + DBProperties.getHost() + ":" + DBProperties.getPort() + "/" + DBProperties.getDbName() + "?" + DBProperties.getOption(),
                    DBProperties.getUsername(), DBProperties.getPassword());
        } catch (ClassNotFoundException e) {
            return;
        }
    }

    public static String getHost() {
        return properties.getProperty("db.host");
    }

    public static String getPort() {
        return properties.getProperty("db.port");
    }

    public static String getUsername() {
        return properties.getProperty("db.username");
    }

    public static String getPassword() {
        return properties.getProperty("db.password");
    }

    public static String getDbName() {
        return properties.getProperty("db.name");
    }

    public static String getOption() {
        return properties.getProperty("db.options");
    }
}
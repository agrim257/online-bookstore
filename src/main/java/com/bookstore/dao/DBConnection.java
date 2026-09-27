package com.bookstore.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static final String DEFAULT_URL = "jdbc:mysql://localhost:3306/bookstore_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String DEFAULT_USERNAME = "root";
    private static final String DEFAULT_PASSWORD = "Agrim@257";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        // 1. Check for Railway's unified URI (MYSQL_PRIVATE_URL / MYSQL_URL / DATABASE_URL)
        String privateUrl = System.getenv("MYSQL_PRIVATE_URL");
        if (privateUrl == null || privateUrl.trim().isEmpty()) {
            privateUrl = System.getenv("MYSQL_URL");
        }
        if (privateUrl == null || privateUrl.trim().isEmpty()) {
            privateUrl = System.getenv("DATABASE_URL");
        }

        if (privateUrl != null && !privateUrl.trim().isEmpty()) {
            if (privateUrl.startsWith("mysql://")) {
                try {
                    java.net.URI uri = new java.net.URI(privateUrl);
                    String uriUser = null;
                    String uriPass = null;
                    if (uri.getUserInfo() != null) {
                        String[] parts = uri.getUserInfo().split(":", 2);
                        uriUser = parts[0];
                        if (parts.length > 1) uriPass = parts[1];
                    }
                    String uriHost = uri.getHost();
                    int uriPort = uri.getPort() > 0 ? uri.getPort() : 3306;
                    String uriPath = uri.getPath();
                    String uriDb = (uriPath != null && uriPath.length() > 1) ? uriPath.substring(1) : "railway";

                    String jdbcUrl = "jdbc:mysql://" + uriHost + ":" + uriPort + "/" + uriDb + "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
                    return DriverManager.getConnection(jdbcUrl, uriUser, uriPass);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            } else if (privateUrl.startsWith("jdbc:")) {
                return DriverManager.getConnection(privateUrl);
            }
        }

        // 2. Check for individual host/port/user/password variables
        String host = System.getenv("MYSQLHOST");
        String port = System.getenv("MYSQLPORT");
        String database = System.getenv("MYSQLDATABASE");
        String username = System.getenv("MYSQLUSER");
        String password = System.getenv("MYSQLPASSWORD");

        String url = null;
        if (host != null && !host.trim().isEmpty()) {
            port = (port != null && !port.trim().isEmpty()) ? port : "3306";
            database = (database != null && !database.trim().isEmpty()) ? database : "railway";
            url = "jdbc:mysql://" + host + ":" + port + "/" + database + "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
        }

        if (url == null || url.trim().isEmpty()) {
            url = System.getenv("DB_URL");
        }
        if (url == null || url.trim().isEmpty()) {
            url = DEFAULT_URL;
        }

        if (username == null || username.trim().isEmpty()) {
            username = System.getenv("DB_USER");
        }
        if (username == null || username.trim().isEmpty()) {
            username = System.getenv("DB_USERNAME");
        }
        if (username == null || username.trim().isEmpty()) {
            username = DEFAULT_USERNAME;
        }

        if (password == null) {
            password = System.getenv("DB_PASSWORD");
        }
        if (password == null) {
            password = DEFAULT_PASSWORD;
        }

        return DriverManager.getConnection(url, username, password);
    }
}

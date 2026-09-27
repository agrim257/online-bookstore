package com.bookstore.dao;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

public class DBInitializer {
    private static volatile boolean initialized = false;

    public static synchronized void initializeDatabase() {
        if (initialized) return;

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {

            System.out.println("[DBInitializer] Connected to database! Ensuring tables exist...");

            // 1. Users table
            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS users ("
                    + "id INT AUTO_INCREMENT PRIMARY KEY, "
                    + "name VARCHAR(100) NOT NULL, "
                    + "email VARCHAR(100) NOT NULL UNIQUE, "
                    + "password VARCHAR(255) NOT NULL, "
                    + "role VARCHAR(20) DEFAULT 'CUSTOMER', "
                    + "phone VARCHAR(20), "
                    + "address TEXT)");

            // 2. Books table
            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS books ("
                    + "id INT AUTO_INCREMENT PRIMARY KEY, "
                    + "title VARCHAR(200) NOT NULL, "
                    + "author VARCHAR(100) NOT NULL, "
                    + "category VARCHAR(50) NOT NULL, "
                    + "price DECIMAL(10,2) NOT NULL, "
                    + "stock INT NOT NULL DEFAULT 0, "
                    + "description TEXT)");

            // 3. Orders table
            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS orders ("
                    + "id INT AUTO_INCREMENT PRIMARY KEY, "
                    + "user_id INT NOT NULL, "
                    + "order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, "
                    + "total_amount DECIMAL(10,2) NOT NULL, "
                    + "status VARCHAR(30) DEFAULT 'PENDING', "
                    + "FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE)");

            // 4. Order items table
            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS order_items ("
                    + "id INT AUTO_INCREMENT PRIMARY KEY, "
                    + "order_id INT NOT NULL, "
                    + "book_id INT NOT NULL, "
                    + "quantity INT NOT NULL, "
                    + "price DECIMAL(10,2) NOT NULL, "
                    + "FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE, "
                    + "FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE)");

            // 5. Default admin user
            stmt.executeUpdate("INSERT INTO users (name, email, password, role, phone, address) "
                    + "VALUES ('Admin', 'admin@bookstore.com', 'admin123', 'ADMIN', '9999999999', 'Headquarters') "
                    + "ON DUPLICATE KEY UPDATE id=id");

            // 6. Check if books table is empty
            try (ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM books")) {
                if (rs.next() && rs.getInt(1) == 0) {
                    System.out.println("[DBInitializer] Seeding initial books in INR...");
                    stmt.executeUpdate("INSERT INTO books (title, author, category, price, stock, description) VALUES "
                            + "('Clean Code', 'Robert C. Martin', 'Technology', 599.00, 15, 'A Handbook of Agile Software Craftsmanship'), "
                            + "('Effective Java', 'Joshua Bloch', 'Technology', 799.00, 20, 'Best practices for the Java platform'), "
                            + "('The Great Gatsby', 'F. Scott Fitzgerald', 'Fiction', 249.00, 30, 'Classic novel of the Jazz Age'), "
                            + "('To Kill a Mockingbird', 'Harper Lee', 'Fiction', 349.00, 25, 'Pulitzer Prize-winning masterpiece'), "
                            + "('Sapiens', 'Yuval Noah Harari', 'History', 499.00, 10, 'A Brief History of Humankind')");
                    System.out.println("[DBInitializer] Books seeded successfully!");
                }
            }

            initialized = true;
            System.out.println("[DBInitializer] Database initialization complete.");
        } catch (Exception e) {
            System.err.println("[DBInitializer] Warning: Database auto-init failed: " + e.getMessage());
        }
    }
}

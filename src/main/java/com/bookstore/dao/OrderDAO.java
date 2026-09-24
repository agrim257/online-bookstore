package com.bookstore.dao;

import com.bookstore.model.CartItem;
import com.bookstore.model.Order;
import com.bookstore.model.OrderItem;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    public boolean placeOrder(int userId, List<CartItem> cartItems, double totalAmount) {
        String orderSql = "INSERT INTO orders (user_id, total_amount, status) VALUES (?, ?, 'PENDING')";
        String itemSql = "INSERT INTO order_items (order_id, book_id, quantity, price) VALUES (?, ?, ?, ?)";
        BookDAO bookDAO = new BookDAO();

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            int orderId = 0;
            try (PreparedStatement orderStmt = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS)) {
                orderStmt.setInt(1, userId);
                orderStmt.setDouble(2, totalAmount);
                orderStmt.executeUpdate();
                try (ResultSet rs = orderStmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        orderId = rs.getInt(1);
                    }
                }
            }

            if (orderId == 0) {
                conn.rollback();
                return false;
            }

            try (PreparedStatement itemStmt = conn.prepareStatement(itemSql)) {
                for (CartItem item : cartItems) {
                    // Reduce inventory stock
                    boolean stockUpdated = bookDAO.reduceStock(conn, item.getBook().getId(), item.getQuantity());
                    if (!stockUpdated) {
                        conn.rollback();
                        return false;
                    }

                    itemStmt.setInt(1, orderId);
                    itemStmt.setInt(2, item.getBook().getId());
                    itemStmt.setInt(3, item.getQuantity());
                    itemStmt.setDouble(4, item.getBook().getPrice());
                    itemStmt.addBatch();
                }
                itemStmt.executeBatch();
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
        return false;
    }

    public List<Order> getOrdersByUserId(int userId) {
        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY order_date DESC";
        List<Order> orders = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Order order = mapOrder(rs);
                    order.setItems(getOrderItems(order.getId()));
                    orders.add(order);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    public List<Order> getAllOrders() {
        String sql = "SELECT * FROM orders ORDER BY order_date DESC";
        List<Order> orders = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Order order = mapOrder(rs);
                order.setItems(getOrderItems(order.getId()));
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    public boolean updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE orders SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setInt(2, orderId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private List<OrderItem> getOrderItems(int orderId) {
        String sql = "SELECT oi.*, b.title FROM order_items oi JOIN books b ON oi.book_id = b.id WHERE oi.order_id = ?";
        List<OrderItem> items = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, orderId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    items.add(new OrderItem(
                        rs.getInt("id"),
                        rs.getInt("order_id"),
                        rs.getInt("book_id"),
                        rs.getString("title"),
                        rs.getInt("quantity"),
                        rs.getDouble("price")
                    ));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }

    private Order mapOrder(ResultSet rs) throws SQLException {
        return new Order(
            rs.getInt("id"),
            rs.getInt("user_id"),
            rs.getTimestamp("order_date"),
            rs.getDouble("total_amount"),
            rs.getString("status")
        );
    }
}

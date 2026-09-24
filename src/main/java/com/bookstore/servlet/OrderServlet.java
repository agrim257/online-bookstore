package com.bookstore.servlet;

import com.bookstore.dao.OrderDAO;
import com.bookstore.model.CartItem;
import com.bookstore.model.Order;
import com.bookstore.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/orders", "/checkout"})
public class OrderServlet extends HttpServlet {
    private OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login?msg=login_required");
            return;
        }

        List<Order> orders = orderDAO.getOrdersByUserId(user.getId());
        req.setAttribute("orders", orders);
        req.getRequestDispatcher("/orders.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login?msg=login_required");
            return;
        }

        @SuppressWarnings("unchecked")
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        double total = cart.stream().mapToDouble(CartItem::getSubtotal).sum();
        boolean success = orderDAO.placeOrder(user.getId(), cart, total);

        if (success) {
            cart.clear();
            resp.sendRedirect(req.getContextPath() + "/orders?msg=success");
        } else {
            resp.sendRedirect(req.getContextPath() + "/cart?error=stock_error");
        }
    }
}

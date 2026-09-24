package com.bookstore.servlet;

import com.bookstore.dao.BookDAO;
import com.bookstore.dao.OrderDAO;
import com.bookstore.model.Book;
import com.bookstore.model.Order;
import com.bookstore.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {
    "/admin/books",
    "/admin/book-form",
    "/admin/book-save",
    "/admin/book-delete",
    "/admin/orders",
    "/admin/order-status"
})
public class AdminServlet extends HttpServlet {
    private BookDAO bookDAO = new BookDAO();
    private OrderDAO orderDAO = new OrderDAO();

    private boolean checkAdmin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null || !"ADMIN".equalsIgnoreCase(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login?error=unauthorized");
            return false;
        }
        return true;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!checkAdmin(req, resp)) return;

        String path = req.getServletPath();
        if ("/admin/books".equals(path)) {
            List<Book> books = bookDAO.getAllBooks();
            req.setAttribute("books", books);
            req.getRequestDispatcher("/admin-books.jsp").forward(req, resp);
        } else if ("/admin/book-form".equals(path)) {
            String idStr = req.getParameter("id");
            if (idStr != null) {
                Book book = bookDAO.getBookById(Integer.parseInt(idStr));
                req.setAttribute("book", book);
            }
            req.getRequestDispatcher("/admin-book-form.jsp").forward(req, resp);
        } else if ("/admin/book-delete".equals(path)) {
            int id = Integer.parseInt(req.getParameter("id"));
            bookDAO.deleteBook(id);
            resp.sendRedirect(req.getContextPath() + "/admin/books?msg=deleted");
        } else if ("/admin/orders".equals(path)) {
            List<Order> orders = orderDAO.getAllOrders();
            req.setAttribute("orders", orders);
            req.getRequestDispatcher("/admin-orders.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!checkAdmin(req, resp)) return;

        String path = req.getServletPath();
        if ("/admin/book-save".equals(path)) {
            String idStr = req.getParameter("id");
            String title = req.getParameter("title");
            String author = req.getParameter("author");
            String category = req.getParameter("category");
            double price = Double.parseDouble(req.getParameter("price"));
            int stock = Integer.parseInt(req.getParameter("stock"));
            String description = req.getParameter("description");

            Book book = new Book(idStr == null || idStr.isEmpty() ? 0 : Integer.parseInt(idStr),
                                 title, author, category, price, stock, description);

            if (book.getId() > 0) {
                bookDAO.updateBook(book);
            } else {
                bookDAO.addBook(book);
            }
            resp.sendRedirect(req.getContextPath() + "/admin/books?msg=saved");
        } else if ("/admin/order-status".equals(path)) {
            int orderId = Integer.parseInt(req.getParameter("orderId"));
            String status = req.getParameter("status");
            orderDAO.updateOrderStatus(orderId, status);
            resp.sendRedirect(req.getContextPath() + "/admin/orders?msg=updated");
        }
    }
}

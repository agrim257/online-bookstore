package com.bookstore.servlet;

import com.bookstore.dao.BookDAO;
import com.bookstore.model.Book;
import com.bookstore.model.CartItem;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    private BookDAO bookDAO = new BookDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/cart.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        HttpSession session = req.getSession();

        @SuppressWarnings("unchecked")
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
            session.setAttribute("cart", cart);
        }

        try {
            if ("add".equalsIgnoreCase(action)) {
                int bookId = Integer.parseInt(req.getParameter("bookId"));
                int qty = Integer.parseInt(req.getParameter("quantity") == null ? "1" : req.getParameter("quantity"));

                Book book = bookDAO.getBookById(bookId);
                if (book != null && book.getStock() > 0) {
                    boolean exists = false;
                    for (CartItem item : cart) {
                        if (item.getBook().getId() == bookId) {
                            int newQty = item.getQuantity() + qty;
                            if (newQty <= book.getStock()) {
                                item.setQuantity(newQty);
                            }
                            exists = true;
                            break;
                        }
                    }
                    if (!exists) {
                        int finalQty = Math.min(qty, book.getStock());
                        cart.add(new CartItem(book, finalQty));
                    }
                }
            } else if ("update".equalsIgnoreCase(action)) {
                int bookId = Integer.parseInt(req.getParameter("bookId"));
                int qty = Integer.parseInt(req.getParameter("quantity"));
                for (CartItem item : cart) {
                    if (item.getBook().getId() == bookId) {
                        if (qty > 0 && qty <= item.getBook().getStock()) {
                            item.setQuantity(qty);
                        } else if (qty <= 0) {
                            cart.remove(item);
                        }
                        break;
                    }
                }
            } else if ("remove".equalsIgnoreCase(action)) {
                int bookId = Integer.parseInt(req.getParameter("bookId"));
                cart.removeIf(item -> item.getBook().getId() == bookId);
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }

        resp.sendRedirect(req.getContextPath() + "/cart");
    }
}

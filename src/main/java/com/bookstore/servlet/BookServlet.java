package com.bookstore.servlet;

import com.bookstore.dao.BookDAO;
import com.bookstore.model.Book;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/books", "/book-detail"})
public class BookServlet extends HttpServlet {
    private BookDAO bookDAO = new BookDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        if ("/book-detail".equals(path)) {
            String idStr = req.getParameter("id");
            if (idStr != null) {
                try {
                    int id = Integer.parseInt(idStr);
                    Book book = bookDAO.getBookById(id);
                    if (book != null) {
                        req.setAttribute("book", book);
                        req.getRequestDispatcher("/book-detail.jsp").forward(req, resp);
                        return;
                    }
                } catch (NumberFormatException e) {
                    // ignore
                }
            }
            resp.sendRedirect(req.getContextPath() + "/books");
        } else {
            String keyword = req.getParameter("keyword");
            String category = req.getParameter("category");

            List<Book> books = bookDAO.searchBooks(keyword, category);
            List<String> categories = bookDAO.getAllCategories();

            req.setAttribute("books", books);
            req.setAttribute("categories", categories);
            req.setAttribute("selectedCategory", category);
            req.setAttribute("keyword", keyword);

            req.getRequestDispatcher("/books.jsp").forward(req, resp);
        }
    }
}

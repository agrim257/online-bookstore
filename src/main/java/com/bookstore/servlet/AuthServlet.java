package com.bookstore.servlet;

import com.bookstore.dao.UserDAO;
import com.bookstore.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(urlPatterns = {"/login", "/register", "/logout"})
public class AuthServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        if ("/logout".equals(path)) {
            HttpSession session = req.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            resp.sendRedirect(req.getContextPath() + "/login?msg=logged_out");
        } else if ("/register".equals(path)) {
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
        } else {
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        if ("/login".equals(path)) {
            String email = req.getParameter("email");
            String password = req.getParameter("password");

            User user = userDAO.authenticate(email, password);
            if (user != null) {
                HttpSession session = req.getSession();
                session.setAttribute("user", user);
                if ("ADMIN".equalsIgnoreCase(user.getRole())) {
                    resp.sendRedirect(req.getContextPath() + "/admin/books");
                } else {
                    resp.sendRedirect(req.getContextPath() + "/books");
                }
            } else {
                req.setAttribute("error", "Invalid email or password!");
                req.getRequestDispatcher("/login.jsp").forward(req, resp);
            }
        } else if ("/register".equals(path)) {
            String name = req.getParameter("name");
            String email = req.getParameter("email");
            String password = req.getParameter("password");
            String phone = req.getParameter("phone");
            String address = req.getParameter("address");

            if (name == null || email == null || password == null || name.trim().isEmpty() || email.trim().isEmpty() || password.trim().isEmpty()) {
                req.setAttribute("error", "All required fields must be filled!");
                req.getRequestDispatcher("/register.jsp").forward(req, resp);
                return;
            }

            User user = new User(0, name, email, password, "CUSTOMER", phone, address);
            if (userDAO.register(user)) {
                resp.sendRedirect(req.getContextPath() + "/login?msg=registered");
            } else {
                req.setAttribute("error", "Registration failed. Email might already exist.");
                req.getRequestDispatcher("/register.jsp").forward(req, resp);
            }
        }
    }
}

package com.bookstore.servlet;

import com.bookstore.dao.UserDAO;
import com.bookstore.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/profile")
public class UserProfileServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User sessionUser = (session != null) ? (User) session.getAttribute("user") : null;
        if (sessionUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User user = userDAO.getUserById(sessionUser.getId());
        req.setAttribute("user", user);
        req.getRequestDispatcher("/profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User sessionUser = (session != null) ? (User) session.getAttribute("user") : null;
        if (sessionUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String name = req.getParameter("name");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");
        String password = req.getParameter("password");

        sessionUser.setName(name);
        sessionUser.setPhone(phone);
        sessionUser.setAddress(address);
        if (password != null && !password.trim().isEmpty()) {
            sessionUser.setPassword(password);
        }

        boolean updated = userDAO.updateUser(sessionUser);
        if (updated) {
            session.setAttribute("user", sessionUser);
            resp.sendRedirect(req.getContextPath() + "/profile?msg=updated");
        } else {
            req.setAttribute("error", "Profile update failed.");
            req.getRequestDispatcher("/profile.jsp").forward(req, resp);
        }
    }
}

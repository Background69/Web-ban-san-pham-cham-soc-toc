package com.example.nhom49_webbansanphamchamsoctoc.controller.authentication;

import com.example.nhom49_webbansanphamchamsoctoc.dao.UserDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import com.example.nhom49_webbansanphamchamsoctoc.util.PasswordUtil;
import com.example.nhom49_webbansanphamchamsoctoc.util.TokenUtil;
import com.example.nhom49_webbansanphamchamsoctoc.util.ValidationUtil;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.time.Instant;

@WebServlet(name = "ResetPasswordController", urlPatterns = {"/reset-password"})
public class ResetPasswordController extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = req.getParameter("token");
        if (token == null || token.isBlank()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid token.");
            return;
        }

        String tokenHash = TokenUtil.hashToken(token);
        User user = userDAO.findByResetToken(tokenHash);
        if (user == null || user.getResetTokenExpiry() == null ||
                user.getResetTokenExpiry().toInstant().isBefore(Instant.now())) {
            req.setAttribute("error", "Invalid or expired reset link.");
            req.getRequestDispatcher("/authentication/forgot-password-sent.jsp").forward(req, resp);
            return;
        }
        req.setAttribute("token", token);
        req.getRequestDispatcher("/authentication/forgot-password-reset.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String token = req.getParameter("token");
        String tokenHash = TokenUtil.hashToken(token);
        String newPassword = req.getParameter("newPassword");
        String confirmPassword = req.getParameter("confirmPassword");

        if (tokenHash == null) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid token.");
            return;
        }
        if (!ValidationUtil.isNotEmpty(newPassword) || !newPassword.equals(confirmPassword)) {
            req.setAttribute("error", "Passwords không khớp.");
            req.setAttribute("token", token);
            req.getRequestDispatcher("/authentication/forgot-password-reset.jsp").forward(req, resp);


            return;
        }
        User user = userDAO.findByResetToken(tokenHash);
        if (user == null || user.getResetTokenExpiry() == null ||
                user.getResetTokenExpiry().toInstant().isBefore(Instant.now())) {
            req.setAttribute("error", "Invalid or expired reset link.");
            req.getRequestDispatcher("/authentication/forgot-password-sent.jsp").forward(req, resp);
            return;
        }
        String hashed = PasswordUtil.hashPassword(newPassword);
        userDAO.updatePassword(user.getUserId(), hashed);
        userDAO.saveResetToken(user.getUserId(), null, null);
        resp.sendRedirect(req.getContextPath() + "/authentication/login.jsp");

    }
}
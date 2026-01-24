package com.example.nhom49_webbansanphamchamsoctoc.controller.authentication;

import com.example.nhom49_webbansanphamchamsoctoc.dao.UserDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import com.example.nhom49_webbansanphamchamsoctoc.util.PasswordUtil;
import com.example.nhom49_webbansanphamchamsoctoc.util.TokenUtil;
import com.example.nhom49_webbansanphamchamsoctoc.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.Instant;

@WebServlet(name = "ResetPasswordController", urlPatterns = {"/reset-password"})
public class ResetPasswordController extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = req.getParameter("token");

        if (token == null || token.isBlank()) {
            req.setAttribute("error", "Link đặt lại mật khẩu không hợp lệ.");
            req.getRequestDispatcher("/authentication/forgot-password-sent.jsp").forward(req, resp);
            return;
        }

        String tokenHash = TokenUtil.hashToken(token);
        User user = userDAO.findByResetToken(tokenHash);

        // ✅ Check user + expiry an toàn
        if (user == null || user.getResetTokenExpiry() == null ||
                user.getResetTokenExpiry().toInstant().isBefore(Instant.now())) {
            req.setAttribute("error", "Link đặt lại mật khẩu không hợp lệ hoặc đã hết hạn.");
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
        String newPassword = req.getParameter("newPassword");
        String confirmPassword = req.getParameter("confirmPassword");

        if (token == null || token.isBlank()) {
            req.setAttribute("error", "Token không hợp lệ.");
            req.getRequestDispatcher("/authentication/forgot-password-sent.jsp").forward(req, resp);
            return;
        }

        String passErr = ValidationUtil.validatePassword(newPassword);
        if (passErr != null) {
            req.setAttribute("error", passErr);
            req.setAttribute("token", token);
            req.getRequestDispatcher("/authentication/forgot-password-reset.jsp").forward(req, resp);
            return;
        }

        String confirmErr = ValidationUtil.validateConfirmPassword(newPassword, confirmPassword);
        if (confirmErr != null) {
            req.setAttribute("error", confirmErr);
            req.setAttribute("token", token);
            req.getRequestDispatcher("/authentication/forgot-password-reset.jsp").forward(req, resp);
            return;
        }

        String tokenHash = TokenUtil.hashToken(token);
        User user = userDAO.findByResetToken(tokenHash);

        if (user == null || user.getResetTokenExpiry() == null ||
                user.getResetTokenExpiry().toInstant().isBefore(Instant.now())) {
            req.setAttribute("error", "Link đặt lại mật khẩu không hợp lệ hoặc đã hết hạn.");
            req.getRequestDispatcher("/authentication/forgot-password-sent.jsp").forward(req, resp);
            return;
        }

        String hashed = PasswordUtil.hashPassword(newPassword);
        userDAO.updatePassword(user.getUserId(), hashed);
        userDAO.saveResetToken(user.getUserId(), null, null);

        resp.sendRedirect(req.getContextPath() + "/auth/login");
    }
}

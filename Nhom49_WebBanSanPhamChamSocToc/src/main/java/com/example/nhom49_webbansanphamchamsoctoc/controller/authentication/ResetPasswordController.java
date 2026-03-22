package com.example.nhom49_webbansanphamchamsoctoc.controller.authentication;

import com.example.nhom49_webbansanphamchamsoctoc.dao.UserDAO;
import com.example.nhom49_webbansanphamchamsoctoc.util.PasswordUtil;
import com.example.nhom49_webbansanphamchamsoctoc.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "ResetPasswordController", urlPatterns = {"/reset-password"})
public class ResetPasswordController extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Integer verifiedUserId = (Integer) req.getSession().getAttribute("otpVerifiedUserId");

        if (verifiedUserId == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/forgot-password");
            return;
        }

        req.getRequestDispatcher("/authentication/forgot-password-reset.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String email = trim(req.getParameter("email"));
        String otpCode = trim(req.getParameter("otp"));
        String newPassword = req.getParameter("newPassword");
        String confirmPassword = req.getParameter("confirmPassword");
        Integer verifiedUserId = (Integer) req.getSession().getAttribute("otpVerifiedUserId");

        if (verifiedUserId == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/forgot-password");
            return;
        }

        String passwordError = ValidationUtil.validatePassword(newPassword);
        if (passwordError != null) {
            forwardWithError(req, resp, passwordError, email, otpCode);
            return;
        }

        String confirmPasswordError = ValidationUtil.validateConfirmPassword(newPassword, confirmPassword);
        if (confirmPasswordError != null) {
            forwardWithError(req, resp, confirmPasswordError, email, otpCode);
            return;
        }

        String hashedPassword = PasswordUtil.hashPassword(newPassword);
        userDAO.updatePassword(verifiedUserId, hashedPassword);

        req.getSession().removeAttribute("otpVerifiedUserId");
        req.getSession().setAttribute("success", "Đổi mật khẩu thành công.");
        resp.sendRedirect(req.getContextPath() + "/auth/login");
    }

    private void forwardWithError(HttpServletRequest req, HttpServletResponse resp, String error,
                                  String email, String otpCode) throws ServletException, IOException {
        req.setAttribute("error", error);
        req.setAttribute("email", email);
        req.setAttribute("otp", otpCode);
        req.getRequestDispatcher("/authentication/forgot-password-reset.jsp").forward(req, resp);
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }
}

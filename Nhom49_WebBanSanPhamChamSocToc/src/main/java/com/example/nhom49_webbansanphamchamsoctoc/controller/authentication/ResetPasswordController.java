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

        String newPassword = req.getParameter("newPassword");
        String confirmPassword = req.getParameter("confirmPassword");
        Integer verifiedUserId = (Integer) req.getSession().getAttribute("otpVerifiedUserId");

        if (verifiedUserId == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/forgot-password");
            return;
        }

        String passwordError = ValidationUtil.validatePassword(newPassword);
        if (passwordError != null) {
            forwardWithError(req, resp, passwordError);
            return;
        }

        String confirmPasswordError = ValidationUtil.validateConfirmPassword(newPassword, confirmPassword);
        if (confirmPasswordError != null) {
            forwardWithError(req, resp, confirmPasswordError);
            return;
        }

        String hashedPassword = PasswordUtil.hashPassword(newPassword);
        boolean updatePassword = userDAO.updatePassword(verifiedUserId, hashedPassword);

        if (updatePassword) {
            req.getSession().setAttribute("success", "Đổi mật khẩu thành công.");
            req.getSession().removeAttribute("otpVerifiedUserId");
            req.getSession().removeAttribute("otpPendingUserId");
            req.getSession().removeAttribute("otpPendingEmail");
            req.getSession().removeAttribute("otpPurpose");
            req.getSession().removeAttribute("otpLastSentAt");

            resp.sendRedirect(req.getContextPath() + "/auth/login");
        } else  {
            forwardWithError(req, resp, "Không thể cập nhật mật khẩu. Vui lòng thử lại.");
        }

    }

    private void forwardWithError(HttpServletRequest req, HttpServletResponse resp, String error) throws ServletException, IOException {
        req.setAttribute("error", error);
        req.getRequestDispatcher("/authentication/forgot-password-reset.jsp").forward(req, resp);
    }
}

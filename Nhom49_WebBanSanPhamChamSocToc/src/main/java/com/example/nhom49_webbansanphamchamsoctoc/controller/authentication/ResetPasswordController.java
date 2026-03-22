package com.example.nhom49_webbansanphamchamsoctoc.controller.authentication;

import com.example.nhom49_webbansanphamchamsoctoc.dao.OtpVerificationDAO;
import com.example.nhom49_webbansanphamchamsoctoc.dao.UserDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.OtpVerification;
import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import com.example.nhom49_webbansanphamchamsoctoc.util.PasswordUtil;
import com.example.nhom49_webbansanphamchamsoctoc.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDateTime;

@WebServlet(name = "ResetPasswordController", urlPatterns = {"/reset-password"})
public class ResetPasswordController extends HttpServlet {

    private static final int MAX_OTP_ATTEMPTS = 5;

    private final UserDAO userDAO = new UserDAO();
    private final OtpVerificationDAO otpVerificationDAO = new OtpVerificationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("email", req.getParameter("email"));
        req.setAttribute("otp", req.getParameter("otp"));
        req.getRequestDispatcher("/authentication/forgot-password-reset.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String email = trim(req.getParameter("email"));
        String otpCode = trim(req.getParameter("otp"));
        String newPassword = req.getParameter("newPassword");
        String confirmPassword = req.getParameter("confirmPassword");

        String emailError = ValidationUtil.validateEmail(email);
        if (emailError != null) {
            forwardWithError(req, resp, "Email khong hop le.", email, otpCode);
            return;
        }

        if (!isValidOtpCode(otpCode)) {
            forwardWithError(req, resp, "Ma OTP phai gom 6 chu so.", email, otpCode);
            return;
        }

        String passErr = ValidationUtil.validatePassword(newPassword);
        if (passErr != null) {
            forwardWithError(req, resp, passErr, email, otpCode);
            return;
        }

        String confirmErr = ValidationUtil.validateConfirmPassword(newPassword, confirmPassword);
        if (confirmErr != null) {
            forwardWithError(req, resp, confirmErr, email, otpCode);
            return;
        }

        User user = userDAO.findByEmail(email);
        if (user == null) {
            forwardWithError(req, resp, "OTP khong hop le hoac da het han.", email, otpCode);
            return;
        }

        OtpVerification otp = otpVerificationDAO.findLatestForgotPasswordOtp(user.getUserId(), otpCode);
        if (otp == null) {
            OtpVerification latestOtp = otpVerificationDAO.findLatestForgotPasswordOtpByUser(user.getUserId());
            if (latestOtp != null && !latestOtp.isVerified()) {
                otpVerificationDAO.incrementAttempts(latestOtp.getOtpId());
                if (latestOtp.getAttempts() + 1 >= MAX_OTP_ATTEMPTS) {
                    forwardWithError(req, resp, "OTP da vuot qua so lan thu toi da.", email, otpCode);
                    return;
                }
            }
            forwardWithError(req, resp, "OTP khong hop le hoac da het han.", email, otpCode);
            return;
        }

        if (otp.isVerified()) {
            forwardWithError(req, resp, "OTP da duoc su dung. Vui long yeu cau ma moi.", email, otpCode);
            return;
        }

        if (otp.getAttempts() >= MAX_OTP_ATTEMPTS) {
            forwardWithError(req, resp, "OTP da vuot qua so lan thu toi da.", email, otpCode);
            return;
        }

        if (otp.getOtpExpiry() == null || otp.getOtpExpiry().toLocalDateTime().isBefore(LocalDateTime.now())) {
            forwardWithError(req, resp, "OTP da het han. Vui long yeu cau ma moi.", email, otpCode);
            return;
        }

        String hashed = PasswordUtil.hashPassword(newPassword);
        boolean updated = userDAO.updatePassword(user.getUserId(), hashed);
        if (!updated) {
            forwardWithError(req, resp, "Khong the cap nhat mat khau. Vui long thu lai.", email, otpCode);
            return;
        }

        otpVerificationDAO.markVerified(otp.getOtpId());
        req.getSession().setAttribute("success", "Doi mat khau thanh cong, vui long dang nhap.");
        resp.sendRedirect(req.getContextPath() + "/auth/login");
    }

    private void forwardWithError(HttpServletRequest req, HttpServletResponse resp, String error,
                                  String email, String otp) throws ServletException, IOException {
        req.setAttribute("error", error);
        req.setAttribute("email", email);
        req.setAttribute("otp", otp);
        req.getRequestDispatcher("/authentication/forgot-password-reset.jsp").forward(req, resp);
    }

    private boolean isValidOtpCode(String otp) {
        return otp != null && otp.matches("\\d{6}");
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }
}

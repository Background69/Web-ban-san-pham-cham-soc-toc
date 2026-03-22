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
            forwardWithError(req, resp, emailError, email, otpCode);
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

        User user = userDAO.findByEmail(email);
        if (user == null) {
            forwardWithError(req, resp, "Không tìm thấy Email.", email, otpCode);
            return;
        }

        if (!isValidOtpCode(otpCode)) {
            forwardWithError(req, resp, "OTP phải đủ 6 kí tự số.", email, otpCode);
            return;
        }

        OtpVerification otp = otpVerificationDAO.findLatestOtpByUserId(user.getUserId());
        if (otp == null) {
            forwardWithError(req, resp, "Mã OTP không hợp lệ.", email, otpCode);
            return;
        }

        if (otp.getOtpExpiry() == null || otp.getOtpExpiry().toLocalDateTime().isBefore(LocalDateTime.now())) {
            forwardWithError(req, resp, "Mã OTP hết hạn sử dụng.", email, otpCode);
            return;
        }

        if (otp.isVerified()) {
            forwardWithError(req, resp, "Mã OTP đã qua sử dụng rồi.", email, otpCode);
            return;
        }

        if (otp.getAttempts() >= MAX_OTP_ATTEMPTS) {
            forwardWithError(req, resp, "Đã vượt quá số lần nhập OTP.", email, otpCode);
            return;
        }

        if (!otp.getOtpCode().equals(otpCode)) {
            otpVerificationDAO.incrementAttempts(otp.getOtpId());
            int newAttempts = otp.getAttempts() + 1;
            if (newAttempts >= MAX_OTP_ATTEMPTS) {
                forwardWithError(req, resp, "OTP sai. Đã vượt quá số lần nhập.", email, otpCode);
            } else {
                forwardWithError(req, resp, "OTP không đúng.", email, otpCode);
            }
            return;
        }

        String hashedPassword = PasswordUtil.hashPassword(newPassword);

        boolean updated = userDAO.updatePassword(user.getUserId(), hashedPassword);
        if (!updated) {
            forwardWithError(req, resp, "Không thể cập nhật mật khẩu, vui lòng thử lại.", email, otpCode);
            return;
        }

        otpVerificationDAO.markVerified(otp.getOtpId());
        req.getSession().setAttribute("success", "Đổi mật khẩu thành công, vui lòng đăng nhập lại.");
        resp.sendRedirect(req.getContextPath() + "/auth/login");
    }

    private void forwardWithError(HttpServletRequest req, HttpServletResponse resp, String error,
                                  String email, String otpCode) throws ServletException, IOException {
        req.setAttribute("error", error);
        req.setAttribute("email", email);
        req.setAttribute("otp", otpCode);
        req.getRequestDispatcher("/authentication/forgot-password-reset.jsp").forward(req, resp);
    }

    private boolean isValidOtpCode(String otp) {
        return otp != null && otp.matches("\\d{6}");
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }
}

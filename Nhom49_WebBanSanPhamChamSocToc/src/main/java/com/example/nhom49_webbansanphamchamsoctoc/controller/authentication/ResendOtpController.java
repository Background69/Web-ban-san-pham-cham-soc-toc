package com.example.nhom49_webbansanphamchamsoctoc.controller.authentication;

import com.example.nhom49_webbansanphamchamsoctoc.dao.OtpVerificationDAO;
import com.example.nhom49_webbansanphamchamsoctoc.services.EmailService;
import com.example.nhom49_webbansanphamchamsoctoc.util.OtpUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;

@WebServlet(name = "ResendOtpController", urlPatterns = {"/auth/resend-otp"})
public class ResendOtpController extends HttpServlet {
    private static final int RESEND_COOLDOWN_SECONDS = 45;
    private static final int OTP_EXPIRY_MINUTES = 15;

    private final OtpVerificationDAO otpVerificationDAO = new OtpVerificationDAO();
    private final EmailService emailService = new EmailService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        Integer otpPendingUserId = (Integer) req.getSession().getAttribute("otpPendingUserId");
        String otpPendingEmail = (String) req.getSession().getAttribute("otpPendingEmail");
        String otpPurpose = (String) req.getSession().getAttribute("otpPurpose");

        if (otpPendingUserId == null || otpPendingEmail == null || !"FORGOT_PASSWORD".equals(otpPurpose)) {
            res.sendRedirect(req.getContextPath() + "/auth/forgot-password");
            return;
        }

        // Tính cooldown, hết cooldown rồi mới được resend lại code
        Long lastSentAt = (Long) req.getSession().getAttribute("otpLastSentAt");
        long now = System.currentTimeMillis();

        if (lastSentAt != null) {
            long elapsedMillis = now - lastSentAt;
            long cooldownMillis = RESEND_COOLDOWN_SECONDS * 1000L;

            if (elapsedMillis < cooldownMillis) {
                long remainingSec = (cooldownMillis - elapsedMillis + 999) / 1000;
                req.setAttribute("error", "Vui long doi " + remainingSec + " giay de gui lai OTP.");
                req.getRequestDispatcher("/authentication/otp-verification.jsp").forward(req, res);
                return;
            }
        }

        String otpCode = OtpUtil.otpGenerate(6);
        java.sql.Timestamp expiry = Timestamp.valueOf(LocalDateTime.now().plusMinutes(OTP_EXPIRY_MINUTES));

        otpVerificationDAO.createForgotPasswordOtp(otpPendingUserId, otpCode, expiry);

        String resetLink = req.getScheme() + "://" + req.getServerName()
                + ":" + req.getServerPort()
                + req.getContextPath()
                + "/auth/verify-otp";

        boolean sent = emailService.sendPasswordResetOtpEmail(otpPendingEmail, otpCode, resetLink, OTP_EXPIRY_MINUTES);

        if (!sent) {
            req.setAttribute("error", "Khong gui duoc OTP. Vui long thu lai sau.");
            req.getRequestDispatcher("/authentication/otp-verification.jsp").forward(req, res);
            return;
        }

        req.getSession().setAttribute("otpLastSentAt", now);
        req.setAttribute("message", "Da gui lai OTP. Vui long kiem tra email.");
        req.getRequestDispatcher("/authentication/otp-verification.jsp").forward(req, res);
    }
}

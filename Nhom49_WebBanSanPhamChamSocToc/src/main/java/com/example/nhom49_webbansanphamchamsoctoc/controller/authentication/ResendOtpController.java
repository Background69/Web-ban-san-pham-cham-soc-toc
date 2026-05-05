package com.example.nhom49_webbansanphamchamsoctoc.controller.authentication;

import com.example.nhom49_webbansanphamchamsoctoc.dao.OtpVerificationDAO;
import com.example.nhom49_webbansanphamchamsoctoc.dao.PendingRegistrationDAO;
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

    private final PendingRegistrationDAO pendingRegistrationDAO = new PendingRegistrationDAO();
    private final OtpVerificationDAO otpVerificationDAO = new OtpVerificationDAO();
    private final EmailService emailService = new EmailService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/authentication/otp-verification.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String otpPendingEmail = (String) req.getSession().getAttribute("otpPendingEmail");
        String purposeRaw = (String) req.getSession().getAttribute("otpPurpose");

        if (otpPendingEmail == null || otpPendingEmail.isBlank() || purposeRaw == null || purposeRaw.isBlank()) {
            res.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        OtpVerificationDAO.OtpPurpose otpPurpose;
        try {
            otpPurpose = OtpVerificationDAO.OtpPurpose.valueOf(purposeRaw);
        } catch (Exception e) {
            res.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        Long lastSentAt = (Long) req.getSession().getAttribute("otpLastSentAt");
        long now = System.currentTimeMillis();
        long cooldownMillis = RESEND_COOLDOWN_SECONDS * 1000L;

        if (lastSentAt != null && now - lastSentAt < cooldownMillis) {
            long remainingSec = (cooldownMillis - (now - lastSentAt) + 999) / 1000;
            req.setAttribute("error", "Vui lòng đợi " + remainingSec + " giây để gửi lại OTP.");
            req.getRequestDispatcher("/authentication/otp-verification.jsp").forward(req, res);
            return;
        }

        String otpCode = OtpUtil.otpGenerate(6);
        Timestamp expiry = Timestamp.valueOf(LocalDateTime.now().plusMinutes(OTP_EXPIRY_MINUTES));

        String verifyLink = req.getScheme() + "://" + req.getServerName()
                + ":" + req.getServerPort()
                + req.getContextPath()
                + "/auth/verify-otp";

        boolean sent;

        if (otpPurpose == OtpVerificationDAO.OtpPurpose.REGISTER) {
            Integer pendingId = (Integer) req.getSession().getAttribute("otpPendingRegistrationId");
            if (pendingId == null) {
                res.sendRedirect(req.getContextPath() + "/auth/register");
                return;
            }

            boolean updated = pendingRegistrationDAO.updateOtp(pendingId, otpCode, expiry);
            if (!updated) {
                req.setAttribute("error", "Có lỗi xảy ra, vui lòng thử lại.");
                req.getRequestDispatcher("/authentication/otp-verification.jsp").forward(req, res);
                return;
            }

            sent = emailService.sendRegisterOtpEmail(otpPendingEmail, otpCode, verifyLink, OTP_EXPIRY_MINUTES);


        } else {
            Integer otpPendingUserId = (Integer) req.getSession().getAttribute("otpPendingUserId");
            if (otpPendingUserId == null) {
                res.sendRedirect(req.getContextPath() + "/auth/forgot-password");
                return;
            }

            int otpId = otpVerificationDAO.createOtp(otpPendingUserId, otpCode, otpPurpose, expiry);
            if (otpId == -1) {
                req.setAttribute("error", "Có lỗi xảy ra, vui lòng thử lại.");
                req.getRequestDispatcher("/authentication/otp-verification.jsp").forward(req, res);
                return;
            }

            sent = emailService.sendResetPasswordOtpEmail(otpPendingEmail, otpCode, verifyLink, OTP_EXPIRY_MINUTES);
        }

        if (!sent) {
            req.setAttribute("error", "Không gửi được OTP. Vui lòng thử lại sau.");
            req.getRequestDispatcher("/authentication/otp-verification.jsp").forward(req, res);
            return;
        }

        now = System.currentTimeMillis();
        long otpExpiryAt = now + OTP_EXPIRY_MINUTES * 60_000L;

        req.getSession().setAttribute("otpLastSentAt", now);
        req.getSession().setAttribute("otpExpiryAt", otpExpiryAt);
        req.setAttribute("message", "Đã gửi lại OTP. Vui lòng kiểm tra email.");
        req.getRequestDispatcher("/authentication/otp-verification.jsp").forward(req, res);
    }
}

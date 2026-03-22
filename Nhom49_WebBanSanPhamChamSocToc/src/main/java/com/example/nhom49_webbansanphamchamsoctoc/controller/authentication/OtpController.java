package com.example.nhom49_webbansanphamchamsoctoc.controller.authentication;

import com.example.nhom49_webbansanphamchamsoctoc.dao.OtpVerificationDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.OtpVerification;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDateTime;

@WebServlet(name = "OtpController", value = "/auth/verify-otp")
public class OtpController extends HttpServlet {
    private final OtpVerificationDAO otpVerificationDAO = new OtpVerificationDAO();
    private static final int MAX_OTP_ATTEMPTS = 5;


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/authentication/otp-verification.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Integer otpPendingUserId = (Integer) req.getSession().getAttribute("otpPendingUserId");
        String purpose = (String) req.getSession().getAttribute("otpPurpose");

        if (otpPendingUserId == null || !"FORGOT_PASSWORD".equals(purpose)) {
            resp.sendRedirect(req.getContextPath() + "/auth/forgot-password");
            return;
        }
        String otpCode = trim(req.getParameter("otp"));

        if (!isValidOtpCode(otpCode)) {
            forwardWithError(req, resp, "OTP phải đủ 6 kí tự số.", otpCode);
            return;
        }

        OtpVerification otp = otpVerificationDAO.findLatestOtpByUserId(otpPendingUserId);
        if (otp == null) {
            forwardWithError(req, resp, "Mã OTP không hợp lệ.", otpCode);
            return;
        }

        if (otp.getOtpExpiry() == null || otp.getOtpExpiry().toLocalDateTime().isBefore(LocalDateTime.now())) {
            forwardWithError(req, resp, "Mã OTP hết hạn sử dụng.", otpCode);
            return;
        }

        if (otp.isVerified()) {
            forwardWithError(req, resp, "Mã OTP đã qua sử dụng rồi.", otpCode);
            return;
        }

        if (otp.getAttempts() >= MAX_OTP_ATTEMPTS) {
            forwardWithError(req, resp, "Đã vượt quá số lần nhập OTP.", otpCode);
            return;
        }

        if (!otp.getOtpCode().equals(otpCode)) {
            if (!otpVerificationDAO.incrementAttempts(otp.getOtpId())) {
                forwardWithError(req, resp, "Có lỗi xảy ra, vui lòng thử lại.", otpCode);
                return;
            }
            int newAttempts = otp.getAttempts() + 1;
            if (newAttempts >= MAX_OTP_ATTEMPTS) {
                forwardWithError(req, resp, "OTP sai. Đã vượt quá số lần nhập.", otpCode);
            } else {
                forwardWithError(req, resp, "OTP không đúng.", otpCode);
            }
            return;
        }

        req.getSession().setAttribute("otpVerifiedUserId", otpPendingUserId);

        otpVerificationDAO.markVerified(otp.getOtpId());

        req.getSession().removeAttribute("otpPendingUserId");
        req.getSession().removeAttribute("otpPendingEmail");
        req.getSession().removeAttribute("otpPurpose");
        resp.sendRedirect(req.getContextPath() + "/reset-password");
    }

    private void forwardWithError(HttpServletRequest req, HttpServletResponse resp, String error,
                                  String otpCode) throws ServletException, IOException {
        req.setAttribute("error", error);
        req.setAttribute("otp", otpCode);
        req.getRequestDispatcher("/authentication/otp-verification.jsp").forward(req, resp);
    }

    private boolean isValidOtpCode(String otp) {
        return otp != null && otp.matches("\\d{6}");
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }

}

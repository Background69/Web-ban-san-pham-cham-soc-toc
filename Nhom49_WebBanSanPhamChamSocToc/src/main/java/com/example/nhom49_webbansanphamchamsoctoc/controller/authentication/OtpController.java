package com.example.nhom49_webbansanphamchamsoctoc.controller.authentication;

import com.example.nhom49_webbansanphamchamsoctoc.dao.OtpVerificationDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.OtpVerification;
import com.example.nhom49_webbansanphamchamsoctoc.services.AuthenticationService;
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
    private final AuthenticationService authenticationService = new AuthenticationService();
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
        String purposeRaw = (String) req.getSession().getAttribute("otpPurpose");

        if (otpPendingUserId == null || purposeRaw == null || purposeRaw.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        OtpVerificationDAO.OtpPurpose otpPurpose;
        try {
            otpPurpose = OtpVerificationDAO.OtpPurpose.valueOf(purposeRaw);
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        String otpCode = trim(req.getParameter("otp"));
        if (!isValidOtpCode(otpCode)) {
            forwardWithError(req, resp, "OTP phải đủ 6 kí tự số.");
            return;
        }

        OtpVerification otp = otpVerificationDAO.findLatestOtpByUserId(otpPendingUserId, otpPurpose);
        if (otp == null) {
            forwardWithError(req, resp, "Mã OTP không hợp lệ.");
            return;
        }

        if (otp.getOtpExpiry() == null || otp.getOtpExpiry().toLocalDateTime().isBefore(LocalDateTime.now())) {
            forwardWithError(req, resp, "Mã OTP hết hạn sử dụng.");
            return;
        }

        if (otp.isVerified()) {
            forwardWithError(req, resp, "Mã OTP đã qua sử dụng rồi.");
            return;
        }

        if (otp.getAttempts() >= MAX_OTP_ATTEMPTS) {
            forwardWithError(req, resp, "Đã vượt quá số lần nhập OTP.");
            return;
        }

        if (!otp.getOtpCode().equals(otpCode)) {
            if (!otpVerificationDAO.incrementAttempts(otp.getOtpId())) {
                forwardWithError(req, resp, "Có lỗi xảy ra, vui lòng thử lại.");
                return;
            }

            int newAttempts = otp.getAttempts() + 1;
            if (newAttempts >= MAX_OTP_ATTEMPTS) {
                forwardWithError(req, resp, "OTP sai. Đã vượt quá số lần nhập.");
            } else {
                forwardWithError(req, resp, "OTP không đúng.");
            }
            return;
        }


        if (otpPurpose == OtpVerificationDAO.OtpPurpose.FORGOT_PASSWORD) {
            boolean markOtp = otpVerificationDAO.markVerified(otp.getOtpId());
            if (!markOtp) {
                forwardWithError(req, resp, "Có lỗi xảy ra khi xác nhận OTP, vui lòng thử lại");
                return;
            }

            req.getSession().setAttribute("otpVerifiedUserId", otpPendingUserId);

            req.getSession().removeAttribute("otpPendingUserId");
            req.getSession().removeAttribute("otpPendingEmail");
            req.getSession().removeAttribute("otpPurpose");
            req.getSession().removeAttribute("otpLastSentAt");


            resp.sendRedirect(req.getContextPath() + "/reset-password");
            return;
        }

        if (otpPurpose == OtpVerificationDAO.OtpPurpose.REGISTER) {
            boolean activated = authenticationService.setActiveStatus(otpPendingUserId, true);
            if (!activated) {
                forwardWithError(req, resp, "Không thể kích hoạt tài khoản");
                return;
            }

            boolean markOtp = otpVerificationDAO.markVerified(otp.getOtpId());
            if (!markOtp) {
                forwardWithError(req, resp, "Có lỗi xảy ra khi xác nhận OTP, vui lòng thử lại");
                return;
            }
            req.getSession().removeAttribute("otpPendingUserId");
            req.getSession().removeAttribute("otpPendingEmail");
            req.getSession().removeAttribute("otpPurpose");
            req.getSession().removeAttribute("otpLastSentAt");

            req.getSession().setAttribute("success", "Xác minh đăng ký thành công, vui lòng đăng nhập.");

            resp.sendRedirect(req.getContextPath() + "/auth/login");
        }
    }


    private void forwardWithError(HttpServletRequest req, HttpServletResponse resp, String error) throws ServletException, IOException {
        req.setAttribute("error", error);
        req.getRequestDispatcher("/authentication/otp-verification.jsp").forward(req, resp);
    }

    private boolean isValidOtpCode(String otp) {
        return otp != null && otp.matches("\\d{6}");
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }

}

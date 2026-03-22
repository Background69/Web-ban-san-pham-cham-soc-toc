package com.example.nhom49_webbansanphamchamsoctoc.controller.authentication;

import com.example.nhom49_webbansanphamchamsoctoc.dao.OtpVerificationDAO;
import com.example.nhom49_webbansanphamchamsoctoc.dao.PendingRegistrationDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.PendingRegistration;
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
    private final PendingRegistrationDAO pendingRegistrationDAO = new PendingRegistrationDAO();

    private static final int MAX_OTP_ATTEMPTS = 5;


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/authentication/otp-verification.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String purposeRaw = (String) req.getSession().getAttribute("otpPurpose");
        if (purposeRaw == null || purposeRaw.isBlank()) {
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

        if (otpPurpose == OtpVerificationDAO.OtpPurpose.REGISTER) {
            Integer pendingId = (Integer) req.getSession().getAttribute("otpPendingRegistrationId");
            if (pendingId == null) {
                resp.sendRedirect(req.getContextPath() + "/auth/register");
                return;
            }

            PendingRegistration pending = pendingRegistrationDAO.findById(pendingId);
            if (pending == null || pending.isVerified()) {
                forwardWithError(req, resp, "Phiên đăng ký không hợp lệ. Vui lòng đăng ký lại.");
                return;
            }

            if (pending.getOtpExpiry() == null || pending.getOtpExpiry().toLocalDateTime().isBefore(LocalDateTime.now())) {
                forwardWithError(req, resp, "Mã OTP hết hạn sử dụng.");
                return;
            }

            if (pending.getAttempts() >= MAX_OTP_ATTEMPTS) {
                forwardWithError(req, resp, "Đã vượt quá số lần nhập OTP.");
                return;
            }

            if (!pending.getOtpCode().equals(otpCode)) {
                pendingRegistrationDAO.incrementAttempts(pendingId);
                int newAttempts = pending.getAttempts() + 1;
                forwardWithError(req, resp, newAttempts >= MAX_OTP_ATTEMPTS
                        ? "OTP sai. Đã vượt quá số lần nhập."
                        : "OTP không đúng.");
                return;
            }

            int newUserId = pendingRegistrationDAO.createUserAndConsumePending(pendingId);
            if (newUserId <= 0) {
                forwardWithError(req, resp, "Không thể tạo tài khoản. Vui lòng thử lại.");
                return;
            }

            req.getSession().removeAttribute("otpPendingRegistrationId");
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

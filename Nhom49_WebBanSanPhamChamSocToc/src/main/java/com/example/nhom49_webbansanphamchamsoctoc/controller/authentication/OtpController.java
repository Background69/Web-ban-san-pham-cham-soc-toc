package com.example.nhom49_webbansanphamchamsoctoc.controller.authentication;

import com.example.nhom49_webbansanphamchamsoctoc.dao.OtpVerificationDAO;
import com.example.nhom49_webbansanphamchamsoctoc.dao.PendingRegistrationDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.OtpVerification;
import com.example.nhom49_webbansanphamchamsoctoc.model.PendingRegistration;
import com.example.nhom49_webbansanphamchamsoctoc.util.RedirectUtil;
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
    private final PendingRegistrationDAO pendingRegistrationDAO = new PendingRegistrationDAO();

    private static final int MAX_OTP_ATTEMPTS = 5;


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/authentication/otp-verification.jsp").forward(request, response);
    }

    /**
     * Xử lý xác nhận OTP cho cả hai trường hợp: quên mật khẩu và đăng ký tài khoản mới.
     * Mục đích OTP được xác định thông qua session, và luồng xử lý
     * sẽ khác nhau tùy vào mục đích đó. Sau khi xác nhận OTP thành công, sẽ chuyển hướng
     * đến trang đặt lại mật khẩu hoặc trang đăng nhập với thông báo thành công tương ứng.
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        OtpVerificationDAO.OtpPurpose otpPurpose = parseOtpPurpose(req, resp);
        if (otpPurpose == null) return;

        String otpCode = trim(req.getParameter("otp"));
        if (!isValidOtpCode(otpCode)) {
            forwardWithError(req, resp, "OTP phải đủ 6 kí tự số.");
            return;
        }

        switch (otpPurpose) {
            case FORGOT_PASSWORD -> handleForgotPasswordOtp(req, resp, otpCode);
            case REGISTER -> handleRegisterOtp(req, resp, otpCode);
            default -> resp.sendRedirect(req.getContextPath() + "/auth/login");
        }

    }

    private OtpVerificationDAO.OtpPurpose parseOtpPurpose(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        String purposeRaw = (String) req.getSession().getAttribute("otpPurpose");
        if (purposeRaw == null || purposeRaw.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return null;
        }

        try {
            return OtpVerificationDAO.OtpPurpose.valueOf(purposeRaw);
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return null;
        }
    }

    private void handleForgotPasswordOtp(HttpServletRequest req, HttpServletResponse resp, String otpCode)
            throws ServletException, IOException {

        Integer otpPendingUserId = (Integer) req.getSession().getAttribute("otpPendingUserId");
        if (otpPendingUserId == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/forgot-password");
            return;
        }

        OtpVerification otp = otpVerificationDAO.findLatestOtpByUserId(
                otpPendingUserId, OtpVerificationDAO.OtpPurpose.FORGOT_PASSWORD
        );

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
            otpVerificationDAO.incrementAttempts(otp.getOtpId());
            int newAttempts = otp.getAttempts() + 1;
            forwardWithError(req, resp, newAttempts >= MAX_OTP_ATTEMPTS
                    ? "OTP sai. Đã vượt quá số lần nhập."
                    : "OTP không đúng.");
            return;
        }

        boolean marked = otpVerificationDAO.markVerified(otp.getOtpId());
        if (!marked) {
            forwardWithError(req, resp, "Có lỗi xảy ra khi xác nhận OTP, vui lòng thử lại.");
            return;
        }

        req.getSession().setAttribute("otpVerifiedUserId", otpPendingUserId);
        clearOtpSession(req);

        resp.sendRedirect(req.getContextPath() + "/reset-password");
    }

    private void handleRegisterOtp(HttpServletRequest req, HttpServletResponse resp, String otpCode)
            throws ServletException, IOException {

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

        String redirectUrl = (String) req.getSession().getAttribute("registerRedirectUrl");

        req.getSession().removeAttribute("registerRedirectUrl");
        req.getSession().removeAttribute("otpPendingRegistrationId");
        clearOtpSession(req);

        req.getSession().setAttribute("success", "Xác minh đăng ký thành công.");

        String targetUrl = RedirectUtil.buildRedirectUrl(req, redirectUrl, "/");

        String separator = targetUrl.contains("?") ? "&" : "?";
        resp.sendRedirect(targetUrl + separator + "registerSuccess=true");
    }

    private void clearOtpSession(HttpServletRequest req) {
        req.getSession().removeAttribute("otpPendingUserId");
        req.getSession().removeAttribute("otpPendingEmail");
        req.getSession().removeAttribute("otpPurpose");
        req.getSession().removeAttribute("otpLastSentAt");
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

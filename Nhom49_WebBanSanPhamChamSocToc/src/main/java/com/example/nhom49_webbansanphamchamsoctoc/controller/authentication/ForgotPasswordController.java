package com.example.nhom49_webbansanphamchamsoctoc.controller.authentication;

import com.example.nhom49_webbansanphamchamsoctoc.dao.OtpVerificationDAO;
import com.example.nhom49_webbansanphamchamsoctoc.dao.UserDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import com.example.nhom49_webbansanphamchamsoctoc.services.EmailService;
import com.example.nhom49_webbansanphamchamsoctoc.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.concurrent.ThreadLocalRandom;

@WebServlet(name = "ForgotPasswordController", urlPatterns = {"/auth/forgot-password"})
public class ForgotPasswordController extends HttpServlet {

    private static final int OTP_EXPIRY_MINUTES = 15;
    private static final String FORGOT_PASSWORD_VIEW = "/authentication/forgot-password.jsp";

    private final UserDAO userDAO = new UserDAO();
    private final OtpVerificationDAO otpVerificationDAO = new OtpVerificationDAO();
    private EmailService emailService;

    @Override
    public void init() throws ServletException {
        try {
            emailService = new EmailService();
        } catch (RuntimeException ex) {
            emailService = null;
            log("EmailService chưa sẵn sàng: " + ex.getMessage(), ex);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        request.getRequestDispatcher(FORGOT_PASSWORD_VIEW)
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        String email = request.getParameter("email");
        email = email == null ? "" : email.trim();

        String commonMsg = "Nếu email tồn tại trong hệ thống, chúng tôi đã gửi mã OTP đặt lại mật khẩu.";

        if (emailService == null) {
            request.setAttribute("error", "Chức năng gửi OTP tạm thời chưa khả dụng. Vui lòng cấu hình email hệ thống rồi thử lại.");
            request.getRequestDispatcher(FORGOT_PASSWORD_VIEW).forward(request, response);
            return;
        }

        if (ValidationUtil.validateEmail(email) != null) {
            request.setAttribute("message", commonMsg);
            request.getRequestDispatcher(FORGOT_PASSWORD_VIEW).forward(request, response);
            return;
        }

        User user = userDAO.findByEmail(email);
        if (user != null) {
            String otpCode = generateOtpCode();
            Timestamp expiry = Timestamp.valueOf(LocalDateTime.now().plusMinutes(OTP_EXPIRY_MINUTES));

            otpVerificationDAO.createForgotPasswordOtp(user.getUserId(), otpCode, expiry);

            String resetLink = request.getScheme() + "://" + request.getServerName()
                    + ":" + request.getServerPort()
                    + request.getContextPath()
                    + "/reset-password?email=" + URLEncoder.encode(email, StandardCharsets.UTF_8)
                    + "&otp=" + URLEncoder.encode(otpCode, StandardCharsets.UTF_8);

            boolean sent = emailService.sendPasswordResetOtpEmail(email, otpCode, resetLink, OTP_EXPIRY_MINUTES);
            if (!sent) {
                request.setAttribute("error", "Không gửi được email. Vui lòng thử lại sau.");
            }
        }

        request.setAttribute("message", commonMsg);
        request.getRequestDispatcher(FORGOT_PASSWORD_VIEW)
                .forward(request, response);
    }

    private String generateOtpCode() {
        int value = ThreadLocalRandom.current().nextInt(100000, 1000000);
        return String.valueOf(value);
    }
}

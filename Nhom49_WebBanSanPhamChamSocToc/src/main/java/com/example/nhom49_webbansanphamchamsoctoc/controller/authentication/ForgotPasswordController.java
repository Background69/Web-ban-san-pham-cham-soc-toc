package com.example.nhom49_webbansanphamchamsoctoc.controller.authentication;

import com.example.nhom49_webbansanphamchamsoctoc.dao.OtpVerificationDAO;
import com.example.nhom49_webbansanphamchamsoctoc.dao.UserDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import com.example.nhom49_webbansanphamchamsoctoc.services.EmailService;
import com.example.nhom49_webbansanphamchamsoctoc.util.OtpUtil;
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

@WebServlet(name = "ForgotPasswordController", urlPatterns = {"/auth/forgot-password"})
public class ForgotPasswordController extends HttpServlet {

    private static final int OTP_EXPIRY_MINUTES = 15;

    private final UserDAO userDAO = new UserDAO();
    private final OtpVerificationDAO otpVerificationDAO = new OtpVerificationDAO();
    private EmailService emailService;

    @Override
    public void init() throws ServletException {
        emailService = new EmailService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/authentication/forgot-password.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String email = request.getParameter("email");
        email = (email != null) ? email.trim() : "";
        String commonMsg = "Neu email ton tai trong he thong, chung toi da gui ma OTP dat lai mat khau.";

        if (validateEmail(request, response, email, commonMsg)) return;

        User user = userDAO.findByEmail(email);
        if (user != null) {
            String otpCode = OtpUtil.otpGenerate(6);
            Timestamp expiry = Timestamp.valueOf(LocalDateTime.now().plusMinutes(OTP_EXPIRY_MINUTES));

            otpVerificationDAO.createForgotPasswordOtp(user.getUserId(), otpCode, expiry);

            String resetLink = request.getScheme() + "://" + request.getServerName()
                    + ":" + request.getServerPort()
                    + request.getContextPath()
                    + "/reset-password?email=" + URLEncoder.encode(email, StandardCharsets.UTF_8);

            boolean sent = emailService.sendPasswordResetOtpEmail(email, otpCode, resetLink, OTP_EXPIRY_MINUTES);
            if (!sent) {
                request.setAttribute("error", "Khong gui duoc email. Vui long thu lai sau.");
            }
        }

        request.setAttribute("message", commonMsg);
        request.getRequestDispatcher("/authentication/forgot-password.jsp")
                .forward(request, response);
    }

    private static boolean validateEmail(HttpServletRequest request, HttpServletResponse response, String email, String commonMsg) throws ServletException, IOException {
        if (ValidationUtil.validateEmail(email) != null) {
            request.setAttribute("message", commonMsg);
            request.getRequestDispatcher("/authentication/forgot-password.jsp").forward(request, response);
            return true;
        }
        return false;
    }


}

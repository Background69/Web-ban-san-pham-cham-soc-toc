package com.example.nhom49_webbansanphamchamsoctoc.controller.authentication;

import com.example.nhom49_webbansanphamchamsoctoc.dao.OtpVerificationDAO;
import com.example.nhom49_webbansanphamchamsoctoc.services.AuthenticationService;
import com.example.nhom49_webbansanphamchamsoctoc.services.EmailService;
import com.example.nhom49_webbansanphamchamsoctoc.util.OtpUtil;
import com.example.nhom49_webbansanphamchamsoctoc.util.PasswordUtil;
import com.example.nhom49_webbansanphamchamsoctoc.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;

@WebServlet(name = "RegisterController", urlPatterns = {"/auth/register"})
public class RegisterController extends HttpServlet {

    private AuthenticationService authService;
    private static final int OTP_EXPIRY_MINUTES = 15;

    private final OtpVerificationDAO otpVerificationDAO = new OtpVerificationDAO();
    private final EmailService emailService = new EmailService();

    @Override
    public void init() {
        authService = new AuthenticationService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (SessionUtil.isLoggedIn(request.getSession(false))) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        request.getRequestDispatcher("/authentication/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String fullname = request.getParameter("fullname");
        String username = request.getParameter("username");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");

        String confirmPassword = request.getParameter("confirmPassword");

        boolean validateUserInput = authService.validateUserInput(email, fullname, username, phone, password, confirmPassword);

        if (!validateUserInput) {
            request.setAttribute("error", authService.getLastError());
            request.getRequestDispatcher("/authentication/register.jsp").forward(request, response);
            return;
        }

        PasswordUtil.hashPassword(password);
        request.getSession(true).setAttribute("pendingReqEmail", email);
        request.getSession(true).setAttribute("pendingReqFullname", fullname);
        request.getSession(true).setAttribute("pendingReqUsername", username);
        request.getSession(true).setAttribute("pendingReqPhone", phone);
        request.getSession(true).setAttribute("pendingReqPassword", password);

        String otpCode = OtpUtil.otpGenerate(6);
        java.sql.Timestamp expiry = Timestamp.valueOf(LocalDateTime.now().plusMinutes(OTP_EXPIRY_MINUTES));

        int otpId = otpVerificationDAO.createOtp(email, otpCode, OtpVerificationDAO.OtpPurpose.REGISTER, expiry);
        if (otpId == -1) {
            request.setAttribute("error", "Có lỗi xảy ra, vui lòng thử lại.");
            request.getRequestDispatcher("/authentication/register.jsp").forward(request, response);
            return;
        }

        request.getSession().setAttribute("otpPurpose", "REGISTER");
        request.getSession().setAttribute("otpPendingEmail", email);

        String verifyOtpLink = request.getScheme() + "://" + request.getServerName()
                + ":" + request.getServerPort()
                + request.getContextPath()
                + "/auth/verify-otp";
        boolean sent = emailService.sendRegisterOtpEmail(email, otpCode, verifyOtpLink, OTP_EXPIRY_MINUTES);


        if (!sent) {
            request.setAttribute("error", "không gửi được Emai. vui lòng gửi lại sau");
            request.getRequestDispatcher("/authentication/otp-verification.jsp").forward(request, response);
            return;
        } else {
            request.getSession().setAttribute("otpLastSentAt", System.currentTimeMillis());
        }


        request.getSession().setAttribute("success", "Tài khoản đã được kích hoạt. Vui lòng đăng nhập");
        response.sendRedirect(request.getContextPath() + "/auth/login");

    }
}

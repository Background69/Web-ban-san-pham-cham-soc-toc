package com.example.nhom49_webbansanphamchamsoctoc.controller.authentication;

import com.example.nhom49_webbansanphamchamsoctoc.dao.PendingRegistrationDAO;
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

    private final PendingRegistrationDAO pendingRegistrationDAO = new PendingRegistrationDAO();
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

        String email = trim(request.getParameter("email"));
        String fullname = trim(request.getParameter("fullname"));
        String username = trim(request.getParameter("username"));
        String phone = trim(request.getParameter("phone"));
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        boolean ok = authService.validateUserInput(email, fullname, username, phone, password, confirmPassword);
        if (!ok) {
            request.setAttribute("error", authService.getLastError());
            request.setAttribute("email", email);
            request.setAttribute("fullname", fullname);
            request.setAttribute("username", username);
            request.setAttribute("phone", phone);
            request.getRequestDispatcher("/authentication/register.jsp").forward(request, response);
            return;
        }

        String passwordHash = PasswordUtil.hashPassword(password);
        String otpCode = OtpUtil.otpGenerate(6);
        java.sql.Timestamp expiry = Timestamp.valueOf(LocalDateTime.now().plusMinutes(OTP_EXPIRY_MINUTES));

        int pendingId = pendingRegistrationDAO.upsertPending(
                email, username, fullname, phone, passwordHash, otpCode, expiry
        );
        if (pendingId <= 0) {
            request.setAttribute("error", "Có lỗi xảy ra, vui lòng thử lại.");
            request.getRequestDispatcher("/authentication/register.jsp").forward(request, response);
            return;
        }

        String verifyOtpLink = request.getScheme() + "://" + request.getServerName()
                + ":" + request.getServerPort()
                + request.getContextPath()
                + "/auth/verify-otp";

        boolean sent = emailService.sendRegisterOtpEmail(email, otpCode, verifyOtpLink, OTP_EXPIRY_MINUTES);

        request.getSession().setAttribute("otpPurpose", "REGISTER");
        request.getSession().setAttribute("otpPendingRegistrationId", pendingId);
        request.getSession().setAttribute("otpPendingEmail", email);

        if (!sent) {
            request.setAttribute("error", "Không gửi được email OTP. Vui lòng thử lại.");
            request.getRequestDispatcher("/authentication/otp-verification.jsp").forward(request, response);
            return;
        }

        request.getSession().setAttribute("otpLastSentAt", System.currentTimeMillis());
        response.sendRedirect(request.getContextPath() + "/auth/verify-otp");
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }

}

package com.example.nhom49_webbansanphamchamsoctoc.controller.authentication;

import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import com.example.nhom49_webbansanphamchamsoctoc.services.AuthenticationService;
import com.example.nhom49_webbansanphamchamsoctoc.util.SessionUtil;
import com.example.nhom49_webbansanphamchamsoctoc.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "VerifyRegistrationController", urlPatterns = {"/auth/verify-registration"})
public class VerifyRegistrationController extends HttpServlet {

    private AuthenticationService authService;

    @Override
    public void init() throws ServletException {
        authService = new AuthenticationService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (SessionUtil.isLoggedIn(request.getSession(false))) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        String email = trim(request.getParameter("email"));
        request.setAttribute("email", email);
        request.getRequestDispatcher("/authentication/verify-registration.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action = trim(request.getParameter("action"));
        String email = trim(request.getParameter("email"));

        if (ValidationUtil.isEmpty(email)) {
            request.setAttribute("error", "Email khong duoc de trong");
            request.getRequestDispatcher("/authentication/verify-registration.jsp").forward(request, response);
            return;
        }

        if ("resend".equalsIgnoreCase(action)) {
            boolean resent = authService.resendRegistrationOtp(email);
            if (resent) {
                request.setAttribute("message", "Da gui lai OTP. Vui long kiem tra email");
            } else {
                request.setAttribute("error", authService.getLastError());
            }
            request.setAttribute("email", email);
            request.getRequestDispatcher("/authentication/verify-registration.jsp").forward(request, response);
            return;
        }

        String otpCode = trim(request.getParameter("otp"));
        User verifiedUser = authService.verifyPendingRegistration(email, otpCode);
        if (verifiedUser != null) {
            request.getSession(true).setAttribute("success", "Dang ky thanh cong. Vui long dang nhap");
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        request.setAttribute("error", authService.getLastError());
        request.setAttribute("email", email);
        request.setAttribute("otp", otpCode);
        request.getRequestDispatcher("/authentication/verify-registration.jsp").forward(request, response);
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }
}

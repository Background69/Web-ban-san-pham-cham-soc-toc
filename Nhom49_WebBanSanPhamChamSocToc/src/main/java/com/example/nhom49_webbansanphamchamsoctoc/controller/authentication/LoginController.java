package com.example.nhom49_webbansanphamchamsoctoc.controller.authentication;

import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import com.example.nhom49_webbansanphamchamsoctoc.services.AuthenticationService;
import com.example.nhom49_webbansanphamchamsoctoc.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "LoginController", value = "/auth/login")
public class LoginController extends HttpServlet {

    private AuthenticationService authService;

    @Override
    public void init() {
        authService = new AuthenticationService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/authentication/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String redirect = request.getParameter("redirect");

        email = email == null ? "" : email.trim();
        password = password == null ? "" : password;

        if (email.trim().isEmpty() || password.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ Email/Tên đăng nhập và Mật khẩu");
            request.setAttribute("email", email);
            request.setAttribute("redirect", redirect);
            request.getRequestDispatcher("/authentication/login.jsp").forward(request, response);
            return;
        }

        User user = authService.login(email, password);

        if (user == null) {
            request.setAttribute("error", authService.getLastError());
            request.setAttribute("showPasswordSetupLink", authService.isGoogleLinkedNoPasswordError());
            request.setAttribute("email", email);
            request.setAttribute("redirect", redirect);
            request.getRequestDispatcher("/authentication/login.jsp").forward(request, response);
            return;
        }

        if (!user.isActive()) {
            request.setAttribute("error", "Tài khoản đã bị khóa");
            request.getRequestDispatcher("/authentication/login.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession(true);
        SessionUtil.setCurrentUser(session, user);
        session.setMaxInactiveInterval(30 * 60);
        if ("Admin".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }
        String safeRedirect = normalizeRedirect(redirect);
        if (safeRedirect != null) {
            response.sendRedirect(request.getContextPath() + safeRedirect);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/");
    }

    private String normalizeRedirect(String redirect) {
        if (redirect == null) {
            return null;
        }
        String trimmed = redirect.trim();
        if (trimmed.isEmpty()) {
            return null;
        }
        if (trimmed.startsWith("http://") || trimmed.startsWith("https://")) {
            return null;
        }
        return trimmed.startsWith("/") ? trimmed : "/" + trimmed;
    }
}

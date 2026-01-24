package com.example.nhom49_webbansanphamchamsoctoc.controller.authentication;

import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import com.example.nhom49_webbansanphamchamsoctoc.services.AuthenticationService;
import com.example.nhom49_webbansanphamchamsoctoc.services.EmailService;
import com.example.nhom49_webbansanphamchamsoctoc.util.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Servlet xử lý đăng ký tài khoản
 * GET: Hiển thị form đăng ký
 * POST: Xử lý đăng ký
 */
@WebServlet(name = "RegisterController", urlPatterns = {"/register"})
public class RegisterController extends HttpServlet {

    private AuthenticationService authService;
    private EmailService emailService;

    @Override
    public void init() throws ServletException {
        authService = new AuthenticationService();
        emailService = new EmailService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (SessionUtil.isLoggedIn(request.getSession(false))) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        request.getRequestDispatcher("/authentication/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String username = request.getParameter("username");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        User user = authService.register(email, username, phone, password, confirmPassword);
        if (user == null) {
            String errorMessage = authService.getLastError();
            request.setAttribute("error", errorMessage != null ? errorMessage : "Dang ky that bai");
            request.setAttribute("email", email);
            request.setAttribute("username", username);
            request.getRequestDispatcher("/authentication/register.jsp").forward(request, response);
            return;
        }
        HttpSession session = request.getSession(true);
        request.changeSessionId();
        SessionUtil.setCurrentUser(session, user);
        SessionUtil.setSuccessMessage(session, "Registration successful.");
        response.sendRedirect(request.getContextPath() + "/");
    }
}

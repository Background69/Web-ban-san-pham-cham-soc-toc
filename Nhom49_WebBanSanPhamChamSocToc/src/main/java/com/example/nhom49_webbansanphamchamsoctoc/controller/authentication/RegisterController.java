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

        request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
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

        User newUser = authService.register(email, username, phone, password, confirmPassword);


        if (newUser != null) {
            // Gửi email xác minh
            String verifyLink = request.getRequestURL().toString().replace(request.getServletPath(), "")
                    + "/verify?token=" + newUser.getVerificationToken();
            emailService.sendVerificationEmail(email, verifyLink);

            SessionUtil.setSuccessMessage(request.getSession(), "Đăng ký thành công! Vui lòng kiểm tra email để xác minh tài khoản.");
            response.sendRedirect(request.getContextPath() + "/login");
        } else {
            request.setAttribute("error", authService.getLastError());
            request.setAttribute("email", email);
            request.setAttribute("username", username);
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
        }
    }
}

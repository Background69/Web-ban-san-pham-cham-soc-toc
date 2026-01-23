package com.example.nhom49_webbansanphamchamsoctoc.controller.authentication;

import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import com.example.nhom49_webbansanphamchamsoctoc.services.AuthenticationService;
import com.example.nhom49_webbansanphamchamsoctoc.util.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet(name = "RegisterController", urlPatterns = {"/auth/register"})
public class RegisterController extends HttpServlet {

    private AuthenticationService authService;

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

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String username = request.getParameter("username"); // ✅ phải là username
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        AuthenticationService.RegisterResult result =
                authService.register(email, username, phone, password, confirmPassword);

        if (result.success()) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        request.setAttribute("error", result.message());
        request.setAttribute("email", email);
        request.setAttribute("username", username);
        request.setAttribute("phone", phone);

        request.getRequestDispatcher("/authentication/register.jsp").forward(request, response);
    }
}

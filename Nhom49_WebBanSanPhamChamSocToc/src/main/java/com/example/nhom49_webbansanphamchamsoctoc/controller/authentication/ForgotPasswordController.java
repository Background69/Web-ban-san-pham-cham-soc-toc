package com.example.nhom49_webbansanphamchamsoctoc.controller.authentication;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "ForgotPassword", value = "/ForgotPassword")
public class ForgotPasswordController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/views/authentication/forgot-password.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");

        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập email.");
            request.getRequestDispatcher("/views/authentication/forgot-password.jsp")
                    .forward(request, response);
            return;
        }

        boolean emailExists = checkEmailExists(email);

        if (!emailExists) {
            request.setAttribute("error", "Email không tồn tại trong hệ thống.");
        } else {
            request.setAttribute("message", "Link đặt lại mật khẩu đã được gửi về email.");
        }

        request.getRequestDispatcher("/views/authentication/forgot-password.jsp")
                .forward(request, response);
    }

    private boolean checkEmailExists(String email) {
        return email.equalsIgnoreCase("test@gmail.com");
    }
}


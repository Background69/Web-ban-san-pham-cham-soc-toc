package com.example.nhom49_webbansanphamchamsoctoc.controller.authentication;

import com.example.nhom49_webbansanphamchamsoctoc.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/ForgotPassword")
public class ForgotPasswordController extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

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

        boolean emailExists = userDAO.existsByEmail(email);

        if (!emailExists) {
            request.setAttribute("error", "Email không tồn tại trong hệ thống.");
        } else {
            // Tạm thời chỉ thông báo – sau này mới gửi mail thật
            request.setAttribute("message", "Link đặt lại mật khẩu đã được gửi về email.");
        }

        request.getRequestDispatcher("/views/authentication/forgot-password.jsp")
                .forward(request, response);
    }
}

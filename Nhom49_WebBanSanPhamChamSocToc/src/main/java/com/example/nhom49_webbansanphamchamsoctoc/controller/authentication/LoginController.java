package com.example.nhom49_webbansanphamchamsoctoc.controller.authentication;

import com.example.nhom49_webbansanphamchamsoctoc.dao.UserDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet(name = "LoginController", value = "/Login")
public class LoginController extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    // Hiển thị trang login
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/views/authentication/login.jsp")
                .forward(request, response);
    }

    // Xử lý đăng nhập
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // 1️⃣ Validate dữ liệu
        if (email == null || password == null ||
                email.trim().isEmpty() || password.trim().isEmpty()) {

            request.setAttribute("error", "Vui lòng nhập đầy đủ Email và Mật khẩu");
            request.getRequestDispatcher("/views/authentication/login.jsp")
                    .forward(request, response);
            return;
        }

        // 2️⃣ Xác thực người dùng
        User user = userDAO.authenticate(email, password);

        if (user == null) {
            request.setAttribute("error", "Email hoặc mật khẩu không đúng");
            request.getRequestDispatcher("/views/authentication/login.jsp")
                    .forward(request, response);
            return;
        }

        // 3️⃣ Kiểm tra trạng thái tài khoản
        if (!user.isActive()) {
            request.setAttribute("error", "Tài khoản đã bị khóa");
            request.getRequestDispatcher("/views/authentication/login.jsp")
                    .forward(request, response);
            return;
        }

        // 4️⃣ Lưu session
        HttpSession session = request.getSession(true);
        session.setAttribute("currentUser", user);
        session.setMaxInactiveInterval(30 * 60); // 30 phút

        // 5️⃣ Điều hướng theo role
        if ("Admin".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/Admin/Dashboard");
        } else {
            response.sendRedirect(request.getContextPath() + "/Home");
        }
    }
}

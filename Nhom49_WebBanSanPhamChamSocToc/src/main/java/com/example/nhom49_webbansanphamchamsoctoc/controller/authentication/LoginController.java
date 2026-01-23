package com.example.nhom49_webbansanphamchamsoctoc.controller.authentication;

import com.example.nhom49_webbansanphamchamsoctoc.dao.UserDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet(name = "LoginController", value = "/auth/login")
public class LoginController extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/authentication/login.jsp")
                .forward(request, response);
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // DEBUG: đảm bảo request có vào doPost
        System.out.println("✅ HIT /auth/login doPost | email=" + email);

        // 1) Validate dữ liệu
        if (email == null || password == null ||
                email.trim().isEmpty() || password.trim().isEmpty()) {

            request.setAttribute("error", "Vui lòng nhập đầy đủ Email và Mật khẩu");
            request.getRequestDispatcher("/views/authentication/login.jsp")
                    .forward(request, response);
            return;
        }

        // 2) Xác thực người dùng (chỗ này mới đụng DB)
        User user = userDAO.authenticate(email.trim(), password);

        // DEBUG: xem authenticate có ra user không
        System.out.println("AUTH RESULT = " + (user != null));

        if (user == null) {
            request.setAttribute("error", "Email hoặc mật khẩu không đúng");
            request.getRequestDispatcher("/views/authentication/login.jsp")
                    .forward(request, response);
            return;
        }

        // 3) Kiểm tra trạng thái tài khoản
        if (!user.isActive()) {
            request.setAttribute("error", "Tài khoản đã bị khóa");
            request.getRequestDispatcher("/views/authentication/login.jsp")
                    .forward(request, response);
            return;
        }

        // 4) Lưu session
        HttpSession session = request.getSession(true);
        session.setAttribute("currentUser", user);
        session.setMaxInactiveInterval(30 * 60);

        // 5) Điều hướng sau đăng nhập (THÊM return để chắc chắn redirect chạy)
        if ("Admin".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/Admin/Dashboard");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
}

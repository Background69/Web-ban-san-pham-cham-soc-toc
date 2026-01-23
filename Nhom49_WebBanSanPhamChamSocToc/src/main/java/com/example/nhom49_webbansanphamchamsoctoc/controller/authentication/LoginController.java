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

        System.out.println("✅ HIT /auth/login doPost | email=" + email);

        if (email == null || password == null ||
                email.trim().isEmpty() || password.trim().isEmpty()) {

            request.setAttribute("error", "Vui lòng nhập đầy đủ Email và Mật khẩu");
            request.getRequestDispatcher("/views/authentication/login.jsp")
                    .forward(request, response);
            return;
        }

        User user = userDAO.authenticate(email.trim(), password);

        System.out.println("AUTH RESULT = " + (user != null));

        if (user == null) {
            request.setAttribute("error", "Email hoặc mật khẩu không đúng");
            request.getRequestDispatcher("/views/authentication/login.jsp")
                    .forward(request, response);
            return;
        }

        if (!user.isActive()) {
            request.setAttribute("error", "Tài khoản đã bị khóa");
            request.getRequestDispatcher("/views/authentication/login.jsp")
                    .forward(request, response);
            return;
        }

        HttpSession session = request.getSession(true);
        session.setAttribute("currentUser", user);
        session.setMaxInactiveInterval(30 * 60);

        if ("Admin".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/Admin/Dashboard");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
}

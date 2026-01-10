package com.example.nhom49_webbansanphamchamsoctoc.controller.authentication;

import com.example.nhom49_webbansanphamchamsoctoc.dao.UserDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet(name = "Register", value = "/Register")
public class RegisterController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirm = request.getParameter("confirm");
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");

        if (email == null || password == null || confirm == null ||
                name == null || phone == null ||
                email.isEmpty() || password.isEmpty() ||
                confirm.isEmpty() || name.isEmpty() || phone.isEmpty()) {

            request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin!");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirm)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp!");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        try {
            UserDAO userDAO = new UserDAO();

            if (userDAO.isEmailExist(email)) {
                request.setAttribute("error", "Email đã tồn tại!");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }

            User user = new User();
            user.setEmail(email);
            user.setPassword(password);
            user.setFullName(name);
            user.setPhone(phone);
            user.setRole("USER");

            int userId = userDAO.insert(user);

            if (userId > 0) {
                response.sendRedirect("login.jsp");
            } else {
                request.setAttribute("error", "Đăng ký thất bại!");
                request.getRequestDispatcher("register.jsp").forward(request, response);
            }


        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống!");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
}

package com.example.nhom49_webbansanphamchamsoctoc.controller.admin;

import com.example.nhom49_webbansanphamchamsoctoc.dao.UserDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "UserManagementController", value = "/UserManagementController")
public class UserManagementController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        UserDAO userDAO = new UserDAO();
        //Nếu chưa đăng nhập chuyển sang trang Login
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        User currentUser = (User) session.getAttribute("currentUser");
        //Check có phải role Admin hay không
        if (!"Admin".equalsIgnoreCase(currentUser.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Không có quyeefn truy cập");
            return;
        }
        List<User> users = userDAO.findAll();
        request.setAttribute("user", users);
        request.getRequestDispatcher("view/admin/users")
                .forward(request, response);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
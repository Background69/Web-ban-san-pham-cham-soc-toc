package com.example.nhom49_webbansanphamchamsoctoc.controller.admin;

import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import com.example.nhom49_webbansanphamchamsoctoc.services.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "UserManagementController", value = "/admin/users")
public class UserManagementController extends HttpServlet {

    private UserService userService;

    @Override
    public void init() {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("detail".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            User user = userService.getUserById(id);
            request.setAttribute("user", user);
            request.getRequestDispatcher("/admin/user/detail.jsp")
                    .forward(request, response);
            return;
        }

        List<User> users = userService.getAllUsers();
        request.setAttribute("users", users);
        request.getRequestDispatcher("/admin/users/list.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }

        if ("update-profile".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));

            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String role = request.getParameter("role");

            User u = new User();
            u.setUserId(id);
            u.setUsername(username);
            u.setEmail(email);
            u.setPhone(phone);
            u.setRole(role);

            userService.updateProfile(u);

            response.sendRedirect(request.getContextPath() + "/admin/users?action=detail&id=" + id);
            return;
        }

        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            userService.toggleUserActive(id);
            response.sendRedirect(request.getContextPath() + "/admin/users");
        }
    }
}

package com.example.nhom49_webbansanphamchamsoctoc.controller.admin;

import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import com.example.nhom49_webbansanphamchamsoctoc.services.UserService;
import com.example.nhom49_webbansanphamchamsoctoc.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import com.google.gson.Gson;

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
            Integer id = ValidationUtil.parseIntSafe(request.getParameter("id"));
            if (id == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid ID");
                return;
            }
            User user = userService.getUserById(id);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            String json = new Gson().toJson(user);
            response.getWriter().write(json);
            return;
        }

        List<User> users = userService.getAllUsers();
        request.setAttribute("users", users);
        request.getRequestDispatcher("/admin/user/list.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }

        if ("update-profile".equals(action)) {
            Integer id = ValidationUtil.parseIntSafe(request.getParameter("id"));
            if (id == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid ID");
                return;
            }

            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String role = request.getParameter("role");

            User existing = userService.getUserById(id);
            if (existing == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "User not found");
                return;
            }

            existing.setUsername(username);
            existing.setEmail(email);
            existing.setPhone(phone);
            existing.setRole(role);

            userService.updateProfile(existing);

            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }

        if ("toggle-status".equals(action)) {
            Integer id = ValidationUtil.parseIntSafe(request.getParameter("id"));
            if (id == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid ID");
                return;
            }
            userService.toggleUserActive(id);
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }
    }
}

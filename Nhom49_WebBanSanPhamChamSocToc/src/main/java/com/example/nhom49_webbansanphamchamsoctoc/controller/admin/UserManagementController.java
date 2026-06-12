package com.example.nhom49_webbansanphamchamsoctoc.controller.admin;

import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import com.example.nhom49_webbansanphamchamsoctoc.services.OrderService;
import com.example.nhom49_webbansanphamchamsoctoc.services.UserService;
import com.example.nhom49_webbansanphamchamsoctoc.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import com.google.gson.Gson;

@WebServlet(name = "UserManagementController", value = "/admin/users")
public class UserManagementController extends HttpServlet {

    private UserService userService;
    private OrderService orderService;

    @Override
    public void init() {
        userService = new UserService();
        orderService = new OrderService();
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
            Map<String, Object> result = new HashMap<>();
            result.put("userId", user.getUserId());
            result.put("email", user.getEmail());
            result.put("username", user.getUsername());
            result.put("fullName", user.getFullName());
            result.put("phone", user.getPhone());
            result.put("avatar", user.getAvatar());
            result.put("role", user.getRole());
            result.put("isActive", user.isActive());
            result.put("authProvider", user.getAuthProvider());
            result.put("createdAt", user.getCreatedAt() != null ? user.getCreatedAt().getTime() : null);
            result.put("updatedAt", user.getUpdatedAt() != null ? user.getUpdatedAt().getTime() : null);

            BigDecimal totalSpending = orderService.getTotalSpendingByUser(id);
            int totalOrders = orderService.countOrdersByUser(id);
            Map<String, Integer> statusCounts = orderService.getOrderCountsByStatus(id);
            int cancelledOrders = statusCounts.getOrDefault("cancelled", 0);

            result.put("totalSpending", totalSpending);
            result.put("totalOrders", totalOrders);
            result.put("cancelledOrders", cancelledOrders);

            String json = new Gson().toJson(result);
            response.getWriter().write(json);
            return;
        }

        List<User> users = userService.getAllUsers();

        int totalUsers = users.size();
        int staffUsers = (int) users.stream().filter(this::isPrivilegedRole).count();
        int customerUsers = totalUsers - staffUsers;
        int lockedUsers = (int) users.stream().filter(u -> !u.isActive()).count();

        java.util.Calendar cal = java.util.Calendar.getInstance();
        cal.set(java.util.Calendar.DAY_OF_MONTH, 1);
        cal.set(java.util.Calendar.HOUR_OF_DAY, 0);
        cal.set(java.util.Calendar.MINUTE, 0);
        cal.set(java.util.Calendar.SECOND, 0);
        cal.set(java.util.Calendar.MILLISECOND, 0);
        java.util.Date startOfMonth = cal.getTime();

        int newUsersThisMonth = (int) users.stream()
                .filter(u -> u.getCreatedAt() != null && u.getCreatedAt().after(startOfMonth))
                .count();

        request.setAttribute("users", users);
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("customerUsers", customerUsers);
        request.setAttribute("staffUsers", staffUsers);
        request.setAttribute("newUsersThisMonth", newUsersThisMonth);
        request.setAttribute("lockedUsers", lockedUsers);
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
    private boolean isPrivilegedRole(User user) {
        if (user == null || user.getRole() == null) {
            return false;
        }
        String role = user.getRole().trim();
        return "Admin".equalsIgnoreCase(role)
                || "Staff".equalsIgnoreCase(role)
                || "Nhân viên".equalsIgnoreCase(role);
    }
}

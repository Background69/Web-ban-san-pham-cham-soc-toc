package com.example.nhom49_webbansanphamchamsoctoc.controller.admin;

import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import com.example.nhom49_webbansanphamchamsoctoc.model.UserStatusHistory;
import com.example.nhom49_webbansanphamchamsoctoc.services.OrderService;
import com.example.nhom49_webbansanphamchamsoctoc.services.UserService;
import com.example.nhom49_webbansanphamchamsoctoc.services.UserStatusHistoryService;
import com.example.nhom49_webbansanphamchamsoctoc.util.SessionUtil;
import com.example.nhom49_webbansanphamchamsoctoc.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import com.google.gson.Gson;

@WebServlet(name = "UserManagementController", value = "/admin/users")
public class UserManagementController extends HttpServlet {

    private static final String STATUS_ACTION_LOCK = "lock";
    private static final String STATUS_ACTION_UNLOCK = "unlock";
    private static final Set<String> LOCK_REASON_CODES = Set.of(
            "POLICY_VIOLATION",
            "SUSPICIOUS_ACTIVITY",
            "ORDER_ABUSE",
            "CUSTOMER_REQUEST",
            "OTHER"
    );
    private static final Set<String> UNLOCK_REASON_CODES = Set.of(
            "VERIFIED_SAFE",
            "ISSUE_RESOLVED",
            "CUSTOMER_REQUEST_RESOLVED",
            "OTHER"
    );

    private UserService userService;
    private UserStatusHistoryService userStatusHistoryService;
    private OrderService orderService;

    @Override
    public void init() {
        userService = new UserService();
        userStatusHistoryService = new UserStatusHistoryService();
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
            if (user == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "User not found");
                return;
            }
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
            result.put("statusHistory", buildStatusHistoryPayload(id));

            String json = new Gson().toJson(result);
            response.getWriter().write(json);
            return;
        }

        HttpSession session = request.getSession(false);
        request.setAttribute("success", SessionUtil.getAndClearSuccessMessage(session));
        request.setAttribute("error", SessionUtil.getAndClearErrorMessage(session));

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
            redirectWithError(request, response, "Thiếu thao tác cần xử lý.");
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
            handleToggleStatus(request, response);
            return;
        }
        redirectWithError(request, response, "Thao tác không hợp lệ.");
    }

    private void handleToggleStatus(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Integer id = ValidationUtil.parseIntSafe(request.getParameter("id"));
        if (id == null) {
            redirectWithError(request, response, "Thiếu mã tài khoản cần xử lý.");
            return;
        }
        String statusAction = trimToNull(request.getParameter("statusAction"));
        if (statusAction != null) {
            statusAction = statusAction.toLowerCase();
        }
        if (!STATUS_ACTION_LOCK.equals(statusAction) && !STATUS_ACTION_UNLOCK.equals(statusAction)) {
            redirectWithError(request, response, "Thao tác khóa/mở tài khoản không hợp lệ.");
            return;
        }
        String reasonCode = trimToNull(request.getParameter("reasonCode"));
        if (reasonCode == null) {
            redirectWithError(request, response, "Vui lòng chọn lý do xử lý tài khoản.");
            return;
        }
        reasonCode = reasonCode.toUpperCase();
        if (!isAllowedReason(statusAction, reasonCode)) {
            redirectWithError(request, response, "Lý do xử lý tài khoản không hợp lệ.");
            return;
        }
        String reasonDetail = trimToNull(request.getParameter("reasonDetail"));
        if ("OTHER".equals(reasonCode) && (reasonDetail == null || reasonDetail.length() < 5)) {
            redirectWithError(request, response, "Vui lòng nhập ghi chú tối thiểu 5 ký tự khi chọn lý do khác.");
            return;
        }
        User targetUser = userService.getUserById(id);
        if (targetUser == null) {
            redirectWithError(request, response, "Không tìm thấy tài khoản người dùng.");
            return;
        }
        if (STATUS_ACTION_LOCK.equals(statusAction)) {
            User currentUser = SessionUtil.getCurrentUser(request.getSession(false));
            if (currentUser != null && currentUser.getUserId() == targetUser.getUserId()) {
                redirectWithError(request, response, "Không thể tự khóa tài khoản Admin đang đăng nhập.");
                return;
            }
            if (isAdminRole(targetUser)) {
                redirectWithError(request, response, "Không thể khóa tài khoản Admin.");
                return;
            }
        }
        boolean targetActiveStatus = STATUS_ACTION_UNLOCK.equals(statusAction);
        if (targetUser.isActive() == targetActiveStatus) {
            redirectWithError(request, response, "Trạng thái tài khoản đã được cập nhật trước đó.");
            return;
        }
        String historyAction = targetActiveStatus ? "UNLOCK" : "LOCK";
        boolean updated = userService.setUserActiveStatusWithHistory(
                targetUser,
                targetActiveStatus,
                historyAction,
                reasonCode,
                reasonDetail
        );
        if (!updated) {
            String error = userService.getLastError();
            redirectWithError(request, response,
                    error != null ? error : "Không thể xử lý trạng thái tài khoản.");
            return;
        }
        String message = targetActiveStatus
                ? "Đã mở khóa tài khoản " + getDisplayName(targetUser) + "."
                : "Đã tạm khóa tài khoản " + getDisplayName(targetUser) + ".";
        redirectWithSuccess(request, response, message);
    }

    private List<Map<String, Object>> buildStatusHistoryPayload(int userId) {
        List<Map<String, Object>> payload = new ArrayList<>();
        List<UserStatusHistory> histories = userStatusHistoryService.findByUserId(userId);
        for (UserStatusHistory history : histories) {
            Map<String, Object> item = new HashMap<>();
            item.put("action", history.getAction());
            item.put("reasonCode", history.getReasonCode());
            item.put("reasonDetail", history.getReasonDetail());
            item.put("createdAt", history.getCreatedAt() != null
                    ? history.getCreatedAt().toLocalDateTime().toString()
                    : null);
            payload.add(item);
        }
        return payload;
    }

    private boolean isAllowedReason(String statusAction, String reasonCode) {
        if (STATUS_ACTION_LOCK.equals(statusAction)) {
            return LOCK_REASON_CODES.contains(reasonCode);
        }
        return UNLOCK_REASON_CODES.contains(reasonCode);
    }

    private String trimToNull(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

    private String getDisplayName(User user) {
        if (user.getFullName() != null && !user.getFullName().isBlank()) {
            return user.getFullName();
        }
        if (user.getUsername() != null && !user.getUsername().isBlank()) {
            return user.getUsername();
        }
        return "#U" + user.getUserId();
    }

    private void redirectWithSuccess(HttpServletRequest request, HttpServletResponse response, String message)
            throws IOException {
        SessionUtil.setSuccessMessage(request.getSession(), message);
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }

    private void redirectWithError(HttpServletRequest request, HttpServletResponse response, String message)
            throws IOException {
        SessionUtil.setErrorMessage(request.getSession(), message);
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }

    private boolean isAdminRole(User user) {
        if (user == null || user.getRole() == null) {
            return false;
        }
        String role = user.getRole().trim();
        return "Admin".equalsIgnoreCase(role);
    }
}

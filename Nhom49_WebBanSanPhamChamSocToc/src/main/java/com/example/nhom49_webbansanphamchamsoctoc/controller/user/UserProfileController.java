package com.example.nhom49_webbansanphamchamsoctoc.controller.user;

import com.example.nhom49_webbansanphamchamsoctoc.model.Order;
import com.example.nhom49_webbansanphamchamsoctoc.model.ShippingAddress;
import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import com.example.nhom49_webbansanphamchamsoctoc.services.OrderService;
import com.example.nhom49_webbansanphamchamsoctoc.services.ProfileService;
import com.example.nhom49_webbansanphamchamsoctoc.services.ReviewService;
import com.example.nhom49_webbansanphamchamsoctoc.services.ShippingService;
import com.example.nhom49_webbansanphamchamsoctoc.util.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

@WebServlet(name = "UserProfileController", urlPatterns = { "/profile", "/profile/*" })
public class UserProfileController extends HttpServlet {

    private static final List<String> ORDER_STATUSES = List.of(
            "pending", "confirmed", "shipping", "completed", "cancelled");

    private ProfileService profileService;
    private ShippingService shippingService;
    private OrderService orderService;
    private ReviewService reviewService;

    @Override
    public void init() throws ServletException {
        super.init();
        this.profileService = new ProfileService();
        this.shippingService = new ShippingService();
        this.orderService = new OrderService();
        this.reviewService = new ReviewService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = SessionUtil.getCurrentUser(session);

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login?redirect=/profile");
            return;
        }

        String pathInfo = request.getPathInfo();
        request.setAttribute("user", currentUser);

        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/overview")) {
            // Profile Overview - trang tổng quan mới
            showProfileOverview(request, response, currentUser);
        } else if (pathInfo.equals("/edit")) {
            request.setAttribute("activeTab", "info");
            request.getRequestDispatcher("/user/profile-edit.jsp").forward(request, response);
        } else if (pathInfo.equals("/addresses")) {
            response.sendRedirect(request.getContextPath() + "/profile/addresses");
        } else if (pathInfo.equals("/orders")) {
            // Tab đơn hàng của tôi
            showUserOrders(request, response, currentUser);
        } else if (pathInfo.equals("/reviews")) {
            // Tab đánh giá của tôi
            showUserReviews(request, response, currentUser);
        } else if (pathInfo.equals("/security") || pathInfo.equals("/change-password")) {
            request.setAttribute("activeTab", "security");
            request.getRequestDispatcher("/user/change-password.jsp").forward(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    /**
     * Hiển thị trang Profile Overview với statistics
     */
    private void showProfileOverview(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        int userId = currentUser.getUserId();

        // Lấy statistics
        Map<String, Object> stats = new HashMap<>();
        stats.put("totalOrders", orderService.countOrdersByUser(userId));
        stats.put("totalSpending", orderService.getTotalSpendingByUser(userId));
        stats.put("totalAddresses", shippingService.countAddressesByUser(userId));

        // Lấy địa chỉ mặc định
        ShippingAddress defaultAddress = shippingService.getDefaultAddress(userId);

        // Lấy đơn hàng gần đây (3 đơn gần nhất)
        List<Order> recentOrders = orderService.getRecentOrdersByUser(userId, 3);

        request.setAttribute("stats", stats);
        request.setAttribute("defaultAddress", defaultAddress);
        request.setAttribute("recentOrders", recentOrders);
        request.setAttribute("activeTab", "overview");

        request.getRequestDispatcher("/user/profile-overview.jsp").forward(request, response);
    }

    /**
     * Hiển thị danh sách đơn hàng của người dùng
     */
    private void showUserOrders(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        int userId = currentUser.getUserId();
        String normalizedStatus = normalizeOrderStatus(request.getParameter("status"));

        List<Order> orders;
        if (normalizedStatus != null) {
            orders = orderService.getOrdersByUserAndStatus(userId, normalizedStatus);
        } else {
            orders = orderService.getOrdersByUser(userId);
        }

        // Lấy số lượng đơn hàng theo từng status
        Map<String, Integer> orderCounts = buildOrderCounts(orderService.getOrderCountsByStatus(userId));

        request.setAttribute("orders", orders);
        request.setAttribute("orderCounts", orderCounts);
        request.setAttribute("status", normalizedStatus != null ? normalizedStatus : "all");
        request.setAttribute("activeTab", "orders");

        request.getRequestDispatcher("/user/profile-orders.jsp").forward(request, response);
    }

    /**
     * Hiển thị danh sách đánh giá của người dùng
     */
    private void showUserReviews(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        int userId = currentUser.getUserId();

        // Lấy danh sách reviews với thông tin sản phẩm
        var reviews = reviewService.getUserReviewsWithProduct(userId);

        request.setAttribute("reviews", reviews);
        request.setAttribute("activeTab", "reviews");

        request.getRequestDispatcher("/user/profile-reviews.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = SessionUtil.getCurrentUser(session);

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        String pathInfo = request.getPathInfo();

        if (pathInfo != null && pathInfo.equals("/edit")) {
            updateProfile(request, response, currentUser);
        } else if (pathInfo != null
                && (pathInfo.equals("/change-password") || pathInfo.equals("/security/change-password"))) {
            changePassword(request, response, currentUser);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void updateProfile(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {

        String fullname = request.getParameter("fullname");
        String username = request.getParameter("username");
        String phone = request.getParameter("phone");

        boolean success = profileService.updateProfile(currentUser, fullname, username, phone);
        if (success) {
            SessionUtil.setCurrentUser(request.getSession(), currentUser);
            request.setAttribute("success", "Cập nhật hồ sơ thành công.");
        } else {
            String errorMessage = profileService.getLastError();
            request.setAttribute("error", errorMessage != null ? errorMessage : "Cập nhật hồ sơ thất bại.");
        }

        request.setAttribute("user", currentUser);
        request.getRequestDispatcher("/user/profile-edit.jsp").forward(request, response);
    }

    private void changePassword(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {

        String oldPassword = request.getParameter("oldPassword");
        if (oldPassword == null) {
            oldPassword = request.getParameter("currentPassword");
        }
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        boolean success = profileService.changePassword(
                currentUser.getUserId(), oldPassword, newPassword, confirmPassword);

        if (success) {
            request.setAttribute("success", "Đổi mật khẩu thành công.");
        } else {
            String errorMessage = profileService.getLastError();
            request.setAttribute("error", errorMessage != null ? errorMessage : "Đổi mật khẩu thất bại.");
        }

        request.setAttribute("activeTab", "security");
        request.getRequestDispatcher("/user/change-password.jsp").forward(request, response);
    }

    private String normalizeOrderStatus(String rawStatus) {
        if (rawStatus == null) {
            return null;
        }

        String normalized = rawStatus.trim().toLowerCase(Locale.ROOT);
        if (normalized.isEmpty() || "all".equals(normalized)) {
            return null;
        }

        return ORDER_STATUSES.contains(normalized) ? normalized : null;
    }

    private Map<String, Integer> buildOrderCounts(Map<String, Integer> sourceCounts) {
        Map<String, Integer> counts = new LinkedHashMap<>();
        int total = 0;

        for (String status : ORDER_STATUSES) {
            int count = sourceCounts != null ? sourceCounts.getOrDefault(status, 0) : 0;
            counts.put(status, count);
            total += count;
        }

        counts.put("all", total);
        return counts;
    }
}

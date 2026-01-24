package com.example.nhom49_webbansanphamchamsoctoc.controller.user;

import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import com.example.nhom49_webbansanphamchamsoctoc.model.ShippingAddress;
import com.example.nhom49_webbansanphamchamsoctoc.model.Order;
import com.example.nhom49_webbansanphamchamsoctoc.services.ProfileService;
import com.example.nhom49_webbansanphamchamsoctoc.services.ShippingService;
import com.example.nhom49_webbansanphamchamsoctoc.services.OrderService;
import com.example.nhom49_webbansanphamchamsoctoc.util.SessionUtil;
import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet(name = "UserProfileController", urlPatterns = {"/profile", "/profile/*"})
public class UserProfileController extends HttpServlet {

    private ProfileService profileService;
    private ShippingService shippingService;
    private OrderService orderService;

    @Override
    public void init() throws ServletException {
        super.init();
        this.profileService = new ProfileService();
        this.shippingService = new ShippingService();
        this.orderService = new OrderService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = SessionUtil.getCurrentUser(session);

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login?redirect=/profile");
            return;
        }

        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            // Trang thông tin tài khoản
            ShippingAddress defaultAddress = shippingService.getDefaultAddress(currentUser.getUserId());
            request.setAttribute("defaultAddress", defaultAddress);
            request.setAttribute("activeTab", "info");
            request.getRequestDispatcher("/user/profile.jsp").forward(request, response);

        } else if (pathInfo.equals("/edit")) {
            request.setAttribute("activeTab", "info");
            request.getRequestDispatcher("/WEB-INF/views/user/profile-edit.jsp").forward(request, response);

        } else if (pathInfo.equals("/addresses")) {
            // Trang quản lý địa chỉ
            List<ShippingAddress> addresses = shippingService.getAddressesByUser(currentUser.getUserId());
            request.setAttribute("addresses", addresses);
            request.setAttribute("activeTab", "address");
            request.getRequestDispatcher("/user/address.jsp").forward(request, response);

        } else if (pathInfo.startsWith("/addresses/") && !pathInfo.equals("/addresses/save")
                && !pathInfo.equals("/addresses/delete") && !pathInfo.equals("/addresses/set-default")) {
            // API lấy thông tin địa chỉ theo ID (cho edit)
            try {
                int addressId = Integer.parseInt(pathInfo.substring("/addresses/".length()));
                ShippingAddress address = shippingService.getAddressById(addressId);
                if (address != null && address.getUserId() == currentUser.getUserId()) {
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    PrintWriter out = response.getWriter();
                    out.print(new Gson().toJson(address));
                    out.flush();
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }

        } else if (pathInfo.equals("/orders")) {
            // Trang lịch sử đơn hàng
            String status = request.getParameter("status");
            String normalizedStatus = normalizeOrderStatus(status);
            List<Order> orders;
            if (normalizedStatus != null && !normalizedStatus.isEmpty()) {
                orders = orderService.getOrdersByUserAndStatus(currentUser.getUserId(), normalizedStatus.toUpperCase());
            } else {
                orders = orderService.getOrdersByUser(currentUser.getUserId());
            }

            // Đếm số lượng theo trạng thái
            request.setAttribute("orders", orders);
            request.setAttribute("status", status);
            request.setAttribute("totalOrders", orderService.countOrdersByUser(currentUser.getUserId()));
            request.setAttribute("pendingCount", orderService.countOrdersByUserAndStatus(currentUser.getUserId(), "PENDING"));
            request.setAttribute("processingCount", orderService.countOrdersByUserAndStatus(currentUser.getUserId(), "CONFIRMED"));
            request.setAttribute("shippingCount", orderService.countOrdersByUserAndStatus(currentUser.getUserId(), "SHIPPING"));
            request.setAttribute("deliveredCount", orderService.countOrdersByUserAndStatus(currentUser.getUserId(), "COMPLETED"));
            request.setAttribute("cancelledCount", orderService.countOrdersByUserAndStatus(currentUser.getUserId(), "CANCELLED"));
            request.setAttribute("activeTab", "orders");
            request.getRequestDispatcher("/user/orders.jsp").forward(request, response);

        } else if (pathInfo.equals("/security")) {
            // Trang bảo mật
            request.setAttribute("activeTab", "security");
            request.getRequestDispatcher("user/security.jsp").forward(request, response);

        } else if (pathInfo.equals("/change-password")) {
            request.setAttribute("activeTab", "security");
            request.getRequestDispatcher("user/change-password.jsp").forward(request, response);

        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = SessionUtil.getCurrentUser(session);

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        String pathInfo = request.getPathInfo();

        if (pathInfo != null && pathInfo.equals("/edit")) {
            updateProfile(request, response, currentUser);
        } else if (pathInfo != null && pathInfo.equals("/change-password")) {
            changePassword(request, response, currentUser);
        } else if (pathInfo != null && pathInfo.equals("/addresses/save")) {
            saveAddress(request, response, currentUser);
        } else if (pathInfo != null && pathInfo.equals("/addresses/delete")) {
            deleteAddress(request, response, currentUser);
        } else if (pathInfo != null && pathInfo.equals("/addresses/set-default")) {
            setDefaultAddress(request, response, currentUser);
        } else if (pathInfo != null && pathInfo.equals("/orders/cancel")) {
            cancelOrder(request, response, currentUser);
        } else if (pathInfo != null && pathInfo.equals("/security/change-password")) {
            changePassword(request, response, currentUser);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private String normalizeOrderStatus(String status) {
        if (status == null) {
            return null;
        }
        String normalized = status.trim().toLowerCase();
        if (normalized.isEmpty()) {
            return normalized;
        }
        switch (normalized) {
            case "processing":
                return "confirmed";
            case "delivered":
                return "completed";
            default:
                return normalized;
        }
    }

    private void updateProfile(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String phone = request.getParameter("phone");

        boolean success = profileService.updateProfile(currentUser, username, phone);
        if (success) {
            SessionUtil.setCurrentUser(request.getSession(), currentUser);
            request.setAttribute("success", "Profile updated thành công.");
        } else {
            String errorMessage = profileService.getLastError();
            request.setAttribute("error", errorMessage != null ? errorMessage : "Update profile thất bại.");
        }

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
                currentUser.getUserId(), oldPassword, newPassword, confirmPassword
        );

        if (success) {
            request.setAttribute("success", "Đổi mật khẩu thành công.");
        } else {
            String errorMessage = profileService.getLastError();
            request.setAttribute("error", errorMessage != null ? errorMessage : "Đổi mật khẩu thất bại.");
        }

        // Kiểm tra xem request từ trang nào
        String referer = request.getHeader("Referer");
        if (referer != null && referer.contains("/security")) {
            request.setAttribute("activeTab", "security");
            request.getRequestDispatcher("/user/security.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/user/change-password.jsp").forward(request, response);
        }
    }

    private void saveAddress(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws IOException {

        String addressIdStr = request.getParameter("addressId");
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String provinceCode = request.getParameter("provinceCode");
        String provinceName = request.getParameter("provinceName");
        String districtCode = request.getParameter("districtCode");
        String districtName = request.getParameter("districtName");
        String wardCode = request.getParameter("wardCode");
        String wardName = request.getParameter("wardName");
        String specificAddress = request.getParameter("specificAddress");
        boolean isDefault = "true".equals(request.getParameter("isDefault"));

        ShippingAddress address = new ShippingAddress();
        address.setUserId(currentUser.getUserId());
        address.setFullName(fullName);
        address.setPhone(phone);
        address.setProvinceCode(provinceCode);
        address.setProvinceName(provinceName);
        address.setDistrictCode(districtCode);
        address.setDistrictName(districtName);
        address.setWardCode(wardCode);
        address.setWardName(wardName);
        address.setSpecificAddress(specificAddress);
        address.setDefault(isDefault);

        boolean success;
        if (addressIdStr != null && !addressIdStr.isEmpty()) {
            address.setAddressId(Integer.parseInt(addressIdStr));
            success = shippingService.updateAddress(address);
        } else {
            success = shippingService.addAddress(address);
        }

        if (success) {
            request.getSession().setAttribute("success", "Lưu địa chỉ thành công");
        } else {
            request.getSession().setAttribute("error", "Có lỗi xảy ra khi lưu địa chỉ");
        }

        response.sendRedirect(request.getContextPath() + "/profile/addresses");
    }

    private void deleteAddress(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws IOException {

        String addressIdStr = request.getParameter("addressId");
        if (addressIdStr != null && !addressIdStr.isEmpty()) {
            int addressId = Integer.parseInt(addressIdStr);
            ShippingAddress address = shippingService.getAddressById(addressId);

            if (address != null && address.getUserId() == currentUser.getUserId()) {
                boolean success = shippingService.deleteAddress(addressId);
                if (success) {
                    request.getSession().setAttribute("success", "Xóa địa chỉ thành công");
                } else {
                    request.getSession().setAttribute("error", "Có lỗi xảy ra khi xóa địa chỉ");
                }
            }
        }

        response.sendRedirect(request.getContextPath() + "/profile/addresses");
    }

    private void setDefaultAddress(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws IOException {

        String addressIdStr = request.getParameter("addressId");
        if (addressIdStr != null && !addressIdStr.isEmpty()) {
            int addressId = Integer.parseInt(addressIdStr);
            boolean success = shippingService.setDefaultAddress(currentUser.getUserId(), addressId);
            if (success) {
                request.getSession().setAttribute("success", "Đã đặt địa chỉ mặc định");
            } else {
                request.getSession().setAttribute("error", "Có lỗi xảy ra");
            }
        }

        response.sendRedirect(request.getContextPath() + "/profile/addresses");
    }

    private void cancelOrder(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws IOException {

        String orderIdStr = request.getParameter("orderId");
        if (orderIdStr != null && !orderIdStr.isEmpty()) {
            int orderId = Integer.parseInt(orderIdStr);
            Order order = orderService.getOrderById(orderId);

            if (order != null && order.getUserId() == currentUser.getUserId() && "pending".equalsIgnoreCase(order.getOrderStatus())) {
                boolean success = orderService.updateOrderStatus(orderId, "cancelled");
                if (success) {
                    request.getSession().setAttribute("success", "Đã hủy đơn hàng thành công");
                } else {
                    request.getSession().setAttribute("error", "Có lỗi xảy ra khi hủy đơn hàng");
                }
            } else {
                request.getSession().setAttribute("error", "Không thể hủy đơn hàng này");
            }
        }

        response.sendRedirect(request.getContextPath() + "/profile/orders");
    }
}

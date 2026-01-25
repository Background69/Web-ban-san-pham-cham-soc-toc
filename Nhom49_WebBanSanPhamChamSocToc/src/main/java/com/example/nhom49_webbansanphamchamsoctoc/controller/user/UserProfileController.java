package com.example.nhom49_webbansanphamchamsoctoc.controller.user;

import com.example.nhom49_webbansanphamchamsoctoc.model.ShippingAddress;
import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import com.example.nhom49_webbansanphamchamsoctoc.services.ProfileService;
import com.example.nhom49_webbansanphamchamsoctoc.services.ShippingService;
import com.example.nhom49_webbansanphamchamsoctoc.util.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "UserProfileController", urlPatterns = {"/profile", "/profile/*"})
public class UserProfileController extends HttpServlet {

    private ProfileService profileService;
    private ShippingService shippingService;

    @Override
    public void init() throws ServletException {
        super.init();
        this.profileService = new ProfileService();
        this.shippingService = new ShippingService();
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

        if (pathInfo == null || pathInfo.equals("/")) {
            ShippingAddress defaultAddress = shippingService.getDefaultAddress(currentUser.getUserId());
            request.setAttribute("defaultAddress", defaultAddress);
            request.setAttribute("activeTab", "info");
            request.getRequestDispatcher("/user/user-profile.jsp").forward(request, response);
        } else if (pathInfo.equals("/edit")) {
            request.setAttribute("activeTab", "info");
            request.getRequestDispatcher("/user/profile-edit.jsp").forward(request, response);
        } else if (pathInfo.equals("/addresses")) {
            response.sendRedirect(request.getContextPath() + "/profile/addresses");
        } else if (pathInfo.equals("/orders")) {
            response.sendRedirect(request.getContextPath() + "/orders");
        } else if (pathInfo.equals("/security") || pathInfo.equals("/change-password")) {
            request.setAttribute("activeTab", "security");
            request.getRequestDispatcher("/user/change-password.jsp").forward(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
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
        } else if (pathInfo != null && (pathInfo.equals("/change-password") || pathInfo.equals("/security/change-password"))) {
            changePassword(request, response, currentUser);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void updateProfile(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String phone = request.getParameter("phone");

        boolean success = profileService.updateProfile(currentUser, username, phone);
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
                currentUser.getUserId(), oldPassword, newPassword, confirmPassword
        );

        if (success) {
            request.setAttribute("success", "Đổi mật khẩu thành công.");
        } else {
            String errorMessage = profileService.getLastError();
            request.setAttribute("error", errorMessage != null ? errorMessage : "Đổi mật khẩu thất bại.");
        }

        request.setAttribute("activeTab", "security");
        request.getRequestDispatcher("/user/change-password.jsp").forward(request, response);
    }
}

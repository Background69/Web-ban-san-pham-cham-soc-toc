package com.example.nhom49_webbansanphamchamsoctoc.controller.user;

import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import com.example.nhom49_webbansanphamchamsoctoc.services.UserService;
import com.example.nhom49_webbansanphamchamsoctoc.util.SessionUtil;
import com.example.nhom49_webbansanphamchamsoctoc.util.ValidationUtil;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;

/**
 * Servlet xử lý profile user
 */
@WebServlet(name = "UserController", value = "/user/*")
public class UserController extends HttpServlet {
    private UserService userService;

    @Override
    public void init() {
        this.userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = SessionUtil.getCurrentUser(session);

        // Kiểm tra đăng nhập
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=/user");
            return;
        }

        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            // Hiển thị profile
            RequestDispatcher dispatcher =
                    this.getServletContext().getRequestDispatcher("/webapp/user/user_profile.jsp");
            dispatcher.forward(request, response);
        } else if (pathInfo.equals("/edit")) {
            // Form chỉnh sửa profile
            RequestDispatcher dispatcher =
                    this.getServletContext().getRequestDispatcher("/webapp/user/profile-edit.jsp");
            dispatcher.forward(request, response);
        } else if (pathInfo.equals("/change-password")) {
            // Form đổi mật khẩu
            RequestDispatcher dispatcher =
                    this.getServletContext().getRequestDispatcher("/webapp/user/change-password.jsp");
            dispatcher.forward(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = SessionUtil.getCurrentUser(session);

        // Kiểm tra đăng nhập
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String pathInfo = request.getPathInfo();
        if (pathInfo != null && pathInfo.equals("/edit")) {
            profileUpdate(request, response, currentUser);
        } else if (pathInfo != null && pathInfo.equals("/change-password")) {
            changePassword(request, response, currentUser);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }

    }

    private void profileUpdate(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String phone = request.getParameter("phone");
        // Để JSP hiển thị lại dữ liệu người dùng vừa nhập khi có lỗi
        request.setAttribute("username", username);
        request.setAttribute("phone", phone);

        try {
            userService.updateUserProfile(currentUser, username, phone);

            // Refresh user trong session
            User refreshed = userService.getUserById(currentUser.getUserId());
            if (refreshed != null) {
                SessionUtil.setCurrentUser(request.getSession(), refreshed);
            }

            request.setAttribute("success", "Cập nhật profile thành công.");
        } catch (IllegalArgumentException ex) {
            request.setAttribute("error", ex.getMessage());
        } catch (Exception ex) {
            request.setAttribute("error", "Có lỗi xảy ra khi cập nhật profile. Vui lòng thử lại.");
        }

        RequestDispatcher dispatcher =
                this.getServletContext().getRequestDispatcher("/webapp/user/profile-edit.jsp");
        dispatcher.forward(request, response);

    }

    private void changePassword(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {

        // Hỗ trợ nhiều tên field (tùy template đang đặt)
        String currentPassword = firstNonEmpty(
                request.getParameter("currentPassword"),
                request.getParameter("oldPassword"),
                request.getParameter("password")
        );
        String newPassword = firstNonEmpty(
                request.getParameter("newPassword"),
                request.getParameter("passwordNew")
        );
        String confirmPassword = firstNonEmpty(
                request.getParameter("confirmPassword"),
                request.getParameter("passwordConfirm"),
                request.getParameter("rePassword")
        );

        try {
            if (ValidationUtil.isEmpty(newPassword) || ValidationUtil.isEmpty(confirmPassword)) {
                throw new IllegalArgumentException("Vui lòng nhập đầy đủ mật khẩu mới và xác nhận mật khẩu.");
            }
            if (!newPassword.equals(confirmPassword)) {
                throw new IllegalArgumentException("Mật khẩu xác nhận không khớp.");
            }

            userService.changePassword(currentUser, currentPassword, newPassword);
            request.setAttribute("success", "Đổi mật khẩu thành công.");
        } catch (IllegalArgumentException ex) {
            request.setAttribute("error", ex.getMessage());
        } catch (Exception ex) {
            request.setAttribute("error", "Có lỗi xảy ra khi đổi mật khẩu. Vui lòng thử lại.");
        }

        RequestDispatcher dispatcher =
                this.getServletContext().getRequestDispatcher("/webapp/user/change-password.jsp");
        dispatcher.forward(request, response);
    }

    private String firstNonEmpty(String... values) {
        if (values == null) return null;
        for (String v : values) {
            if (ValidationUtil.isNotEmpty(v)) {
                return v;
            }
        }
        return null;
    }
}
package com.example.nhom49_webbansanphamchamsoctoc.services;

import com.example.nhom49_webbansanphamchamsoctoc.dao.UserDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import com.example.nhom49_webbansanphamchamsoctoc.util.PasswordUtil;
import com.example.nhom49_webbansanphamchamsoctoc.util.ValidationUtil;

/**
 * Lớp ProfileService.
 */
public class ProfileService {

    private final UserDAO userDAO;
    private String lastError;

    public ProfileService() {
        this.userDAO = new UserDAO();
    }

    /**
     * Lấy thông báo lỗi cuối cùng
     */
    public String getLastError() {
        return lastError;
    }

    /**
     * Cập nhật thông tin profile người dùng.
     */
    public boolean updateProfile(User user, String newFullname, String newUsername, String newPhone) {
        lastError = null;
        if (user == null) {
            lastError = "Không thấy user";
            return false;
        }

        if (ValidationUtil.isEmpty(newFullname)) {
            lastError = "Họ tên là bắt buộc";
            return false;
        }

        if (ValidationUtil.isEmpty(newUsername)) {
            lastError = "Username là bắt buộc";
            return false;
        }

        String fullnameError = ValidationUtil.validateFullName(newFullname);
        if (fullnameError != null) {
            lastError = fullnameError;
            return false;
        }

        String usernameError = ValidationUtil.validateUsername(newUsername);
        if (usernameError != null) {
            lastError = usernameError;
            return false;
        }

        if (userDAO.existsByUsername(newUsername.trim())) {
            User existingUser = userDAO.findByUsername(newUsername.trim());
            if (existingUser != null && existingUser.getUserId() != user.getUserId()) {
                lastError = "Tên đăng nhập đã tồn tại";
                return false;
            }
        }

        // Cập nhật thông tin
        user.setUsername(ValidationUtil.sanitize(newUsername));
        user.setPhone(ValidationUtil.sanitize(newPhone));

        boolean success = userDAO.update(user);
        if (!success) {
            lastError = "Có lỗi xảy ra khi cập nhật thông tin";
        }
        return success;
    }

    /**
     * Đổi mật khẩu cho user
     * @return true nếu thành công, false nếu thất bại (lấy lỗi qua getLastError())
     */
    public boolean changePassword(int userId, String oldPassword, String newPassword, String confirmPassword) {
        lastError = null;
        if (!ValidationUtil.isPositiveInteger(userId)) {
            lastError = "ID user không hợp lệ";
            return false;
        }

        // Validate input không null
        if (ValidationUtil.isEmpty(oldPassword)) {
            lastError = "Mật khẩu hiện tại không được để trống";
            return false;
        }

        // Validate confirm password
        String confirmError = ValidationUtil.validateConfirmPassword(newPassword, confirmPassword);
        if (confirmError != null) {
            lastError = confirmError;
            return false;
        }

        // Validate mật khẩu mới
        String passwordError = ValidationUtil.validatePassword(newPassword);
        if (passwordError != null) {
            lastError = passwordError;
            return false;
        }

        // Lấy user hiện tại
        User user = userDAO.findById(userId);
        if (user == null) {
            lastError = "Không tìm thấy user";
            return false;
        }

        // Kiểm tra mật khẩu cũ
        if (!PasswordUtil.verifyPassword(oldPassword, user.getPassword())) {
            lastError = "Mật khẩu cũ không đúng";
            return false;
        }

        // Hash mật khẩu mới và cập nhật
        String hashedNewPassword = PasswordUtil.hashPassword(newPassword);
        boolean success = userDAO.updatePassword(userId, hashedNewPassword);
        if (!success) {
            lastError = "Có lỗi xảy ra khi đổi mật khẩu";
        }
        return success;
    }

    /**
     * Cập nhật avatar cho user
     */
    public boolean updateAvatar(int userId, String avatarUrl) {
        lastError = null;
        if (!ValidationUtil.isPositiveInteger(userId)) {
            lastError = "ID user không hợp lệ";
            return false;
        }

        if (ValidationUtil.isEmpty(avatarUrl)) {
            lastError = "URL avatar không được để trống";
            return false;
        }

        User user = userDAO.findById(userId);
        if (user == null) {
            lastError = "Không tìm thấy user";
            return false;
        }

        user.setAvatar(avatarUrl);
        boolean success = userDAO.update(user);
        if (!success) {
            lastError = "Có lỗi xảy ra khi cập nhật avatar";
        }
        return success;
    }
}


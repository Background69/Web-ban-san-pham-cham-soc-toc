package com.example.nhom49_webbansanphamchamsoctoc.services;

import com.example.nhom49_webbansanphamchamsoctoc.dao.UserDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import com.example.nhom49_webbansanphamchamsoctoc.util.ValidationUtil;
import org.mindrot.jbcrypt.BCrypt;

/**
 * Service chuyên xử lý các thao tác liên quan đến profile user
 */
public class UserService {

    private final UserDAO userDAO;
    public UserService() {
        this.userDAO = new UserDAO();
    }

    /**
     * Lấy user mới nhất từ DB theo id.
     */
    public User getUserById(int userId) {
        if (!ValidationUtil.isPositiveInteger(userId)) {
            return null;
        }
        return userDAO.findById(userId);
    }

    /**
     * Cập nhật thông tin profile cơ bản.
     *
     * @throws IllegalArgumentException nếu dữ liệu không hợp lệ
     * @throws RuntimeException nếu cập nhật DB thất bại
     */

    public void updateUserProfile(User user, String newUsername, String newPhone) {
        // Validate user
        if (user == null || !ValidationUtil.isPositiveInteger(user.getUserId())) {
            throw new IllegalArgumentException("Thông tin user không hợp lệ");
        }

        // Validate username
        String usernameError = ValidationUtil.validateUsername(newUsername);
        if (usernameError != null) {
            throw new IllegalArgumentException(usernameError);
        }

        // Validate phone (optional)
        String phoneError = ValidationUtil.validatePhone(newPhone);
        if (phoneError != null) {
            throw new IllegalArgumentException(phoneError);
        }

        // Lấy dữ liệu user mới nhất từ DB (để tránh dùng user trên session bị thiếu field)
        User dbUser = userDAO.findById(user.getUserId());
        if (dbUser == null) {
            throw new IllegalArgumentException("Không tìm thấy tài khoản.");
        }

        String normalizedUsername = ValidationUtil.sanitize(newUsername);
        String normalizedPhone = ValidationUtil.isNotEmpty(newPhone) ? ValidationUtil.sanitize(newPhone) : null;

        // Kiểm tra username đã tồn tại chưa (trừ user hiện tại)
        if (normalizedUsername != null) {
            User existingUser = userDAO.findByUsername(normalizedUsername);
            if (existingUser != null && existingUser.getUserId() != dbUser.getUserId()) {
                throw new IllegalArgumentException("Tên đăng nhập đã tồn tại.");
            }
        }

        // Cập nhật thông tin
        dbUser.setUsername(normalizedUsername);
        dbUser.setPhone(normalizedPhone);

        boolean success = userDAO.update(dbUser);
        if (!success) {
            throw new RuntimeException("Cập nhật profile thất bại. Vui lòng thử lại.");
        }
    }

    /**
     * Đổi mật khẩu.
     *
     * @throws IllegalArgumentException nếu dữ liệu không hợp lệ hoặc mật khẩu hiện tại sai
     * @throws RuntimeException nếu cập nhật DB thất bại
     */
    public void changePassword(User sessionUser, String currentPassword, String newPassword) {
        if (sessionUser == null || !ValidationUtil.isPositiveInteger(sessionUser.getUserId())) {
            throw new IllegalArgumentException("Tài khoản không hợp lệ.");
        }
        if (ValidationUtil.isEmpty(currentPassword)) {
            throw new IllegalArgumentException("Vui lòng nhập mật khẩu hiện tại.");
        }
        if (ValidationUtil.isEmpty(newPassword)) {
            throw new IllegalArgumentException("Vui lòng nhập mật khẩu mới.");
        }
        if (!ValidationUtil.isValidLength(newPassword, 6, 255)) {
            throw new IllegalArgumentException("Mật khẩu mới phải từ 6 ký tự trở lên.");
        }

        User dbUser = userDAO.findById(sessionUser.getUserId());
        if (dbUser == null) {
            throw new IllegalArgumentException("Không tìm thấy tài khoản.");
        }
        if (dbUser.getPassword() == null) {
            throw new IllegalArgumentException("Tài khoản chưa có mật khẩu.");
        }

        // Verify mật khẩu hiện tại
        boolean ok = BCrypt.checkpw(currentPassword, dbUser.getPassword());
        if (!ok) {
            throw new IllegalArgumentException("Mật khẩu hiện tại không đúng.");
        }

        String hashed = BCrypt.hashpw(newPassword, BCrypt.gensalt(12));
        boolean updated = userDAO.updatePassword(dbUser.getUserId(), hashed);
        if (!updated) {
            throw new RuntimeException("Đổi mật khẩu thất bại. Vui lòng thử lại.");
        }
    }
}

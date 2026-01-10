package com.example.nhom49_webbansanphamchamsoctoc.services;

import com.example.nhom49_webbansanphamchamsoctoc.dao.UserDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import com.example.nhom49_webbansanphamchamsoctoc.util.PasswordUtil;
import com.example.nhom49_webbansanphamchamsoctoc.util.ValidationUtil;

import jakarta.servlet.http.HttpSession;

/**
 * Service chuyên xử lý authentication (đăng nhập, đăng ký, session)
 * Tách biệt với UserService để quản lý user
 */
public class AuthenticationService {

    private final UserDAO userDAO;
    private String lastError;

    public AuthenticationService() {
        this.userDAO = new UserDAO();
    }

    /**
     * Lấy thông báo lỗi cuối cùng
     */
    public String getLastError() {
        return lastError;
    }

    /**
     * Đăng nhập user
     *
     * @return User nếu thành công, null nếu thất bại (lấy lỗi qua getLastError())
     */
    public User login(String emailOrUsername, String password) {
        if (ValidationUtil.isEmpty(emailOrUsername)) {
            lastError = "Email hoặc tên đăng nhập không được để trống";
            return null;
        }

        if (ValidationUtil.isEmpty(password)) {
            lastError = "Mật khẩu không được để trống";
            return null;
        }

        User user = userDAO.authenticate(emailOrUsername.trim(), password);

        if (user == null) {
            lastError = "Email/tên đăng nhập hoặc mật khẩu không đúng";
            return null;
        }

        if (!user.isActive()) {
            lastError = "Tài khoản đã bị khóa. Vui lòng liên hệ admin.";
            return null;
        }
        if ("LOCAL".equalsIgnoreCase(user.getAuthProvider()) && !user.isVerified()) {
            lastError = "Tài khoản chưa được xác minh email.";
            return null;
        }

        return user;
    }

    /**
     * Đăng ký user mới
     *
     * @return User nếu thành công, null nếu thất bại (lấy lỗi qua getLastError())
     */
    public User register(String email, String username, String phone, String password, String confirmPassword) {
        String emailError = ValidationUtil.validateEmail(email);
        if (emailError != null) {
            lastError = emailError;
            return null;
        }

        String usernameError = ValidationUtil.validateUsername(username);
        if (usernameError != null) {
            lastError = usernameError;
            return null;
        }

        String passwordError = ValidationUtil.validatePassword(password);
        if (passwordError != null) {
            lastError = passwordError;
            return null;
        }

        String phoneError = ValidationUtil.validatePhone(phone);
        if (phoneError != null) {
            lastError = phoneError;
            return null;
        }

        String confirmError = ValidationUtil.validateConfirmPassword(password, confirmPassword);
        if (confirmError != null) {
            lastError = confirmError;
            return null;
        }

        if (userDAO.existsByEmail(email.trim())) {
            lastError = "Email đã được sử dụng";
            return null;
        }

        if (userDAO.existsByUsername(username.trim())) {
            lastError = "Tên đăng nhập đã được sử dụng";
            return null;
        }

        User user = new User();
        user.setEmail(email.trim());
        user.setUsername(username.trim());
        user.setPassword(PasswordUtil.hashPassword(password));
        user.setRole("Khách hàng");
        user.setActive(true);
        user.setPhone(ValidationUtil.sanitize(phone));
        user.setAuthProvider("LOCAL");
        user.setVerified(false);
        String token = java.util.UUID.randomUUID().toString();
        user.setVerificationToken(token);

        int userId = userDAO.insert(user);
        if (userId > 0) {
            user.setUserId(userId);
            return user;
        }

        lastError = "Đăng ký thất bại. Vui lòng thử lại.";
        return null;
    }

    /**
     * Đăng xuất user - hủy session
     */
    public void logout(HttpSession session) {
        if (session != null) {
            session.removeAttribute("user");
            session.removeAttribute("cart");
            session.invalidate();
        }
    }

    /**
     * Lấy user hiện tại từ session
     */
    public User getCurrentUser(HttpSession session) {
        if (session != null) {
            return (User) session.getAttribute("user");
        }
        return null;
    }

    /**
     * Lưu user vào session (không bao gồm password)
     */
    public void setCurrentUser(HttpSession session, User user) {
        if (session != null && user != null) {
            User sessionUser = new User();
            sessionUser.setUserId(user.getUserId());
            sessionUser.setEmail(user.getEmail());
            sessionUser.setUsername(user.getUsername());
            sessionUser.setPhone(user.getPhone());
            sessionUser.setAvatar(user.getAvatar());
            sessionUser.setRole(user.getRole());
            sessionUser.setActive(user.isActive());
            sessionUser.setVerified(user.isVerified());
            sessionUser.setAuthProvider(user.getAuthProvider());
            sessionUser.setVerificationToken(user.getVerificationToken());
            sessionUser.setCreatedAt(user.getCreatedAt());
            sessionUser.setGoogleId(user.getGoogleId());
            session.setAttribute("user", sessionUser);
        }
    }

    /**
     * Kiểm tra email đã tồn tại chưa
     */
    public boolean isEmailExists(String email) {
        return userDAO.existsByEmail(email);
    }

    /**
     * Kiểm tra username đã tồn tại chưa
     */
    public boolean isUsernameExists(String username) {
        return userDAO.existsByUsername(username);
    }

    /**
     * Kiểm tra user có phải admin không
     */
    public boolean isAdmin(User user) {
        return user != null && "Admin".equals(user.getRole()) && user.isActive();
    }

    /**
     * Kiểm tra user có active không
     */
    public boolean isActiveUser(User user) {
        return user != null && user.isActive();
    }

    /**
     * Kiểm tra user đã đăng nhập chưa
     */
    public boolean isLoggedIn(HttpSession session) {
        return getCurrentUser(session) != null;
    }
}

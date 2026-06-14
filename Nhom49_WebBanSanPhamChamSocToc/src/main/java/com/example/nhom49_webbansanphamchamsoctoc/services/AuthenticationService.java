package com.example.nhom49_webbansanphamchamsoctoc.services;

import com.example.nhom49_webbansanphamchamsoctoc.dao.LoginAttemptDAO;
import com.example.nhom49_webbansanphamchamsoctoc.dao.UserDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import com.example.nhom49_webbansanphamchamsoctoc.util.PasswordUtil;
import com.example.nhom49_webbansanphamchamsoctoc.util.ValidationUtil;
import com.example.nhom49_webbansanphamchamsoctoc.util.SessionUtil;


import jakarta.servlet.http.HttpSession;

public class AuthenticationService {

    public static final String GOOGLE_LINKED_NO_PASSWORD_MESSAGE =
            "Tài khoản này đã liên kết với Google nhưng chưa có mật khẩu. " +
                    "Vui lòng đăng nhập bằng Google hoặc thiết lập mật khẩu.";

    private static final int MAX_FAILED_ATTEMPTS = 5;
    private static final int FAILED_ATTEMPT_WINDOW_MINUTES = 30;
    private final UserDAO userDAO;
    private final LoginAttemptDAO loginAttemptDAO;
    private String lastError;

    public AuthenticationService() {
        this.userDAO = new UserDAO();
        this.loginAttemptDAO = new LoginAttemptDAO();
    }

    public String getLastError() {
        return lastError;
    }

    public boolean isGoogleLinkedNoPasswordError() {
        return GOOGLE_LINKED_NO_PASSWORD_MESSAGE.equals(lastError);
    }

    /**
     * Đăng nhập có tích hợp brute-force protection
     */
    public User login(String emailOrUsername, String password, String ipAddress) {
        lastError = null;
        if (ValidationUtil.isEmpty(emailOrUsername)) {
            lastError = "Email hoặc tên đăng nhập không được để trống";
            return null;
        }
        if (ValidationUtil.isEmpty(password)) {
            lastError = "Mật khẩu không được để trống";
            return null;
        }

        User user = userDAO.findByEmail(emailOrUsername.trim());
        if (user == null) {
            user = userDAO.findByUsername(emailOrUsername.trim());
        }

        if (user == null) {
            lastError = "Tài khoản không tồn tại";
            return null;
        }
        // Kiểm tra tài khoản đã bị khóa chưa
        if (!user.isActive()) {
            lastError = "Tài khoản đã bị khóa do nhập sai mật khẩu quá nhiều lần. " +
                    "Vui lòng liên hệ quản trị viên để mở khóa.";
            return null;
        }
        if (isGoogleLinkedAccount(user) && !hasLocalPassword(user)) {
            lastError = GOOGLE_LINKED_NO_PASSWORD_MESSAGE;
            return null;
        }
        if (!PasswordUtil.verifyPassword(password, user.getPassword())) {
            // Mật khẩu sai → ghi nhận attempt thất bại
            loginAttemptDAO.recordAttempt(user.getUserId(), ipAddress, false);
            // Đếm số lần sai trong cửa sổ thời gian
            int failedCount = loginAttemptDAO.countRecentFailedAttempts(
                    user.getUserId(), FAILED_ATTEMPT_WINDOW_MINUTES);
            if (failedCount >= MAX_FAILED_ATTEMPTS) {
                // Khóa tài khoản
                userDAO.updateActiveStatus(user.getUserId(), false);
                lastError = "Tài khoản đã bị khóa do nhập sai mật khẩu " + MAX_FAILED_ATTEMPTS +
                        " lần. Vui lòng liên hệ quản trị viên để mở khóa.";
            } else {
                int remaining = MAX_FAILED_ATTEMPTS - failedCount;
                lastError = "Mật khẩu không đúng. Bạn còn " + remaining + " lần thử trước khi tài khoản bị khóa.";
            }
            return null;
        }

        // Đăng nhập thành công → ghi nhận
        loginAttemptDAO.recordAttempt(user.getUserId(), ipAddress, true);
        return user;
    }

    private boolean isGoogleLinkedAccount(User user) {
        if (user == null) {
            return false;
        }
        String googleId = user.getGoogleId();
        return (googleId != null && !googleId.isBlank())
                || "GOOGLE".equalsIgnoreCase(user.getAuthProvider());
    }

    private boolean hasLocalPassword(User user) {
        String storedPassword = user.getPassword();
        return storedPassword != null && !storedPassword.isBlank();
    }

    public String validateUserInput(String email, String fullname, String username, String phone, String password, String confirmPassword) {
        lastError = null;
        String emailError = ValidationUtil.validateEmail(email);
        if (emailError != null) {
            lastError = emailError;
            return lastError;
        }

        String fullnameError = ValidationUtil.validateFullName(fullname);
        if (fullnameError != null) {
            lastError = fullnameError;
            return lastError;
        }

        String usernameError = ValidationUtil.validateUsername(username);
        if (usernameError != null) {
            lastError = usernameError;
            return lastError;
        }

        String passwordError = ValidationUtil.validatePassword(password);
        if (passwordError != null) {
            lastError = passwordError;
            return lastError;
        }

        String phoneError = ValidationUtil.validatePhone(phone);
        if (phoneError != null) {
            lastError = phoneError;
            return lastError;
        }

        String confirmError = ValidationUtil.validateConfirmPassword(password, confirmPassword);
        if (confirmError != null) {
            lastError = confirmError;
            return lastError;
        }

        if (userDAO.existsByEmail(email.trim())) {
            lastError = "Email đã tồn tại";
            return lastError;
        }

        if (userDAO.existsByUsername(username.trim())) {
            lastError = "Tên đăng nhập đã tồn tại";
            return lastError;
        }

        lastError = null;
        return null;
    }

    public User register(String email, String fullname, String username, String phone, String password, String confirmPassword) {

        User user = new User();
        user.setEmail(email.trim());
        user.setFullName(fullname.trim());
        user.setUsername(username.trim());
        user.setPassword(PasswordUtil.hashPassword(password));
        user.setRole("Khách hàng");
        user.setActive(true);
        user.setPhone(ValidationUtil.sanitize(phone));
        user.setAuthProvider("LOCAL");

        int userId = userDAO.insert(user);
        if (userId > 0) {
            user.setUserId(userId);
            return user;
        }
        lastError = "Không thể tạo tài khoản. Vui lòng thử lại.";
        return null;
    }

    public boolean setActiveStatus(int userId, boolean active) {
        return userDAO.updateActiveStatus(userId, active);
    }

    public void setCurrentUser(HttpSession session, User user) {
        SessionUtil.setCurrentUser(session, user);
    }

    public void logout(HttpSession session) {
        if (session != null) {
            session.removeAttribute(SessionUtil.USER_KEY);
            session.removeAttribute(SessionUtil.CURRENT_USER_KEY);
            session.removeAttribute(SessionUtil.CART_KEY);
            session.invalidate();
        }
    }
    public boolean isActiveUser(User user) {
        return user != null && user.isActive();
    }
}


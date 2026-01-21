package com.example.nhom49_webbansanphamchamsoctoc.services;

import com.example.nhom49_webbansanphamchamsoctoc.dao.UserDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import com.example.nhom49_webbansanphamchamsoctoc.util.PasswordUtil;
import com.example.nhom49_webbansanphamchamsoctoc.util.ValidationUtil;
import com.example.nhom49_webbansanphamchamsoctoc.util.SessionUtil;
import com.example.nhom49_webbansanphamchamsoctoc.util.TokenUtil;

import jakarta.servlet.http.HttpSession;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Service chuyên xử lý authentication (đăng nhập, đăng ký, session)
 * Tách biệt với UserService để quản lý user
 */
public class AuthenticationService {

    private static final int VERIFICATION_TOKEN_EXPIRY_HOURS = 24;
    private final UserDAO userDAO;
    private String lastError;

    public Object getLastError() {
        return lastError;
    }

    /**
     * Thực hiện registration result.
     */
    public record RegistrationResult(User user, String rawVerificationToken) {
    }

    /**
     * Thực hiện auth service.
     */
    public AuthenticationService() {
        this.userDAO = new UserDAO();
    }

    /**
     * Đăng nhập bằng email hoặc username.
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

        User user = userDAO.findByEmail(emailOrUsername.trim());
        if (user == null) {
            user = userDAO.findByUsername(emailOrUsername.trim());
        }

        if (user == null) {
            lastError = "Email/tên đăng nhập hoặc mật khẩu không đúng";
            return null;
        }

        if (!user.isActive()) {
            lastError = "Tài khoản đã bị khóa. Vui lòng liên hệ admin.";
            return null;
        }
        if (!PasswordUtil.verifyPassword(password, user.getPassword())) {
            lastError = "Tài khoản chưa được xác minh email.";
            return null;
        }
        if (!user.isVerified()) {
            lastError = "Tài khoản chưa được xác minh email.";
            return null;
        }

        return user;
    }

    /**
     * Thực hiện register.
     */
    public RegistrationResult register(String email, String username, String phone, String password, String confirmPassword) {
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

        String rawToken = UUID.randomUUID().toString();
        String hashedToken = TokenUtil.hashToken(rawToken);
        user.setVerificationToken(hashedToken);
        user.setResetTokenExpiry(Timestamp.valueOf(LocalDateTime.now().plusHours(VERIFICATION_TOKEN_EXPIRY_HOURS)));

        int userId = userDAO.insert(user);
        if (userId > 0) {
            user.setUserId(userId);
            return new RegistrationResult(user, rawToken);
        }

        lastError = "Đăng ký thất bại. Vui lòng thử lại.";
        return null;
    }

    /**
     * Thiết lập current user vao session.
     */
    public void setCurrentUser(HttpSession session, User user) {
        SessionUtil.setCurrentUser(session, user);
    }

    /**
     * Thực hiện đăng xuất.
     */
    public void logout(HttpSession session) {
        if (session != null) {
            session.removeAttribute("user");
            session.removeAttribute("cart");
            session.invalidate();
        }
    }

    /**
     * Lấy current user.
     */
    public User getCurrentUser(HttpSession session) {
        return SessionUtil.getCurrentUser(session);
    }

    /**
     * Kiểm tra email exists.
     */
    public boolean isEmailExists(String email) {
        return userDAO.existsByEmail(email);
    }

    /**
     * Kiểm tra user active.
     */
    public boolean isActiveUser(User user) {
        return user != null && user.isActive();
    }

    /**
     * Kiểm tra user admin.
     */
    public boolean isAdmin(User user) {
        return user != null && user.isAdmin();
    }
}


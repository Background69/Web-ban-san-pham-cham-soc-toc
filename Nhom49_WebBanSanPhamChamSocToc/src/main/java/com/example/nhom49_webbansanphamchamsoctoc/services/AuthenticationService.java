package com.example.nhom49_webbansanphamchamsoctoc.services;

import com.example.nhom49_webbansanphamchamsoctoc.dao.UserDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import com.example.nhom49_webbansanphamchamsoctoc.util.PasswordUtil;
import com.example.nhom49_webbansanphamchamsoctoc.util.ValidationUtil;
import jakarta.servlet.http.HttpSession;

public class AuthenticationService {

    private final UserDAO userDAO;
    private String lastError;

    public AuthenticationService() {
        this.userDAO = new UserDAO();
    }

    public String getLastError() {
        return lastError;
    }

    public User login(String emailOrUsername, String password) {
        lastError = null;

        if (ValidationUtil.isEmpty(emailOrUsername) || ValidationUtil.isEmpty(password)) {
            lastError = "Vui lòng nhập đầy đủ thông tin";
            return null;
        }

        String key = emailOrUsername.trim();

        User user = userDAO.findByEmail(key);
        if (user == null) user = userDAO.findByUsername(key);
        if (user == null) {
            lastError = "Email/tên đăng nhập hoặc mật khẩu không đúng";
            return null;
        }

        if (!user.isActive()) {
            lastError = "Tài khoản đã bị khóa";
            return null;
        }

        if (!PasswordUtil.verifyPassword(password, user.getPassword())) {
            lastError = "Email/tên đăng nhập hoặc mật khẩu không đúng";
            return null;
        }

        if (!user.isVerified()) {
            lastError = "Tài khoản chưa được xác minh";
            return null;
        }

        return user;
    }

    // REGISTER: trả về User nếu thành công, null nếu thất bại
    public User register(String email, String username, String phone,
                         String password, String confirmPassword) {
        lastError = null;

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

        String emailTrim = email.trim();
        String usernameTrim = username.trim();
        String phoneTrim = phone.trim();

        if (userDAO.existsByEmail(emailTrim)) {
            lastError = "Email đã được sử dụng";
            return null;
        }
        if (userDAO.existsByUsername(usernameTrim)) {
            lastError = "Username đã được sử dụng";
            return null;
        }
        if (userDAO.existsByPhone(phoneTrim)) {
            lastError = "Số điện thoại đã được sử dụng";
            return null;
        }

        User u = new User();
        u.setEmail(emailTrim);
        u.setUsername(usernameTrim);
        u.setPhone(phoneTrim);
        u.setPassword(PasswordUtil.hashPassword(password));

        u.setAvatar("avatar/avatar.jpg");
        u.setRole("Khách hàng");
        u.setActive(true);

        // Vì bạn muốn bỏ verify/email token nên để true cho giống code cũ của bạn
        u.setVerified(true);

        u.setAuthProvider("LOCAL");
        u.setVerificationToken(null);
        u.setResetToken(null);
        u.setResetTokenExpiry(null);

        int id = userDAO.insert(u);
        if (id > 0) {
            u.setUserId(id);
            return u;
        }

        lastError = "Đăng ký thất bại (không insert được)";
        return null;
    }

    public void logout(HttpSession session) {
        if (session != null) session.invalidate();
    }

    public boolean isActiveUser(User user) {
        return user != null && user.isActive();
    }

    public void setCurrentUser(HttpSession session, User user) {
        if (session != null) session.setAttribute("currentUser", user);
    }
}

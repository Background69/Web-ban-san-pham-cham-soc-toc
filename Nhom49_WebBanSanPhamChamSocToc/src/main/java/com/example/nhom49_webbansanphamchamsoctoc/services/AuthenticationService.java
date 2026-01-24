package com.example.nhom49_webbansanphamchamsoctoc.services;

import com.example.nhom49_webbansanphamchamsoctoc.dao.UserDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import com.example.nhom49_webbansanphamchamsoctoc.util.PasswordUtil;
import com.example.nhom49_webbansanphamchamsoctoc.util.ValidationUtil;
import com.example.nhom49_webbansanphamchamsoctoc.util.SessionUtil;


import jakarta.servlet.http.HttpSession;

/**
 * Service chuyên xử lý authentication (đăng nhập, đăng ký, session)
 * Tách biệt với UserService để quản lý user
 */
public class AuthenticationService {

    private static final int VERIFICATION_TOKEN_EXPIRY_HOURS = 24;
    private final UserDAO userDAO;
    private String lastError;

    public AuthenticationService() {
        this.userDAO = new UserDAO();
    }
    /**
     * Thực hiện registration result.
     */
    public String getLastError() {
        return lastError;
    }

    public User login(String emailOrUsername, String password) {
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
        if (!user.isActive()) {
            lastError = "Tài khoản đã bị khóa";
            return null;
        }
        if (!PasswordUtil.verifyPassword(password, user.getPassword())) {
            lastError = "Mật khẩu không đúng";
            return null;
        }

        return user;
    }

    public User register(String email, String username, String phone, String password, String confirmPassword) {
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

        if (userDAO.existsByEmail(email.trim())) {
            lastError = "Email đã tồn tại";
            return null;
        }

        if (userDAO.existsByUsername(username.trim())) {
            lastError = "Tên đăng nhập đã tồn tại";
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

        int userId = userDAO.insert(user);
        if (userId > 0) {
            user.setUserId(userId);
            return user;
        }

        lastError = "Đăng ký thất bại, vui lòng thử lại";
        return null;
    }

    public void setCurrentUser(HttpSession session, User user) {
        SessionUtil.setCurrentUser(session, user);
    }

    public void logout(HttpSession session) {
        if (session != null) {
            session.removeAttribute("user");
            session.removeAttribute("cart");
            session.invalidate();
        }
    }



    public boolean isActiveUser(User user) {
        return user != null && user.isActive();
    }

}


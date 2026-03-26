package com.example.nhom49_webbansanphamchamsoctoc.services;

import com.example.nhom49_webbansanphamchamsoctoc.dao.UserDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import com.example.nhom49_webbansanphamchamsoctoc.util.PasswordUtil;
import com.example.nhom49_webbansanphamchamsoctoc.util.ValidationUtil;
import com.example.nhom49_webbansanphamchamsoctoc.util.SessionUtil;


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

    public boolean validateUserInput(String email, String fullname, String username, String phone, String password, String confirmPassword) {
        lastError = null;
        String emailError = ValidationUtil.validateEmail(email);
        if (emailError != null) {
            lastError = emailError;
            return false;
        }

        String fullnameError = ValidationUtil.validateFullName(fullname);
        if (fullnameError != null) {
            lastError = fullnameError;
            return false;
        }

        String usernameError = ValidationUtil.validateUsername(username);
        if (usernameError != null) {
            lastError = usernameError;
            return false;
        }

        String passwordError = ValidationUtil.validatePassword(password);
        if (passwordError != null) {
            lastError = passwordError;
            return false;
        }

        String phoneError = ValidationUtil.validatePhone(phone);
        if (phoneError != null) {
            lastError = phoneError;
            return false;
        }

        String confirmError = ValidationUtil.validateConfirmPassword(password, confirmPassword);
        if (confirmError != null) {
            lastError = confirmError;
            return false;
        }

        if (userDAO.existsByEmail(email.trim())) {
            lastError = "Email đã tồn tại";
            return false;
        }

        if (userDAO.existsByUsername(username.trim())) {
            lastError = "Tên đăng nhập đã tồn tại";
            return false;
        }

        lastError = null;
        return true;
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


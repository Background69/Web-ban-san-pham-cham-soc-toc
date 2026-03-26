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

    public String validateUserInput(String email, String fullname, String username, String phone, String password, String confirmPassword) {
        email = ValidationUtil.sanitize(email);
        fullname = ValidationUtil.sanitize(fullname);
        username = ValidationUtil.sanitize(username);
        phone = ValidationUtil.sanitize(phone);

        String error;
        if ((error = ValidationUtil.validateEmail(email)) != null) return error;
        if ((error = ValidationUtil.validateFullName(fullname)) != null) return error;
        if ((error = ValidationUtil.validateUsername(username)) != null) return error;
        if ((error = ValidationUtil.validatePassword(password)) != null) return error;
        if ((error = ValidationUtil.validatePhone(phone)) != null) return error;
        if ((error = ValidationUtil.validateConfirmPassword(password, confirmPassword)) != null) return error;

        if (userDAO.existsByEmail(email)) return "Email đã tồn tại";
        if (userDAO.existsByUsername(username)) return "Tên đăng nhập đã tồn tại";

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


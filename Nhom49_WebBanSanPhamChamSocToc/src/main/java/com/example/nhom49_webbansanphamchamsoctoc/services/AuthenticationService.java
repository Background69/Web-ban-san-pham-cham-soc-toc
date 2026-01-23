package com.example.nhom49_webbansanphamchamsoctoc.services;

import com.example.nhom49_webbansanphamchamsoctoc.dao.UserDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import com.example.nhom49_webbansanphamchamsoctoc.util.PasswordUtil;
import com.example.nhom49_webbansanphamchamsoctoc.util.ValidationUtil;

import jakarta.servlet.http.HttpSession;

public class AuthenticationService {

    private final UserDAO userDAO;

    public AuthenticationService() {
        this.userDAO = new UserDAO();
    }

    public record RegisterResult(boolean success, String message, User user) {}

    public User login(String emailOrUsername, String password) {

        if (ValidationUtil.isEmpty(emailOrUsername) || ValidationUtil.isEmpty(password)) {
            return null;
        }

        User user = userDAO.findByEmail(emailOrUsername.trim());
        if (user == null) user = userDAO.findByUsername(emailOrUsername.trim());
        if (user == null) return null;

        if (!user.isActive()) return null;

        if (!PasswordUtil.verifyPassword(password, user.getPassword())) {
            return null;
        }

         if (!user.isVerified()) return null;

        return user;
    }

    // ====== REGISTER (theo DB schema bạn gửi) ======
    public RegisterResult register(String email, String username, String phone,
                                   String password, String confirmPassword) {

        String emailError = ValidationUtil.validateEmail(email);
        if (emailError != null) return new RegisterResult(false, emailError, null);

        String usernameError = ValidationUtil.validateUsername(username);
        if (usernameError != null) return new RegisterResult(false, usernameError, null);

        String passwordError = ValidationUtil.validatePassword(password);
        if (passwordError != null) return new RegisterResult(false, passwordError, null);

        String phoneError = ValidationUtil.validatePhone(phone);
        if (phoneError != null) return new RegisterResult(false, phoneError, null);

        String confirmError = ValidationUtil.validateConfirmPassword(password, confirmPassword);
        if (confirmError != null) return new RegisterResult(false, confirmError, null);

        if (userDAO.existsByEmail(email.trim())) {
            return new RegisterResult(false, "Email đã được sử dụng", null);
        }
        if (userDAO.existsByUsername(username.trim())) {
            return new RegisterResult(false, "Username đã được sử dụng", null);
        }
        if (userDAO.existsByPhone(phone.trim())) {
            return new RegisterResult(false, "Số điện thoại đã được sử dụng", null);
        }

        User u = new User();
        u.setEmail(email.trim());
        u.setUsername(username.trim());
        u.setPhone(phone.trim());
        u.setPassword(PasswordUtil.hashPassword(password));

        u.setAvatar("avatar/avatar.jpg");
        u.setRole("Khách hàng");
        u.setActive(true);

        u.setVerified(true);

        u.setAuthProvider("LOCAL");

        u.setVerificationToken(null);
        u.setResetToken(null);
        u.setResetTokenExpiry(null);

        int id = userDAO.insert(u);
        if (id > 0) {
            u.setUserId(id);
            return new RegisterResult(true, "Đăng ký thành công", u);
        }

        return new RegisterResult(false, "Đăng ký thất bại (không insert được)", null);
    }



    public void logout(HttpSession session) {
        if (session != null) {
            session.invalidate();
        }
    }

    public boolean isActiveUser(User user) {
        return user != null && user.isActive();
    }

    public void setCurrentUser(HttpSession session, User user) {
        if (session != null) {
            session.setAttribute("currentUser", user);
        }
    }
}

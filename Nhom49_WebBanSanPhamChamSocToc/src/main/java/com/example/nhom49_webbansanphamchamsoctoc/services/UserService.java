package com.example.nhom49_webbansanphamchamsoctoc.services;

import com.example.nhom49_webbansanphamchamsoctoc.dao.UserDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import com.example.nhom49_webbansanphamchamsoctoc.util.PasswordUtil;
import com.example.nhom49_webbansanphamchamsoctoc.util.ValidationUtil;
import jakarta.servlet.http.HttpSession;

import java.util.List;

/**
 * Service class cho User management
 * Xử lý CRUD user, Google OAuth
 * Authentication được xử lý bởi AuthService
 */
public class UserService {

    private final UserDAO userDAO;
    private final AuthenticationService authService;

    public UserService() {
        this.userDAO = new UserDAO();
        this.authService = new AuthenticationService();
    }

    /**
     * Đăng nhập user - AuthService
     */
    public User login(String emailOrUsername, String password) {
        return authService.login(emailOrUsername, password);
    }

    /**
     * Kiểm tra active user.

     */
    public boolean isActiveUser(User user) {
        return authService.isActiveUser(user);
    }

    /**
     * Thực hiện register.
     */
    public User register(String email, String username, String password) {
        if (!isValidEmail(email) || !isValidUsername(username) || !PasswordUtil.isValidPassword(password)) {
            return null;
        }

        if (userDAO.existsByEmail(email) || userDAO.existsByUsername(username)) {
            return null;
        }

        User user = new User();
        user.setEmail(email);
        user.setUsername(username);
        user.setPassword(PasswordUtil.hashPassword(password));
        user.setRole("Khách hàng");
        user.setActive(true);
        user.setAuthProvider("LOCAL");
        user.setVerified(true);
        user.setVerificationToken(null);

        int userId = userDAO.insert(user);
        if (userId > 0) {
            user.setUserId(userId);
            return user;
        }
        return null;
    }

    /**
     * Kiểm tra email exists.

     */
    public boolean isEmailExists(String email) {
        return userDAO.existsByEmail(email);
    }

    /**
     * Lấy all users.
     */
    public List<User> getAllUsers() {
        return userDAO.findAll();
    }

    /**
     * Lấy user by id.

     */
    public User getUserById(int userId) {
        return userDAO.findById(userId);
    }

    /**
     * Lấy user by email.
     */
    public User getUserByEmail(String email) {
        return userDAO.findByEmail(email);
    }

    /**
     * Thực hiện change password.
     */
    public boolean changePassword(int userId, String oldPassword, String newPassword) {
        User user = userDAO.findById(userId);
        if (user == null || !PasswordUtil.verifyPassword(oldPassword, user.getPassword())) {
            return false;
        }

        if (!PasswordUtil.isValidPassword(newPassword)) {
            return false;
        }

        String hashedNewPassword = PasswordUtil.hashPassword(newPassword);
        return userDAO.updatePassword(userId, hashedNewPassword);
    }

    /**
     * Tìm hoặc tạo google user.

     */
    public User findOrCreateGoogleUser(GoogleOAuthService.GoogleUserInfo googleInfo) {
        if (googleInfo == null || googleInfo.getGoogleId() == null) {
            return null;
        }

        User existingUser = userDAO.findByGoogleId(googleInfo.getGoogleId());
        if (existingUser != null) {
            return existingUser;
        }

        existingUser = userDAO.findByEmail(googleInfo.getEmail());
        if (existingUser != null) {
            userDAO.updateGoogleId(existingUser.getUserId(), googleInfo.getGoogleId());
            existingUser.setGoogleId(googleInfo.getGoogleId());
            return existingUser;
        }

        User newUser = new User();
        newUser.setEmail(googleInfo.getEmail());
        newUser.setUsername(generateUsernameFromGoogleName(googleInfo.getName(), googleInfo.getEmail()));
        newUser.setPassword(null);
        newUser.setAvatar(googleInfo.getPicture());
        newUser.setGoogleId(googleInfo.getGoogleId());
        newUser.setRole("Khách hàng");
        newUser.setActive(true);
        newUser.setAuthProvider("GOOGLE");
        newUser.setVerified(true);

        int userId = userDAO.insert(newUser);
        if (userId > 0) {
            newUser.setUserId(userId);
            return newUser;
        }

        return null;
    }

    /**
     * Thực hiện link google account.
     */
    public boolean linkGoogleAccount(int userId, String googleId) {
        if (googleId == null || googleId.isEmpty()) {
            return false;
        }

        User existingUser = userDAO.findByGoogleId(googleId);
        if (existingUser != null && existingUser.getUserId() != userId) {
            return false;
        }

        return userDAO.updateGoogleId(userId, googleId);
    }

    /**
     * Tim by google id.
     */
    public User findByGoogleId(String googleId) {
        if (googleId == null || googleId.isEmpty()) {
            return null;
        }
        return userDAO.findByGoogleId(googleId);
    }

    /**
     * Sinh username from google name.
     */
    private String generateUsernameFromGoogleName(String name, String email) {
        String baseUsername;

        if (name != null && !name.isEmpty()) {
            baseUsername = name.replaceAll("[^A-Za-z0-9]", "").toLowerCase();
        } else {
            baseUsername = email.split("@")[0].replaceAll("[^A-Za-z0-9]", "").toLowerCase();
        }

        if (baseUsername.length() < 3) {
            baseUsername = baseUsername + "user";
        }

        String username = baseUsername;
        int counter = 1;
        while (userDAO.existsByUsername(username)) {
            username = baseUsername + counter;
            counter++;
        }

        return username;
    }

    /**
     * Kiểm tra email hop le.
     */
    private boolean isValidEmail(String email) {
        return ValidationUtil.validateEmail(email) == null;
    }

    /**
     * Kiểm tra username hop le.
     */
    private boolean isValidUsername(String username) {
        return ValidationUtil.validateUsername(username) == null;
    }

    /**
     * Lấy danh sách người dùng theo role.
     */
    public List<User> getUsersByRole(String role) {
        return userDAO.findByRole(role);
    }

    /**
     * Bật/tắt trạng thái active của người dùng.
     */
    public boolean toggleUserActive(int userId) {
        User user = userDAO.findById(userId);
        if (user == null) {
            return false;
        }
        return userDAO.updateActiveStatus(userId, !user.isActive());
    }

    /**
     * Thay đổi vai trò của người dùng.
     */
    public boolean changeUserRole(int userId, String newRole) {
        if (newRole == null || newRole.isEmpty()) {
            return false;
        }
        return userDAO.updateRole(userId, newRole);
    }

    public void setCurrentUser(HttpSession session, User user) {
    }

    public boolean updateProfile(User user) {
        return userDAO.update(user);
    }
}

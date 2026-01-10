package com.example.nhom49_webbansanphamchamsoctoc.services;

import com.example.nhom49_webbansanphamchamsoctoc.dao.UserDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import com.example.nhom49_webbansanphamchamsoctoc.util.PasswordUtil;

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
     * Đăng xuất user - AuthService
     */
    public void logout(HttpSession session) {
        authService.logout(session);
    }

    /**
     * Lấy user hiện tại từ session - AuthService
     */
    public User getCurrentUser(HttpSession session) {
        return authService.getCurrentUser(session);
    }

    /**
     * Lưu user vào session - AuthService
     */
    public void setCurrentUser(HttpSession session, User user) {
        authService.setCurrentUser(session, user);
    }

    /**
     * Kiểm tra user có phải admin không - AuthService
     */
    public boolean isAdmin(User user) {
        return authService.isAdmin(user);
    }

    /**
     * Kiểm tra user có active không - AuthService
     */
    public boolean isActiveUser(User user) {
        return authService.isActiveUser(user);
    }


    /**
     * Đăng ký user mới
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


    public boolean isEmailExists(String email) {
        return userDAO.existsByEmail(email);
    }

    public boolean isUsernameExists(String username) {
        return userDAO.existsByUsername(username);
    }

    public boolean validateRegistration(String email, String username, String password) {
        return isValidEmail(email) &&
                isValidUsername(username) &&
                PasswordUtil.isValidPassword(password) &&
                !isEmailExists(email) &&
                !isUsernameExists(username);
    }

    private boolean isValidEmail(String email) {
        return email != null &&
                email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
    }

    private boolean isValidUsername(String username) {
        return username != null &&
                username.length() >= 3 &&
                username.length() <= 50 &&
                username.matches("^[A-Za-z0-9_]+$");
    }


    public List<User> getAllUsers() {
        return userDAO.findAll();
    }

    public List<User> getUsersByRole(String role) {
        return userDAO.findByRole(role);
    }

    public User getUserById(int userId) {
        return userDAO.findById(userId);
    }

    public User getUserByEmail(String email) {
        return userDAO.findByEmail(email);
    }

    public boolean toggleUserActive(int userId) {
        User user = userDAO.findById(userId);
        if (user != null) {
            return userDAO.updateActiveStatus(userId, !user.isActive());
        }
        return false;
    }

    public boolean changeUserRole(int userId, String newRole) {
        if (newRole == null || (!newRole.equals("Admin") && !newRole.equals("Khách hàng"))) {
            return false;
        }
        return userDAO.updateRole(userId, newRole);
    }

    public boolean updateProfile(User user) {
        if (user == null || user.getUserId() <= 0) {
            return false;
        }
        return userDAO.update(user);
    }

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
     * Tìm hoặc tạo user từ thông tin Google OAuth
     */
//    public User findOrCreateGoogleUser(GoogleOAuthService.GoogleUserInfo googleInfo) {
//        if (googleInfo == null || googleInfo.getGoogleId() == null) {
//            return null;
//        }
//
//        User existingUser = userDAO.findByGoogleId(googleInfo.getGoogleId());
//        if (existingUser != null) {
//            return existingUser;
//        }
//
//        existingUser = userDAO.findByEmail(googleInfo.getEmail());
//        if (existingUser != null) {
//            userDAO.updateGoogleId(existingUser.getUserId(), googleInfo.getGoogleId());
//            existingUser.setGoogleId(googleInfo.getGoogleId());
//            return existingUser;
//        }
//
//        User newUser = new User();
//        newUser.setEmail(googleInfo.getEmail());
//        newUser.setUsername(generateUsernameFromGoogleName(googleInfo.getName(), googleInfo.getEmail()));
//        newUser.setPassword(null);
//        newUser.setAvatar(googleInfo.getPicture());
//        newUser.setGoogleId(googleInfo.getGoogleId());
//        newUser.setRole("Khách hàng");
//        newUser.setActive(true);
//        newUser.setAuthProvider("GOOGLE");
//        newUser.setVerified(true);
//
//        int userId = userDAO.insert(newUser);
//        if (userId > 0) {
//            newUser.setUserId(userId);
//            return newUser;
//        }
//
//        return null;
//    }

    /**
     * Liên kết tài khoản Google với user hiện có
     */
//    public boolean linkGoogleAccount(int userId, String googleId) {
//        if (googleId == null || googleId.isEmpty()) {
//            return false;
//        }
//
//        User existingUser = userDAO.findByGoogleId(googleId);
//        if (existingUser != null && existingUser.getUserId() != userId) {
//            return false;
//        }
//
//        return userDAO.updateGoogleId(userId, googleId);
//    }
//
//    /**
//     * Tìm user theo Google ID
//     */
//    public User findByGoogleId(String googleId) {
//        if (googleId == null || googleId.isEmpty()) {
//            return null;
//        }
//        return userDAO.findByGoogleId(googleId);
//    }
//
//    /**
//     * Tạo username từ tên Google
//     */
//    private String generateUsernameFromGoogleName(String name, String email) {
//        String baseUsername;
//
//        if (name != null && !name.isEmpty()) {
//            baseUsername = name.replaceAll("[^A-Za-z0-9]", "").toLowerCase();
//        } else {
//            baseUsername = email.split("@")[0].replaceAll("[^A-Za-z0-9]", "").toLowerCase();
//        }
//
//        if (baseUsername.length() < 3) {
//            baseUsername = baseUsername + "user";
//        }
//
//        String username = baseUsername;
//        int counter = 1;
//        while (userDao.existsByUsername(username)) {
//            username = baseUsername + counter;
//            counter++;
//        }
//
//        return username;
//    }
}

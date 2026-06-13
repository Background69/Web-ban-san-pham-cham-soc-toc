package com.example.nhom49_webbansanphamchamsoctoc.services;

import com.example.nhom49_webbansanphamchamsoctoc.dao.UserStatusHistoryDAO;
import com.example.nhom49_webbansanphamchamsoctoc.dao.UserDAO;
import com.example.nhom49_webbansanphamchamsoctoc.database.JDBIConnector;
import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import com.example.nhom49_webbansanphamchamsoctoc.model.UserStatusHistory;

import java.util.List;

public class UserService {

    private final UserDAO userDAO;
    private final UserStatusHistoryDAO userStatusHistoryDAO;
    private final AuthenticationService authService;
    private String lastError;

    public UserService() {
        this.userDAO = new UserDAO();
        this.userStatusHistoryDAO = new UserStatusHistoryDAO();
        this.authService = new AuthenticationService();
    }

    public String getLastError() {
        return lastError;
    }

    public User login(String emailOrUsername, String password, String ipAddress) {
        return authService.login(emailOrUsername, password, ipAddress);
    }

    public List<User> getAllUsers() {
        return userDAO.findAll();
    }

    public User getUserById(int userId) {
        return userDAO.findById(userId);
    }

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
        int userId = userDAO.insert(newUser);
        if (userId > 0) {
            newUser.setUserId(userId);
            return newUser;
        }

        return null;
    }

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

    public boolean toggleUserActive(int userId) {
        lastError = null;
        User user = userDAO.findById(userId);
        if (user == null) {
            lastError = "Không tìm thấy tài khoản người dùng.";
            return false;
        }
        String action = user.isActive() ? "LOCK" : "UNLOCK";
        String detail = user.isActive()
                ? "Tạm khóa tài khoản từ thao tác quản trị."
                : "Mở khóa tài khoản từ thao tác quản trị.";
        return setUserActiveStatusWithHistory(user, !user.isActive(), action, "OTHER", detail);
    }

    public boolean setUserActiveStatusWithHistory(User user, boolean isActive, String action,
                                                  String reasonCode, String reasonDetail) {
        lastError = null;
        if (user == null) {
            lastError = "Không tìm thấy tài khoản người dùng.";
            return false;
        }
        try {
            return JDBIConnector.getInstance().inTransaction(handle -> {
                boolean statusUpdated = userDAO.updateActiveStatus(handle, user.getUserId(), isActive);
                if (!statusUpdated) {
                    throw new IllegalStateException("Không thể cập nhật trạng thái tài khoản.");
                }
                UserStatusHistory history = new UserStatusHistory();
                history.setUserId(user.getUserId());
                history.setAction(action);
                history.setReasonCode(reasonCode);
                history.setReasonDetail(reasonDetail);
                long historyId = userStatusHistoryDAO.insertHistory(handle, history);
                if (historyId <= 0) {
                    throw new IllegalStateException("Không thể lưu lịch sử xử lý tài khoản.");
                }
                return true;
            });
        } catch (Exception ex) {
            lastError = ex.getMessage() != null && !ex.getMessage().isBlank()
                    ? ex.getMessage()
                    : "Không thể xử lý trạng thái tài khoản.";
            return false;
        }
    }

    public boolean updateProfile(User user) {
        return userDAO.update(user);
    }
}

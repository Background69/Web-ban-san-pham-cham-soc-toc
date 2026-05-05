package com.example.nhom49_webbansanphamchamsoctoc.services;

import com.example.nhom49_webbansanphamchamsoctoc.dao.UserDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.User;

import java.util.List;

public class UserService {

    private final UserDAO userDAO;
    private final AuthenticationService authService;

    public UserService() {
        this.userDAO = new UserDAO();
        this.authService = new AuthenticationService();
    }

    public User login(String emailOrUsername, String password) {
        return authService.login(emailOrUsername, password);
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
        User user = userDAO.findById(userId);
        if (user == null) {
            return false;
        }
        return userDAO.updateActiveStatus(userId, !user.isActive());
    }

    public boolean updateProfile(User user) {
        return userDAO.update(user);
    }
}

package com.example.nhom49_webbansanphamchamsoctoc.dao;

import com.example.nhom49_webbansanphamchamsoctoc.database.JDBIConnector;
import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import com.example.nhom49_webbansanphamchamsoctoc.util.PasswordUtil;
import org.jdbi.v3.core.Jdbi;

import java.util.List;
import java.util.Objects;

public class UserDAO implements IDAO<User> {

    private final Jdbi jdbi;

    public UserDAO() {
        this.jdbi = JDBIConnector.getInstance();
    }

    @Override
    public List<User> findAll() {
        String sql = "SELECT * FROM users ORDER BY created_at DESC";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .map((rs, ctx) -> mapUser(rs))
                .list());
    }

    /**
     * Đếm tổng số người dùng
     */
    public int countAll() {
        String sql = "SELECT COUNT(*) FROM users";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .mapTo(Integer.class)
                .findFirst()
                .orElse(0));
    }

    @Override
    public int insert(User user) {
        String sql = "INSERT INTO users (email, username, password, phone, avatar, role, is_active, google_id, auth_provider, reset_token_expiry) "
                +
                "VALUES (:email, :username, :password, :phone, :avatar, :role, :isActive, :googleId, :authProvider, :resetTokenExpiry)";
        return jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("email", user.getEmail())
                .bind("username", user.getUsername())
                .bind("password", user.getPassword())
                .bind("phone", user.getPhone())
                .bind("avatar", user.getAvatar() != null ? user.getAvatar() : "avatar/avatar.jpg")
                .bind("role", user.getRole() != null ? user.getRole() : "Khách hàng")
                .bind("isActive", user.isActive())
                .bind("googleId", user.getGoogleId())
                .bind("authProvider", user.getAuthProvider())
                .bind("resetTokenExpiry", user.getResetTokenExpiry())
                .executeAndReturnGeneratedKeys("user_id")
                .mapTo(Integer.class)
                .findFirst()
                .orElse(-1));
    }

    @Override
    public boolean update(User user) {
        String sql = "UPDATE users SET email = :email, username = :username, phone = :phone, avatar = :avatar, role = :role, is_active = :isActive "
                +
                "WHERE user_id = :userId";
        int rowsAffected = jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("email", user.getEmail())
                .bind("username", user.getUsername())
                .bind("phone", user.getPhone())
                .bind("avatar", user.getAvatar())
                .bind("role", user.getRole())
                .bind("isActive", user.isActive())
                .bind("userId", user.getUserId())
                .execute());
        return rowsAffected > 0;
    }

    @Override
    public boolean delete(int id) {
        String sql = "DELETE FROM users WHERE user_id = :userId";
        int rowsAffected = jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("userId", id)
                .execute());
        return rowsAffected > 0;
    }

    @Override
    public User findById(int id) {
        String sql = "SELECT * FROM users WHERE user_id = :id";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("id", id)
                .map((rs, ctx) -> mapUser(rs))
                .findFirst()
                .orElse(null));
    }

    // Authentication methods

    public User findByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = :email";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("email", email)
                .map((rs, ctx) -> mapUser(rs))
                .findFirst()
                .orElse(null));
    }

    public User findByUsername(String username) {
        String sql = "SELECT * FROM users WHERE username = :username";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("username", username)
                .map((rs, ctx) -> mapUser(rs))
                .findFirst()
                .orElse(null));
    }

    public User authenticate(String emailOrUsername, String password) {
        User user = findByEmail(emailOrUsername);
        if (user == null) {
            user = findByUsername(emailOrUsername);
        }

        if (user != null && user.isActive() && PasswordUtil.verifyPassword(password, user.getPassword())) {
            return user;
        }
        return null;
    }

    public boolean existsByEmail(String email) {
        String sql = "SELECT COUNT(*) FROM users WHERE email = :email";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("email", email)
                .mapTo(Integer.class)
                .findFirst()
                .orElse(0) > 0);
    }

    public boolean existsByUsername(String username) {
        String sql = "SELECT COUNT(*) FROM users WHERE username = :username";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("username", username)
                .mapTo(Integer.class)
                .findFirst()
                .orElse(0) > 0);
    }

    public boolean existsByPhone(String phone) {
        if (phone == null || phone.isBlank()) {
            return false;
        }
        String sql = "SELECT COUNT(*) FROM users WHERE phone = :phone";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("phone", phone.trim())
                .mapTo(Integer.class)
                .findFirst()
                .orElse(0) > 0);
    }

    // Google OAuth methods

    public User findByGoogleId(String googleId) {
        if (googleId == null || googleId.isEmpty()) {
            return null;
        }
        String sql = "SELECT * FROM users WHERE google_id = :googleId";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("googleId", googleId)
                .map((rs, ctx) -> mapUser(rs))
                .findFirst()
                .orElse(null));
    }

    public boolean updateGoogleId(int userId, String googleId) {
        String sql = "UPDATE users SET google_id = :googleId WHERE user_id = :userId";
        int rowsAffected = jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("googleId", googleId)
                .bind("userId", userId)
                .execute());
        return rowsAffected > 0;
    }

    // User management methods

    public List<User> findByRole(String role) {
        String sql = "SELECT * FROM users WHERE role = :role ORDER BY created_at DESC";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("role", role)
                .map((rs, ctx) -> mapUser(rs))
                .list());
    }

    public boolean updateActiveStatus(int userId, boolean isActive) {
        String sql = "UPDATE users SET is_active = :isActive WHERE user_id = :userId";
        int rowsAffected = jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("isActive", isActive)
                .bind("userId", userId)
                .execute());
        return rowsAffected > 0;
    }

    public boolean updateRole(int userId, String role) {
        String sql = "UPDATE users SET role = :role WHERE user_id = :userId";
        int rowsAffected = jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("role", role)
                .bind("userId", userId)
                .execute());
        return rowsAffected > 0;
    }

    public boolean updatePassword(int userId, String hashedPassword) {
        String sql = "UPDATE users SET password = :password, reset_token = NULL, reset_token_expiry = NULL WHERE user_id = :userId";
        int rowsAffected = jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("password", hashedPassword)
                .bind("userId", userId)
                .execute());
        return rowsAffected > 0;
    }

    public boolean saveResetToken(int userId, String tokenHash, java.sql.Timestamp expiry) {
        String sql = "UPDATE users SET reset_token = :resetToken, reset_token_expiry = :resetTokenExpiry WHERE user_id = :userId";
        int rowsAffected = jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("resetToken", tokenHash)
                .bind("resetTokenExpiry", expiry)
                .bind("userId", userId)
                .execute());
        return rowsAffected > 0;
    }

    public User findByResetToken(String tokenHash) {
        if (tokenHash == null || tokenHash.isBlank()) {
            return null;
        }
        String sql = "SELECT * FROM users WHERE reset_token = :resetToken";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("resetToken", tokenHash)
                .map((rs, ctx) -> mapUser(rs))
                .findFirst()
                .orElse(null));
    }

    // Helper method to map ResultSet to User
    private User mapUser(java.sql.ResultSet rs) throws java.sql.SQLException {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setEmail(rs.getString("email"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setPhone(rs.getString("phone"));
        user.setAvatar(rs.getString("avatar"));
        user.setRole(rs.getString("role"));
        user.setActive(rs.getBoolean("is_active"));
        user.setAuthProvider(rs.getString("auth_provider"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        user.setGoogleId(rs.getString("google_id"));
        if (user.getAuthProvider() == null || user.getAuthProvider().isEmpty()) {
            user.setAuthProvider("LOCAL");
        }
        user.setResetToken(rs.getString("reset_token"));
        user.setResetTokenExpiry(rs.getTimestamp("reset_token_expiry"));
        return user;
    }

}

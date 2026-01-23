package com.example.nhom49_webbansanphamchamsoctoc.dao;

import com.example.nhom49_webbansanphamchamsoctoc.database.JDBIConnector;
import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import com.example.nhom49_webbansanphamchamsoctoc.util.PasswordUtil;
import org.jdbi.v3.core.Jdbi;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.List;

public class UserDAO implements IDAO<User> {

    private final Jdbi jdbi;

    public UserDAO() {
        this.jdbi = JDBIConnector.getInstance();
    }

    // =================== BASIC CRUD ===================

    @Override
    public List<User> findAll() {
        String sql = "SELECT * FROM users ORDER BY created_at DESC";
        return jdbi.withHandle(h ->
                h.createQuery(sql)
                        .map((rs, ctx) -> mapUser(rs))
                        .list()
        );
    }

    @Override
    public int insert(User user) {
        String sql = """
                INSERT INTO users
                (email, username, password, phone, avatar, role, is_active,
                 google_id, auth_provider, is_verified, verification_token, reset_token_expiry)
                VALUES
                (:email, :username, :password, :phone, :avatar, :role, :isActive,
                 :googleId, :authProvider, :isVerified, :verificationToken, :resetTokenExpiry)
                """;

        return jdbi.withHandle(h ->
                h.createUpdate(sql)
                        .bind("email", user.getEmail())
                        .bind("username", user.getUsername())
                        .bind("password", user.getPassword())
                        .bind("phone", user.getPhone())
                        .bind("avatar", user.getAvatar() != null ? user.getAvatar() : "avatar/avatar.jpg")
                        .bind("role", user.getRole() != null ? user.getRole() : "Khách hàng")
                        .bind("isActive", user.isActive())
                        .bind("googleId", user.getGoogleId())
                        .bind("authProvider", user.getAuthProvider())
                        .bind("isVerified", user.isVerified())
                        .bind("verificationToken", user.getVerificationToken())
                        .bind("resetTokenExpiry", user.getResetTokenExpiry())
                        .executeAndReturnGeneratedKeys("user_id")
                        .mapTo(Integer.class)
                        .one()
        );
    }

    @Override
    public boolean update(User user) {
        String sql = """
                UPDATE users
                SET email = :email,
                    username = :username,
                    phone = :phone,
                    avatar = :avatar,
                    role = :role,
                    is_active = :isActive
                WHERE user_id = :userId
                """;

        return jdbi.withHandle(h ->
                h.createUpdate(sql)
                        .bind("email", user.getEmail())
                        .bind("username", user.getUsername())
                        .bind("phone", user.getPhone())
                        .bind("avatar", user.getAvatar())
                        .bind("role", user.getRole())
                        .bind("isActive", user.isActive())
                        .bind("userId", user.getUserId())
                        .execute() > 0
        );
    }

    @Override
    public boolean delete(int id) {
        String sql = "DELETE FROM users WHERE user_id = :id";
        return jdbi.withHandle(h ->
                h.createUpdate(sql)
                        .bind("id", id)
                        .execute() > 0
        );
    }

    @Override
    public User findById(int id) {
        String sql = "SELECT * FROM users WHERE user_id = :id";
        return jdbi.withHandle(h ->
                h.createQuery(sql)
                        .bind("id", id)
                        .map((rs, ctx) -> mapUser(rs))
                        .findFirst()
                        .orElse(null)
        );
    }

    // =================== AUTH ===================

    public User findByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = :email";
        return jdbi.withHandle(h ->
                h.createQuery(sql)
                        .bind("email", email)
                        .map((rs, ctx) -> mapUser(rs))
                        .findFirst()
                        .orElse(null)
        );
    }

    public User findByUsername(String username) {
        String sql = "SELECT * FROM users WHERE username = :username";
        return jdbi.withHandle(h ->
                h.createQuery(sql)
                        .bind("username", username)
                        .map((rs, ctx) -> mapUser(rs))
                        .findFirst()
                        .orElse(null)
        );
    }

    public User authenticate(String emailOrUsername, String password) {
        User user = findByEmail(emailOrUsername);
        if (user == null) {
            user = findByUsername(emailOrUsername);
        }

        if (user != null && user.isActive()
                && PasswordUtil.verifyPassword(password, user.getPassword())) {
            return user;
        }
        return null;
    }

    // =================== EXISTS ===================

    public boolean existsByEmail(String email) {
        String sql = "SELECT COUNT(*) FROM users WHERE email = :email";
        return jdbi.withHandle(h ->
                h.createQuery(sql)
                        .bind("email", email)
                        .mapTo(Integer.class)
                        .one() > 0
        );
    }

    public boolean existsByUsername(String username) {
        String sql = "SELECT COUNT(*) FROM users WHERE username = :username";
        return jdbi.withHandle(h ->
                h.createQuery(sql)
                        .bind("username", username)
                        .mapTo(Integer.class)
                        .one() > 0
        );
    }

    public boolean existsByPhone(String phone) {
        if (phone == null || phone.isBlank()) return false;
        String sql = "SELECT COUNT(*) FROM users WHERE phone = :phone";
        return jdbi.withHandle(h ->
                h.createQuery(sql)
                        .bind("phone", phone.trim())
                        .mapTo(Integer.class)
                        .one() > 0
        );
    }

    // =================== COUNT ===================

    public int countUsers() {
        return jdbi.withHandle(h ->
                h.createQuery("SELECT COUNT(*) FROM users")
                        .mapTo(Integer.class)
                        .one()
        );
    }

    // =================== MAPPER ===================

    private User mapUser(ResultSet rs) throws SQLException {
        User u = new User();
        u.setUserId(rs.getInt("user_id"));
        u.setEmail(rs.getString("email"));
        u.setUsername(rs.getString("username"));
        u.setPassword(rs.getString("password"));
        u.setPhone(rs.getString("phone"));
        u.setAvatar(rs.getString("avatar"));
        u.setRole(rs.getString("role"));
        u.setActive(rs.getBoolean("is_active"));
        u.setGoogleId(rs.getString("google_id"));
        u.setAuthProvider(rs.getString("auth_provider"));
        u.setVerified(rs.getBoolean("is_verified"));
        u.setVerificationToken(rs.getString("verification_token"));
        u.setResetToken(rs.getString("reset_token"));
        u.setResetTokenExpiry(rs.getTimestamp("reset_token_expiry"));
        u.setCreatedAt(rs.getTimestamp("created_at"));
        return u;
    }

    public int countUsers() {
            String sql = "SELECT COUNT(*) FROM users";
            return jdbi.withHandle(handle ->
                    handle.createQuery(sql)
                            .mapTo(Integer.class)
                            .findFirst()
                            .orElse(0)
            );

    }
}

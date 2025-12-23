package com.example.nhom49_webbansanphamchamsoctoc.dao;

import com.example.nhom49_webbansanphamchamsoctoc.database.JDBIConnector;
import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import org.jdbi.v3.core.Jdbi;

import java.util.List;

public class UserDAO implements IDAO<User> {
    private final Jdbi jdbi;

    public UserDAO(Jdbi jdbi) {
        this.jdbi = JDBIConnector.getInstance();
    }


    @Override
    public User findById(int id) {
        String sql = "SELECT * FROM users WHERE user_id = ?";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind(0, id)
                        .map((rs, ctx) -> mapUser(rs))
                        .findFirst()
                        .orElse(null)
        );
    }

    @Override
    public List<User> findAll() {
        String sql = "SELECT * FROM users ORDER BY created_at DESC";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .map((rs, ctx) -> mapUser(rs))
                        .list()
        );
    }

    @Override
    public int insert(User user) {
        String sql = "INSERT INTO users (email, username, password, phone, avatar, role, is_active) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";
        return jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind(0, user.getEmail())
                        .bind(1, user.getUsername())
                        .bind(2, user.getPassword())
                        .bind(3, user.getPhone())
                        .bind(4, user.getAvatar() != null ? user.getAvatar() : "avatar/avatar.jpg")
                        .bind(5, user.getRole() != null ? user.getRole() : "Khách hàng")
                        .bind(6, user.isActive())
                        .executeAndReturnGeneratedKeys("user_id")
                        .mapTo(Integer.class)
                        .findFirst()
                        .orElse(-1)
        );
    }

    @Override
    public boolean update(User user) {
        String sql = "UPDATE users SET email = ?, username = ?, phone = ?, avatar = ?, role = ?, is_active = ? " +
                "WHERE user_id = ?";
        int rowsAffected = jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind(0, user.getEmail())
                        .bind(1, user.getUsername())
                        .bind(2, user.getPhone())
                        .bind(3, user.getAvatar())
                        .bind(4, user.getRole())
                        .bind(5, user.isActive())
                        .bind(6, user.getUserId())
                        .execute()
        );
        return rowsAffected > 0;
    }

    @Override
    public boolean delete(int id) {
        String sql = "DELETE FROM users WHERE user_id = ?";
        int rowsAffected = jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind(0, id)
                        .execute()
        );
        return rowsAffected > 0;
    }

    // Authentication methods

    public User findByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind(0, email)
                        .map((rs, ctx) -> mapUser(rs))
                        .findFirst()
                        .orElse(null)
        );
    }

    public User findByUsername(String username) {
        String sql = "SELECT * FROM users WHERE username = ?";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind(0, username)
                        .map((rs, ctx) -> mapUser(rs))
                        .findFirst()
                        .orElse(null)
        );
    }


    /**
     * Xác thực user bằng email/username và password
     */
//    public User authenticate(String emailOrUsername, String password) {
//        User user = findByEmail(emailOrUsername);
//        if (user == null) {
//            user = findByUsername(emailOrUsername);
//        }
//
//        if (user != null && user.isActive() && PasswordUtil.verifyPassword(password, user.getPassword())) {
//            return user;
//        } chua xong utkl xu ly pass
//        return null;
//    }

    public boolean existsByEmail(String email) {
        String sql = "SELECT COUNT(*) FROM users WHERE email = ?";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind(0, email)
                        .mapTo(Integer.class)
                        .findFirst()
                        .orElse(0) > 0
        );
    }

    public boolean existsByUsername(String username) {
        String sql = "SELECT COUNT(*) FROM users WHERE username = ?";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind(0, username)
                        .mapTo(Integer.class)
                        .findFirst()
                        .orElse(0) > 0
        );
    }

    // Quan ly User
    public List<User> findByRole(String role) {
        String sql = "SELECT * FROM users WHERE role = ? ORDER BY created_at DESC";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind(0, role)
                        .map((rs, ctx) -> mapUser(rs))
                        .list()
        );
    }

    public boolean updateActiveStatus(int userId, boolean isActive) {
        String sql = "UPDATE users SET is_active = ? WHERE user_id = ?";
        int rowsAffected = jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind(0, isActive)
                        .bind(1, userId)
                        .execute()
        );
        return rowsAffected > 0;
    }

    public boolean updateRole(int userId, String role) {
        String sql = "UPDATE users SET role = ? WHERE user_id = ?";
        int rowsAffected = jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind(0, role)
                        .bind(1, userId)
                        .execute()
        );
        return rowsAffected > 0;
    }

    public boolean updatePassword(int userId, String hashedPassword) {
        String sql = "UPDATE users SET password = ? WHERE user_id = ?";
        int rowsAffected = jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind(0, hashedPassword)
                        .bind(1, userId)
                        .execute()
        );
        return rowsAffected > 0;
    }

    // Helper method de map ResultSet toi User
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
        user.setCreatedAt(rs.getTimestamp("created_at"));
        return user;
    }
}

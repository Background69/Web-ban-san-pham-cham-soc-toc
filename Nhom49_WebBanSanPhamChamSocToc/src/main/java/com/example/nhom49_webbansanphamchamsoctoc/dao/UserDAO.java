package com.example.nhom49_webbansanphamchamsoctoc.dao;

import com.example.nhom49_webbansanphamchamsoctoc.database.JDBIConnector;
import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import org.jdbi.v3.core.Jdbi;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class UserDAO implements IDAO<User> {

    private final Jdbi jdbi;

    public UserDAO() {
        this.jdbi = JDBIConnector.getInstance();
    }

    // ========== BASIC CRUD ==========

    @Override
    public User findById(int id) {
        String sql = "SELECT * FROM users WHERE user_id = :id";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("id", id)
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
        String sql = """
            INSERT INTO users (email, username, password, phone, avatar, role, is_active)
            VALUES (:email, :username, :password, :phone, :avatar, :role, :isActive)
        """;

        return jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("email", user.getEmail())
                        .bind("username", user.getUsername())
                        .bind("password", user.getPassword())
                        .bind("phone", user.getPhone())
                        .bind("avatar", user.getAvatar() != null ? user.getAvatar() : "avatar/avatar.jpg")
                        .bind("role", user.getRole() != null ? user.getRole() : "Khách hàng")
                        .bind("isActive", user.isActive())
                        .executeAndReturnGeneratedKeys("user_id")
                        .mapTo(Integer.class)
                        .findFirst()
                        .orElse(-1)
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
            WHERE user_id = :id
        """;

        int rows = jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("email", user.getEmail())
                        .bind("username", user.getUsername())
                        .bind("phone", user.getPhone())
                        .bind("avatar", user.getAvatar())
                        .bind("role", user.getRole())
                        .bind("isActive", user.isActive())
                        .bind("id", user.getUserId())
                        .execute()
        );

        return rows > 0;
    }

    @Override
    public boolean delete(int id) {
        String sql = "DELETE FROM users WHERE user_id = :id";
        int rows = jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("id", id)
                        .execute()
        );
        return rows > 0;
    }

    // ========== AUTHENTICATION SUPPORT ==========

    /**
     * Tìm user theo email hoặc username (dùng cho login)
     */
    public User findByEmailOrUsername(String value) {
        String sql = """
            SELECT * FROM users
            WHERE email = :v OR username = :v
        """;

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("v", value)
                        .map((rs, ctx) -> mapUser(rs))
                        .findFirst()
                        .orElse(null)
        );
    }

    public User findByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = :email";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("email", email)
                        .map((rs, ctx) -> mapUser(rs))
                        .findFirst()
                        .orElse(null)
        );
    }

    public User findByUsername(String username) {
        String sql = "SELECT * FROM users WHERE username = :username";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("username", username)
                        .map((rs, ctx) -> mapUser(rs))
                        .findFirst()
                        .orElse(null)
        );
    }

    public boolean existsByEmail(String email) {
        String sql = "SELECT COUNT(*) FROM users WHERE email = :email";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("email", email)
                        .mapTo(Integer.class)
                        .one() > 0
        );
    }

    public boolean existsByUsername(String username) {
        String sql = "SELECT COUNT(*) FROM users WHERE username = :username";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("username", username)
                        .mapTo(Integer.class)
                        .one() > 0
        );
    }

    // ========== ADMIN ==========

    public List<User> findByRole(String role) {
        String sql = "SELECT * FROM users WHERE role = :role ORDER BY created_at DESC";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("role", role)
                        .map((rs, ctx) -> mapUser(rs))
                        .list()
        );
    }

    public boolean updateActiveStatus(int userId, boolean isActive) {
        String sql = "UPDATE users SET is_active = :active WHERE user_id = :id";
        return jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("active", isActive)
                        .bind("id", userId)
                        .execute() > 0
        );
    }

    public boolean updateRole(int userId, String role) {
        String sql = "UPDATE users SET role = :role WHERE user_id = :id";
        return jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("role", role)
                        .bind("id", userId)
                        .execute() > 0
        );
    }

    public boolean updatePassword(int userId, String hashedPassword) {
        String sql = "UPDATE users SET password = :pass WHERE user_id = :id";
        return jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("pass", hashedPassword)
                        .bind("id", userId)
                        .execute() > 0
        );
    }

    // ========== MAPPER ==========

    private User mapUser(ResultSet rs) throws SQLException {
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

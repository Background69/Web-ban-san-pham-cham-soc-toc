package com.example.nhom49_webbansanphamchamsoctoc.dao;

import com.example.nhom49_webbansanphamchamsoctoc.database.JDBIConnector;
import com.example.nhom49_webbansanphamchamsoctoc.model.PendingRegistration;
import org.jdbi.v3.core.Jdbi;

import java.sql.Timestamp;

public class PendingRegistrationDAO {

    private final Jdbi jdbi;

    public PendingRegistrationDAO() {
        this.jdbi = JDBIConnector.getInstance();
    }

    public PendingRegistration findByEmail(String email) {
        String sql = "SELECT * FROM pending_registration WHERE email = :email";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("email", email)
                .map((rs, ctx) -> mapPending(rs))
                .findFirst()
                .orElse(null));
    }

    public boolean existsByEmail(String email) {
        String sql = "SELECT COUNT(*) FROM pending_registration WHERE email = :email";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("email", email)
                .mapTo(Integer.class)
                .findFirst()
                .orElse(0) > 0);
    }

    public boolean existsByUsernameExcludingEmail(String username, String email) {
        String sql = """
                SELECT COUNT(*)
                FROM pending_registration
                WHERE username = :username
                  AND email <> :email
                """;
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("username", username)
                .bind("email", email)
                .mapTo(Integer.class)
                .findFirst()
                .orElse(0) > 0);
    }

    public int saveOrUpdate(String email, String username, String fullName, String phone,
                            String passwordHash, String otpCode, Timestamp otpExpiry) {
        return jdbi.inTransaction(handle -> {
            Integer existingId = handle.createQuery(
                            "SELECT pending_id FROM pending_registration WHERE email = :email")
                    .bind("email", email)
                    .mapTo(Integer.class)
                    .findFirst()
                    .orElse(null);

            if (existingId != null) {
                handle.createUpdate("""
                                UPDATE pending_registration
                                SET username = :username,
                                    full_name = :fullName,
                                    phone = :phone,
                                    password_hash = :passwordHash,
                                    otp_code = :otpCode,
                                    otp_expiry = :otpExpiry,
                                    attempts = 0,
                                    is_verified = FALSE
                                WHERE pending_id = :pendingId
                                """)
                        .bind("username", username)
                        .bind("fullName", fullName)
                        .bind("phone", normalizePhone(phone))
                        .bind("passwordHash", passwordHash)
                        .bind("otpCode", otpCode)
                        .bind("otpExpiry", otpExpiry)
                        .bind("pendingId", existingId)
                        .execute();
                return existingId;
            }

            return handle.createUpdate("""
                            INSERT INTO pending_registration
                            (email, username, full_name, phone, password_hash, otp_code, otp_expiry, attempts, is_verified)
                            VALUES (:email, :username, :fullName, :phone, :passwordHash, :otpCode, :otpExpiry, 0, FALSE)
                            """)
                    .bind("email", email)
                    .bind("username", username)
                    .bind("fullName", fullName)
                    .bind("phone", normalizePhone(phone))
                    .bind("passwordHash", passwordHash)
                    .bind("otpCode", otpCode)
                    .bind("otpExpiry", otpExpiry)
                    .executeAndReturnGeneratedKeys("pending_id")
                    .mapTo(Integer.class)
                    .findFirst()
                    .orElse(-1);
        });
    }

    public boolean updateOtp(String email, String otpCode, Timestamp otpExpiry) {
        String sql = """
                UPDATE pending_registration
                SET otp_code = :otpCode,
                    otp_expiry = :otpExpiry,
                    attempts = 0,
                    is_verified = FALSE
                WHERE email = :email
                """;
        return jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("otpCode", otpCode)
                .bind("otpExpiry", otpExpiry)
                .bind("email", email)
                .execute() > 0);
    }

    public boolean incrementAttempts(int pendingId) {
        String sql = "UPDATE pending_registration SET attempts = attempts + 1 WHERE pending_id = :pendingId";
        return jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("pendingId", pendingId)
                .execute() > 0);
    }

    public boolean deleteById(int pendingId) {
        String sql = "DELETE FROM pending_registration WHERE pending_id = :pendingId";
        return jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("pendingId", pendingId)
                .execute() > 0);
    }

    public int deleteExpiredUnverified() {
        String sql = "DELETE FROM pending_registration WHERE is_verified = FALSE AND otp_expiry < NOW()";
        return jdbi.withHandle(handle -> handle.createUpdate(sql).execute());
    }

    private PendingRegistration mapPending(java.sql.ResultSet rs) throws java.sql.SQLException {
        PendingRegistration pending = new PendingRegistration();
        pending.setPendingId(rs.getInt("pending_id"));
        pending.setEmail(rs.getString("email"));
        pending.setUsername(rs.getString("username"));
        pending.setFullName(rs.getString("full_name"));
        pending.setPhone(rs.getString("phone"));
        pending.setPasswordHash(rs.getString("password_hash"));
        pending.setOtpCode(rs.getString("otp_code"));
        pending.setOtpExpiry(rs.getTimestamp("otp_expiry"));
        pending.setAttempts(rs.getInt("attempts"));
        pending.setVerified(rs.getBoolean("is_verified"));
        pending.setCreatedAt(rs.getTimestamp("created_at"));
        pending.setUpdatedAt(rs.getTimestamp("updated_at"));
        return pending;
    }

    private String normalizePhone(String phone) {
        if (phone == null) {
            return null;
        }
        String trimmed = phone.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }
}

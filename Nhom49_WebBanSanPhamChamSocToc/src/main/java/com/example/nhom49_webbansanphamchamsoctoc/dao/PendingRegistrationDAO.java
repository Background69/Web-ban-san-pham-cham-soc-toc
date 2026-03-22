package com.example.nhom49_webbansanphamchamsoctoc.dao;

import com.example.nhom49_webbansanphamchamsoctoc.database.JDBIConnector;
import com.example.nhom49_webbansanphamchamsoctoc.model.PendingRegistration;
import org.jdbi.v3.core.Handle;
import org.jdbi.v3.core.Jdbi;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Optional;

public class PendingRegistrationDAO {
    private final Jdbi jdbi;

    public PendingRegistrationDAO() {
        this.jdbi = JDBIConnector.getInstance();
    }

    public int upsertPending(String email, String username, String fullName, String phone,
                             String passwordHash, String otpCode, Timestamp otpExpiry) {
        String sql = """
                INSERT INTO pending_registration
                    (email, username, full_name, phone, password_hash, otp_code, otp_expiry, attempts, is_verified)
                VALUES
                    (:email, :username, :fullName, :phone, :passwordHash, :otpCode, :otpExpiry, 0, FALSE)
                ON DUPLICATE KEY UPDATE
                    pending_id = LAST_INSERT_ID(pending_id),
                    full_name = VALUES(full_name),
                    phone = VALUES(phone),
                    password_hash = VALUES(password_hash),
                    otp_code = VALUES(otp_code),
                    otp_expiry = VALUES(otp_expiry),
                    attempts = 0,
                    is_verified = FALSE
                """;

        return jdbi.withHandle(handle -> {
            int affected = handle.createUpdate(sql)
                    .bind("email", email)
                    .bind("username", username)
                    .bind("fullName", fullName)
                    .bind("phone", phone)
                    .bind("passwordHash", passwordHash)
                    .bind("otpCode", otpCode)
                    .bind("otpExpiry", otpExpiry)
                    .execute();

            if (affected <= 0) {
                return -1;
            }

            return handle.createQuery("SELECT LAST_INSERT_ID()")
                    .mapTo(Integer.class)
                    .findFirst()
                    .orElse(-1);
        });
    }

    public PendingRegistration findById(int pendingId) {
        String sql = """
                SELECT *
                FROM pending_registration
                WHERE pending_id = :pendingId
                LIMIT 1
                """;

        return (PendingRegistration) jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("pendingId", pendingId)
                .map((rs, ctx) -> mapPending(rs)));
    }

    public boolean incrementAttempts(int pendingId) {
        String sql = """
                UPDATE pending_registration
                SET attempts = attempts + 1
                WHERE pending_id = :pendingId
                  AND is_verified = FALSE
                """;

        return jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("pendingId", pendingId)
                .execute() > 0);
    }

    public boolean updateOtp(int pendingId, String otpCode, Timestamp otpExpiry) {
        String sql = """
                UPDATE pending_registration
                SET otp_code = :otpCode,
                    otp_expiry = :otpExpiry,
                    attempts = 0,
                    is_verified = FALSE
                WHERE pending_id = :pendingId
                """;

        return jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("pendingId", pendingId)
                .bind("otpCode", otpCode)
                .bind("otpExpiry", otpExpiry)
                .execute() > 0);
    }

    public int createUserAndConsumePending(int pendingId) {
        return jdbi.inTransaction(handle -> {
            PendingRegistration pending = findByIdForUpdate(handle, pendingId);
            if (pending == null) {
                return -1;
            }

            int userId = handle.createUpdate("""
                            INSERT INTO users
                                (email, username, full_name, password, phone, avatar, role, is_active, google_id, auth_provider)
                            VALUES
                                (:email, :username, :fullName, :password, :phone, :avatar, :role, :isActive, :googleId, :authProvider)
                            """)
                    .bind("email", pending.getEmail())
                    .bind("username", pending.getUsername())
                    .bind("fullName", pending.getFullName())
                    .bind("password", pending.getPasswordHash())
                    .bind("phone", pending.getPhone())
                    .bind("avatar", "avatar/avatar.jpg")
                    .bind("role", "Khach hang")
                    .bind("isActive", true)      // OTP ok => account active ngay
                    .bind("googleId", Optional.empty())
                    .bind("authProvider", "LOCAL")
                    .executeAndReturnGeneratedKeys("user_id")
                    .mapTo(Integer.class)
                    .findFirst()
                    .orElse(-1);

            if (userId <= 0) {
                return -1;
            }

            int deleted = handle.createUpdate("""
                            DELETE FROM pending_registration
                            WHERE pending_id = :pendingId
                            """)
                    .bind("pendingId", pendingId)
                    .execute();

            return deleted > 0 ? userId : -1;
        });
    }

    private PendingRegistration findByIdForUpdate(Handle handle, int pendingId) {
        String sql = """
                SELECT *
                FROM pending_registration
                WHERE pending_id = :pendingId
                LIMIT 1
                FOR UPDATE
                """;

        return handle.createQuery(sql)
                .bind("pendingId", pendingId)
                .map((rs, ctx) -> mapPending(rs))
                .findFirst()
                .orElse(null);
    }

    private PendingRegistration mapPending(ResultSet rs) throws SQLException {
        PendingRegistration p = new PendingRegistration();
        p.setPendingId(rs.getInt("pending_id"));
        p.setEmail(rs.getString("email"));
        p.setUsername(rs.getString("username"));
        p.setFullName(rs.getString("full_name"));
        p.setPhone(rs.getString("phone"));
        p.setPasswordHash(rs.getString("password_hash"));
        p.setOtpCode(rs.getString("otp_code"));
        p.setOtpExpiry(rs.getTimestamp("otp_expiry"));
        p.setAttempts(rs.getInt("attempts"));
        p.setVerified(rs.getBoolean("is_verified"));
        p.setCreatedAt(rs.getTimestamp("created_at"));
        p.setUpdatedAt(rs.getTimestamp("updated_at"));
        return p;
    }
}

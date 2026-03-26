package com.example.nhom49_webbansanphamchamsoctoc.dao;

import com.example.nhom49_webbansanphamchamsoctoc.database.JDBIConnector;
import com.example.nhom49_webbansanphamchamsoctoc.model.OtpVerification;
import org.jdbi.v3.core.Handle;
import org.jdbi.v3.core.Jdbi;

import java.sql.Timestamp;

public class OtpVerificationDAO {
    private final Jdbi jdbi;

    public OtpVerificationDAO() {
        this.jdbi = JDBIConnector.getInstance();
    }

    public enum OtpPurpose {
        REGISTER,
        FORGOT_PASSWORD
    }


    public int createOtp(int userId, String otpCode, OtpPurpose purpose, Timestamp expiry) {
        return jdbi.inTransaction(handle -> {
            invalidateOldOtp(handle, userId, purpose);
            return insertNewOtp(handle, userId, otpCode, purpose, expiry);
        });
    }

    // Tắt otp cũ chưa dùng của user
    private void invalidateOldOtp(Handle handle, int userId, OtpPurpose purpose) {
        handle.createUpdate("""
                        UPDATE otp_verification
                        SET is_verified = TRUE
                        WHERE user_id = :userId
                          AND otp_type = :otpType
                          AND is_verified = FALSE
                        """)
                .bind("userId", userId)
                .bind("otpType", purpose.name())
                .execute();
    }

    // Tạo otp mới cho user
    private int insertNewOtp(Handle handle, int userId, String otpCode, OtpPurpose purpose, Timestamp expiry) {
        return handle.createUpdate("""
                        INSERT INTO otp_verification
                        (user_id, otp_code, otp_type, otp_expiry, attempts, is_verified)
                        VALUES (:userId, :otpCode, :otpType, :otpExpiry, 0, FALSE)
                        """)
                .bind("userId", userId)
                .bind("otpCode", otpCode)
                .bind("otpType", purpose.name())
                .bind("otpExpiry", expiry)
                .executeAndReturnGeneratedKeys("otp_id")
                .mapTo(Integer.class)
                .findFirst()
                .orElse(-1);
    }

    // Lọc date của otp từ mới nhất xuống => lấy otp đầu tiên và phải còn hạn
    public OtpVerification findLatestOtpByUserId(int userId, OtpPurpose purpose) {
        String sql = """
                        SELECT *
                        FROM otp_verification
                        WHERE user_id = :userId
                            AND otp_type = :otpType
                            AND  is_verified = FALSE
                            AND otp_expiry > CURRENT_TIMESTAMP
                        ORDER BY otp_expiry DESC
                        LIMIT 1
                """;

        return jdbi.withHandle(handle -> handle.createQuery(sql))
                .bind("userId", userId)
                .bind("otpType", purpose.name())
                .map((rs, ctx) -> mapOtp(rs))
                .findFirst()
                .orElse(null);
    }

    public boolean incrementAttempts(int otpId) {
        String sql = "UPDATE otp_verification SET attempts = attempts + 1 WHERE otp_id = :otpId";
        return jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("otpId", otpId)
                .execute() > 0);
    }

    public boolean markVerified(int otpId) {
        String sql = "UPDATE otp_verification SET is_verified = TRUE WHERE otp_id = :otpId";
        return jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("otpId", otpId)
                .execute() > 0);
    }

    private OtpVerification mapOtp(java.sql.ResultSet rs) throws java.sql.SQLException {
        OtpVerification otp = new OtpVerification();
        otp.setOtpId(rs.getInt("otp_id"));
        otp.setUserId(rs.getInt("user_id"));
        otp.setOtpCode(rs.getString("otp_code"));
        otp.setOtpType(rs.getString("otp_type"));
        otp.setOtpExpiry(rs.getTimestamp("otp_expiry"));
        otp.setAttempts(rs.getInt("attempts"));
        otp.setVerified(rs.getBoolean("is_verified"));
        otp.setCreatedAt(rs.getTimestamp("created_at"));
        return otp;
    }
}

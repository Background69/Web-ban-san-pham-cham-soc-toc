package com.example.nhom49_webbansanphamchamsoctoc.dao;
import com.example.nhom49_webbansanphamchamsoctoc.database.JDBIConnector;
import org.jdbi.v3.core.Jdbi;
import java.util.logging.Level;
import java.util.logging.Logger;
/**
 * Ghi nhận mỗi lần đăng nhập (thành công/thất bại) và đếm số lần thất bại
 * trong cửa sổ thời gian để hỗ trợ khóa tài khoản chống brute-force
 */
public class LoginAttemptDAO {

    private static final Logger LOGGER = Logger.getLogger(LoginAttemptDAO.class.getName());

    private final Jdbi jdbi;

    public LoginAttemptDAO() {
        this.jdbi = JDBIConnector.getInstance();
    }

    public void recordAttempt(int userId, String ipAddress, boolean success) {
        String sql = "INSERT INTO login_attempts (user_id, ip_address, success) VALUES (:userId, :ipAddress, :success)";
        try {
            jdbi.useHandle(handle ->
                    handle.createUpdate(sql)
                            .bind("userId", userId)
                            .bind("ipAddress", ipAddress)
                            .bind("success", success)
                            .execute()
            );
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi ghi nhận login attempt cho userId=" + userId, e);
        }
    }

    public int countRecentFailedAttempts(int userId, int minutesWindow) {
        String sql = "SELECT COUNT(*) FROM login_attempts " +
                "WHERE user_id = :userId " +
                "AND success = false " +
                "AND attempt_time >= DATE_SUB(NOW(), INTERVAL :minutes MINUTE)";
        try {
            return jdbi.withHandle(handle ->
                    handle.createQuery(sql)
                            .bind("userId", userId)
                            .bind("minutes", minutesWindow)
                            .mapTo(Integer.class)
                            .findFirst()
                            .orElse(0)
            );
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi đếm failed attempts cho userId=" + userId, e);
            return 0;
        }
    }

    public void clearFailedAttempts(int userId) {
        String sql = "DELETE FROM login_attempts WHERE user_id = :userId AND success = false";
        try {
            jdbi.useHandle(handle ->
                    handle.createUpdate(sql)
                            .bind("userId", userId)
                            .execute()
            );
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi xóa failed attempts cho userId=" + userId, e);
        }
    }
}
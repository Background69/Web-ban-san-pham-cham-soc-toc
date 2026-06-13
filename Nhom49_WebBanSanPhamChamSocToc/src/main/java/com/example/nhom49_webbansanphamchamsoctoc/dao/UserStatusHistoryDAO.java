package com.example.nhom49_webbansanphamchamsoctoc.dao;
import com.example.nhom49_webbansanphamchamsoctoc.database.JDBIConnector;
import com.example.nhom49_webbansanphamchamsoctoc.model.UserStatusHistory;
import org.jdbi.v3.core.Handle;
import org.jdbi.v3.core.Jdbi;
import java.util.List;

public class UserStatusHistoryDAO implements IDAO<UserStatusHistory> {
    private final Jdbi jdbi;

    public UserStatusHistoryDAO() {
        this.jdbi = JDBIConnector.getInstance();
    }

    @Override
    public UserStatusHistory findById(int id) {
        String sql = "SELECT * FROM user_status_history WHERE id = :id";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("id", id)
                .map((rs, ctx) -> mapHistory(rs))
                .findFirst()
                .orElse(null));
    }

    @Override
    public List<UserStatusHistory> findAll() {
        String sql = "SELECT * FROM user_status_history ORDER BY created_at DESC";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .map((rs, ctx) -> mapHistory(rs))
                .list());
    }

    @Override
    public int insert(UserStatusHistory entity) {
        long id = insertHistory(entity);
        return id > Integer.MAX_VALUE ? Integer.MAX_VALUE : (int) id;
    }

    public long insertHistory(UserStatusHistory history) {
        return jdbi.withHandle(handle -> insertHistory(handle, history));
    }

    public long insertHistory(Handle handle, UserStatusHistory history) {
        String sql = "INSERT INTO user_status_history (user_id, action, reason_code, reason_detail) " +
                "VALUES (:userId, :action, :reasonCode, :reasonDetail)";
        return handle.createUpdate(sql)
                .bind("userId", history.getUserId())
                .bind("action", history.getAction())
                .bind("reasonCode", history.getReasonCode())
                .bind("reasonDetail", history.getReasonDetail())
                .executeAndReturnGeneratedKeys("id")
                .mapTo(Long.class)
                .findFirst()
                .orElse(-1L);
    }

    public List<UserStatusHistory> findByUserId(int userId) {
        String sql = "SELECT * FROM user_status_history WHERE user_id = :userId ORDER BY created_at DESC";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("userId", userId)
                .map((rs, ctx) -> mapHistory(rs))
                .list());
    }

    @Override
    public boolean update(UserStatusHistory entity) {
        return false;
    }

    @Override
    public boolean delete(int id) {
        return false;
    }

    private UserStatusHistory mapHistory(java.sql.ResultSet rs) throws java.sql.SQLException {
        UserStatusHistory history = new UserStatusHistory();
        history.setId(rs.getLong("id"));
        history.setUserId(rs.getInt("user_id"));
        history.setAction(rs.getString("action"));
        history.setReasonCode(rs.getString("reason_code"));
        history.setReasonDetail(rs.getString("reason_detail"));
        history.setCreatedAt(rs.getTimestamp("created_at"));
        return history;
    }
}
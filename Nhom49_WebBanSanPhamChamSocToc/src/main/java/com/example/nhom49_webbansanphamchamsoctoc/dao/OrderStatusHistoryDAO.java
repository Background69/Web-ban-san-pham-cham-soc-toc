package com.example.nhom49_webbansanphamchamsoctoc.dao;

import com.example.nhom49_webbansanphamchamsoctoc.database.JDBIConnector;
import com.example.nhom49_webbansanphamchamsoctoc.model.OrderStatusHistory;
import org.jdbi.v3.core.Jdbi;

import java.util.List;

public class OrderStatusHistoryDAO implements IDAO<OrderStatusHistory> {
    private final Jdbi jdbi;

    public OrderStatusHistoryDAO() {
        this.jdbi = JDBIConnector.getInstance();
    }

    @Override
    public OrderStatusHistory findById(int id) {
        String sql = "SELECT h.*, u.username AS changed_by_username FROM order_status_history h LEFT JOIN users u ON h.changed_by = u.user_id WHERE h.history_id = :id";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("id", id)
                .map((rs, ctx) -> mapHistory(rs))
                .findFirst()
                .orElse(null));
    }

    @Override
    public List<OrderStatusHistory> findAll() {
        String sql = "SELECT h.*, u.username AS changed_by_username FROM order_status_history h LEFT JOIN users u ON h.changed_by = u.user_id ORDER BY h.changed_at DESC";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .map((rs, ctx) -> mapHistory(rs))
                .list());
    }

    @Override
    public int insert(OrderStatusHistory entity) {
        String sql = "INSERT INTO order_status_history (order_id, old_status, new_status, changed_by, note) VALUES (:orderId, :oldStatus, :newStatus, :changedBy, :note)";
        return jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("orderId", entity.getOrderId())
                .bind("oldStatus", entity.getOldStatus())
                .bind("newStatus", entity.getNewStatus())
                .bind("changedBy", entity.getChangedBy())
                .bind("note", entity.getNote())
                .executeAndReturnGeneratedKeys("history_id")
                .mapTo(Integer.class)
                .findFirst()
                .orElse(-1));
    }

    @Override
    public boolean update(OrderStatusHistory entity) {
        String sql = "UPDATE order_status_history SET old_status = :oldStatus, new_status = :newStatus, changed_by = :changedBy, note = :note WHERE history_id = :historyId";
        return jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("oldStatus", entity.getOldStatus())
                .bind("newStatus", entity.getNewStatus())
                .bind("changedBy", entity.getChangedBy())
                .bind("note", entity.getNote())
                .bind("historyId", entity.getHistoryId())
                .execute() > 0);
    }

    @Override
    public boolean delete(int id) {
        String sql = "DELETE FROM order_status_history WHERE history_id = :id";
        return jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("id", id)
                .execute() > 0);
    }

    public List<OrderStatusHistory> findByOrderId(int orderId) {
        String sql = "SELECT h.*, u.username AS changed_by_username FROM order_status_history h LEFT JOIN users u ON h.changed_by = u.user_id WHERE h.order_id = :orderId ORDER BY h.changed_at DESC";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("orderId", orderId)
                .map((rs, ctx) -> mapHistory(rs))
                .list());
    }

    public int insertWithTransaction(OrderStatusHistory entity) {
        return jdbi.inTransaction(handle -> handle.createUpdate(
                        "INSERT INTO order_status_history (order_id, old_status, new_status, changed_by, note) VALUES (:orderId, :oldStatus, :newStatus, :changedBy, :note)")
                .bind("orderId", entity.getOrderId())
                .bind("oldStatus", entity.getOldStatus())
                .bind("newStatus", entity.getNewStatus())
                .bind("changedBy", entity.getChangedBy())
                .bind("note", entity.getNote())
                .executeAndReturnGeneratedKeys("history_id")
                .mapTo(Integer.class)
                .findFirst()
                .orElse(-1));
    }

    private OrderStatusHistory mapHistory(java.sql.ResultSet rs) throws java.sql.SQLException {
        OrderStatusHistory history = new OrderStatusHistory();
        history.setHistoryId(rs.getInt("history_id"));
        history.setOrderId(rs.getInt("order_id"));
        history.setOldStatus(rs.getString("old_status"));
        history.setNewStatus(rs.getString("new_status"));
        history.setChangedBy(rs.getObject("changed_by") != null ? rs.getInt("changed_by") : null);
        history.setChangedAt(rs.getTimestamp("changed_at"));
        history.setNote(rs.getString("note"));
        history.setChangedByUsername(rs.getString("changed_by_username"));
        return history;
    }
}


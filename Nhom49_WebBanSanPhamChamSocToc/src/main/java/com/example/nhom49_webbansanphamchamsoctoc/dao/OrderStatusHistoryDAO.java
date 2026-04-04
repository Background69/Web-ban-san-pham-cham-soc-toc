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
        String sql = "SELECT * FROM order_status_history WHERE history_id = :id";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("id", id)
                .map((rs, ctx) -> mapHistory(rs))
                .findFirst()
                .orElse(null));
    }

    @Override
    public List<OrderStatusHistory> findAll() {
        String sql = "SELECT * FROM order_status_history ORDER BY created_at DESC";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .map((rs, ctx) -> mapHistory(rs))
                .list());
    }

    @Override
    public int insert(OrderStatusHistory entity) {
        String sql = "INSERT INTO order_status_history (order_id, status, note) VALUES (:orderId, :status, :note)";
        return jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("orderId", entity.getOrderId())
                .bind("status", entity.getStatus())
                .bind("note", entity.getNote())
                .executeAndReturnGeneratedKeys("history_id")
                .mapTo(Integer.class)
                .findFirst()
                .orElse(-1));
    }

    @Override
    public boolean update(OrderStatusHistory entity) {
        return false;
    }

    @Override
    public boolean delete(int id) {
        return false;
    }


    private OrderStatusHistory mapHistory(java.sql.ResultSet rs) throws java.sql.SQLException {
        OrderStatusHistory history = new OrderStatusHistory();
        history.setHistoryId(rs.getInt("history_id"));
        history.setOrderId(rs.getInt("order_id"));
        history.setStatus(rs.getString("status"));
        history.setCreatedAt(rs.getTimestamp("created_at"));
        history.setNote(rs.getString("note"));
        return history;
    }
}

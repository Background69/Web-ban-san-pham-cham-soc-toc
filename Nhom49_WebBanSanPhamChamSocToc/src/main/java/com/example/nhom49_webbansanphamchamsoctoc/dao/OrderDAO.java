package com.example.nhom49_webbansanphamchamsoctoc.dao;

import com.example.nhom49_webbansanphamchamsoctoc.database.JDBIConnector;
import com.example.nhom49_webbansanphamchamsoctoc.model.Order;
import org.jdbi.v3.core.Jdbi;

import java.math.BigDecimal;
import java.util.List;

public class OrderDAO implements IDAO<Order> {
    private final Jdbi jdbi = JDBIConnector.getInstance();

    @Override
    public Order findById(int id) {
        String sql = "SELECT * FROM orders WHERE order_id =?";

        return jdbi.withHandle(h -> h.createQuery(sql)
                        .bind(0, id)
                        .map((rs, ctx) -> {
                            Order o = new Order();
                            o.setOrderId(rs.getInt("order_id"));
                            o.setOrderCode(rs.getString("order_code"));
                            o.setOrderStatus(rs.getString("order_status"));
                            o.setTotalAmount(BigDecimal.valueOf(rs.getDouble("total_amount")));
                            o.setCreatedAt(rs.getTimestamp("created_at"));
                            return o;

                        }))
                .findFirst()
                .orElse(null);
    }

    @Override
    public List<Order> findAll() {
        String sql = "SELECT * FROM orders ORDER BY created_at DESC";

        return jdbi.withHandle(h ->
                h.createQuery(sql)
                        .map((rs, ctx) -> {
                            Order o = new Order();
                            o.setOrderId(rs.getInt("order_id"));
                            o.setOrderCode(rs.getString("order_code"));
                            o.setUserId(rs.getInt("user_id"));
                            o.setOrderStatus(rs.getString("order_status"));
                            o.setTotalAmount(BigDecimal.valueOf(rs.getDouble("total_amount")));
                            o.setCreatedAt(rs.getTimestamp("created_at"));
                            return o;
                        })
                        .list()
        );
    }
    @Override
    public int insert(Order order) {
        String sql = """
            INSERT INTO orders
            (order_code, user_id, shipping_address_id,
             shipping_full_name, shipping_fee, total_amount)
            VALUES (?, ?, ?, ?, ?, ?)
        """;

        return jdbi.withHandle(h ->
                h.createUpdate(sql)
                        .bind(0, order.getOrderCode())
                        .bind(1, order.getUserId())
                        .bind(2, order.getShippingAddressId())
                        .bind(3, order.getShippingFullName())
                        .bind(4, order.getShippingFee())
                        .bind(5, order.getTotalAmount())
                        .executeAndReturnGeneratedKeys("order_id")
                        .mapTo(int.class)
                        .findFirst()
                        .orElse(0)
        );
    }

    @Override
    public boolean update(Order order) {
        String sql = "UPDATE orders SET order_status = ? WHERE order_id=?";
        return jdbi.withHandle(h->h.createUpdate(sql)
                .bind(0,order.getOrderStatus())
                .bind(1, order.getOrderId())
                .execute()
        )>0;
    }

    @Override
    public boolean delete(int id) {
        String sql = "DELETE FROM orders WHERE order_id = ?";
        return jdbi.withHandle(h->h.createUpdate(sql)
                .bind(0,id)
                .execute()
        )>0;
    }
}

package com.example.nhom49_webbansanphamchamsoctoc.dao;

import com.example.nhom49_webbansanphamchamsoctoc.database.JDBIConnector;
import com.example.nhom49_webbansanphamchamsoctoc.model.Order;
import com.example.nhom49_webbansanphamchamsoctoc.model.OrderItem;
import org.jdbi.v3.core.Jdbi

import java.math.BigDecimal;
import java.util.List;

public class OrderItemDAO implements IDAO<OrderItem> {
    private final Jdbi jdbi = JDBIConnector.getInstance();

    @Override
    public int insert(OrderItem order) {
        return 0;
    }

    @Override
    public boolean update(OrderItem entity) {
        return false;
    }

    @Override
    public OrderItem findById(int id) {
        String sql = "SELECT * FROM order_items WHERE order_item_id=?";

        return jdbi.withHandle(h -> h.createQuery(sql)
                        .bind(0, id)
                        .map((rs, ctx) -> {
                            OrderItem oi = new OrderItem();
                            oi.setOrderItemId(rs.getInt("order_item_id"));
                            oi.setOrderId(rs.getInt("order_id"));
                            oi.setProductId(rs.getInt("product_id"));
                            oi.setQuantity(rs.getInt("quantity"));
                            oi.setUnitPrice(rs.getBigDecimal("created_at"));
                            return oi;

                        }))
                .findFirst()
                .orElse(null);
    }

    @Override
    public List<Order> findAll() {
        String sql = "SELECT * FROM orders_items";

        return jdbi.withHandle(h ->
                h.createQuery(sql)
                        .map((rs, ctx) -> {
                            OrderItem oi = new OrderItem();
                            oi.setOrderItemId(rs.getInt("order_item_id"));
                            oi.setOrderId(rs.getInt("order_id"));
                            oi.setProductId(rs.getInt("product_id"));
                            oi.setQuantity(rs.getInt("quantity"));
                            oi.setUnitPrice(rs.getBigDecimal("created_at"));
                            return oi;
                        })
                        .list()
        );
    }
    @Override
    public int insert(OrderItem item) {
        String sql = """
                INSERT INTO order_item(order_id, product_id, quantity, unitprice)
                VALUES(?,?,?,?)
                """;
        return jdbi.withHandle(h->h.createUpdate(sql)
                .bind(0,item.getOrderId())
                        .bind(1, item.getProductId())
                        .bind(2, item.getQuantity())
                        .bind(3, item.getUnitPrice())
                        .executeAndReturnGeneratedKeys(order_item_id)
                );
    }

    @Override
    public boolean update(OrderItem entity) {
        return false;
    }
}

package com.example.nhom49_webbansanphamchamsoctoc.dao;

import com.example.nhom49_webbansanphamchamsoctoc.database.JDBIConnector;
import com.example.nhom49_webbansanphamchamsoctoc.model.OrderItem;
import org.jdbi.v3.core.Jdbi;

import java.util.List;

/**
 * Lớp OrderItemDAO.
 */
public class OrderItemDAO implements IDAO<OrderItem> {

    private final Jdbi jdbi;

    /**
     * Thực hiện order item dao.
     */
    public OrderItemDAO() {
        this.jdbi = JDBIConnector.getInstance();
    }


    @Override
    public List<OrderItem> findAll() {
        String sql = "SELECT * FROM order_items";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .map((rs, ctx) -> mapOrderItem(rs))
                .list());
    }


    public List<OrderItem> findByOrderId(int orderId) {
        String sql = "SELECT oi.*, " +
                "(SELECT pi.image_url FROM product_images pi WHERE pi.product_id = oi.product_id AND pi.is_primary = 1 LIMIT 1) as product_image "
                +
                "FROM order_items oi WHERE oi.order_id = :orderId";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("orderId", orderId)
                .map((rs, ctx) -> mapOrderItemWithImage(rs))
                .list());
    }


    @Override
    public OrderItem findById(int id) {
        String sql = "SELECT * FROM order_items WHERE order_item_id = :id";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("id", id)
                .map((rs, ctx) -> mapOrderItem(rs))
                .findFirst()
                .orElse(null));
    }


    @Override
    public int insert(OrderItem item) {
        String sql = "INSERT INTO order_items (order_id, product_id, variant_id, product_name, " +
                "variant_name, quantity, unit_price, total_price) VALUES (:orderId, :productId, :variantId, :productName, :variantName, :quantity, :unitPrice, :totalPrice)";
        return jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("orderId", item.getOrderId())
                .bind("productId", item.getProductId())
                .bind("variantId", item.getVariantId())
                .bind("productName", item.getProductName())
                .bind("variantName", item.getVariantName())
                .bind("quantity", item.getQuantity())
                .bind("unitPrice", item.getUnitPrice())
                .bind("totalPrice", item.getTotalPrice())
                .executeAndReturnGeneratedKeys("order_item_id")
                .mapTo(Integer.class)
                .findFirst()
                .orElse(-1));
    }
    public int getTotalSoldByProduct(int productId) {

        String sql = """
        SELECT COALESCE(SUM(oi.quantity),0)
        FROM order_items oi
        JOIN orders o
            ON oi.order_id = o.order_id
        WHERE oi.product_id = :productId
          AND o.order_status = 'completed'
        """;

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("productId", productId)
                        .mapTo(Integer.class)
                        .findFirst()
                        .orElse(0)
        );
    }
    public List<Integer> getSalesByMonth(int productId) {

        String sql = """
        SELECT MONTH(o.created_at) month,
               SUM(oi.quantity) total
        FROM order_items oi
        JOIN orders o
             ON oi.order_id = o.order_id
        WHERE oi.product_id = :productId
          AND o.order_status = 'completed'
        GROUP BY MONTH(o.created_at)
        ORDER BY MONTH(o.created_at)
        """;

        List<Integer> result =
                new java.util.ArrayList<>(
                        java.util.Collections.nCopies(12, 0)
                );

        jdbi.useHandle(handle ->
                handle.createQuery(sql)
                        .bind("productId", productId)
                        .mapToMap()
                        .forEach(row -> {

                            int month =
                                    ((Number) row.get("month")).intValue();

                            int total =
                                    ((Number) row.get("total")).intValue();

                            result.set(month - 1, total);
                        })
        );

        return result;
    }

    @Override
    public boolean update(OrderItem item) {
        String sql = "UPDATE order_items SET quantity = :quantity, unit_price = :unitPrice, total_price = :totalPrice WHERE order_item_id = :orderItemId";
        int rowsAffected = jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("quantity", item.getQuantity())
                .bind("unitPrice", item.getUnitPrice())
                .bind("totalPrice", item.getTotalPrice())
                .bind("orderItemId", item.getOrderItemId())
                .execute());
        return rowsAffected > 0;
    }


    @Override
    public boolean delete(int id) {
        String sql = "DELETE FROM order_items WHERE order_item_id = :orderItemId";
        int rowsAffected = jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("orderItemId", id)
                .execute());
        return rowsAffected > 0;
    }

    private OrderItem mapOrderItem(java.sql.ResultSet rs) throws java.sql.SQLException {
        OrderItem item = new OrderItem();
        item.setOrderItemId(rs.getInt("order_item_id"));
        item.setOrderId(rs.getInt("order_id"));
        item.setProductId(rs.getObject("product_id") != null ? rs.getInt("product_id") : null);
        item.setVariantId(rs.getObject("variant_id") != null ? rs.getInt("variant_id") : null);
        item.setProductName(rs.getString("product_name"));
        item.setVariantName(rs.getString("variant_name"));
        item.setQuantity(rs.getInt("quantity"));
        item.setUnitPrice(rs.getBigDecimal("unit_price"));
        item.setTotalPrice(rs.getBigDecimal("total_price"));
        item.setCreatedAt(rs.getTimestamp("created_at"));
        return item;
    }


    private OrderItem mapOrderItemWithImage(java.sql.ResultSet rs) throws java.sql.SQLException {
        OrderItem item = mapOrderItem(rs);
        try {
            String productImage = rs.getString("product_image");
            item.setProductImage(productImage);
        } catch (java.sql.SQLException e) {
            // Nếu cột product_image không tồn tại, bỏ qua lỗi và tiếp tục
        }
        return item;
    }
}

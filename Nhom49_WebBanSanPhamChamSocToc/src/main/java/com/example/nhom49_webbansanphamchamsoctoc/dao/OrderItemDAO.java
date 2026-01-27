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

    /**
     * Tim all.
     *
     * @return Kết quả xử lý của phương thức.
     */
    @Override
    public List<OrderItem> findAll() {
        String sql = "SELECT * FROM order_items";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .map((rs, ctx) -> mapOrderItem(rs))
                .list());
    }

    /**
     * Tim by order id.
     *
     * @param orderId Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
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

    /**
     * Tim by id.
     *
     * @param id Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    @Override
    public OrderItem findById(int id) {
        String sql = "SELECT * FROM order_items WHERE order_item_id = :id";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("id", id)
                .map((rs, ctx) -> mapOrderItem(rs))
                .findFirst()
                .orElse(null));
    }

    /**
     * Them .
     *
     * @param item Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
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

    /**
     * Them batch.
     *
     * @param items Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    public boolean insertBatch(List<OrderItem> items) {
        if (items == null || items.isEmpty()) {
            return false;
        }

        String sql = "INSERT INTO order_items (order_id, product_id, variant_id, product_name, " +
                "variant_name, quantity, unit_price, total_price) VALUES (:orderId, :productId, :variantId, :productName, :variantName, :quantity, :unitPrice, :totalPrice)";

        return jdbi.withHandle(handle -> {
            var batch = handle.prepareBatch(sql);
            for (OrderItem item : items) {
                batch.bind("orderId", item.getOrderId())
                        .bind("productId", item.getProductId())
                        .bind("variantId", item.getVariantId())
                        .bind("productName", item.getProductName())
                        .bind("variantName", item.getVariantName())
                        .bind("quantity", item.getQuantity())
                        .bind("unitPrice", item.getUnitPrice())
                        .bind("totalPrice", item.getTotalPrice())
                        .add();
            }
            int[] results = batch.execute();
            return results.length == items.size();
        });
    }

    /**
     * Cập nhật .
     *
     * @param item Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
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

    /**
     * Xóa .
     *
     * @param id Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    @Override
    public boolean delete(int id) {
        String sql = "DELETE FROM order_items WHERE order_item_id = :orderItemId";
        int rowsAffected = jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("orderItemId", id)
                .execute());
        return rowsAffected > 0;
    }

    /**
     * Xóa by order id.
     *
     * @param orderId Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    public boolean deleteByOrderId(int orderId) {
        String sql = "DELETE FROM order_items WHERE order_id = :orderId";
        int rowsAffected = jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("orderId", orderId)
                .execute());
        return rowsAffected > 0;
    }

    /**
     * Thực hiện map order item.
     *
     * @param rs Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    private OrderItem mapOrderItem(java.sql.ResultSet rs) throws java.sql.SQLException {
        OrderItem item = new OrderItem();
        item.setOrderItemId(rs.getInt("order_item_id"));
        item.setOrderId(rs.getInt("order_id"));
        item.setProductId(rs.getInt("product_id"));
        item.setVariantId(rs.getObject("variant_id") != null ? rs.getInt("variant_id") : null);
        item.setProductName(rs.getString("product_name"));
        item.setVariantName(rs.getString("variant_name"));
        item.setQuantity(rs.getInt("quantity"));
        item.setUnitPrice(rs.getBigDecimal("unit_price"));
        item.setTotalPrice(rs.getBigDecimal("total_price"));
        return item;
    }

    /**
     * Map order item kèm theo product image.
     *
     * @param rs Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    private OrderItem mapOrderItemWithImage(java.sql.ResultSet rs) throws java.sql.SQLException {
        OrderItem item = mapOrderItem(rs);
        try {
            String productImage = rs.getString("product_image");
            item.setProductImage(productImage);
        } catch (java.sql.SQLException e) {
            // Column may not exist in some queries
        }
        return item;
    }
}

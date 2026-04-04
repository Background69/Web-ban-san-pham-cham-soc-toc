package com.example.nhom49_webbansanphamchamsoctoc.dao;

import com.example.nhom49_webbansanphamchamsoctoc.database.JDBIConnector;
import com.example.nhom49_webbansanphamchamsoctoc.model.Order;
import org.jdbi.v3.core.Jdbi;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;


public class OrderDAO implements IDAO<Order> {


    private static final AtomicInteger orderCounter = new AtomicInteger(100);
    private final Jdbi jdbi;

    public OrderDAO() {
        this.jdbi = JDBIConnector.getInstance();
        Integer maxId = jdbi.withHandle(handle -> handle.createQuery("SELECT MAX(order_id) FROM orders")
                .mapTo(Integer.class)
                .findFirst()
                .orElse(100));
        if (maxId != null) {
            orderCounter.set(maxId);
        }
    }

    @Override
    public Order findById(int id) {
        String sql = "SELECT * FROM orders WHERE order_id = :orderId";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("orderId", id)
                .map((rs, ctx) -> mapOrder(rs))
                .findFirst()
                .orElse(null));
    }

    @Override
    public List<Order> findAll() {
        String sql = "SELECT * FROM orders ORDER BY created_at DESC";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .map((rs, ctx) -> mapOrder(rs))
                .list());
    }

    @Override
    public int insert(Order order) {
        String sql = "INSERT INTO orders (order_code, user_id, shipping_address_id, shipping_full_name, " +
                "shipping_phone, shipping_address, shipping_method, shipping_fee, payment_method, " +
                "subtotal, total_amount, order_status, note) VALUES (:orderCode, :userId, :shippingAddressId, :shippingFullName, :shippingPhone, :shippingAddress, :shippingMethod, :shippingFee, :paymentMethod, :subtotal, :totalAmount, :orderStatus, :note)";
        return jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("orderCode", order.getOrderCode())
                .bind("userId", order.getUserId())
                .bind("shippingAddressId", order.getShippingAddressId())
                .bind("shippingFullName", order.getShippingFullName())
                .bind("shippingPhone", order.getShippingPhone())
                .bind("shippingAddress", order.getShippingAddress())
                .bind("shippingMethod", order.getShippingMethod())
                .bind("shippingFee", order.getShippingFee())
                .bind("paymentMethod", order.getPaymentMethod())
                .bind("subtotal", order.getSubtotal())
                .bind("totalAmount", order.getTotalAmount())
                .bind("orderStatus", order.getOrderStatus() != null ? order.getOrderStatus() : "pending")
                .bind("note", order.getNote())
                .executeAndReturnGeneratedKeys("order_id")
                .mapTo(Integer.class)
                .findFirst()
                .orElse(-1));
    }

    @Override
    public boolean update(Order order) {
        String sql = "UPDATE orders SET shipping_full_name = :shippingFullName, shipping_phone = :shippingPhone, shipping_address = :shippingAddress, "
                +
                "shipping_method = :shippingMethod, shipping_fee = :shippingFee, payment_method = :paymentMethod, subtotal = :subtotal, "
                +
                "total_amount = :totalAmount, order_status = :orderStatus, note = :note WHERE order_id = :orderId";
        int rowsAffected = jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("shippingFullName", order.getShippingFullName())
                .bind("shippingPhone", order.getShippingPhone())
                .bind("shippingAddress", order.getShippingAddress())
                .bind("shippingMethod", order.getShippingMethod())
                .bind("shippingFee", order.getShippingFee())
                .bind("paymentMethod", order.getPaymentMethod())
                .bind("subtotal", order.getSubtotal())
                .bind("totalAmount", order.getTotalAmount())
                .bind("orderStatus", order.getOrderStatus())
                .bind("note", order.getNote())
                .bind("orderId", order.getOrderId())
                .execute());
        return rowsAffected > 0;
    }

    @Override
    public boolean delete(int id) {
        String sql = "DELETE FROM orders WHERE order_id = :orderId";
        int rowsAffected = jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("orderId", id)
                .execute());
        return rowsAffected > 0;
    }

    // Query methods

    public List<Order> findByUserId(int userId) {
        String sql = "SELECT * FROM orders WHERE user_id = :userId ORDER BY created_at DESC";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("userId", userId)
                .map((rs, ctx) -> mapOrder(rs))
                .list());
    }


    public List<Order> findRecentOrder(int limit) {
        String sql = "SELECT * FROM orders ORDER BY created_at DESC LIMIT ?";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind(0, limit)
                .map((rs, ctx) -> mapOrder(rs))
                .list());
    }


    public List<Order> findByUserIdAndStatus(int userId, String status) {
        String sql = "SELECT * FROM orders WHERE user_id = :userId AND order_status = :orderStatus ORDER BY created_at DESC";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("userId", userId)
                .bind("orderStatus", status)
                .map((rs, ctx) -> mapOrder(rs))
                .list());
    }

    public int countByUserId(int userId) {
        String sql = "SELECT COUNT(*) FROM orders WHERE user_id = :userId";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("userId", userId)
                .mapTo(Integer.class)
                .findFirst()
                .orElse(0));
    }



    public boolean hasUserPurchasedProduct(int userId, int productId) {
        String sql = """
                    SELECT COUNT(*)
                    FROM orders o
                    JOIN order_items oi ON o.order_id = oi.order_id
                    WHERE o.user_id = :userId
                      AND oi.product_id = :productId
                      AND o.order_status = 'completed'
                """;

        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("userId", userId)
                .bind("productId", productId)
                .mapTo(Integer.class)
                .findFirst()
                .orElse(0)) > 0;
    }

    public boolean hasUserPurchasedProductPending(int userId, int productId) {
        String sql = """
                    SELECT COUNT(*)
                    FROM orders o
                    JOIN order_items oi ON o.order_id = oi.order_id
                    WHERE o.user_id = :userId
                      AND oi.product_id = :productId
                      AND o.order_status NOT IN ('completed', 'cancelled')
                """;

        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("userId", userId)
                .bind("productId", productId)
                .mapTo(Integer.class)
                .findFirst()
                .orElse(0) > 0);

    }

    public BigDecimal getTotalSpendingByUser(int userId) {
        String sql = """
                    SELECT COALESCE(SUM(total_amount), 0)
                    FROM orders
                    WHERE user_id = :userId
                      AND order_status = 'completed'
                """;

        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("userId", userId)
                .mapTo(BigDecimal.class)
                .findFirst()
                .orElse(BigDecimal.ZERO)

        );
    }

    public List<Order> findByUserIdWithLimit(int userId, int limit) {
        String sql = """
                    SELECT *
                    FROM orders
                    WHERE user_id = :userId
                    ORDER BY created_at DESC
                    LIMIT :limit
                """;

        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("userId", userId)
                .bind("limit", limit)
                .map((rs, ctx) -> mapOrder(rs))
                .list());
    }

    public Map<String, Integer> getOrderCountsByStatus(int userId) {
        String sql = """
                    SELECT order_status, COUNT(*) AS total
                    FROM orders
                    WHERE user_id = :userId
                    GROUP BY order_status
                """;

        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("userId", userId)
                .mapToMap()
                .stream()
                .collect(
                        java.util.stream.Collectors.toMap(
                                row -> (String) row.get("order_status"),
                                row -> ((Number) row.get("total")).intValue())));
    }

    public boolean updateStatus(int orderId, String status) {
        String sql = "UPDATE orders SET order_status = :orderStatus WHERE order_id = :orderId";
        int rowsAffected = jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("orderStatus", status)
                .bind("orderId", orderId)
                .execute());
        return rowsAffected > 0;
    }

    public String generateOrderCode() {
        return "#HD" + orderCounter.incrementAndGet();
    }

    public boolean existsByOrderCode(String orderCode) {
        String sql = "SELECT COUNT(*) FROM orders WHERE order_code = :orderCode";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("orderCode", orderCode)
                .mapTo(Integer.class)
                .findFirst()
                .orElse(0) > 0);
    }

    public java.util.Map<String, Object> getDailyStats(java.util.Date startDate, java.util.Date endDate) {
        // Validate input
        if (startDate == null || endDate == null) {
            java.util.Map<String, Object> defaultResult = new java.util.HashMap<>();
            defaultResult.put("revenue", java.math.BigDecimal.ZERO);
            defaultResult.put("orders", 0);
            return defaultResult;
        }

        String sql = "SELECT COALESCE(SUM(total_amount), 0) as revenue, COUNT(*) as orders " +
                "FROM orders WHERE created_at >= :startDate AND created_at < :endDate " +
                "AND order_status NOT IN ('cancelled')";

        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("startDate", startDate)
                .bind("endDate", endDate)
                .map((rs, ctx) -> {
                    java.util.Map<String, Object> result = new java.util.HashMap<>();
                    java.math.BigDecimal revenue = rs.getBigDecimal("revenue");
                    result.put("revenue", revenue != null ? revenue : java.math.BigDecimal.ZERO);
                    result.put("orders", rs.getInt("orders"));
                    return result;
                })
                .findFirst()
                .orElseGet(() -> {
                    java.util.Map<String, Object> defaultResult = new java.util.HashMap<>();
                    defaultResult.put("revenue", java.math.BigDecimal.ZERO);
                    defaultResult.put("orders", 0);
                    return defaultResult;
                }));
    }

    public int countOrders() {
        String sql = "SELECT COUNT(*) FROM orders";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .mapTo(Integer.class)
                .findFirst()
                .orElse(0)

        );
    }

    public List<Integer> getRevenueByWeek() {
        String sql = "SELECT DAYOFWEEK(created_at) as d, SUM(total_amount) as total FROM orders GROUP BY DAYOFWEEK(created_At)";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .map((rs, ctx) -> rs.getInt("total"))
                        .list());
    }

    public List<Integer> getRevenueByMonth() {
        String sql = "SELECT MONTH(created_at) as m, SUM(total_amount) as total FROM orders GROUP BY MONTH(created_At)";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .map((rs, ctx) -> rs.getInt("total"))
                        .list());
    }

    public List<Integer> getRevenueByYear() {
        String sql = "SELECT YEAR(created_at) as Y, SUM(total_amount) as total FROM orders GROUP BY YEAR(created_At)";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .map((rs, ctx) -> rs.getInt("total"))
                        .list());
    }

    public long totalRevenue() {
        // Hỗ trợ nhiều biến thể trạng thái hoàn thành
        String sql = "SELECT COALESCE(SUM(total_amount),0) FROM orders WHERE order_status = 'completed'";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .mapTo(Long.class)
                .findFirst()
                .orElse(0L));
    }

    public List<Integer> getOrderStatusStats() {
        String sql = "SELECT SUM(CASE WHEN order_status IN ('completed','done') THEN 1 ELSE 0 END) AS completed,SUM(CASE WHEN order_status IN ('cancelled','canceled') THEN 1 ELSE 0 END) AS cancelled, SUM(CASE WHEN order_status = 'pending' THEN 1 ELSE 0 END) AS pending FROM orders";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .map((rs, ctx) -> List.of(
                                rs.getInt("completed"),
                                rs.getInt("cancelled"),
                                rs.getInt("pending")
                        ))
                        .findFirst()
                        .orElse(List.of(0, 0, 0))
        );
    }
    // Helper method;

    // Helper method
    private Order mapOrder(java.sql.ResultSet rs) throws java.sql.SQLException {
        Order order = new Order();
        order.setOrderId(rs.getInt("order_id"));
        order.setOrderCode(rs.getString("order_code"));
        order.setUserId(rs.getObject("user_id") != null ? rs.getInt("user_id") : null);
        order.setShippingAddressId(
                rs.getObject("shipping_address_id") != null ? rs.getInt("shipping_address_id") : null);
        order.setShippingFullName(rs.getString("shipping_full_name"));
        order.setShippingPhone(rs.getString("shipping_phone"));
        order.setShippingAddress(rs.getString("shipping_address"));
        order.setShippingMethod(rs.getString("shipping_method"));
        order.setShippingFee(rs.getBigDecimal("shipping_fee"));
        order.setPaymentMethod(rs.getString("payment_method"));
        order.setSubtotal(rs.getBigDecimal("subtotal"));
        order.setTotalAmount(rs.getBigDecimal("total_amount"));
        order.setOrderStatus(rs.getString("order_status"));
        order.setNote(rs.getString("note"));
        order.setCreatedAt(rs.getTimestamp("created_at"));
        order.setUpdatedAt(rs.getTimestamp("updated_at"));
        return order;
    }
}




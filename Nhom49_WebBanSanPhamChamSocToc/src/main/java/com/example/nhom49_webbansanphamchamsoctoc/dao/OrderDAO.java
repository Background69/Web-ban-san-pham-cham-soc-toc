package com.example.nhom49_webbansanphamchamsoctoc.dao;

import com.example.nhom49_webbansanphamchamsoctoc.database.JDBIConnector;
import com.example.nhom49_webbansanphamchamsoctoc.model.Order;
import org.jdbi.v3.core.Jdbi;

import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;


/**
 * Lớp OrderDao.
 */
public class OrderDAO implements IDAO<Order> {

    /**
     * Thực hiện atomic integer.
     *
     * @param 100 Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    private static final AtomicInteger orderCounter = new AtomicInteger(100);
    private final Jdbi jdbi;

    /**
     * Khởi tạo OrderDao.
     */
    public OrderDAO() {
        this.jdbi = JDBIConnector.getInstance();
        Integer maxId = jdbi.withHandle(handle ->
                handle.createQuery("SELECT MAX(order_id) FROM orders")
                        .mapTo(Integer.class)
                        .findFirst()
                        .orElse(100)
        );
        if (maxId != null) {
            orderCounter.set(maxId);
        }
    }

    /**
     * Tim by id.
     *
     * @param id Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    @Override
    public Order findById(int id) {
        String sql = "SELECT * FROM orders WHERE order_id = :orderId";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("orderId", id)
                        .map((rs, ctx) -> mapOrder(rs))
                        .findFirst()
                        .orElse(null)
        );
    }

    /**
     * Tim all.
     *
     * @return Kết quả xử lý của phương thức.
     */
    @Override
    public List<Order> findAll() {
        String sql = "SELECT * FROM orders ORDER BY created_at DESC";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .map((rs, ctx) -> mapOrder(rs))
                        .list()
        );
    }


    /**
     * Them .
     *
     * @param order Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    @Override
    public int insert(Order order) {
        String sql = "INSERT INTO orders (order_code, user_id, shipping_address_id, shipping_full_name, " +
                "shipping_phone, shipping_address, shipping_method, shipping_fee, payment_method, " +
                "subtotal, total_amount, order_status) VALUES (:orderCode, :userId, :shippingAddressId, :shippingFullName, :shippingPhone, :shippingAddress, :shippingMethod, :shippingFee, :paymentMethod, :subtotal, :totalAmount, :orderStatus)";
        return jdbi.withHandle(handle ->
                handle.createUpdate(sql)
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
                        .executeAndReturnGeneratedKeys("order_id")
                        .mapTo(Integer.class)
                        .findFirst()
                        .orElse(-1)
        );
    }

    /**
     * Cập nhật .
     *
     * @param order Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    @Override
    public boolean update(Order order) {
        String sql = "UPDATE orders SET shipping_full_name = :shippingFullName, shipping_phone = :shippingPhone, shipping_address = :shippingAddress, " +
                "shipping_method = :shippingMethod, shipping_fee = :shippingFee, payment_method = :paymentMethod, subtotal = :subtotal, " +
                "total_amount = :totalAmount, order_status = :orderStatus WHERE order_id = :orderId";
        int rowsAffected = jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("shippingFullName", order.getShippingFullName())
                        .bind("shippingPhone", order.getShippingPhone())
                        .bind("shippingAddress", order.getShippingAddress())
                        .bind("shippingMethod", order.getShippingMethod())
                        .bind("shippingFee", order.getShippingFee())
                        .bind("paymentMethod", order.getPaymentMethod())
                        .bind("subtotal", order.getSubtotal())
                        .bind("totalAmount", order.getTotalAmount())
                        .bind("orderStatus", order.getOrderStatus())
                        .bind("orderId", order.getOrderId())
                        .execute()
        );
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
        String sql = "DELETE FROM orders WHERE order_id = :orderId";
        int rowsAffected = jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("orderId", id)
                        .execute()
        );
        return rowsAffected > 0;
    }

    // Query methods

    /**
     * Tim by user id.
     *
     * @param userId Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    public List<Order> findByUserId(int userId) {
        String sql = "SELECT * FROM orders WHERE user_id = :userId ORDER BY created_at DESC";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("userId", userId)
                        .map((rs, ctx) -> mapOrder(rs))
                        .list()
        );
    }

    /**
     * Tim by order code.
     *
     * @param orderCode Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    public Order findByOrderCode(String orderCode) {
        String sql = "SELECT * FROM orders WHERE order_code = :orderCode";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("orderCode", orderCode)
                        .map((rs, ctx) -> mapOrder(rs))
                        .findFirst()
                        .orElse(null)
        );
    }
    public List<Order> findRecentOrder(int limit){
        String sql= "SELECT * FROM orders ORDER BY created_at DESC LIMIT ?";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind(0,limit)
                        .map((rs,ctx)->mapOrder(rs))
                        .list()
        );
    }

    /**
     * Tim by status.
     *
     * @param status Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    public List<Order> findByStatus(String status) {
        String sql = "SELECT * FROM orders WHERE order_status = :orderStatus ORDER BY created_at DESC";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("orderStatus", status)
                        .map((rs, ctx) -> mapOrder(rs))
                        .list()
        );
    }

    /**
     * Tim by user id and status.
     *
     * @param userId Tham số đầu vào.
     * @param status Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    public List<Order> findByUserIdAndStatus(int userId, String status) {
        String sql = "SELECT * FROM orders WHERE user_id = :userId AND UPPER(order_status) = :orderStatus ORDER BY created_at DESC";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("userId", userId)
                        .bind("orderStatus", status.toUpperCase())
                        .map((rs, ctx) -> mapOrder(rs))
                        .list()
        );
    }

    /**
     * Dem by user id.
     *
     * @param userId Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    public int countByUserId(int userId) {
        String sql = "SELECT COUNT(*) FROM orders WHERE user_id = :userId";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("userId", userId)
                        .mapTo(Integer.class)
                        .findFirst()
                        .orElse(0)
        );
    }

    /**
     * Dem by user id and status.
     *
     * @param userId Tham số đầu vào.
     * @param status Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    public int countByUserIdAndStatus(int userId, String status) {
        String sql = "SELECT COUNT(*) FROM orders WHERE user_id = :userId AND UPPER(order_status) = :orderStatus";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("userId", userId)
                        .bind("orderStatus", status.toUpperCase())
                        .mapTo(Integer.class)
                        .findFirst()
                        .orElse(0)
        );
    }


    // Management methods

    /**
     * Cập nhật status.
     *
     * @param orderId Tham số đầu vào.
     * @param status Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    public boolean updateStatus(int orderId, String status) {
        String sql = "UPDATE orders SET order_status = :orderStatus WHERE order_id = :orderId";
        int rowsAffected = jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("orderStatus", status)
                        .bind("orderId", orderId)
                        .execute()
        );
        return rowsAffected > 0;
    }

    /**
     * Sinh order code.
     *
     * @return Kết quả xử lý của phương thức.
     */
    public String generateOrderCode() {
        return "#HD" + orderCounter.incrementAndGet();
    }

    /**
     * Kiểm tra mã đơn hàng đã tồn tại hay chưa.
     *
     * @param orderCode Mã đơn hàng cần kiểm tra.
     * @return true nếu mã đơn hàng đã tồn tại, false nếu chưa.
     */
    public boolean existsByOrderCode(String orderCode) {
        String sql = "SELECT COUNT(*) FROM orders WHERE order_code = :orderCode";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("orderCode", orderCode)
                        .mapTo(Integer.class)
                        .findFirst()
                        .orElse(0) > 0
        );
    }


    /**
     * Lấy daily stats.
     *
     * @param startDate Tham số đầu vào.
     * @param endDate Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
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

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
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
                        })
        );
    }

    /**
     * Lấy stats.
     *
     * @param startDate Tham số đầu vào.
     * @param endDate Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    public java.util.Map<String, Object> getStats(java.util.Date startDate, java.util.Date endDate) {
        return getDailyStats(startDate, endDate);
    }

    /**
     * Lấy revenue by promotion.
     *
     * @param startDate Tham số đầu vào.
     * @param endDate Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    public java.util.List<java.util.Map<String, Object>> getRevenueByPromotion(java.util.Date startDate, java.util.Date endDate) {
        String sql = "SELECT p.promotion_id, p.promotion_name, p.promotion_type, " +
                "COALESCE(SUM(oi.total_price), 0) AS revenue " +
                "FROM promotions p " +
                "JOIN product_promotions pp ON pp.promotion_id = p.promotion_id " +
                "JOIN order_items oi ON oi.product_id = pp.product_id " +
                "JOIN orders o ON o.order_id = oi.order_id " +
                "WHERE o.created_at >= :startDate AND o.created_at < :endDate " +
                "AND o.order_status NOT IN ('cancelled') " +
                "GROUP BY p.promotion_id, p.promotion_name, p.promotion_type " +
                "ORDER BY revenue DESC";

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("startDate", startDate)
                        .bind("endDate", endDate)
                        .map((rs, ctx) -> {
                            java.util.Map<String, Object> row = new java.util.HashMap<>();
                            row.put("promotionId", rs.getInt("promotion_id"));
                            row.put("promotionName", rs.getString("promotion_name"));
                            row.put("promotionType", rs.getString("promotion_type"));
                            row.put("revenue", rs.getBigDecimal("revenue"));
                            return row;
                        })
                        .list()
        );
    }
    public int countOrders() {
        String sql = "SELECT COUNT(*) FROM orders";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .mapTo(Integer.class)
                        .one()
        );
    }
    public long totalRevenue(){
        String sql = "SELECT COALESCE(SUM(total_amount),0) FROM orders WHERE status='Hoàn thành'";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .mapTo(Long.class)
                        .one()
        );
    }


    // Helper method;

    // Helper method
    /**
     * Thực hiện map order.
     *
     * @param rs Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    private Order mapOrder(java.sql.ResultSet rs) throws java.sql.SQLException {
        Order order = new Order();
        order.setOrderId(rs.getInt("order_id"));
        order.setOrderCode(rs.getString("order_code"));
        order.setUserId(rs.getObject("user_id") != null ? rs.getInt("user_id") : null);
        order.setShippingAddressId(rs.getObject("shipping_address_id") != null ? rs.getInt("shipping_address_id") : null);
        order.setShippingFullName(rs.getString("shipping_full_name"));
        order.setShippingPhone(rs.getString("shipping_phone"));
        order.setShippingAddress(rs.getString("shipping_address"));
        order.setShippingMethod(rs.getString("shipping_method"));
        order.setShippingFee(rs.getBigDecimal("shipping_fee"));
        order.setPaymentMethod(rs.getString("payment_method"));
        order.setSubtotal(rs.getBigDecimal("subtotal"));
        order.setTotalAmount(rs.getBigDecimal("total_amount"));
        order.setOrderStatus(rs.getString("order_status"));
        order.setCreatedAt(rs.getTimestamp("created_at"));
        return order;
    }
}

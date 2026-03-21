package com.example.nhom49_webbansanphamchamsoctoc.services;

import com.example.nhom49_webbansanphamchamsoctoc.database.JDBIConnector;
import com.example.nhom49_webbansanphamchamsoctoc.dao.OrderDAO;
import com.example.nhom49_webbansanphamchamsoctoc.dao.OrderItemDAO;
import com.example.nhom49_webbansanphamchamsoctoc.dao.OrderStatusHistoryDAO;
import com.example.nhom49_webbansanphamchamsoctoc.dao.ProductVariantDAO;
import com.example.nhom49_webbansanphamchamsoctoc.dao.ProductDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.Order;
import com.example.nhom49_webbansanphamchamsoctoc.model.OrderItem;
import com.example.nhom49_webbansanphamchamsoctoc.model.OrderStatusHistory;
import com.example.nhom49_webbansanphamchamsoctoc.model.ProductVariant;
import com.example.nhom49_webbansanphamchamsoctoc.model.Product;
import com.example.nhom49_webbansanphamchamsoctoc.model.ShippingAddress;
import com.example.nhom49_webbansanphamchamsoctoc.util.AddressUtil;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class OrderService {

    private final OrderDAO orderDao;
    private final OrderItemDAO orderItemDao;
    private final OrderStatusHistoryDAO orderStatusHistoryDAO;
    private final ProductVariantDAO variantDao;
    private final ProductDAO productDao;
    private final ShippingService shippingService;
    private String lastError;

    public OrderService() {
        this.orderDao = new OrderDAO();
        this.orderItemDao = new OrderItemDAO();
        this.orderStatusHistoryDAO = new OrderStatusHistoryDAO();
        this.variantDao = new ProductVariantDAO();
        this.productDao = new ProductDAO();
        this.shippingService = new ShippingService();
    }

    // Constructor for testing
    public OrderService(OrderDAO orderDao, OrderItemDAO orderItemDao,
                        ProductVariantDAO variantDao, ProductDAO productDao) {
        this.orderDao = orderDao;
        this.orderItemDao = orderItemDao;
        this.orderStatusHistoryDAO = new OrderStatusHistoryDAO();
        this.variantDao = variantDao;
        this.productDao = productDao;
        this.shippingService = new ShippingService();
    }

    public String getLastError() {
        return lastError;
    }

    /**
     * Tạo đơn hàng từ giỏ hàng và thông tin giao hàng.
     */
    public Order createOrder(int userId, Map<Integer, Integer> cartItems,
                             ShippingAddress address, String shippingMethod, String paymentMethod) {
        lastError = null;

        if (cartItems == null || cartItems.isEmpty()) {
            lastError = "Giỏ hàng trống";
            return null;
        }

        if (address == null) {
            lastError = "Địa chỉ giao hàng không hợp lệ";
            return null;
        }

        // Validate stock trước khi tạo đơn
        List<String> stockErrors = validateStockForOrder(cartItems);
        if (!stockErrors.isEmpty()) {
            lastError = "Một số sản phẩm vượt quá số lượng tồn kho:\n" + String.join("\n", stockErrors);
            return null;
        }

        // Convert cart items to order items
        List<OrderItem> orderItems = convertCartToOrderItems(cartItems);
        if (orderItems.isEmpty()) {
            lastError = "Không thể xử lý sản phẩm trỗng giỏ hàng";
            return null;
        }

        // Calculate totals
        BigDecimal subtotal = calculateSubtotal(orderItems);
        BigDecimal shippingFee = shippingService.getShippingFee(shippingMethod);
        BigDecimal total = calculateTotal(subtotal, shippingFee);

        // Create order
        Order order = new Order();
        order.setOrderCode(generateOrderCode());
        order.setUserId(userId);
        order.setShippingAddressId(address.getAddressId());
        order.setShippingFullName(address.getFullName());
        order.setShippingPhone(address.getPhone());
        order.setShippingAddress(AddressUtil.formatFullAddress(address));
        order.setShippingMethod(shippingMethod);
        order.setShippingFee(shippingFee);
        order.setPaymentMethod(paymentMethod);
        order.setSubtotal(subtotal);
        order.setTotalAmount(total);
        order.setOrderStatus("pending");

        try {
            Order createdOrder = JDBIConnector.getInstance().inTransaction(handle -> {
                String insertOrderSql = "INSERT INTO orders (order_code, user_id, shipping_address_id, shipping_full_name, " +
                        "shipping_phone, shipping_address, shipping_method, shipping_fee, payment_method, subtotal, total_amount, order_status, note) " +
                        "VALUES (:orderCode, :userId, :shippingAddressId, :shippingFullName, :shippingPhone, :shippingAddress, :shippingMethod, :shippingFee, :paymentMethod, :subtotal, :totalAmount, :orderStatus, :note)";

                Integer orderId = handle.createUpdate(insertOrderSql)
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
                        .bind("orderStatus", order.getOrderStatus())
                        .bind("note", order.getNote())
                        .executeAndReturnGeneratedKeys("order_id")
                        .mapTo(Integer.class)
                        .findFirst()
                        .orElse(null);

                if (orderId == null || orderId <= 0) {
                    throw new IllegalStateException("Không thể tạo đơn hàng");
                }

                String insertHistorySql = "INSERT INTO order_status_history (order_id, status, note) VALUES (:orderId, :status, :note)";
                int historyInserted = handle.createUpdate(insertHistorySql)
                        .bind("orderId", orderId)
                        .bind("status", order.getOrderStatus())
                        .bind("note", "Initial status")
                        .execute();
                if (historyInserted == 0) {
                    throw new IllegalStateException("Không thể lưu lịch sử trạng thái đơn hàng");
                }

                String insertItemSql = "INSERT INTO order_items (order_id, product_id, variant_id, product_name, variant_name, quantity, unit_price, total_price) " +
                        "VALUES (:orderId, :productId, :variantId, :productName, :variantName, :quantity, :unitPrice, :totalPrice)";

                var batch = handle.prepareBatch(insertItemSql);
                for (OrderItem item : orderItems) {
                    item.setOrderId(orderId);
                    batch.bind("orderId", orderId)
                            .bind("productId", item.getProductId())
                            .bind("variantId", item.getVariantId())
                            .bind("productName", item.getProductName())
                            .bind("variantName", item.getVariantName())
                            .bind("quantity", item.getQuantity())
                            .bind("unitPrice", item.getUnitPrice())
                            .bind("totalPrice", item.getTotalPrice())
                            .add();
                }

                int[] insertedRows = batch.execute();
                for (int rowCount : insertedRows) {
                    if (rowCount == 0) {
                        throw new IllegalStateException("Không thể lưu chi tiết đơn hàng");
                    }
                }

                for (OrderItem item : orderItems) {
                    int affected = handle.createUpdate("UPDATE product_variants SET stock_quantity = stock_quantity - :quantity WHERE variant_id = :variantId AND stock_quantity >= :quantity")
                            .bind("variantId", item.getVariantId())
                            .bind("quantity", item.getQuantity())
                            .execute();
                    if (affected == 0) {
                        throw new IllegalStateException("Stock changed, please try again");
                    }
                }

                order.setOrderId(orderId);
                order.setOrderItems(orderItems);
                return order;
            });
            return createdOrder;
        } catch (Exception ex) {
            if (ex.getMessage() != null && !ex.getMessage().isBlank()) {
                lastError = ex.getMessage();
            } else {
                lastError = "Không thể tạo đơn hàng";
            }
        }

        return null;
    }

    private List<String> validateStockForOrder(Map<Integer, Integer> cartItems) {
        List<String> errors = new ArrayList<>();

        for (Map.Entry<Integer, Integer> entry : cartItems.entrySet()) {
            int variantId = entry.getKey();
            int requestedQuantity = entry.getValue();

            ProductVariant variant = variantDao.findById(variantId);
            if (variant == null) {
                errors.add("- Sản phẩm không tồn tại (ID: " + variantId + ")");
                continue;
            }

            if (requestedQuantity > variant.getStockQuantity()) {
                Product product = productDao.findById(variant.getProductId());
                String productName = product != null ? product.getProductName() : "Sản phẩm #" + variant.getProductId();
                String variantName = variant.getVariantName() != null ? " (" + variant.getVariantName() + ")" : "";
                errors.add("- " + productName + variantName + ": Yêu cầu " + requestedQuantity +
                        ", còn lại " + variant.getStockQuantity());
            }
        }

        return errors;
    }


    // Order calculation methods

    public BigDecimal calculateSubtotal(List<OrderItem> items) {
        return items.stream()
                .map(OrderItem::getTotalPrice)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    public BigDecimal calculateTotal(BigDecimal subtotal, BigDecimal shippingFee) {
        return subtotal.add(shippingFee != null ? shippingFee : BigDecimal.ZERO);
    }

    public String generateOrderCode() {
        String code;
        do {
            code = orderDao.generateOrderCode();
        } while (orderDao.existsByOrderCode(code));
        return code;
    }

    // Order query methods

    public List<Order> getOrdersByUser(int userId) {
        List<Order> orders = orderDao.findByUserId(userId);
        enrichOrdersWithItems(orders);
        return orders;
    }

    public Order getOrderById(int orderId) {
        Order order = orderDao.findById(orderId);
        if (order != null) {
            enrichOrderWithItems(order);
        }
        return order;
    }

    public Order getOrderByCode(String orderCode) {
        Order order = orderDao.findByOrderCode(orderCode);
        if (order != null) {
            enrichOrderWithItems(order);
        }
        return order;
    }

    public List<Order> getAllOrders() {
        List<Order> orders = orderDao.findAll();
        enrichOrdersWithItems(orders);
        return orders;
    }


    public List<Order> getOrdersByStatus(String status) {
        List<Order> orders = orderDao.findByStatus(status);
        enrichOrdersWithItems(orders);
        return orders;
    }

    public List<Order> getOrdersByUserAndStatus(int userId, String status) {
        List<Order> orders = orderDao.findByUserIdAndStatus(userId, status);
        enrichOrdersWithItems(orders);
        return orders;
    }

    public int countOrdersByUser(int userId) {
        return orderDao.countByUserId(userId);
    }

    public int countOrdersByUserAndStatus(int userId, String status) {
        return orderDao.countByUserIdAndStatus(userId, status);
    }

    // Order management methods

    /**
     * Cập nhật trạng thái đơn hàng.
     */
    public boolean updateOrderStatus(int orderId, String status) {
        if (!isValidOrderStatus(status)) {
            lastError = "Trạng thái đơn hàng không hợp lệ: " + status;
            return false;
        }

        Order order = orderDao.findById(orderId);
        if (order == null) {
            lastError = "Không tìm thấy đơn hàng với ID: " + orderId;
            return false;
        }

        boolean result = orderDao.updateStatus(orderId, status);
        if (!result) {
            lastError = "Không thể cập nhật trạng thái đơn hàng";
            return false;
        }

        OrderStatusHistory history = new OrderStatusHistory();
        history.setOrderId(orderId);
        history.setStatus(status);
        history.setNote("Status updated");
        orderStatusHistoryDAO.insert(history);
        return result;
    }

    /**
     * Hủy đơn hàng và hoàn trả stock.
     */
    public boolean cancelOrder(int orderId) {
        Order order = orderDao.findById(orderId);
        if (order == null) {
            lastError = "Không tìm thấy đơn hàng với ID: " + orderId;
            return false;
        }

        // Chỉ có thể hủy đơn hàng ở trạng thái pending hoặc confirmed
        String currentStatus = order.getOrderStatus();
        if (currentStatus != null &&
                (currentStatus.equals("shipping") || currentStatus.equals("completed"))) {
            lastError = "Không thể hủy đơn hàng đang giao hoặc đã hoàn thành";
            return false;
        }

        boolean cancelled = updateOrderStatus(orderId, "cancelled");
        if (cancelled) {
            // Hoàn trả stock cho từng item
            List<OrderItem> items = orderItemDao.findByOrderId(orderId);
            for (OrderItem item : items) {
                if (item.getVariantId() != null) {
                    variantDao.incrementStock(item.getVariantId(), item.getQuantity());
                }
            }
        }
        return cancelled;
    }

    private List<OrderItem> convertCartToOrderItems(Map<Integer, Integer> cartItems) {
        List<OrderItem> orderItems = new ArrayList<>();

        for (Map.Entry<Integer, Integer> entry : cartItems.entrySet()) {
            int variantId = entry.getKey();
            int quantity = entry.getValue();

            if (quantity <= 0) continue;

            ProductVariant variant = variantDao.findById(variantId);
            if (variant == null) continue;

            Product product = productDao.findById(variant.getProductId());
            if (product == null) continue;

            // Use sale price if available, otherwise original price
            BigDecimal unitPrice = variant.getSalePrice() != null ?
                    variant.getSalePrice() : variant.getOriginalPrice();

            OrderItem item = new OrderItem();
            item.setProductId(product.getProductId());
            item.setVariantId(variantId);
            item.setProductName(product.getProductName());
            item.setVariantName(variant.getVariantName());
            item.setQuantity(quantity);
            item.setUnitPrice(unitPrice);
            item.setTotalPrice(unitPrice.multiply(BigDecimal.valueOf(quantity)));

            orderItems.add(item);
        }

        return orderItems;
    }

    private void enrichOrderWithItems(Order order) {
        if (order != null) {
            List<OrderItem> items = orderItemDao.findByOrderId(order.getOrderId());
            order.setOrderItems(items);
        }
    }

    private void enrichOrdersWithItems(List<Order> orders) {
        for (Order order : orders) {
            enrichOrderWithItems(order);
        }
    }

    private boolean isValidOrderStatus(String status) {
        return status != null &&
                (status.equals("pending") || status.equals("confirmed") ||
                        status.equals("shipping") || status.equals("completed") ||
                        status.equals("cancelled"));
    }

    public String getOrderStatusDisplayName(String status) {
        switch (status) {
            case "pending":
                return "Chờ xác nhận";
            case "confirmed":
                return "Đã xác nhận";
            case "shipping":
                return "Đang giao hàng";
            case "completed":
                return "Hoàn thành";
            case "cancelled":
                return "Đã hủy";
            default:
                return status;
        }
    }

    private boolean decrementStock(List<OrderItem> orderItems) {
        if (orderItems == null || orderItems.isEmpty()) {
            return true;
        }
        for (OrderItem item : orderItems) {
            if (item.getVariantId() == null) {
                return false;
            }
            if (!variantDao.decrementStock(item.getVariantId(), item.getQuantity())) {
                return false;
            }
        }
        return true;
    }

    public BigDecimal getTotalSpendingByUser(int userId) {
        return orderDao.getTotalSpendingByUser(userId);
    }

    public List<Order> getRecentOrdersByUser(int userId, int limit) {
        List<Order> orders = orderDao.findByUserIdWithLimit(userId, limit);
        // Load order items for each order
        for (Order order : orders) {
            List<OrderItem> items = orderItemDao.findByOrderId(order.getOrderId());
            order.setOrderItems(items);
        }
        return orders;
    }

    public Map<String, Integer> getOrderCountsByStatus(int userId) {
        return orderDao.getOrderCountsByStatus(userId);
    }
}


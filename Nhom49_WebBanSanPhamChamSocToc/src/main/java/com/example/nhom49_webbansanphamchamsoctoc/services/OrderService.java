package com.example.nhom49_webbansanphamchamsoctoc.services;

import com.example.nhom49_webbansanphamchamsoctoc.dao.OrderDAO;
import com.example.nhom49_webbansanphamchamsoctoc.dao.OrderItemDAO;
import com.example.nhom49_webbansanphamchamsoctoc.dao.ProductVariantDAO;
import com.example.nhom49_webbansanphamchamsoctoc.dao.ProductDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.Order;
import com.example.nhom49_webbansanphamchamsoctoc.model.OrderItem;
import com.example.nhom49_webbansanphamchamsoctoc.model.ProductVariant;
import com.example.nhom49_webbansanphamchamsoctoc.model.Product;
import com.example.nhom49_webbansanphamchamsoctoc.model.ShippingAddress;
import com.example.nhom49_webbansanphamchamsoctoc.util.AddressUtil;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Service class cho Order business logic
 * Xử lý order creation, calculation, management
 */
public class OrderService {

    private final OrderDAO orderDAO;
    private final OrderItemDAO orderItemDAO;
    private final ProductVariantDAO variantDAO;
    private final ProductDAO productDAO;
    private final ShippingService shippingService;
    private String lastError;

    public OrderService() {
        this.orderDAO = new OrderDAO();
        this.orderItemDAO = new OrderItemDAO();
        this.variantDAO = new ProductVariantDAO();
        this.productDAO = new ProductDAO();
        this.shippingService = new ShippingService();
    }

    /**
     * Lấy thông báo lỗi cuối cùng
     */
    public String getLastError() {
        return lastError;
    }

    /**
     * Tạo order từ session cart
     *
     * @param userId         ID của user
     * @param cartItems      Map<variantId, quantity> từ session
     * @param address        Địa chỉ giao hàng
     * @param shippingMethod "standard" hoặc "express"
     * @param paymentMethod  Phương thức thanh toán
     * @return Order đã tạo hoặc null nếu thất bại
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
            lastError = "Không thể xử lý sản phẩm trong giỏ hàng";
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

        // Insert order
        int orderId = orderDAO.insert(order);
        if (orderId > 0) {
            order.setOrderId(orderId);

            // Set order ID for all items and insert
            for (OrderItem item : orderItems) {
                item.setOrderId(orderId);
            }

            if (orderItemDAO.insertBatch(orderItems)) {
                if (!decrementStock(orderItems)) {
                    orderItemDAO.deleteByOrderId(orderId);
                    orderDAO.delete(orderId);
                    lastError = "Stock changed, please try again";
                } else {
                    order.setOrderItems(orderItems);
                    return order;
                }
            } else {
                // Rollback: delete order if items insertion failed
                orderDAO.delete(orderId);
                lastError = "Không thể lưu chi tiết đơn hàng";
            }
        } else {
            lastError = "Không thể tạo đơn hàng";
        }

        return null;
    }

    /**
     * Validate stock cho tất cả sản phẩm trong cart
     *
     * @param cartItems Map<variantId, quantity>
     * @return List các thông báo lỗi (rỗng nếu tất cả hợp lệ)
     */
    private List<String> validateStockForOrder(Map<Integer, Integer> cartItems) {
        List<String> errors = new ArrayList<>();

        for (Map.Entry<Integer, Integer> entry : cartItems.entrySet()) {
            int variantId = entry.getKey();
            int requestedQuantity = entry.getValue();

            ProductVariant variant = variantDAO.findById(variantId);
            if (variant == null) {
                errors.add("- Sản phẩm không tồn tại (ID: " + variantId + ")");
                continue;
            }

            if (requestedQuantity > variant.getStockQuantity()) {
                Product product = productDAO.findById(variant.getProductId());
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

    public BigDecimal getShippingFee(String shippingMethod) {
        return shippingService.getShippingFee(shippingMethod);
    }

    public String generateOrderCode() {
        String code;
        do {
            code = orderDAO.generateOrderCode();
        } while (orderDAO.existsByOrderCode(code));
        return code;
    }

    // Order query methods

    public List<Order> getOrdersByUser(int userId) {
        List<Order> orders = orderDAO.findByUserId(userId);
        enrichOrdersWithItems(orders);
        return orders;
    }

    public Order getOrderById(int orderId) {
        Order order = orderDAO.findById(orderId);
        if (order != null) {
            enrichOrderWithItems(order);
        }
        return order;
    }

    public Order getOrderByCode(String orderCode) {
        Order order = orderDAO.findByOrderCode(orderCode);
        if (order != null) {
            enrichOrderWithItems(order);
        }
        return order;
    }

    public List<Order> getAllOrders() {
        List<Order> orders = orderDAO.findAll();
        enrichOrdersWithItems(orders);
        return orders;
    }

    public List<Order> getOrdersByStatus(String status) {
        List<Order> orders = orderDAO.findByStatus(status);
        enrichOrdersWithItems(orders);
        return orders;
    }

    /**
     * Lấy đơn hàng theo user và status
     */
    public List<Order> getOrdersByUserAndStatus(int userId, String status) {
        List<Order> orders = orderDAO.findByUserIdAndStatus(userId, status);
        enrichOrdersWithItems(orders);
        return orders;
    }

    /**
     * Đếm số đơn hàng của user
     */
    public int countOrdersByUser(int userId) {
        return orderDAO.countByUserId(userId);
    }

    /**
     * Đếm số đơn hàng theo user và status
     */
    public int countOrdersByUserAndStatus(int userId, String status) {
        return orderDAO.countByUserIdAndStatus(userId, status);
    }

    // Order management methods

    public boolean cancelOrder(int orderId) {
        Order order = orderDAO.findById(orderId);
        if (order != null && "pending".equals(order.getOrderStatus())) {
            return orderDAO.updateStatus(orderId, "cancelled");
        }
        return false;
    }

    public boolean updateOrderStatus(int orderId, String newStatus) {
        if (!isValidOrderStatus(newStatus)) {
            return false;
        }
        return orderDAO.updateStatus(orderId, newStatus);
    }

    // Helper methods

    private List<OrderItem> convertCartToOrderItems(Map<Integer, Integer> cartItems) {
        List<OrderItem> orderItems = new ArrayList<>();

        for (Map.Entry<Integer, Integer> entry : cartItems.entrySet()) {
            int variantId = entry.getKey();
            int quantity = entry.getValue();

            if (quantity <= 0) continue;

            ProductVariant variant = variantDAO.findById(variantId);
            if (variant == null) continue;

            Product product = productDAO.findById(variant.getProductId());
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
            List<OrderItem> items = orderItemDAO.findByOrderId(order.getOrderId());
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

    /**
     * Lấy tên hiển thị tiếng Việt cho order status
     */
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
            if (!variantDAO.decrementStock(item.getVariantId(), item.getQuantity())) {
                return false;
            }
        }
        return true;
    }
}

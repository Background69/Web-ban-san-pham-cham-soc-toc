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
 * Lớp OrderService.
 */
public class OrderService {

    private final OrderDAO orderDao;
    private final OrderItemDAO orderItemDao;
    private final ProductVariantDAO variantDao;
    private final ProductDAO productDao;
    private final ShippingService shippingService;
    private String lastError;

    /**
     * Thực hiện order service.
     */
    public OrderService() {
        this.orderDao = new OrderDAO();
        this.orderItemDao = new OrderItemDAO();
        this.variantDao = new ProductVariantDAO();
        this.productDao = new ProductDAO();
        this.shippingService = new ShippingService();
    }

    // Constructor for testing
    /**
     * Khởi tạo OrderService với cac DAO (phuc vu test).
     *
     * @param orderDao     DAO đơn hàng.
     * @param orderItemDao DAO chỉ tiet đơn hàng.
     * @param variantDao   DAO bien the sản phẩm.
     * @param productDao   DAO sản phẩm.
     */
    public OrderService(OrderDAO orderDao, OrderItemDAO orderItemDao,
                        ProductVariantDAO variantDao, ProductDAO productDao) {
        this.orderDao = orderDao;
        this.orderItemDao = orderItemDao;
        this.variantDao = variantDao;
        this.productDao = productDao;
        this.shippingService = new ShippingService();
    }

    /**
     * Lấy last error.
     *
     * @return Kết quả xử lý của phương thức.
     */
    public String getLastError() {
        return lastError;
    }

    /**
     * Tạo đơn hàng từ giỏ hàng và thong tin giao hàng.
     *
     * @param userId         ID nguoi dung.
     * @param cartItems      Map bien the và số lượng.
     * @param address        Địa chỉ giao hàng.
     * @param shippingMethod Phương thức giao hàng.
     * @param paymentMethod  Phương thức thanh toán.
     * @return Đơn hàng đã tao hoặc null nếu thất bại.
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

        // Insert order
        int orderId = orderDao.insert(order);
        if (orderId > 0) {
            order.setOrderId(orderId);

            // Set order ID for all items and insert
            for (OrderItem item : orderItems) {
                item.setOrderId(orderId);
            }

            if (orderItemDao.insertBatch(orderItems)) {
                if (!decrementStock(orderItems)) {
                    orderItemDao.deleteByOrderId(orderId);
                    orderDao.delete(orderId);
                    lastError = "Stock changed, please try again";
                } else {
                    order.setOrderItems(orderItems);
                    return order;
                }
            } else {
                // Rollback: delete order if items insertion failed
                orderDao.delete(orderId);
                lastError = "Không thể lưu chỉ tiết đơn hàng";
            }
        } else {
            lastError = "Không thể tạo đơn hàng";
        }

        return null;
    }

    /**
     * Kiểm tra hop le stock for order.
     *
     * @param cartItems Map<variantId, quantity>
     * @return List các thông báo lỗi (rỗng nếu tất cả hợp lệ)
     */
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

    /**
     * Thực hiện calculate subtotal.
     *
     * @param items Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    public BigDecimal calculateSubtotal(List<OrderItem> items) {
        return items.stream()
                .map(OrderItem::getTotalPrice)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    /**
     * Thực hiện calculate total.
     *
     * @param subtotal Tham số đầu vào.
     * @param shippingFee Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    public BigDecimal calculateTotal(BigDecimal subtotal, BigDecimal shippingFee) {
        return subtotal.add(shippingFee != null ? shippingFee : BigDecimal.ZERO);
    }

    /**
     * Sinh order code.
     *
     * @return Kết quả xử lý của phương thức.
     */
    public String generateOrderCode() {
        String code;
        do {
            code = orderDao.generateOrderCode();
        } while (orderDao.existsByOrderCode(code));
        return code;
    }

    // Order query methods

    /**
     * Lấy orders by user.
     *
     * @param userId Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    public List<Order> getOrdersByUser(int userId) {
        List<Order> orders = orderDao.findByUserId(userId);
        enrichOrdersWithItems(orders);
        return orders;
    }

    /**
     * Lấy order by id.
     *
     * @param orderId Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    public Order getOrderById(int orderId) {
        Order order = orderDao.findById(orderId);
        if (order != null) {
            enrichOrderWithItems(order);
        }
        return order;
    }

    /**
     * Lấy order by code.
     *
     * @param orderCode Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    public Order getOrderByCode(String orderCode) {
        Order order = orderDao.findByOrderCode(orderCode);
        if (order != null) {
            enrichOrderWithItems(order);
        }
        return order;
    }

    /**
     * Lấy all orders.
     *
     * @return Kết quả xử lý của phương thức.
     */
    public List<Order> getAllOrders() {
        List<Order> orders = orderDao.findAll();
        enrichOrdersWithItems(orders);
        return orders;
    }


    /**
     * Lấy orders by status.
     *
     * @param status Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    public List<Order> getOrdersByStatus(String status) {
        List<Order> orders = orderDao.findByStatus(status);
        enrichOrdersWithItems(orders);
        return orders;
    }

    /**
     * Lấy orders by user and status.
     *
     * @param userId Tham số đầu vào.
     * @param status Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    public List<Order> getOrdersByUserAndStatus(int userId, String status) {
        List<Order> orders = orderDao.findByUserIdAndStatus(userId, status);
        enrichOrdersWithItems(orders);
        return orders;
    }

    /**
     * Dem orders by user.
     *
     * @param userId Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    public int countOrdersByUser(int userId) {
        return orderDao.countByUserId(userId);
    }

    /**
     * Dem orders by user and status.
     *
     * @param userId Tham số đầu vào.
     * @param status Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    public int countOrdersByUserAndStatus(int userId, String status) {
        return orderDao.countByUserIdAndStatus(userId, status);
    }

    // Order management methods

    /**
     * Cập nhật trạng thái đơn hàng.
     *
     * @param orderId ID đơn hàng cần cập nhật.
     * @param status Trạng thái mới của đơn hàng.
     * @return true nếu cập nhật thành công, false nếu thất bại.
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
        }
        return result;
    }

    /**
     * Hủy đơn hàng.
     *
     * @param orderId ID đơn hàng cần hủy.
     * @return true nếu hủy thành công, false nếu thất bại.
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

        return updateOrderStatus(orderId, "cancelled");
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

    /**
     * Thực hiện enrich order with items.
     *
     * @param order Tham số đầu vào.
     * @return Không trả về giá trị.
     */
    private void enrichOrderWithItems(Order order) {
        if (order != null) {
            List<OrderItem> items = orderItemDao.findByOrderId(order.getOrderId());
            order.setOrderItems(items);
        }
    }


    /**
     * Thực hiện enrich orders with items.
     *
     * @param orders Tham số đầu vào.
     * @return Không trả về giá trị.
     */
    private void enrichOrdersWithItems(List<Order> orders) {
        for (Order order : orders) {
            enrichOrderWithItems(order);
        }
    }

    /**
     * Kiểm tra valid order status.
     *
     * @param status Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    private boolean isValidOrderStatus(String status) {
        return status != null &&
                (status.equals("pending") || status.equals("confirmed") ||
                        status.equals("shipping") || status.equals("completed") ||
                        status.equals("cancelled"));
    }


    /**
     * Lấy order status display name.
     *
     * @param status Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
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

    /**
     * Thực hiện decrement stock.
     *
     * @param orderItems Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
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

    /**
     * Lấy tổng chi tiêu của user
     */
    public BigDecimal getTotalSpendingByUser(int userId) {
        return orderDao.getTotalSpendingByUser(userId);
    }

    /**
     * Lấy danh sách đơn hàng gần đây của user
     */
    public List<Order> getRecentOrdersByUser(int userId, int limit) {
        List<Order> orders = orderDao.findByUserIdWithLimit(userId, limit);
        // Load order items for each order
        for (Order order : orders) {
            List<OrderItem> items = orderItemDao.findByOrderId(order.getOrderId());
            order.setOrderItems(items);
        }
        return orders;
    }

    /**
     * Lấy số lượng đơn hàng theo từng status
     */
    public Map<String, Integer> getOrderCountsByStatus(int userId) {
        return orderDao.getOrderCountsByStatus(userId);
    }
}





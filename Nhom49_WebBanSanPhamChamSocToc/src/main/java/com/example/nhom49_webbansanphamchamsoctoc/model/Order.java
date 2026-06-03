package com.example.nhom49_webbansanphamchamsoctoc.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.List;

/**
 * Model Order - Bảng orders trong database
 * Quản lý đơn hàng
 */
public class Order implements Serializable {
    private int orderId;
    private String orderCode;
    private Integer userId;
    private Integer shippingAddressId;
    private String shippingFullName;
    private String shippingPhone;
    private String shippingAddress;
    private String shippingMethod; // 'standard', 'express'
    private BigDecimal shippingFee;
    private String paymentMethod; // 'cod', 'bank_transfer', 'VNPAY'
    private BigDecimal subtotal;
    private BigDecimal totalAmount;
    private String orderStatus; // 'pending', 'pending_payment', 'confirmed', 'shipping', 'completed', 'cancelled'
    private String note;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Đối tượng liên kết
    private User user;
    private ShippingAddress address;
    private List<OrderItem> orderItems;

    // Constructors
    public Order() {
    }

    // Getters and Setters
    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public String getOrderCode() {
        return orderCode;
    }

    public void setOrderCode(String orderCode) {
        this.orderCode = orderCode;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public Integer getShippingAddressId() {
        return shippingAddressId;
    }

    public void setShippingAddressId(Integer shippingAddressId) {
        this.shippingAddressId = shippingAddressId;
    }

    public String getShippingFullName() {
        return shippingFullName;
    }

    public void setShippingFullName(String shippingFullName) {
        this.shippingFullName = shippingFullName;
    }

    public String getShippingPhone() {
        return shippingPhone;
    }

    public void setShippingPhone(String shippingPhone) {
        this.shippingPhone = shippingPhone;
    }

    public String getShippingAddress() {
        return shippingAddress;
    }

    public void setShippingAddress(String shippingAddress) {
        this.shippingAddress = shippingAddress;
    }

    public String getShippingMethod() {
        return shippingMethod;
    }

    public void setShippingMethod(String shippingMethod) {
        this.shippingMethod = shippingMethod;
    }

    public BigDecimal getShippingFee() {
        return shippingFee;
    }

    public void setShippingFee(BigDecimal shippingFee) {
        this.shippingFee = shippingFee;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public BigDecimal getSubtotal() {
        return subtotal;
    }

    public void setSubtotal(BigDecimal subtotal) {
        this.subtotal = subtotal;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getOrderStatus() {
        return orderStatus;
    }

    public void setOrderStatus(String orderStatus) {
        this.orderStatus = orderStatus;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public ShippingAddress getAddress() {
        return address;
    }

    public void setAddress(ShippingAddress address) {
        this.address = address;
    }

    public List<OrderItem> getOrderItems() {
        return orderItems;
    }

    public void setOrderItems(List<OrderItem> orderItems) {
        this.orderItems = orderItems;
    }

    // Helper methods
    public String getStatusDisplayName() {
        switch (orderStatus) {
            case "pending":
                return "Chờ xác nhận";
            case "pending_payment":
                return "Chờ thanh toán";
            case "confirmed":
                return "Đã xác nhận";
            case "shipping":
                return "Đang giao hàng";
            case "completed":
                return "Hoàn thành";
            case "cancelled":
                return "Đã hủy";
            default:
                return orderStatus;
        }
    }

    public String getPaymentMethodDisplayName() {
        switch (paymentMethod) {
            case "cod":
                return "Thanh toán khi nhận hàng";
            case "bank":
            case "bank_transfer":
                return "Chuyển khoản ngân hàng";
            case "VNPAY":
                return "Cổng VNPAY-QR";
            default:
                return paymentMethod;
        }
    }

    public String getShippingMethodDisplayName() {
        switch (shippingMethod) {
            case "standard":
                return "Giao hàng tiêu chuẩn";
            case "express":
                return "Giao hàng nhanh";
            default:
                return shippingMethod;
        }
    }

    @Override
    public String toString() {
        return "Order{" +
                "orderId=" + orderId +
                ", orderCode='" + orderCode + '\'' +
                ", userId=" + userId +
                ", totalAmount=" + totalAmount +
                ", orderStatus='" + orderStatus + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}

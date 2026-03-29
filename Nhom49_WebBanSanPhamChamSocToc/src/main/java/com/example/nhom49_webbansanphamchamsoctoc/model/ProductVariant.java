package com.example.nhom49_webbansanphamchamsoctoc.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Model ProductVariant - Bảng product_variants trong database
 * Quản lý các biến thể sản phẩm (dung tích: 30ml, 50ml, 100ml...)
 */
public class ProductVariant implements Serializable {
    private int variantId;
    private int productId;
    private String variantName;
    private String sku;
    private BigDecimal originalPrice;
    private BigDecimal salePrice;
    private int discountPercent;
    private int stockQuantity;
    private boolean isDefault;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Constructors
    public ProductVariant() {
    }

    // Getters and Setters
    public int getVariantId() {
        return variantId;
    }

    public void setVariantId(int variantId) {
        this.variantId = variantId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getVariantName() {
        return variantName;
    }

    public void setVariantName(String variantName) {
        this.variantName = variantName;
    }

    public String getSku() {
        return sku;
    }

    public void setSku(String sku) {
        this.sku = sku;
    }

    public BigDecimal getOriginalPrice() {
        return originalPrice;
    }

    public void setOriginalPrice(BigDecimal originalPrice) {
        this.originalPrice = originalPrice;
    }

    public BigDecimal getSalePrice() {
        return salePrice;
    }

    public void setSalePrice(BigDecimal salePrice) {
        this.salePrice = salePrice;
    }

    public int getDiscountPercent() {
        return discountPercent;
    }

    public void setDiscountPercent(int discountPercent) {
        this.discountPercent = discountPercent;
    }

    public int getStockQuantity() {
        return stockQuantity;
    }

    public void setStockQuantity(int stockQuantity) {
        this.stockQuantity = stockQuantity;
    }

    public boolean isDefault() {
        return isDefault;
    }

    public void setDefault(boolean aDefault) {
        isDefault = aDefault;
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

    // Helper method - Lấy giá hiện tại (sale price nếu có, không thì original price)
    public BigDecimal getCurrentPrice() {
        return (salePrice != null && salePrice.compareTo(BigDecimal.ZERO) > 0) ? salePrice : originalPrice;
    }

    // Helper method - Kiểm tra còn hàng
    public boolean isInStock() {
        return stockQuantity > 0;
    }

    @Override
    public String toString() {
        return "ProductVariant{" +
                "variantId=" + variantId +
                ", productId=" + productId +
                ", variantName='" + variantName + '\'' +
                ", sku='" + sku + '\'' +
                ", originalPrice=" + originalPrice +
                ", salePrice=" + salePrice +
                ", discountPercent=" + discountPercent +
                ", stockQuantity=" + stockQuantity +
                ", isDefault=" + isDefault +
                '}';
    }
}

package com.example.nhom49_webbansanphamchamsoctoc.model;

import java.sql.Timestamp;

/**
 * Model ProductImage - Bảng product_images trong database
 * Quản lý hình ảnh sản phẩm (gallery)
 */
public class ProductImage {
    private int imageId;
    private int productId;
    private String imageUrl;
    private boolean isPrimary;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Constructors
    public ProductImage() {
    }

    // Getters and Setters
    public int getImageId() {
        return imageId;
    }

    public void setImageId(int imageId) {
        this.imageId = imageId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public boolean isPrimary() {
        return isPrimary;
    }

    public void setPrimary(boolean primary) {
        isPrimary = primary;
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

}

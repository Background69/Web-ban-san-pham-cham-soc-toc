package com.example.nhom49_webbansanphamchamsoctoc.model;

import java.sql.Timestamp;
import java.util.List;

/**
 * Model Brand - Bảng brands trong database
 * Quản lý thông tin thương hiệu sản phẩm
 */
public class Brand {
    private int brandId;
    private String brandName;
    private String brandSlug;
    private String logoUrl;
    private String origin;
    private String shortDescription;
    private String fullDescription;
    private Timestamp createdAt;

    // Constructors
    public Brand() {
    }

    // Getters and Setters
    public int getBrandId() {
        return brandId;
    }

    public void setBrandId(int brandId) {
        this.brandId = brandId;
    }

    public String getBrandName() {
        return brandName;
    }

    public void setBrandName(String brandName) {
        this.brandName = brandName;
    }

    public String getBrandSlug() {
        return brandSlug;
    }

    public void setBrandSlug(String brandSlug) {
        this.brandSlug = brandSlug;
    }

    public String getLogoUrl() {
        return logoUrl;
    }

    public void setLogoUrl(String logoUrl) {
        this.logoUrl = logoUrl;
    }

    public String getOrigin() {
        return origin;
    }

    public void setOrigin(String origin) {
        this.origin = origin;
    }

    public String getShortDescription() {
        return shortDescription;
    }

    public void setShortDescription(String shortDescription) {
        this.shortDescription = shortDescription;
    }

    public String getFullDescription() {
        return fullDescription;
    }

    public void setFullDescription(String fullDescription) {
        this.fullDescription = fullDescription;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

}

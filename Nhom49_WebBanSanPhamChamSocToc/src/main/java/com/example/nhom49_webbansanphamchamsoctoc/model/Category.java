package com.example.nhom49_webbansanphamchamsoctoc.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Model Category - Bảng categories trong database
 * Quản lý danh mục sản phẩm (Dầu gội, Dầu xả, Kem ủ tóc...)
 */
public class Category implements Serializable {
    private int categoryId;
    private String categoryName;
    private String categorySlug;
    private Integer parentCategoryId;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Constructors
    public Category() {
    }

    // Getters and Setters
    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public String getCategorySlug() {
        return categorySlug;
    }

    public void setCategorySlug(String categorySlug) {
        this.categorySlug = categorySlug;
    }

    public Integer getParentCategoryId() {
        return parentCategoryId;
    }

    public void setParentCategoryId(Integer parentCategoryId) {
        this.parentCategoryId = parentCategoryId;
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

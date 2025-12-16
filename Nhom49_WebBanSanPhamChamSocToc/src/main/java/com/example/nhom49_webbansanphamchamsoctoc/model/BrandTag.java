package com.example.nhom49_webbansanphamchamsoctoc.model;

/**
 * Model BrandTag - Bảng brand_tags trong database
 * Quản lý các tag/đặc điểm của thương hiệu
 */
public class BrandTag {
    private int tagId;
    private int brandId;
    private String tagText;
    private String iconClass;

    // Constructors
    public BrandTag() {
    }

    // Getters and Setters
    public int getTagId() {
        return tagId;
    }

    public void setTagId(int tagId) {
        this.tagId = tagId;
    }

    public int getBrandId() {
        return brandId;
    }

    public void setBrandId(int brandId) {
        this.brandId = brandId;
    }

    public String getTagText() {
        return tagText;
    }

    public void setTagText(String tagText) {
        this.tagText = tagText;
    }

    public String getIconClass() {
        return iconClass;
    }

    public void setIconClass(String iconClass) {
        this.iconClass = iconClass;
    }


}

package com.example.nhom49_webbansanphamchamsoctoc.model;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.List;

/**
 * Model Product - Bảng products trong database
 * Quản lý thông tin sản phẩm chăm sóc tóc
 */
public class Product {
    private int productId;
    private String productName;
    private String productSlug;
    private Integer brandId;
    private Integer categoryId;
    private String origin;
    private String shortDescription;
    private String fullDescription;
    private int stockQuantity;
    private boolean isFeatured;
    private boolean isOnSale;
    private BigDecimal averageRating;
    private int reviewCount;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Các đối tượng liên kết
    private Brand brand;
    private Category category;
    private List<ProductVariant> variants;
    private List<ProductImage> images;
    private List<HairCondition> hairConditions;
    private List<Promotion> promotions;

    // Transient fields for display
    private String categoryName;
    private String brandName;
    private String primaryImageUrl;
    private ProductVariant defaultVariant;
    private int remainingStock;
    private int soldQuantity;
    private int soldPercent;

    // Transient fields for promotion display
    private BigDecimal finalPrice;
    private Promotion activePromotion;

    // Constructors
    public Product() {
    }

    public Product(int productId, String productName, String productSlug, Integer brandId, Integer categoryId,
            String origin, String shortDescription, String fullDescription, int stockQuantity,
            boolean isFeatured, boolean isOnSale, BigDecimal averageRating, int reviewCount,
            Timestamp createdAt, Timestamp updatedAt) {
        this.productId = productId;
        this.productName = productName;
        this.productSlug = productSlug;
        this.brandId = brandId;
        this.categoryId = categoryId;
        this.origin = origin;
        this.shortDescription = shortDescription;
        this.fullDescription = fullDescription;
        this.stockQuantity = stockQuantity;
        this.isFeatured = isFeatured;
        this.isOnSale = isOnSale;
        this.averageRating = averageRating;
        this.reviewCount = reviewCount;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // Getters and Setters
    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getProductSlug() {
        return productSlug;
    }

    public void setProductSlug(String productSlug) {
        this.productSlug = productSlug;
    }

    public Integer getBrandId() {
        return brandId;
    }

    public void setBrandId(Integer brandId) {
        this.brandId = brandId;
    }

    public Integer getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(Integer categoryId) {
        this.categoryId = categoryId;
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

    public int getStockQuantity() {
        return stockQuantity;
    }

    public void setStockQuantity(int stockQuantity) {
        this.stockQuantity = stockQuantity;
    }

    public boolean isFeatured() {
        return isFeatured;
    }

    public void setFeatured(boolean featured) {
        isFeatured = featured;
    }

    public boolean isOnSale() {
        return isOnSale;
    }

    public void setOnSale(boolean onSale) {
        isOnSale = onSale;
    }

    public BigDecimal getAverageRating() {
        return averageRating;
    }

    public void setAverageRating(BigDecimal averageRating) {
        this.averageRating = averageRating;
    }

    public int getReviewCount() {
        return reviewCount;
    }

    public void setReviewCount(int reviewCount) {
        this.reviewCount = reviewCount;
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

    public Brand getBrand() {
        return brand;
    }

    public void setBrand(Brand brand) {
        this.brand = brand;
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

    public List<ProductVariant> getVariants() {
        return variants;
    }

    public void setVariants(List<ProductVariant> variants) {
        this.variants = variants;
    }

    public List<ProductImage> getImages() {
        return images;
    }

    public void setImages(List<ProductImage> images) {
        this.images = images;
    }

    public List<HairCondition> getHairConditions() {
        return hairConditions;
    }

    public void setHairConditions(List<HairCondition> hairConditions) {
        this.hairConditions = hairConditions;
    }

    public List<Promotion> getPromotions() {
        return promotions;
    }

    public void setPromotions(List<Promotion> promotions) {
        this.promotions = promotions;
    }

    // Transient field getters and setters
    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public String getBrandName() {
        return brandName;
    }

    public void setBrandName(String brandName) {
        this.brandName = brandName;
    }

    public String getPrimaryImageUrl() {
        return primaryImageUrl;
    }

    public void setPrimaryImageUrl(String primaryImageUrl) {
        this.primaryImageUrl = primaryImageUrl;
    }

    public int getRemainingStock() {
        return remainingStock;
    }

    public void setRemainingStock(int remainingStock) {
        this.remainingStock = remainingStock;
    }

    public int getSoldQuantity() {
        return soldQuantity;
    }

    public void setSoldQuantity(int soldQuantity) {
        this.soldQuantity = soldQuantity;
    }

    public int getSoldPercent() {
        return soldPercent;
    }

    public void setSoldPercent(int soldPercent) {
        this.soldPercent = soldPercent;
    }

    public BigDecimal getFinalPrice() {
        return finalPrice;
    }

    public void setFinalPrice(BigDecimal finalPrice) {
        this.finalPrice = finalPrice;
    }

    public Promotion getActivePromotion() {
        return activePromotion;
    }

    public void setActivePromotion(Promotion activePromotion) {
        this.activePromotion = activePromotion;
    }

    public void setDefaultVariant(ProductVariant defaultVariant) {
        this.defaultVariant = defaultVariant;
    }

    // Helper methods
    public ProductImage getPrimaryImage() {
        if (images != null) {
            for (ProductImage img : images) {
                if (img.isPrimary()) {
                    return img;
                }
            }
            if (!images.isEmpty()) {
                return images.get(0);
            }
        }
        return null;
    }

    public ProductVariant getDefaultVariant() {
        // Return cached default variant if set
        if (defaultVariant != null) {
            return defaultVariant;
        }
        // Otherwise find from variants list
        if (variants != null) {
            for (ProductVariant v : variants) {
                if (v.isDefault()) {
                    return v;
                }
            }
            if (!variants.isEmpty()) {
                return variants.get(0);
            }
        }
        return null;
    }

    @Override
    public String toString() {
        return "Product{" +
                "productId=" + productId +
                ", productName='" + productName + '\'' +
                ", productSlug='" + productSlug + '\'' +
                ", brandId=" + brandId +
                ", categoryId=" + categoryId +
                ", origin='" + origin + '\'' +
                ", isFeatured=" + isFeatured +
                ", isOnSale=" + isOnSale +
                ", averageRating=" + averageRating +
                ", reviewCount=" + reviewCount +
                '}';
    }
}

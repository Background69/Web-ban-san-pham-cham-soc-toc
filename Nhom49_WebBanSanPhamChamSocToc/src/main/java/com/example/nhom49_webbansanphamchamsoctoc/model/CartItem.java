package com.example.nhom49_webbansanphamchamsoctoc.model;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * Lớp CartItem.
 */
public class CartItem implements Serializable {

    private Product product;
    private ProductVariant variant;
    private int quantity;
    private String imageUrl;

    /**
     * Thực hiện cart item.
     */
    public CartItem() {
    }

    /**
     * Khởi tạo CartItem với product và variant.
     *
     * @param product  Sản phẩm.
     * @param variant  Bien the.
     * @param quantity So luong.
     */
    public CartItem(Product product, ProductVariant variant, int quantity) {
        this(product, variant, quantity, null);
    }

    /**
     * Khởi tạo CartItem đầy đủ thong tin.
     *
     * @param product  Sản phẩm.
     * @param variant  Bien the.
     * @param quantity So luong.
     * @param imageUrl Anh dai dien.
     */
    public CartItem(Product product, ProductVariant variant, int quantity, String imageUrl) {
        this.product = product;
        this.variant = variant;
        this.quantity = quantity;
        this.imageUrl = imageUrl;
    }

    /**
     * Lấy product name.
     *
     */
    public String getProductName() {
        return product != null ? product.getProductName() : null;
    }

    /**
     * Lấy slug sản phẩm từ product
     */
    public String getProductSlug() {
        return product != null ? product.getProductSlug() : null;
    }

    /**
     * Lấy tên variant từ variant
     */
    public String getVariantName() {
        return variant != null ? variant.getVariantName() : null;
    }

    /**
     * Lấy giá gốc từ variant
     */
    public BigDecimal getOriginalPrice() {
        return variant != null ? variant.getOriginalPrice() : BigDecimal.ZERO;
    }

    /**
     * Lấy giá sale từ variant
     */
    public BigDecimal getSalePrice() {
        return variant != null ? variant.getSalePrice() : null;
    }

    /**
     * Lấy số lượng tồn kho từ variant
     */
    public int getStockQuantity() {
        return variant != null ? variant.getStockQuantity() : 0;
    }

    /**
     * Tính giá đơn vị (ưu tiên giá sale nếu có)
     */
    public BigDecimal getUnitPrice() {
        if (variant == null) return BigDecimal.ZERO;
        return variant.getCurrentPrice();
    }

    /**
     * Tính tổng giá của item (unitPrice * quantity)
     */
    public BigDecimal getTotalPrice() {
        return getUnitPrice().multiply(BigDecimal.valueOf(quantity));
    }

    /**
     * Kiểm tra xem số lượng yêu cầu có vượt quá tồn kho không
     */
    public boolean isOverStock() {
        return quantity > getStockQuantity();
    }

    /**
     * Tăng số lượng
     */
    public void increaseQuantity(int amount) {
        if (amount > 0) {
            this.quantity += amount;
        }
    }

    /**
     * Giảm số lượng
     */
    public void decreaseQuantity(int amount) {
        if (amount > 0 && this.quantity > amount) {
            this.quantity -= amount;
        }
    }

    // Getters and Setters
    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public ProductVariant getVariant() {
        return variant;
    }

    public void setVariant(ProductVariant variant) {
        this.variant = variant;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getImageUrl() {
        if (imageUrl != null) {
            return imageUrl;
        }
        if (product != null) {
            return product.getPrimaryImageUrl();
        }
        return null;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    /**
     * Lấy variant id.
     */
    public int getVariantId() {
        return variant != null ? variant.getVariantId() : 0;
    }

    /**
     * Lấy product id.
     */
    public int getProductId() {
        return product != null ? product.getProductId() : 0;
    }

    
    @Override
    public String toString() {
        return "CartItem{" +
                "productId=" + getProductId() +
                ", variantId=" + getVariantId() +
                ", quantity=" + quantity +
                ", unitPrice=" + getUnitPrice() +
                ", totalPrice=" + getTotalPrice() +
                '}';
    }

    /**
     * So sanh doi tuong hiện tại với doi tuong khac.
     */
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        CartItem cartItem = (CartItem) o;
        return getVariantId() == cartItem.getVariantId();
    }

    /**
     * Tạo ma bam dai dien cho doi tuong.
     */
    @Override
    public int hashCode() {
        return Integer.hashCode(getVariantId());
    }
}

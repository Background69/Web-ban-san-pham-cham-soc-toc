package com.example.nhom49_webbansanphamchamsoctoc.model;

import java.io.Serializable;
import java.math.BigDecimal;

public class StockProduct implements Serializable {
    private int variantId;
    private String productName;
    private String variantName;
    private int stock;
    private BigDecimal price;

    public StockProduct() {
    }

    public StockProduct(int variantId, String productName, String variantName, int stock, BigDecimal price) {
        this.variantId = variantId;
        this.productName = productName;
        this.variantName = variantName;
        this.stock = stock;
        this.price = price;
    }

    public int getVariantId() {
        return variantId;
    }

    public void setVariantId(int variantId) {
        this.variantId = variantId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getVariantName() {
        return variantName;
    }

    public void setVariantName(String variantName) {
        this.variantName = variantName;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }
}

package com.example.nhom49_webbansanphamchamsoctoc.model;

import java.math.BigDecimal;

public class InventoryReceiptDetail {
    private int detailId;
    private int receiptId;
    private int productId;
    private String productName;
    private int quantity;
    private BigDecimal unitCost;

    public InventoryReceiptDetail() {
    }

    public InventoryReceiptDetail(int detailId, int receiptId, int productId, String productName, int quantity, BigDecimal unitCost) {
        this.detailId = detailId;
        this.receiptId = receiptId;
        this.productId = productId;
        this.productName = productName;
        this.quantity = quantity;
        this.unitCost = unitCost;
    }

    public int getDetailId() {
        return detailId;
    }

    public void setDetailId(int detailId) {
        this.detailId = detailId;
    }

    public int getReceiptId() {
        return receiptId;
    }

    public void setReceiptId(int receiptId) {
        this.receiptId = receiptId;
    }

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

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getUnitCost() {
        return unitCost;
    }

    public void setUnitCost(BigDecimal unitCost) {
        this.unitCost = unitCost;
    }
}

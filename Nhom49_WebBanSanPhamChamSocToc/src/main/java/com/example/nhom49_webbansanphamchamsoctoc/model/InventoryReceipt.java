package com.example.nhom49_webbansanphamchamsoctoc.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.List;

public class InventoryReceipt implements Serializable {
    private int receiptId;
    private int createdBy;
    private Timestamp receiptDate;
    private List<InventoryReceiptDetail> details;
    private BigDecimal totalAmount;
    private String note;

    public InventoryReceipt() {
    }

    public InventoryReceipt(int receiptId, int createdBy, Timestamp receiptDate, List<InventoryReceiptDetail> details, BigDecimal totalAmount, String note) {
        this.receiptId = receiptId;
        this.createdBy = createdBy;
        this.receiptDate = receiptDate;
        this.details = details;
        this.totalAmount = totalAmount;
        this.note = note;
    }

    public int getReceiptId() {
        return receiptId;
    }

    public void setReceiptId(int receiptId) {
        this.receiptId = receiptId;
    }

    public int getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }

    public Timestamp getReceiptDate() {
        return receiptDate;
    }

    public void setReceiptDate(Timestamp receiptDate) {
        this.receiptDate = receiptDate;
    }

    public List<InventoryReceiptDetail> getDetails() {
        return details;
    }

    public void setDetails(List<InventoryReceiptDetail> details) {
        this.details = details;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }
}

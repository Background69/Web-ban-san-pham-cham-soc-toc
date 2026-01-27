package com.example.nhom49_webbansanphamchamsoctoc.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Model PaymentTransaction - Bảng payment_transactions trong database
 * Quản lý các giao dịch thanh toán QR
 */
public class PaymentTransaction {
    private int transactionId;
    private String orderTempId;
    private int userId;
    private BigDecimal amount;
    private String paymentMethod; // BANK hoặc MOMO
    private String qrCodeUrl;
    private String bankAccount;
    private String bankName;
    private String accountHolder;
    private String transferContent;
    private String status; // PENDING, SUCCESS, EXPIRED
    private Timestamp createdAt;
    private Timestamp confirmedAt;
    private Timestamp expiresAt;

    // Constructors
    public PaymentTransaction() {
    }

    public PaymentTransaction(String orderTempId, int userId, BigDecimal amount, String paymentMethod) {
        this.orderTempId = orderTempId;
        this.userId = userId;
        this.amount = amount;
        this.paymentMethod = paymentMethod;
        this.status = "PENDING";
    }

    // Getters and Setters
    public int getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(int transactionId) {
        this.transactionId = transactionId;
    }

    public String getOrderTempId() {
        return orderTempId;
    }

    public void setOrderTempId(String orderTempId) {
        this.orderTempId = orderTempId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getQrCodeUrl() {
        return qrCodeUrl;
    }

    public void setQrCodeUrl(String qrCodeUrl) {
        this.qrCodeUrl = qrCodeUrl;
    }

    public String getBankAccount() {
        return bankAccount;
    }

    public void setBankAccount(String bankAccount) {
        this.bankAccount = bankAccount;
    }

    public String getBankName() {
        return bankName;
    }

    public void setBankName(String bankName) {
        this.bankName = bankName;
    }

    public String getAccountHolder() {
        return accountHolder;
    }

    public void setAccountHolder(String accountHolder) {
        this.accountHolder = accountHolder;
    }

    public String getTransferContent() {
        return transferContent;
    }

    public void setTransferContent(String transferContent) {
        this.transferContent = transferContent;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getConfirmedAt() {
        return confirmedAt;
    }

    public void setConfirmedAt(Timestamp confirmedAt) {
        this.confirmedAt = confirmedAt;
    }

    public Timestamp getExpiresAt() {
        return expiresAt;
    }

    public void setExpiresAt(Timestamp expiresAt) {
        this.expiresAt = expiresAt;
    }

    // Helper methods
    public boolean isPending() {
        return "PENDING".equals(status);
    }

    public boolean isSuccess() {
        return "SUCCESS".equals(status);
    }

    public boolean isExpired() {
        return "EXPIRED".equals(status);
    }

    public boolean isBankTransfer() {
        return "BANK".equals(paymentMethod) || "bank_transfer".equalsIgnoreCase(paymentMethod);
    }

    public boolean isMoMo() {
        return "MOMO".equals(paymentMethod) || "momo".equalsIgnoreCase(paymentMethod);
    }
}

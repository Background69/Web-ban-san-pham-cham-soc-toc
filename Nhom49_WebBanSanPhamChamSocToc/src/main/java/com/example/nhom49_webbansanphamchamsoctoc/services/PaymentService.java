package com.example.nhom49_webbansanphamchamsoctoc.services;

import com.example.nhom49_webbansanphamchamsoctoc.dao.PaymentTransactionDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.PaymentTransaction;

import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Timestamp;
import java.util.Random;

public class PaymentService {

    private PaymentTransactionDAO transactionDAO;

    // Hardcoded bank info for demo
    private static final String BANK_NAME = "Vietcombank (VCB)";
    private static final String BANK_ACCOUNT = "1234567890";
    private static final String ACCOUNT_HOLDER = "CONG TY TNHH HAIRGLOW";
    private static final String MOMO_PHONE = "0912345678";
    private static final String MOMO_NAME = "HAIRGLOW STORE";

    // QR API
    private static final String QR_API_URL = "https://api.qrserver.com/v1/create-qr-code/?size=300x300&data=";

    // Expiration time (15 minutes)
    private static final long EXPIRATION_MS = 15 * 60 * 1000;

    // Auto success time for mock (10 seconds)
    public static final long AUTO_SUCCESS_MS = 10 * 1000;

    public PaymentService() {
        this.transactionDAO = new PaymentTransactionDAO();
    }

    /**
     * Tạo orderTempId unique
     */
    public String generateOrderTempId() {
        long timestamp = System.currentTimeMillis();
        int random = new Random().nextInt(9000) + 1000;
        return "ORD" + timestamp + random;
    }

    /**
     * Tạo transaction mới cho thanh toán QR
     */
    public PaymentTransaction createTransaction(int userId, BigDecimal amount, String paymentMethod) {
        PaymentTransaction t = new PaymentTransaction();
        t.setOrderTempId(generateOrderTempId());
        t.setUserId(userId);
        t.setAmount(amount);
        t.setPaymentMethod(paymentMethod.toUpperCase());
        t.setStatus("PENDING");

        // Set bank/momo info
        if ("BANK".equalsIgnoreCase(paymentMethod) || "bank_transfer".equalsIgnoreCase(paymentMethod)) {
            t.setPaymentMethod("BANK");
            t.setBankAccount(BANK_ACCOUNT);
            t.setBankName(BANK_NAME);
            t.setAccountHolder(ACCOUNT_HOLDER);
        } else if ("MOMO".equalsIgnoreCase(paymentMethod)) {
            t.setPaymentMethod("MOMO");
            t.setBankAccount(MOMO_PHONE);
            t.setBankName("MoMo");
            t.setAccountHolder(MOMO_NAME);
        }

        // Transfer content = orderTempId
        t.setTransferContent(t.getOrderTempId());

        // Generate QR URL
        t.setQrCodeUrl(generateQRUrl(t));

        // Set expiration time
        t.setExpiresAt(new Timestamp(System.currentTimeMillis() + EXPIRATION_MS));

        return transactionDAO.create(t);
    }

    /**
     * Generate QR code URL
     */
    private String generateQRUrl(PaymentTransaction t) {
        String content;
        if ("BANK".equals(t.getPaymentMethod())) {
            content = String.format("Ngan hang: %s | STK: %s | So tien: %s | Noi dung: %s",
                    t.getBankName(), t.getBankAccount(),
                    t.getAmount().toBigInteger().toString(), t.getTransferContent());
        } else {
            content = String.format("MoMo: %s | Ten: %s | So tien: %s | Noi dung: %s",
                    t.getBankAccount(), t.getAccountHolder(),
                    t.getAmount().toBigInteger().toString(), t.getTransferContent());
        }

        try {
            return QR_API_URL + URLEncoder.encode(content, StandardCharsets.UTF_8);
        } catch (Exception e) {
            return QR_API_URL + content.replace(" ", "%20");
        }
    }

    /**
     * Lấy transaction theo orderTempId
     */
    public PaymentTransaction getTransaction(String orderTempId) {
        return transactionDAO.findByOrderTempId(orderTempId);
    }

    /**
     * Kiểm tra status và auto-success nếu đủ thời gian (mock)
     */
    public PaymentTransaction checkStatus(String orderTempId, boolean autoSuccess) {
        PaymentTransaction t = transactionDAO.findByOrderTempId(orderTempId);
        if (t == null) return null;

        // Check expired first
        if (t.isPending() && t.getExpiresAt() != null &&
            System.currentTimeMillis() > t.getExpiresAt().getTime()) {
            transactionDAO.updateStatus(orderTempId, "EXPIRED");
            t.setStatus("EXPIRED");
            return t;
        }

        // Auto success after 10 seconds (mock for demo)
        if (autoSuccess && t.isPending() && t.getCreatedAt() != null) {
            long elapsed = System.currentTimeMillis() - t.getCreatedAt().getTime();
            if (elapsed >= AUTO_SUCCESS_MS) {
                transactionDAO.updateStatus(orderTempId, "SUCCESS");
                t.setStatus("SUCCESS");
                t.setConfirmedAt(new Timestamp(System.currentTimeMillis()));
            }
        }

        return t;
    }

    /**
     * User manual confirm payment
     */
    public boolean confirmPayment(String orderTempId) {
        PaymentTransaction t = transactionDAO.findByOrderTempId(orderTempId);
        if (t == null || !t.isPending()) return false;
        return transactionDAO.updateStatus(orderTempId, "SUCCESS");
    }

    /**
     * Hủy transaction
     */
    public boolean cancelTransaction(String orderTempId) {
        return transactionDAO.delete(orderTempId);
    }

    /**
     * Kiểm tra transaction có thể complete order không
     */
    public boolean canCompleteOrder(String orderTempId) {
        PaymentTransaction t = transactionDAO.findByOrderTempId(orderTempId);
        return t != null && t.isSuccess();
    }
}

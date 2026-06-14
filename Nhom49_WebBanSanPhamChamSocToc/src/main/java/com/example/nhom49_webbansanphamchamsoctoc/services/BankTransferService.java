package com.example.nhom49_webbansanphamchamsoctoc.services;

import com.example.nhom49_webbansanphamchamsoctoc.dao.OrderDAO;
import com.example.nhom49_webbansanphamchamsoctoc.dao.OrderStatusHistoryDAO;
import com.example.nhom49_webbansanphamchamsoctoc.dao.PaymentTransactionDAO;
import com.example.nhom49_webbansanphamchamsoctoc.database.DBProperties;
import com.example.nhom49_webbansanphamchamsoctoc.model.Order;
import com.example.nhom49_webbansanphamchamsoctoc.model.OrderStatusHistory;
import com.example.nhom49_webbansanphamchamsoctoc.model.PaymentTransaction;

import java.sql.Timestamp;
import java.time.Instant;
import java.time.temporal.ChronoUnit;

public class BankTransferService {
    private static final int QR_CODE_URL_COLUMN_LIMIT = 1000;

    private final PaymentTransactionDAO paymentTransactionDAO;
    private final OrderDAO orderDAO;
    private final OrderStatusHistoryDAO orderStatusHistoryDAO;
    private final OrderService orderService;
    private final DBProperties dbProperties;
    private final VietQRService vietQRService;
    private String lastError;

    public BankTransferService() {
        this.paymentTransactionDAO = new PaymentTransactionDAO();
        this.orderDAO = new OrderDAO();
        this.orderStatusHistoryDAO = new OrderStatusHistoryDAO();
        this.orderService = new OrderService();
        this.dbProperties = new DBProperties();
        this.vietQRService = new VietQRService();
    }

    public String getLastError() {
        return lastError;
    }

    public PaymentTransaction createTransactionForOrder(Order order, int userId) {
        lastError = null;

        if (order == null || order.getOrderId() <= 0) {
            lastError = "Không tìm thấy đơn hàng để tạo giao dịch chuyển khoản";
            return null;
        }

        if (order.getTotalAmount() == null || order.getTotalAmount().signum() <= 0) {
            lastError = "Số tiền đơn hàng không hợp lệ";
            return null;
        }

        PaymentTransaction existing = paymentTransactionDAO.findLatestByOrderId(order.getOrderId());
        if (existing != null &&
                ("PENDING".equalsIgnoreCase(existing.getStatus())
                        || "SUCCESS".equalsIgnoreCase(existing.getStatus()))) {
            ensureQrForTransaction(existing);
            return existing;
        }

        PaymentTransaction transaction = new PaymentTransaction();
        transaction.setOrderTempId(buildOrderTempId(order.getOrderCode()));
        transaction.setOrderId(order.getOrderId());
        transaction.setUserId(userId);
        transaction.setAmount(order.getTotalAmount());
        transaction.setPaymentMethod("BANK");
        transaction.setQrCodeUrl(null);
        transaction.setBankAccount(dbProperties.getBankTransferAccountNo());
        transaction.setBankName(dbProperties.getBankTransferBankName());
        transaction.setAccountHolder(dbProperties.getBankTransferAccountName());
        transaction.setTransferContent(buildTransferContent(order));
        transaction.setStatus("PENDING");
        transaction.setExpiresAt(buildExpiresAt());

        int transactionId = paymentTransactionDAO.insert(transaction);
        if (transactionId <= 0) {
            lastError = "Không thể tạo giao dịch thanh toán";
            return null;
        }

        transaction.setTransactionId(transactionId);
        ensureQrForTransaction(transaction);
        return transaction;
    }

    public boolean ensureQrForTransaction(PaymentTransaction transaction) {
        if (transaction == null) {
            lastError = "Giao dịch không hợp lệ";
            return false;
        }

        if (!"PENDING".equalsIgnoreCase(transaction.getStatus())) {
            return true;
        }

        if (!isBlank(transaction.getQrCodeUrl())) {
            return true;
        }

        VietQRService.QrGenerationResult qrResult =
                vietQRService.generateQr(transaction.getAmount(), transaction.getTransferContent());

        if (!qrResult.isSuccess()) {
            lastError = vietQRService.getLastError();
            return false;
        }

        String qrCodeUrl = selectPersistableQrCode(qrResult);
        if (isBlank(qrCodeUrl)) {
            lastError = "Mã QR VietQR vượt quá giới hạn lưu trữ hiện tại. Vui lòng chuyển khoản thủ công theo thông tin hiển thị.";
            return false;
        }

        transaction.setQrCodeUrl(qrCodeUrl);
        boolean updated;
        try {
            updated = paymentTransactionDAO.update(transaction);
        } catch (RuntimeException e) {
            transaction.setQrCodeUrl(null);
            lastError = "Không thể lưu mã QR vào giao dịch: " + e.getMessage();
            return false;
        }

        if (!updated) {
            lastError = "Không thể cập nhật mã QR vào giao dịch";
            return false;
        }

        return true;
    }

    private String selectPersistableQrCode(VietQRService.QrGenerationResult qrResult) {
        if (qrResult == null) {
            return null;
        }

        String qrDataUrl = qrResult.getQrDataUrl();
        if (fitsQrColumn(qrDataUrl)) {
            return qrDataUrl;
        }

        String qrCode = qrResult.getQrCode();
        if (fitsQrColumn(qrCode)) {
            return qrCode;
        }

        return null;
    }

    private boolean fitsQrColumn(String value) {
        return !isBlank(value) && value.length() <= QR_CODE_URL_COLUMN_LIMIT;
    }

    public PaymentTransaction getTransactionForUser(int transactionId, int userId) {
        PaymentTransaction transaction = paymentTransactionDAO.findByIdAndUserId(transactionId, userId);
        if (transaction != null) {
            refreshTransactionStatus(transaction);
        }
        return transaction;
    }

    public PaymentTransaction getLatestTransactionByOrder(int orderId) {
        PaymentTransaction transaction = paymentTransactionDAO.findLatestByOrderId(orderId);
        if (transaction != null) {
            refreshTransactionStatus(transaction);
        }
        return transaction;
    }

    public boolean hasSuccessfulPayment(int orderId) {
        return paymentTransactionDAO.existsByOrderIdAndStatus(orderId, "SUCCESS");
    }

    public boolean expirePendingByOrderId(int orderId) {
        if (orderId <= 0) {
            return false;
        }
        return paymentTransactionDAO.markExpiredByOrderId(orderId);
    }

    public boolean mockConfirmByUser(int transactionId, int userId) {
        lastError = null;

        PaymentTransaction transaction = paymentTransactionDAO.findByIdAndUserId(transactionId, userId);
        if (transaction == null) {
            lastError = "Không tìm thấy giao dịch thanh toán";
            return false;
        }

        return confirmPendingTransaction(transaction, "Khách hàng xác nhận đã chuyển khoản (demo)");
    }

    public boolean confirmByAdmin(int transactionId) {
        lastError = null;

        PaymentTransaction transaction = paymentTransactionDAO.findById(transactionId);
        if (transaction == null) {
            lastError = "Không tìm thấy giao dịch thanh toán";
            return false;
        }

        return confirmPendingTransaction(transaction, "Admin xác nhận đã nhận tiền chuyển khoản");
    }

    private boolean confirmPendingTransaction(PaymentTransaction transaction, String historyNote) {
        refreshTransactionStatus(transaction);

        if ("SUCCESS".equalsIgnoreCase(transaction.getStatus())) {
            return true;
        }

        if (!"PENDING".equalsIgnoreCase(transaction.getStatus())) {
            lastError = "Giao dịch không ở trạng thái chờ xác nhận";
            return false;
        }

        if (isExpired(transaction)) {
            markExpired(transaction, "Giao dịch chuyển khoản hết hạn");
            lastError = "Giao dịch đã hết hạn";
            return false;
        }

        transaction.setStatus("SUCCESS");
        transaction.setConfirmedAt(Timestamp.from(Instant.now()));
        if (!paymentTransactionDAO.update(transaction)) {
            lastError = "Không thể cập nhật trạng thái giao dịch";
            return false;
        }

        updateOrderAfterSuccessfulPayment(transaction.getOrderId(), historyNote);
        return true;
    }

    private void refreshTransactionStatus(PaymentTransaction transaction) {
        if (transaction == null || !"PENDING".equalsIgnoreCase(transaction.getStatus())) {
            return;
        }

        if (isExpired(transaction)) {
            markExpired(transaction, "Giao dịch chuyển khoản hết hạn");
            transaction.setStatus("EXPIRED");
        }
    }

    private void markExpired(PaymentTransaction transaction, String reason) {
        transaction.setStatus("EXPIRED");
        transaction.setConfirmedAt(null);
        if (paymentTransactionDAO.update(transaction)) {
            cancelOrderWhenPaymentExpired(transaction.getOrderId());
        }
    }

    private void cancelOrderWhenPaymentExpired(Integer orderId) {
        if (orderId == null) {
            return;
        }

        Order order = orderDAO.findById(orderId);
        if (order == null ||
                (!"pending".equalsIgnoreCase(order.getOrderStatus())
                 && !"pending_payment".equalsIgnoreCase(order.getOrderStatus()))) {
            return;
        }

        orderService.cancelOrder(orderId);
    }

    private void updateOrderAfterSuccessfulPayment(Integer orderId, String note) {
        if (orderId == null) {
            return;
        }

        Order order = orderDAO.findById(orderId);
        if (order == null ||
                (!"pending".equalsIgnoreCase(order.getOrderStatus())
                 && !"pending_payment".equalsIgnoreCase(order.getOrderStatus()))) {
            return;
        }

        if (orderDAO.updateStatus(orderId, "confirmed")) {
            OrderStatusHistory history = new OrderStatusHistory();
            history.setOrderId(orderId);
            history.setStatus("confirmed");
            history.setNote(note);
            orderStatusHistoryDAO.insert(history);
        }
    }

    private Timestamp buildExpiresAt() {
        int expireMinutes = dbProperties.getBankTransferExpireMinutes();
        if (expireMinutes <= 0) {
            expireMinutes = 30;
        }
        return Timestamp.from(Instant.now().plus(expireMinutes, ChronoUnit.MINUTES));
    }

    private String buildOrderTempId(String orderCode) {
        String code = isBlank(orderCode) ? "ORDER" : orderCode.replaceAll("[^A-Za-z0-9]", "").toUpperCase();
        if (code.isBlank()) {
            code = "ORDER";
        }
        return "TMP-" + code + "-" + System.currentTimeMillis();
    }

    private String buildTransferContent(Order order) {
        String orderCode = order != null ? order.getOrderCode() : "";
        String code = isBlank(orderCode) ? String.valueOf(System.currentTimeMillis())
                : orderCode.replaceAll("[^A-Za-z0-9]", "").toUpperCase();
        if (code.isBlank()) {
            code = String.valueOf(System.currentTimeMillis());
        }

        String transferContent = "TT DH " + code;
        if (transferContent.length() > 25) {
            transferContent = transferContent.substring(0, 25);
        }
        return transferContent;
    }

    private boolean isExpired(PaymentTransaction transaction) {
        return transaction.getExpiresAt() != null && transaction.getExpiresAt().before(Timestamp.from(Instant.now()));
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}

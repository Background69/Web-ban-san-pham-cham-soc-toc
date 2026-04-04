package com.example.nhom49_webbansanphamchamsoctoc.dao;

import com.example.nhom49_webbansanphamchamsoctoc.database.JDBIConnector;
import com.example.nhom49_webbansanphamchamsoctoc.model.PaymentTransaction;
import org.jdbi.v3.core.Jdbi;

import java.util.List;

public class PaymentTransactionDAO implements IDAO<PaymentTransaction> {
    private final Jdbi jdbi;

    public PaymentTransactionDAO() {
        this.jdbi = JDBIConnector.getInstance();
    }

    @Override
    public PaymentTransaction findById(int id) {
        String sql = "SELECT * FROM payment_transactions WHERE transaction_id = :id";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("id", id)
                .map((rs, ctx) -> mapPaymentTransaction(rs))
                .findFirst()
                .orElse(null));
    }

    @Override
    public List<PaymentTransaction> findAll() {
        String sql = "SELECT * FROM payment_transactions ORDER BY created_at DESC";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .map((rs, ctx) -> mapPaymentTransaction(rs))
                .list());
    }

    @Override
    public int insert(PaymentTransaction entity) {
        String sql = "INSERT INTO payment_transactions (order_temp_id, order_id, user_id, amount, payment_method, qr_code_url, bank_account, bank_name, account_holder, transfer_content, status, expires_at) " +
                "VALUES (:orderTempId, :orderId, :userId, :amount, :paymentMethod, :qrCodeUrl, :bankAccount, :bankName, :accountHolder, :transferContent, :status, :expiresAt)";
        return jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("orderTempId", entity.getOrderTempId())
                .bind("orderId", entity.getOrderId())
                .bind("userId", entity.getUserId())
                .bind("amount", entity.getAmount())
                .bind("paymentMethod", entity.getPaymentMethod())
                .bind("qrCodeUrl", entity.getQrCodeUrl())
                .bind("bankAccount", entity.getBankAccount())
                .bind("bankName", entity.getBankName())
                .bind("accountHolder", entity.getAccountHolder())
                .bind("transferContent", entity.getTransferContent())
                .bind("status", entity.getStatus())
                .bind("expiresAt", entity.getExpiresAt())
                .executeAndReturnGeneratedKeys("transaction_id")
                .mapTo(Integer.class)
                .findFirst()
                .orElse(-1));
    }

    @Override
    public boolean update(PaymentTransaction entity) {
        String sql = "UPDATE payment_transactions SET order_temp_id = :orderTempId, order_id = :orderId, user_id = :userId, amount = :amount, payment_method = :paymentMethod, qr_code_url = :qrCodeUrl, bank_account = :bankAccount, bank_name = :bankName, account_holder = :accountHolder, transfer_content = :transferContent, status = :status, confirmed_at = :confirmedAt, expires_at = :expiresAt WHERE transaction_id = :transactionId";
        return jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("orderTempId", entity.getOrderTempId())
                .bind("orderId", entity.getOrderId())
                .bind("userId", entity.getUserId())
                .bind("amount", entity.getAmount())
                .bind("paymentMethod", entity.getPaymentMethod())
                .bind("qrCodeUrl", entity.getQrCodeUrl())
                .bind("bankAccount", entity.getBankAccount())
                .bind("bankName", entity.getBankName())
                .bind("accountHolder", entity.getAccountHolder())
                .bind("transferContent", entity.getTransferContent())
                .bind("status", entity.getStatus())
                .bind("confirmedAt", entity.getConfirmedAt())
                .bind("expiresAt", entity.getExpiresAt())
                .bind("transactionId", entity.getTransactionId())
                .execute() > 0);
    }

    @Override
    public boolean delete(int id) {
        String sql = "DELETE FROM payment_transactions WHERE transaction_id = :id";
        return jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("id", id)
                .execute() > 0);
    }

    public PaymentTransaction findByIdAndUserId(int transactionId, int userId) {
        String sql = "SELECT * FROM payment_transactions WHERE transaction_id = :transactionId AND user_id = :userId";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("transactionId", transactionId)
                .bind("userId", userId)
                .map((rs, ctx) -> mapPaymentTransaction(rs))
                .findFirst()
                .orElse(null));
    }

    public PaymentTransaction findLatestByOrderId(int orderId) {
        String sql = "SELECT * FROM payment_transactions WHERE order_id = :orderId ORDER BY created_at DESC LIMIT 1";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("orderId", orderId)
                .map((rs, ctx) -> mapPaymentTransaction(rs))
                .findFirst()
                .orElse(null));
    }

    public boolean existsByOrderIdAndStatus(int orderId, String status) {
        String sql = "SELECT COUNT(*) FROM payment_transactions WHERE order_id = :orderId AND status = :status";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("orderId", orderId)
                .bind("status", status)
                .mapTo(Integer.class)
                .findFirst()
                .orElse(0) > 0);
    }

    public boolean markExpiredByOrderId(int orderId) {
        String sql = "UPDATE payment_transactions " +
                "SET status = 'EXPIRED', confirmed_at = NULL " +
                "WHERE order_id = :orderId AND status = 'PENDING'";
        return jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("orderId", orderId)
                .execute() > 0);
    }

    private PaymentTransaction mapPaymentTransaction(java.sql.ResultSet rs) throws java.sql.SQLException {
        PaymentTransaction tx = new PaymentTransaction();
        tx.setTransactionId(rs.getInt("transaction_id"));
        tx.setOrderTempId(rs.getString("order_temp_id"));
        tx.setOrderId(rs.getObject("order_id") != null ? rs.getInt("order_id") : null);
        tx.setUserId(rs.getInt("user_id"));
        tx.setAmount(rs.getBigDecimal("amount"));
        tx.setPaymentMethod(rs.getString("payment_method"));
        tx.setQrCodeUrl(rs.getString("qr_code_url"));
        tx.setBankAccount(rs.getString("bank_account"));
        tx.setBankName(rs.getString("bank_name"));
        tx.setAccountHolder(rs.getString("account_holder"));
        tx.setTransferContent(rs.getString("transfer_content"));
        tx.setStatus(rs.getString("status"));
        tx.setCreatedAt(rs.getTimestamp("created_at"));
        tx.setConfirmedAt(rs.getTimestamp("confirmed_at"));
        tx.setExpiresAt(rs.getTimestamp("expires_at"));
        return tx;
    }
}

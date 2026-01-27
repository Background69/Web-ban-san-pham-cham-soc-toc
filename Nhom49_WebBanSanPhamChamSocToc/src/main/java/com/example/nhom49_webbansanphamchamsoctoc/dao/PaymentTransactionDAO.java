package com.example.nhom49_webbansanphamchamsoctoc.dao;

import com.example.nhom49_webbansanphamchamsoctoc.database.JDBIConnector;
import com.example.nhom49_webbansanphamchamsoctoc.model.PaymentTransaction;
import org.jdbi.v3.core.Jdbi;

import java.sql.Timestamp;

public class PaymentTransactionDAO {

    private final Jdbi jdbi;

    public PaymentTransactionDAO() {
        this.jdbi = JDBIConnector.getInstance();
    }

    public PaymentTransaction create(PaymentTransaction t) {
        String sql = "INSERT INTO payment_transactions (order_temp_id, user_id, amount, payment_method, qr_code_url, bank_account, bank_name, account_holder, transfer_content, status, expires_at) VALUES (:orderTempId, :userId, :amount, :paymentMethod, :qrCodeUrl, :bankAccount, :bankName, :accountHolder, :transferContent, :status, :expiresAt)";

        return jdbi.withHandle(handle -> {
            int generatedId = handle.createUpdate(sql)
                    .bind("orderTempId", t.getOrderTempId())
                    .bind("userId", t.getUserId())
                    .bind("amount", t.getAmount())
                    .bind("paymentMethod", t.getPaymentMethod())
                    .bind("qrCodeUrl", t.getQrCodeUrl())
                    .bind("bankAccount", t.getBankAccount())
                    .bind("bankName", t.getBankName())
                    .bind("accountHolder", t.getAccountHolder())
                    .bind("transferContent", t.getTransferContent())
                    .bind("status", t.getStatus())
                    .bind("expiresAt", t.getExpiresAt())
                    .executeAndReturnGeneratedKeys("transaction_id")
                    .mapTo(Integer.class)
                    .findFirst()
                    .orElse(-1);

            if (generatedId > 0) {
                t.setTransactionId(generatedId);
                return t;
            }
            return null;
        });
    }

    public PaymentTransaction findByOrderTempId(String orderTempId) {
        String sql = "SELECT * FROM payment_transactions WHERE order_temp_id = :orderTempId";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("orderTempId", orderTempId)
                        .map((rs, ctx) -> {
                            PaymentTransaction t = new PaymentTransaction();
                            t.setTransactionId(rs.getInt("transaction_id"));
                            t.setOrderTempId(rs.getString("order_temp_id"));
                            t.setUserId(rs.getInt("user_id"));
                            t.setAmount(rs.getBigDecimal("amount"));
                            t.setPaymentMethod(rs.getString("payment_method"));
                            t.setQrCodeUrl(rs.getString("qr_code_url"));
                            t.setBankAccount(rs.getString("bank_account"));
                            t.setBankName(rs.getString("bank_name"));
                            t.setAccountHolder(rs.getString("account_holder"));
                            t.setTransferContent(rs.getString("transfer_content"));
                            t.setStatus(rs.getString("status"));
                            t.setCreatedAt(rs.getTimestamp("created_at"));
                            t.setConfirmedAt(rs.getTimestamp("confirmed_at"));
                            t.setExpiresAt(rs.getTimestamp("expires_at"));
                            return t;
                        })
                        .findFirst()
                        .orElse(null)
        );
    }

    public boolean updateStatus(String orderTempId, String status) {
        String sql = "UPDATE payment_transactions SET status = :status, confirmed_at = :confirmedAt WHERE order_temp_id = :orderTempId";
        return jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("status", status)
                        .bind("confirmedAt", "SUCCESS".equals(status) ? new Timestamp(System.currentTimeMillis()) : null)
                        .bind("orderTempId", orderTempId)
                        .execute() > 0
        );
    }

    public boolean checkAndUpdateExpired(String orderTempId) {
        String sql = "UPDATE payment_transactions SET status = 'EXPIRED' WHERE order_temp_id = :orderTempId AND status = 'PENDING' AND expires_at < NOW()";
        return jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("orderTempId", orderTempId)
                        .execute() > 0
        );
    }

    public boolean delete(String orderTempId) {
        String sql = "DELETE FROM payment_transactions WHERE order_temp_id = :orderTempId";
        return jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("orderTempId", orderTempId)
                        .execute() > 0
        );
    }
}

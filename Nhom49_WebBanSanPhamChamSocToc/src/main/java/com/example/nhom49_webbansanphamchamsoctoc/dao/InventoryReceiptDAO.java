package com.example.nhom49_webbansanphamchamsoctoc.dao;

import com.example.nhom49_webbansanphamchamsoctoc.database.JDBIConnector;
import com.example.nhom49_webbansanphamchamsoctoc.model.InventoryReceipt;
import com.example.nhom49_webbansanphamchamsoctoc.model.InventoryReceiptDetail;
import org.jdbi.v3.core.Jdbi;

import java.math.BigDecimal;
import java.util.List;

public class InventoryReceiptDAO {
    private final Jdbi jdbi;

    public InventoryReceiptDAO() {
        this.jdbi = JDBIConnector.getInstance();
    }


    public int createReceipt(int adminId, BigDecimal totalAmount, String note) {

        return jdbi.withHandle(handle ->
                handle.createUpdate("""
                                INSERT INTO inventory_receipts
                                (created_by, total_amount, note)
                                VALUES (:createdBy, :totalAmount, :note)
                                """)
                        .bind("createdBy", adminId)
                        .bind("totalAmount", totalAmount)
                        .bind("note", note)
                        .executeAndReturnGeneratedKeys("receipt_id")
                        .mapTo(Integer.class)
                        .one()
        );
    }


    public List<InventoryReceipt> findAll() {
        return jdbi.withHandle(handle ->
                handle.createQuery("""
                    SELECT *
                    FROM inventory_receipts
                    ORDER BY receipt_date DESC
                    """)
                        .mapToBean(InventoryReceipt.class)
                        .list()
        );
    }


}

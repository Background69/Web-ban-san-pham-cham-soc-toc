package com.example.nhom49_webbansanphamchamsoctoc.services;

import com.example.nhom49_webbansanphamchamsoctoc.database.JDBIConnector;
import com.example.nhom49_webbansanphamchamsoctoc.model.InventoryReceiptDetail;
import org.jdbi.v3.core.Jdbi;

import java.math.BigDecimal;
import java.util.List;

public class InventoryReceiptDetailDAO {
    private final Jdbi jdbi;

    public InventoryReceiptDetailDAO() {
        this.jdbi = JDBIConnector.getInstance();
    }

    public boolean addDetail(int receiptId,
                             int productId,
                             int quantity,
                             BigDecimal unitCost) {

        int rows = jdbi.withHandle(handle ->
                handle.createUpdate("""
                                INSERT INTO inventory_receipt_details
                                (receipt_id, variant_id, quantity, unit_cost)
                                VALUES (:receiptId, :productId, :quantity, :unitCost)
                                """)
                        .bind("receiptId", receiptId)
                        .bind("productId", productId)
                        .bind("quantity", quantity)
                        .bind("unitCost", unitCost)
                        .execute()
        );

        return rows > 0;
    }

    public List<InventoryReceiptDetail> getDetailsByReceiptId(int receiptId) {

        String sql = """
        SELECT d.*, v.variant_name
        FROM inventory_receipt_details d
        JOIN product_variants v ON d.variant_id = v.variant_id
        WHERE d.receipt_id = :id
    """;

        return jdbi.withHandle(h ->
                h.createQuery(sql)
                        .bind("id", receiptId)
                        .map((rs, ctx) -> {
                            InventoryReceiptDetail d = new InventoryReceiptDetail();
                            d.setDetailId(rs.getInt("detail_id"));
                            d.setReceiptId(rs.getInt("receipt_id"));
                            d.setProductId(rs.getInt("variant_id"));
                            d.setQuantity(rs.getInt("quantity"));
                            d.setUnitCost(rs.getBigDecimal("unit_cost"));
                            return d;
                        })
                        .list()
        );
    }
}

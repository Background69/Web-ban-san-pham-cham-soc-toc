package com.example.nhom49_webbansanphamchamsoctoc.services;

import com.example.nhom49_webbansanphamchamsoctoc.dao.InventoryReceiptDAO;
import com.example.nhom49_webbansanphamchamsoctoc.dao.ProductVariantDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.ImportItem;
import com.example.nhom49_webbansanphamchamsoctoc.model.InventoryReceipt;
import com.example.nhom49_webbansanphamchamsoctoc.model.InventoryReceiptDetail;
import com.example.nhom49_webbansanphamchamsoctoc.model.ProductVariant;

import java.math.BigDecimal;
import java.util.List;

public class InventoryService {

    private final InventoryReceiptDAO inventoryReceiptDAO;
    private final InventoryReceiptDetailDAO inventoryReceiptDetailDAO;
    private final ProductVariantDAO productVariantDAO;

    public InventoryService(
            InventoryReceiptDAO inventoryReceiptDAO,
            InventoryReceiptDetailDAO inventoryReceiptDetailDAO,
            ProductVariantDAO productVariantDAO
    ) {
        this.inventoryReceiptDAO = inventoryReceiptDAO;
        this.inventoryReceiptDetailDAO = inventoryReceiptDetailDAO;
        this.productVariantDAO = productVariantDAO;
    }

    public boolean importStock(int adminId, List<ImportItem> items, String note) {

        try {
            if (items == null || items.isEmpty()) return false;

            BigDecimal total = BigDecimal.ZERO;

            // calc total
            for (ImportItem item : items) {

                ProductVariant variant = productVariantDAO.findById(item.getVariantId());
                if (variant == null) continue;

                BigDecimal price = variant.getCurrentPrice();

                total = total.add(price.multiply(BigDecimal.valueOf(item.getQuantity())));
            }

            // create receipt
            int receiptId = inventoryReceiptDAO.createReceipt(adminId, total, note);
            if (receiptId <= 0) return false;

            // details + increase stock
            for (ImportItem item : items) {

                ProductVariant variant = productVariantDAO.findById(item.getVariantId());
                if (variant == null) continue;

                BigDecimal price = variant.getCurrentPrice();

                inventoryReceiptDetailDAO.addDetail(
                        receiptId,
                        item.getVariantId(),
                        item.getQuantity(),
                        price
                );

                productVariantDAO.incrementStock(
                        item.getVariantId(),
                        item.getQuantity()
                );
            }

            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<ProductVariant> getAllVariants() {
        return productVariantDAO.findAll();
    }

    public List<InventoryReceipt> getAllReceipts() {
        return inventoryReceiptDAO.findAll();
    }

    public BigDecimal getVariantPrice(int variantId) {
        ProductVariant v = productVariantDAO.findById(variantId);
        return v != null ? v.getCurrentPrice() : BigDecimal.ZERO;
    }

    public List<InventoryReceiptDetail> getDetailsByReceiptId(int receiptId){
        return inventoryReceiptDetailDAO.getDetailsByReceiptId(receiptId);
    }
}

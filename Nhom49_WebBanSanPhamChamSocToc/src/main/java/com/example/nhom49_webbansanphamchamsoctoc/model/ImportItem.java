package com.example.nhom49_webbansanphamchamsoctoc.model;

import java.io.Serializable;

public class ImportItem implements Serializable {
    private int variantId;
    private int quantity;

    public ImportItem() {
    }

    public ImportItem(int variantId, int quantity) {
        this.variantId = variantId;
        this.quantity = quantity;
    }

    public int getVariantId() {
        return variantId;
    }

    public void setVariantId(int variantId) {
        this.variantId = variantId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

}

package com.example.nhom49_webbansanphamchamsoctoc.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

/**
 * Lớp Cart.
 */
public class Cart implements Serializable {

    private Map<String, CartItem> data;

    public Cart() {
        this.data = new HashMap<>();
    }

    /**
     * Them item.
     */
    public void addItem(CartItem item) {
        if (item == null) return;
        String key = String.valueOf(item.getVariantId());
        if (data.containsKey(key)) {
            CartItem existingItem = data.get(key);
            existingItem.increaseQuantity(item.getQuantity());
        } else {
            data.put(key, item);
        }
    }

    /**
     * Cập nhật quantity.
     */
    public void updateQuantity(int variantId, int quantity) {
        String key = String.valueOf(variantId);
        if (quantity <= 0) {
            data.remove(key);
        } else if (data.containsKey(key)) {
            data.get(key).setQuantity(quantity);
        }
    }

    /**
     * Xóa item.
     */
    public CartItem removeItem(int variantId) {
        return data.remove(String.valueOf(variantId));
    }

    /**
     * Kiểm tra co item hay không.
     */
    public boolean containsItem(int variantId) {
        return data.containsKey(String.valueOf(variantId));
    }

    /**
     * Lấy subtotal.
     */
    public BigDecimal getSubtotal() {
        return data.values().stream()
                .map(CartItem::getTotalPrice)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    /**
     * Lấy items.
     */
    public Collection<CartItem> getItems() {
        return data.values();
    }

    /**
     * Lấy so dong sản phẩm trỗng gio.
     */
    public int getItemCount() {
        return data.size();
    }

    /**
     * Lấy tong số lượng sản phẩm.
     */
    public int getTotalQuantity() {
        return data.values().stream()
                .mapToInt(CartItem::getQuantity)
                .sum();
    }

    /**
     * Kiểm tra giỏ hàng rỗng.
     */
    public boolean isEmpty() {
        return data.isEmpty();
    }

    /**
     * Chuyen sang map variantId -> quantity.
     */
    public Map<Integer, Integer> toVariantQuantityMap() {
        Map<Integer, Integer> map = new HashMap<>();
        for (CartItem item : data.values()) {
            map.put(item.getVariantId(), item.getQuantity());
        }
        return map;
    }

    /**
     * Tạo cart từ map variantId -> quantity.
     */
    public static Cart fromVariantQuantityMap(Map<Integer, Integer> map) {
        Cart cart = new Cart();
        if (map == null || map.isEmpty()) {
            return cart;
        }

        for (Map.Entry<Integer, Integer> entry : map.entrySet()) {
            int variantId = entry.getKey();
            int quantity = entry.getValue() != null ? entry.getValue() : 0;
            if (variantId <= 0 || quantity <= 0) {
                continue;
            }

            // Tạo variant stub để giữ variantId; giá se được cập nhật sau
            ProductVariant variant = new ProductVariant();
            variant.setVariantId(variantId);
            variant.setOriginalPrice(BigDecimal.ZERO);
            variant.setSalePrice(BigDecimal.ZERO);

            CartItem item = new CartItem(null, variant, quantity);
            cart.addItem(item);
        }

        return cart;
    }

    /**
     * Tạo chuỗi mô tả doi tuong.
     */
    @Override
    public String toString() {
        return "Cart{itemCount=" + getItemCount()
                + ", totalQuantity=" + getTotalQuantity()
                + ", subtotal=" + getSubtotal() + "}";
    }
}

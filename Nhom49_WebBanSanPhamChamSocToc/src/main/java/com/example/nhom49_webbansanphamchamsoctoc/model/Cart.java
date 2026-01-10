package com.example.nhom49_webbansanphamchamsoctoc.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

/**
 * Model class đại diện cho giỏ hàng
 * Implements Serializable để có thể lưu trong session
 * Sử dụng HashMap với key là variantId (String) và value là CartItem
 */
public class Cart implements Serializable {

    private Map<String, CartItem> data;

    public Cart() {
        this.data = new HashMap<>();
    }

    public Cart(Map<String, CartItem> data) {
        this.data = data != null ? new HashMap<>(data) : new HashMap<>();
    }

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

    public void updateQuantity(int variantId, int quantity) {
        String key = String.valueOf(variantId);
        if (quantity <= 0) {
            data.remove(key);
        } else if (data.containsKey(key)) {
            data.get(key).setQuantity(quantity);
        }
    }

    public CartItem removeItem(int variantId) {
        return data.remove(String.valueOf(variantId));
    }

    public CartItem removeItem(String key) {
        return data.remove(key);
    }

    public CartItem getItem(int variantId) {
        return data.get(String.valueOf(variantId));
    }

    public CartItem getItem(String key) {
        return data.get(key);
    }

    public boolean containsItem(int variantId) {
        return data.containsKey(String.valueOf(variantId));
    }

    public void clear() {
        data.clear();
    }

    public boolean isEmpty() {
        return data.isEmpty();
    }

    public int getItemCount() {
        return data.size();
    }

    public int getTotalQuantity() {
        return data.values().stream()
                .mapToInt(CartItem::getQuantity)
                .sum();
    }

    public BigDecimal getSubtotal() {
        return data.values().stream()
                .map(CartItem::getTotalPrice)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    public Collection<CartItem> getItems() {
        return data.values();
    }

    public Map<String, CartItem> getData() {
        return data;
    }

    public void setData(Map<String, CartItem> data) {
        this.data = data != null ? data : new HashMap<>();
    }

    public void merge(Cart otherCart) {
        if (otherCart == null || otherCart.isEmpty()) return;
        for (CartItem item : otherCart.getItems()) {
            addItem(item);
        }
    }

    public Map<Integer, Integer> toVariantQuantityMap() {
        Map<Integer, Integer> result = new HashMap<>();
        for (CartItem item : data.values()) {
            result.put(item.getVariantId(), item.getQuantity());
        }
        return result;
    }

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

            // Create a lightweight variant stub to retain the variantId; price will be refreshed later
            ProductVariant variant = new ProductVariant();
            variant.setVariantId(variantId);
            variant.setOriginalPrice(BigDecimal.ZERO);
            variant.setSalePrice(BigDecimal.ZERO);

            CartItem item = new CartItem(null, variant, quantity);
            cart.addItem(item);
        }

        return cart;
    }

    @Override
    public String toString() {
        return "Cart{itemCount=" + getItemCount() + ", totalQuantity=" + getTotalQuantity() + ", subtotal=" + getSubtotal() + "}";
    }
}

package com.example.nhom49_webbansanphamchamsoctoc.services;

import com.example.nhom49_webbansanphamchamsoctoc.dao.ProductDAO;
import com.example.nhom49_webbansanphamchamsoctoc.dao.ProductImgDAO;
import com.example.nhom49_webbansanphamchamsoctoc.dao.ProductVariantDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.Cart;
import com.example.nhom49_webbansanphamchamsoctoc.model.CartItem;
import com.example.nhom49_webbansanphamchamsoctoc.model.Product;
import com.example.nhom49_webbansanphamchamsoctoc.model.ProductImage;
import com.example.nhom49_webbansanphamchamsoctoc.model.ProductVariant;

import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class CartService {

    private static final String CART_SESSION_KEY = "cart";

    private final ProductVariantDAO variantDAO;
    private final ProductDAO productDAO;
    private final ProductImgDAO imageDAO;

    public CartService() {
        this.variantDAO = new ProductVariantDAO();
        this.productDAO = new ProductDAO();
        this.imageDAO = new ProductImgDAO();
    }

    public CartService(ProductVariantDAO variantDAO, ProductDAO productDAO, ProductImgDAO imageDAO) {
        this.variantDAO = (variantDAO != null) ? variantDAO : new ProductVariantDAO();
        this.productDAO = (productDAO != null) ? productDAO : new ProductDAO();
        this.imageDAO = (imageDAO != null) ? imageDAO : new ProductImgDAO();
    }

    public Cart getCart(HttpSession session) {
        if (session == null) return new Cart();
        Object obj = session.getAttribute(CART_SESSION_KEY);
        if (obj instanceof Cart) {
            return (Cart) obj;
        }
        if (obj instanceof Map) {
            Cart cart = rebuildCartFromMap((Map<?, ?>) obj);
            saveCartToSession(session, cart);
            return cart;
        }
        Cart cart = new Cart();
        saveCartToSession(session, cart);
        return cart;
    }

    private void saveCartToSession(HttpSession session, Cart cart) {
        if (session != null) {
            session.setAttribute(CART_SESSION_KEY, cart);
        }
    }

    public boolean addToCart(HttpSession session, int variantId, int quantity) {
        if (session == null || variantId <= 0) return false;

        Cart cart = getCart(session);
        ProductVariant variant = variantDAO.findById(variantId);
        if (variant == null) return false;

        Product product = productDAO.findById(variant.getProductId());
        if (product == null) return false;

        String imageUrl = getProductPrimaryImage(product.getProductId());
        if (quantity <= 0) quantity = 1;

        if (cart.containsItem(variantId)) {
            CartItem existingItem = cart.removeItem(variantId);
            if (existingItem != null) {
                existingItem.increaseQuantity(quantity);
                existingItem.setProduct(product);
                existingItem.setVariant(variant);
                cart.addItem(existingItem);
            }
        } else {
            CartItem newItem = new CartItem(product, variant, quantity, imageUrl);
            cart.addItem(newItem);
        }

        saveCartToSession(session, cart);
        return true;
    }

    public boolean updateQuantity(HttpSession session, int variantId, int quantity) {
        if (session == null) return false;

        Cart cart = getCart(session);

        if (quantity <= 0) {
            cart.removeItem(variantId);
        } else {
            if (!cart.containsItem(variantId)) return false;
            cart.updateQuantity(variantId, quantity);
        }

        saveCartToSession(session, cart);
        return true;
    }

    public boolean removeFromCart(HttpSession session, int variantId) {
        if (session == null) return false;

        Cart cart = getCart(session);
        cart.removeItem(variantId);
        saveCartToSession(session, cart);
        return true;
    }

    public void clearCart(HttpSession session) {
        if (session != null) {
            session.removeAttribute(CART_SESSION_KEY);
        }
    }

    public List<CartItem> getCartItems(HttpSession session) {
        return getCartItems(getCart(session));
    }

    public List<CartItem> getCartItems(Cart cart) {
        List<CartItem> items = new ArrayList<>();
        if (cart == null) return items;

        for (CartItem item : cart.getItems()) {
            int variantId = item.getVariantId();
            if (variantId <= 0) continue;

            ProductVariant variant = variantDAO.findById(variantId);
            if (variant == null) continue;

            Product product = productDAO.findById(variant.getProductId());
            if (product == null) continue;

            item.setProduct(product);
            item.setVariant(variant);

            if (item.getImageUrl() == null) {
                item.setImageUrl(getProductPrimaryImage(product.getProductId()));
            }

            items.add(item);
        }

        return items;
    }

    public BigDecimal calculateSubtotal(HttpSession session) {
        List<CartItem> refreshedItems = getCartItems(session);
        return calculateSubtotal(refreshedItems);
    }

    public BigDecimal calculateSubtotal(List<CartItem> items) {
        return items.stream()
                .map(CartItem::getTotalPrice)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    public int getCartCount(HttpSession session) {
        return getCart(session).getTotalQuantity();
    }

    private String getProductPrimaryImage(int productId) {
        List<ProductImage> images = imageDAO.findByProductId(productId);
        if (images != null && !images.isEmpty()) {
            for (ProductImage img : images) {
                if (img.isPrimary()) return img.getImageUrl();
            }
            return images.get(0).getImageUrl();
        }
        return null;
    }

    private Cart rebuildCartFromMap(Map<?, ?> cartMap) {
        Cart cart = new Cart();
        if (cartMap == null || cartMap.isEmpty()) {
            return cart;
        }

        for (Map.Entry<?, ?> entry : cartMap.entrySet()) {
            Integer variantId = parseInteger(entry.getKey());
            Integer quantity = parseInteger(entry.getValue());

            if (variantId == null || quantity == null || variantId <= 0 || quantity <= 0) {
                continue;
            }

            ProductVariant variant = variantDAO.findById(variantId);
            if (variant == null) {
                continue;
            }

            Product product = productDAO.findById(variant.getProductId());
            if (product == null) {
                continue;
            }

            String imageUrl = getProductPrimaryImage(product.getProductId());
            cart.addItem(new CartItem(product, variant, quantity, imageUrl));
        }

        return cart;
    }

    private Integer parseInteger(Object value) {
        if (value instanceof Number) {
            return ((Number) value).intValue();
        }
        if (value instanceof String) {
            try {
                return Integer.parseInt(((String) value).trim());
            } catch (NumberFormatException ignored) {
                return null;
            }
        }
        return null;
    }

    // Cart chỉ lưu ở session, chưa đồng bộ với database
    public void loadCartFromDatabase(HttpSession session, int userId) {
    }

    public void clearCartInDatabase(int userId) {
    }

    public List<StockValidationResult> validateStock(Cart cart) {
        if (cart == null) {
            return new ArrayList<>();
        }
        return validateStock(cart.toVariantQuantityMap());
    }

    public List<StockValidationResult> validateStock(Map<Integer, Integer> cartMap) {
        List<StockValidationResult> invalidItems = new ArrayList<>();
        if (cartMap == null || cartMap.isEmpty()) return invalidItems;

        for (Map.Entry<Integer, Integer> entry : cartMap.entrySet()) {
            int variantId = entry.getKey();
            int requestedQuantity = entry.getValue();

            ProductVariant variant = variantDAO.findById(variantId);
            if (variant == null) {
                invalidItems.add(new StockValidationResult(variantId, "Sản phẩm không tồn tại", null, requestedQuantity, 0));
                continue;
            }

            Product product = productDAO.findById(variant.getProductId());
            String productName = product != null ? product.getProductName() : "Sản phẩm #" + variant.getProductId();
            int availableStock = variant.getStockQuantity();

            if (requestedQuantity > availableStock) {
                invalidItems.add(new StockValidationResult(variantId, productName, variant.getVariantName(), requestedQuantity, availableStock));
            }
        }

        return invalidItems;
    }

    public boolean isStockValid(HttpSession session) {
        return validateStock(getCart(session)).isEmpty();
    }

    public String buildStockErrorMessage(List<StockValidationResult> items) {
        if (items == null || items.isEmpty()) {
            return "";
        }
        StringBuilder sb = new StringBuilder("Mot so sản phẩm vuot tồn kho:\n");
        for (StockValidationResult item : items) {
            String name = item.getProductName();
            if (item.getVariantName() != null && !item.getVariantName().isEmpty()) {
                name += " (" + item.getVariantName() + ")";
            }
            sb.append("- ").append(name);
            sb.append(": Yêu cầu ").append(item.getRequestedQuantity())
                    .append(", còn lại ").append(item.getAvailableStock()).append("\n");
        }
        return sb.toString();
    }

    public Map<Integer, Integer> getCartAsMap(HttpSession session) {
        return getCart(session).toVariantQuantityMap();
    }

    public static class StockValidationResult {
        private final int variantId;
        private final String productName;
        private final String variantName;
        private final int requestedQuantity;
        private final int availableStock;

        public StockValidationResult(int variantId, String productName, String variantName, int requestedQuantity, int availableStock) {
            this.variantId = variantId;
            this.productName = productName;
            this.variantName = variantName;
            this.requestedQuantity = requestedQuantity;
            this.availableStock = availableStock;
        }

        public int getVariantId() { return variantId; }
        public String getProductName() { return productName; }
        public String getVariantName() { return variantName; }
        public int getRequestedQuantity() { return requestedQuantity; }
        public int getAvailableStock() { return availableStock; }
    }
}

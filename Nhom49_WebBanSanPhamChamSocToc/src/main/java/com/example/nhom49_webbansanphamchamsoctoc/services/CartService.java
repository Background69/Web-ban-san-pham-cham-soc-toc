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

/**
 * Lớp CartService.
 */
public class CartService {

    private static final String CART_SESSION_KEY = "cart";

    private final ProductVariantDAO variantDAO;
    private final ProductDAO productDAO;
    private final ProductImgDAO imageDAO;

    /**
     * Thực hiện cart service.
     */
    public CartService() {
        this.variantDAO = new ProductVariantDAO();
        this.productDAO = new ProductDAO();
        this.imageDAO = new ProductImgDAO();
    }

    /**
     * Thực hiện cart service.
     *
     * @param variantDAO Tham số đầu vào.
     * @param productDAO Tham số đầu vào.
     * @param imageDAO Tham số đầu vào.
     */
    public CartService(ProductVariantDAO variantDAO, ProductDAO productDAO, ProductImgDAO imageDAO) {
        this.variantDAO = new ProductVariantDAO();
        this.productDAO = new ProductDAO();
        this.imageDAO = imageDAO != null ? imageDAO : new ProductImgDAO();
    }

    /**
     * Lấy cart từ session, nếu chua co thi tạo mới.
     *
     * @param session Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
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

    /**
     * Thực hiện save cart to session.
     *
     * Security note: Xu ly du lieu nhay cam (mật khẩu/token/phien), tranh ghi log và dam bao bao mat.
     *
     * @param session Tham số đầu vào.
     * @param cart Tham số đầu vào.
     * @return Không trả về giá trị.
     */
    private void saveCartToSession(HttpSession session, Cart cart) {
        if (session != null) {
            session.setAttribute(CART_SESSION_KEY, cart);
        }
    }

    /**
     * Them sản phẩm vao giỏ hàng.
     *
     * @param session Tham số đầu vào.
     * @param variantId Tham số đầu vào.
     * @param quantity Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
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

    /**
     * Cập nhật quantity.
     *
     * Security note: Xu ly du lieu nhay cam (mật khẩu/token/phien), tranh ghi log và dam bao bao mat.
     *
     * @param session Tham số đầu vào.
     * @param variantId Tham số đầu vào.
     * @param quantity Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
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

    /**
     * Xóa from cart.
     *
     * Security note: Xu ly du lieu nhay cam (mật khẩu/token/phien), tranh ghi log và dam bao bao mat.
     *
     * @param session Tham số đầu vào.
     * @param variantId Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    public boolean removeFromCart(HttpSession session, int variantId) {
        if (session == null) return false;

        Cart cart = getCart(session);
        cart.removeItem(variantId);
        saveCartToSession(session, cart);
        return true;
    }

    /**
     * Thực hiện clear cart.
     *
     * Security note: Xu ly du lieu nhay cam (mật khẩu/token/phien), tranh ghi log và dam bao bao mat.
     *
     * @param session Tham số đầu vào.
     * @return Không trả về giá trị.
     */
    public void clearCart(HttpSession session) {
        if (session != null) {
            session.removeAttribute(CART_SESSION_KEY);
        }
    }

    /**
     * Lấy danh sach cart items đã được lam moi thong tin.
     *
     * @param session Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    public List<CartItem> getCartItems(HttpSession session) {
        return getCartItems(getCart(session));
    }

    /**
     * Lấy danh sach cart items đã được lam moi thong tin.
     *
     * @param cart Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
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

    /**
     * Thực hiện calculate subtotal.
     *
     * Security note: Xu ly du lieu nhay cam (mật khẩu/token/phien), tranh ghi log và dam bao bao mat.
     *
     * @param session Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    public BigDecimal calculateSubtotal(HttpSession session) {
        List<CartItem> refreshedItems = getCartItems(session);
        return calculateSubtotal(refreshedItems);
    }

    /**
     * Thực hiện calculate subtotal.
     *
     * @param items Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    public BigDecimal calculateSubtotal(List<CartItem> items) {
        return items.stream()
                .map(CartItem::getTotalPrice)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    /**
     * Lấy số lượng sản phẩm trỗng gio.
     *
     * @param session Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    public int getCartCount(HttpSession session) {
        return getCart(session).getTotalQuantity();
    }

    /**
     * Lấy product primary image.
     *
     * @param productId Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
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

    /**
     * Thực hiện rebuild cart from map.
     *
     * @param cartMap Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
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

    /**
     * Thực hiện parse integer.
     *
     * @param value Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
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

    /**
     * Thực hiện load cart from database.
     *
     * Security note: Xu ly du lieu nhay cam (mật khẩu/token/phien), tranh ghi log và dam bao bao mat.
     *
     * @param session Tham số đầu vào.
     * @param userId Tham số đầu vào.
     * @return Không trả về giá trị.
     */
    public void loadCartFromDatabase(HttpSession session, int userId) {
        // Cart dang luu trỗng session, chua dong bo với database
    }

    /**
     * Xóa cart trỗng database (neu co).
     *
     * @param userId Tham số đầu vào.
     * @return Không trả về giá trị.
     */
    public void clearCartInDatabase(int userId) {
        // Cart chỉ luu o session, chua can thao tac DB
    }

    /**
     * Kiểm tra hop le stock từ Cart.
     *
     * @param cart Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    public List<StockValidationResult> validateStock(Cart cart) {
        if (cart == null) {
            return new ArrayList<>();
        }
        return validateStock(cart.toVariantQuantityMap());
    }

    /**
     * Kiểm tra hop le stock.
     *
     * @param cartMap Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
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

    /**
     * Kiểm tra stock valid.
     *
     * Security note: Xu ly du lieu nhay cam (mật khẩu/token/phien), tranh ghi log và dam bao bao mat.
     *
     * @param session Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    public boolean isStockValid(HttpSession session) {
        return validateStock(getCart(session)).isEmpty();
    }

    /**
     * Tạo thông báo lỗi stock.
     *
     * @param items Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
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

    /**
     * Lấy cart as map.
     *
     * Security note: Xu ly du lieu nhay cam (mật khẩu/token/phien), tranh ghi log và dam bao bao mat.
     *
     * @param session Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    public Map<Integer, Integer> getCartAsMap(HttpSession session) {
        return getCart(session).toVariantQuantityMap();
    }

    /**
     * Ket qua kiem tra tồn kho.
     */
    public static class StockValidationResult {
        private final int variantId;
        private final String productName;
        private final String variantName;
        private final int requestedQuantity;
        private final int availableStock;

        /**
         * Thực hiện stock validation result.
         *
         * @param variantId Tham số đầu vào.
         * @param productName Tham số đầu vào.
         * @param variantName Tham số đầu vào.
         * @param requestedQuantity Tham số đầu vào.
         * @param availableStock Tham số đầu vào.
         */
        public StockValidationResult(int variantId, String productName, String variantName, int requestedQuantity, int availableStock) {
            this.variantId = variantId;
            this.productName = productName;
            this.variantName = variantName;
            this.requestedQuantity = requestedQuantity;
            this.availableStock = availableStock;
        }

        /**
         * Lấy variant id.
         *
         * @return Kết quả xử lý của phương thức.
         */
        public int getVariantId() {
            return variantId;
        }

        /**
         * Lấy product name.
         *
         * @return Kết quả xử lý của phương thức.
         */
        public String getProductName() {
            return productName;
        }

        /**
         * Lấy variant name.
         *
         * @return Kết quả xử lý của phương thức.
         */
        public String getVariantName() {
            return variantName;
        }

        /**
         * Lấy requested quantity.
         *
         * @return Kết quả xử lý của phương thức.
         */
        public int getRequestedQuantity() {
            return requestedQuantity;
        }

        /**
         * Lấy available stock.
         *
         * @return Kết quả xử lý của phương thức.
         */
        public int getAvailableStock() {
            return availableStock;
        }
    }
}

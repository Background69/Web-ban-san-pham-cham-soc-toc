package com.example.nhom49_webbansanphamchamsoctoc.util;

import com.example.nhom49_webbansanphamchamsoctoc.model.Cart;
import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import jakarta.servlet.http.HttpSession;

import java.util.HashMap;
import java.util.Map;

/**
 * Utility class để quản lý session
 * Tập trung tất cả logic session vào một nơi
 */
public class SessionUtil {

    // Session attribute keys
    public static final String USER_KEY = "user";
    public static final String CART_KEY = "cart";
    public static final String SUCCESS_KEY = "success";
    public static final String ERROR_KEY = "error";

    // ==================== User Session ====================

    /**
     * Lấy user hiện tại từ session
     */
    public static User getCurrentUser(HttpSession session) {
        if (session == null) return null;
        return (User) session.getAttribute(USER_KEY);
    }

    /**
     * Lưu user vào session (không bao gồm password)
     */
    public static void setCurrentUser(HttpSession session, User user) {
        if (session == null || user == null) return;

        // Tạo copy không có password để lưu vào session
        User sessionUser = new User();
        sessionUser.setUserId(user.getUserId());
        sessionUser.setEmail(user.getEmail());
        sessionUser.setUsername(user.getUsername());
        sessionUser.setPhone(user.getPhone());
        sessionUser.setAvatar(user.getAvatar());
        sessionUser.setRole(user.getRole());
        sessionUser.setActive(user.isActive());
        sessionUser.setCreatedAt(user.getCreatedAt());
        sessionUser.setGoogleId(user.getGoogleId());
        // Password KHÔNG được set vào session

        session.setAttribute(USER_KEY, sessionUser);
    }

    /**
     * Xóa user khỏi session
     */
    public static void removeCurrentUser(HttpSession session) {
        if (session != null) {
            session.removeAttribute(USER_KEY);
        }
    }

    /**
     * Kiểm tra user đã đăng nhập chưa
     */
    public static boolean isLoggedIn(HttpSession session) {
        return getCurrentUser(session) != null;
    }

    /**
     * Kiểm tra user có phải admin không
     */
    public static boolean isAdmin(HttpSession session) {
        User user = getCurrentUser(session);
        return user != null && "Admin".equals(user.getRole()) && user.isActive();
    }

    // ==================== Cart Session ====================

    /**
     * Lấy Cart object từ session
     */
    public static Cart getCartObject(HttpSession session) {
        if (session == null) return new Cart();
        Cart cart = (Cart) session.getAttribute(CART_KEY);
        return cart != null ? cart : new Cart();
    }

    /**
     * Lưu Cart object vào session
     */
    public static void setCartObject(HttpSession session, Cart cart) {
        if (session != null) {
            session.setAttribute(CART_KEY, cart);
        }
    }

    /**
     * Lấy cart từ session dưới dạng Map (để tương thích ngược)
     */
    @SuppressWarnings("unchecked")
    public static Map<Integer, Integer> getCart(HttpSession session) {
        if (session == null) return new HashMap<>();
        Object cartObj = session.getAttribute(CART_KEY);

        // Hỗ trợ cả Cart object và Map cũ
        if (cartObj instanceof Cart) {
            return ((Cart) cartObj).toVariantQuantityMap();
        } else if (cartObj instanceof Map) {
            return (Map<Integer, Integer>) cartObj;
        }
        return new HashMap<>();
    }

    /**
     * Lưu cart vào session
     */
    public static void setCart(HttpSession session, Map<Integer, Integer> cart) {
        if (session != null) {
            // Chuyển đổi sang Cart object
            Cart cartObj = Cart.fromVariantQuantityMap(cart);
            session.setAttribute(CART_KEY, cartObj);
        }
    }

    /**
     * Xóa cart khỏi session
     */
    public static void clearCart(HttpSession session) {
        if (session != null) {
            session.removeAttribute(CART_KEY);
        }
    }

    /**
     * Kiểm tra cart có trống không
     */
    public static boolean isCartEmpty(HttpSession session) {
        Cart cart = getCartObject(session);
        return cart.isEmpty();
    }

    /**
     * Lấy số lượng items trong cart
     */
    public static int getCartItemCount(HttpSession session) {
        Cart cart = getCartObject(session);
        return cart.getTotalQuantity();
    }

    // ==================== Flash Messages ====================

    /**
     * Set success message (sẽ hiển thị 1 lần)
     */
    public static void setSuccessMessage(HttpSession session, String message) {
        if (session != null && message != null) {
            session.setAttribute(SUCCESS_KEY, message);
        }
    }

    /**
     * Set error message (sẽ hiển thị 1 lần)
     */
    public static void setErrorMessage(HttpSession session, String message) {
        if (session != null && message != null) {
            session.setAttribute(ERROR_KEY, message);
        }
    }

    /**
     * Lấy và xóa success message
     */
    public static String getAndClearSuccessMessage(HttpSession session) {
        if (session == null) return null;
        String message = (String) session.getAttribute(SUCCESS_KEY);
        session.removeAttribute(SUCCESS_KEY);
        return message;
    }

    /**
     * Lấy và xóa error message
     */
    public static String getAndClearErrorMessage(HttpSession session) {
        if (session == null) return null;
        String message = (String) session.getAttribute(ERROR_KEY);
        session.removeAttribute(ERROR_KEY);
        return message;
    }

    // ==================== Session Management ====================

    /**
     * Invalidate session (logout)
     */
    public static void invalidateSession(HttpSession session) {
        if (session != null) {
            session.removeAttribute(USER_KEY);
            session.removeAttribute(CART_KEY);
            session.invalidate();
        }
    }

    /**
     * Lấy hoặc tạo session
     */
    public static HttpSession getOrCreateSession(jakarta.servlet.http.HttpServletRequest request) {
        return request.getSession(true);
    }
}

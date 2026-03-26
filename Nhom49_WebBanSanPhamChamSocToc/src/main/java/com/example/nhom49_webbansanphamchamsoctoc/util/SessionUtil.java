package com.example.nhom49_webbansanphamchamsoctoc.util;

import com.example.nhom49_webbansanphamchamsoctoc.model.Cart;
import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import jakarta.servlet.http.HttpSession;

import java.util.Map;

/**
 * Utility class để quản lý session
 * Tập trung tất cả logic session vào một nơi
 */
public class SessionUtil {

    public static final String USER_KEY = "user";
    public static final String CURRENT_USER_KEY = "currentUser";
    public static final String CART_KEY = "cart";
    public static final String SUCCESS_KEY = "success";
    public static final String ERROR_KEY = "error";

    /**
     * Lấy user hiện tại từ session
     */
    public static User getCurrentUser(HttpSession session) {
        if (session == null) return null;
        User user = (User) session.getAttribute(USER_KEY);
        if (user == null) {
            user = (User) session.getAttribute(CURRENT_USER_KEY);
        }
        return user;
    }

    /**
     * Lưu user vào session (không bao gồm password)
     */
    public static void setCurrentUser(HttpSession session, User user) {
        if (session == null || user == null) return;

        // Tạo copy không có password để luu vao session
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
        session.setAttribute(CURRENT_USER_KEY, sessionUser);
        // Đảm bảo cả 2 key đều trỏ tới cùng 1 object
    }

    /**
     * Xóa user khỏi session
     */
    public static void removeCurrentUser(HttpSession session) {
        if (session != null) {
            session.removeAttribute(USER_KEY);
            session.removeAttribute(CURRENT_USER_KEY);
        }
    }

    /**
     * Kiểm tra user đã đăng nhập chưa
     */
    public static boolean isLoggedIn(HttpSession session) {
        return getCurrentUser(session) != null;
    }

    /**
     * Thiết lập cart.
     */
    public static void setCart(HttpSession session, Map<Integer, Integer> cart) {
        if (session != null) {
            Cart cartObj = Cart.fromVariantQuantityMap(cart);
            session.setAttribute(CART_KEY, cartObj);
        }
    }

    /**
     * Lấy Cart object từ session hoặc tạo mới nếu chua co.
     */
    private static Cart getCartObject(HttpSession session) {
        if (session == null) {
            return new Cart();
        }
        Object data = session.getAttribute(CART_KEY);
        if (data instanceof Cart) {
            return (Cart) data;
        }
        if (data instanceof Map) {
            @SuppressWarnings("unchecked")
            Map<Integer, Integer> cartMap = (Map<Integer, Integer>) data;
            Cart cart = Cart.fromVariantQuantityMap(cartMap);
            session.setAttribute(CART_KEY, cart);
            return cart;
        }
        Cart cart = new Cart();
        session.setAttribute(CART_KEY, cart);
        return cart;
    }

    /**
     * Thực hiện clear cart.
     */
    public static void clearCart(HttpSession session) {
        if (session != null) {
            session.removeAttribute(CART_KEY);
        }
    }

    /**
     * Kiểm tra cart empty.
     */
    public static boolean isCartEmpty(HttpSession session) {
        Cart cart = getCartObject(session);
        return cart.isEmpty();
    }

    /**
     * Lấy cart item count.
     */
    public static int getCartItemCount(HttpSession session) {
        Cart cart = getCartObject(session);
        return cart.getTotalQuantity();
    }

    /**
     * Thiết lập success message.
     */
    public static void setSuccessMessage(HttpSession session, String message) {
        if (session != null && message != null) {
            session.setAttribute(SUCCESS_KEY, message);
        }
    }

    /**
     * Thiết lập error message.
     */
    public static void setErrorMessage(HttpSession session, String message) {
        if (session != null && message != null) {
            session.setAttribute(ERROR_KEY, message);
        }
    }

    /**
     * Lấy và xoa success message.
     */
    public static String getAndClearSuccessMessage(HttpSession session) {
        if (session == null) return null;
        String message = (String) session.getAttribute(SUCCESS_KEY);
        session.removeAttribute(SUCCESS_KEY);
        return message;
    }

    /**
     * Lấy và xoa error message.
     */
    public static String getAndClearErrorMessage(HttpSession session) {
        if (session == null) return null;
        String message = (String) session.getAttribute(ERROR_KEY);
        session.removeAttribute(ERROR_KEY);
        return message;
    }

    /**
     * Invalidate session.
     */
    public static void invalidateSession(HttpSession session) {
        if (session != null) {
            session.removeAttribute(USER_KEY);
            session.removeAttribute(CURRENT_USER_KEY);
            session.removeAttribute(CART_KEY);
            session.invalidate();
        }
    }

    /**
     * Lấy hoặc tao session.
     */
    public static HttpSession getOrCreateSession(jakarta.servlet.http.HttpServletRequest request) {
        return request.getSession(true);
    }
}

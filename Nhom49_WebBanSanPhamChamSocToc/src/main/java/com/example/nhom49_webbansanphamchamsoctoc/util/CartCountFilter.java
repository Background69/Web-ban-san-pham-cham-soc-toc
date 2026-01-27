package com.example.nhom49_webbansanphamchamsoctoc.util;

import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import com.example.nhom49_webbansanphamchamsoctoc.services.CartService;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Filter để set cartCount vào session cho mọi request.
 * Đảm bảo header luôn hiển thị đúng số lượng sản phẩm trong giỏ hàng.
 */
@WebFilter(filterName = "CartCountFilter", urlPatterns = { "/*" })
public class CartCountFilter implements Filter {

    private CartService cartService;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        cartService = new CartService();
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpSession session = httpRequest.getSession(false);

        // Chỉ xử lý nếu đã có session và user đã đăng nhập
        if (session != null) {
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser != null) {
                // Lấy cart count từ CartService và set vào session
                int cartCount = cartService.getCartCount(session);
                session.setAttribute("cartCount", cartCount);
            } else {
                // Nếu chưa đăng nhập, set cartCount = 0
                session.setAttribute("cartCount", 0);
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Cleanup if needed
    }
}

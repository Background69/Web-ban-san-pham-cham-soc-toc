package com.example.nhom49_webbansanphamchamsoctoc.controller.authentication;

import com.example.nhom49_webbansanphamchamsoctoc.model.User;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Filter để kiểm tra quyền Admin trước khi truy cập các trang quản trị.
 */
public class AdminFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    /**
     * Thực hiện lọc request để kiểm tra quyền Admin.
     */
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        HttpSession session = httpRequest.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user != null && user.isActive() && "Admin".equals(user.getRole())) {
            // User là Admin và active, cho phép truy cập
            chain.doFilter(request, response);
        } else if (user != null && user.isActive()) {
            // User đã đăng nhập nhưng không phải Admin
            // Redirect về trang chủ với thông báo lỗi
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/?error=access_denied");
        } else {
            // Chưa đăng nhập, redirect to login
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login?redirect=/admin");
        }
    }

    /**
     * Giải phóng tài nguyên khi kết thúc
     */
    @Override
    public void destroy() {
    }
}
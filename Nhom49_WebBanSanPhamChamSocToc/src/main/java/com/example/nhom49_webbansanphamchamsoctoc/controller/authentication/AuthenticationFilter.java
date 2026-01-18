package com.example.nhom49_webbansanphamchamsoctoc.controller.authentication;

import com.example.nhom49_webbansanphamchamsoctoc.model.User;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

/**
 * Filter kiểm tra authentication cho các URL cần đăng nhập
 * Áp dụng cho: /checkout, /orders/*, /profile/*
 */
public class AuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        HttpSession session = httpRequest.getSession(false);
        User user = null;

        if (session != null) {
            user = (User) session.getAttribute("user");
        }

        if (user != null && user.isActive()) {
            // User đã đăng nhập và active, cho phép truy cập
            chain.doFilter(request, response);
        } else {
            // Chưa đăng nhập hoặc user không active, redirect to login
            String requestURI = httpRequest.getRequestURI();
            String contextPath = httpRequest.getContextPath();
            String redirectPath = requestURI.substring(contextPath.length());

            // Thêm query string nếu có
            String queryString = httpRequest.getQueryString();
            if (queryString != null && !queryString.isEmpty()) {
                redirectPath += "?" + queryString;
            }

            httpResponse.sendRedirect(contextPath + "/login?redirect=" +
                    URLEncoder.encode(redirectPath, StandardCharsets.UTF_8));
        }
    }

    @Override
    public void destroy() {
        // Cleanup if needed
    }
}

package com.example.nhom49_webbansanphamchamsoctoc.controller.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Controller này chỉ redirect /orders -> /profile/orders
 * Để giữ backward compatibility với các link cũ
 */
@WebServlet(name = "OrderHistoryController", urlPatterns = {"/orders"})
public class OrderHistoryController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect tới profile orders với các query params nếu có
        String status = request.getParameter("status");
        String redirectUrl = request.getContextPath() + "/profile/orders";
        if (status != null && !status.isEmpty()) {
            redirectUrl += "?status=" + status;
        }
        response.sendRedirect(redirectUrl);
    }
}

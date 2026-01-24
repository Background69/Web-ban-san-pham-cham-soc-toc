package com.example.nhom49_webbansanphamchamsoctoc.controller.user;

import com.example.nhom49_webbansanphamchamsoctoc.model.Order;
import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import com.example.nhom49_webbansanphamchamsoctoc.services.OrderService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "OrderDetailController", urlPatterns = {"/orders/*"})
public class OrderDetailController extends HttpServlet {
    private OrderService orderService;


    @Override
    public void init() throws ServletException {
        orderService = new OrderService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendRedirect(request.getContextPath() + "/orders");
            return;
        }

        HttpSession session = request.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=/orders");
            return;
        }

        try {
            int orderId = Integer.parseInt(pathInfo.substring(1));
            Order order = orderService.getOrderById(orderId);

            // Kiểm tra order thuộc về user hiện tại
            if (order == null || !order.getUserId().equals(user.getUserId())) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Đơn hàng không tồn tại");
                return;
            }

            request.setAttribute("order", order);
            request.setAttribute("orderService", orderService);

            request.getRequestDispatcher("/user/product-detail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/orders");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        if (pathInfo != null && pathInfo.endsWith("/cancel")) {
            cancelOrder(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/orders");
        }
    }

    private void cancelOrder(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String pathInfo = request.getPathInfo();
        HttpSession session = request.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=/orders");
            return;
        }

        try {
            // Extract order ID từ path: /orders/{id}/cancel
            String orderIdStr = pathInfo.replace("/cancel", "").substring(1);
            int orderId = Integer.parseInt(orderIdStr);

            Order order = orderService.getOrderById(orderId);

            // Kiểm tra order thuộc về user và có thể hủy
            if (order != null && order.getUserId().equals(user.getUserId())) {
                orderService.cancelOrder(orderId);
            }

            response.sendRedirect(request.getContextPath() + "/orders/" + orderId);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/orders");
        }
    }
}
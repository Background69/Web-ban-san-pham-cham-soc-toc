package com.example.nhom49_webbansanphamchamsoctoc.controller.admin;

import com.example.nhom49_webbansanphamchamsoctoc.dao.OrderDAO;
import com.example.nhom49_webbansanphamchamsoctoc.dao.OrderItemDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.Order;
import com.example.nhom49_webbansanphamchamsoctoc.model.OrderItem;
import com.example.nhom49_webbansanphamchamsoctoc.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "OrderManagementController", value = "/admin/orders")
public class OrderManagementController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        OrderDAO orderDAO = new OrderDAO();
        // Cập nhật trạng thái của đơn hàng
        String action = request.getParameter("action");
        if ("updateStatus".equals(action)) {
            Integer orderId = ValidationUtil.parseIntSafe(request.getParameter("id"));
            if (orderId == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid ID");
                return;
            }
            String status = request.getParameter("status");
            orderDAO.updateStatus(orderId, status);
            // Nếu gọi từ trang detail, redirect về detail
            String from = request.getParameter("from");
            if ("detail".equals(from)) {
                response.sendRedirect(request.getContextPath() + "/admin/orders?action=detail&id=" + orderId);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/orders");
            }
            return;
        }
        // Xoá đơn hàng
        if ("delete".equals(action)) {
            Integer orderId = ValidationUtil.parseIntSafe(request.getParameter("id"));
            if (orderId == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid ID");
                return;
            }
            orderDAO.delete(orderId);
            response.sendRedirect(request.getContextPath() + "/admin/orders");
            return;
        }
        if ("detail".equals(action)) {
            Integer orderId = ValidationUtil.parseIntSafe(request.getParameter("id"));
            if (orderId == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid ID");
                return;
            }
            OrderItemDAO orderItemDAO = new OrderItemDAO();
            Order order = orderDAO.findById(orderId);
            List<OrderItem> orderItems = orderItemDAO.findByOrderId(orderId);

            request.setAttribute("order", order);
            request.setAttribute("orderItems", orderItems);

            request.getRequestDispatcher("/admin/order/detail.jsp")
                    .forward(request, response);
            return;
        }

        // Danh sách đơn hàng
        List<Order> orders = orderDAO.findAll();
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/admin/order/list.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
    }
}
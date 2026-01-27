package com.example.nhom49_webbansanphamchamsoctoc.controller.admin;

import com.example.nhom49_webbansanphamchamsoctoc.dao.OrderDAO;
import com.example.nhom49_webbansanphamchamsoctoc.dao.OrderItemDAO;
import com.example.nhom49_webbansanphamchamsoctoc.dao.ProductDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.Order;
import com.example.nhom49_webbansanphamchamsoctoc.model.OrderItem;
import com.example.nhom49_webbansanphamchamsoctoc.model.Product;
import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "OrderManagementController", value = "/admin/orders")
public class OrderManagementController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        OrderDAO orderDAO = new OrderDAO();
        // Cập nhật trạng thái của đơn hàng
        String action = request.getParameter("action");
        if ("updateStatus".equals(action)) {
            int orderId = Integer.parseInt(request.getParameter("id"));
            String status = request.getParameter("status");
            orderDAO.updateStatus(orderId, status);
            response.sendRedirect(request.getContextPath() + "/admin/orders");
            return;
        }
        //Xoá đơn hàng
        if ("delete".equals(action)){
            int orderId = Integer.parseInt(request.getParameter("id"));
            orderDAO.delete(orderId);
            response.sendRedirect(request.getContextPath() + "/admin/orders");
            return;
        }
        if ("detail".equals(action)) {
            int orderId = Integer.parseInt(request.getParameter("id"));
            OrderItemDAO orderItemDAO = new OrderItemDAO();
            Order order = orderDAO.findById(orderId);
            List<OrderItem> orderItems = orderItemDAO.findByOrderId(orderId);

            request.setAttribute("order", order);
            request.setAttribute("orderItems", orderItems);

            request.getRequestDispatcher("/admin/order/detail.jsp")
                    .forward(request, response);
            return;
        }

        //Danh sách đơn hàng
        List<Order> orders = orderDAO.findAll();
        request.setAttribute("orders",orders);
        request.getRequestDispatcher("/admin/order/list.jsp")
                .forward(request,response);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
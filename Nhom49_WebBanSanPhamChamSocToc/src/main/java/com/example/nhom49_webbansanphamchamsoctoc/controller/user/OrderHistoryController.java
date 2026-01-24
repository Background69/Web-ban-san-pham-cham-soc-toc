package com.example.nhom49_webbansanphamchamsoctoc.controller.user;

import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import com.example.nhom49_webbansanphamchamsoctoc.services.OrderService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "OrderHistoryController", urlPatterns = {"/orders"})
public class OrderHistoryController extends HttpServlet {
    private OrderService orderService;

    @Override
    public void init() throws ServletException {
        orderService = new OrderService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = session != null ? (User) session.getAttribute("currentUser") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login?redirect=/orders");
            return;
        }

        String status = request.getParameter("status");
        if (status != null && !status.isEmpty()) {
            request.setAttribute("orders", orderService.getOrdersByUserAndStatus(user.getUserId(), status.toUpperCase()));
        } else {
            request.setAttribute("orders", orderService.getOrdersByUser(user.getUserId()));
        }
        request.setAttribute("orderService", orderService); // For status display name

        request.getRequestDispatcher("/user/order/history.jsp").forward(request, response);
    }
}
package com.example.nhom49_webbansanphamchamsoctoc.controller.admin;

import com.example.nhom49_webbansanphamchamsoctoc.dao.OrderDAO;
import com.example.nhom49_webbansanphamchamsoctoc.dao.OrderItemDAO;
import com.example.nhom49_webbansanphamchamsoctoc.dao.PaymentTransactionDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.Order;
import com.example.nhom49_webbansanphamchamsoctoc.model.OrderItem;
import com.example.nhom49_webbansanphamchamsoctoc.model.PaymentTransaction;
import com.example.nhom49_webbansanphamchamsoctoc.services.BankTransferService;
import com.example.nhom49_webbansanphamchamsoctoc.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

@WebServlet(name = "OrderManagementController", value = "/admin/orders")
public class OrderManagementController extends HttpServlet {
    private OrderDAO orderDAO;
    private OrderItemDAO orderItemDAO;
    private PaymentTransactionDAO paymentTransactionDAO;
    private BankTransferService bankTransferService;

    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
        orderItemDAO = new OrderItemDAO();
        paymentTransactionDAO = new PaymentTransactionDAO();
        bankTransferService = new BankTransferService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("updateStatus".equals(action)) {
            handleUpdateStatus(request, response);
            return;
        }

        if ("confirmPayment".equals(action)) {
            handleConfirmPayment(request, response);
            return;
        }

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
            showOrderDetail(request, response, orderId);
            return;
        }

        String keyword = request.getParameter("keyword");
        String status = request.getParameter("status");
        System.out.println("keyword = [" + keyword + "]");
        System.out.println("status = [" + status + "]");

        List<Order> orders;

        if ((keyword != null && !keyword.isBlank())
                || (status != null && !status.isBlank())) {

            orders = orderDAO.searchOrders(keyword, status);
        } else {
            orders = orderDAO.findAll();
        }
        System.out.println("orders found = " + orders.size());
        request.setAttribute("orders", orders);
        request.setAttribute("keyword", keyword);
        request.setAttribute("status", status);
        request.getRequestDispatcher("/admin/order/list.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
    }

    private void handleUpdateStatus(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Integer orderId = ValidationUtil.parseIntSafe(request.getParameter("id"));
        if (orderId == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid ID");
            return;
        }

        String status = request.getParameter("status");
        if (status == null || status.isBlank()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid status");
            return;
        }

        Order order = orderDAO.findById(orderId);
        if (order == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Order not found");
            return;
        }

        if ("confirmed".equalsIgnoreCase(status)
                && "bank_transfer".equalsIgnoreCase(order.getPaymentMethod())
                && !bankTransferService.hasSuccessfulPayment(orderId)) {
            redirectWithDetailMessage(response, request, orderId, "error",
                    "Đơn bank transfer chưa có giao dịch thanh toán SUCCESS.");
            return;
        }

        orderDAO.updateStatus(orderId, status);
        String from = request.getParameter("from");
        if ("detail".equals(from)) {
            response.sendRedirect(request.getContextPath() + "/admin/orders?action=detail&id=" + orderId);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/orders");
        }
    }

    private void handleConfirmPayment(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Integer transactionId = ValidationUtil.parseIntSafe(request.getParameter("transactionId"));
        if (transactionId == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid transaction ID");
            return;
        }

        PaymentTransaction transaction = paymentTransactionDAO.findById(transactionId);
        if (transaction == null || transaction.getOrderId() == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Transaction not found");
            return;
        }

        boolean success = bankTransferService.confirmByAdmin(transactionId);
        if (success) {
            redirectWithDetailMessage(response, request, transaction.getOrderId(), "success",
                    "Đã xác nhận thanh toán bank transfer thành công.");
        } else {
            redirectWithDetailMessage(response, request, transaction.getOrderId(), "error",
                    bankTransferService.getLastError() != null
                            ? bankTransferService.getLastError()
                            : "Không thể xác nhận thanh toán.");
        }
    }

    private void showOrderDetail(HttpServletRequest request, HttpServletResponse response, int orderId)
            throws ServletException, IOException {
        Order order = orderDAO.findById(orderId);
        if (order == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Order not found");
            return;
        }

        List<OrderItem> orderItems = orderItemDAO.findByOrderId(orderId);
        PaymentTransaction paymentTransaction = bankTransferService.getLatestTransactionByOrder(orderId);

        request.setAttribute("order", order);
        request.setAttribute("orderItems", orderItems);
        request.setAttribute("paymentTransaction", paymentTransaction);
        request.setAttribute("success", request.getParameter("success"));
        request.setAttribute("error", request.getParameter("error"));

        request.getRequestDispatcher("/admin/order/detail.jsp")
                .forward(request, response);
    }

    private void redirectWithDetailMessage(HttpServletResponse response, HttpServletRequest request, int orderId,
                                           String type, String message) throws IOException {
        String encoded = URLEncoder.encode(message, StandardCharsets.UTF_8);
        response.sendRedirect(request.getContextPath()
                + "/admin/orders?action=detail&id=" + orderId + "&" + type + "=" + encoded);
    }
}

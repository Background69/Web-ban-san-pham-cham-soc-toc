package com.example.nhom49_webbansanphamchamsoctoc.controller.payment;

import com.example.nhom49_webbansanphamchamsoctoc.model.PaymentTransaction;
import com.example.nhom49_webbansanphamchamsoctoc.services.PaymentService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * API endpoint để kiểm tra trạng thái thanh toán
 * URL: /payment/status
 * Returns JSON: {status: "PENDING|SUCCESS|EXPIRED", message: "..."}
 */
@WebServlet(name = "CheckPaymentStatusController", urlPatterns = { "/payment/status" })
public class CheckPaymentStatusController extends HttpServlet {

    private PaymentService paymentService;

    @Override
    public void init() throws ServletException {
        paymentService = new PaymentService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String orderTempId = request.getParameter("orderTempId");

        if (orderTempId == null || orderTempId.isEmpty()) {
            out.print("{\"success\":false,\"message\":\"Missing orderTempId\"}");
            return;
        }

        // Check status với auto-success sau 10 giây (demo mode)
        PaymentTransaction transaction = paymentService.checkStatus(orderTempId, true);

        if (transaction == null) {
            out.print("{\"success\":false,\"status\":\"NOT_FOUND\",\"message\":\"Không tìm thấy giao dịch\"}");
            return;
        }

        String jsonResponse = String.format(
                "{\"success\":true,\"status\":\"%s\",\"orderTempId\":\"%s\",\"message\":\"%s\"}",
                transaction.getStatus(),
                transaction.getOrderTempId(),
                getStatusMessage(transaction.getStatus()));

        out.print(jsonResponse);
    }

    private String getStatusMessage(String status) {
        return switch (status) {
            case "PENDING" -> "Đang chờ thanh toán";
            case "SUCCESS" -> "Thanh toán thành công";
            case "EXPIRED" -> "Giao dịch đã hết hạn";
            default -> "Trạng thái không xác định";
        };
    }
}

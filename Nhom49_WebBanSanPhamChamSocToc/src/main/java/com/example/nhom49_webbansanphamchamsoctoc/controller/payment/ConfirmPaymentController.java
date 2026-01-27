package com.example.nhom49_webbansanphamchamsoctoc.controller.payment;

import com.example.nhom49_webbansanphamchamsoctoc.services.PaymentService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "ConfirmPaymentController", urlPatterns = {"/payment/confirm"})
public class ConfirmPaymentController extends HttpServlet {

    private PaymentService paymentService;

    @Override
    public void init() throws ServletException {
        paymentService = new PaymentService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String orderTempId = request.getParameter("orderTempId");

        if (orderTempId == null || orderTempId.isEmpty()) {
            out.print("{\"success\":false,\"message\":\"Missing orderTempId\"}");
            return;
        }

        boolean success = paymentService.confirmPayment(orderTempId);

        if (success) {
            out.print("{\"success\":true,\"message\":\"Đã xác nhận thanh toán\"}");
        } else {
            out.print("{\"success\":false,\"message\":\"Không thể xác nhận thanh toán\"}");
        }
    }
}

package com.example.nhom49_webbansanphamchamsoctoc.controller.payment;

import com.example.nhom49_webbansanphamchamsoctoc.model.PaymentTransaction;
import com.example.nhom49_webbansanphamchamsoctoc.services.PaymentService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Controller hiển thị trang thanh toán QR
 * URL: /payment/qr
 */
@WebServlet(name = "QRPaymentController", urlPatterns = { "/payment/qr" })
public class QRPaymentController extends HttpServlet {

    private PaymentService paymentService;

    @Override
    public void init() throws ServletException {
        paymentService = new PaymentService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // Lấy orderTempId từ session
        String orderTempId = (String) session.getAttribute("orderTempId");

        if (orderTempId == null || orderTempId.isEmpty()) {
            // Không có transaction pending, redirect về trang chủ
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        // Lấy thông tin transaction từ database
        PaymentTransaction transaction = paymentService.getTransaction(orderTempId);

        if (transaction == null) {
            // Transaction không tồn tại
            session.removeAttribute("orderTempId");
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        // Kiểm tra nếu transaction đã hết hạn
        if (transaction.isExpired()) {
            session.removeAttribute("orderTempId");
            request.setAttribute("errorMessage", "Giao dịch đã hết hạn. Vui lòng thử lại.");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        // Kiểm tra nếu transaction đã thanh toán thành công
        if (transaction.isSuccess()) {
            session.removeAttribute("orderTempId");
            response.sendRedirect(request.getContextPath() + "/checkout/success?orderId=" + orderTempId);
            return;
        }

        // Set attributes cho JSP
        request.setAttribute("transaction", transaction);
        request.setAttribute("autoSuccessTime", PaymentService.AUTO_SUCCESS_MS / 1000); // seconds

        // Forward đến trang QR payment
        request.getRequestDispatcher("/user/payment/qr-payment.jsp").forward(request, response);
    }
}

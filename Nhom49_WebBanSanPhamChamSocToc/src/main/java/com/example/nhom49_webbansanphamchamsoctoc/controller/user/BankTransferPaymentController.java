package com.example.nhom49_webbansanphamchamsoctoc.controller.user;

import com.example.nhom49_webbansanphamchamsoctoc.model.Order;
import com.example.nhom49_webbansanphamchamsoctoc.model.PaymentTransaction;
import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import com.example.nhom49_webbansanphamchamsoctoc.services.BankTransferService;
import com.example.nhom49_webbansanphamchamsoctoc.services.OrderService;
import com.example.nhom49_webbansanphamchamsoctoc.util.SessionUtil;
import com.example.nhom49_webbansanphamchamsoctoc.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "BankTransferPaymentController",
        urlPatterns = {"/payment/bank-transfer", "/payment/bank-transfer/mock-confirm"})
public class BankTransferPaymentController extends HttpServlet {
    private BankTransferService bankTransferService;
    private OrderService orderService;

    @Override
    public void init() throws ServletException {
        bankTransferService = new BankTransferService();
        orderService = new OrderService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = SessionUtil.getCurrentUser(session);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login?redirect=/payment/bank-transfer");
            return;
        }

        if ("/payment/bank-transfer/mock-confirm".equals(request.getServletPath())) {
            response.sendRedirect(request.getContextPath() + "/payment/bank-transfer");
            return;
        }

        PaymentTransaction transaction = resolveTransactionForUser(request, user);
        if (transaction == null) {
            SessionUtil.setErrorMessage(session,
                    bankTransferService.getLastError() != null
                            ? bankTransferService.getLastError()
                            : "Không tìm thấy giao dịch chuyển khoản.");
            response.sendRedirect(request.getContextPath() + "/profile/orders");
            return;
        }

        String successMessage = SessionUtil.getAndClearSuccessMessage(session);
        String errorMessage = SessionUtil.getAndClearErrorMessage(session);

        if ("PENDING".equalsIgnoreCase(transaction.getStatus()) &&
                (transaction.getQrCodeUrl() == null || transaction.getQrCodeUrl().isBlank())) {
            if (!bankTransferService.ensureQrForTransaction(transaction) &&
                    (errorMessage == null || errorMessage.isBlank())) {
                errorMessage = bankTransferService.getLastError();
            }
        }

        Order order = null;
        if (transaction.getOrderId() != null) {
            order = orderService.getOrderById(transaction.getOrderId());
            if (order == null || !order.getUserId().equals(user.getUserId())) {
                SessionUtil.setErrorMessage(session, "Không tìm thấy đơn hàng liên kết với giao dịch.");
                response.sendRedirect(request.getContextPath() + "/profile/orders");
                return;
            }
        }

        request.setAttribute("paymentTransaction", transaction);
        request.setAttribute("order", order);
        request.setAttribute("success", successMessage);
        request.setAttribute("error", errorMessage);
        request.getRequestDispatcher("/user/payment/bank-transfer.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = SessionUtil.getCurrentUser(session);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login?redirect=/payment/bank-transfer");
            return;
        }

        if (!"/payment/bank-transfer/mock-confirm".equals(request.getServletPath())) {
            response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            return;
        }

        Integer transactionId = ValidationUtil.parseIntSafe(request.getParameter("transactionId"));
        if (transactionId == null) {
            SessionUtil.setErrorMessage(session, "Thiếu mã giao dịch thanh toán.");
            response.sendRedirect(request.getContextPath() + "/payment/bank-transfer");
            return;
        }

        boolean confirmed = bankTransferService.mockConfirmByUser(transactionId, user.getUserId());
        if (confirmed) {
            SessionUtil.setSuccessMessage(session, "Đã xác nhận thanh toán demo thành công.");
        } else {
            SessionUtil.setErrorMessage(session,
                    bankTransferService.getLastError() != null
                            ? bankTransferService.getLastError()
                            : "Không thể xác nhận giao dịch.");
        }

        response.sendRedirect(request.getContextPath() + "/payment/bank-transfer?transactionId=" + transactionId);
    }

    private PaymentTransaction resolveTransactionForUser(HttpServletRequest request, User user) {
        Integer transactionId = ValidationUtil.parseIntSafe(request.getParameter("transactionId"));
        if (transactionId != null) {
            return bankTransferService.getTransactionForUser(transactionId, user.getUserId());
        }

        Integer orderId = ValidationUtil.parseIntSafe(request.getParameter("orderId"));
        if (orderId == null) {
            return null;
        }

        Order order = orderService.getOrderById(orderId);
        if (order == null || !order.getUserId().equals(user.getUserId())) {
            return null;
        }

        PaymentTransaction transaction = bankTransferService.getLatestTransactionByOrder(orderId);
        if (transaction == null &&
                "bank_transfer".equalsIgnoreCase(order.getPaymentMethod()) &&
                "pending".equalsIgnoreCase(order.getOrderStatus()) &&
                !bankTransferService.hasSuccessfulPayment(orderId)) {
            return bankTransferService.createTransactionForOrder(order, user.getUserId());
        }

        return transaction;
    }
}

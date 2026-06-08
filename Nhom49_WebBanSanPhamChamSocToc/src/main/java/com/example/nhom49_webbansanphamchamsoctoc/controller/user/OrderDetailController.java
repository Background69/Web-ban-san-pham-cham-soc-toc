package com.example.nhom49_webbansanphamchamsoctoc.controller.user;

import com.example.nhom49_webbansanphamchamsoctoc.model.Order;
import com.example.nhom49_webbansanphamchamsoctoc.model.PaymentTransaction;
import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import com.example.nhom49_webbansanphamchamsoctoc.services.BankTransferService;
import com.example.nhom49_webbansanphamchamsoctoc.services.OrderService;
import com.example.nhom49_webbansanphamchamsoctoc.util.SessionUtil;
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
    private BankTransferService bankTransferService;

    @Override
    public void init() throws ServletException {
        orderService = new OrderService();
        bankTransferService = new BankTransferService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendRedirect(request.getContextPath() + "/profile/orders");
            return;
        }

        HttpSession session = request.getSession(false);
        User user = SessionUtil.getCurrentUser(session);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login?redirect=/profile/orders");
            return;
        }

        try {
            int orderId = Integer.parseInt(pathInfo.substring(1));
            Order order = orderService.getOrderById(orderId);

            if (order == null || !order.getUserId().equals(user.getUserId())) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Đơn hàng không tồn tại");
                return;
            }

            PaymentTransaction paymentTransaction = null;
            if ("bank_transfer".equalsIgnoreCase(order.getPaymentMethod())) {
                paymentTransaction = bankTransferService.getLatestTransactionByOrder(orderId);
            }

            request.setAttribute("paymentTransaction", paymentTransaction);
            request.setAttribute("canCancelOrder", canCancelOrder(order, paymentTransaction));
            request.setAttribute("success", SessionUtil.getAndClearSuccessMessage(session));
            request.setAttribute("error", SessionUtil.getAndClearErrorMessage(session));
            request.setAttribute("order", order);
            request.getRequestDispatcher("/user/order/order-detail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/profile/orders");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        if (pathInfo != null && pathInfo.endsWith("/cancel")) {
            cancelOrder(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/profile/orders");
        }
    }

    private void cancelOrder(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String pathInfo = request.getPathInfo();
        HttpSession session = request.getSession(false);
        User user = SessionUtil.getCurrentUser(session);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login?redirect=/profile/orders");
            return;
        }

        try {
            String orderIdStr = pathInfo.replace("/cancel", "").substring(1);
            int orderId = Integer.parseInt(orderIdStr);

            // Lấy lý do hủy đơn từ Modal
            String cancelReason = request.getParameter("cancelReason");
            if (cancelReason != null) {
                cancelReason = cancelReason.trim();
                if (cancelReason.isEmpty()) {
                    cancelReason = null;
                }
            }

            Order order = orderService.getOrderById(orderId);

            if (order != null && order.getUserId().equals(user.getUserId())) {
                PaymentTransaction paymentTransaction = null;
                if ("bank_transfer".equalsIgnoreCase(order.getPaymentMethod())) {
                    paymentTransaction = bankTransferService.getLatestTransactionByOrder(orderId);
                }

                if (!canCancelOrder(order, paymentTransaction)) {
                    SessionUtil.setErrorMessage(session, "Đơn hàng này không thể hủy ở trạng thái hiện tại.");
                    response.sendRedirect(request.getContextPath() + "/orders/" + orderId);
                    return;
                }

                if (orderService.cancelOrder(orderId, cancelReason)) {
                    if ("bank_transfer".equalsIgnoreCase(order.getPaymentMethod())) {
                        bankTransferService.expirePendingByOrderId(orderId);
                    }
                    SessionUtil.setSuccessMessage(session, "Đã hủy đơn hàng thành công.");
                } else {
                    SessionUtil.setErrorMessage(session,
                            orderService.getLastError() != null ? orderService.getLastError() : "Không thể hủy đơn hàng.");
                }
            }

            response.sendRedirect(request.getContextPath() + "/orders/" + orderId);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/profile/orders");
        }
    }

    private boolean canCancelOrder(Order order, PaymentTransaction paymentTransaction) {
        if (order == null ||
                (!"pending".equalsIgnoreCase(order.getOrderStatus())
                 && !"pending_payment".equalsIgnoreCase(order.getOrderStatus()))) {
            return false;
        }

        if ("bank_transfer".equalsIgnoreCase(order.getPaymentMethod())
                && paymentTransaction != null
                && "SUCCESS".equalsIgnoreCase(paymentTransaction.getStatus())) {
            return false;
        }

        return true;
    }
}

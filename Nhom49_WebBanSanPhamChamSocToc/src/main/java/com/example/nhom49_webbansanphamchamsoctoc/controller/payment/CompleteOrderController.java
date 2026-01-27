package com.example.nhom49_webbansanphamchamsoctoc.controller.payment;

import com.example.nhom49_webbansanphamchamsoctoc.model.*;
import com.example.nhom49_webbansanphamchamsoctoc.services.*;
import com.example.nhom49_webbansanphamchamsoctoc.util.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "CompleteOrderController", urlPatterns = {"/payment/complete"})
public class CompleteOrderController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(CompleteOrderController.class.getName());
    private PaymentService paymentService;
    private OrderService orderService;
    private CartService cartService;

    @Override
    public void init() throws ServletException {
        paymentService = new PaymentService();
        orderService = new OrderService();
        cartService = new CartService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        User user = SessionUtil.getCurrentUser(session);

        if (user == null) {
            out.print("{\"success\":false,\"message\":\"Vui lòng đăng nhập\"}");
            return;
        }

        String orderTempId = request.getParameter("orderTempId");
        if (orderTempId == null) {
            orderTempId = (String) session.getAttribute("orderTempId");
        }

        if (orderTempId == null) {
            out.print("{\"success\":false,\"message\":\"Không tìm thấy giao dịch\"}");
            return;
        }

        // Verify payment is SUCCESS
        if (!paymentService.canCompleteOrder(orderTempId)) {
            out.print("{\"success\":false,\"message\":\"Thanh toán chưa được xác nhận\"}");
            return;
        }

        // Get order data from session
        @SuppressWarnings("unchecked")
        Map<String, Object> orderData = (Map<String, Object>) session.getAttribute("orderData");

        if (orderData == null) {
            out.print("{\"success\":false,\"message\":\"Dữ liệu đơn hàng không hợp lệ\"}");
            return;
        }

        try {
            // Get data từ session
            ShippingAddress address = (ShippingAddress) orderData.get("address");
            String shippingMethod = (String) orderData.get("shippingMethod");
            String paymentMethod = (String) orderData.get("paymentMethod");
            Cart cart = cartService.getCart(session);

            if (cart.isEmpty()) {
                out.print("{\"success\":false,\"message\":\"Giỏ hàng trống\"}");
                return;
            }

            // Tạo order
            Order order = orderService.createOrder(
                user.getUserId(),
                cart.toVariantQuantityMap(),
                address,
                shippingMethod != null ? shippingMethod : "standard",
                paymentMethod != null ? paymentMethod : "bank_transfer"
            );

            if (order != null) {
                // Clear cart
                cartService.clearCart(session);
                cartService.clearCartInDatabase(user.getUserId());

                // Clear session data
                session.removeAttribute("orderTempId");
                session.removeAttribute("orderData");

                out.printf("{\"success\":true,\"orderId\":%d,\"message\":\"Đặt hàng thành công!\"}", order.getOrderId());
            } else {
                out.print("{\"success\":false,\"message\":\"Đặt hàng thất bại. Vui lòng thử lại.\"}");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error completing order", e);
            out.print("{\"success\":false,\"message\":\"Có lỗi xảy ra: " + e.getMessage() + "\"}");
        }
    }
}

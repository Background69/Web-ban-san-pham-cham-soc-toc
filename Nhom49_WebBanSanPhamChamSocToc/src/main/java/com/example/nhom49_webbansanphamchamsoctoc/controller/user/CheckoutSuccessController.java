package com.example.nhom49_webbansanphamchamsoctoc.controller.user;

import com.example.nhom49_webbansanphamchamsoctoc.model.*;
import com.example.nhom49_webbansanphamchamsoctoc.services.CartService;
import com.example.nhom49_webbansanphamchamsoctoc.services.OrderService;
import com.example.nhom49_webbansanphamchamsoctoc.services.PaymentService;
import com.example.nhom49_webbansanphamchamsoctoc.util.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Map;

/**
 * Controller xử lý sau khi thanh toán QR thành công
 * Tạo đơn hàng thực tế và hiển thị trang thành công
 */
@WebServlet(name = "CheckoutSuccessController", urlPatterns = { "/checkout/success" })
public class CheckoutSuccessController extends HttpServlet {

    private OrderService orderService;
    private CartService cartService;
    private PaymentService paymentService;

    @Override
    public void init() throws ServletException {
        orderService = new OrderService();
        cartService = new CartService();
        paymentService = new PaymentService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = SessionUtil.getCurrentUser(session);

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        String orderTempId = request.getParameter("orderTempId");

        // Fallback từ session nếu không có parameter
        if (orderTempId == null || orderTempId.isEmpty()) {
            orderTempId = (String) session.getAttribute("orderTempId");
        }

        if (orderTempId == null || orderTempId.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        // Kiểm tra transaction có thành công không
        PaymentTransaction transaction = paymentService.getTransaction(orderTempId);

        if (transaction == null || !transaction.isSuccess()) {
            // Transaction chưa success, redirect về trang QR
            response.sendRedirect(request.getContextPath() + "/payment/qr");
            return;
        }

        // Lấy order data đã lưu trong session
        @SuppressWarnings("unchecked")
        Map<String, Object> orderData = (Map<String, Object>) session.getAttribute("orderData");

        Order order = null;

        if (orderData != null) {
            ShippingAddress address = (ShippingAddress) orderData.get("address");
            String shippingMethod = (String) orderData.get("shippingMethod");
            String paymentMethod = (String) orderData.get("paymentMethod");

            // Lấy cart từ session
            Cart cart = cartService.getCart(session);

            if (!cart.isEmpty() && address != null) {
                // Tạo order thực tế
                order = orderService.createOrder(
                        user.getUserId(),
                        cart.toVariantQuantityMap(),
                        address,
                        shippingMethod != null ? shippingMethod : "standard",
                        paymentMethod != null ? paymentMethod : "bank_transfer");

                if (order != null) {
                    // Clear cart sau khi tạo order thành công
                    cartService.clearCart(session);
                    cartService.clearCartInDatabase(user.getUserId());
                }
            }
        }

        // Xóa session attributes
        session.removeAttribute("orderTempId");
        session.removeAttribute("orderData");

        // Set attributes cho JSP
        request.setAttribute("transaction", transaction);
        request.setAttribute("order", order);
        request.setAttribute("orderTempId", orderTempId);

        // Forward đến trang success
        request.getRequestDispatcher("/user/cart/checkout-success.jsp").forward(request, response);
    }
}

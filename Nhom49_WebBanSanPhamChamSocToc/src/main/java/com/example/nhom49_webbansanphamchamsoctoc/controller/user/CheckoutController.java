package com.example.nhom49_webbansanphamchamsoctoc.controller.user;

import com.example.nhom49_webbansanphamchamsoctoc.model.Cart;
import com.example.nhom49_webbansanphamchamsoctoc.model.CartItem;
import com.example.nhom49_webbansanphamchamsoctoc.model.Order;
import com.example.nhom49_webbansanphamchamsoctoc.model.PaymentTransaction;
import com.example.nhom49_webbansanphamchamsoctoc.model.ShippingAddress;
import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import com.example.nhom49_webbansanphamchamsoctoc.services.BankTransferService;
import com.example.nhom49_webbansanphamchamsoctoc.services.CartService;
import com.example.nhom49_webbansanphamchamsoctoc.services.OrderService;
import com.example.nhom49_webbansanphamchamsoctoc.services.ShippingService;
import com.example.nhom49_webbansanphamchamsoctoc.util.SessionUtil;
import com.example.nhom49_webbansanphamchamsoctoc.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "CheckoutController", value = "/checkout")
public class CheckoutController extends HttpServlet {
    private OrderService orderService;
    private ShippingService shippingService;
    private CartService cartService;
    private BankTransferService bankTransferService;

    @Override
    public void init() throws ServletException {
        orderService = new OrderService();
        shippingService = new ShippingService();
        cartService = new CartService();
        bankTransferService = new BankTransferService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = SessionUtil.getCurrentUser(session);

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login?redirect=/checkout");
            return;
        }

        Cart cart = cartService.getCart(session);

        if (cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        List<CartService.StockValidationResult> stockErrors = cartService.validateStock(cart);
        if (!stockErrors.isEmpty()) {
            String errorMessage = cartService.buildStockErrorMessage(stockErrors);
            SessionUtil.setErrorMessage(session, errorMessage);
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        request.setAttribute("addresses", shippingService.getAddressesByUser(user.getUserId()));
        request.setAttribute("defaultAddress", shippingService.getDefaultAddress(user.getUserId()));
        List<CartItem> cartItems = cartService.getCartItems(session);
        request.setAttribute("cartItems", cartItems);
        request.setAttribute("subtotal", cartService.calculateSubtotal(cartItems));

        request.getRequestDispatcher("/user/cart/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        User user = SessionUtil.getCurrentUser(session);

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login?redirect=/checkout");
            return;
        }

        Cart cart = cartService.getCart(session);

        if (cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        List<CartService.StockValidationResult> stockErrors = cartService.validateStock(cart);
        if (!stockErrors.isEmpty()) {
            String errorMessage = cartService.buildStockErrorMessage(stockErrors);
            request.setAttribute("error", errorMessage);
            doGet(request, response);
            return;
        }

        String addressIdParam = request.getParameter("addressId");
        String shippingMethod = request.getParameter("shippingMethod");
        String paymentMethod = request.getParameter("paymentMethod");

        if (!isValidPaymentMethod(paymentMethod)) {
            request.setAttribute("error", "Phương thức thanh toán không hợp lệ.");
            doGet(request, response);
            return;
        }

        ShippingAddress address = null;

        Integer addressId = ValidationUtil.parseIntSafe(addressIdParam);
        if (addressId != null) {
            address = shippingService.getAddressById(addressId);
        }

        if (address == null) {
            address = createAddressFromForm(request, user.getUserId());
            if (address == null) {
                request.setAttribute("error", shippingService.getLastError());
                doGet(request, response);
                return;
            }
        }

        Map<Integer, Integer> cartMap = cart.toVariantQuantityMap();

        String initialStatus;
        if ("cod".equalsIgnoreCase(paymentMethod)) {
            initialStatus = "pending";           // COD: chờ xác nhận
        } else {
            initialStatus = "pending_payment";   // bank_transfer & VNPAY: chờ thanh toán
        }

        Order order = orderService.createOrder(
                user.getUserId(),
                cartMap,
                address,
                shippingMethod != null ? shippingMethod : "standard",
                paymentMethod,
                initialStatus
        );

        if (order != null) {
            cartService.clearCart(session);
            cartService.clearCartInDatabase(user.getUserId());

            if ("bank_transfer".equalsIgnoreCase(order.getPaymentMethod())) {
                PaymentTransaction transaction = bankTransferService.createTransactionForOrder(order, user.getUserId());
                if (transaction == null) {
                    SessionUtil.setErrorMessage(session,
                            bankTransferService.getLastError() != null
                                    ? bankTransferService.getLastError()
                                    : "Không thể tạo giao dịch chuyển khoản. Vui lòng thử lại.");
                    response.sendRedirect(request.getContextPath() + "/orders/" + order.getOrderId());
                    return;
                }

                if (bankTransferService.getLastError() != null) {
                    SessionUtil.setErrorMessage(session, bankTransferService.getLastError());
                }
                response.sendRedirect(request.getContextPath() + "/payment/bank-transfer?transactionId="
                        + transaction.getTransactionId());
                return;
            }

            if ("VNPAY".equalsIgnoreCase(order.getPaymentMethod())) {
                String vnpayRedirect = request.getContextPath() + "/vnpay/create-payment"
                        + "?orderId=" + order.getOrderId();
                response.sendRedirect(vnpayRedirect);
                return;
            }

            // COD: set success message rồi redirect đến order detail
            SessionUtil.setSuccessMessage(session,
                    "Đặt hàng thành công! Mã đơn hàng: " + order.getOrderCode()
                    + ". Bạn sẽ thanh toán khi nhận hàng.");
            response.sendRedirect(request.getContextPath() + "/orders/" + order.getOrderId());
        } else {
            request.setAttribute("error", orderService.getLastError() != null ?
                    orderService.getLastError() : "Đặt hàng thất bại. Vui lòng thử lại.");
            doGet(request, response);
        }
    }

    private ShippingAddress createAddressFromForm(HttpServletRequest request, int userId) {
        return shippingService.createAddress(
                userId,
                request.getParameter("fullName"),
                request.getParameter("phone"),
                request.getParameter("provinceCode"),
                request.getParameter("provinceName"),
                request.getParameter("districtCode"),
                request.getParameter("districtName"),
                request.getParameter("wardCode"),
                request.getParameter("wardName"),
                request.getParameter("specificAddress"),
                request.getParameter("note")
        );
    }

    private boolean isValidPaymentMethod(String method) {
        return method != null
                && ("cod".equalsIgnoreCase(method)
                || "bank_transfer".equalsIgnoreCase(method)
                || "VNPAY".equalsIgnoreCase(method));
    }
}

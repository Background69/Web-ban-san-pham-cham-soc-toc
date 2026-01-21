package com.example.nhom49_webbansanphamchamsoctoc.controller.user;

import com.example.nhom49_webbansanphamchamsoctoc.model.Cart;
import com.example.nhom49_webbansanphamchamsoctoc.model.CartItem;
import com.example.nhom49_webbansanphamchamsoctoc.model.Order;
import com.example.nhom49_webbansanphamchamsoctoc.model.ShippingAddress;
import com.example.nhom49_webbansanphamchamsoctoc.model.User;
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

    @Override
    public void init() throws ServletException {
        orderService = new OrderService();
        shippingService = new ShippingService();
        cartService = new CartService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = SessionUtil.getCurrentUser(session);

        // Lấy Cart object từ session
        Cart cart = cartService.getCart(session);

        if (cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        // Validate stock trước khi hiển thị trang checkout
        List<CartService.StockValidationResult> stockErrors = cartService.validateStock(cart);
        if (!stockErrors.isEmpty()) {
            // Có sản phẩm vượt tồn kho, redirect về cart với thông báo lỗi
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

        request.getRequestDispatcher("user/cart/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        User user = SessionUtil.getCurrentUser(session);

        // Lấy Cart object từ session
        Cart cart = cartService.getCart(session);

        if (cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        // Validate stock trước khi tạo đơn hàng
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

        ShippingAddress address = null;

        // Sử dụng địa chỉ có sẵn hoặc tạo mới
        Integer addressId = ValidationUtil.parseIntSafe(addressIdParam);
        if (addressId != null) {
            address = shippingService.getAddressById(addressId);
        }

        // Nếu không có địa chỉ có sẵn, tạo địa chỉ mới từ form
        if (address == null) {
            address = createAddressFromForm(request, user.getUserId());
            if (address == null) {
                request.setAttribute("error", shippingService.getLastError());
                doGet(request, response);
                return;
            }
        }

        Map<Integer, Integer> cartMap = cart.toVariantQuantityMap();

        // Tạo order
        Order order = orderService.createOrder(
                user.getUserId(),
                cartMap,
                address,
                shippingMethod != null ? shippingMethod : "standard",
                paymentMethod != null ? paymentMethod : "cod"
        );

        if (order != null) {
            // Xóa giỏ hàng sau khi đặt hàng thành công
            cartService.clearCart(session);
            cartService.clearCartInDatabase(user.getUserId());

            response.sendRedirect(request.getContextPath() + "/orders/" + order.getOrderId());
        } else {
            request.setAttribute("error", orderService.getLastError() != null ?
                    orderService.getLastError() : "Đặt hàng thất bại. Vui lòng thử lại.");
            doGet(request, response);
        }
    }

    /**
     * Tạo address cho form.
     */
    private ShippingAddress createAddressFromForm(HttpServletRequest request, int userId) {
        return shippingService.createAddress(
                userId,
                request.getParameter("fullName"),
                request.getParameter("phone"),
                request.getParameter("email"),
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
}
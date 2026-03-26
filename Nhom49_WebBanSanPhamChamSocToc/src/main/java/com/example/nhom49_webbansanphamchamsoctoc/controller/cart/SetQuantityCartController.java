package com.example.nhom49_webbansanphamchamsoctoc.controller.cart;

import com.example.nhom49_webbansanphamchamsoctoc.services.CartService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "SetQuantityCartController", urlPatterns = {"/cart/set-quantity", "/cart/update"})
public class SetQuantityCartController extends HttpServlet {

    private CartService cartService;

    @Override
    public void init() throws ServletException {
        cartService = new CartService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(true);

        int variantId = parsePositiveInt(request.getParameter("variantId"), 0);
        if (variantId <= 0) {
            variantId = parsePositiveInt(request.getParameter("itemKey"), 0);
        }
        int quantity = parseInt(request.getParameter("quantity"), -1);

        boolean success = false;
        String message = null;
        String successMessage = null;
        if (variantId > 0 && quantity >= 0) {
            if (quantity == 0) {
                success = cartService.removeFromCart(session, variantId);
                successMessage = "Đã xóa khỏi giỏ hàng.";
                if (!success) {
                    message = "Không thể xóa sản phẩm khỏi giỏ hàng.";
                }
            } else {
                success = cartService.updateQuantity(session, variantId, quantity);
                successMessage = "Cập nhật số lượng sản phẩm.";
                if (!success) {
                    message = "Không thể cập nhật số lượng sản phẩm.";
                }
            }
        } else {
            message = "Thông tin không hợp lệ.";
        }

        if (success) {
            session.setAttribute("success", successMessage != null ? successMessage : "Cập nhật thành công giỏ hàng.");
        } else {
            session.setAttribute("error", message != null ? message : "Không thể cập nhật giỏ hàng.");
        }

        response.sendRedirect(request.getContextPath() + "/cart");
    }

    private int parsePositiveInt(String value, int fallback) {
        if (value == null || value.isEmpty()) {
            return fallback;
        }
        try {
            int parsed = Integer.parseInt(value);
            return parsed > 0 ? parsed : fallback;
        } catch (NumberFormatException e) {
            return fallback;
        }
    }

    private int parseInt(String value, int fallback) {
        if (value == null || value.isEmpty()) {
            return fallback;
        }
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return fallback;
        }
    }
}

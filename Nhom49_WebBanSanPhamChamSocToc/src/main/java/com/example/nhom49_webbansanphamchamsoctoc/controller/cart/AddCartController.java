package com.example.nhom49_webbansanphamchamsoctoc.controller.cart;

import com.example.nhom49_webbansanphamchamsoctoc.dao.ProductVariantDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.ProductVariant;
import com.example.nhom49_webbansanphamchamsoctoc.services.CartService;
import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "AddCartController", urlPatterns = {"/cart/add"})
public class AddCartController extends HttpServlet{
    private CartService cartService;
    private ProductVariantDAO variantDAO;

    @Override
    public void init() throws ServletException {
        cartService = new CartService();
        variantDAO = new ProductVariantDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(true);

        int quantity = parsePositiveInt(request.getParameter("quantity"), 1);
        int variantId = parsePositiveInt(request.getParameter("variantId"), 0);

        if (variantId <= 0) {
            int productId = parsePositiveInt(request.getParameter("productId"), 0);
            if (productId > 0) {
                ProductVariant variant = variantDAO.findDefaultByProductId(productId);
                if (variant != null) {
                    variantId = variant.getVariantId();
                }
            }
        }

        boolean success = false;
        String message = null;
        if (variantId > 0) {
            success = cartService.addToCart(session, variantId, quantity);
            if (!success) {
                message = "Không thể thêm sản phẩm vào giỏ.";
            }
        } else {
            message = "Sản phẩm không hợp lệ.";
        }

        if (success) {
            session.setAttribute("success", "Đã thêm sản phẩm vào giỏ.");
        } else {
            session.setAttribute("error", message != null ? message : "Không thể thêm sản phẩm vào giỏ.");
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
}

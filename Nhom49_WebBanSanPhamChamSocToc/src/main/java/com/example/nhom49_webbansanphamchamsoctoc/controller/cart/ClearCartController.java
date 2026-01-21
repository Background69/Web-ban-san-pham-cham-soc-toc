package com.example.nhom49_webbansanphamchamsoctoc.controller.cart;

import com.example.nhom49_webbansanphamchamsoctoc.services.CartService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "ClearCartController", urlPatterns = {"/cart/clear"})
public class ClearCartController extends HttpServlet {

    private CartService cartService;

    @Override
    public void init() throws ServletException {
        cartService = new CartService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(true);

        cartService.clearCart(session);
        session.setAttribute("success", "Đã xóa toàn bộ giỏ hàng.");

        response.sendRedirect(request.getContextPath() + "/cart");
    }
}

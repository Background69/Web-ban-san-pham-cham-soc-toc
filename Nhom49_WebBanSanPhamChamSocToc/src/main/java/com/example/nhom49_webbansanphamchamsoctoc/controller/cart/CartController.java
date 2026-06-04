package com.example.nhom49_webbansanphamchamsoctoc.controller.cart;

import com.example.nhom49_webbansanphamchamsoctoc.model.CartItem;
import com.example.nhom49_webbansanphamchamsoctoc.model.Product;
import com.example.nhom49_webbansanphamchamsoctoc.services.CartService;
import com.example.nhom49_webbansanphamchamsoctoc.services.ProductService;
import com.example.nhom49_webbansanphamchamsoctoc.util.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet(name = "CartController", urlPatterns = {"/cart"})
public class CartController extends HttpServlet {

    private CartService cartService;
    private ProductService productService;

    @Override
    public void init() throws ServletException {
        cartService = new CartService();
        productService = new ProductService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(true);

        List<CartItem> cartItems = cartService.getCartItems(session);
        BigDecimal subtotal = cartService.calculateSubtotal(cartItems);
        int cartCount = cartService.getCartCount(session);

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("subtotal", subtotal);
        request.setAttribute("cartCount", cartCount);
        request.setAttribute("successMessage", SessionUtil.getAndClearSuccessMessage(session));
        request.setAttribute("errorMessage", SessionUtil.getAndClearErrorMessage(session));

        if (cartItems == null || cartItems.isEmpty() || cartCount == 0) {
            List<Product> topProducts = productService.getFeaturedProducts();
            if (topProducts != null && topProducts.size() > 4) {
                topProducts = topProducts.subList(0, 4);
            }
            request.setAttribute("topProducts", topProducts);
        }

        request.getRequestDispatcher("/user/cart/cart.jsp").forward(request, response);
    }
}

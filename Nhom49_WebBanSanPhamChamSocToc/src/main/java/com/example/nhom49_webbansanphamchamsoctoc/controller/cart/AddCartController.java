package com.example.nhom49_webbansanphamchamsoctoc.controller.cart;

import com.example.nhom49_webbansanphamchamsoctoc.dao.ProductVariantDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.ProductVariant;
import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import com.example.nhom49_webbansanphamchamsoctoc.services.CartService;
import com.example.nhom49_webbansanphamchamsoctoc.util.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet(name = "AddCartController", urlPatterns = { "/cart/add" })
public class AddCartController extends HttpServlet {
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
        HttpSession session = request.getSession(false);
        User currentUser = SessionUtil.getCurrentUser(session);

        // Kiểm tra AJAX
        boolean isAjax = "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));

        if (currentUser == null) {
            if (isAjax) {
                sendJsonResponse(response, false, "Vui lòng đăng nhập để thêm vào giỏ hàng", 0);
                return;
            }
            response.sendRedirect(buildLoginRedirect(request));
            return;
        }
        session = request.getSession(true);

        int quantity = parsePositiveInt(request.getParameter("quantity"), 1);
        int variantId = parsePositiveInt(request.getParameter("variantId"), 0);
        String action = request.getParameter("action");
        boolean buyNow = action != null && "buy_now".equalsIgnoreCase(action.trim());

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

        // Handle AJAX response
        if (isAjax) {
            int cartCount = cartService.getCartCount(session);
            if (success) {
                sendJsonResponse(response, true, "Đã thêm sản phẩm vào giỏ hàng", cartCount);
            } else {
                sendJsonResponse(response, false, message != null ? message : "Không thể thêm sản phẩm", cartCount);
            }
            return;
        }

        if (success) {
            SessionUtil.setSuccessMessage(session, "Đã thêm sản phẩm vào giỏ.");
        } else {
            SessionUtil.setErrorMessage(session,
                    message != null ? message : "Không thể thêm sản phẩm vào giỏ.");
        }

        if (success && buyNow) {
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        }
        response.sendRedirect(request.getContextPath() + "/cart");
    }

    private void sendJsonResponse(HttpServletResponse response, boolean success, String message, int cartCount)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        String json = String.format("{\"success\":%b,\"message\":\"%s\",\"cartCount\":%d}",
                success, escapeJson(message), cartCount);
        response.getWriter().write(json);
    }

    private String escapeJson(String text) {
        if (text == null)
            return "";
        return text.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
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

    private String buildLoginRedirect(HttpServletRequest request) {
        String contextPath = request.getContextPath();
        String redirectPath = buildRedirectPath(request, contextPath);
        if (redirectPath == null || redirectPath.isBlank()) {
            redirectPath = "/";
        }
        String encoded = URLEncoder.encode(redirectPath, StandardCharsets.UTF_8);
        return contextPath + "/auth/login?redirect=" + encoded;
    }

    private String buildRedirectPath(HttpServletRequest request, String contextPath) {
        String referer = request.getHeader("Referer");
        if (referer == null || referer.isBlank()) {
            return null;
        }
        String path;
        String query = null;
        try {
            URL url = new URL(referer);
            path = url.getPath();
            query = url.getQuery();
        } catch (MalformedURLException e) {
            if (!referer.startsWith("/")) {
                return null;
            }
            path = referer;
        }
        if (path == null || path.isBlank()) {
            return null;
        }
        if (contextPath != null && !contextPath.isEmpty() && path.startsWith(contextPath)) {
            path = path.substring(contextPath.length());
            if (path.isEmpty()) {
                path = "/";
            }
        }
        if (query != null && !query.isBlank()) {
            return path + "?" + query;
        }
        return path;
    }
}
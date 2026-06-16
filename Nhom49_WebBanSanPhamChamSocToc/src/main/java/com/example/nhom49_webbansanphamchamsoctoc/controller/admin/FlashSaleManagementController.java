package com.example.nhom49_webbansanphamchamsoctoc.controller.admin;

import com.example.nhom49_webbansanphamchamsoctoc.dao.ProductDAO;
import com.example.nhom49_webbansanphamchamsoctoc.dao.ProductVariantDAO;
import com.example.nhom49_webbansanphamchamsoctoc.dao.PromotionDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.Product;
import com.example.nhom49_webbansanphamchamsoctoc.model.ProductVariant;
import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import com.example.nhom49_webbansanphamchamsoctoc.services.ProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Controller quản lý Flash Sale - các sản phẩm có isOnSale = true
 */
@WebServlet(name = "FlashSaleManagementController", value = "/admin/flash-sale")
public class FlashSaleManagementController extends HttpServlet {
    private ProductDAO productDAO;
    private ProductVariantDAO productVariantDAO;
    private ProductService productService;
    private PromotionDAO promotionDAO;

    @Override
    public void init() {
        productDAO = new ProductDAO();
        productVariantDAO = new ProductVariantDAO();
        productService = new ProductService();
        promotionDAO = new PromotionDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        User currentUser = (User) session.getAttribute("currentUser");
        if (!"Admin".equalsIgnoreCase(currentUser.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Không có quyền truy cập");
            return;
        }

        // Lấy tất cả sản phẩm đang sale (isOnSale = true)
        List<Product> saleProducts = productDAO.findOnSale();

        // Lấy default variant, remaining stock và primary image cho mỗi product
        if (!saleProducts.isEmpty()) {
            List<Integer> productIds = saleProducts.stream()
                    .map(Product::getProductId)
                    .collect(Collectors.toList());

            Map<Integer, Integer> stockMap = productVariantDAO.getTotalStockByProductIds(productIds);

            // Load primary images
            com.example.nhom49_webbansanphamchamsoctoc.dao.ProductImgDAO productImgDAO = new com.example.nhom49_webbansanphamchamsoctoc.dao.ProductImgDAO();
            Map<Integer, String> imageMap = productImgDAO.getPrimaryImagesByProductIds(productIds);

            for (Product p : saleProducts) {
                ProductVariant defaultVariant = productVariantDAO.findDefaultByProductId(p.getProductId());
                p.setDefaultVariant(defaultVariant);
                p.setRemainingStock(stockMap.getOrDefault(p.getProductId(), 0));
                p.setPrimaryImageUrl(imageMap.get(p.getProductId()));
            }
        }

        // Lấy tất cả sản phẩm KHÔNG đang sale để thêm vào flash sale
        List<Product> allProducts = productService.getAllProducts();
        List<Product> nonSaleProducts = allProducts.stream()
                .filter(p -> !p.isOnSale())
                .collect(Collectors.toList());
        for (Product p:nonSaleProducts) {
            boolean conflict = promotionDAO.hasActivePromotion(p.getProductId());
            request.setAttribute("promotionConflict_" +p.getProductId(),conflict);
        }
        request.setAttribute("saleProducts", saleProducts);
        request.setAttribute("nonSaleProducts", nonSaleProducts);
        request.getRequestDispatcher("/admin/promotion/flash-sale.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if (action != null) {
            switch (action) {
                case "addToSale" -> addToSale(request);
                case "removeFromSale" -> removeFromSale(request);
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/flash-sale");
    }

    /**
     * Thêm sản phẩm vào Flash Sale (set isOnSale = true)
     */
    private void addToSale(HttpServletRequest request) {
        String[] productIds = request.getParameterValues("productIds");
        if (productIds != null) {
            for (String idStr : productIds) {
                try {
                    int productId = Integer.parseInt(idStr);
                    Product p = productDAO.findById(productId);
                    if (p != null) {
                        if(promotionDAO.hasActivePromotion(productId)){
                            continue;
                        }
                        p.setOnSale(true);
                        productDAO.update(p);
                    }
                } catch (NumberFormatException ignored) {
                }
            }
        }
    }

    /**
     * Xóa sản phẩm khỏi Flash Sale (set isOnSale = false)
     */
    private void removeFromSale(HttpServletRequest request) {
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            Product p = productDAO.findById(productId);
            if (p != null) {
                p.setOnSale(false);
                productDAO.update(p);
            }
        } catch (NumberFormatException ignored) {
        }
    }
}

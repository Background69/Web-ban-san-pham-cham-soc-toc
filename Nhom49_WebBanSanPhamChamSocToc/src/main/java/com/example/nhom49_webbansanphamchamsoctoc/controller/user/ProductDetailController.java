package com.example.nhom49_webbansanphamchamsoctoc.controller.user;

import com.example.nhom49_webbansanphamchamsoctoc.model.Product;
import com.example.nhom49_webbansanphamchamsoctoc.services.ProductService;
import com.example.nhom49_webbansanphamchamsoctoc.services.ReviewService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

@WebServlet(name = "ProductDetailController", value = "/product/*")
public class ProductDetailController extends HttpServlet {

    private ProductService productService;
    private ReviewService reviewService;

    @Override
    public void init() throws ServletException {
        productService = new ProductService();
        reviewService = new ReviewService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendRedirect(request.getContextPath() + "/products");
            return;
        }

        // Lấy slug từ URL: /product/{slug}
        String slug = pathInfo.substring(1);

        // Tìm product theo slug
        Product product = productService.getProductBySlug(slug);

        if (product == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Sản phẩm không tồn tại");
            return;
        }

        List<Product> candidates = new ArrayList<>(productService.getAllProducts());
        candidates.removeIf(item -> item.getProductId() == product.getProductId() || item.isOnSale());
        Collections.shuffle(candidates);
        List<Product> relatedProducts = candidates.size() > 4 ? candidates.subList(0, 4) : candidates;

        // Lấy reviews của sản phẩm
        request.setAttribute("product", product);
        request.setAttribute("reviews", reviewService.getReviewsByProduct(product.getProductId()));
        request.setAttribute("averageRating", reviewService.calculateAverageRating(product.getProductId()));
        request.setAttribute("reviewCount", reviewService.countReviewsByProduct(product.getProductId()));
        request.setAttribute("ratingStats", reviewService.getRatingStatistics(product.getProductId()));
        request.setAttribute("relatedProducts", relatedProducts);

        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            com.example.nhom49_webbansanphamchamsoctoc.model.User user = (com.example.nhom49_webbansanphamchamsoctoc.model.User) session
                    .getAttribute("user");
            String canReviewStatus = reviewService.canUserReviewProduct(user.getUserId(), product.getProductId());
            if (canReviewStatus == null) {
                canReviewStatus = "CAN_REVIEW";
            }
            request.setAttribute("canReviewStatus", canReviewStatus);
        }

        request.getRequestDispatcher("/user/product/product-detail.jsp").forward(request, response);
    }
}

package com.example.nhom49_webbansanphamchamsoctoc.controller.user;


import com.example.nhom49_webbansanphamchamsoctoc.model.Product;
import com.example.nhom49_webbansanphamchamsoctoc.services.ProductService;
import com.example.nhom49_webbansanphamchamsoctoc.services.ReviewService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet(name = "ProductDetailController", value = "/product-detail")
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

        // Lấy reviews của sản phẩm
        request.setAttribute("product", product);
        request.setAttribute("reviews", reviewService.getReviewsByProduct(product.getProductId()));
        request.setAttribute("averageRating", reviewService.calculateAverageRating(product.getProductId()));
        request.setAttribute("reviewCount", reviewService.countReviewsByProduct(product.getProductId()));
        request.setAttribute("ratingStats", reviewService.getRatingStatistics(product.getProductId()));

        request.getRequestDispatcher("/user/product_detail.jsp").forward(request, response);
    }
}

package com.example.nhom49_webbansanphamchamsoctoc.controller.user;

import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import com.example.nhom49_webbansanphamchamsoctoc.services.ProductService;
import com.example.nhom49_webbansanphamchamsoctoc.services.ReviewService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "ReviewController", urlPatterns = {"/review"})

public class ReviewController extends HttpServlet {

    private ReviewService reviewService;
    private ProductService productService;


    @Override
    public void init() throws ServletException {
        reviewService = new ReviewService();
        productService = new ProductService();
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String content = request.getParameter("content");

            // Validate rating (1-5)
            if (!reviewService.isValidRating(rating)) {
                session.setAttribute("reviewError", "Điểm đánh giá phải từ 1-5");
                redirectToProduct(request, response, productId);
                return;
            }

            // Validate content
            if (content == null || content.trim().isEmpty()) {
                session.setAttribute("reviewError", "Vui lòng nhập nội dung đánh giá");
                redirectToProduct(request, response, productId);
                return;
            }

            // Tạo review
            var review = reviewService.createReview(productId, user, rating, content.trim());

            if (review != null) {
                session.setAttribute("reviewSuccess", "Đánh giá của bạn đã được gửi thành công!");
            } else {
                session.setAttribute("reviewError", "Không thể gửi đánh giá. Vui lòng thử lại.");
            }

            redirectToProduct(request, response, productId);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/products");
        }
    }

    private void redirectToProduct(HttpServletRequest request, HttpServletResponse response, int productId)
            throws IOException {
        var product = productService.getProductById(productId);
        if (product != null) {
            response.sendRedirect(request.getContextPath() + "/product/" + product.getProductSlug() + "#reviews");
        } else {
            response.sendRedirect(request.getContextPath() + "/products");
        }
    }
}
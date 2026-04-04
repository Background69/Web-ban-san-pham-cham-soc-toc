package com.example.nhom49_webbansanphamchamsoctoc.services;

import com.example.nhom49_webbansanphamchamsoctoc.dao.OrderDAO;
import com.example.nhom49_webbansanphamchamsoctoc.dao.ReviewDAO;
import com.example.nhom49_webbansanphamchamsoctoc.dao.ProductDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.Review;
import com.example.nhom49_webbansanphamchamsoctoc.model.User;

import java.util.List;

public class ReviewService {

    private final ReviewDAO reviewDAO;
    private final ProductDAO productDAO;
    private final OrderDAO orderDAO;

    public ReviewService() {
        this.reviewDAO = new ReviewDAO();
        this.productDAO = new ProductDAO();
        this.orderDAO = new OrderDAO();
    }

    public List<Review> getReviewsByProduct(int productId) {
        return reviewDAO.findByProductId(productId);
    }

    public List<Review> getUserReviewsWithProduct(int userId) {
        return reviewDAO.findByUserIdWithProduct(userId);
    }

    public Review createReview(int productId, User user, int rating, String content) {
        // Validate input
        if (!isValidRating(rating) || user == null || content == null || content.trim().isEmpty()) {
            return null;
        }

        // Check if product exists
        if (productDAO.findById(productId) == null) {
            return null;
        }

        // Create review
        Review review = new Review();
        review.setProductId(productId);
        review.setUserId(user.getUserId());
        review.setReviewerName(user.getUsername());
        review.setRating(rating);
        review.setContent(content.trim());

        int reviewId = reviewDAO.insert(review);
        if (reviewId > 0) {
            review.setReviewId(reviewId);

            // Update product rating
            updateProductRating(productId);

            return review;
        }

        return null;
    }

    public boolean updateReview(int reviewId, int rating, String content) {
        if (!isValidRating(rating) || content == null || content.trim().isEmpty()) {
            return false;
        }

        Review review = reviewDAO.findById(reviewId);
        if (review == null) {
            return false;
        }

        review.setRating(rating);
        review.setContent(content.trim());

        boolean updated = reviewDAO.update(review);
        if (updated) {
            // Update product rating
            updateProductRating(review.getProductId());
        }

        return updated;
    }


    public boolean isValidRating(int rating) {
        return rating >= 1 && rating <= 5;
    }

    public double calculateAverageRating(int productId) {
        return reviewDAO.calculateAverageRating(productId);
    }

    public int countReviewsByProduct(int productId) {
        return reviewDAO.countByProductId(productId);
    }

    private void updateProductRating(int productId) {
        double avgRating = reviewDAO.calculateAverageRating(productId);
        int reviewCount = reviewDAO.countByProductId(productId);

        productDAO.updateRating(productId, avgRating, reviewCount);
    }

    public String canUserReviewProduct(int userId, int productId) {
        // Kiểm tra đã review chưa
        if (reviewDAO.existsByUserIdAndProductId(userId, productId)) {
            return "ALREADY_REVIEWED";
        }

        // Kiểm tra đã mua và nhận hàng thành công chưa
        if (orderDAO.hasUserPurchasedProduct(userId, productId)) {
            return null; // Có thể review
        }

        // Kiểm tra đã đặt hàng nhưng chưa nhận
        if (orderDAO.hasUserPurchasedProductPending(userId, productId)) {
            return "ORDER_NOT_COMPLETED";
        }

        // Chưa từng mua
        return "NOT_PURCHASED";
    }

    public java.util.Map<Integer, Integer> getRatingStatistics(int productId) {
        List<Review> reviews = reviewDAO.findByProductId(productId);
        int[] counts = new int[5]; // Index 0 = 1 star, Index 4 = 5 stars
        int totalReviews = reviews.size();

        for (Review review : reviews) {
            int rating = review.getRating();
            if (rating >= 1 && rating <= 5) {
                counts[rating - 1]++;
            }
        }

        // Tạo LinkedHashMap để giữ thứ tự từ 5 sao xuống 1 sao
        java.util.Map<Integer, Integer> stats = new java.util.LinkedHashMap<>();
        for (int i = 5; i >= 1; i--) {
            int percent = (totalReviews > 0) ? (counts[i - 1] * 100 / totalReviews) : 0;
            stats.put(i, percent);
        }

        return stats;
    }
}

package com.example.nhom49_webbansanphamchamsoctoc.services;

import com.example.nhom49_webbansanphamchamsoctoc.dao.ReviewDAO;
import com.example.nhom49_webbansanphamchamsoctoc.dao.ProductDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.Review;
import com.example.nhom49_webbansanphamchamsoctoc.model.User;

import java.util.List;

public class ReviewService {

    private final ReviewDAO reviewDAO;
    private final ProductDAO productDAO;


    public ReviewService() {
        this.reviewDAO = new ReviewDAO();
        this.productDAO = new ProductDAO();
    }


    /**
     * Lấy reviews by product.
     */
    public List<Review> getReviewsByProduct(int productId) {
        return reviewDAO.findByProductId(productId);
    }

    /**
     * Lấy reviews by user.
     */
    public List<Review> getReviewsByUser(int userId) {
        return reviewDAO.findByUserId(userId);
    }

    /**
     * Tạo review.
     */
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

    /**
     * Cập nhật review.
     */
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

    /**
     * Xóa review.
     */
    public boolean deleteReview(int reviewId) {
        Review review = reviewDAO.findById(reviewId);
        if (review == null) {
            return false;
        }

        boolean deleted = reviewDAO.delete(reviewId);
        if (deleted) {
            // Update product rating
            updateProductRating(review.getProductId());
        }

        return deleted;
    }

    /**
     * Kiểm tra valid rating.
     */
    public boolean isValidRating(int rating) {
        return rating >= 1 && rating <= 5;
    }

    /**
     * Thực hiện calculate average rating.
     */
    public double calculateAverageRating(int productId) {
        return reviewDAO.calculateAverageRating(productId);
    }

    /**
     * Dem reviews by product.
     */
    public int countReviewsByProduct(int productId) {
        return reviewDAO.countByProductId(productId);
    }

    /**
     * Cập nhật product rating.
     */
    private void updateProductRating(int productId) {
        double avgRating = reviewDAO.calculateAverageRating(productId);
        int reviewCount = reviewDAO.countByProductId(productId);

        productDAO.updateRating(productId, avgRating, reviewCount);
    }


    /**
     * Lấy review by id.
     */
    public Review getReviewById(int reviewId) {
        return reviewDAO.findById(reviewId);
    }

    /**
     * Kiểm tra user reviewed product.
     */
    public boolean hasUserReviewedProduct(int productId, int userId) {
        List<Review> userReviews = reviewDAO.findByUserId(userId);
        return userReviews.stream()
                .anyMatch(review -> review.getProductId() == productId);
    }

    /**
     * Lấy rating statistics.
     */
    public int[] getRatingStatistics(int productId) {
        List<Review> reviews = reviewDAO.findByProductId(productId);
        int[] stats = new int[5]; // Index 0 = 1 star, Index 4 = 5 stars

        for (Review review : reviews) {
            int rating = review.getRating();
            if (rating >= 1 && rating <= 5) {
                stats[rating - 1]++;
            }
        }

        return stats;
    }
}

package com.example.nhom49_webbansanphamchamsoctoc.dao;

import com.example.nhom49_webbansanphamchamsoctoc.database.JDBIConnector;
import com.example.nhom49_webbansanphamchamsoctoc.model.Review;
import com.example.nhom49_webbansanphamchamsoctoc.model.User;
import org.jdbi.v3.core.Jdbi;

import java.util.List;

public class ReviewDAO implements IDAO<Review> {

    private final Jdbi jdbi;

    /**
     * Thực hiện review dao.
     */
    public ReviewDAO() {
        this.jdbi = JDBIConnector.getInstance();
    }


    @Override
    public List<Review> findAll() {
        String sql = "SELECT * FROM reviews ORDER BY created_at DESC";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .map((rs, ctx) -> mapReview(rs))
                .list());
    }


    public List<Review> findByProductId(int productId) {
        String sql = "SELECT r.*, " +
                "u.user_id AS reviewer_user_id, u.username AS reviewer_username, " +
                "u.full_name AS reviewer_full_name, u.avatar AS reviewer_avatar, " +
                "u.auth_provider AS reviewer_auth_provider " +
                "FROM reviews r " +
                "LEFT JOIN users u ON r.user_id = u.user_id " +
                "WHERE r.product_id = :productId " +
                "ORDER BY r.created_at DESC";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("productId", productId)
                .map((rs, ctx) -> mapReviewWithReviewer(rs))
                .list());
    }

    /**
     * Lấy reviews của user kèm thông tin sản phẩm
     */
    public List<Review> findByUserIdWithProduct(int userId) {
        String sql = "SELECT r.*, p.product_name, p.product_slug, " +
                "(SELECT pi.image_url FROM product_images pi WHERE pi.product_id = p.product_id AND pi.is_primary = 1 LIMIT 1) as product_image_url "
                +
                "FROM reviews r " +
                "INNER JOIN products p ON r.product_id = p.product_id " +
                "WHERE r.user_id = :userId " +
                "ORDER BY r.created_at DESC";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("userId", userId)
                .map((rs, ctx) -> {
                    Review review = mapReview(rs);
                    review.setProductName(rs.getString("product_name"));
                    review.setProductSlug(rs.getString("product_slug"));
                    review.setProductImageUrl(rs.getString("product_image_url"));
                    return review;
                })
                .list());
    }

    @Override
    public Review findById(int id) {
        String sql = "SELECT * FROM reviews WHERE review_id = :id";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("id", id)
                .map((rs, ctx) -> mapReview(rs))
                .findFirst()
                .orElse(null));
    }


    @Override
    public int insert(Review review) {
        String sql = "INSERT INTO reviews (product_id, user_id, reviewer_name, rating, content) " +
                "VALUES (:productId, :userId, :reviewerName, :rating, :content)";
        return jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("productId", review.getProductId())
                .bind("userId", review.getUserId())
                .bind("reviewerName", review.getReviewerName())
                .bind("rating", review.getRating())
                .bind("content", review.getContent())
                .executeAndReturnGeneratedKeys("review_id")
                .mapTo(Integer.class)
                .findFirst()
                .orElse(-1));
    }

    @Override
    public boolean update(Review review) {
        // Review is immutable after creation: update operation is disabled.
        return false;
    }

    @Override
    public boolean delete(int id) {
        String sql = "DELETE FROM reviews WHERE review_id = :reviewId";
        int rowsAffected = jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("reviewId", id)
                .execute());
        return rowsAffected > 0;
    }

    public double calculateAverageRating(int productId) {
        String sql = "SELECT AVG(rating) FROM reviews WHERE product_id = :productId";
        Double avg = jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("productId", productId)
                .mapTo(Double.class)
                .findFirst()
                .orElse(0.0));
        return avg != null ? Math.round(avg * 10.0) / 10.0 : 0.0;
    }

    public int countByProductId(int productId) {
        String sql = "SELECT COUNT(*) FROM reviews WHERE product_id = :productId";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("productId", productId)
                .mapTo(Integer.class)
                .findFirst()
                .orElse(0));
    }

    /**
     * Kiểm tra user đã review sản phẩm này chưa
     */
    public boolean existsByUserIdAndProductId(int userId, int productId) {
        String sql = "SELECT COUNT(*) FROM reviews WHERE user_id = :userId AND product_id = :productId";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("userId", userId)
                .bind("productId", productId)
                .mapTo(Integer.class)
                .findFirst()
                .orElse(0) > 0);
    }

    private Review mapReview(java.sql.ResultSet rs) throws java.sql.SQLException {
        Review review = new Review();
        review.setReviewId(rs.getInt("review_id"));
        review.setProductId(rs.getInt("product_id"));
        review.setUserId(rs.getObject("user_id") != null ? rs.getInt("user_id") : null);
        review.setReviewerName(rs.getString("reviewer_name"));
        review.setRating(rs.getInt("rating"));
        review.setContent(rs.getString("content"));
        review.setCreatedAt(rs.getTimestamp("created_at"));
        try {
            review.setAdminReply(rs.getString("admin_reply_content"));
            review.setAdminReplyDate(rs.getTimestamp("admin_reply_at"));
        } catch (java.sql.SQLException ignored) {
        }
        return review;
    }

    private Review mapReviewWithReviewer(java.sql.ResultSet rs) throws java.sql.SQLException {
        Review review = mapReview(rs);
        int reviewerUserId = rs.getInt("reviewer_user_id");
        if (!rs.wasNull()) {
            User reviewer = new User();
            reviewer.setUserId(reviewerUserId);
            reviewer.setUsername(rs.getString("reviewer_username"));
            reviewer.setFullName(rs.getString("reviewer_full_name"));
            reviewer.setAvatar(rs.getString("reviewer_avatar"));
            reviewer.setAuthProvider(rs.getString("reviewer_auth_provider"));
            review.setReviewer(reviewer);
        }
        return review;
    }
}

package com.example.nhom49_webbansanphamchamsoctoc.dao;

import com.example.nhom49_webbansanphamchamsoctoc.database.JDBIConnector;
import com.example.nhom49_webbansanphamchamsoctoc.model.Review;
import org.jdbi.v3.core.Jdbi;

import java.util.List;

public class ReviewDAO implements IDAO<Review> {

    private final Jdbi jdbi;

    public ReviewDAO() {
        this.jdbi = JDBIConnector.getInstance();
    }

    @Override
    public Review findById(int id) {
        String sql = """
            SELECT * FROM reviews
            WHERE review_id = :id
        """;

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("id", id)
                        .mapToBean(Review.class)
                        .findFirst()
                        .orElse(null)
        );
    }

    @Override
    public List<Review> findAll() {
        String sql = "SELECT * FROM reviews ORDER BY created_at DESC";

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .mapToBean(Review.class)
                        .list()
        );
    }

    public List<Review> findByProductId(int productId) {
        String sql = """
            SELECT * FROM reviews
            WHERE product_id = :productId
            ORDER BY created_at DESC
        """;

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("productId", productId)
                        .mapToBean(Review.class)
                        .list()
        );
    }

    @Override
    public int insert(Review review) {
        String sql = """
            INSERT INTO reviews
            (product_id, user_id, reviewer_name, rating, content)
            VALUES (:productId, :userId, :reviewerName, :rating, :content)
        """;

        return jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bindBean(review)
                        .execute()
        );
    }

    @Override
    public boolean update(Review review) {
        String sql = """
            UPDATE reviews
            SET rating = :rating,
                content = :content
            WHERE review_id = :reviewId
        """;

        int rows = jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bindBean(review)
                        .execute()
        );

        return rows > 0;
    }

    @Override
    public boolean delete(int id) {
        String sql = "DELETE FROM reviews WHERE review_id = :id";

        int rows = jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("id", id)
                        .execute()
        );

        return rows > 0;
    }
}

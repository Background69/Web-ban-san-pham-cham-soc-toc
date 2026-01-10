package com.example.nhom49_webbansanphamchamsoctoc.dao;

import com.example.nhom49_webbansanphamchamsoctoc.database.JDBIConnector;
import com.example.nhom49_webbansanphamchamsoctoc.model.Category;
import org.jdbi.v3.core.Jdbi;

import java.util.List;

public class CategoryDAO implements IDAO<Category> {
    private final Jdbi jdbi;

    public CategoryDAO() {
        this.jdbi = JDBIConnector.getInstance();
    }

    @Override
    public Category findById(int id) {
        String sql = "SELECT * FROM categories WHERE category_id = :categoryId";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("categoryId", id)
                        .map((rs, ctx) -> mapCategory(rs))
                        .findFirst()
                        .orElse(null)
        );
    }

    public Category findBySlug(String slug) {
        String sql = "SELECT * FROM categories WHERE category_slug = :categorySlug";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("categorySlug", slug)
                        .map((rs, ctx) -> mapCategory(rs))
                        .findFirst()
                        .orElse(null)
        );
    }

    @Override
    public List<Category> findAll() {
        String sql = "SELECT * FROM categories ORDER BY category_name";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .map((rs, ctx) -> mapCategory(rs))
                        .list()
        );
    }

    @Override
    public int insert(Category category) {
        String sql = "INSERT INTO categories (category_name, category_slug) VALUES (:categoryName, :categorySlug)";
        return jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("categoryName", category.getCategoryName())
                        .bind("categorySlug", category.getCategorySlug())
                        .executeAndReturnGeneratedKeys("category_id")
                        .mapTo(Integer.class)
                        .findFirst()
                        .orElse(-1)
        );
    }

    @Override
    public boolean update(Category category) {
        String sql = "UPDATE categories SET category_name = :categoryName, category_slug = :categorySlug, " +
                "updated_at = CURRENT_TIMESTAMP WHERE category_id = :categoryId";
        int rowsAffected = jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("categoryName", category.getCategoryName())
                        .bind("categorySlug", category.getCategorySlug())
                        .bind("categoryId", category.getCategoryId())
                        .execute()
        );
        return rowsAffected > 0;
    }

    @Override
    public boolean delete(int id) {
        String sql = "DELETE FROM categories WHERE category_id = :categoryId";
        int rowsAffected = jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("categoryId", id)
                        .execute()
        );
        return rowsAffected > 0;
    }

    private Category mapCategory(java.sql.ResultSet rs) throws java.sql.SQLException {
        Category category = new Category();
        category.setCategoryId(rs.getInt("category_id"));
        category.setCategoryName(rs.getString("category_name"));
        category.setCategorySlug(rs.getString("category_slug"));
        category.setCreatedAt(rs.getTimestamp("created_at"));
        category.setUpdatedAt(rs.getTimestamp("updated_at"));
        return category;
    }
}

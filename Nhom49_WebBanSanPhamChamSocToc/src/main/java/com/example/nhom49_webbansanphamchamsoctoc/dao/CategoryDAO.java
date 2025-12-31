package com.example.nhom49_webbansanphamchamsoctoc.dao;

import com.example.nhom49_webbansanphamchamsoctoc.database.JDBIConnector;
import com.example.nhom49_webbansanphamchamsoctoc.model.Category;
import org.jdbi.v3.core.Jdbi;

import java.sql.ResultSet;
import java.util.List;

public class CategoryDAO implements IDAO<Category> {
    private final Jdbi jdbi;

    public CategoryDAO(Jdbi jdbi) {
        this.jdbi = JDBIConnector.getInstance();
    }

    @Override
    public Category findById(int id) {
        String sql = "SELECT * FROM categories WHERE category_id = ?";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind(0, id)
                        .map((rs, ctx) -> mapCategory(rs))
                        .findFirst()
                        .orElse(null)
        );
    }

    public Category findBySlug(String slug) {
        String sql = "SELECT * FROM categories WHERE category_slug = ?";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind(0, slug)
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
        String sql = "INSERT INTO categories (category_name, category_slug) VALUES (?, ?)";
        return jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind(0, category.getCategoryName())
                        .bind(1, category.getCategorySlug())
                        .executeAndReturnGeneratedKeys("category_id")
                        .mapTo(Integer.class)
                        .findFirst()
                        .orElse(-1)
        );
    }

    @Override
    public boolean update(Category category) {
        String sql = "UPDATE categories SET category_name = ?, category_slug = ?, updated_at = CURRENT_TIMESTAMP WHERE category_id = ?";
        int rowsAffected = jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind(0, category.getCategoryName())
                        .bind(1, category.getCategorySlug())
                        .bind(2, category.getCategoryId())
                        .execute()
        );
        return rowsAffected > 0;
    }

    @Override
    public boolean delete(int id) {
        String sql = "DELETE FROM categories WHERE category_id = ?";
        int rowsAffected = jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind(0, id)
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

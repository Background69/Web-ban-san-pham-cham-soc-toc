package com.example.nhom49_webbansanphamchamsoctoc.dao;

import com.example.nhom49_webbansanphamchamsoctoc.database.JDBIConnector;
import com.example.nhom49_webbansanphamchamsoctoc.model.Category;
import org.jdbi.v3.core.Jdbi;

import java.util.List;

/**
 * Lớp CategoryDao.
 */
public class CategoryDAO implements IDAO<Category> {

    private final Jdbi jdbi;

    /**
     * Thực hiện category dao.
     */
    public CategoryDAO() {
        this.jdbi = JDBIConnector.getInstance();
    }

    /**
     * Tim by id.
     *
     * @param id Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    @Override
    public Category findById(int id) {
        String sql = "SELECT * FROM categories WHERE category_id = :categoryId";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("categoryId", id)
                        .map((rs, ctx) -> mapCategory(rs))  // Map ResultSet sang Category object
                        .findFirst()
                        .orElse(null)
        );
    }

    /**
     * Tim by slug.
     *
     * @param slug Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
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

    /**
     * Tim all.
     *
     * @return Kết quả xử lý của phương thức.
     */
    @Override
    public List<Category> findAll() {
        String sql = "SELECT * FROM categories ORDER BY category_name";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .map((rs, ctx) -> mapCategory(rs))
                        .list()
        );
    }

    /**
     * Them .
     *
     * @param category Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    @Override
    public int insert(Category category) {
        String sql = "INSERT INTO categories (category_name, category_slug) VALUES (:categoryName, :categorySlug)";
        return jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("categoryName", category.getCategoryName())
                        .bind("categorySlug", category.getCategorySlug())
                        .executeAndReturnGeneratedKeys("category_id")  // Trả về ID tự động tăng
                        .mapTo(Integer.class)
                        .findFirst()
                        .orElse(-1)
        );
    }

    /**
     * Cập nhật .
     *
     * @param category Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    @Override
    public boolean update(Category category) {
        String sql = "UPDATE categories SET category_name = :categoryName, category_slug = :categorySlug, updated_at = CURRENT_TIMESTAMP WHERE category_id = :categoryId";
        int rowsAffected = jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("categoryName", category.getCategoryName())
                        .bind("categorySlug", category.getCategorySlug())
                        .bind("categoryId", category.getCategoryId())
                        .execute()
        );
        return rowsAffected > 0;  // Trả về true nếu có ít nhất 1 row bị ảnh hưởng
    }

    /**
     * Xóa .
     *
     * @param id Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
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

    /**
     * Thực hiện map category.
     *
     * @param rs Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
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
package com.example.nhom49_webbansanphamchamsoctoc.dao;

import com.example.nhom49_webbansanphamchamsoctoc.database.JDBIConnector;
import com.example.nhom49_webbansanphamchamsoctoc.model.Product;
import org.jdbi.v3.core.Jdbi;

import java.util.List;

public class ProductDAO implements IDAO<Product> {

    private final Jdbi jdbi;

    public ProductDAO() {
        this.jdbi = JDBIConnector.getInstance();
    }

    @Override
    public Product findById(int id) {
        String sql = "SELECT * FROM products WHERE product_id = ?";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind(0, id)
                        .map((rs, ctx) -> mapProduct(rs))
                        .findFirst()
                        .orElse(null)
        );
    }

    public Product findBySlug(String slug) {
        String sql = "SELECT * FROM products WHERE product_slug = ?";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind(0, slug)
                        .map((rs, ctx) -> mapProduct(rs))
                        .findFirst()
                        .orElse(null)
        );
    }

    @Override
    public List<Product> findAll() {
        String sql = "SELECT * FROM products ORDER BY created_at DESC";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .map((rs, ctx) -> mapProduct(rs))
                        .list()
        );
    }


    @Override
    public int insert(Product product) {
        String sql = "INSERT INTO products (product_name, product_slug, brand_id, category_id, origin, " +
                "short_description, full_description, stock_quantity, is_featured, is_on_sale) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        return jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind(0, product.getProductName())
                        .bind(1, product.getProductSlug())
                        .bind(2, product.getBrandId())
                        .bind(3, product.getCategoryId())
                        .bind(4, product.getOrigin())
                        .bind(5, product.getShortDescription())
                        .bind(6, product.getFullDescription())
                        .bind(7, product.getStockQuantity())
                        .bind(8, product.isFeatured())
                        .bind(9, product.isOnSale())
                        .executeAndReturnGeneratedKeys("product_id")
                        .mapTo(Integer.class)
                        .findFirst()
                        .orElse(-1)
        );
    }

    @Override
    public boolean update(Product product) {
        String sql = "UPDATE products SET product_name = ?, product_slug = ?, brand_id = ?, category_id = ?, " +
                "origin = ?, short_description = ?, full_description = ?, stock_quantity = ?, " +
                "is_featured = ?, is_on_sale = ?, updated_at = CURRENT_TIMESTAMP WHERE product_id = ?";
        int rowsAffected = jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind(0, product.getProductName())
                        .bind(1, product.getProductSlug())
                        .bind(2, product.getBrandId())
                        .bind(3, product.getCategoryId())
                        .bind(4, product.getOrigin())
                        .bind(5, product.getShortDescription())
                        .bind(6, product.getFullDescription())
                        .bind(7, product.getStockQuantity())
                        .bind(8, product.isFeatured())
                        .bind(9, product.isOnSale())
                        .bind(10, product.getProductId())
                        .execute()
        );
        return rowsAffected > 0;
    }

    @Override
    public boolean delete(int id) {
        String sql = "DELETE FROM products WHERE product_id = ?";
        int rowsAffected = jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind(0, id)
                        .execute()
        );
        return rowsAffected > 0;
    }

    // Query methods

    public List<Product> findByCategory(int categoryId) {
        String sql = "SELECT * FROM products WHERE category_id = ? ORDER BY created_at DESC";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind(0, categoryId)
                        .map((rs, ctx) -> mapProduct(rs))
                        .list()
        );
    }

    public List<Product> findByBrand(int brandId) {
        String sql = "SELECT * FROM products WHERE brand_id = ? ORDER BY created_at DESC";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind(0, brandId)
                        .map((rs, ctx) -> mapProduct(rs))
                        .list()
        );
    }


    public List<Product> search(String keyword) {
        String sql = "SELECT * FROM products WHERE product_name LIKE ? OR short_description LIKE ? " +
                "ORDER BY created_at DESC";
        String searchPattern = "%" + keyword + "%";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind(0, searchPattern)
                        .bind(1, searchPattern)
                        .map((rs, ctx) -> mapProduct(rs))
                        .list()
        );
    }

    public List<Product> findFeatured() {
        String sql = "SELECT * FROM products WHERE is_featured = true ORDER BY created_at DESC";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .map((rs, ctx) -> mapProduct(rs))
                        .list()
        );
    }

    public List<Product> findOnSale() {
        String sql = "SELECT * FROM products WHERE is_on_sale = true ORDER BY created_at DESC";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .map((rs, ctx) -> mapProduct(rs))
                        .list()
        );
    }

    /**
     * Tìm sản phẩm flash sale
     */
    public List<Product> findFlashSale() {
        String sql = "SELECT p.* FROM products p " +
                "JOIN product_variants pv ON p.product_id = pv.product_id " +
                "WHERE pv.is_default = true AND pv.original_price > 0 " +
                "AND ((pv.original_price - pv.sale_price) / pv.original_price * 100) > 30 " +
                "ORDER BY p.created_at DESC";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .map((rs, ctx) -> mapProduct(rs))
                        .list()
        );
    }

    /**
     * Tìm sản phẩm theo brand với pagination
     */
    public List<Product> findByBrandWithPagination(int brandId, int page, int pageSize) {
        int offset = (page - 1) * pageSize;
        String sql = "SELECT * FROM products WHERE brand_id = ? ORDER BY created_at DESC LIMIT ? OFFSET ?";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind(0, brandId)
                        .bind(1, pageSize)
                        .bind(2, offset)
                        .map((rs, ctx) -> mapProduct(rs))
                        .list()
        );
    }

    /**
     * Đếm số sản phẩm theo brand
     */
    public int countByBrand(int brandId) {
        String sql = "SELECT COUNT(*) FROM products WHERE brand_id = ?";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind(0, brandId)
                        .mapTo(Integer.class)
                        .findFirst()
                        .orElse(0)
        );
    }

    /**
     * Lấy danh sách sản phẩm có phân trang (không lọc theo điều kiện gì)
     * Dùng cho trang danh sách sản phẩm chung (Shop page)
     */
    public List<Product> findWithPagination(int page, int pageSize) {
        int offset = (page - 1) * pageSize;
        String sql = "SELECT * FROM products ORDER BY created_at DESC LIMIT ? OFFSET ?";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind(0, pageSize)
                        .bind(1, offset)
                        .map((rs, ctx) -> mapProduct(rs))
                        .list()
        );
    }

    /**
     * Đếm tổng số lượng sản phẩm trong toàn bộ CSDL
     */
    public int countAll() {
        String sql = "SELECT COUNT(*) FROM products";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .mapTo(Integer.class)
                        .findFirst()
                        .orElse(0)
        );
    }

    /**
     * Đếm tổng số lượng sản phẩm thuộc một danh mục cụ thể
     */

    public int countByCategory(int categoryId) {
        String sql = "SELECT COUNT(*) FROM products WHERE category_id = ?";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind(0, categoryId)
                        .mapTo(Integer.class)
                        .findFirst()
                        .orElse(0)
        );
    }

    /**
     * Cập nhật điểm đánh giá trung bình và số lượng review cho sản phẩm.
     * Thường được gọi sau khi user submit một review mới.
     *
     * @param productId   ID sản phẩm.
     * @param avgRating   Điểm trung bình mới.
     * @param reviewCount Tổng số lượng review mới.
     */
    public boolean updateRating(int productId, double avgRating, int reviewCount) {
        String sql = "UPDATE products SET average_rating = ?, review_count = ? WHERE product_id = ?";
        int rowsAffected = jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind(0, avgRating)
                        .bind(1, reviewCount)
                        .bind(2, productId)
                        .execute()
        );
        return rowsAffected > 0;
    }

    /**
     * Hàm hỗ trợ map dữ liệu từ ResultSet (SQL) sang Object Product (Java).
     */
    private Product mapProduct(java.sql.ResultSet rs) throws java.sql.SQLException {
        Product product = new Product();
        product.setProductId(rs.getInt("product_id"));
        product.setProductName(rs.getString("product_name"));
        product.setProductSlug(rs.getString("product_slug"));
        product.setBrandId(rs.getObject("brand_id") != null ? rs.getInt("brand_id") : null);
        product.setCategoryId(rs.getObject("category_id") != null ? rs.getInt("category_id") : null);
        product.setOrigin(rs.getString("origin"));
        product.setShortDescription(rs.getString("short_description"));
        product.setFullDescription(rs.getString("full_description"));
        product.setStockQuantity(rs.getInt("stock_quantity"));
        product.setFeatured(rs.getBoolean("is_featured"));
        product.setOnSale(rs.getBoolean("is_on_sale"));
        product.setAverageRating(rs.getBigDecimal("average_rating"));
        product.setReviewCount(rs.getInt("review_count"));
        product.setCreatedAt(rs.getTimestamp("created_at"));
        product.setUpdatedAt(rs.getTimestamp("updated_at"));
        return product;
    }
}

package com.example.nhom49_webbansanphamchamsoctoc.dao;

import com.example.nhom49_webbansanphamchamsoctoc.database.JDBIConnector;
import com.example.nhom49_webbansanphamchamsoctoc.model.Product;
import org.jdbi.v3.core.Jdbi;

import java.util.List;

/**
 * Lớp ProductDao.
 */
public class ProductDAO implements IDAO<Product> {

    private final Jdbi jdbi;

    /**
     * Thực hiện product dao.
     */
    public ProductDAO() {
        this.jdbi = JDBIConnector.getInstance();
    }


    /**
     * Tim by slug.
     *
     * @param slug Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    public Product findBySlug(String slug) {
        String sql = "SELECT * FROM products WHERE product_slug = :productSlug";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("productSlug", slug)
                        .map((rs, ctx) -> mapProduct(rs))
                        .findFirst()
                        .orElse(null)
        );
    }

    /**
     * Tim by id.
     *
     * @param id Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    @Override
    public Product findById(int id) {
        String sql = "SELECT * FROM products WHERE product_id = :id";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("id", id)
                        .map((rs, ctx) -> mapProduct(rs))
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
    public List<Product> findAll() {
        String sql = "SELECT * FROM products ORDER BY created_at DESC";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .map((rs, ctx) -> mapProduct(rs))
                        .list()
        );
    }


    /**
     * Them .
     *
     * @param product Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    @Override
    public int insert(Product product) {
        String sql = "INSERT INTO products (product_name, product_slug, brand_id, category_id, origin, " +
                "short_description, full_description, stock_quantity, is_featured, is_on_sale) " +
                "VALUES (:productName, :productSlug, :brandId, :categoryId, :origin, :shortDescription, :fullDescription, :stockQuantity, :isFeatured, :isOnSale)";
        return jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("productName", product.getProductName())
                        .bind("productSlug", product.getProductSlug())
                        .bind("brandId", product.getBrandId())
                        .bind("categoryId", product.getCategoryId())
                        .bind("origin", product.getOrigin())
                        .bind("shortDescription", product.getShortDescription())
                        .bind("fullDescription", product.getFullDescription())
                        .bind("stockQuantity", product.getStockQuantity())
                        .bind("isFeatured", product.isFeatured())
                        .bind("isOnSale", product.isOnSale())
                        .executeAndReturnGeneratedKeys("product_id")
                        .mapTo(Integer.class)
                        .findFirst()
                        .orElse(-1)
        );
    }

    /**
     * Cập nhật .
     *
     * @param product Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    @Override
    public boolean update(Product product) {
        String sql = "UPDATE products SET product_name = :productName, product_slug = :productSlug, brand_id = :brandId, category_id = :categoryId, " +
                "origin = :origin, short_description = :shortDescription, full_description = :fullDescription, stock_quantity = :stockQuantity, " +
                "is_featured = :isFeatured, is_on_sale = :isOnSale, updated_at = CURRENT_TIMESTAMP WHERE product_id = :productId";
        int rowsAffected = jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("productName", product.getProductName())
                        .bind("productSlug", product.getProductSlug())
                        .bind("brandId", product.getBrandId())
                        .bind("categoryId", product.getCategoryId())
                        .bind("origin", product.getOrigin())
                        .bind("shortDescription", product.getShortDescription())
                        .bind("fullDescription", product.getFullDescription())
                        .bind("stockQuantity", product.getStockQuantity())
                        .bind("isFeatured", product.isFeatured())
                        .bind("isOnSale", product.isOnSale())
                        .bind("productId", product.getProductId())
                        .execute()
        );
        return rowsAffected > 0;
    }

    /**
     * Xóa .
     *
     * @param id Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    @Override
    public boolean delete(int id) {
        String sql = "DELETE FROM products WHERE product_id = :productId";
        int rowsAffected = jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("productId", id)
                        .execute()
        );
        return rowsAffected > 0;
    }

    // Query methods

    /**
     * Tim by category.
     *
     * @param categoryId Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    public List<Product> findByCategory(int categoryId) {
        String sql = "SELECT * FROM products WHERE category_id = :categoryId ORDER BY created_at DESC";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("categoryId", categoryId)
                        .map((rs, ctx) -> mapProduct(rs))
                        .list()
        );
    }

    /**
     * Tim by brand.
     *
     * @param brandId Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    public List<Product> findByBrand(int brandId) {
        String sql = "SELECT * FROM products WHERE brand_id = :brandId ORDER BY created_at DESC";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("brandId", brandId)
                        .map((rs, ctx) -> mapProduct(rs))
                        .list()
        );
    }


    /**
     * Thực hiện search.
     *
     * @param keyword Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    public List<Product> search(String keyword) {
        String sql = "SELECT * FROM products WHERE product_name LIKE :searchPattern OR short_description LIKE :searchPattern " +
                "ORDER BY created_at DESC";
        String searchPattern = "%" + keyword + "%";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("searchPattern", searchPattern)
                        .map((rs, ctx) -> mapProduct(rs))
                        .list()
        );
    }

    /**
     * Tim featured.
     *
     * @return Kết quả xử lý của phương thức.
     */
    public List<Product> findFeatured() {
        String sql = "SELECT * FROM products WHERE is_featured = true ORDER BY created_at DESC";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .map((rs, ctx) -> mapProduct(rs))
                        .list()
        );
    }

    /**
     * Tim on sale.
     *
     * @return Kết quả xử lý của phương thức.
     */
    public List<Product> findOnSale() {
        String sql = "SELECT * FROM products WHERE is_on_sale = true ORDER BY created_at DESC";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .map((rs, ctx) -> mapProduct(rs))
                        .list()
        );
    }

    /**
     * Tim flash sale.
     *
     * @return Kết quả xử lý của phương thức.
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
     * Tim by brand with pagination.
     *
     * @param brandId Tham số đầu vào.
     * @param page Tham số đầu vào.
     * @param pageSize Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    public List<Product> findByBrandWithPagination(int brandId, int page, int pageSize) {
        int offset = (page - 1) * pageSize;
        String sql = "SELECT * FROM products WHERE brand_id = :brandId ORDER BY created_at DESC LIMIT :pageSize OFFSET :offset";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("brandId", brandId)
                        .bind("pageSize", pageSize)
                        .bind("offset", offset)
                        .map((rs, ctx) -> mapProduct(rs))
                        .list()
        );
    }

    /**
     * Dem by brand.
     *
     * @param brandId Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    public int countByBrand(int brandId) {
        String sql = "SELECT COUNT(*) FROM products WHERE brand_id = :brandId";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("brandId", brandId)
                        .mapTo(Integer.class)
                        .findFirst()
                        .orElse(0)
        );
    }

    // Pagination methods

    /**
     * Tim with pagination.
     *
     * @param page Tham số đầu vào.
     * @param pageSize Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    public List<Product> findWithPagination(int page, int pageSize) {
        int offset = (page - 1) * pageSize;
        String sql = "SELECT * FROM products ORDER BY created_at DESC LIMIT :pageSize OFFSET :offset";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("pageSize", pageSize)
                        .bind("offset", offset)
                        .map((rs, ctx) -> mapProduct(rs))
                        .list()
        );
    }

    /**
     * Tim by category with pagination.
     *
     * @param categoryId Tham số đầu vào.
     * @param page Tham số đầu vào.
     * @param pageSize Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    public List<Product> findByCategoryWithPagination(int categoryId, int page, int pageSize) {
        int offset = (page - 1) * pageSize;
        String sql = "SELECT * FROM products WHERE category_id = :categoryId ORDER BY created_at DESC LIMIT :pageSize OFFSET :offset";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("categoryId", categoryId)
                        .bind("pageSize", pageSize)
                        .bind("offset", offset)
                        .map((rs, ctx) -> mapProduct(rs))
                        .list()
        );
    }

    /**
     * Dem all.
     *
     * @return Kết quả xử lý của phương thức.
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
     * Dem by category.
     *
     * @param categoryId Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    public int countByCategory(int categoryId) {
        String sql = "SELECT COUNT(*) FROM products WHERE category_id = :categoryId";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("categoryId", categoryId)
                        .mapTo(Integer.class)
                        .findFirst()
                        .orElse(0)
        );
    }

    // Rating update

    /**
     * Cập nhật rating.
     *
     * @param productId Tham số đầu vào.
     * @param avgRating Tham số đầu vào.
     * @param reviewCount Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    public boolean updateRating(int productId, double avgRating, int reviewCount) {
        String sql = "UPDATE products SET average_rating = :averageRating, review_count = :reviewCount WHERE product_id = :productId";
        int rowsAffected = jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("averageRating", avgRating)
                        .bind("reviewCount", reviewCount)
                        .bind("productId", productId)
                        .execute()
        );
        return rowsAffected > 0;
    }

    // Helper method
    /**
     * Thực hiện map product.
     *
     * @param rs Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
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





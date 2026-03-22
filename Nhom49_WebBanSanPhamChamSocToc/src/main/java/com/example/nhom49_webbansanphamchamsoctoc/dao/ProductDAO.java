package com.example.nhom49_webbansanphamchamsoctoc.dao;

import com.example.nhom49_webbansanphamchamsoctoc.database.JDBIConnector;
import com.example.nhom49_webbansanphamchamsoctoc.model.HairCondition;
import com.example.nhom49_webbansanphamchamsoctoc.model.Product;
import com.example.nhom49_webbansanphamchamsoctoc.model.Promotion;
import org.jdbi.v3.core.Jdbi;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class ProductDAO implements IDAO<Product> {

    private final Jdbi jdbi;

    public ProductDAO() {
        this.jdbi = JDBIConnector.getInstance();
    }

    public Product findBySlug(String slug) {
        String sql = "SELECT * FROM products WHERE product_slug = :productSlug AND is_deleted = FALSE";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("productSlug", slug)
                .map((rs, ctx) -> mapProduct(rs))
                .findFirst()
                .orElse(null));
    }

    @Override
    public Product findById(int id) {
        String sql = "SELECT * FROM products WHERE product_id = :id AND is_deleted = FALSE";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("id", id)
                .map((rs, ctx) -> mapProduct(rs))
                .findFirst()
                .orElse(null));
    }

    /**
     * Tìm sản phẩm theo ID kèm theo HairConditions và Promotions.
     * Sử dụng kỹ thuật LinkedHashMap reducer để tránh n+1 query.
     *
     * @param productId ID sản phẩm.
     * @return Product với đầy đủ hairConditions và promotions.
     */
    public Product findByIdWithRelations(int productId) {
        String sql = """
                SELECT
                    p.*,
                    hc.condition_id AS hc_condition_id,
                    hc.condition_name AS hc_condition_name,
                    hc.condition_slug AS hc_condition_slug,
                    pr.promotion_id AS pr_promotion_id,
                    pr.promotion_name AS pr_promotion_name,
                    pr.promotion_type AS pr_promotion_type,
                    pr.badge_text AS pr_badge_text,
                    pr.start_date AS pr_start_date,
                    pr.end_date AS pr_end_date,
                    pr.is_active AS pr_is_active
                FROM products p
                LEFT JOIN product_hair_conditions phc ON p.product_id = phc.product_id
                LEFT JOIN hair_conditions hc ON phc.condition_id = hc.condition_id
                LEFT JOIN product_promotions pp ON p.product_id = pp.product_id
                LEFT JOIN promotions pr ON pp.promotion_id = pr.promotion_id
                WHERE p.product_id = :productId
                  AND p.is_deleted = FALSE
                """;

        return jdbi.withHandle(handle -> {
            Map<Integer, Product> productMap = new LinkedHashMap<>();
            Map<Integer, HairCondition> conditionMap = new HashMap<>();
            Map<Integer, Promotion> promotionMap = new HashMap<>();

            handle.createQuery(sql)
                    .bind("productId", productId)
                    .map((rs, ctx) -> {
                        // Get or create Product
                        int pId = rs.getInt("product_id");
                        Product product = productMap.computeIfAbsent(pId, id -> {
                            try {
                                Product p = mapProduct(rs);
                                p.setHairConditions(new java.util.ArrayList<>());
                                p.setPromotions(new java.util.ArrayList<>());
                                return p;
                            } catch (java.sql.SQLException e) {
                                throw new RuntimeException(e);
                            }
                        });

                        // Map HairCondition if present
                        int hcId = rs.getInt("hc_condition_id");
                        if (!rs.wasNull() && !conditionMap.containsKey(hcId)) {
                            HairCondition hc = new HairCondition();
                            hc.setConditionId(hcId);
                            hc.setConditionName(rs.getString("hc_condition_name"));
                            hc.setConditionSlug(rs.getString("hc_condition_slug"));
                            conditionMap.put(hcId, hc);
                            product.getHairConditions().add(hc);
                        }

                        // Map Promotion if present
                        int prId = rs.getInt("pr_promotion_id");
                        if (!rs.wasNull() && !promotionMap.containsKey(prId)) {
                            Promotion pr = new Promotion();
                            pr.setPromotionId(prId);
                            pr.setPromotionName(rs.getString("pr_promotion_name"));
                            pr.setPromotionType(rs.getString("pr_promotion_type"));
                            pr.setBadgeText(rs.getString("pr_badge_text"));
                            java.sql.Timestamp start = rs.getTimestamp("pr_start_date");
                            java.sql.Timestamp end = rs.getTimestamp("pr_end_date");
                            pr.setStartDate(start != null ? start.toLocalDateTime() : null);
                            pr.setEndDate(end != null ? end.toLocalDateTime() : null);
                            pr.setActive(rs.getBoolean("pr_is_active"));
                            promotionMap.put(prId, pr);
                            product.getPromotions().add(pr);
                        }

                        return product;
                    })
                    .list();

            return productMap.values().stream().findFirst().orElse(null);
        });
    }

    
    @Override
    public List<Product> findAll() {
        String sql = "SELECT * FROM products WHERE is_deleted = FALSE ORDER BY created_at DESC";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .map((rs, ctx) -> mapProduct(rs))
                .list());
    }

    
    @Override
    public int insert(Product product) {
        String sql = "INSERT INTO products (product_name, product_slug, brand_id, category_id, origin, " +
                "short_description, full_description, ingredients, usage_instructions, is_featured, is_on_sale) " +
                "VALUES (:productName, :productSlug, :brandId, :categoryId, :origin, :shortDescription, :fullDescription, :ingredients, :usageInstructions, :isFeatured, :isOnSale)";
        return jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("productName", product.getProductName())
                .bind("productSlug", product.getProductSlug())
                .bind("brandId", product.getBrandId())
                .bind("categoryId", product.getCategoryId())
                .bind("origin", product.getOrigin())
                .bind("shortDescription", product.getShortDescription())
                .bind("fullDescription", product.getFullDescription())
                .bind("ingredients", product.getIngredients())
                .bind("usageInstructions", product.getUsageInstructions())
                .bind("isFeatured", product.isFeatured())
                .bind("isOnSale", product.isOnSale())
                .executeAndReturnGeneratedKeys("product_id")
                .mapTo(Integer.class)
                .findFirst()
                .orElse(-1));
    }

    
    @Override
    public boolean update(Product product) {
        String sql = "UPDATE products SET product_name = :productName, product_slug = :productSlug, brand_id = :brandId, category_id = :categoryId, "
                + "origin = :origin, short_description = :shortDescription, full_description = :fullDescription, ingredients = :ingredients, usage_instructions = :usageInstructions, "
                +
                "is_featured = :isFeatured, is_on_sale = :isOnSale, updated_at = CURRENT_TIMESTAMP WHERE product_id = :productId";
        int rowsAffected = jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("productName", product.getProductName())
                .bind("productSlug", product.getProductSlug())
                .bind("brandId", product.getBrandId())
                .bind("categoryId", product.getCategoryId())
                .bind("origin", product.getOrigin())
                .bind("shortDescription", product.getShortDescription())
                .bind("fullDescription", product.getFullDescription())
                .bind("ingredients", product.getIngredients())
                .bind("usageInstructions", product.getUsageInstructions())
                .bind("isFeatured", product.isFeatured())
                .bind("isOnSale", product.isOnSale())
                .bind("productId", product.getProductId())
                .execute());
        return rowsAffected > 0;
    }

    
    @Override
    public boolean delete(int id) {
        String sql = "DELETE FROM products WHERE product_id = :productId";
        int rowsAffected = jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("productId", id)
                .execute());
        return rowsAffected > 0;
    }

    public boolean softDelete(int id) {
        String sql = "UPDATE products SET is_deleted = TRUE, deleted_at = NOW() WHERE product_id = :id";
        return jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("id", id)
                .execute() > 0);
    }

    // Query methods

    
    public List<Product> findByCategory(int categoryId) {
        String sql = "SELECT * FROM products WHERE category_id = :categoryId AND is_deleted = FALSE ORDER BY created_at DESC";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("categoryId", categoryId)
                .map((rs, ctx) -> mapProduct(rs))
                .list());
    }

    
    public List<Product> findByBrand(int brandId) {
        String sql = "SELECT * FROM products WHERE brand_id = :brandId AND is_deleted = FALSE ORDER BY created_at DESC";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("brandId", brandId)
                .map((rs, ctx) -> mapProduct(rs))
                .list());
    }

    /**
     * Lấy sản phẩm liên quan theo category, loại trừ sản phẩm hiện tại
     */
    public List<Product> findRelatedProducts(int productId, int categoryId, int limit) {
        String sql = "SELECT * FROM products WHERE category_id = :categoryId AND product_id != :productId AND is_deleted = FALSE ORDER BY RAND() LIMIT :limit";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("categoryId", categoryId)
                .bind("productId", productId)
                .bind("limit", limit)
                .map((rs, ctx) -> mapProduct(rs))
                .list());
    }

    
    public List<Product> search(String keyword) {
        String sql = "SELECT * FROM products WHERE (product_name LIKE :searchPattern OR short_description LIKE :searchPattern) AND is_deleted = FALSE "
                +
                "ORDER BY created_at DESC";
        String searchPattern = "%" + keyword + "%";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("searchPattern", searchPattern)
                .map((rs, ctx) -> mapProduct(rs))
                .list());
    }

    
    public List<Product> findFeatured() {
        String sql = "SELECT * FROM products WHERE is_featured = true AND is_deleted = FALSE ORDER BY created_at DESC";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .map((rs, ctx) -> mapProduct(rs))
                .list());
    }

    public List<Product> getTopRatedBestSellingProducts(int limit) {
        String sql = """
                SELECT p.*, COALESCE(sold.sold_quantity, 0) AS sold_quantity
                FROM products p
                LEFT JOIN (
                    SELECT oi.product_id, SUM(oi.quantity) AS sold_quantity
                    FROM order_items oi
                    GROUP BY oi.product_id
                ) sold ON sold.product_id = p.product_id
                WHERE p.is_on_sale = false
                  AND p.is_deleted = false
                ORDER BY COALESCE(p.average_rating, 0) DESC, sold_quantity DESC
                LIMIT :limit
                """;
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("limit", limit)
                .map((rs, ctx) -> mapProduct(rs))
                .list());
    }

    
    public List<Product> findOnSale() {
        String sql = """
                SELECT p.*
                FROM products p
                WHERE p.is_deleted = FALSE
                  AND (
                        p.is_on_sale = TRUE
                        OR EXISTS (
                            SELECT 1
                            FROM product_promotions pp
                            JOIN promotions pr ON pr.promotion_id = pp.promotion_id
                            WHERE pp.product_id = p.product_id
                              AND pr.is_active = TRUE
                              AND NOW() BETWEEN pr.start_date AND pr.end_date
                        )
                  )
                ORDER BY p.created_at DESC
                """;
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .map((rs, ctx) -> mapProduct(rs))
                .list());
    }

    public List<Product> findOnSale(int limit, int offset) {
        String sql = """
                SELECT p.*
                FROM products p
                WHERE p.is_deleted = FALSE
                  AND (
                        p.is_on_sale = TRUE
                        OR EXISTS (
                            SELECT 1
                            FROM product_promotions pp
                            JOIN promotions pr ON pr.promotion_id = pp.promotion_id
                            WHERE pp.product_id = p.product_id
                              AND pr.is_active = TRUE
                              AND NOW() BETWEEN pr.start_date AND pr.end_date
                        )
                  )
                ORDER BY p.created_at DESC
                LIMIT :limit OFFSET :offset
                """;
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("limit", limit)
                .bind("offset", offset)
                .map((rs, ctx) -> mapProduct(rs))
                .list());
    }

    public int countOnSale() {
        String sql = """
                SELECT COUNT(*)
                FROM products p
                WHERE p.is_deleted = FALSE
                  AND (
                        p.is_on_sale = TRUE
                        OR EXISTS (
                            SELECT 1
                            FROM product_promotions pp
                            JOIN promotions pr ON pr.promotion_id = pp.promotion_id
                            WHERE pp.product_id = p.product_id
                              AND pr.is_active = TRUE
                              AND NOW() BETWEEN pr.start_date AND pr.end_date
                        )
                  )
                """;
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .mapTo(Integer.class)
                .findFirst()
                .orElse(0));
    }

    
    public List<Product> findFlashSale() {
        String sql = "SELECT p.* FROM products p " +
                "JOIN product_variants pv ON p.product_id = pv.product_id " +
                "WHERE pv.is_default = true AND pv.original_price > 0 AND p.is_deleted = FALSE " +
                "AND pv.sale_price IS NOT NULL AND pv.sale_price > 0 " +
                "AND ((pv.original_price - pv.sale_price) / pv.original_price * 100) > 30 " +
                "ORDER BY p.created_at DESC";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .map((rs, ctx) -> mapProduct(rs))
                .list());
    }

    
    public List<Product> findByBrandWithPagination(int brandId, int page, int pageSize) {
        int offset = (page - 1) * pageSize;
        String sql = "SELECT * FROM products WHERE brand_id = :brandId AND is_deleted = FALSE ORDER BY created_at DESC LIMIT :pageSize OFFSET :offset";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("brandId", brandId)
                .bind("pageSize", pageSize)
                .bind("offset", offset)
                .map((rs, ctx) -> mapProduct(rs))
                .list());
    }

    
    public int countByBrand(int brandId) {
        String sql = "SELECT COUNT(*) FROM products WHERE brand_id = :brandId AND is_deleted = FALSE";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("brandId", brandId)
                .mapTo(Integer.class)
                .findFirst()
                .orElse(0));
    }

    // Pagination methods

    
    public List<Product> findWithPagination(int page, int pageSize) {
        int offset = (page - 1) * pageSize;
        String sql = "SELECT * FROM products WHERE is_deleted = FALSE ORDER BY created_at DESC LIMIT :pageSize OFFSET :offset";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("pageSize", pageSize)
                .bind("offset", offset)
                .map((rs, ctx) -> mapProduct(rs))
                .list());
    }

    
    public List<Product> findByCategoryWithPagination(int categoryId, int page, int pageSize) {
        int offset = (page - 1) * pageSize;
        String sql = "SELECT * FROM products WHERE category_id = :categoryId AND is_deleted = FALSE ORDER BY created_at DESC LIMIT :pageSize OFFSET :offset";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("categoryId", categoryId)
                .bind("pageSize", pageSize)
                .bind("offset", offset)
                .map((rs, ctx) -> mapProduct(rs))
                .list());
    }

    
    public int countAll() {
        String sql = "SELECT COUNT(*) FROM products WHERE is_deleted = FALSE";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .mapTo(Integer.class)
                .findFirst()
                .orElse(0));
    }

    
    public int countByCategory(int categoryId) {
        String sql = "SELECT COUNT(*) FROM products WHERE category_id = :categoryId AND is_deleted = FALSE";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("categoryId", categoryId)
                .mapTo(Integer.class)
                .findFirst()
                .orElse(0));
    }

    public List<Product> findByFilters(String search, Integer categoryId, Integer brandId, int page, int pageSize) {
        int offset = (page - 1) * pageSize;
        StringBuilder sql = new StringBuilder("SELECT * FROM products WHERE is_deleted = FALSE");
        Map<String, Object> params = new HashMap<>();

        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (product_name LIKE :search OR short_description LIKE :search)");
            params.put("search", "%" + search.trim() + "%");
        }
        if (categoryId != null) {
            sql.append(" AND category_id = :categoryId");
            params.put("categoryId", categoryId);
        }
        if (brandId != null) {
            sql.append(" AND brand_id = :brandId");
            params.put("brandId", brandId);
        }

        sql.append(" ORDER BY created_at DESC LIMIT :pageSize OFFSET :offset");
        params.put("pageSize", pageSize);
        params.put("offset", offset);

        return jdbi.withHandle(handle -> {
            var query = handle.createQuery(sql.toString());
            for (var entry : params.entrySet()) {
                query.bind(entry.getKey(), entry.getValue());
            }
            return query.map((rs, ctx) -> mapProduct(rs)).list();
        });
    }

    public int countByFilters(String search, Integer categoryId, Integer brandId) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM products WHERE is_deleted = FALSE");
        Map<String, Object> params = new HashMap<>();

        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (product_name LIKE :search OR short_description LIKE :search)");
            params.put("search", "%" + search.trim() + "%");
        }
        if (categoryId != null) {
            sql.append(" AND category_id = :categoryId");
            params.put("categoryId", categoryId);
        }
        if (brandId != null) {
            sql.append(" AND brand_id = :brandId");
            params.put("brandId", brandId);
        }

        return jdbi.withHandle(handle -> {
            var query = handle.createQuery(sql.toString());
            for (var entry : params.entrySet()) {
                query.bind(entry.getKey(), entry.getValue());
            }
            return query.mapTo(Integer.class).findFirst().orElse(0);
        });
    }

    // Rating update

    
    public boolean updateRating(int productId, double avgRating, int reviewCount) {
        String sql = "UPDATE products SET average_rating = :averageRating, review_count = :reviewCount WHERE product_id = :productId";
        int rowsAffected = jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("averageRating", avgRating)
                .bind("reviewCount", reviewCount)
                .bind("productId", productId)
                .execute());
        return rowsAffected > 0;
    }

    // Helper method
    
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
        product.setIngredients(rs.getString("ingredients"));
        product.setUsageInstructions(rs.getString("usage_instructions"));
        try {
            product.setSoldQuantity(rs.getInt("sold_quantity"));
        } catch (java.sql.SQLException ignored) {
            product.setSoldQuantity(0);
        }
        product.setFeatured(rs.getBoolean("is_featured"));
        product.setOnSale(rs.getBoolean("is_on_sale"));
        product.setDeleted(rs.getBoolean("is_deleted"));
        product.setDeletedAt(rs.getTimestamp("deleted_at"));
        product.setAverageRating(rs.getBigDecimal("average_rating"));
        product.setReviewCount(rs.getInt("review_count"));
        product.setCreatedAt(rs.getTimestamp("created_at"));
        product.setUpdatedAt(rs.getTimestamp("updated_at"));
        return product;
    }
}

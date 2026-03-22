package com.example.nhom49_webbansanphamchamsoctoc.dao;

import com.example.nhom49_webbansanphamchamsoctoc.database.JDBIConnector;
import com.example.nhom49_webbansanphamchamsoctoc.model.ProductImage;
import org.jdbi.v3.core.Jdbi;

import java.util.List;

/**
 * Lớp ProductImageDao.
 */
public class ProductImgDAO implements IDAO<ProductImage> {

    private final Jdbi jdbi;

    /**
     * Thực hiện product image dao.
     */
    public ProductImgDAO() {
        this.jdbi = JDBIConnector.getInstance();
    }

    
    @Override
    public List<ProductImage> findAll() {
        String sql = "SELECT * FROM product_images";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .map((rs, ctx) -> mapImage(rs))
                .list());
    }

    
    public List<ProductImage> findByProductId(int productId) {
        String sql = "SELECT * FROM product_images WHERE product_id = :productId ORDER BY is_primary DESC";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("productId", productId)
                .map((rs, ctx) -> mapImage(rs))
                .list());
    }

    
    public ProductImage findPrimaryByProductId(int productId) {
        String sql = "SELECT * FROM product_images WHERE product_id = :productId AND is_primary = true LIMIT 1";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("productId", productId)
                .map((rs, ctx) -> mapImage(rs))
                .findFirst()
                .orElse(null));
    }

    
    @Override
    public ProductImage findById(int id) {
        String sql = "SELECT * FROM product_images WHERE image_id = :id";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("id", id)
                .map((rs, ctx) -> mapImage(rs))
                .findFirst()
                .orElse(null));
    }

    
    @Override
    public int insert(ProductImage image) {
        String sql = "INSERT INTO product_images (product_id, image_url, is_primary) VALUES (:productId, :imageUrl, :isPrimary)";
        return jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("productId", image.getProductId())
                .bind("imageUrl", image.getImageUrl())
                .bind("isPrimary", image.isPrimary())
                .executeAndReturnGeneratedKeys("image_id")
                .mapTo(Integer.class)
                .findFirst()
                .orElse(-1));
    }

    
    @Override
    public boolean update(ProductImage image) {
        String sql = "UPDATE product_images SET image_url = :imageUrl, is_primary = :isPrimary WHERE image_id = :imageId";
        int rowsAffected = jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("imageUrl", image.getImageUrl())
                .bind("isPrimary", image.isPrimary())
                .bind("imageId", image.getImageId())
                .execute());
        return rowsAffected > 0;
    }

    
    @Override
    public boolean delete(int id) {
        String sql = "DELETE FROM product_images WHERE image_id = :imageId";
        int rowsAffected = jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("imageId", id)
                .execute());
        return rowsAffected > 0;
    }

    
    public boolean deleteByProductId(int productId) {
        String sql = "DELETE FROM product_images WHERE product_id = :productId";
        int rowsAffected = jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("productId", productId)
                .execute());
        return rowsAffected > 0;
    }

    
    public boolean setAllNonPrimary(int productId) {
        String sql = "UPDATE product_images SET is_primary = false WHERE product_id = :productId";
        int rowsAffected = jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("productId", productId)
                .execute());
        return rowsAffected > 0;
    }

    /**
     * Lấy primary image URLs cho danh sách product IDs.
     *
     * @param productIds Danh sách product IDs.
     * @return Map từ productId -> imageUrl.
     */
    public java.util.Map<Integer, String> getPrimaryImagesByProductIds(java.util.List<Integer> productIds) {
        if (productIds == null || productIds.isEmpty()) {
            return java.util.Collections.emptyMap();
        }
        String sql = "SELECT product_id, image_url FROM product_images WHERE product_id IN (<productIds>) AND is_primary = true";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bindList("productIds", productIds)
                .map((rs, ctx) -> java.util.Map.entry(rs.getInt("product_id"), rs.getString("image_url")))
                .list()
                .stream()
                .collect(java.util.stream.Collectors.toMap(
                        java.util.Map.Entry::getKey,
                        java.util.Map.Entry::getValue,
                        (v1, v2) -> v1)));
    }

    
    private ProductImage mapImage(java.sql.ResultSet rs) throws java.sql.SQLException {
        ProductImage image = new ProductImage();
        image.setImageId(rs.getInt("image_id"));
        image.setProductId(rs.getInt("product_id"));
        image.setImageUrl(rs.getString("image_url"));
        image.setPrimary(rs.getBoolean("is_primary"));
        image.setCreatedAt(rs.getTimestamp("created_at"));
        image.setUpdatedAt(rs.getTimestamp("updated_at"));
        return image;
    }
}

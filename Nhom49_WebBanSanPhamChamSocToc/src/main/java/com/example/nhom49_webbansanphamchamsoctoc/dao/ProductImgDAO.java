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

    /**
     * Tim all.
     *
     * @return Kết quả xử lý của phương thức.
     */
    @Override
    public List<ProductImage> findAll() {
        String sql = "SELECT * FROM product_images";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .map((rs, ctx) -> mapImage(rs))
                .list());
    }

    /**
     * Tim by product id.
     *
     * @param productId Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    public List<ProductImage> findByProductId(int productId) {
        String sql = "SELECT * FROM product_images WHERE product_id = :productId ORDER BY is_primary DESC";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("productId", productId)
                .map((rs, ctx) -> mapImage(rs))
                .list());
    }

    /**
     * Tim primary by product id.
     *
     * @param productId Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    public ProductImage findPrimaryByProductId(int productId) {
        String sql = "SELECT * FROM product_images WHERE product_id = :productId AND is_primary = true LIMIT 1";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("productId", productId)
                .map((rs, ctx) -> mapImage(rs))
                .findFirst()
                .orElse(null));
    }

    /**
     * Tim by id.
     *
     * @param id Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    @Override
    public ProductImage findById(int id) {
        String sql = "SELECT * FROM product_images WHERE image_id = :id";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("id", id)
                .map((rs, ctx) -> mapImage(rs))
                .findFirst()
                .orElse(null));
    }

    /**
     * Them .
     *
     * @param image Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
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

    /**
     * Cập nhật .
     *
     * @param image Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
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

    /**
     * Xóa .
     *
     * @param id Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    @Override
    public boolean delete(int id) {
        String sql = "DELETE FROM product_images WHERE image_id = :imageId";
        int rowsAffected = jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("imageId", id)
                .execute());
        return rowsAffected > 0;
    }

    /**
     * Xóa by product id.
     *
     * @param productId Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    public boolean deleteByProductId(int productId) {
        String sql = "DELETE FROM product_images WHERE product_id = :productId";
        int rowsAffected = jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("productId", productId)
                .execute());
        return rowsAffected > 0;
    }

    /**
     * Đặt tất cả ảnh của sản phẩm thành không phải primary.
     *
     * @param productId ID sản phẩm.
     * @return Kết quả xử lý của phương thức.
     */
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

    /**
     * Thực hiện map image.
     *
     * @param rs Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    private ProductImage mapImage(java.sql.ResultSet rs) throws java.sql.SQLException {
        ProductImage image = new ProductImage();
        image.setImageId(rs.getInt("image_id"));
        image.setProductId(rs.getInt("product_id"));
        image.setImageUrl(rs.getString("image_url"));
        image.setPrimary(rs.getBoolean("is_primary"));
        image.setCreatedAt(rs.getTimestamp("created_at"));
        return image;
    }
}

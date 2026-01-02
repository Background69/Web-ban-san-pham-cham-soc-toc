package com.example.nhom49_webbansanphamchamsoctoc.dao;

import com.example.nhom49_webbansanphamchamsoctoc.database.JDBIConnector;
import com.example.nhom49_webbansanphamchamsoctoc.model.ProductImage;
import org.jdbi.v3.core.Jdbi;

import java.util.List;

public class ProductImgDAO implements IDAO<ProductImage> {
    private final Jdbi jdbi;
    public ProductImgDAO() {
        this.jdbi = JDBIConnector.getInstance();
    }

    /**
     * Tìm kiếm một hình ảnh cụ thể theo ID
     */
    @Override
    public ProductImage findById(int id) {
        String sql = "SELECT * FROM product_images WHERE image_id = ?";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind(0, id)
                        .map((rs, ctx) -> mapImage(rs))
                        .findFirst()
                        .orElse(null)
        );
    }

    /**
     * Lấy danh sách tất cả hình ảnh có trong database
     */
    @Override
    public List<ProductImage> findAll() {
        String sql = "SELECT * FROM product_images";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .map((rs, ctx) -> mapImage(rs))
                        .list()
        );
    }

    /**
     * Lấy danh sách toàn bộ hình ảnh của một sản phẩm dựa trên product_id
     */
    public List<ProductImage> findByProductId(int productId) {
        String sql = "SELECT * FROM product_images WHERE product_id = ? ORDER BY is_primary DESC";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind(0, productId)
                        .map((rs, ctx) -> mapImage(rs))
                        .list()
        );
    }

    /**
     * Chỉ lấy duy nhất hình ảnh chính (Thumbnail) của sản phẩm
     * Dùng cho trang Danh sách sản phẩm (Shop/Home page) để hiển thị ảnh đại diện
     */
    public ProductImage findPrimaryByProductId(int productId) {
        String sql = "SELECT * FROM product_images WHERE product_id = ? AND is_primary = true LIMIT 1";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind(0, productId)
                        .map((rs, ctx) -> mapImage(rs))
                        .findFirst()
                        .orElse(null)
        );
    }

    /**
     * Thêm mới một hình ảnh vào database
     */
    @Override
    public int insert(ProductImage image) {
        String sql = "INSERT INTO product_images (product_id, image_url, is_primary) VALUES (?, ?, ?)";
        return jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind(0, image.getProductId())
                        .bind(1, image.getImageUrl())
                        .bind(2, image.isPrimary())
                        .executeAndReturnGeneratedKeys("image_id")
                        .mapTo(Integer.class)
                        .findFirst()
                        .orElse(-1)
        );
    }

    /**
     * Cập nhật thông tin hình ảnh (đường dẫn URL, trạng thái ảnh chính/phụ)
     */
    @Override
    public boolean update(ProductImage image) {
        String sql = "UPDATE product_images SET image_url = ?, is_primary = ? WHERE image_id = ?";
        int rowsAffected = jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind(0, image.getImageUrl())
                        .bind(1, image.isPrimary())
                        .bind(2, image.getImageId())
                        .execute()
        );
        return rowsAffected > 0;
    }

    /**
     * Xóa một hình ảnh cụ thể theo ID
     * Dùng trong trang quản lý (Admin) khi muốn xóa bớt ảnh của sản phẩm
     */
    @Override
    public boolean delete(int id) {
        String sql = "DELETE FROM product_images WHERE image_id = ?";
        int rowsAffected = jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind(0, id)
                        .execute()
        );
        return rowsAffected > 0;
    }

    /**
     * Xóa tất cả hình ảnh thuộc về một sản phẩm
     * Thường được gọi khi thực hiện xóa hoàn toàn một sản phẩm khỏi hệ thống
     */
    public boolean deleteByProductId(int productId) {
        String sql = "DELETE FROM product_images WHERE product_id = ?";
        int rowsAffected = jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind(0, productId)
                        .execute()
        );
        return rowsAffected > 0;
    }

    /**
     * Helper method để ánh xạ dữ liệu từ ResultSet sang đối tượng ProductImage
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
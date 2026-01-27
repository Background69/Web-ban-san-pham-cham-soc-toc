package com.example.nhom49_webbansanphamchamsoctoc.dao;

import com.example.nhom49_webbansanphamchamsoctoc.database.JDBIConnector;
import com.example.nhom49_webbansanphamchamsoctoc.model.ProductImage;
import org.jdbi.v3.core.Jdbi;

import java.util.List;

public class ProductImgDAO {

    private final Jdbi jdbi;

    public ProductImgDAO() {
        this.jdbi = JDBIConnector.getInstance();
    }

    public int insert(ProductImage img) {
        String sql = "INSERT INTO product_images (product_id, image_url, is_primary) VALUES (:productId, :imageUrl, :isPrimary)";
        return jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("productId", img.getProductId())
                .bind("imageUrl", img.getImageUrl())
                .bind("isPrimary", img.isPrimary() ? 1 : 0)
                .executeAndReturnGeneratedKeys("image_id")
                .mapTo(Integer.class)
                .findFirst()
                .orElse(-1));
    }

    public boolean deleteByProductId(int productId) {
        String sql = "DELETE FROM product_images WHERE product_id = :productId";
        int rows = jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("productId", productId)
                .execute());
        return rows > 0;
    }

    public boolean setAllNonPrimary(int productId) {
        String sql = "UPDATE product_images SET is_primary = 0 WHERE product_id = :productId";
        int rows = jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("productId", productId)
                .execute());
        return rows >= 0;
    }

    public List<ProductImage> findByProductId(int productId) {
        String sql = "SELECT image_id, product_id, image_url, is_primary FROM product_images " +
                "WHERE product_id = :productId ORDER BY is_primary DESC, image_id DESC";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("productId", productId)
                .map((rs, ctx) -> {
                    ProductImage img = new ProductImage();
                    img.setImageId(rs.getInt("image_id"));
                    img.setProductId(rs.getInt("product_id"));
                    img.setImageUrl(rs.getString("image_url"));
                    img.setPrimary(rs.getInt("is_primary") == 1);
                    return img;
                })
                .list());
    }

    public ProductImage findPrimaryByProductId(int productId) {
        String sql = "SELECT image_id, product_id, image_url, is_primary FROM product_images " +
                "WHERE product_id = :productId AND is_primary = 1 ORDER BY image_id DESC LIMIT 1";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("productId", productId)
                .map((rs, ctx) -> {
                    ProductImage img = new ProductImage();
                    img.setImageId(rs.getInt("image_id"));
                    img.setProductId(rs.getInt("product_id"));
                    img.setImageUrl(rs.getString("image_url"));
                    img.setPrimary(rs.getInt("is_primary") == 1);
                    return img;
                })
                .findFirst()
                .orElse(null));
    }
}

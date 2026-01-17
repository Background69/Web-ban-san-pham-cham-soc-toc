package com.example.nhom49_webbansanphamchamsoctoc.dao;

import com.example.nhom49_webbansanphamchamsoctoc.database.JDBIConnector;
import com.example.nhom49_webbansanphamchamsoctoc.model.ProductVariant;
import org.jdbi.v3.core.Jdbi;

import java.util.List;

/**
 * Lớp ProductVariantDao.
 */
public class ProductVariantDAO implements IDAO<ProductVariant> {

    private final Jdbi jdbi;

    /**
     * Thực hiện product variant dao.
     */
    public ProductVariantDAO() {
        this.jdbi = JDBIConnector.getInstance();
    }


    /**
     * Tim all.
     *
     * @return Kết quả xử lý của phương thức.
     */
    @Override
    public List<ProductVariant> findAll() {
        String sql = "SELECT * FROM product_variants";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .map((rs, ctx) -> mapVariant(rs))
                        .list()
        );
    }

    /**
     * Tim by product id.
     *
     * @param productId Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    public List<ProductVariant> findByProductId(int productId) {
        String sql = "SELECT * FROM product_variants WHERE product_id = :productId";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("productId", productId)
                        .map((rs, ctx) -> mapVariant(rs))
                        .list()
        );
    }

    /**
     * Tim default by product id.
     *
     * @param productId Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    public ProductVariant findDefaultByProductId(int productId) {
        String sql = "SELECT * FROM product_variants WHERE product_id = :productId AND is_default = true LIMIT 1";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("productId", productId)
                        .map((rs, ctx) -> mapVariant(rs))
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
    public ProductVariant findById(int id) {
        String sql = "SELECT * FROM product_variants WHERE variant_id = :id";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("id", id)
                        .map((rs, ctx) -> mapVariant(rs))
                        .findFirst()
                        .orElse(null)
        );
    }


    /**
     * Them .
     *
     * @param variant Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    @Override
    public int insert(ProductVariant variant) {
        String sql = "INSERT INTO product_variants (product_id, variant_name, original_price, sale_price, " +
                "discount_percent, stock_quantity, is_default) VALUES (:productId, :variantName, :originalPrice, :salePrice, :discountPercent, :stockQuantity, :isDefault)";
        return jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("productId", variant.getProductId())
                        .bind("variantName", variant.getVariantName())
                        .bind("originalPrice", variant.getOriginalPrice())
                        .bind("salePrice", variant.getSalePrice())
                        .bind("discountPercent", variant.getDiscountPercent())
                        .bind("stockQuantity", variant.getStockQuantity())
                        .bind("isDefault", variant.isDefault())
                        .executeAndReturnGeneratedKeys("variant_id")
                        .mapTo(Integer.class)
                        .findFirst()
                        .orElse(-1)
        );
    }

    /**
     * Cập nhật .
     *
     * @param variant Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    @Override
    public boolean update(ProductVariant variant) {
        String sql = "UPDATE product_variants SET variant_name = :variantName, original_price = :originalPrice, sale_price = :salePrice, " +
                "discount_percent = :discountPercent, stock_quantity = :stockQuantity, is_default = :isDefault WHERE variant_id = :variantId";
        int rowsAffected = jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("variantName", variant.getVariantName())
                        .bind("originalPrice", variant.getOriginalPrice())
                        .bind("salePrice", variant.getSalePrice())
                        .bind("discountPercent", variant.getDiscountPercent())
                        .bind("stockQuantity", variant.getStockQuantity())
                        .bind("isDefault", variant.isDefault())
                        .bind("variantId", variant.getVariantId())
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
        String sql = "DELETE FROM product_variants WHERE variant_id = :variantId";
        int rowsAffected = jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("variantId", id)
                        .execute()
        );
        return rowsAffected > 0;
    }

    /**
     * Xóa by product id.
     *
     * @param productId Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    public boolean deleteByProductId(int productId) {
        String sql = "DELETE FROM product_variants WHERE product_id = :productId";
        int rowsAffected = jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("productId", productId)
                        .execute()
        );
        return rowsAffected > 0;
    }

    /**
     * Thực hiện decrement stock.
     *
     * @param variantId Tham số đầu vào.
     * @param quantity Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    public boolean decrementStock(int variantId, int quantity) {
        if (quantity <= 0) {
            return true;
        }
        String sql = "UPDATE product_variants SET stock_quantity = stock_quantity - :quantity " +
                "WHERE variant_id = :variantId AND stock_quantity >= :quantity";
        int rowsAffected = jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("quantity", quantity)
                        .bind("variantId", variantId)
                        .execute()
        );
        return rowsAffected > 0;
    }

    /**
     * Thực hiện map variant.
     *
     * @param rs Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    private ProductVariant mapVariant(java.sql.ResultSet rs) throws java.sql.SQLException {
        ProductVariant variant = new ProductVariant();
        variant.setVariantId(rs.getInt("variant_id"));
        variant.setProductId(rs.getInt("product_id"));
        variant.setVariantName(rs.getString("variant_name"));
        variant.setOriginalPrice(rs.getBigDecimal("original_price"));
        variant.setSalePrice(rs.getBigDecimal("sale_price"));
        variant.setDiscountPercent(rs.getInt("discount_percent"));
        variant.setStockQuantity(rs.getInt("stock_quantity"));
        variant.setDefault(rs.getBoolean("is_default"));
        return variant;
    }
}

package com.example.nhom49_webbansanphamchamsoctoc.dao;

import com.example.nhom49_webbansanphamchamsoctoc.database.JDBIConnector;
import com.example.nhom49_webbansanphamchamsoctoc.model.ProductVariant;
import org.jdbi.v3.core.Jdbi;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class ProductVariantDAO implements IDAO<ProductVariant> {

    private final Jdbi jdbi;

    public ProductVariantDAO() {
        this.jdbi = JDBIConnector.getInstance();
    }


    @Override
    public List<ProductVariant> findAll() {
        String sql = "SELECT * FROM product_variants";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .map((rs, ctx) -> mapVariant(rs))
                        .list()
        );
    }

    public List<ProductVariant> findByProductId(int productId) {
        String sql = "SELECT * FROM product_variants WHERE product_id = :productId";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("productId", productId)
                        .map((rs, ctx) -> mapVariant(rs))
                        .list()
        );
    }

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

    public ProductVariant findDefault(int productId) {
        return findDefaultByProductId(productId);
    }

    public Map<Integer, Integer> getTotalStockByProductIds(List<Integer> productIds) {
        if (productIds == null || productIds.isEmpty()) {
            return Map.of();
        }
        String sql = "SELECT product_id, COALESCE(SUM(stock_quantity), 0) AS total_stock " +
                "FROM product_variants WHERE product_id IN (<productIds>) GROUP BY product_id";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bindList("productIds", productIds)
                        .map((rs, ctx) -> Map.entry(rs.getInt("product_id"), rs.getInt("total_stock")))
                        .list()
                        .stream()
                        .collect(Collectors.toMap(Map.Entry::getKey, Map.Entry::getValue))
        );
    }

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

    public boolean deleteByProductId(int productId) {
        String sql = "DELETE FROM product_variants WHERE product_id = :productId";
        int rowsAffected = jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("productId", productId)
                        .execute()
        );
        return rowsAffected > 0;
    }

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

    public boolean decreaseStock(int variantId, int quantity) {
        return decrementStock(variantId, quantity);
    }

    /**
     * Hoàn trả stock khi hủy đơn hàng
     */
    public boolean incrementStock(int variantId, int quantity) {
        if (quantity <= 0) {
            return true;
        }
        String sql = "UPDATE product_variants SET stock_quantity = stock_quantity + :quantity " +
                "WHERE variant_id = :variantId";
        int rowsAffected = jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("quantity", quantity)
                        .bind("variantId", variantId)
                        .execute()
        );
        return rowsAffected > 0;
    }

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
        variant.setCreatedAt(rs.getTimestamp("created_at"));
        variant.setUpdatedAt(rs.getTimestamp("updated_at"));
        return variant;
    }
}

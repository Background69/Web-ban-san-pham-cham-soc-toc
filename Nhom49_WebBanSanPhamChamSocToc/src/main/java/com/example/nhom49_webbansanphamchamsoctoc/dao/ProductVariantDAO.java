package com.example.nhom49_webbansanphamchamsoctoc.dao;

import com.example.nhom49_webbansanphamchamsoctoc.database.JDBIConnector;
import com.example.nhom49_webbansanphamchamsoctoc.model.ProductVariant;
import org.jdbi.v3.core.Jdbi;

import java.util.List;

public class ProductVariantDAO implements IDAO<ProductVariant> {

    private final Jdbi jdbi;

    public ProductVariantDAO() {
        this.jdbi = JDBIConnector.getInstance();
    }

    @Override
    public ProductVariant findById(int id) {
        String sql = """
            SELECT * FROM product_variants
            WHERE variant_id = :id
        """;

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("id", id)
                        .mapToBean(ProductVariant.class)
                        .findFirst()
                        .orElse(null)
        );
    }

    @Override
    public List<ProductVariant> findAll() {
        String sql = "SELECT * FROM product_variants";

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .mapToBean(ProductVariant.class)
                        .list()
        );
    }

    public List<ProductVariant> findByProductId(int productId) {
        String sql = """
            SELECT * FROM product_variants
            WHERE product_id = :productId
            ORDER BY is_default DESC
        """;

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("productId", productId)
                        .mapToBean(ProductVariant.class)
                        .list()
        );
    }

    @Override
    public int insert(ProductVariant variant) {
        String sql = """
            UPDATE product_variants
                    SET variant_name = :variantName,
                        original_price = :originalPrice,
                        sale_price = :salePrice,
                        discount_percent = :discountPercent,
                        stock_quantity = :stockQuantity,
                        is_default = :isDefault
                    WHERE variant_id = :variantId
        """;

        return jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bindBean(variant)
                        .execute()
        );
    }

    @Override
    public boolean update(ProductVariant variant) {
        String sql = """
            UPDATE product_variants
            SET variant_name = :variantName,
                original_price = :originalPrice,
                sale_price = :salePrice,
                discount_percent = :discountPercent,
                stock_quantity = :stockQuantity,
                is_default = :default
            WHERE variant_id = :variantId
        """;

        int rows = jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bindBean(variant)
                        .execute()
        );

        return rows > 0;
    }

    @Override
    public boolean delete(int id) {
        String sql = "DELETE FROM product_variants WHERE variant_id = :id";

        int rows = jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("id", id)
                        .execute()
        );

        return rows > 0;
    }
}

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
        return null;
    }

    @Override
    public List<ProductVariant> findAll() {
        return List.of();
    }

    @Override
    public int insert(ProductVariant entity) {
        return 0;
    }

    @Override
    public boolean update(ProductVariant entity) {
        return false;
    }

    @Override
    public boolean delete(int id) {
        return false;
    }
}

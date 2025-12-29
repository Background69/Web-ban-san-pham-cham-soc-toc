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


    @Override
    public ProductImage findById(int id) {
        return null;
    }

    @Override
    public List<ProductImage> findAll() {
        return List.of();
    }

    @Override
    public int insert(ProductImage entity) {
        return 0;
    }

    @Override
    public boolean update(ProductImage entity) {
        return false;
    }

    @Override
    public boolean delete(int id) {
        return false;
    }
}

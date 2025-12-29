package com.example.nhom49_webbansanphamchamsoctoc.dao;

import com.example.nhom49_webbansanphamchamsoctoc.database.JDBIConnector;
import com.example.nhom49_webbansanphamchamsoctoc.model.Product;
import org.jdbi.v3.core.Jdbi;

import java.util.List;

public class ProductDAO implements IDAO<Product>{

    private final Jdbi jdbi;

    public ProductDAO() {
        this.jdbi = JDBIConnector.getInstance();
    }

    @Override
    public Product findById(int id) {
        return null;
    }

    @Override
    public List<Product> findAll() {
        return List.of();
    }

    @Override
    public int insert(Product entity) {
        return 0;
    }

    @Override
    public boolean update(Product entity) {
        return false;
    }

    @Override
    public boolean delete(int id) {
        return false;
    }
}

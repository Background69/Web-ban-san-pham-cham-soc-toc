package com.example.nhom49_webbansanphamchamsoctoc.dao;

import com.example.nhom49_webbansanphamchamsoctoc.database.JDBIConnector;
import com.example.nhom49_webbansanphamchamsoctoc.model.Brand;
import org.jdbi.v3.core.Jdbi;

import java.util.List;

public class BrandDAO implements IDAO<Brand>{
    private final Jdbi jdbi;

    public BrandDAO() {
        this.jdbi = JDBIConnector.getInstance();
    }
    @Override
    public Brand findById(int id) {
        return null;
    }

    @Override
    public List<Brand> findAll() {
        return List.of();
    }

    @Override
    public int insert(Brand entity) {
        return 0;
    }

    @Override
    public boolean update(Brand entity) {
        return false;
    }

    @Override
    public boolean delete(int id) {
        return false;
    }
}

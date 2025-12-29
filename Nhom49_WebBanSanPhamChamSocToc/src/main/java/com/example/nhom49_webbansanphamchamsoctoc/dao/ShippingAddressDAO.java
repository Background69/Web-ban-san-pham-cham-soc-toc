package com.example.nhom49_webbansanphamchamsoctoc.dao;

import com.example.nhom49_webbansanphamchamsoctoc.database.JDBIConnector;
import com.example.nhom49_webbansanphamchamsoctoc.model.ShippingAddress;
import org.jdbi.v3.core.Jdbi;

import java.util.List;

public class ShippingAddressDAO implements IDAO<ShippingAddress>{
    private final Jdbi jdbi;
    public ShippingAddressDAO() {
        this.jdbi = JDBIConnector.getInstance();
    }

    @Override
    public ShippingAddress findById(int id) {
        return null;
    }

    @Override
    public List<ShippingAddress> findAll() {
        return List.of();
    }

    @Override
    public int insert(ShippingAddress entity) {
        return 0;
    }

    @Override
    public boolean update(ShippingAddress entity) {
        return false;
    }

    @Override
    public boolean delete(int id) {
        return false;
    }
}

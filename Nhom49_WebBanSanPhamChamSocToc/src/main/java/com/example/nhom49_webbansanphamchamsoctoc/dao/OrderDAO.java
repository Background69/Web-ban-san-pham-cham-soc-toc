package com.example.nhom49_webbansanphamchamsoctoc.dao;

import com.example.nhom49_webbansanphamchamsoctoc.database.JDBIConnector;
import com.example.nhom49_webbansanphamchamsoctoc.model.Order;
import org.jdbi.v3.core.Jdbi;

import java.util.List;

public class OrderDAO implements IDAO<Order>{
    private final Jdbi jdbi;
    public OrderDAO() {
        this.jdbi = JDBIConnector.getInstance();
    }
    @Override
    public Order findById(int id) {
        return null;
    }

    @Override
    public List<Order> findAll() {
        return List.of();
    }

    @Override
    public int insert(Order entity) {
        return 0;
    }

    @Override
    public boolean update(Order entity) {
        return false;
    }

    @Override
    public boolean delete(int id) {
        return false;
    }
}

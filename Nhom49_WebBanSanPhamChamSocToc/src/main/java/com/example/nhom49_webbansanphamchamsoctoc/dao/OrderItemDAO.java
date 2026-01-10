package com.example.nhom49_webbansanphamchamsoctoc.dao;

import com.example.nhom49_webbansanphamchamsoctoc.database.JDBIConnector;
import com.example.nhom49_webbansanphamchamsoctoc.model.OrderItem;

import java.util.List;

public class OrderItemDAO implements IDAO<OrderItem> {
    @Override
    public OrderItem findById(int id) {
        return null;
    }

    @Override
    public List<OrderItem> findAll() {
        return List.of();
    }

    @Override
    public int insert(OrderItem entity) {
        return 0;
    }

    @Override
    public boolean update(OrderItem entity) {
        return false;
    }

    @Override
    public boolean delete(int id) {
        return false;
    }
}
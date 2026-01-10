package com.example.nhom49_webbansanphamchamsoctoc.dao;

import com.example.nhom49_webbansanphamchamsoctoc.model.Promotion;

import java.util.List;

public class PromotionDAO implements IDAO<Promotion> {
    @Override
    public Promotion findById(int id) {
        return null;
    }

    @Override
    public List<Promotion> findAll() {
        return List.of();
    }

    @Override
    public int insert(Promotion entity) {
        return 0;
    }

    @Override
    public boolean update(Promotion entity) {
        return false;
    }

    @Override
    public boolean delete(int id) {
        return false;
    }
}

package com.example.nhom49_webbansanphamchamsoctoc.dao;

import com.example.nhom49_webbansanphamchamsoctoc.model.HairCondition;

import java.util.List;

public class HairConditionDAO implements IDAO<HairCondition> {

    @Override
    public HairCondition findById(int id) {
        return null;
    }

    @Override
    public List<HairCondition> findAll() {
        return List.of();
    }

    @Override
    public int insert(HairCondition entity) {
        return 0;
    }

    @Override
    public boolean update(HairCondition entity) {
        return false;
    }

    @Override
    public boolean delete(int id) {
        return false;
    }
}

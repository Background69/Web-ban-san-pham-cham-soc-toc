package com.example.nhom49_webbansanphamchamsoctoc.dao;

import com.example.nhom49_webbansanphamchamsoctoc.database.JDBIConnector;
import com.example.nhom49_webbansanphamchamsoctoc.model.Review;
import org.jdbi.v3.core.Jdbi;

import java.util.List;

public class ReviewDAO implements IDAO<Review> {
    private final Jdbi jdbi;

    public ReviewDAO() {
        this.jdbi = JDBIConnector.getInstance();
    }

    @Override
    public Review findById(int id) {
        return null;
    }

    @Override
    public List<Review> findAll() {
        return List.of();
    }

    @Override
    public int insert(Review entity) {
        return 0;
    }

    @Override
    public boolean update(Review entity) {
        return false;
    }

    @Override
    public boolean delete(int id) {
        return false;
    }
}

package com.example.nhom49_webbansanphamchamsoctoc.dao;

import java.util.List;

public interface IDAO<T> {
    // tìm theo id
    T findById(int id);
    //tìm tất cả danh sách
    List<T> findAll();
    // Nhập thêm mới
    int insert(T entity);
    // Cập nhật
    boolean update(T entity);
    // Xóa theo id
    boolean delete(int id);
}

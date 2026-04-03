package com.example.nhom49_webbansanphamchamsoctoc.services;

import com.example.nhom49_webbansanphamchamsoctoc.dao.BrandDAO;

import com.example.nhom49_webbansanphamchamsoctoc.model.Brand;

import java.util.List;

public class BrandService {

    private final BrandDAO brandDAO;

    public BrandService() {
        this.brandDAO = new BrandDAO();
    }


    /**
     * Lấy tất cả brands
     */
    public List<Brand> getAllBrands() {
        return brandDAO.findAll();
    }


    /**
     * Lấy brand theo slug
     */
    public Brand getBrandBySlug(String slug) {
        if (slug == null || slug.trim().isEmpty()) {
            return null;
        }
        return brandDAO.findBySlug(slug);
    }

    public List<String> getAllOrigins() {
        return brandDAO.findAllOrigins();
    }
}

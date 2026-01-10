package com.example.nhom49_webbansanphamchamsoctoc.services;

import com.example.nhom49_webbansanphamchamsoctoc.dao.BrandDAO;

import com.example.nhom49_webbansanphamchamsoctoc.model.Brand;
import com.example.nhom49_webbansanphamchamsoctoc.util.SlugUtil;

import java.util.List;

/**
 * Service class cho Brand business logic
 */
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
     * Lấy brand theo ID
     */
    public Brand getBrandById(int brandId) {
        return brandDAO.findById(brandId);
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

    /**
     * Tạo brand mới với auto-generate slug
     */
    public int createBrand(Brand brand) {
        if (brand == null || !isValidBrand(brand)) {
            return -1;
        }

        // Auto-generate slug từ tên brand
        if (brand.getBrandSlug() == null || brand.getBrandSlug().isEmpty()) {
            brand.setBrandSlug(SlugUtil.generateSlug(brand.getBrandName()));
        }

        // Kiểm tra slug đã tồn tại chưa
        if (isSlugExists(brand.getBrandSlug())) {
            // Thêm suffix để tạo slug unique
            brand.setBrandSlug(brand.getBrandSlug() + "-" + System.currentTimeMillis());
        }

        return brandDAO.insert(brand);
    }

    /**
     * Cập nhật brand, regenerate slug nếu tên thay đổi
     */
    public boolean updateBrand(Brand brand) {
        if (brand == null || brand.getBrandId() <= 0 || !isValidBrand(brand)) {
            return false;
        }

        Brand existingBrand = brandDAO.findById(brand.getBrandId());
        if (existingBrand == null) {
            return false;
        }

        // Regenerate slug nếu tên thay đổi
        if (!existingBrand.getBrandName().equals(brand.getBrandName())) {
            String newSlug = SlugUtil.generateSlug(brand.getBrandName());
            // Kiểm tra slug mới có trùng với brand khác không
            Brand brandWithSlug = brandDAO.findBySlug(newSlug);
            if (brandWithSlug != null && brandWithSlug.getBrandId() != brand.getBrandId()) {
                newSlug = newSlug + "-" + System.currentTimeMillis();
            }
            brand.setBrandSlug(newSlug);
        }

        return brandDAO.update(brand);
    }

    /**
     * Xóa brand
     */
    public boolean deleteBrand(int brandId) {
        return brandDAO.delete(brandId);
    }

    /**
     * Kiểm tra slug đã tồn tại chưa
     */
    public boolean isSlugExists(String slug) {
        return brandDAO.findBySlug(slug) != null;
    }

    /**
     * Validate brand data
     */
    private boolean isValidBrand(Brand brand) {
        return brand.getBrandName() != null &&
                !brand.getBrandName().trim().isEmpty() &&
                brand.getBrandName().length() <= 100;
    }

    /**
     * Lấy danh sách xuất xứ unique của tất cả brands
     */
    public List<String> getAllOrigins() {
        return brandDAO.findAllOrigins();
    }
}

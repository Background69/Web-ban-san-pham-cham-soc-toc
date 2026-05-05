package com.example.nhom49_webbansanphamchamsoctoc.services;

import com.example.nhom49_webbansanphamchamsoctoc.dao.CategoryDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.Category;
import com.example.nhom49_webbansanphamchamsoctoc.util.SlugUtil;

import java.util.List;

public class CategoryService {

    private final CategoryDAO categoryDAO;

    public CategoryService() {
        this.categoryDAO = new CategoryDAO();
    }

    public List<Category> getAllCategories() {
        return categoryDAO.findAll();
    }

    public Category getCategoryById(int categoryId) {
        return categoryDAO.findById(categoryId);
    }


    public int createCategory(Category category) {
        if (category == null || !isValidCategory(category)) {
            return -1;
        }

        // Auto-generate slug từ tên category
        if (category.getCategorySlug() == null || category.getCategorySlug().isEmpty()) {
            category.setCategorySlug(SlugUtil.generateSlug(category.getCategoryName()));
        }

        // Kiểm tra slug đã tồn tại chưa
        if (isSlugExists(category.getCategorySlug())) {
            // Thêm suffix để tạo slug unique
            category.setCategorySlug(category.getCategorySlug() + "-" + System.currentTimeMillis());
        }

        return categoryDAO.insert(category);
    }

    public boolean updateCategory(Category category) {
        if (category == null || category.getCategoryId() <= 0 || !isValidCategory(category)) {
            return false;
        }

        Category existingCategory = categoryDAO.findById(category.getCategoryId());
        if (existingCategory == null) {
            return false;
        }

        // Regenerate slug nếu tên thay đổi
        if (!existingCategory.getCategoryName().equals(category.getCategoryName())) {
            String newSlug = SlugUtil.generateSlug(category.getCategoryName());
            // Kiểm tra slug mới có trùng với category khác không
            Category categoryWithSlug = categoryDAO.findBySlug(newSlug);
            if (categoryWithSlug != null && categoryWithSlug.getCategoryId() != category.getCategoryId()) {
                newSlug = newSlug + "-" + System.currentTimeMillis();
            }
            category.setCategorySlug(newSlug);
        }

        return categoryDAO.update(category);
    }


    public boolean deleteCategory(int categoryId) {
        return categoryDAO.delete(categoryId);
    }


    public boolean isSlugExists(String slug) {
        return categoryDAO.findBySlug(slug) != null;
    }


    private boolean isValidCategory(Category category) {
        return category.getCategoryName() != null &&
                !category.getCategoryName().trim().isEmpty() &&
                category.getCategoryName().length() <= 100;
    }
}
